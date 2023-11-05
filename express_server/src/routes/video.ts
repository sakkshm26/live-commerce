import express from "express";
import { getVideos } from "../controllers";
import { authMiddleware } from "../middleware";

const router = express.Router();

router.get("/", getVideos);

export default router;