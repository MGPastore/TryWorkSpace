import Server from "./server.js";
import "./config/passport.js"
import 'dotenv/config'

const port =  process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost/notesdb";

const server = new Server(port,MONGODB_URI);
server.start();

