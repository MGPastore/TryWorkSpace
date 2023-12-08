import { Router } from "express";
import { signin,signup,logout } from "./login/auth.controllers.js";

const router = Router();

// Routes
//router.get("/auth/signup", renderSignUpForm);

router.post("/auth/signup", signup);

//router.get("/auth/signin", renderSigninForm);

router.post("/auth/signin", signin);

router.get("/auth/logout", logout);

export default router;
