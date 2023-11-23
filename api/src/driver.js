// db.js
import mongoose from 'mongoose';

const connectToDatabase = async () => {
  try {
    const mongoURL = 'mongodb://localhost:27017/home';

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
