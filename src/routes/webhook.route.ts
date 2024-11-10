import { Router } from "express";
import { clerkWebhook } from "../webhooks/clerk.js";
import { verifyClerkWebhook } from "../middleware/clerk.webhook.middleware.js";
const router:Router = Router()

router.route('/clerk').post(verifyClerkWebhook ,clerkWebhook)

export default router