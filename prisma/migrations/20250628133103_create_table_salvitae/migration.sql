-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('admin', 'secretary');

-- CreateEnum
CREATE TYPE "ConsultationType" AS ENUM ('first', 'followUp');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'secretary',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patients" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "birth_date" TEXT NOT NULL,
    "sexo" TEXT NOT NULL,
    "telefone" TEXT NOT NULL,
    "altura" TEXT NOT NULL,
    "peso" TEXT NOT NULL,
    "etnia" TEXT NOT NULL,
    "cidade" TEXT NOT NULL,
    "bairro" TEXT NOT NULL,
    "rua" TEXT NOT NULL,
    "num" TEXT NOT NULL,
    "profissao" TEXT NOT NULL,
    "estado_civil" TEXT NOT NULL,
    "adminId" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "consultations" (
    "id" TEXT NOT NULL,
    "patient_id" TEXT NOT NULL,
    "admin_id" TEXT NOT NULL,
    "type" "ConsultationType" NOT NULL DEFAULT 'first',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "consultations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "anamnese" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "HMA" TEXT NOT NULL,
    "Exf" TEXT NOT NULL,
    "Temp" TEXT NOT NULL,
    "AGI" TEXT NOT NULL,
    "Cd" TEXT NOT NULL,
    "FC" TEXT NOT NULL,
    "ACV" TEXT NOT NULL,
    "PA" TEXT NOT NULL,
    "Outros" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "anamnese_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hpp" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "patologias-previas" TEXT NOT NULL,
    "Medicacao" TEXT NOT NULL,
    "Alergia" TEXT NOT NULL,
    "Cirurgia" TEXT NOT NULL,
    "Tratamento" TEXT NOT NULL,
    "historico-familiar" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "hpp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exames" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "data_hora" TEXT NOT NULL,
    "Er(mi/mm3)" TEXT NOT NULL,
    "Hg(g%)" TEXT NOT NULL,
    "Ht(%)" TEXT NOT NULL,
    "Leu(/mm3)" TEXT NOT NULL,
    "Plq(/mm3)" TEXT NOT NULL,
    "PA(mmHg)" TEXT NOT NULL,
    "Obs" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "exames_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "patients_cpf_key" ON "patients"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "anamnese_consultation_id_key" ON "anamnese"("consultation_id");

-- CreateIndex
CREATE UNIQUE INDEX "hpp_consultation_id_key" ON "hpp"("consultation_id");

-- CreateIndex
CREATE UNIQUE INDEX "exames_consultation_id_key" ON "exames"("consultation_id");

-- AddForeignKey
ALTER TABLE "patients" ADD CONSTRAINT "patients_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consultations" ADD CONSTRAINT "consultations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consultations" ADD CONSTRAINT "consultations_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anamnese" ADD CONSTRAINT "anamnese_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hpp" ADD CONSTRAINT "hpp_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exames" ADD CONSTRAINT "exames_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
