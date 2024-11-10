/*
  Warnings:

  - Added the required column `Verification` to the `EmailAddress` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "EmailAddress" ADD COLUMN     "Verification" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "isActive" SET DEFAULT true;
