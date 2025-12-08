const functions = require("firebase-functions");
const axios = require("axios");

exports.scanFood = functions.https.onCall(async (data) => {
  const imageUrl = data.imageUrl;

  const BASE_URL = functions.config().backend.url;

  try {
    const response = await axios.post(
      `${BASE_URL}/scan`,
      { imageUrl: imageUrl }
    );

    return response.data;

  } catch (error) {
    return { error: error.message };
  }
});
