import express from "express";
import { createProduct, deleteProduct, getProducts, getProduct, updateProduct } from "../controllers";
import { authMiddleware } from "../middleware";
import multer from "multer";

const storage = multer.memoryStorage();
const upload = multer({ storage });

var router = express.Router();

router.get('/', authMiddleware, getProducts);
router.get('/:id', authMiddleware, getProduct);
router.post('/', authMiddleware, upload.single("image"), createProduct);
router.put('/:id', authMiddleware, upload.single("image"), updateProduct);
router.delete('/:id', authMiddleware, deleteProduct);
export default router