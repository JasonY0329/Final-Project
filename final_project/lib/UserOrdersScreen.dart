import 'package:flutter/material.dart';
import 'firestore_helper.dart';

class UserOrdersScreen extends StatelessWidget {
  final String userId = "vwJNRr1J4YnA703zZJkz"; // Example userId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Orders"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserWithOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final user = snapshot.data!['user'];
            final orders = snapshot.data!['orders'] as List;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Name: ${user['name']}\nAddress: ${user['address']}\nPhone: ${user['phoneNumber']}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return ListTile(
                        title: Text("Items: ${order['items']}"),
                        subtitle: Text("Status: ${order['status']}"),
                        trailing: Text("Total: \$${order['total']}"),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getUserWithOrders(String userId) async {
    final user = await getUser(userId);
    final orders = await getOrdersByUser(userId);

    if (user != null) {
      return {
        'user': user,
        'orders': orders,
      };
    } else {
      throw Exception('User not found');
    }
  }
}