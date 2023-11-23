import express from "express";
import Router from "./router.js";

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

  start() {
    this.app.listen(this.port, () => {
      console.log(`Server is running on http://localhost:${this.port}`);
    });
  }
}

export default Server;

