/*
  Warnings:

  - The primary key for the `Demo` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Payment` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Restaurant` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `RestaurantAddress` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `RestaurantLegalInfo` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Subscription` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `SubsCription_id` on the `Subscription` table. All the data in the column will be lost.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[Username]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `Subscription_id` to the `Subscription` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Demo" DROP CONSTRAINT "Demo_Staff_Id_fkey";

-- DropForeignKey
ALTER TABLE "Payment" DROP CONSTRAINT "Payment_Subscription_id_fkey";

-- DropForeignKey
ALTER TABLE "Payment" DROP CONSTRAINT "Payment_User_id_fkey";

-- DropForeignKey
ALTER TABLE "Restaurant" DROP CONSTRAINT "Restaurant_Restaurant_address_fkey";

-- DropForeignKey
ALTER TABLE "Restaurant" DROP CONSTRAINT "Restaurant_Restaurant_legal_info_fkey";

-- DropForeignKey
ALTER TABLE "Subscription" DROP CONSTRAINT "Subscription_Product_id_fkey";

-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_Restaurant_id_fkey";

-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_Subscription_id_fkey";

-- AlterTable
ALTER TABLE "Demo" DROP CONSTRAINT "Demo_pkey",
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ALTER COLUMN "Staff_Id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Demo_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "Demo_Id_seq";

-- AlterTable
ALTER TABLE "Payment" DROP CONSTRAINT "Payment_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "User_id" SET DATA TYPE TEXT,
ALTER COLUMN "Subscription_id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Payment_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Payment_id_seq";

-- AlterTable
ALTER TABLE "Product" DROP CONSTRAINT "Product_pkey",
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Product_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "Product_Id_seq";

-- AlterTable
ALTER TABLE "Restaurant" DROP CONSTRAINT "Restaurant_pkey",
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ALTER COLUMN "Restaurant_address" SET DATA TYPE TEXT,
ALTER COLUMN "Restaurant_legal_info" SET DATA TYPE TEXT,
ADD CONSTRAINT "Restaurant_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "Restaurant_Id_seq";

-- AlterTable
ALTER TABLE "RestaurantAddress" DROP CONSTRAINT "RestaurantAddress_pkey",
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ADD CONSTRAINT "RestaurantAddress_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "RestaurantAddress_Id_seq";

-- AlterTable
ALTER TABLE "RestaurantLegalInfo" DROP CONSTRAINT "RestaurantLegalInfo_pkey",
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ADD CONSTRAINT "RestaurantLegalInfo_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "RestaurantLegalInfo_Id_seq";

-- AlterTable
ALTER TABLE "Subscription" DROP CONSTRAINT "Subscription_pkey",
DROP COLUMN "SubsCription_id",
ADD COLUMN     "Subscription_id" VARCHAR(200) NOT NULL,
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ALTER COLUMN "Product_id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Subscription_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "Subscription_Id_seq";

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ADD COLUMN     "Username" VARCHAR(200),
ADD COLUMN     "isSubscribed" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "Id" DROP DEFAULT,
ALTER COLUMN "Id" SET DATA TYPE TEXT,
ALTER COLUMN "Subscription_id" SET DATA TYPE TEXT,
ALTER COLUMN "Restaurant_id" SET DATA TYPE TEXT,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("Id");
DROP SEQUENCE "User_Id_seq";

-- CreateIndex
CREATE UNIQUE INDEX "User_Username_key" ON "User"("Username");

-- AddForeignKey
ALTER TABLE "Demo" ADD CONSTRAINT "Demo_Staff_Id_fkey" FOREIGN KEY ("Staff_Id") REFERENCES "User"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_Subscription_id_fkey" FOREIGN KEY ("Subscription_id") REFERENCES "Subscription"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_Restaurant_id_fkey" FOREIGN KEY ("Restaurant_id") REFERENCES "Restaurant"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Restaurant" ADD CONSTRAINT "Restaurant_Restaurant_legal_info_fkey" FOREIGN KEY ("Restaurant_legal_info") REFERENCES "RestaurantLegalInfo"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Restaurant" ADD CONSTRAINT "Restaurant_Restaurant_address_fkey" FOREIGN KEY ("Restaurant_address") REFERENCES "RestaurantAddress"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subscription" ADD CONSTRAINT "Subscription_Product_id_fkey" FOREIGN KEY ("Product_id") REFERENCES "Product"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_User_id_fkey" FOREIGN KEY ("User_id") REFERENCES "User"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_Subscription_id_fkey" FOREIGN KEY ("Subscription_id") REFERENCES "Subscription"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;
