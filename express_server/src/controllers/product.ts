import { Request, Response } from "express";
import { DB } from "../db";
import { db_product } from "../db/schema";
import { eq, sql } from "drizzle-orm";
import { PutObjectCommand, DeleteObjectCommand } from "@aws-sdk/client-s3";
import { bucketName, s3 } from "../aws/s3";
import { v4 } from "uuid";
import dotenv from "dotenv";
dotenv.config();

export const createProduct = async (req: Request, res: Response) => {
    try {
        const image_name = v4();

        const command = new PutObjectCommand({
            Bucket: bucketName,
            Key: `${image_name}`,
            Body: req.file!.buffer,
            ContentType: req.file!.mimetype,
        });

        await s3.send(command);

        const { title, description, price, product_url } = req.body;
        const image_url = `${process.env.CLOUDFRONT_URL}/${image_name}`;

        const product = await DB.insert(db_product)
            .values({
                title,
                description,
                price,
                image_url,
                product_url,
                seller_id: (req as any).seller_id,
            })
            .returning({
                id: db_product.id,
                title: db_product.title,
                description: db_product.description,
                price: db_product.price,
                image_url: db_product.image_url,
                product_url: db_product.product_url,
                created_at: db_product.created_at,
            });

        res.status(200).json(product[0]);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when creating a product",
        });
    }
};

export const getProducts = async (req: Request, res: Response) => {
    try {
        const seller_id = (req as any).seller_id;

        let products: any = await DB.select({
            id: db_product.id,
            title: db_product.title,
            description: db_product.description,
            price: db_product.price,
            image_url: db_product.image_url,
            created_at: db_product.created_at,
            product_url: db_product.product_url,
        })
            .from(db_product)
            .where(eq(db_product.seller_id, seller_id));

        res.status(200).json(products);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when getting products",
        });
    }
};

export const getProduct = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;

        let product = await DB.select({
            id: db_product.id,
            title: db_product.title,
            description: db_product.description,
            price: db_product.price,
            image_url: db_product.image_url,
            created_at: db_product.created_at,
            product_url: db_product.product_url,
        })
            .from(db_product)
            .where(eq(db_product.id, id));

        res.status(200).json(product[0]);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when getting products",
        });
    }
};

export const updateProduct = async (req: Request, res: Response) => {
    try {
        const { title, description, price, product_url } = req.body;

        const { id } = req.params;

        let new_image_name;

        if (req.file) {
            const product = await DB.select({ image_url: db_product.image_url })
                .from(db_product)
                .where(eq(db_product.id, id));
            const image_url = product[0].image_url;

            const image_name = image_url.split("cloudfront.net/")[1];

            const delete_command = new DeleteObjectCommand({
                Bucket: bucketName,
                Key: `${image_name}`,
            });

            await s3.send(delete_command);

            new_image_name = v4();

            const create_command = new PutObjectCommand({
                Bucket: bucketName,
                Key: `${new_image_name}`,
                Body: req.file.buffer,
                ContentType: req.file.mimetype,
            });

            await s3.send(create_command);
        }

        const image_url = `${process.env.CLOUDFRONT_URL}/${new_image_name}`;

        let query = sql`UPDATE products SET `;

        if (!title && !description && !price && !product_url) {
            return res.status(400).json();
        } else {
            if (title)
                query.append(
                    sql`title = CASE WHEN ${title} IS DISTINCT FROM title THEN ${title} ELSE title END`
                );
            if (description)
                query.append(
                    sql`,description = CASE WHEN ${description} IS DISTINCT FROM description THEN ${description} ELSE description END`
                );
            if (price)
                query.append(
                    sql`,price = CASE WHEN ${price} IS DISTINCT FROM price THEN ${price} ELSE price END`
                );
            if (new_image_name) query.append(sql`,image_url = ${image_url}`);
            if (product_url)
                query.append(
                    sql`,product_url = CASE WHEN ${product_url} IS DISTINCT FROM product_url THEN ${product_url} ELSE product_url END`
                );
        }

        query.append(
            sql` WHERE id = ${id} RETURNING id, title, description, price, image_url, created_at, product_url;`
        );

        // console.log(query.toQuery);

        const product = await DB.execute(query);

        res.status(200).json(product.rows[0]);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when updating the product",
        });
    }
};

export const deleteProduct = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const product = await DB.delete(db_product)
            .where(eq(db_product.id, id))
            .returning();

        const image_url = product[0].image_url;

        const image_name = image_url.split("cloudfront.net/")[1];

        const delete_command = new DeleteObjectCommand({
            Bucket: bucketName,
            Key: `${image_name}`,
        });

        await s3.send(delete_command);

        if (product.length) {
            res.status(200).json();
        } else {
            res.status(404).json();
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when deleting the product",
        });
    }
};
