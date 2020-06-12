import 'product.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "http://10.0.0.4:5000";
  Client client = Client();

  // ### PRODUTOS ###

  //listar todos produtos
  Future<List<Product>> getProducts() async {
    final response = await client.get("$baseUrl/api/purchases");
    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      return null;
    }
  }

  //adicionar novo produto
  Future<bool> createProduct(Product data) async {
    final response = await client.post(
      "$baseUrl/api/purchases",
      headers: {"content-type": "application/json"},
      body: productToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //atualizar um produto
  Future<bool> updateProduct(Product data) async {
    final response = await client.put(
      "$baseUrl/api/purchases/${data.id}",
      headers: {"content-type": "application/json"},
      body: productToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  //deletar um produto
  Future<bool> deleteProduct(int id) async {
    final response = await client.delete(
      "$baseUrl/api/purchases/$id",
      headers: {"content-type": "application/json"},
    );
    if(response.statusCode == 200) {
      return true;
    } else
      return false;
  }
}
