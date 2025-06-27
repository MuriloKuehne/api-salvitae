import { Router } from "express"
import { usersRoutes } from "./users-routes"
import { sessionsRoutes } from "./sessions-route"
import { deliveriesRoutes } from "./deliveries-route"
import { deliveryLogsRoutes } from "./delivery-logs-routes"

const routes = Router()

routes.use("/users", usersRoutes)
routes.use("/sessions", sessionsRoutes)
routes.use("/deliveries", deliveriesRoutes)
routes.use("/delivery-logs", deliveryLogsRoutes)

export { routes }
