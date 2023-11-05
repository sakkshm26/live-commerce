import dotenv from "dotenv";
import fs from "fs";
import multer from "multer";
import { S3Client } from "@aws-sdk/client-s3";
import { v4 } from "uuid";

dotenv.config();

const bucketName = process.env.AWS_BUCKET_NAME as string;
const region = process.env.AWS_BUCKET_REGION as string;
const accessKeyId = process.env.AWS_ACCESS_KEY as string;
const secretAccessKey = process.env.AWS_SECRET_KEY as string;

const s3 = new S3Client({
    credentials: {
        accessKeyId,
        secretAccessKey
    },
    region
});

// const upload = () =>
//     multer({
//         storage: multerS3({
//             s3,
//             bucket: bucketName as string,
//             contentType: multerS3.AUTO_CONTENT_TYPE,
//             metadata: function (req: any, file: any, cb: any) {
//                 cb(null, { fieldName: file.fieldname });
//             },
//             key: function (req: any, file: any, cb: any) {
//                 cb(null, `${v4()}.jpeg`);
//             },
//             acl: 'public-read'
//         }),
//     });

export { s3, bucketName, region, accessKeyId, secretAccessKey };
