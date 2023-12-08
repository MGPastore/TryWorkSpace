import express from "express";
import Router from "./router.js";
import connectToDatabase from './driver.js';
import passport from "passport";
import session from "express-session";
import MongoStore from "connect-mongo";
import "./config/passport.js"


//const __dirname = dirname(fileURLToPath(import.meta.url));

class Server {
  constructor(port, URI) {
    this.app = express();
    this.port = port;
    this.DATABASE_URI = URI;


    this.configureMiddleware();
    this.configureRoutes();
    this.Login();
  }

  Login() {
    this.app.use(
      session({
        secret: "secret",
        resave: true,
        saveUninitialized: true,
        store: MongoStore.create({ mongoUrl: this.DATABASE_URI }),
      })
    );
    
    this.app.use(passport.initialize());
    this.app.use(passport.session());
    
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

