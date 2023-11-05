import "dotenv/config";
import express, { Router } from "express";
import http from "http";
import { authRouter, livestreamRouter, userRouter, productRouter, videoRouter } from "./routes";
import cors from "cors";
import bodyParser from "body-parser";
import { types } from "pg";

types.setTypeParser(1700, function(val) {
    return parseFloat(val);
});

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());

const server = http.createServer(app);

const port = process.env.PORT;

app.use("/auth", authRouter);
app.use("/livestream", livestreamRouter);
app.use("/user", userRouter);
app.use("/product", productRouter);
app.use("/video", videoRouter);
app.get("/health-check", (req, res) => {
    res.send("server running")
})

server.listen(port, () => {
    console.log(`> server running on port ${port} ⚡️`);
});
