import express from "express";
import { buyerSignin, buyerSignup, checkUniquePhone } from "../controllers";

var router = express.Router()

router.post('/login', buyerSignin);
router.post('/signup', buyerSignup);

export default router