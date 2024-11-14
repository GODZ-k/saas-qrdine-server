import { Request, Response } from "express";
import { rzp } from "../services/rezorpay.js";
import { CreatePlanType, CreatePlanTypeSchema } from "../Types/Plans.types.js";
import { number } from "zod";

class Plan {
    
  static async createPlan(req: Request, res: Response): Promise<any> {
    try {
      // const user = req.user
      const inputData: CreatePlanType = req.body;

      if (!inputData) {
        return res.status(400).json({
          msg: "All fields must be required",
        });
      }

      const payload = CreatePlanTypeSchema.safeParse(inputData);

      if (!payload.success) {
        return res.status(400).json({
          msg: payload.error.errors[0].message,
        });
      }

      const { period, interval, item, notes } = payload.data;

      const planDetails: CreatePlanType = {
        period,
        interval,
        item: {
          name: item.name,
          amount: item.amount,
          currency: item.currency,
          description: item.description || "",
        },
        notes: notes || {},
      };

      const plan = await rzp.plans.create(planDetails);

      return res.status(200).json({
        plan,
        msg: "Plan created successfully",
      });
    } catch (error) {
      console.log(error);
      return res.status(500).json({
        msg: "Internal server error",
      });
    }
  }

  static async plans(req:Request, res:Response):Promise<any> {
    try{
        const user = req.user

        const plans = await rzp.plans.all()

        if(!plans || plans.items.length === 0){
            return res.status(404).json({
                msg:"Plans not found"
            })
        }

        return res.status(200).json({
            plans,
            msg:"plans found successfully"
        })

    }catch(error:any){
        console.log(error);
        return res.status(500).json({
          msg: "Internal server error",
        });
    }
  }

  static async plan(req:Request, res:Response):Promise<any> {
    try{
        const user = req.user
        const planId:string = req.params.planId

        const plan = await rzp.plans.fetch(planId)

        if(!plan){
            return res.status(404).json({
                msg:"Plans not found"
            })
        }

        return res.status(200).json({
            plan,
            msg:"plans found successfully"
        })

    }catch(error:any){
        console.log(error);
        return res.status(500).json({
          msg: "Internal server error",
        });
    }
  }

}

export default Plan;
