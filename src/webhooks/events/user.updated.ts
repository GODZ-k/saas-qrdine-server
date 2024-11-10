import prisma from "../../config/db.config.js";
import { UserData } from "../clerk.js";

export default async function UserUpdated(data: UserData) {
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

    if (data.external_accounts && data.external_accounts.length > 0) {
      // Now insert external accounts associated with the user
      for (let externalAccount of data.external_accounts) {
        await prisma.externalAccount.upsert({
          where: { Id: externalAccount.id },
          update: {
            Provider: externalAccount.verification?.strategy,
            ProviderUserId:
              externalAccount.google_id ||
              externalAccount.provider_user_id ||
              "",
            EmailAddress: externalAccount.email_address,
            VerificationStatus: externalAccount.verification?.status,
          },
          create: {
            Id: externalAccount.id || "",
            UserId: user.Id, // Link external account to the updated user
            Provider: externalAccount.verification?.strategy || "",
            ProviderUserId:
              externalAccount.google_id ||
              externalAccount.provider_user_id ||
              "",
            EmailAddress: externalAccount.email_address || "",
            VerificationStatus: externalAccount.verification?.status || "",
            EmailAddressId:EmailaddressId?.Id
          },
        });
      }

      console.log("external account created ");
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
