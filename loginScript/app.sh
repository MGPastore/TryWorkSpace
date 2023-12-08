#!/bin/bash

mkdir api
cd api
mkdir src
touch src/server.js src/index.js src/userModel.js src/authController.js src/userRouter.js

npm init -y

echo '// db.js
import mongoose from "mongoose";

const connectToDatabase = async () => {
  try {
    const mongoURL = "mongodb://localhost:27017/home";

    await mongoose.connect(mongoURL);
    console.log("Database OK");
    const { connection: db } = mongoose;
    return { mongoose, db };
  } catch (error) {
    console.error("Error al conectar con MongoDB:", error);
    throw error;
  }
};

export default connectToDatabase;
' > src/driver.js



echo '{
  "name": "ApiV1",
  "type": "module",
  "version": "1.0.0",
  "description": "A simple Express project",
  "main": "src/index.mjs",
  "scripts": {
    "start": "nodemon src/index.js"
  }
}' > package.json

npm install express mongoose bcryptjs passport passport-local express-session connect-mongo nodemon dotenv -D

echo 'import express from "express";
import connectToDatabase from "./driver.js";
import session from "express-session";
import passport from "passport";
import userRouter from "./userRouter.js";

class Server {
  constructor(port, URI) {
    this.app = express();
    this.port = port;
    this.DATABASE_URI = URI;

    this.configureMiddleware();
    this.configureRoutes();
  }

  configureMiddleware() {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: true }));
    this.app.use(session({ secret: "secret", resave: true, saveUninitialized: true }));
    this.app.use(passport.initialize());
    this.app.use(passport.session());
  }

  configureRoutes() {
    this.app.use("/", (req, res) => {
      res.send("Hello, Express!");
    });

    this.app.use("/users", userRouter);
  }

  async start() {
    const { db } = await connectToDatabase(this.DATABASE_URI);
    this.app.listen(this.port, () => {
      console.log(`Server is running on http://localhost:${this.port}`);
    });
  }
}

export default Server;
' > src/server.js

echo 'import Server from "./server.js";
// import "dotenv/config"

const port = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost/myAppDB";
const server = new Server(port, MONGODB_URI);
server.start();
' > src/index.js

echo 'import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const UserSchema = new mongoose.Schema(
  {
    name: { type: String, trim: true },
    email: { type: String, required: true, unique: true, trim: true },
    password: { type: String, required: true },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

UserSchema.methods.encryptPassword = async function (password) {
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(password, salt);
};

UserSchema.methods.matchPassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

export default mongoose.model("User", UserSchema);
' > src/userModel.js

echo 'import passport from "passport";
import LocalStrategy from "passport-local";
import User from "./userModel.js";

passport.use(
  new LocalStrategy.Strategy(
    { usernameField: "email" },
    async (email, password, done) => {
      try {
        const user = await User.findOne({ email });
        if (!user) {
          return done(null, false, { message: "Usuario no encontrado" });
        }

        const match = await user.matchPassword(password);
        if (match) {
          return done(null, user);
        } else {
          return done(null, false, { message: "Contraseña incorrecta" });
        }
      } catch (error) {
        return done(error);
      }
    }
  )
);

passport.serializeUser((user, done) => {
  done(null, user._id);
});

passport.deserializeUser(async (id, done) => {
  try {
    const user = await User.findById(id);
    done(null, user);
  } catch (error) {
    done(error);
  }
});
' > src/authController.js

echo 'import express from "express";
import passport from "passport";
import User from "./userModel.js";

const userRouter = express.Router();

userRouter.post("/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const newUser = new User({ name, email, password });
    await newUser.encryptPassword(password);
    await newUser.save();
    res.status(201).json({ message: "Usuario creado exitosamente" });
  } catch (error) {
    console.error("Error al registrar usuario:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
});

userRouter.post(
  "/login",
  passport.authenticate("local", {
    successRedirect: "/",
    failureRedirect: "/login",
    failureFlash: true,
  })
);

userRouter.get("/logout", (req, res) => {
  req.logout();
  res.redirect("/");
});

export default userRouter;
' > src/userRouter.js

echo "Proyecto creado exitosamente. Ejecute 'npm start' para iniciar el servidor."
