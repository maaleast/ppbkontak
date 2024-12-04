
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'contact.dart';

class AddEditContact extends StatefulWidget {
  final Contact? contact;

  AddEditContact({this.contact});

  @override
  _AddEditContactState createState() => _AddEditContactState();
}

class _AddEditContactState extends State<AddEditContact> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  late DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    if (widget.contact != null) {
      _name = widget.contact!.name;
      _phone = widget.contact!.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final contact = Contact(
                      id: widget.contact?.id,
                      name: _name!,
                      phone: _phone!,
                    );
                    if (widget.contact == null) {
                      dbHelper.insertContact(contact);
                    } else {
                      dbHelper.updateContact(contact);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.contact == null ? 'Add' : 'Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
