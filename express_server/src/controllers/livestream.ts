import { eq, isNull } from "drizzle-orm";
import { DB } from "../db";
import {
    db_seller,
    db_livestream,
    db_livestream_product,
    db_product,
} from "../db/schema";
import { Request, Response } from "express";
import { AccessToken, RoomServiceClient } from "livekit-server-sdk";
import { v4 } from "uuid";
import { bucketName, s3 } from "../aws/s3";
import { PutObjectCommand } from "@aws-sdk/client-s3";

export const getLivestreams = async (req: Request, res: Response) => {
    try {
        const liveStreams = await DB.select({
            id: db_livestream.id,
            title: db_livestream.title,
            thumbnail: db_livestream.thumbnail,
            start_time: db_livestream.start_time,
            end_time: db_livestream.end_time,
            created_at: db_livestream.created_at,
            seller_username: db_seller.username,
            seller_profile_image: db_seller.profile_image,
        })
            .from(db_livestream)
            .where(isNull(db_livestream.end_time))
            .leftJoin(db_seller, eq(db_seller.id, db_livestream.seller_id));

        res.status(200).json(liveStreams);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when fetching livestreams",
        });
    }
};

export const createLivestream = async (req: Request, res: Response) => {
    try {
        const { title, seller_id, selected_product_ids } = req.body;

        let image_name;

        if (req.file) {
            image_name = v4();
            
            const command = new PutObjectCommand({
                Bucket: bucketName,
                Key: `${image_name}`,
                Body: req.file!.buffer,
                ContentType: req.file!.mimetype,
            });

            await s3.send(command);
        }

        const livestream = await DB.insert(db_livestream)
            .values({
                seller_id,
                title,
                start_time: new Date(
                    new Date().getTime() + 5.5 * 60 * 60 * 1000
                ),
                thumbnail: image_name ? `${process.env.CLOUDFRONT_URL}/${image_name}` :  null,
            })
            .returning();

        let selected_products_obj_array = [];

        if (selected_product_ids) {
            for (let id of selected_product_ids) {
                selected_products_obj_array.push({
                    livestream_id: livestream[0].id,
                    product_id: id,
                });
            }
    
            await DB.insert(db_livestream_product).values(
                selected_products_obj_array
            );
        }

        const roomID = livestream[0].id;

        const at = new AccessToken(
            process.env.LIVEKIT_API_KEY,
            process.env.LIVEKIT_API_SECRET,
            {
                identity: seller_id,
            }
        );
        at.addGrant({ roomJoin: true, room: roomID });

        res.status(200).json({
            livekit_token: at.toJwt(),
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when creating a livestream",
        });
    }
};

export const joinLivestream = async (req: Request, res: Response) => {
    try {
        const { livestream_id } = req.body;

        const livestream = await DB.select()
            .from(db_livestream)
            .where(eq(db_livestream.id, livestream_id));

        if (livestream[0].end_time != null) {
            return res.status(410).json();
        }

        const roomName = livestream[0].id;
        const buyer_id = (req as any).buyer_id;

        const at = new AccessToken(
            process.env.LIVEKIT_API_KEY,
            process.env.LIVEKIT_API_SECRET,
            {
                identity: buyer_id,
            }
        );
        at.addGrant({ roomJoin: true, room: roomName });

        res.status(200).json({
            id: livestream[0].id,
            livekit_token: at.toJwt(),
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when creating a livestream",
        });
    }
};

export const endLivestream = async (req: Request, res: Response) => {
    try {
        const { room_name } = req.body;

        const svc = new RoomServiceClient(
            "wss://first-app-jcllwzee.livekit.cloud",
            process.env.LIVEKIT_API_KEY,
            process.env.LIVEKIT_API_SECRET
        );

        await svc.deleteRoom(room_name);

        await DB.update(db_livestream)
            .set({
                end_time: new Date(new Date().getTime() + 5.5 * 60 * 60 * 1000),
            })
            .where(eq(db_livestream.id, room_name));

        res.status(200).json();
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when ending the livestream",
        });
    }
};

export const getLivestreamProducts = async (req: Request, res: Response) => {
    try {
        const { livestream_id } = req.params;

        const livestream_products = await DB.select({
            id: db_product.id,
            title: db_product.title,
            price: db_product.price,
            image_url: db_product.image_url,
            product_url: db_product.product_url,
        })
            .from(db_livestream_product)
            .leftJoin(
                db_product,
                eq(db_product.id, db_livestream_product.product_id)
            )
            .where(eq(db_livestream_product.livestream_id, livestream_id));

        res.status(200).json(livestream_products);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when getting livestream products",
        });
    }
};

export const uploadThumbnail = async (req: Request, res: Response) => {
    try {
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when uploading the thumbnail",
        });
    }
};
