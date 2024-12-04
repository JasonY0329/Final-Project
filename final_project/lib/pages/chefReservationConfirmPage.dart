import 'package:final_project/pages/reservation_tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChefReservationConfirmPage extends StatefulWidget {
  final String chefName;
  final String chefPhoto;
  final Map<String, List<String>> selectedDishes;
  final double totalPrice;
  final String reservationDate;
  final String reservationTime;

  const ChefReservationConfirmPage({
    super.key,
    required this.chefName,
    required this.chefPhoto,
    required this.selectedDishes,
    required this.totalPrice,
    required this.reservationDate,
    required this.reservationTime,
  });

  @override
  _ChefReservationConfirmPageState createState() =>
      _ChefReservationConfirmPageState();
}

class _ChefReservationConfirmPageState
    extends State<ChefReservationConfirmPage> {
  String _cardDetails = 'Credit Card (****1234)'; // Default card details
  String _errorMessage = ''; // For validation error messages
  String _userAddress = 'Loading address...'; // Default address

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          _userAddress = userDoc.data()?['address'] ?? 'Add Your Address';
        });
      }
    }
  }

  Future<void> _saveOrderToFirestore(BuildContext context) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Parse reservationDate and reservationTime into DateTime
      final DateTime parsedDate = DateTime.parse(widget.reservationDate);
      final List<String> timeParts = widget.reservationTime.split(':');
      final int hour = int.parse(timeParts[0].trim());
      final int minute = int.parse(timeParts[1].split(' ')[0].trim());
      final String period = timeParts[1].split(' ')[1].trim();

      // Convert 12-hour time to 24-hour format
      final DateTime fullDateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        period == 'PM' && hour != 12 ? hour + 12 : period == 'AM' && hour == 12 ? 0 : hour,
        minute,
      );

      // Convert DateTime to Timestamp
      final Timestamp reservationTimestamp = Timestamp.fromDate(fullDateTime);

      // Save to Firestore
      CollectionReference orders = FirebaseFirestore.instance.collection('orders');

      await orders.add({
        'userId': userId, // Associate the order with the logged-in user
        'chefName': widget.chefName,
        'chefPhoto': widget.chefPhoto,
        'reservationDate': reservationTimestamp, // Save as Timestamp
        'selectedDishes': widget.selectedDishes,
        'totalPrice': widget.totalPrice,
        'address': _userAddress, // Save address
        'createdAt': FieldValue.serverTimestamp(),
        'rating': 0, // Default rating for past reservations
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation saved successfully!')),
      );

      // Navigate to the reservation tabs page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ReservationTabs(
            userId: userId, // Pass the current user's ID
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save reservation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Confirmation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChefImage(),
              const SizedBox(height: 16),
              _buildHighlightedDateTime(),
              const SizedBox(height: 16),
              const Text(
                'Reservation Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._buildDishItems(),
              const Divider(),
              _buildTotalAmount(),
              const SizedBox(height: 16),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildEditablePaymentMethod(),
              const SizedBox(height: 16),
              const Text(
                'Home Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildEditableAddress(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChefImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          widget.chefPhoto,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 150, color: Colors.red);
          },
        ),
      ),
    );
  }

  Widget _buildHighlightedDateTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservation Date & Time:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            border: Border.all(color: Colors.teal),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.reservationDate,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.reservationTime,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDishItems() {
    List<Widget> dishItems = [];
    widget.selectedDishes.forEach((category, dishes) {
      dishItems.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...dishes.map((dish) => Text(' - $dish')),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
    return dishItems;
  }

  Widget _buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${widget.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEditablePaymentMethod() {
    return InkWell(
      onTap: () => _editPaymentMethod(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1),
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _cardDetails,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.edit, color: Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableAddress() {
    return InkWell(
      onTap: () => _editAddress(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.1),
          border: Border.all(color: Colors.teal),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _userAddress,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.edit, color: Colors.teal),
          ],
        ),
      ),
    );
  }

  void _editAddress(BuildContext context) {
    TextEditingController addressController = TextEditingController(text: _userAddress);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userAddress = addressController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Cancels the reservation
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _saveOrderToFirestore(context); // Saves the reservation and navigates
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  void _editPaymentMethod(BuildContext context) {
    TextEditingController cardController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Payment Method'),
          content: TextField(
            controller: cardController,
            keyboardType: TextInputType.number,
            maxLength: 16,
            decoration: InputDecoration(
              labelText: 'Card Details (16 digits)',
              hintText: 'Enter new card details',
              errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
            ),
            onChanged: (value) {
              setState(() {
                _errorMessage = value.length == 16 && RegExp(r'^\d+$').hasMatch(value)
                    ? ''
                    : 'Invalid card number. Must be 16 digits.';
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (cardController.text.length == 16 &&
                    RegExp(r'^\d+$').hasMatch(cardController.text)) {
                  setState(() {
                    _cardDetails = 'Credit Card (****${cardController.text.substring(12)})';
                  });
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _errorMessage = 'Invalid card number. Must be 16 digits.';
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}