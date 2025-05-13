Flutter MongoDB Atlas Demo

This project demonstrates how to connect a Flutter app to MongoDB Atlas using a Node.js/Express backend. The app allows users to submit data (name and email), which is stored in a MongoDB Atlas database. The app works on both web (e.g., Microsoft Edge) and mobile platforms (Android/iOS).



Table of Contents





Prerequisites



Project Structure



Setup Instructions





1. Clone the Repository



2. Set Up the Backend



3. Set Up the Flutter App



Running the App





Run on Web (Edge)



Run on Mobile (Android/iOS)



Troubleshooting



Contributing



License



Prerequisites

Before you begin, ensure you have the following installed:





Flutter (for the app)



Node.js (for the backend)



Git (to clone the repository)



A MongoDB Atlas account (for the database)

You’ll also need:





A code editor like Visual Studio Code or Android Studio.



A mobile device or emulator for testing (if running on mobile).



Project Structure

The project is divided into two main parts:





Backend: A Node.js/Express server that connects to MongoDB Atlas and handles API requests.



Frontend: A Flutter app that sends data to the backend and displays stored data.

Key files:





server.js: The backend server code.



api_service.dart: Handles API requests from the Flutter app.



main.dart: The main Flutter app file.



Setup Instructions

1. Clone the Repository

First, clone this repository to your local machine:

git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name

Replace yourusername and your-repo-name with your GitHub details.

2. Set Up the Backend





Navigate to the backend folder:

cd backend



Install the required Node.js packages:

npm install



Create a .env file in the backend folder and add your MongoDB Atlas connection string:

MONGODB_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/<database>?retryWrites=true&w=majority

Replace <username>, <password>, and <database> with your MongoDB Atlas credentials.



Start the backend server:

node server.js

You should see "🚀 Server running on port 3000" and "🌟 Connected to MongoDB Atlas!" in the terminal.

3. Set Up the Flutter App





Navigate to the Flutter app folder:

cd ../flutter_app



Install the required Flutter packages:

flutter pub get



Update the baseUrl in api_service.dart:





Open lib/api_service.dart.



Replace 'http://192.168.1.100:3000' with your computer’s IP address. To find your IP:





Windows: Run ipconfig in Command Prompt and look for "IPv4 Address".



macOS/Linux: Run ifconfig or ip addr in Terminal.



Example:

return 'http://192.168.1.5:3000';  // Replace with your actual IP



Running the App

Run on Web (Edge)





Ensure the backend is running (node server.js).



In the Flutter app folder, run:

flutter run -d web-server --web-port 5000



Open Microsoft Edge and go to http://localhost:5000.



Enter data in the app and submit. Check MongoDB Atlas to confirm the data was saved.

Run on Mobile (Android/iOS)





Ensure the backend is running (node server.js).



Connect your mobile device via USB and enable Developer Options and USB Debugging.



In the Flutter app folder, check available devices:

flutter devices



Run the app on your device:

flutter run -d <device_id>

Replace <device_id> with your device’s ID from the previous command.



Enter data in the app and submit. Check MongoDB Atlas to confirm the data was saved.

Note: Ensure your phone and computer are on the same Wi-Fi network.



Troubleshooting





App can’t connect to backend on mobile:





Check that your phone and computer are on the same Wi-Fi network.



Ensure the baseUrl in api_service.dart uses your computer’s correct IP address.



Verify the backend is running and accessible by opening http://<your_computer_ip>:3000 in your phone’s browser.



Data not saving to MongoDB:





Check the backend terminal for errors (e.g., MongoDB connection issues).



Ensure your .env file has the correct MONGODB_URI.



NDK version warning:





Update android/app/build.gradle.kts (or build.gradle) with:

android {
    ndkVersion = "27.0.12077973"
}



Then run flutter clean and flutter run.

For more help, check the Flutter documentation or MongoDB Atlas documentation.



Contributing

If you’d like to contribute to this project:





Fork the repository.



Create a new branch (git checkout -b feature/your-feature).



Make your changes and commit (git commit -m "Add your feature").



Push to your branch (git push origin feature/your-feature).



