import Express, { Request } from "express";

declare global {
	namespace Express {
		interface Request {
			user: { id: number; username: string } | {};
		}
	}
}
