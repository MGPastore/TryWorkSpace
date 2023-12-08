
import User from "./User_Model.js";
import passport from "passport";

export const renderSignUpForm = (req, res) => res.render("auth/signup");

export const signup = async (req, res) => {
  try {
    let errors = [];
    const { name, email, password, confirm_password } = req.body;
    
    // Validations
    if (password !== confirm_password) {
      errors.push({ text: "Passwords do not match." });
    }

    if (password.length < 4) {
      errors.push({ text: "Passwords must be at least 4 characters." });
    }

    if (errors.length > 0) {
      return res.render("auth/signup", {
        errors,
        name,
        email,
        password,
        confirm_password,
      });
    }

    // Check for existing email
    const userFound = await User.findOne({ email: email });
    if (userFound) {
      req.session.errorMessage = "The Email is already in use.";
      return res.redirect("/auth/signup");
    }

    // Save a new user
    const newUser = new User({ name, email, password });
    newUser.password = await newUser.encryptPassword(password);
    await newUser.save();
    req.session.successMessage = "You are registered.";
    res.redirect("/auth/signin");
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
};

export const renderSigninForm = (req, res) => res.render("auth/signin");

export const signin = passport.authenticate("local", {
  successRedirect: "/notes",
  failureRedirect: "/auth/signin",
  failureFlash: true,
});

export const logout = async (req, res, next) => {
  try {
    await req.logout();
    req.session.successMessage = "You are logged out now.";
    res.redirect("/auth/signin");
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
};
