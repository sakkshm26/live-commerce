import { drizzle } from "drizzle-orm/node-postgres";
import { config } from "../config";
import * as schema from "./schema";
import { Client } from "pg";

export const client = new Client({
    connectionString: config.database_uri,
});

client.connect();
export const DB = drizzle(client as any, { schema });
