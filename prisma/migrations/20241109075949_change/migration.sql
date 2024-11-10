/*
  Warnings:

  - You are about to drop the column `Email` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `Name` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `Phone` on the `User` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[EmailAddress]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[GoogleId]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[GithubId]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `EmailAddress` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "User_Email_key";

-- DropIndex
DROP INDEX "User_Phone_key";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "Email",
DROP COLUMN "Name",
DROP COLUMN "Phone",
ADD COLUMN     "BackupCodeEnabled" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "EmailAddress" TEXT NOT NULL,
ADD COLUMN     "First_name" VARCHAR(200),
ADD COLUMN     "GithubId" TEXT,
ADD COLUMN     "GoogleId" TEXT,
ADD COLUMN     "ImageUrl" TEXT,
ADD COLUMN     "LastActiveAt" TIMESTAMP(3),
ADD COLUMN     "LastSignInAt" TIMESTAMP(3),
ADD COLUMN     "Last_name" VARCHAR(200),
ADD COLUMN     "Locked" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "MfaEnabled" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "PasswordEnabled" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "TwoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isBanned" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "profileImageUrl" TEXT,
ALTER COLUMN "Username" SET DATA TYPE TEXT;

-- CreateTable
CREATE TABLE "PhoneNumber" (
    "Id" TEXT NOT NULL,
    "UserId" TEXT NOT NULL,
    "PhoneNumber" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PhoneNumber_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "EmailAddress" (
    "Id" TEXT NOT NULL,
    "EmailAddress" TEXT NOT NULL,
    "UserId" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmailAddress_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "ExternalAccount" (
    "Id" TEXT NOT NULL,
    "UserId" TEXT NOT NULL,
    "Provider" TEXT NOT NULL,
    "ProviderUserId" TEXT NOT NULL,
    "EmailAddress" TEXT,
    "GivenName" TEXT,
    "Username" TEXT,
    "PictureUrl" TEXT,
    "AvatarUrl" TEXT,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,
    "VerificationStatus" TEXT,
    "VerificationExpireAt" TIMESTAMP(3),
    "emailAddressId" TEXT,

    CONSTRAINT "ExternalAccount_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "UserEvent" (
    "Id" TEXT NOT NULL,
    "UserId" TEXT NOT NULL,
    "EventType" TEXT NOT NULL,
    "ClientIp" TEXT NOT NULL,
    "UserAgent" TEXT NOT NULL,
    "Timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserEvent_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "BackupCode" (
    "Id" TEXT NOT NULL,
    "UserId" TEXT NOT NULL,
    "BackupCode" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "Used" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "BackupCode_pkey" PRIMARY KEY ("Id")
);

-- CreateIndex
CREATE UNIQUE INDEX "EmailAddress_EmailAddress_key" ON "EmailAddress"("EmailAddress");

-- CreateIndex
CREATE UNIQUE INDEX "ExternalAccount_Username_key" ON "ExternalAccount"("Username");

-- CreateIndex
CREATE UNIQUE INDEX "ExternalAccount_emailAddressId_key" ON "ExternalAccount"("emailAddressId");

-- CreateIndex
CREATE UNIQUE INDEX "User_EmailAddress_key" ON "User"("EmailAddress");

-- CreateIndex
CREATE UNIQUE INDEX "User_GoogleId_key" ON "User"("GoogleId");

-- CreateIndex
CREATE UNIQUE INDEX "User_GithubId_key" ON "User"("GithubId");

-- AddForeignKey
ALTER TABLE "PhoneNumber" ADD CONSTRAINT "PhoneNumber_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "User"("Id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmailAddress" ADD CONSTRAINT "EmailAddress_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "User"("Id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExternalAccount" ADD CONSTRAINT "ExternalAccount_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "User"("Id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExternalAccount" ADD CONSTRAINT "ExternalAccount_emailAddressId_fkey" FOREIGN KEY ("emailAddressId") REFERENCES "EmailAddress"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserEvent" ADD CONSTRAINT "UserEvent_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "User"("Id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BackupCode" ADD CONSTRAINT "BackupCode_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "User"("Id") ON DELETE CASCADE ON UPDATE CASCADE;
