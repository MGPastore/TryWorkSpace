import Server from "./server.js";
import 'dotenv/config'

const port =  process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost/notesdb";

const server = new Server(port,MONGODB_URI);
import {  createAdminUser } from "../createUser.js";
createAdminUser()
server.start();

