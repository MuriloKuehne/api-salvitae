import { Request, Response } from "express"
import { prisma } from "@/database/prisma"
import { z } from "zod"
import { AppError } from "@/utils/AppError"
import { compare } from "bcrypt"
import { authConfig } from "@/configs/auth"
import { sign } from "jsonwebtoken"

class SessionsController {
  async create(request: Request, response: Response) {
    const bodyschema = z.object({
      email: z.string().email("Invalid email format"),
      password: z.string().min(6, "Password must be at least 6 characters"),
    })

    const { email, password } = bodyschema.parse(request.body)

    const user = await prisma.user.findFirst({
      where: {
        email,
      },
    })

    if (!user) {
      throw new AppError("Invalid email or password", 404)
    }

    const passwordMatch = await compare(password, user.password)

    if (!passwordMatch) {
      throw new AppError("Invalid email or password", 404)
    }

    const { secret, expiresIn } = authConfig.jwt

    const token = sign({ role: user.role ?? "customer" }, secret, {
      subject: user.id,
      expiresIn,
    })

    const { password: hashedPassword, ...userWithoutPassword } = user

    return response.status(201).json({ token, user: userWithoutPassword })
  }
}

export { SessionsController }
