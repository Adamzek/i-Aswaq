import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Add user data
  Future<void> addUser(String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print('Add user error: $e');
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).update(userData);
    } catch (e) {
      print('Update user error: $e');
    }
  }

  // Add listing
  Future<String?> addListing(Map<String, dynamic> listingData) async {
    try {
      DocumentReference doc = await firestore
          .collection('listings')
          .add(listingData);
      return doc.id;
    } catch (e) {
      print('Add listing error: $e');
      return null;
    }
  }

  // Get all listings
  Future<List<Map<String, dynamic>>> getListings() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('listings').get();
      List<Map<String, dynamic>> listings = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        listings.add(data);
      }
      return listings;
    } catch (e) {
      print('Get listings error: $e');
      return [];
    }
  }

  // Get listing by id
  Future<Map<String, dynamic>?> getListing(String listingId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('listings')
          .doc(listingId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Get listing error: $e');
      return null;
    }
  }

  // Update listing
  Future<void> updateListing(
    String listingId,
    Map<String, dynamic> listingData,
  ) async {
    try {
      await firestore.collection('listings').doc(listingId).update(listingData);
    } catch (e) {
      print('Update listing error: $e');
    }
  }

  // Delete listing
  Future<void> deleteListing(String listingId) async {
    try {
      await firestore.collection('listings').doc(listingId).delete();
    } catch (e) {
      print('Delete listing error: $e');
    }
  }

  // Send message
  Future<void> sendMessage(
    String chatId,
    Map<String, dynamic> messageData,
  ) async {
    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      print('Send message error: $e');
    }
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Create chat
  Future<String?> createChat(Map<String, dynamic> chatData) async {
    try {
      DocumentReference doc = await firestore.collection('chats').add(chatData);
      return doc.id;
    } catch (e) {
      print('Create chat error: $e');
      return null;
    }
  }

  // Get user chats
  Future<List<Map<String, dynamic>>> getUserChats(String userId) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .get();
      List<Map<String, dynamic>> chats = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        chats.add(data);
      }
      return chats;
    } catch (e) {
      print('Get user chats error: $e');
      return [];
    }
  }

  // Save user settings
  Future<void> saveUserSettings(
    String userId,
    Map<String, dynamic> settings,
  ) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'settings': settings,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Save user settings error: $e');
    }
  }

  // Get user settings
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return data?['settings'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Get user settings error: $e');
      return null;
    }
  }
}
