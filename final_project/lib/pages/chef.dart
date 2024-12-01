import 'package:flutter/material.dart';

class ChefPage extends StatelessWidget {
  final Map<String, dynamic> chef;

  ChefPage({super.key, required this.chef});

  final Map<String, Map<String, Map<String, dynamic>>> chefDishes = {
    'British': {
    '2-4': {
      'price': 50.0,
      'categories': {
        'Starter': {'options': ['Scotch Egg', 'Welsh Rarebit', 'Prawn Cocktail'], 'max': 1},
        'Main Dish': {'options': ['Fish and Chips', 'Shepherd’s Pie', 'Beef Wellington'], 'max': 1},
        'Dessert': {'options': ['Spotted Dick', 'Treacle Tart', 'Victoria Sponge'], 'max': 1},
      },
    },
    '4-6': {
      'price': 80.0,
      'categories': {
        'Starter': {'options': ['Scotch Egg', 'Welsh Rarebit', 'Prawn Cocktail'], 'max': 1},
        'Soup': {'options': ['Pea and Ham Soup', 'Leek and Potato Soup', 'Cock-a-Leekie Soup'], 'max': 1},
        'Main Dish': {'options': ['Fish and Chips', 'Shepherd’s Pie', 'Beef Wellington'], 'max': 2},
        'Dessert': {'options': ['Spotted Dick', 'Treacle Tart', 'Victoria Sponge'], 'max': 1},
      },
    },
    '6-8': {
      'price': 120.0,
      'categories': {
        'Starter': {'options': ['Scotch Egg', 'Welsh Rarebit', 'Prawn Cocktail'], 'max': 1},
        'Soup': {'options': ['Pea and Ham Soup', 'Leek and Potato Soup', 'Cock-a-Leekie Soup'], 'max': 1},
        'Main Dish': {'options': ['Fish and Chips', 'Shepherd’s Pie', 'Beef Wellington'], 'max': 3},
        'Dessert': {'options': ['Spotted Dick', 'Treacle Tart', 'Victoria Sponge'], 'max': 2},
      },
    },
  },

  // French Cuisine
  'French': {
    '2-4': {
      'price': 50.0,
      'categories': {
        'Starter': {'options': ['Quiche Lorraine', 'Escargots', 'Onion Tart'], 'max': 1},
        'Main Dish': {'options': ['Coq au Vin', 'Bouillabaisse', 'Beef Bourguignon'], 'max': 1},
        'Dessert': {'options': ['Crème Brûlée', 'Tarte Tatin', 'Macarons'], 'max': 1},
      },
    },
    '4-6': {
      'price': 80.0,
      'categories': {
        'Starter': {'options': ['Quiche Lorraine', 'Escargots', 'Onion Tart'], 'max': 1},
        'Soup': {'options': ['French Onion Soup', 'Potage Parmentier', 'Bouillabaisse'], 'max': 1},
        'Main Dish': {'options': ['Coq au Vin', 'Bouillabaisse', 'Beef Bourguignon'], 'max': 2},
        'Dessert': {'options': ['Crème Brûlée', 'Tarte Tatin', 'Macarons'], 'max': 1},
      },
    },
    '6-8': {
      'price': 120.0,
      'categories': {
        'Starter': {'options': ['Quiche Lorraine', 'Escargots', 'Onion Tart'], 'max': 1},
        'Soup': {'options': ['French Onion Soup', 'Potage Parmentier', 'Bouillabaisse'], 'max': 1},
        'Main Dish': {'options': ['Coq au Vin', 'Bouillabaisse', 'Beef Bourguignon'], 'max': 3},
        'Dessert': {'options': ['Crème Brûlée', 'Tarte Tatin', 'Macarons'], 'max': 2},
      },
    },
  },

  // Italian Cuisine
  'Italian': {
    '2-4': {
      'price': 50.0,
      'categories': {
        'Starter': {'options': ['Bruschetta', 'Caprese Salad', 'Garlic Bread'], 'max': 1},
        'Main Dish': {'options': ['Spaghetti Carbonara', 'Lasagna', 'Risotto'], 'max': 1},
        'Dessert': {'options': ['Tiramisu', 'Panna Cotta', 'Cannoli'], 'max': 1},
      },
    },
    '4-6': {
      'price': 80.0,
      'categories': {
        'Starter': {'options': ['Bruschetta', 'Caprese Salad', 'Garlic Bread'], 'max': 1},
        'Soup': {'options': ['Minestrone', 'Tomato Basil Soup', 'Zuppa Toscana'], 'max': 1},
        'Main Dish': {'options': ['Spaghetti Carbonara', 'Lasagna', 'Risotto'], 'max': 2},
        'Dessert': {'options': ['Tiramisu', 'Panna Cotta', 'Cannoli'], 'max': 1},
      },
    },
    '6-8': {
      'price': 120.0,
      'categories': {
        'Starter': {'options': ['Bruschetta', 'Caprese Salad', 'Garlic Bread'], 'max': 1},
        'Soup': {'options': ['Minestrone', 'Tomato Basil Soup', 'Zuppa Toscana'], 'max': 1},
        'Main Dish': {'options': ['Spaghetti Carbonara', 'Lasagna', 'Risotto'], 'max': 3},
        'Dessert': {'options': ['Tiramisu', 'Panna Cotta', 'Cannoli'], 'max': 2},
      },
    },
  },

  // Chinese Cuisine
  'Chinese': {
    '2-4': {
      'price': 50.0,
      'categories': {
        'Starter': {'options': ['Spring Rolls', 'Dumplings', 'Hot and Sour Soup'], 'max': 1},
        'Main Dish': {'options': ['Kung Pao Chicken', 'Sweet and Sour Pork', 'Fried Rice'], 'max': 1},
        'Dessert': {'options': ['Mango Pudding', 'Sesame Balls', 'Egg Tarts'], 'max': 1},
      },
    },
    '4-6': {
      'price': 80.0,
      'categories': {
        'Starter': {'options': ['Spring Rolls', 'Dumplings', 'Hot and Sour Soup'], 'max': 1},
        'Soup': {'options': ['Wonton Soup', 'Hot and Sour Soup', 'Egg Drop Soup'], 'max': 1},
        'Main Dish': {'options': ['Kung Pao Chicken', 'Sweet and Sour Pork', 'Fried Rice'], 'max': 2},
        'Dessert': {'options': ['Mango Pudding', 'Sesame Balls', 'Egg Tarts'], 'max': 1},
      },
    },
    '6-8': {
      'price': 120.0,
      'categories': {
        'Starter': {'options': ['Spring Rolls', 'Dumplings', 'Hot and Sour Soup'], 'max': 1},
        'Soup': {'options': ['Wonton Soup', 'Hot and Sour Soup', 'Egg Drop Soup'], 'max': 1},
        'Main Dish': {'options': ['Kung Pao Chicken', 'Sweet and Sour Pork', 'Fried Rice'], 'max': 3},
        'Dessert': {'options': ['Mango Pudding', 'Sesame Balls', 'Egg Tarts'], 'max': 2},
      },
    },
  },

  // Indian Cuisine
  'Indian': {
    '2-4': {
      'price': 50.0,
      'categories': {
        'Starter': {'options': ['Samosa', 'Paneer Tikka', 'Aloo Tikki'], 'max': 1},
        'Main Dish': {'options': ['Butter Chicken', 'Paneer Butter Masala', 'Biryani'], 'max': 1},
        'Dessert': {'options': ['Gulab Jamun', 'Rasgulla', 'Kheer'], 'max': 1},
      },
    },
    '4-6': {
      'price': 80.0,
      'categories': {
        'Starter': {'options': ['Samosa', 'Paneer Tikka', 'Aloo Tikki'], 'max': 1},
        'Soup': {'options': ['Dal Shorba', 'Tomato Soup', 'Mulligatawny'], 'max': 1},
        'Main Dish': {'options': ['Butter Chicken', 'Paneer Butter Masala', 'Biryani'], 'max': 2},
        'Dessert': {'options': ['Gulab Jamun', 'Rasgulla', 'Kheer'], 'max': 1},
      },
    },
    '6-8': {
      'price': 120.0,
      'categories': {
        'Starter': {'options': ['Samosa', 'Paneer Tikka', 'Aloo Tikki'], 'max': 1},
        'Soup': {'options': ['Dal Shorba', 'Tomato Soup', 'Mulligatawny'], 'max': 1},
        'Main Dish': {'options': ['Butter Chicken', 'Paneer Butter Masala', 'Biryani'], 'max': 3},
        'Dessert': {'options': ['Gulab Jamun', 'Rasgulla', 'Kheer'], 'max': 2},
      },
    },
  },
    'Spanish': {
      '2-4': {
        'price': 50.0,
        'categories': {
          'Starter': {'options': ['Patatas Bravas', 'Croquettes', 'Pan con Tomate'], 'max': 1},
          'Main Dish': {'options': ['Paella', 'Tortilla Española', 'Chorizo al Vino'], 'max': 1},
          'Dessert': {'options': ['Churros', 'Flan', 'Tarta de Santiago'], 'max': 1},
        },
      },
      '4-6': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Patatas Bravas', 'Croquettes', 'Pan con Tomate'], 'max': 1},
          'Soup': {'options': ['Gazpacho', 'Caldo Gallego', 'Sopa de Ajo'], 'max': 1},
          'Main Dish': {'options': ['Paella', 'Tortilla Española', 'Chorizo al Vino'], 'max': 2},
          'Dessert': {'options': ['Churros', 'Flan', 'Tarta de Santiago'], 'max': 1},
        },
      },
      '6-8': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Patatas Bravas', 'Croquettes', 'Pan con Tomate'], 'max': 1},
          'Soup': {'options': ['Gazpacho', 'Caldo Gallego', 'Sopa de Ajo'], 'max': 1},
          'Main Dish': {'options': ['Paella', 'Tortilla Española', 'Chorizo al Vino'], 'max': 3},
          'Dessert': {'options': ['Churros', 'Flan', 'Tarta de Santiago'], 'max': 2},
        },
      },
    },
    'Mexican': {
      '2-4': {
        'price': 50.0,
        'categories': {
          'Starter': {'options': ['Nachos', 'Guacamole', 'Quesadilla'], 'max': 1},
          'Main Dish': {'options': ['Tacos', 'Enchiladas', 'Burritos'], 'max': 1},
          'Dessert': {'options': ['Churros', 'Flan de Coco', 'Tres Leches Cake'], 'max': 1},
        },
      },
      '4-6': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Nachos', 'Guacamole', 'Quesadilla'], 'max': 1},
          'Soup': {'options': ['Tortilla Soup', 'Pozole', 'Sopa Azteca'], 'max': 1},
          'Main Dish': {'options': ['Tacos', 'Enchiladas', 'Burritos'], 'max': 2},
          'Dessert': {'options': ['Churros', 'Flan de Coco', 'Tres Leches Cake'], 'max': 1},
        },
      },
      '6-8': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Nachos', 'Guacamole', 'Quesadilla'], 'max': 1},
          'Soup': {'options': ['Tortilla Soup', 'Pozole', 'Sopa Azteca'], 'max': 1},
          'Main Dish': {'options': ['Tacos', 'Enchiladas', 'Burritos'], 'max': 3},
          'Dessert': {'options': ['Churros', 'Flan de Coco', 'Tres Leches Cake'], 'max': 2},
        },
      },
    },
    'American': {
      '2-4': {
        'price': 50.0,
        'categories': {
          'Starter': {'options': ['Buffalo Wings', 'Loaded Potato Skins', 'Mini Sliders'], 'max': 1},
          'Main Dish': {'options': ['Burgers', 'Fried Chicken', 'BBQ Ribs'], 'max': 1},
          'Dessert': {'options': ['Apple Pie', 'Brownies', 'Cheesecake'], 'max': 1},
        },
      },
      '4-6': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Buffalo Wings', 'Loaded Potato Skins', 'Mini Sliders'], 'max': 1},
          'Soup': {'options': ['Clam Chowder', 'Chicken Noodle Soup', 'Chili'], 'max': 1},
          'Main Dish': {'options': ['Burgers', 'Fried Chicken', 'BBQ Ribs'], 'max': 2},
          'Dessert': {'options': ['Apple Pie', 'Brownies', 'Cheesecake'], 'max': 1},
        },
      },
      '6-8': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Buffalo Wings', 'Loaded Potato Skins', 'Mini Sliders'], 'max': 1},
          'Soup': {'options': ['Clam Chowder', 'Chicken Noodle Soup', 'Chili'], 'max': 1},
          'Main Dish': {'options': ['Burgers', 'Fried Chicken', 'BBQ Ribs'], 'max': 3},
          'Dessert': {'options': ['Apple Pie', 'Brownies', 'Cheesecake'], 'max': 2},
        },
      },
    },
    'Japanese': {
      '2-4': {
        'price': 50.0,
        'categories': {
          'Starter': {'options': ['Edamame', 'Gyoza', 'Agedashi Tofu'], 'max': 1},
          'Main Dish': {'options': ['Sushi', 'Ramen', 'Chicken Teriyaki'], 'max': 1},
          'Dessert': {'options': ['Mochi', 'Matcha Ice Cream', 'Dorayaki'], 'max': 1},
        },
      },
      '4-6': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Edamame', 'Gyoza', 'Agedashi Tofu'], 'max': 1},
          'Soup': {'options': ['Miso Soup', 'Shoyu Ramen', 'Seaweed Soup'], 'max': 1},
          'Main Dish': {'options': ['Sushi', 'Ramen', 'Chicken Teriyaki'], 'max': 2},
          'Dessert': {'options': ['Mochi', 'Matcha Ice Cream', 'Dorayaki'], 'max': 1},
        },
      },
      '6-8': {
        'price': 80.0,
        'categories': {
          'Starter': {'options': ['Edamame', 'Gyoza', 'Agedashi Tofu'], 'max': 1},
          'Soup': {'options': ['Miso Soup', 'Shoyu Ramen', 'Seaweed Soup'], 'max': 1},
          'Main Dish': {'options': ['Sushi', 'Ramen', 'Chicken Teriyaki'], 'max': 3},
          'Dessert': {'options': ['Mochi', 'Matcha Ice Cream', 'Dorayaki'], 'max': 2},
        },
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    final chefCuisine = chef['cuisine'];
    final packages = chefDishes[chefCuisine];

    return Scaffold(
      appBar: AppBar(
        title: Text(chef['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChefDetails(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: const Text('Select Date and Time'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a Package',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (packages != null)
              for (final package in packages.keys) ...[
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text('Package for $package Persons'),
                    subtitle: Text('Price: \$${packages[package]!['price']}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showPackageDialog(context, package, packages);
                    },
                  ),
                ),
              ]
            else
              const Text(
                'No packages available for this cuisine.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChefDetails() {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              chef['photo'],
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
            chef['specialty'],
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            'Rating: ${chef['rating']} ⭐',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    final DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order scheduled for ${selectedDateTime.toLocal()}',
        ),
      ),
    );
  }

  void _showPackageDialog(BuildContext context, String packageKey, Map<String, dynamic> packages) {
    final package = packages[packageKey];
    final categories = package['categories'] as Map<String, dynamic>;
    final double price = package['price'];
    Map<String, List<String>> selectedDishes = {};

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Package for $packageKey Persons'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Price: \$${price.toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    for (final category in categories.keys) ...[
                      Text(
                        '$category (Select up to ${categories[category]['max']}):',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: (categories[category]['options'] as List<String>)
                            .map((dish) => CheckboxListTile(
                                  title: Text(dish),
                                  value: selectedDishes[category]?.contains(dish) ?? false,
                                  onChanged: (bool? selected) {
                                    setState(() {
                                      selectedDishes[category] ??= [];
                                      if (selected == true) {
                                        if (selectedDishes[category]!.length <
                                            categories[category]['max']) {
                                          selectedDishes[category]!.add(dish);
                                        }
                                      } else {
                                        selectedDishes[category]!.remove(dish);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
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
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You selected dishes for \$${price.toStringAsFixed(2)}.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
