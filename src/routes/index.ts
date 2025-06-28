import { Router } from "express"
import { usersRoutes } from "./users-routes"
import { sessionsRoutes } from "./sessions-route"
import { patientsRoutes } from "./patients-route"
import { deliveryLogsRoutes } from "./delivery-logs-routes"

const routes = Router()

routes.use("/users", usersRoutes) //working
routes.use("/sessions", sessionsRoutes) //working

routes.use("/patients", patientsRoutes)

routes.use("/delivery-logs", deliveryLogsRoutes)

export { routes }
