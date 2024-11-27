import 'package:cloud_firestore/cloud_firestore.dart';

// Fetch user data
Future<Map<String, dynamic>?> getUser(String userId) async {
  final userDoc = FirebaseFirestore.instance.collection('User').doc(userId);

  try {
    final snapshot = await userDoc.get();
    if (snapshot.exists) {
      return snapshot.data();
    }
  } catch (e) {
    print('Error fetching user: $e');
  }
  return null;
}

// Fetch orders for a specific user
Future<List<Map<String, dynamic>>> getOrdersByUser(String userId) async {
  final orderCollection = FirebaseFirestore.instance.collection('Order');

  try {
    final snapshot = await orderCollection.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching orders: $e');
    return [];
  }
}