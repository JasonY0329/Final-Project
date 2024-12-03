import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                      break;
                    case 'pronouns':
                      _userPronouns = controller.text;
                      break;
                    case 'phone':
                      _userPhone = controller.text;
                      break;
                    case 'email':
                      _userEmail = controller.text;
                      break;
                    case 'address':
                      _userAddress = controller.text;
                      break;
                  }
                });

                _updateUserInfo(field, controller.text);
                Navigator.pop(context, {
                  'name': _userName,
                  'email': _userEmail,
                  'phone': _userPhone,
                  'pronouns': _userPronouns,
                  'address': _userAddress,
                });
              },
              child: Text('Save'),
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
              title: Text('Pronouns'),
              subtitle: Text(_userPronouns),
              trailing: Icon(Icons.edit),
              onTap: () => _editField(context, 'Pronouns', 'pronouns', _userPronouns),
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
          ],
        ),
      ),
    );
  }
}
