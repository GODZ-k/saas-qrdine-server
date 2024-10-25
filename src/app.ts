import 'dotenv/config'
import express from 'express'
import cookieParser from 'cookie-parser'
import cors from 'cors'

const app = express()
app.use(cors({
    origin:'*',
    credentials:true
}))
app.use(express.json({ limit:"100mb"}))
app.use(express.urlencoded({extended:false}))
app.use(cookieParser())






export default app