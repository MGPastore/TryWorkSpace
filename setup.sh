#!/bin/bash

# Crear la estructura del proyecto
mkdir api
cd api
mkdir src
touch src/server.js src/index.js

# Instalar dependencias
npm init -y

# Crear el archivo package.json
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


npm install express mongoose bcryptjs  passport passport-local express-session connect-mongo
npm install nodemon dotenv -D


# Crear el archivo src/server.js (servidor Express)
echo 'import express from "express";
import connectToDatabase from './driver.js';


class Server {
  constructor(port,URI) {
    this.app = express();
    this.port = port;
    this.DATABASE_URI = URI;

    this.configureMiddleware();
    this.configureRoutes();
  }

  configureMiddleware() {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: true }));
  }

  configureRoutes() {
    this.app.get("/", (req, res) => {
      res.send("Hello, Express!");
    });
  }

  start() {
    const { db } = await connectToDatabase(DATABASE_URI);
    this.app.listen(this.port, () => {
      console.log(`Server is running on http://localhost:${this.port}`);
    });
  }
}

export default Server;
' > src/server.js

# Crear el archivo src/index.js (punto de entrada)
echo 'import Server from "./server.js";
//import 'dotenv/config'

const port =  process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || "mongodb://localhost/myAppDB";
const server = new Server(port,MONGODB_URI);
server.start();
' > src/index.js


# Crear el archivo variables de entorno
echo '{
  PORT=1717
  MONGODB_URI="mongodb://localhost/myAppDB"
}' > .env


# Crear el archivo driver
echo '// db.js
import mongoose from 'mongoose';

const connectToDatabase = async (mongoURL) => {
  try {
    const mongoURL = this.mongoURL;

    await mongoose.connect(mongoURL);    
    console.log("Database OK")
    const { connection: db } = mongoose;   
    return { mongoose, db };
  } 
  
  catch (error) {
    console.error('Error al conectar con MongoDB:', error);
    throw error;
  }
};

export default connectToDatabase;
' > driver.js


echo "Proyecto creado exitosamente. Ejecute 'npm start' para iniciar el servidor."
