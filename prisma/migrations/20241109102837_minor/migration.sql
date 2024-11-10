/*
  Warnings:

  - You are about to drop the column `AvatarUrl` on the `ExternalAccount` table. All the data in the column will be lost.
  - You are about to drop the column `GivenName` on the `ExternalAccount` table. All the data in the column will be lost.
  - You are about to drop the column `PictureUrl` on the `ExternalAccount` table. All the data in the column will be lost.
  - You are about to drop the column `Username` on the `ExternalAccount` table. All the data in the column will be lost.
  - You are about to drop the column `VerificationExpireAt` on the `ExternalAccount` table. All the data in the column will be lost.
  - You are about to drop the column `emailAddressId` on the `ExternalAccount` table. All the data in the column will be lost.
  - You are about to drop the column `GithubId` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `GoogleId` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `ImageUrl` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `PasswordEnabled` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `profileImageUrl` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `BackupCode` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UserEvent` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[EmailAddressId]` on the table `ExternalAccount` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "BackupCode" DROP CONSTRAINT "BackupCode_UserId_fkey";

-- DropForeignKey
ALTER TABLE "ExternalAccount" DROP CONSTRAINT "ExternalAccount_emailAddressId_fkey";

-- DropForeignKey
ALTER TABLE "UserEvent" DROP CONSTRAINT "UserEvent_UserId_fkey";

-- DropIndex
DROP INDEX "ExternalAccount_Username_key";

-- DropIndex
DROP INDEX "ExternalAccount_emailAddressId_key";

-- DropIndex
DROP INDEX "User_GithubId_key";

-- DropIndex
DROP INDEX "User_GoogleId_key";

-- AlterTable
ALTER TABLE "ExternalAccount" DROP COLUMN "AvatarUrl",
DROP COLUMN "GivenName",
DROP COLUMN "PictureUrl",
DROP COLUMN "Username",
DROP COLUMN "VerificationExpireAt",
DROP COLUMN "emailAddressId",
ADD COLUMN     "EmailAddressId" TEXT;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "GithubId",
DROP COLUMN "GoogleId",
DROP COLUMN "ImageUrl",
DROP COLUMN "PasswordEnabled",
DROP COLUMN "profileImageUrl",
ADD COLUMN     "Avatar" TEXT;

-- DropTable
DROP TABLE "BackupCode";

-- DropTable
DROP TABLE "UserEvent";

-- CreateIndex
CREATE UNIQUE INDEX "ExternalAccount_EmailAddressId_key" ON "ExternalAccount"("EmailAddressId");

-- AddForeignKey
ALTER TABLE "ExternalAccount" ADD CONSTRAINT "ExternalAccount_EmailAddressId_fkey" FOREIGN KEY ("EmailAddressId") REFERENCES "EmailAddress"("Id") ON DELETE SET NULL ON UPDATE CASCADE;
