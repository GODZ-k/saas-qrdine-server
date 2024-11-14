import { clerkClient } from "@clerk/express"
import { Response , Request } from "express"
import prisma from "../config/db.config.js"





class User {
    // get current user
    static async currentUser(req:Request , res:Response):Promise<any>{
        const user  = req.user
    
        if(!user){
            return res.status(422).json({
                msg:"User not exists"
            })
        }
    
        const loggedInUser = await prisma.user.findUnique({
            where:{
                Id:user,
            },
            include:{
                subscription:true,
                restaurant:true,
                Demos:true
            }
        })
    
        if(!loggedInUser){
            return res.status(422).json({
                msg:"User not exists"
            }) 
        }
    
        return res.status(200).json({
            loggedInUser,
            msg:"User found succcessfully"
        })
    }

}

export default User