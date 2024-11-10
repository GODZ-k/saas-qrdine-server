import 'dotenv/config'

const PORT = process.env.PORT 
const DATABASE_CONNECTION_URL=process.env.DATABASE_URL


export {
    PORT,
    DATABASE_CONNECTION_URL
}