import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerResult {
  final String? path;
  final String? name;
  final List<int>? bytes;
  final int? size;

  ImagePickerResult({
    this.path,
    this.name,
    this.bytes,
    this.size,
  });
}

class ImagePickerService {
  static final ImagePickerService _instance = ImagePickerService._internal();
  factory ImagePickerService() => _instance;
  ImagePickerService._internal();

  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from gallery or camera
  Future<ImagePickerResult?> pickImage({
    ImageSource source = ImageSource.gallery,
    int? maxWidth,
    int? maxHeight,
    int imageQuality = 85,
  }) async {
    try {
      if (kIsWeb) {
        // Use file_picker for web
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.single.bytes != null) {
          final file = result.files.single;
          return ImagePickerResult(
            path: 'web://${file.name}', // Placeholder path for web
            name: file.name,
            bytes: file.bytes,
            size: file.size,
          );
        }
        return null;
      } else {
        // Use image_picker for mobile
        final XFile? image = await _imagePicker.pickImage(
          source: source,
          maxWidth: maxWidth?.toDouble(),
          maxHeight: maxHeight?.toDouble(),
          imageQuality: imageQuality,
        );

        if (image != null) {
          return ImagePickerResult(
            path: image.path,
            name: image.name,
          );
        }
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Pick image from gallery (convenience method)
  Future<ImagePickerResult?> pickFromGallery({
    int? maxWidth,
    int? maxHeight,
    int imageQuality = 85,
  }) async {
    return pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  /// Pick image from camera (convenience method)
  Future<ImagePickerResult?> pickFromCamera({
    int? maxWidth,
    int? maxHeight,
    int imageQuality = 85,
  }) async {
    return pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }
}
