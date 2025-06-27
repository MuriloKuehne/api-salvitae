import { Request, Response } from "express"
import { hash } from "bcrypt"
import z from "zod"
import { prisma } from "@/database/prisma"
import { AppError } from "@/utils/AppError"

class UserController {
  async create(request: Request, response: Response) {
    const bodyschema = z.object({
      name: z.string().trim().min(2, "Name is required"),
      email: z.string().email("Invalid email format"),
      password: z.string().min(6, "Password must be at least 6 characters"),
    })

    const { name, email, password } = bodyschema.parse(request.body)

    const userWithSameEmail = await prisma.user.findFirst({
      where: {
        email,
      },
    })

    if (userWithSameEmail) {
      throw new AppError("Email already in use", 409)
    }

    const hashedPassword = await hash(password, 8)

    const user = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
      },
    })

    const { password: _, ...userWithoutPassword } = user

    return response.status(201).json(userWithoutPassword)
  }
}

export { UserController }
