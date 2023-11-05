import dotenv from "dotenv";
dotenv.config();

export const config = {
	database_uri: `postgres://postgres:${process.env.DB_PASS}@${process.env.DB_URI}:5432/postgres`,
	// database_uri: `postgres://postgres:psql1234@localhost:5432/test`,
	jwt_secret: process.env.JWT_SECRET || "",
};
