import { Request, Response } from "express";
import { DB } from "../db";
import { db_buyer, db_follow } from "../db/schema";
import { eq, sql } from "drizzle-orm";

export const getUser = async (req: Request, res: Response) => {
    try {
        const user = await DB.select({
            buyer_id: db_buyer.id,
            seller_id: db_buyer.seller_id
        }).from(db_buyer).where(eq(db_buyer.id, (req as any).buyer_id));

        res.status(200).json({...user[0], token: (req as any).token});
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when fetching user",
        });
    }
};

export const getUserProfileData = async (req: Request, res: Response) => {
    try {
        const buyer_id = (req as any).buyer_id;
        const followers = await DB.select({ count: sql<number>`count(*)` })
            .from(db_follow)
            .where(eq(db_follow.following_id, buyer_id));
        const following = await DB.select({ count: sql<number>`count(*)` })
            .from(db_follow)
            .where(eq(db_follow.follower_id, buyer_id));

        const user = await DB.select({
            buyer_id: db_buyer.id,
            seller_id: db_buyer.seller_id,
            username: db_buyer.username,
        })
            .from(db_buyer)
            .where(eq(db_buyer.id, buyer_id));

        res.status(200).json({ ...user[0], followers: followers[0].count, following: following[0].count });
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when fetching user",
        });
    }
};

export const followUser = async (req: Request, res: Response) => {
    try {
        const { follower_id, following_id } = req.body;

        await DB.insert(db_follow).values({
            follower_id,
            following_id,
        });

        res.status(200).json();
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when adding a follower",
        });
    }
};

export const checkUniquePhone = async (req: Request, res: Response) => {
    try {
        const { phone } = req.body;

        const user = await DB.select()
            .from(db_buyer)
            .where(eq(db_buyer.phone, phone));

        if (user.length) {
            res.status(404).json();
        } else {
            res.status(200).json();
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when checking the phone number",
        });
    }
};

export const checkUniqueUsername = async (req: Request, res: Response) => {
    try {
        const { username } = req.body;

        const user = await DB.select()
            .from(db_buyer)
            .where(eq(db_buyer.username, username));

        if (user.length) {
            res.status(404).json();
        } else {
            res.status(200).json();
        }
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when checking the username",
        });
    }
};
