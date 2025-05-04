import 'dart:convert'; // Import for encoding and decoding JSON
import 'dart:io'; // Import for file handling

import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import for accessing environment variables
import 'package:http/http.dart' as http; // Import for making HTTP requests

class CloudinaryService {
  // Static method to upload an image to Cloudinary
  static Future<String?> uploadImage(File imageFile) async {
    // Get the Cloudinary cloud name and upload preset from the environment variables
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

    // If the environment variables are missing, throw an exception
    if (cloudName == null || uploadPreset == null) {
      throw Exception('Cloudinary config missing');
    }

    // Construct the Cloudinary upload URL using the cloud name
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    try {
      // Create a multipart HTTP request for uploading the image
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset // Add the upload preset to the fields
        ..files.add(
          await http.MultipartFile.fromPath('file', imageFile.path), // Add the image file to the request
        );

      // Send the request and wait for the response
      final response = await request.send();

      // Convert the response stream to a string (the JSON response from Cloudinary)
      final resStream = await response.stream.bytesToString();

      // Decode the JSON response
      final resData = json.decode(resStream);

      // Check if the upload was successful (status code 200)
      if (response.statusCode == 200) {
        // Return the secure URL of the uploaded image
        return resData['secure_url'];
      } else {
        // If there was an error, print the response data and return null
        print('Upload Error Response: $resData');
        return null;
      }
    } catch (e) {
      // If an exception occurs (e.g., network issues), print the error and return null
      print('Upload Exception: $e');
      return null;
    }
  }
}
