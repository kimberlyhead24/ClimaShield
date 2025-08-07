// This script reads recipe data from a JSON file and uploads it to your Firestore collection.
// It uses the Firebase Admin SDK, which gives your script special server-like access to Firebase.

// 1. Import necessary Firebase Admin SDK modules.
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path'); // Import the 'path' module to handle file paths

// --- START OF DEBUGGING AND SETUP ---

// 2. Define the paths for your key file and data file.
//    __dirname is a special variable in Node.js that gives the path of the folder where this script is located.
const keyFilePath = path.join(__dirname, 'firebase-key.json');
const dataFilePath = path.join(__dirname, 'recipes.json');

// 3. DEBUGGING STEP: Print the paths to the console so you can verify them.
console.log('--- Looking for files ---');
console.log(`Service Account Key Path: ${keyFilePath}`);
console.log(`Recipe Data Path: ${dataFilePath}`);
console.log('--------------------------');

// 4. Check if the service account key file exists BEFORE trying to use it.
if (!fs.existsSync(keyFilePath)) {
  console.error('❌ FATAL ERROR: Service account key file not found at the path above.');
  console.error('Please make sure your "firebase-key.json" file is in the SAME FOLDER as this script.');
  process.exit(1); // Exit the script if the key file is missing.
}

// 5. Load the service account key from the file.
const serviceAccount = JSON.parse(fs.readFileSync(keyFilePath, 'utf8'));

// 6. Initialize the Firebase Admin App.
//    I have already filled in your project ID from the screenshot.
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: `https://climateshield-app.firebaseio.com`
});

// 7. Get a reference to your Firestore database.
const db = admin.firestore();
const collectionName = 'recipes';

// --- END OF SETUP ---


// 8. Define the main function to upload the data.
async function uploadData() {
  try {
    // Read the JSON file from your computer.
    const rawData = fs.readFileSync(dataFilePath, 'utf8');
    const recipes = JSON.parse(rawData);

    if (!Array.isArray(recipes)) {
      throw new Error('Data is not an array. Please check your JSON file format.');
    }

    console.log(`Found ${recipes.length} recipes. Starting upload to '${collectionName}'...`);

    // Use a batch write for efficiency. This groups multiple operations into one.
    const batch = db.batch();

    recipes.forEach(recipe => {
      // For each recipe in your file, create a new document in the 'recipes' collection.
      const docRef = db.collection(collectionName).doc();
      batch.set(docRef, recipe);
    });

    // Commit the batch to Firestore.
    await batch.commit();

    console.log('--------------------------------------');
    console.log('✅ Success! All recipes have been uploaded.');
    console.log('--------------------------------------');

  } catch (error) {
    console.error('❌ Error uploading data:', error);
  }
}

// 9. Run the upload function.
uploadData();