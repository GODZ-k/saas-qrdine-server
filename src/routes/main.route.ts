import { Router } from "express";
import mainController from "../controllers/main.controller.js";
const router:Router = Router()

router.route('/').get(mainController)

export default router