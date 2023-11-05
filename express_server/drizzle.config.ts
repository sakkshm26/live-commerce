import type { Config } from "drizzle-kit";
import * as dotenv from "dotenv";
import { config } from "./src/config";
dotenv.config();

export default {
	driver: "pg",
	dbCredentials: {
		connectionString: config.database_uri,
	},
	schema: "./src/db/schema.ts",
	out: "./src/db/migrations",
} satisfies Config;
