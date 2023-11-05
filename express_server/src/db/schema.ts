import { relations, sql } from "drizzle-orm";
import {
    boolean,
    integer,
    json,
    numeric,
    pgTable,
    text,
    timestamp,
    varchar,
    uuid,
    primaryKey,
    decimal,
} from "drizzle-orm/pg-core";

// Declare the `buyers` table.
const db_buyer = pgTable("buyers", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    seller_id: uuid("fk_seller_id").references(() => db_seller.id),
    username: text("username").notNull().unique(),
    email: text("email").notNull().unique(),
    phone: varchar("phone", { length: 20 }).notNull().unique(),
    first_name: text("first_name").notNull(),
    last_name: text("last_name").notNull(),
    profile_image: text("profile_image"),
    gender: text("gender", {
        enum: ["MALE", "FEMALE", "NON-BINARY"],
    }).notNull(),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

// Declare the `seller` table.
const db_seller = pgTable("sellers", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    username: text("username"),
    name: text("name"),
    description: text("description"),
    profile_image: text("profile_image"),
    verified: boolean("verified").notNull(),
    // pickup_address: text("pickup_address"),
    // badges: json("badges"),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

const db_follow = pgTable(
    "follows",
    {
        following_id: uuid("fk_following_id").references(() => db_buyer.id),
        follower_id: uuid("fk_follower_id").references(() => db_buyer.id),
    },
    (table) => ({
        cpk: primaryKey(table.following_id, table.follower_id),
    })
);

// Declare the `products` table.
const db_product = pgTable("products", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    seller_id: uuid("fk_seller_id")
        .references(() => db_seller.id)
        .notNull(),
    title: text("title").notNull(),
    description: text("description"),
    price: decimal("price", { precision: 12, scale: 2 }).notNull(),
    image_url: text("image_url").notNull(),
    product_url: text("product_url"),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

// Declare the `orders` table.
const db_order = pgTable("orders", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    buyer_id: uuid("fk_buyer_id").references(() => db_buyer.id),
    logistics_key: text("logistics_key"),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

const db_order_item = pgTable("order_items", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    order_id: uuid("fk_order_id").references(() => db_order.id),
    product_id: uuid("fk_product_id").references(() => db_product.id),
    quantity: integer("quantity").notNull(),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

const db_livestream = pgTable("livestreams", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    seller_id: uuid("fk_seller_id")
        .references(() => db_seller.id)
        .notNull(),
    title: text("title"),
    thumbnail: text("thumbnail"),
    start_time: timestamp("start_time", { withTimezone: true }),
    end_time: timestamp("end_time", { withTimezone: true }),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

const db_video = pgTable("videos", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    seller_id: uuid("fk_seller_id")
        .references(() => db_seller.id)
        .notNull(),
    video_url: text("video_url").notNull(),
    description: text("description").notNull(),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
})

const db_file = pgTable("files", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    file_url: text("file_url").notNull(),
    bucket_name: text("bucket_name"),
    key: text("key"),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at").defaultNow().notNull(),
});

const db_livestream_product = pgTable("livestream_products", {
    id: uuid("id")
        .default(sql`gen_random_uuid()`)
        .primaryKey(),
    livestream_id: uuid("fk_livestream_id")
        .references(() => db_livestream.id)
        .notNull(),
    product_id: uuid("fk_product_id")
        .references(() => db_product.id, {
            onDelete: "set null",
            onUpdate: 'set null'
        }),
});

export {
    db_buyer,
    db_seller,
    db_follow,
    db_product,
    db_order,
    db_order_item,
    db_livestream,
    db_file,
    db_livestream_product,
    db_video
};
