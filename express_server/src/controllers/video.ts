import { Request, Response } from "express";
import { DB } from "../db";
import { db_video, db_seller } from "../db/schema";
import { eq } from "drizzle-orm";

export const getVideos = async (req: Request, res: Response) => {
    try {
        const videos = await DB.select({
            id: db_video.id,
            description: db_video.description,
            video_url: db_video.video_url,
            seller_name: db_seller.name,
            seller_profile_image: db_seller.profile_image,
        })
            .from(db_video)
            .leftJoin(db_seller, eq(db_seller.id, db_video.seller_id));

        res.status(200).json(videos);
    } catch (err) {
        console.log(err);
        res.status(500).json({
            message: "Something went wrong when fetching videos",
        });
    }
};
