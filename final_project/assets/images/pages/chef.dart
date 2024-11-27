import 'package:flutter/material.dart';

class ChefPage extends StatelessWidget {
  final Map<String, dynamic> chef;

  ChefPage({super.key, required this.chef});

  final Map<String, List<String>> dishes = {
    '2-4': ['Starter (Option A)', 'Main Dish (Option B)', 'Dessert (Option C)'],
    '4-6': [
      'Starter (Option A)',
      'Soup (Option B)',
      'Main Dish 1 (Option C)',
      'Main Dish 2 (Option D)',
      'Dessert (Option E)'
    ],
    '6-8': [
      'Appetizer (Option A)',
      'Soup (Option B)',
      'Main Dish 1 (Option C)',
      'Main Dish 2 (Option D)',
      'Main Dish 3 (Option E)',
      'Side Dish (Option F)',
      'Dessert (Option G)'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chef['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chef Photo and Details
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      chef['photo'], // Load chef image dynamically
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 150, color: Colors.red);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    chef['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chef['cuisine'],
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rating: ${chef['rating']} ⭐',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Experience: ${chef['experience']} years',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dish Packages
            for (final package in dishes.keys) ...[
              Text(
                'Package for $package Persons',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: dishes[package]!
                    .map((dish) => ListTile(
                          title: Text(dish),
                          subtitle: Text('Options available for $package persons'),
                          trailing: const Icon(Icons.comment, color: Colors.grey),
                          onTap: () {
                            _showCommentDialog(context, dish);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Customer Reviews Section
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (chef['reviews'] != null && chef['reviews'].isNotEmpty)
              Column(
                children: chef['reviews']
                    .map<Widget>((review) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(review['user']),
                            subtitle: Text(review['comment']),
                            trailing: Text('${review['rating']} ⭐'),
                          ),
                        ))
                    .toList(),
              )
            else
              const Text(
                'No reviews available yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context, String dish) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Comment on $dish'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String comment = commentController.text;
                if (comment.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your comment: "$comment" was submitted!')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
