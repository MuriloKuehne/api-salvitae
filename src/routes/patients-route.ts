import { Router } from "express"
import { ensureAuthenticated } from "@/middlewares/ensure-authenticated"
import { PatientsController } from "@/controllers/patients-controller"
import { DeliveriesStatusController } from "@/controllers/deliveries-status-controller"
import { verifyUserAuthorization } from "@/middlewares/verifyUserAuthorization"

const patientsRoutes = Router()
const patientsController = new PatientsController()
const deliveriesStatusController = new DeliveriesStatusController()

patientsRoutes.use("/", ensureAuthenticated, verifyUserAuthorization(["admin"]))

patientsRoutes.post(
  "/",
  ensureAuthenticated,
  verifyUserAuthorization(["admin", "secretary"]),
  patientsController.create
)
patientsRoutes.get("/:id/show", ensureAuthenticated, patientsController.show)

patientsRoutes.put("/:id", ensureAuthenticated, patientsController.update)
patientsRoutes.delete("/:id", ensureAuthenticated, patientsController.delete)

patientsRoutes.get("/", ensureAuthenticated, patientsController.index)
export { patientsRoutes }
