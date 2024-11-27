import 'package:final_project/pages/chef.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> recommendedChefs;

  const SearchPage({super.key, required this.recommendedChefs});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  String _sortBy = 'Rating';

  List<Map<String, dynamic>> getFilteredChefs() {
    List<Map<String, dynamic>> filteredChefs = widget.recommendedChefs;

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      filteredChefs = filteredChefs.where((chef) {
        final query = _searchQuery.toLowerCase();
        return chef['name'].toLowerCase().contains(query) ||
            chef['cuisine'].toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    if (_sortBy == 'Rating') {
      filteredChefs.sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (_sortBy == 'Name') {
      filteredChefs.sort((a, b) => a['name'].compareTo(b['name']));
    }

    return filteredChefs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: const Text('Search Chefs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by name or cuisine',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sort By Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Sort by: '),
                DropdownButton<String>(
                  value: _sortBy,
                  items: ['Rating', 'Name'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _sortBy = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Filtered Chefs List
            Expanded(
              child: ListView.builder(
                itemCount: getFilteredChefs().length,
                itemBuilder: (context, index) {
                  final chef = getFilteredChefs()[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to ChefPage with selected chef details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChefPage(chef: chef),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            chef['photo'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50, color: Colors.red);
                            },
                          ),
                        ),
                        title: Text(chef['name']),
                        subtitle: Text(
                          'Cuisine: ${chef['cuisine']}\n'
                          'Rating: ${chef['rating']} ⭐',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
