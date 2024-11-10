import prisma from "../../config/db.config.js";
import { UserData } from "../clerk.js";

export default async function UserCreated(data:UserData) {
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
          },
        });
      }
    }
    
    console.log("email created", EmailAddressId);
    
    if (data.external_accounts && data.external_accounts.length > 0) {
      // Now insert external accounts associated with the user
      for (let externalAccount of data.external_accounts) {
        await prisma.externalAccount.create({
          data: {
            Id: externalAccount.id || "",
            UserId: user.Id, // Link external account to the user
            Provider: externalAccount.verification?.strategy || "",
            ProviderUserId:
              externalAccount.google_id ||
              externalAccount.provider_user_id ||
              "",
            EmailAddress: externalAccount.email_address || "",
            VerificationStatus: externalAccount.verification?.status || "",
            EmailAddressId: EmailAddressId?.Id || "",
          },
        });
      }

      console.log("external account created ");
    }

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
