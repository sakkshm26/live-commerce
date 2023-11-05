import express from "express";
import { getUser, checkUniquePhone, followUser, getUserProfileData, checkUniqueUsername } from "../controllers";
import { authMiddleware } from "../middleware";

var router = express.Router();

router.get('/', authMiddleware, getUser);
router.get('/profile', authMiddleware, getUserProfileData);
router.post('/check/phone', checkUniquePhone);
router.post('/check/username', checkUniqueUsername);
router.get('/follow', authMiddleware, followUser);

export default router