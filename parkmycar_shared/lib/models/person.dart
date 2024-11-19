import 'package:objectbox/objectbox.dart';
import '../util/validators.dart';
import 'identifiable.dart';
import 'serializer.dart';

@Entity()
class Person extends Identifiable {
  @override
  @Id()
  // ignore: overridden_fields
  int id; // Gör en override för att det ska funka med ObjectBox

  String name;
  String personnr;

  /// Default constructor. Exclude id if this is a new object
  Person(this.name, this.personnr, [this.id = -1]);

  @override
  bool isValid() {
    return Validators.isValidName(name) && Validators.isValidPersonNr(personnr);
  }

  @override
  String toString() {
    return "Id: $id, Namn: $name, Personnr: $personnr";
  }
}

class PersonSerializer extends Serializer<Person> {
  @override
  Map<String, dynamic> toJson(Person item) {
    return {
      'id': item.id,
      'name': item.name,
      'personnr': item.personnr,
    };
  }

  @override
  Person fromJson(Map<String, dynamic> json) {
    return Person(
      json['name'] as String,
      json['personnr'] as String,
      json['id'] as int,
    );
  }
}
