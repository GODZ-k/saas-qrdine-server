import { Request, Response } from "express";
import { WebhookEvent } from "@clerk/express";
import UserCreated from "./events/user.created.js";
import logger from "../logger.js";
import UserUpdated from "./events/user.updated.js";

interface ExternalAccount {
  id: string;
  created_at: number;
  email_address: string;
  google_id?: string;
  updated_at: number;
  username: string;
  verification: { status: string; strategy: string; expire_at: number };
  approved_scopes: string;
  avatar_url?: string;
  first_name?: string;
  identification_id?: string;
  last_name?: string;
  provider?: string;
  provider_user_id?: string;
}

interface EmailAddress {
  created_at?: number;
  email_address?: string;
  id?: string;
  updated_at?: number;
  verification?: { status: string; strategy: string };
}

interface PhoneNumber {
  id: string;
  phone_number: string;
  verification?: { status: string; strategy: string };
}

export interface UserData {
  id: string;
  first_name: string;
  last_name: string;
  email_addresses?: Array<EmailAddress> | undefined;
  external_accounts?: Array<ExternalAccount>;
  banned?: boolean;
  backup_code_enabled?: boolean;
  image_url?: string;
  last_active_at?: number;
  last_sign_in_at?: number;
  locked?: boolean;
  updated_at?: number;
  two_factor_enabled?: boolean;
  username?: string;
  phone_numbers?: Array<PhoneNumber>;
}

export const clerkWebhook = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const evt = req.event as WebhookEvent;

    if (!evt) {
      return res.status(400).json({
        success: false,
        message: "Webhook event not found or not verified.",
      });
    }

    const data = evt.data as UserData;
    const eventType = evt.type;

    if (eventType === "user.created") {
      await UserCreated(data);
    } else if (eventType === "user.updated") {
      await UserUpdated(data)
    }

    return res.status(200).json({
      success: true,
      message: "Webhook received successfully",
    });
  } catch (error) {
    return res.status(500).json({
      msg: "Internal server error",
    });
  }
};

// Type guard function
function isUserData(data: any): data is UserData {
  return (
    data &&
    typeof data.id === "string" &&
    Array.isArray(data.email_addresses) &&
    Array.isArray(data.external_accounts) &&
    Array.isArray(data.phone_numbers)
  );
}
