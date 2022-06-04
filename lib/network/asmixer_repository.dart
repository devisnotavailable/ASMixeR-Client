import 'package:asmixer/network/categories_response.dart';
import 'package:asmixer/network/samples_response.dart';

import 'network_handler.dart';

class MixerRepository {
  final NetworkHandler _networkHandler;
  final String baseUrl = "http://185.219.42.134";

  MixerRepository(this._networkHandler);

  Future<CategoriesResponse> getCategories() async {
    final response = await _networkHandler.get("$baseUrl/lib/categories");
    return CategoriesResponse.fromJson(response);
  }

  Future<SamplesResponse> getSamplesForCategory(int categoryID) async {
    final response =
        await _networkHandler.get("$baseUrl/sample/get?categoryId=$categoryID");
    return SamplesResponse.fromJson(response);
  }

  Future<SamplesResponse> getSamples() async {
    final response = await _networkHandler.get("$baseUrl/sample/get-all");
    return SamplesResponse.fromJson(response);
  }
}
