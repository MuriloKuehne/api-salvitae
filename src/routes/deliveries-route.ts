import { Router } from "express"
import { ensureAuthenticated } from "@/middlewares/ensure-authenticated"
import { DeliveriesController } from "@/controllers/deliveries-controller"
import { DeliveriesStatusController } from "@/controllers/deliveries-status-controller"
import { verifyUserAuthorization } from "@/middlewares/verifyUserAuthorization"

const deliveriesRoutes = Router()
const deliveriesController = new DeliveriesController()
const deliveriesStatusController = new DeliveriesStatusController()

deliveriesRoutes.use(ensureAuthenticated, verifyUserAuthorization(["sale"]))
deliveriesRoutes.get("/", ensureAuthenticated, deliveriesController.index)
deliveriesRoutes.post("/", ensureAuthenticated, deliveriesController.create)
deliveriesRoutes.patch("/:id/status", deliveriesStatusController.update)

export { deliveriesRoutes }
