final String ID_COLUMN = "id_column";
final String NAME_COLUMN = "name_column";
final String EMAIL_COLUMN = "email_column";
final String PHONE_COLUMN = "phone_column";
final String IMAGE_COLUMN = "image_column";

class ContactHelper {}

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
