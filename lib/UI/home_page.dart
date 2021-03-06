import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/UI/contact_page.dart';
import 'package:flutter_agenda_contatos/helper/contact.dart';
import 'package:url_launcher/url_launcher.dart';

enum EOrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contatos"),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: <Widget>[
            PopupMenuButton<EOrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<EOrderOptions>>[
                const PopupMenuItem(
                  child: Text("Ordenar de A-Z"),
                  value: EOrderOptions.orderaz,
                ),
                const PopupMenuItem(
                  child: Text("Ordenar de Z-A"),
                  value: EOrderOptions.orderza,
                )
              ],
              onSelected: _orderContacts,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: contacts.length,
            itemBuilder: _buildContactCard),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.red,
          onPressed: () {
            _showContactPage();
          },
        ));
  }

  Widget _buildContactCard(BuildContext context, int index) {
    var _contact = contacts[index];

    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _contact.image != null
                            ? FileImage(File(_contact.image))
                            : AssetImage("images/person.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _contact.name ?? "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _contact.email ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    _contact.phone ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showContactPage({Contact contact}) async {
    final editedContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (editedContact != null) {
      if (contact != null) {
        await helper.updateContact(editedContact);
      } else {
        await helper.saveContact(editedContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAll().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: FlatButton(
                          child: Text(
                            "Ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          onPressed: () {
                            launch("tel:${contacts[index].phone}");
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: FlatButton(
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: FlatButton(
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          onPressed: () {
                            helper.deleteContact(contacts[index].id);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _orderContacts(EOrderOptions value) {
    switch (value) {
      case EOrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case EOrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
