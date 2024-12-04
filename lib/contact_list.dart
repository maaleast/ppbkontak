
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'contact.dart';
import 'add_edit_contact.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late DBHelper dbHelper;
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _loadContacts();
  }

  void _loadContacts() async {
    final data = await dbHelper.getContacts();
    setState(() {
      contacts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index].name),
            subtitle: Text(contacts[index].phone),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.deleteContact(contacts[index].id!);
                _loadContacts();
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditContact(contact: contacts[index]),
                ),
              ).then((_) => _loadContacts());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditContact()),
          ).then((_) => _loadContacts());
        },
      ),
    );
  }
}
