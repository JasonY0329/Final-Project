import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'signin.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserProfilePage({required this.userData});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _userName;
  late String _userPronouns;
  late String _userPhone;
  late String _userEmail;
  late String _userAddress;

  @override
  void initState() {
    super.initState();
    _userName = widget.userData['name'] ?? '';
    _userPronouns = widget.userData['pronouns'] ?? 'Add Your Pronouns';
    _userPhone = widget.userData['phone'] ?? '';
    _userEmail = widget.userData['email'] ?? '';
    _userAddress = widget.userData['address'] ?? 'Add Your Address';
  }

  void _updateUserInfo(String field, String value) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({field: value});
    }
  }

  void _editField(BuildContext context, String title, String field, String value) {
    TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  switch (field) {
                    case 'name':
                      _userName = controller.text;
                      widget.userData['name'] = controller.text;
                      break;
                    case 'pronouns':
                      _userPronouns = controller.text;
                      widget.userData['pronouns'] = controller.text;
                      break;
                    case 'phone':
                      _userPhone = controller.text;
                      widget.userData['phone'] = controller.text;
                      break;
                    case 'email':
                      _userEmail = controller.text;
                      widget.userData['email'] = controller.text;
                      break;
                    case 'address':
                      _userAddress = controller.text;
                      widget.userData['address'] = controller.text;
                      break;
                  }
                });

                _updateUserInfo(field, controller.text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false, // Remove all previous routes
    );
  }
  void _editPronounsField(BuildContext context) {
  String selectedPronoun = _userPronouns.isNotEmpty &&
          ['He', 'She', 'They'].contains(_userPronouns)
      ? _userPronouns
      : 'He'; // Default to 'He' if _userPronouns is empty or invalid

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Pronouns'),
        content: Form(
          child: DropdownButtonFormField<String>(
            value: selectedPronoun,
            items: ['He', 'She', 'They'].map((String pronoun) {
              return DropdownMenuItem<String>(
                value: pronoun,
                child: Text(pronoun),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedPronoun = newValue!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Pronouns',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userPronouns = selectedPronoun; // Update the state
              });
              _updateUserInfo('pronouns', selectedPronoun); // Save to Firestore
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/user.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Name'),
              subtitle: Text(_userName),
              trailing: Icon(Icons.edit),
              onTap: () => _editField(context, 'Name', 'name', _userName),
            ),
            ListTile(
              title: const Text('Pronouns'),
              subtitle: Text(_userPronouns),
              trailing: const Icon(Icons.edit),
              onTap: () => _editPronounsField(context),
            ),

            ListTile(
              title: Text('Phone'),
              subtitle: Text(_userPhone),
              trailing: Icon(Icons.edit),
              onTap: () => _editField(context, 'Phone', 'phone', _userPhone),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(_userEmail),
              trailing: Icon(Icons.edit),
              onTap: () => _editField(context, 'Email', 'email', _userEmail),
            ),
            ListTile(
              title: Text('Address'),
              subtitle: Text(_userAddress),
              trailing: Icon(Icons.edit),
              onTap: () => _editField(context, 'Address', 'address', _userAddress),
            ),
            Spacer(), // Pushes the button to the bottom
            Center(
              child: ElevatedButton(
                onPressed: () => _logOut(context),
                child: Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
