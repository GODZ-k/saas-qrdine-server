import { clerkClient } from "@clerk/express"
import { Response , Request } from "express"
import prisma from "../config/db.config.js"
import { rzp } from "../services/rezorpay.js"





class Subscription {

    // create a subscription
    static async create(req:Request,res:Response):Promise<any>{
        try {

            interface SubscriptionInputType {
                plan_id:string;
                total_count:number;
                quantity?:number;
            }

            // const user  =  req.user
            const inputData:SubscriptionInputType = req.body
            
            // if(!user){
            //     return res.status(422).json({
            //         msg:"User not exists"
            //     })
            // }

            const subscriptionInput:SubscriptionInputType = {
                plan_id: inputData.plan_id,
                quantity: inputData.quantity,
                total_count: inputData.total_count,
            }

            const subscribe = await rzp.subscriptions.create({
                ...subscriptionInput,
                customer_notify:1,
            })

            return res.status(200).json({
                subscribe,
                msg:"subscription created successfully"
            })
            
        } catch (error) {
            console.log(error)
            return res.status(500).json({
                msg:"Internal server error"
            })
        }
    }

    // fetch subscription by id 
    static async getById(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user

            const sub_id:string =  req.params.sub_id

            const subscription = await rzp.subscriptions.fetch(sub_id)

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"subscription created successfully"
            })
            
        } catch (error) {
            console.log(error)
            return res.status(500).json({
                msg:"Internal server error"
            })
        }
    }

    // get all subscription
    static async getAll(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user

            const subscriptions = await rzp.subscriptions.all()

            if(!subscriptions || subscriptions.items.length === 0){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscriptions,
                msg:"subscription created successfully"
            })
            
        } catch (error) {
            console.log(error)
            return res.status(500).json({
                msg:"Internal server error"
            })
        }
    }

    // cancel the subscription
    static async cancel(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user
            const sub_id:string = req.params.sub_id

            const subscription = await rzp.subscriptions.cancel(sub_id,{cancel_at_cycle_end:true})

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"subscription canceled successfully"
            })
            
        } catch (error:any) {
            console.log(error)
            return res.status(500).json({
                msg:error.error.description || "Internal server error"
            })
        }
    }

    // Cancel an Update
    static async cancelUpdates(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user
            const sub_id:string = req.params.sub_id

            const subscription = await rzp.subscriptions.cancelScheduledChanges(sub_id)

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"updates canceled successfully"
            })
            
        } catch (error:any) {
            console.log(error)
            return res.status(500).json({
                msg:error.error.description || "Internal server error"
            })
        }
    }

    // pause a subscription
    static async pause(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user
            const sub_id:string = req.params.sub_id

            const subscription = await rzp.subscriptions.pause(sub_id,{
                pause_at:'now'
            })

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"subscription paused successfully"
            })
            
        } catch (error:any) {
            console.log(error)
            return res.status(500).json({
                msg:error.error.description || "Internal server error"
            })
        }
    }

    // Resume a subscription
    static async resume(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user
            const sub_id:string = req.params.sub_id

            const subscription = await rzp.subscriptions.resume(sub_id,{
                resume_at:'now'
            })

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"subscription resumed successfully"
            })
            
        } catch (error:any) {
            console.log(error)
            return res.status(500).json({
                msg:error.error.description || "Internal server error"
            })
        }
    }

    // fetch all invoices of the subscription
    static async invoices(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user
            const sub_id:string = req.params.sub_id

            const subscription = await rzp.invoices.all({
                'subscription_id':sub_id
            })

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"Invoices found successfully"
            })
            
        } catch (error:any) {
            console.log(error)
            return res.status(500).json({
                msg:error.error.description || "Internal server error"
            })
        }
    }

    // delete an affer fromthe subscription
    static async delOffer(req:Request,res:Response):Promise<any>{
        try {

            const user  =  req.user
            const sub_id:string = req.params.sub_id
            const off_id:string = req.params.off_id

            const subscription = await rzp.subscriptions.deleteOffer(sub_id,off_id)

            if(!subscription){
                return res.status(404).json({
                    msg:"Subscription not found"
                })
            }

            return res.status(200).json({
                subscription,
                msg:"offer deleted successfully"
            })
            
        } catch (error:any) {
            console.log(error)
            return res.status(500).json({
                msg:error.error.description || "Internal server error"
            })
        }
    }    
}

export default Subscription