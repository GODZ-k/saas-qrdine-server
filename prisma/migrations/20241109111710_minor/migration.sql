/*
  Warnings:

  - You are about to drop the `PhoneNumber` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "PhoneNumber" DROP CONSTRAINT "PhoneNumber_UserId_fkey";

-- DropTable
DROP TABLE "PhoneNumber";

-- CreateTable
CREATE TABLE "Phone" (
    "Id" TEXT NOT NULL,
    "UserId" TEXT NOT NULL,
    "PhoneNumber" TEXT NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Phone_pkey" PRIMARY KEY ("Id")
);

-- AddForeignKey
ALTER TABLE "Phone" ADD CONSTRAINT "Phone_UserId_fkey" FOREIGN KEY ("UserId") REFERENCES "User"("Id") ON DELETE CASCADE ON UPDATE CASCADE;
