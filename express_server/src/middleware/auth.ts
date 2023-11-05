import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { config } from "../config";

export const authMiddleware = async (
    req: any,
    res: any,
    next: NextFunction
) => {
    try {
        let token, decoded_data;
        token = req.headers.authorization?.split(" ")[1];
        decoded_data = jwt.verify(token as string, process.env.JWT_SECRET as any) as any;

        req.buyer_id = decoded_data.buyer_id;
        req.token = token;

        if (decoded_data.seller_id) {
          req.seller_id = decoded_data.seller_id;
        }
    
        next();
      } catch (error) {
        return res.status(401).json({ message: "Unauthorized" });
      }
};
