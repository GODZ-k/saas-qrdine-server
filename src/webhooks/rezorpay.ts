import { Request, Response } from "express";
import {UserCreated,UserDeleted , UserUpdated} from "./events/subscription.event.js";
import logger from "../logger.js";

import { Queue } from "bullmq";
import { client } from "../services/redis.js";



const paymentQueue = new Queue('payment-queue',{
  connection:client
});


export const rezorpayWebhook = async (
  req: Request,
  res: Response
): Promise<any> => {
  try {
    const request = req.event;

    if (!request) {
      return res.status(400).json({
        success: false,
        message: "Webhook event not found or not verified.",
      });
    }

    const data = request.payload;
    const eventType = request.event;

    // console.log("data",data , "eventType",eventType)

    const eventHandlers: Record<string, Function> = {
      "user.created": UserCreated,
      "user.updated": UserUpdated,
      "user.deleted": UserDeleted,
    };

    const handler = eventHandlers[eventType];
    if (handler) {
      await handler(data);
      await paymentQueue.add(eventType, { eventType, data },{
        attempts: 5, // Retry the job up to 5 times
        backoff: 5000, // Retry after 5 seconds if the job fails
        delay:1000
      });
    } else {
      return res.status(400).json({
        success: false,
        message: `Unhandled event type: ${eventType}`,
      });
    }

    return res.status(200).json({
      success: true,
      message: "Webhook received successfully",
    });
  } catch (error: any) {
    logger.error("Error handling webhook event", {
      error: error.message,
      stack: error.stack,
    });
    return res.status(500).json({
      status: false,
      msg: "Internal server error",
      error: error.message,
    });
  }
};