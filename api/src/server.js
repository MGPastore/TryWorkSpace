import express from "express";
import Router from "./router.js";
import connectToDatabase from './driver.js';
class Server {
  constructor(port) {
    this.app = express();
    this.port = port;

    this.configureMiddleware();
    this.configureRoutes();
  }

  configureMiddleware() {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: true }));
    
  }

  configureRoutes() {

    this.app.use("/api",Router );
    this.app.get("/", (req, res) => {
      res.send("Hello, Express!");
    });
  }
  
 async start() {

    const { db } = await connectToDatabase();
    this.app.use('/public', express.static('public'));
    this.app.listen(this.port, () => {
      console.log(`Server is running on http://localhost:${this.port}`);
    });
  }
}

export default Server;

