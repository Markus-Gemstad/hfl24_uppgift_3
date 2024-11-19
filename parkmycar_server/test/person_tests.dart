import 'dart:convert';
import 'package:http/http.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import 'package:test/test.dart';
import 'server_test.dart';

int newPersonId = -1;

personCreateTest() async {
  String name = 'Testare Test';
  String pnr = '199901010101';
  Person item = Person(name, pnr);
  expect(item.isValid(), true);

  final response = await post(Uri.parse('$host/persons'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(PersonSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = PersonSerializer().fromJson(json);
  expect(item.id > 0, true);
  expect(item.name, name);
  expect(item.personnr, pnr);

  newPersonId = item.id;
}

personGetAllTest() async {
  final response = await get(Uri.parse('$host/persons'));
  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  var list =
      (json as List).map((item) => PersonSerializer().fromJson(item)).toList();
  expect(list.isEmpty || list.isNotEmpty, true);
}

personGetByIdTest() async {
  final response = await get(
    Uri.parse('$host/persons/$newPersonId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  Person item = PersonSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newPersonId);
}

personUpdateTest() async {
  String name = 'Testare Test uppdaterad';
  String pnr = '200001010101';
  Person item = Person(name, pnr, newPersonId);
  expect(item.isValid(), true);

  final response = await put(Uri.parse('$host/persons'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(PersonSerializer().toJson(item)));

  expect(response.statusCode, 200);
  expect(response.body.isNotEmpty, true);

  final json = jsonDecode(response.body);
  expect(json != null, true);

  item = PersonSerializer().fromJson(json);
  expect(item.isValid(), true);
  expect(item.id, newPersonId);
  expect(item.name, name);
  expect(item.personnr, pnr);
}

personDeleteTest() async {
  final response = await delete(
    Uri.parse('$host/persons/$newPersonId'),
    headers: {'Content-Type': 'application/json'},
  );

  expect(response.statusCode, 200);
}
