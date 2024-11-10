/*
  Warnings:

  - You are about to drop the `ExternalAccount` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "ExternalAccount" DROP CONSTRAINT "ExternalAccount_EmailAddressId_fkey";

-- DropForeignKey
ALTER TABLE "ExternalAccount" DROP CONSTRAINT "ExternalAccount_UserId_fkey";

-- DropTable
DROP TABLE "ExternalAccount";
