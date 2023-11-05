import express from "express";
import {
    getLivestreams,
    createLivestream,
    uploadThumbnail,
    joinLivestream,
    endLivestream,
    getLivestreamProducts
} from "../controllers";
import multer from "multer";
import { authMiddleware } from "../middleware";
const storage = multer.memoryStorage();
const upload = multer({ storage });

var router = express.Router();

router.get("/get-list", getLivestreams);
router.post("/upload-thumbnail", authMiddleware, upload.single("image"), uploadThumbnail);
router.post("/create", authMiddleware, upload.single("image"), createLivestream);
router.post("/join", authMiddleware, joinLivestream);
router.get("/:livestream_id/products", authMiddleware, getLivestreamProducts);
router.post("/end", authMiddleware, endLivestream);

export default router;
