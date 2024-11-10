/*
  Warnings:

  - You are about to drop the `Staff` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `Password` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Demo" DROP CONSTRAINT "Demo_Staff_Id_fkey";

-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_Restaurant_id_fkey";

-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_Subscription_id_fkey";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "Password" TEXT NOT NULL,
ALTER COLUMN "Subscription_id" DROP NOT NULL,
ALTER COLUMN "Restaurant_id" DROP NOT NULL;

-- DropTable
DROP TABLE "Staff";

-- AddForeignKey
ALTER TABLE "Demo" ADD CONSTRAINT "Demo_Staff_Id_fkey" FOREIGN KEY ("Staff_Id") REFERENCES "User"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_Subscription_id_fkey" FOREIGN KEY ("Subscription_id") REFERENCES "Subscription"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_Restaurant_id_fkey" FOREIGN KEY ("Restaurant_id") REFERENCES "Restaurant"("Id") ON DELETE SET NULL ON UPDATE CASCADE;
