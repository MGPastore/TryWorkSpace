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
' > src/server.js

# Crear el archivo src/index.js (punto de entrada)
echo 'import Server from "./server.js";
//import 'dotenv/config'

const port =  process.env.PORT || 3000;
const server = new Server(port);
server.start();
' > src/index.js


# Crear el archivo variables de entorno
echo '{
  PORT=1717
  URI_DATABASE="Localhost"
}' > .env



echo "Proyecto creado exitosamente. Ejecute 'npm start' para iniciar el servidor."
