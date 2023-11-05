import { drizzle } from "drizzle-orm/postgres-js";
import { migrate } from "drizzle-orm/postgres-js/migrator";
import postgres from "postgres";
import { config } from "../config";

const PostgresConnection = postgres(config.database_uri);

export const main = async () => {
    try {
        await migrate(drizzle(PostgresConnection), {
            migrationsFolder: "./src/db/migrations",
        });
        console.log("Migrations complete!");
        await PostgresConnection.end();
        process.exit(0);
    } catch (err) {
        console.error("Migrations failed!", err);
        await PostgresConnection.end();
        process.exit(1);
    }
};

main();
