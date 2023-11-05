import { DB } from "../db";
import { db_buyer } from "../db/schema";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { eq } from "drizzle-orm";
import { Request, Response } from "express";
dotenv.config();

export const buyerSignup = async (req: Request, res: Response) => {
    try {
        const { first_name, last_name, email, username, phone, gender } =
            req.body;
        const inserted_user = await DB.insert(db_buyer)
            .values({
                first_name,
                last_name,
                phone,
                email,
                username,
                gender,
            })
            .returning();

        const token = jwt.sign(
            { buyer_id: inserted_user[0].id },
            process.env.JWT_SECRET as string,
            {
                expiresIn: "60d",
            }
        );

        res.status(200).json({
            buyer_id: inserted_user[0].id,
            seller_id: null,
            token,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Something went wrong during signup" });
    }
};

export const buyerSignin = async (req: Request, res: Response) => {
    try {
        const { phone } = req.body;

        const user = await DB.select()
            .from(db_buyer)
            .where(eq(db_buyer.phone, phone));

        const token = jwt.sign(
            { buyer_id: user[0].id, seller_id: user[0].seller_id },
            process.env.JWT_SECRET as string,
            {
                expiresIn: "60d",
            }
        );

        res.status(200).json({
            buyer_id: user[0].id,
            seller_id: user[0].seller_id,
            token,
        });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Something went wrong during signup" });
    }
};