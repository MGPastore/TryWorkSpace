import User from "../api/src/login/User_Model.js";

export const createAdminUser = async () => {
  const userFound = await User.findOne({ email: "admin@admin.com" });

  if (userFound) return;

  const newUser = new User({
    username: "admin",
    email: "admin@admin.com",
  });

  newUser.password = await newUser.encryptPassword("admin");

  const admin = await newUser.save();

  console.log("Admin user created", admin);
};
