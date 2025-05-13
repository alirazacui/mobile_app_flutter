require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

// Initialize Express app
const app = express();

// CORS Configuration - Adjusted for Flutter web testing
const corsOptions = {
  origin: '*', // Allows all origins for testing; replace with specific origins in production
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type']
};
app.use(cors(corsOptions));

// Middleware
app.use(express.json());

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('🌟 Connected to MongoDB Atlas!'))
  .catch(err => console.error('🚨 Connection error:', err));

// User Schema
const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  createdAt: { type: Date, default: Date.now }
});
const User = mongoose.model('User', userSchema);

// Routes
app.get('/', (req, res) => {
  res.json({ message: "Hello from backend!", status: 200 });
});

// Create User
app.post('/users', async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).json(user);
  } catch (err) {
    res.status(400).json({ 
      error: err.message,
      status: 400
    });
  }
});

// Get All Users
app.get('/users', async (req, res) => {
  try {
    const users = await User.find().sort({ createdAt: -1 });
    res.json({
      status: 200,
      data: users
    });
  } catch (err) {
    res.status(500).json({
      status: 500,
      error: 'Server error'
    });
  }
});

// Server Setup
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on port ${PORT}`);
});