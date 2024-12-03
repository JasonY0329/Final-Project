import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationDetailPage extends StatelessWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetailPage({required this.reservation});

  @override
  Widget build(BuildContext context) {
    // Safely extract fields with fallback defaults
    final chefName = reservation['chefName'] ?? 'Unknown Chef';
    final chefImage = reservation['chefPhoto'] ?? ''; // Use an empty string if no image is provided
    final Timestamp reservationTimestamp = reservation['reservationDate'];
    final DateTime reservationDateTime = reservationTimestamp.toDate();
    final address = reservation['address'] ?? 'Unknown Address';
    final dishes = reservation['selectedDishes'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: chefImage.isNotEmpty
                      ? Image.network(
                          chefImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 150, color: Colors.grey);
                          },
                        )
                      : const Icon(Icons.person, size: 150, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Chef: $chefName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Date: $reservationDateTime',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              
              const SizedBox(height: 8),
              Text(
                'Address: $address',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ordered Dishes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              dishes.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dishes.entries.map<Widget>((entry) {
                        final category = entry.key;
                        final items = List<String>.from(entry.value);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$category:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...items.map(
                              (dish) => Padding(
                                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                                child: Text(
                                  '- $dish',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    )
                  : const Text(
                      'No dishes ordered.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
              const SizedBox(height: 16),
              Text(
                'Total Price: \$${reservation['totalPrice']?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
