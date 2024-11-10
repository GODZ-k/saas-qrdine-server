-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'STAFF', 'USER');

-- CreateEnum
CREATE TYPE "PlanType" AS ENUM ('BASIC', 'PRO');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'TRIALING', 'EXPIRED', 'CANCELED', 'UNPAID', 'PAUSED');

-- CreateEnum
CREATE TYPE "Currency" AS ENUM ('INR', 'USD', 'EUR');

-- CreateEnum
CREATE TYPE "PlanInterval" AS ENUM ('MONTH', 'YEAR');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('SUCCESS', 'FAILED', 'PENDING');

-- CreateTable
CREATE TABLE "Demo" (
    "Id" SERIAL NOT NULL,
    "Name" VARCHAR(200) NOT NULL,
    "Email" VARCHAR(200) NOT NULL,
    "Phone" VARCHAR(15) NOT NULL,
    "Message" VARCHAR(500),
    "Staff_Id" INTEGER,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Demo_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Staff" (
    "Id" SERIAL NOT NULL,
    "Name" VARCHAR(200) NOT NULL,
    "Email" VARCHAR(200) NOT NULL,
    "Phone" VARCHAR(15) NOT NULL,
    "Role" "UserRole" NOT NULL DEFAULT 'STAFF',
    "IsActive" BOOLEAN NOT NULL DEFAULT true,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Staff_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "User" (
    "Id" SERIAL NOT NULL,
    "Name" VARCHAR(200) NOT NULL,
    "Email" VARCHAR(200) NOT NULL,
    "Phone" VARCHAR(15) NOT NULL,
    "Role" "UserRole" NOT NULL DEFAULT 'USER',
    "Subscription_id" INTEGER NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "Restaurant_id" INTEGER NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Restaurant" (
    "Id" SERIAL NOT NULL,
    "Restaurant_name" VARCHAR(200) NOT NULL,
    "Restaurant_url" VARCHAR(200) NOT NULL,
    "Restaurant_type" VARCHAR(200) NOT NULL,
    "Food_menu" VARCHAR(500) NOT NULL,
    "Tables" INTEGER NOT NULL DEFAULT 0,
    "Staff_count" INTEGER NOT NULL DEFAULT 0,
    "Location" VARCHAR(200) NOT NULL,
    "Business_email" VARCHAR(300) NOT NULL,
    "Business_contact_number" INTEGER NOT NULL,
    "Company_name" VARCHAR(200) NOT NULL,
    "Owner_name" VARCHAR(200) NOT NULL,
    "Restaurant_address" INTEGER NOT NULL,
    "Restaurant_legal_info" INTEGER NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Restaurant_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "RestaurantAddress" (
    "Id" SERIAL NOT NULL,
    "Address" VARCHAR(500) NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RestaurantAddress_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "RestaurantLegalInfo" (
    "Id" SERIAL NOT NULL,
    "GST" VARCHAR(15) NOT NULL,
    "FSSAI_Licence" VARCHAR(500) NOT NULL,
    "MSME_Certificate" VARCHAR(500) NOT NULL,
    "Company_pan" VARCHAR(500) NOT NULL,
    "Phone_no" VARCHAR(15) NOT NULL,
    "Director_pan" VARCHAR(500) NOT NULL,
    "Director_aadhar" VARCHAR(500) NOT NULL,
    "Email" VARCHAR(200) NOT NULL,
    "Cancel_cheque" VARCHAR(500) NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RestaurantLegalInfo_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Subscription" (
    "Id" SERIAL NOT NULL,
    "Product_id" INTEGER NOT NULL,
    "Interval" VARCHAR(200) NOT NULL,
    "Plan_type" "PlanType" NOT NULL DEFAULT 'BASIC',
    "Start_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "End_date" TIMESTAMP(3) NOT NULL,
    "Status" "SubscriptionStatus" NOT NULL DEFAULT 'UNPAID',
    "Invoice" VARCHAR(500) NOT NULL,
    "Has_trial" BOOLEAN NOT NULL DEFAULT true,
    "Amount" INTEGER NOT NULL,
    "SubsCription_id" VARCHAR(200) NOT NULL,
    "Payment_method" VARCHAR(200) NOT NULL,
    "Price" VARCHAR(200) NOT NULL,
    "Description" VARCHAR(200) NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Subscription_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Product" (
    "Id" SERIAL NOT NULL,
    "Plan_type" "PlanType" NOT NULL DEFAULT 'BASIC',
    "Amount" INTEGER NOT NULL,
    "Currency" "Currency" NOT NULL DEFAULT 'INR',
    "Interval" "PlanInterval" NOT NULL DEFAULT 'MONTH',
    "IsActive" BOOLEAN NOT NULL DEFAULT true,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("Id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" SERIAL NOT NULL,
    "User_id" INTEGER NOT NULL,
    "Subscription_id" INTEGER NOT NULL,
    "Amount" INTEGER NOT NULL,
    "Payment_status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "Invoice" VARCHAR(500) NOT NULL,
    "Payment_method" VARCHAR(200) NOT NULL,
    "CreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Demo_Email_key" ON "Demo"("Email");

-- CreateIndex
CREATE UNIQUE INDEX "Demo_Phone_key" ON "Demo"("Phone");

-- CreateIndex
CREATE UNIQUE INDEX "Staff_Email_key" ON "Staff"("Email");

-- CreateIndex
CREATE UNIQUE INDEX "Staff_Phone_key" ON "Staff"("Phone");

-- CreateIndex
CREATE UNIQUE INDEX "User_Email_key" ON "User"("Email");

-- CreateIndex
CREATE UNIQUE INDEX "User_Phone_key" ON "User"("Phone");

-- CreateIndex
CREATE UNIQUE INDEX "User_Subscription_id_key" ON "User"("Subscription_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_Restaurant_id_key" ON "User"("Restaurant_id");

-- CreateIndex
CREATE UNIQUE INDEX "Restaurant_Business_email_key" ON "Restaurant"("Business_email");

-- CreateIndex
CREATE UNIQUE INDEX "Restaurant_Business_contact_number_key" ON "Restaurant"("Business_contact_number");

-- CreateIndex
CREATE UNIQUE INDEX "Restaurant_Restaurant_address_key" ON "Restaurant"("Restaurant_address");

-- CreateIndex
CREATE UNIQUE INDEX "Restaurant_Restaurant_legal_info_key" ON "Restaurant"("Restaurant_legal_info");

-- CreateIndex
CREATE UNIQUE INDEX "RestaurantLegalInfo_GST_key" ON "RestaurantLegalInfo"("GST");

-- CreateIndex
CREATE UNIQUE INDEX "RestaurantLegalInfo_Phone_no_key" ON "RestaurantLegalInfo"("Phone_no");

-- CreateIndex
CREATE UNIQUE INDEX "RestaurantLegalInfo_Email_key" ON "RestaurantLegalInfo"("Email");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_User_id_key" ON "Payment"("User_id");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_Subscription_id_key" ON "Payment"("Subscription_id");

-- AddForeignKey
ALTER TABLE "Demo" ADD CONSTRAINT "Demo_Staff_Id_fkey" FOREIGN KEY ("Staff_Id") REFERENCES "Staff"("Id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_Subscription_id_fkey" FOREIGN KEY ("Subscription_id") REFERENCES "Subscription"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_Restaurant_id_fkey" FOREIGN KEY ("Restaurant_id") REFERENCES "Restaurant"("Id") ON DELETE RESTRICT ON UPDATE CASCADE;

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
