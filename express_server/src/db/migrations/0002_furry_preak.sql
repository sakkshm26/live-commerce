ALTER TABLE "videos" ALTER COLUMN "description" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "videos" ADD COLUMN "video_url" text NOT NULL;