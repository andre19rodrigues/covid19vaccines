import 'dart:convert';
import 'package:flutter_cache/flutter_cache.dart' as Cache;
import 'package:vacinas_covid/model/vacinas_dssg.dart';
import 'package:http/http.dart';
import 'package:vacinas_covid/defaults.dart';

//Get data from the API
class VacinasDSSGreq{

  final String apiUrl = AppDefaults.API_URL;

  Future<List<VaccinesDSSG>> getAdministeredVaccines() async {
    var response = null;

    var source = await Cache.remember('vacinas', () async {
      response = await get(apiUrl);
      if (response.statusCode == 200) {
        return Utf8Decoder().convert(response.bodyBytes);
      }
    }, 180); //The results will be cached for 5 minutes

    List<dynamic> vacinas_source = jsonDecode(source);
    List<VaccinesDSSG> vacinas = vacinas_source
        .map((dynamic item) => VaccinesDSSG.fromJson(item))
        .toList();

    return vacinas;
  }
}