import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transport_model.dart';

class TransportRepository {
  final String baseUrl;

  TransportRepository({required this.baseUrl});

  Future<List<TransportModel>> getAllTransports() async {
    final response = await http.get(Uri.parse('$baseUrl/get_transport'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['transports'];
      return data.map((json) => TransportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transports');
    }
  }

  Future<TransportModel> getTransport(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/get_transport/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['transport'];
      return TransportModel.fromJson(data);
    } else {
      throw Exception('Failed to load transport');
    }
  }

  Future<void> insertTransport(TransportModel transport) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert_transport'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transport.toJson()),  // Asegúrate de que TransportModel tenga un método toJson
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create transport');
    }
  }

  Future<void> updateTransport(TransportModel transport) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update_transport'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transport.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transport');
    }
  }

  Future<void> deleteTransport(int id) async {
    final url = '$baseUrl/delete_transport_by_id';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transport');
    }
  }


}
