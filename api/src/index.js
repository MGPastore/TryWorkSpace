import Server from "./server.js";
import 'dotenv/config'

const port =  process.env.PORT || 3000;
const server = new Server(port);
server.start();

