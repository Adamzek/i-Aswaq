import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Upload profile image
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      String path = 'profile_images/$userId.jpg';
      Reference ref = storage.ref().child(path);
      UploadTask task = ref.putFile(imageFile);
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload profile image error: $e');
      return null;
    }
  }

  // Upload item image
  Future<String?> uploadItemImage(String listingId, File imageFile) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String path = 'item_images/$listingId/$timestamp.jpg';
      Reference ref = storage.ref().child(path);
      UploadTask task = ref.putFile(imageFile);
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload item image error: $e');
      return null;
    }
  }

  // Upload multiple item images
  Future<List<String>> uploadMultipleItemImages(String listingId, List<File> imageFiles) async {
    List<String> downloadUrls = [];
    for (File imageFile in imageFiles) {
      String? url = await uploadItemImage(listingId, imageFile);
      if (url != null) {
        downloadUrls.add(url);
      }
    }
    return downloadUrls;
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Delete image error: $e');
    }
  }

  // Delete multiple images
  Future<void> deleteMultipleImages(List<String> imageUrls) async {
    for (String url in imageUrls) {
      await deleteImage(url);
    }
  }
}
