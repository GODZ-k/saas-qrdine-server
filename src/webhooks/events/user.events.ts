import prisma from "../../config/db.config.js";
import { UserData } from "../clerk.js";

export  async function UserCreated(data:UserData) {
  try {
    const user = await prisma.user.create({
      data: {
        Id: data.id,
        First_name: data.first_name || "",
        Last_name: data.last_name || "",
        EmailAddress: data.email_addresses
          ? data.email_addresses[0].email_address
          : "",
        Avatar: data.image_url || "",
        Username: data.username || "",
        LastActiveAt: data.last_active_at
          ? new Date(data.last_active_at)
          : new Date(),
        LastSignInAt: data.last_sign_in_at
          ? new Date(data.last_sign_in_at)
          : new Date(),
        isBanned: data.banned || false,
        TwoFactorEnabled: data.two_factor_enabled || false,
        Locked: data.locked || false,
        BackupCodeEnabled: data.backup_code_enabled || false,
        CreatedAt: data.created_at ? new Date(data.created_at) : new Date(),
        UpdatedAt: data.updated_at ?  new Date(data.updated_at) : new Date() 
      },
    });

    console.log("user created", user);

    // Now insert email addresses associated with the user
    let EmailAddressId;
    if (data.email_addresses && data.email_addresses.length > 0) {
      for (let email of data.email_addresses) {
        EmailAddressId = await prisma.emailAddress.create({
          data: {
            Id: email.id || "",
            EmailAddress: email.email_address ? email.email_address : "",
            Verification: email.verification ? email.verification.status : "",
            UserId: user.Id, // Link the email to the created user
            CreatedAt:email.created_at ? new Date(email.created_at) : new Date(),
            UpdatedAt:email.updated_at ? new Date(email.updated_at) : new Date()
          },
        });
      }
    }
    
    console.log("email created", EmailAddressId);

    if (data.phone_numbers && data.phone_numbers.length > 0) {
      let phoneNoId;
      for (let phone of data.phone_numbers) {
        phoneNoId = await prisma.phone.create({
          data: {
            Id: phone.id || "",
            PhoneNumber: phone.phone_number || "",
            isVerified: phone.verification
              ? phone?.verification.status === "verified" && true
              : false,
            UserId: user.Id, // Link the email to the created user
          },
        });
      }
      console.log("Phone no created ", phoneNoId);
    }

  } catch (error) {
    console.log(error)
  }
}

export  async function UserDeleted(data: UserData) {
  try {
    await prisma.user.delete({
      where: { Id: data.id },
    });
  } catch (error) {
    console.log(error);
  }
}


export async function UserUpdated(data: UserData) {
  try {
    const user = await prisma.user.update({
      where: { Id: data.id },
      data: {
        First_name: data.first_name,
        Last_name: data.last_name,
        EmailAddress:
          data.email_addresses && data.email_addresses[0].email_address,
        Avatar: data.image_url,
        Username: data.username,
        LastActiveAt: data.last_active_at
          ? new Date(data.last_active_at)
          : new Date(),
        LastSignInAt: data.last_sign_in_at
          ? new Date(data.last_sign_in_at)
          : new Date(),
        isBanned: data.banned,
        TwoFactorEnabled: data.two_factor_enabled,
        Locked: data.locked,
        BackupCodeEnabled: data.backup_code_enabled,
      },
    });

    console.log("user created", user);

    // Now insert email addresses associated with the user
    let EmailaddressId
    if (data.email_addresses && data.email_addresses.length > 0) {
      for (let email of data.email_addresses) {
        EmailaddressId = await prisma.emailAddress.upsert({
          where: { Id: email.id },
          update: {
            EmailAddress: email.email_address,
            Verification: email.verification ? email.verification.status : "",
          },
          create: {
            Id: email.id || "",
            EmailAddress: email.email_address || "",
            Verification: email.verification ? email.verification.status : "",
            UserId: user.Id, // Link the email to the updated user
          },
        });
      }
    }

    if (data.phone_numbers && data.phone_numbers.length > 0) {
      for (let phone of data.phone_numbers) {
        await prisma.phone.upsert({
          where: { Id: phone.id },
          update: {
            PhoneNumber: phone.phone_number,
            isVerified: phone.verification
              ? phone.verification.status === "verified" && true
              : false,
          },
          create: {
            Id: phone.id || "",
            PhoneNumber: phone.phone_number || "",
            isVerified: phone.verification
              ? phone.verification.status === "verified" && true
              : false,
            UserId: user.Id, // Link the phone number to the updated user
          },
        });
      }
    }
  } catch (error) {
    console.log(error);
  }
}
