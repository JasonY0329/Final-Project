import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/pages/MapAddressPicker.dart';
import 'package:final_project/pages/chef.dart';
import 'package:final_project/pages/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'reservation_tabs.dart';
import 'user_profile_page.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key, required this.userData});
  final Map<String, dynamic> userData;
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _currentAddress = "Set your address here";
  String _searchQuery = '';
  final String _selectedCuisine = 'All';
  bool _isLoadingChefs = true;
  List<Map<String, dynamic>> recommendedChefs = [];

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
    _fetchRecommendedChefs();
  }

  Future<void> _fetchUserAddress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          if (userData != null && userData.containsKey('address')) {
            setState(() {
              _currentAddress = userData['address'] ?? "Address not available";
            });
          }
        }
      } else {
        setState(() {
          _currentAddress = "User not signed in";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Error fetching address";
      });
    }
  }

  Future<void> _fetchRecommendedChefs() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('chefs').get();
      final List<Map<String, dynamic>> chefs = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': data['name'] ?? 'Unknown',
          'rating': data['rating']?.toDouble() ?? 0.0,
          'specialty': data['specialty'] ?? 'Unknown',
          'cuisine': data['cuisine'] ?? 'Unknown',
          'photo': data['photo'] ?? '',
        };
      }).toList();

      setState(() {
        recommendedChefs = chefs;
        _isLoadingChefs = false; // Set loading to false after fetching
      });
    } catch (e) {
      setState(() {
        _isLoadingChefs = false; // Set loading to false even on error
      });
      print('Error fetching chefs: $e');
    }
  }

  // Handle Bottom Navigation Bar Taps
  void _onItemTapped(int index) {
    
  if (index == 1) {
    // Navigate to SearchPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(recommendedChefs: recommendedChefs),
      ),
    );
  } else if (index == 2) {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationTabs(userId: userId),
      ),
    );
  } else {
    // Handle the null userId case
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User is not signed in.')),
    );
  }
}
 else if (index == 3) {
    // Navigate to UserProfilePage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(userData: widget.userData),
      ),
    ).then((updatedData) {
      if (updatedData != null) {
        setState(() {
          widget.userData.addAll(updatedData); // Update user data after changes
        });
      }
});
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
              const Icon(Icons.location_on, color: Colors.blue, size: 18),
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
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;

              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationTabs(userId: userId),
                  ),
                );
              } else {
                // Handle the case where the user is not signed in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User is not signed in.')),
                );
              }
            },
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
  final user = FirebaseAuth.instance.currentUser;
  LatLng initialPosition;

  try {
    if (user != null) {
      // Fetch the current user's address from Firestore
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        if (userData != null && userData.containsKey('address')) {
          // Use geocoding to convert the address to LatLng
          final String currentAddress = userData['address'];
          List<Location> locations = await locationFromAddress(currentAddress);
          initialPosition = LatLng(locations.first.latitude, locations.first.longitude);
        } else {
          // Default position if no address is found
          initialPosition = const LatLng(37.7749, -122.4194); // San Francisco coordinates
        }
      } else {
        initialPosition = const LatLng(37.7749, -122.4194);
      }
    } else {
      initialPosition = const LatLng(37.7749, -122.4194);
    }
  } catch (e) {
    // Fallback to default position in case of an error
    initialPosition = const LatLng(37.7749, -122.4194);
  }

  // Open the MapAddressPicker with the initial position
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapAddressPicker(initialPosition: initialPosition),
    ),
  );

  if (result != null) {
    String selectedAddress = result['address'];

    // Save to Firebase
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'address': selectedAddress});
    }

    // Update local data
    setState(() {
      _currentAddress = selectedAddress;
      widget.userData['address'] = selectedAddress;
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
