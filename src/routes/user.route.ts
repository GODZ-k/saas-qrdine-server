import { Router } from "express";
import { requireUser } from "../middleware/user.middleware.js";
import mainController from "../controllers/user.controller.js";
const router:Router = Router()

router.route('/').get(requireUser,mainController)

export default router