import 'package:final_project/pages/MapAddressPicker.dart';
import 'package:final_project/pages/chef.dart';
import 'package:final_project/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _currentAddress = "123 Main St, SF";
  String _searchQuery = '';
  final String _selectedCuisine = 'All';

  // Recommended Chefs List
  final List<Map<String, dynamic>> recommendedChefs = [
    {
      'name': 'Gordon Ramsay',
      'rating': 4.9,
      'specialty': 'British Cuisine',
      'cuisine': 'British',
      'photo': 'assets/images/Gordon Ramsay.jpg',
    },
    {
      'name': 'Nigella Lawson',
      'rating': 4.8,
      'specialty': 'Desserts & Baking',
      'cuisine': 'French',
      'photo': 'assets/images/Nigella Lawson.jpg',
    },
    {
      'name': 'Massimo Bottura',
      'rating': 4.7,
      'specialty': 'Italian Cuisine',
      'cuisine': 'Italian',
      'photo': 'assets/images/Massimo Bottura.jpg',
    },
    {
      'name': 'Anita Lo',
      'rating': 4.6,
      'specialty': 'Chinese Cuisine',
      'cuisine': 'Chinese',
      'photo': 'assets/images/Anita Lo.jpg',
    },
    {
      'name': 'Vikas Khanna',
      'rating': 4.8,
      'specialty': 'Indian Cuisine',
      'cuisine': 'Indian',
      'photo': 'assets/images/Vikas Khanna.jpg',
    },
    {
      'name': 'Enrique Olvera',
      'rating': 4.7,
      'specialty': 'Mexican Cuisine',
      'cuisine': 'Mexican',
      'photo': 'assets/images/Enrique Olvera.jpg',
    },
    {
      'name': 'Alain Ducasse',
      'rating': 4.9,
      'specialty': 'French Haute Cuisine',
      'cuisine': 'French',
      'photo': 'assets/images/Alain Ducasse.jpg',
    },
    {
      'name': 'Nobu Matsuhisa',
      'rating': 4.8,
      'specialty': 'Japanese Fusion',
      'cuisine': 'Japanese',
      'photo': 'assets/images/Nobu Matsuhisa.jpg',
    },
    {
      'name': 'José Andrés',
      'rating': 4.7,
      'specialty': 'Spanish Tapas',
      'cuisine': 'Spanish',
      'photo': 'assets/images/Jose Andres.jpg',
    },
    {
      'name': 'Ming Tsai',
      'rating': 4.6,
      'specialty': 'Asian Fusion',
      'cuisine': 'Chinese',
      'photo': 'assets/images/Ming Tsai.jpg',
    },
    {
      'name': 'Rick Bayless',
      'rating': 4.8,
      'specialty': 'Modern Mexican Cuisine',
      'cuisine': 'Mexican',
      'photo': 'assets/images/Rick Bayless.jpg',
    },
    {
      'name': 'Alice Waters',
      'rating': 4.9,
      'specialty': 'Farm-to-Table Cuisine',
      'cuisine': 'American',
      'photo': 'assets/images/Alice Waters.jpg',
    },
  ];

  // Handle Bottom Navigation Bar Taps
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(recommendedChefs: recommendedChefs),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Filter Chefs Based on Query and Cuisine
  List<Map<String, dynamic>> getFilteredChefs() {
    List<Map<String, dynamic>> filteredChefs = recommendedChefs;

    if (_selectedCuisine != 'All') {
      filteredChefs = filteredChefs
          .where((chef) => chef['cuisine'] == _selectedCuisine)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredChefs = filteredChefs.where((chef) {
        final searchLower = _searchQuery.toLowerCase();
        return chef['name'].toLowerCase().contains(searchLower) ||
            chef['specialty'].toLowerCase().contains(searchLower) ||
            chef['cuisine'].toLowerCase().contains(searchLower);
      }).toList();
    }

    return filteredChefs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _editAddress(context),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search for cuisines, chefs, or dishes',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recommended Chefs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: getFilteredChefs().length,
                    itemBuilder: (context, index) {
                      final chef = getFilteredChefs()[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChefPage(chef: chef),
                            ),
                          );
                        },
                        child: RecommendedChefCard(
                          name: chef['name'],
                          rating: chef['rating'],
                          specialty: chef['specialty'],
                          photo: chef['photo'],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Center(child: Text('Order Screen')),
          const Center(child: Text('Profile Screen')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

void _editAddress(BuildContext context) async {
  // Ensure location permission is granted
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are permanently denied")),
      );
      return;
    } else if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are denied")),
      );
      return;
    }
  }

  // Get current location
  Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  LatLng initialPosition = LatLng(currentPosition.latitude, currentPosition.longitude);

  // Navigate to MapAddressPicker
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapAddressPicker(initialPosition: initialPosition),
    ),
  );

  if (result != null) {
    setState(() {
      _currentAddress = result['address'];
    });
  }
}
}

class RecommendedChefCard extends StatelessWidget {
  final String name;
  final double rating;
  final String specialty;
  final String photo;

  const RecommendedChefCard({
    super.key,
    required this.name,
    required this.rating,
    required this.specialty,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            photo,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        ),
        title: Text(name),
        subtitle: Text('Specialty: $specialty\nRating: $rating'),
        trailing: const Icon(Icons.star, color: Colors.yellow),
      ),
    );
  }
}
