import { Router } from "express";
import { requireAdmin } from "../middleware/admin.middleware.js";
import mainController from "../controllers/admin.controller.js";
const router:Router = Router()

router.route('/').get(requireAdmin , mainController)

export default router