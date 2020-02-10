import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String CONTACT_TABLE = "contact_table";
final String ID_COLUMN = "id_column";
final String NAME_COLUMN = "name_column";
final String EMAIL_COLUMN = "email_column";
final String PHONE_COLUMN = "phone_column";
final String IMAGE_COLUMN = "image_column";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contact.db");

    openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $CONTACT_TABLE ($ID_COLUMN INTEGER PRIMARY KEY, $NAME_COLUMN TEXT, $EMAIL_COLUMN TEXT, $PHONE_COLUMN TEXT, $IMAGE_COLUMN TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(CONTACT_TABLE, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(CONTACT_TABLE,
        columns: [
          ID_COLUMN,
          NAME_COLUMN,
          EMAIL_COLUMN,
          PHONE_COLUMN,
          IMAGE_COLUMN
        ],
        where: "$ID_COLUMN = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(CONTACT_TABLE, where: "$ID_COLUMN = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(CONTACT_TABLE, contact.toMap(),
        where: "$ID_COLUMN = ?", whereArgs: [contact.id]);
  }

  Future<List> getAll() async {
    Database dbContact = await db;
    List maps = await dbContact.rawQuery("SELECT * FROM $CONTACT_TABLE");
    List<Contact> listContact = List();
    for (Map map in maps) {
      listContact.add(Contact.fromMap(map));
    }

    listContact;
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String image;

  Contact.fromMap(Map map) {
    id = map[ID_COLUMN];
    name = map[NAME_COLUMN];
    email = map[EMAIL_COLUMN];
    phone = map[PHONE_COLUMN];
    image = map[IMAGE_COLUMN];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      NAME_COLUMN: name,
      EMAIL_COLUMN: email,
      PHONE_COLUMN: phone,
      IMAGE_COLUMN: image
    };

    if (id != null) {
      map[ID_COLUMN] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, image: $image)";
  }
}
