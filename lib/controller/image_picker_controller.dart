import 'package:get/get.dart'; // Import GetX for state management and controller functionality
import 'package:image_picker/image_picker.dart'; // Import ImagePicker for picking images from gallery or camera

class ImagePickerController extends GetxController {
  final ImagePicker picker = ImagePicker(); // Initialize an instance of ImagePicker for picking images

  // Method to pick an image from the gallery
  Future<String> pickImage(ImageSource source) async {
    // Use the ImagePicker instance to open the gallery and pick an image
    final XFile? image = await picker.pickImage(source: source);

    // Check if an image was selected, if so, return its file path
    if (image != null) {
      return image.path; // Return the path to the selected image
    } else {
      return ""; // If no image was selected, return an empty string
    }
  }
}
