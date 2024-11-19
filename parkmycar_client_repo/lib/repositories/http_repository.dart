import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:parkmycar_shared/parkmycar_shared.dart';

abstract class HttpRepository<T> implements RepositoryInterface<T> {
  final String host;
  final String port;
  final String resource;
  Serializer<T> serializer;

  Uri get baseUri => Uri.parse("$host:$port/$resource");

  HttpRepository(
      {required this.serializer,
      required this.resource,
      this.host = "http://localhost",
      this.port = "8080"});

  Uri createUriWithId(int id) {
    return Uri.parse("$baseUri/$id");
  }

  @override
  Future<T?> create(T item) async {
    final response = await http.post(baseUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(serializer.toJson(item)));

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        return serializer.fromJson(json);
      } catch (e) {
        throw Exception('Gick inte att läsa returdata.');
      }
    } else if (response.statusCode == 400 &&
        response.body == objectNotCreated) {
      throw Exception('Kunde inte skapa objekt.');
    } else if (response.statusCode == 404) {
      throw Exception('Kunde inte hitta server.');
    } else {
      throw Exception('Okänt fel.');
    }
  }

  /// Send item serialized as json over http to server
  @override
  Future<T?> update(T item) async {
    final response = await http.put(baseUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(serializer.toJson(item)));

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        return serializer.fromJson(json);
      } catch (e) {
        throw Exception('Gick inte att läsa returdata.');
      }
    } else if (response.statusCode == 400 && response.body == objectNotFound) {
      throw Exception('Hittade inte objekt.');
    } else if (response.statusCode == 404) {
      throw Exception('Kunde inte hitta server.');
    } else {
      throw Exception('Okänt fel.');
    }
  }

  @override
  Future<T?> getById(int id) async {
    Response response = await http.get(
      createUriWithId(id),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        return serializer.fromJson(json);
      } catch (e) {
        throw Exception('Gick inte att läsa returdata.');
      }
    } else if (response.statusCode == 400 && response.body == objectNotFound) {
      throw Exception('Hittade inte objekt.');
    } else if (response.statusCode == 404) {
      throw Exception('Kunde inte hitta server.');
    } else {
      throw Exception('Okänt fel.');
    }
  }

  @override
  Future<List<T>> getAll() async {
    final response = await http.get(
      baseUri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        return (json as List).map((item) => serializer.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Gick inte att läsa returdata.');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Kunde inte hitta server.');
    } else {
      throw Exception('Gick inte att hämta objekt.');
    }
  }

  @override
  Future<bool> delete(int id) async {
    final response = await http.delete(
      createUriWithId(id),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400 && response.body == objectNotFound) {
      throw Exception('Hittade inte objekt.');
    } else if (response.statusCode == 404) {
      throw Exception('Kunde inte hitta server.');
    } else {
      throw Exception('Gick inte att ta bort objekt.');
    }
  }
}
