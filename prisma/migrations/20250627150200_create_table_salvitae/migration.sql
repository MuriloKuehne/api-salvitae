/*
  Warnings:

  - The values [customer,sale] on the enum `UserRole` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the `deliveries` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `delivery_logs` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "AppointmentType" AS ENUM ('first', 'followUp');

-- AlterEnum
BEGIN;
CREATE TYPE "UserRole_new" AS ENUM ('doctor', 'secretary');
ALTER TABLE "users" ALTER COLUMN "role" DROP DEFAULT;
ALTER TABLE "users" ALTER COLUMN "role" TYPE "UserRole_new" USING ("role"::text::"UserRole_new");
ALTER TYPE "UserRole" RENAME TO "UserRole_old";
ALTER TYPE "UserRole_new" RENAME TO "UserRole";
DROP TYPE "UserRole_old";
ALTER TABLE "users" ALTER COLUMN "role" SET DEFAULT 'secretary';
COMMIT;

-- DropForeignKey
ALTER TABLE "deliveries" DROP CONSTRAINT "deliveries_user_id_fkey";

-- DropForeignKey
ALTER TABLE "delivery_logs" DROP CONSTRAINT "delivery_logs_delivery_id_fkey";

-- AlterTable
ALTER TABLE "users" ALTER COLUMN "role" SET DEFAULT 'secretary';

-- DropTable
DROP TABLE "deliveries";

-- DropTable
DROP TABLE "delivery_logs";

-- DropEnum
DROP TYPE "DeliveryStatus";

-- CreateTable
CREATE TABLE "patients" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "birth_date" TIMESTAMP(3) NOT NULL,
    "doctorId" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "consultations" (
    "id" TEXT NOT NULL,
    "patient_id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "type" "AppointmentType" NOT NULL DEFAULT 'first',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "consultations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "anamnese" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "anamnese_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hpp" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "hpp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dados" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "dados_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exames" (
    "id" TEXT NOT NULL,
    "consultation_id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "exames_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "patients_cpf_key" ON "patients"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "anamnese_consultation_id_key" ON "anamnese"("consultation_id");

-- CreateIndex
CREATE UNIQUE INDEX "hpp_consultation_id_key" ON "hpp"("consultation_id");

-- CreateIndex
CREATE UNIQUE INDEX "dados_consultation_id_key" ON "dados"("consultation_id");

-- CreateIndex
CREATE UNIQUE INDEX "exames_consultation_id_key" ON "exames"("consultation_id");

-- AddForeignKey
ALTER TABLE "patients" ADD CONSTRAINT "patients_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consultations" ADD CONSTRAINT "consultations_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consultations" ADD CONSTRAINT "consultations_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "anamnese" ADD CONSTRAINT "anamnese_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hpp" ADD CONSTRAINT "hpp_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dados" ADD CONSTRAINT "dados_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exames" ADD CONSTRAINT "exames_consultation_id_fkey" FOREIGN KEY ("consultation_id") REFERENCES "consultations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
