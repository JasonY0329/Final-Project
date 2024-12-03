import 'package:cloud_firestore/cloud_firestore.dart';

// functions for User
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

Future<void> createUser(String userId, Map<String, dynamic> userData) async {
  final userDoc = FirebaseFirestore.instance.collection('User').doc(userId);

  try {
    await userDoc.set(userData);
    print('User created successfully');
  } catch (e) {
    print('Error creating user: $e');
  }
}

Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
  final userDoc = FirebaseFirestore.instance.collection('User').doc(userId);

  try {
    await userDoc.update(updatedData);
    print('User updated successfully');
  } catch (e) {
    print('Error updating user: $e');
  }
}

Future<void> deleteUser(String userId) async {
  final userDoc = FirebaseFirestore.instance.collection('User').doc(userId);

  try {
    await userDoc.delete();
    print('User deleted successfully');
  } catch (e) {
    print('Error deleting user: $e');
  }
}


// functions for Order
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

Future<void> createOrder(Map<String, dynamic> orderData) async {
  final orderCollection = FirebaseFirestore.instance.collection('Order');

  try {
    await orderCollection.add(orderData);
    print('Order created successfully');
  } catch (e) {
    print('Error creating order: $e');
  }
}

Future<void> updateOrder(String orderId, Map<String, dynamic> updatedData) async {
  final orderDoc = FirebaseFirestore.instance.collection('Order').doc(orderId);

  try {
    await orderDoc.update(updatedData);
    print('Order updated successfully');
  } catch (e) {
    print('Error updating order: $e');
  }
}

Future<void> deleteOrder(String orderId) async {
  final orderDoc = FirebaseFirestore.instance.collection('Order').doc(orderId);

  try {
    await orderDoc.delete();
    print('Order deleted successfully');
  } catch (e) {
    print('Error deleting order: $e');
  }
}