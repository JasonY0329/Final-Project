import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reservation_detail_page.dart';
import 'user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';

class ReservationTabs extends StatefulWidget {
  final String userId;

  const ReservationTabs({super.key, required this.userId});

  @override
  _ReservationTabsState createState() => _ReservationTabsState();
}

class _ReservationTabsState extends State<ReservationTabs> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    FirebaseFirestore.instance.collection('orders').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['userId'] is! String) {
          FirebaseFirestore.instance.collection('orders').doc(doc.id).update({
            'userId': data['userId'].toString(),
          });
        }
      }
    });
    _pages = [
      UpcomingReservationPage(userId: widget.userId),
      PastReservationPage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
         onPressed: () async {
          // Fetch user data from Firestore
          final userId = FirebaseAuth.instance.currentUser!.uid;
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

          if (userDoc.exists && userDoc.data() != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(userData: userDoc.data()!),
              ),
              (Route<dynamic> route) => false, // Remove all previous routes
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load user data')),
            );
          }
        },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .get();

              if (userDoc.exists && userDoc.data() != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      userData: userDoc.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User data not found')),
                );
              }
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.upcoming),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Past',
          ),
        ],
      ),
    );
  }
}

class UpcomingReservationPage extends StatelessWidget {
  final String userId;

  const UpcomingReservationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('reservationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .orderBy('reservationDate')
          .snapshots(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Error fetching reservations: ${snapshot.error}');
          return const Center(
            
            child: Text(
              'Something went wrong. Please try again later.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }
        print('Querying with userId: $userId');
        // Handle connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Explicitly check if data is empty
        final reservations = snapshot.data?.docs ?? [];
        // Debugging Output
        print('Reservations Fetched: ${reservations.map((doc) => doc.data()).toList()}');
        if (reservations.isEmpty) {
          return const Center(
            child: Text(
              'No upcoming reservations.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Debugging Output
        print('Reservations Fetched: ${reservations.map((doc) => doc.data()).toList()}');

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return _buildReservationCard(context, reservation);
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );

  }

  Widget _buildReservationCard(
    BuildContext context, QueryDocumentSnapshot reservation) {
    final reservationData = reservation.data() as Map<String, dynamic>;
    final Timestamp reservationTimestamp = reservationData['reservationDate'];
    final DateTime reservationDateTime = reservationTimestamp.toDate();
    final orderAddress = reservationData['address'] ?? 'Unknown';
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chef: ${reservationData['chefName']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${reservationDateTime.toLocal().toIso8601String().split('T')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${reservationDateTime.toLocal().hour}:${reservationDateTime.toLocal().minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Address: ${reservationData['address'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetailPage(
                      reservation: reservationData,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
class PastReservationPage extends StatelessWidget {
  final String userId;

  const PastReservationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId) // Filter by userId
          .where('reservationDate', isLessThanOrEqualTo: Timestamp.fromDate(now)) // Filter past reservations
          .orderBy('reservationDate', descending: true) // Order by date
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Debugging output
          print('Error fetching past reservations: ${snapshot.error}');
          return const Center(
            child: Text(
              'Something went wrong. Please try again later.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No past reservations.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final reservations = snapshot.data!.docs;

        // Debugging output
        print('Past Reservations Fetched: ${reservations.map((doc) => doc.data()).toList()}');

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return PastReservationCard(
              reservation: reservation.data() as Map<String, dynamic>,
              onRatingChanged: (newRating) {
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(reservation.id)
                    .update({'rating': newRating});
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }
}


class PastReservationCard extends StatefulWidget {
  final Map<String, dynamic> reservation;
  final ValueChanged<int> onRatingChanged;

  const PastReservationCard({
    super.key,
    required this.reservation,
    required this.onRatingChanged,
  });

  @override
  _PastReservationCardState createState() => _PastReservationCardState();
}

class _PastReservationCardState extends State<PastReservationCard> {
  int currentRating = 0;

  @override
  void initState() {
    super.initState();
    currentRating = widget.reservation['rating'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;

    final chefName = reservation['chefName'] ?? 'Unknown Chef';
    //final reservationDate = reservation['reservationDate'] ?? 'Unknown Date';
    //final reservationTime = reservation['reservationTime'] ?? 'Unknown Time';
    final orderAddress = reservation['address'] ?? 'Unknown';
    final Timestamp reservationTimestamp = reservation['reservationDate'];
    final DateTime reservationDateTime = reservationTimestamp.toDate();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chef: $chefName',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${reservationDateTime.toLocal().toIso8601String().split('T')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${reservationDateTime.toLocal().hour}:${reservationDateTime.toLocal().minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Address: $orderAddress',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rate Your Experience:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < currentRating ? Icons.star : Icons.star_border,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            currentRating = index + 1;
                          });
                          widget.onRatingChanged(currentRating);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationDetailPage(
                      reservation: reservation,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
