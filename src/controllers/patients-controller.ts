import { Request, Response } from "express"
import { prisma } from "@/database/prisma"
import z from "zod"

class PatientsController {
  async create(request: Request, response: Response) {
    const bodySchema = z.object({
      nome: z.string().min(1),
      cpf: z.string().min(11).max(14),
      birthDate: z.string(),
      sexo: z.string(),
      telefone: z.string(),
      altura: z.string(),
      peso: z.string(),
      etnia: z.string(),
      cidade: z.string(),
      bairro: z.string(),
      rua: z.string(),
      num: z.string(),
      profissao: z.string(),
      estadoCivil: z.string(),
    })

    const {
      nome,
      cpf,
      birthDate,
      sexo,
      telefone,
      altura,
      peso,
      etnia,
      cidade,
      bairro,
      rua,
      num,
      profissao,
      estadoCivil,
    } = bodySchema.parse(request.body)

    await prisma.patient.create({
      data: {
        nome,
        cpf,
        birthDate,
        sexo,
        telefone,
        altura,
        peso,
        etnia,
        cidade,
        bairro,
        rua,
        num,
        profissao,
        estadoCivil,
      },
    })

    return response
      .status(201)
      .json({ message: "Paciente criado com sucesso." })
  }

  async index(request: Request, response: Response) {
    const patients = await prisma.patient.findMany({})

    return response.json(patients)
  }

  async show(request: Request, response: Response) {
    const { id } = request.params

    const patient = await prisma.patient.findUnique({
      where: { id },
      include: {
        consultations: {
          include: {
            anamnese: true,
            hpp: true,
            exames: true,
          },
        },
      },
    })

    if (!patient) {
      return response.status(404).json({ error: "Paciente não encontrado." })
    }

    return response.json(patient)
  }

  async update(request: Request, response: Response) {
    const { id } = request.params

    const bodySchema = z.object({
      name: z.string().min(1).optional(),
      cpf: z.string().min(11).max(14).optional(),
      birthDate: z.string().optional(),
      doctor_id: z.string().uuid().optional(),
    })

    const data = bodySchema.parse(request.body)

    const updated = await prisma.patient.update({
      where: { id },
      data: {
        ...data,
      },
    })

    return response.json(updated)
  }

  async delete(request: Request, response: Response) {
    const { id } = request.params

    await prisma.patient.delete({
      where: { id },
    })

    return response.status(204).send()
  }
}

export { PatientsController }
