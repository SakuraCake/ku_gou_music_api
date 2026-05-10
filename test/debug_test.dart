import 'package:http/http.dart' as http;
import 'package:kugou_api/kugou_api.dart';
import 'dart:convert';

void main() async {
  final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final mid = '334689572176563962868706300678062568191';
  
  final params = <String, dynamic>{
    'dfid': '-',
    'mid': mid,
    'uuid': '-',
    'appid': 1005,
    'clientver': 20489,
    'clienttime': clienttime,
    'page': 1,
    'pagesize': 30,
    'sort_type': 1,
    'kugouid': 0,
  };
  
  final data = jsonEncode({'exposure': []});
  final sig = signatureAndroidParams(params, data);
  
  params['signature'] = sig;
  
  final queryString = params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
      .join('&');
  
  final url = 'https://gateway.kugou.com/scene/v1/scene/list_v2?$queryString';
  print('URL: $url');
  print('Signature: $sig');
  
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'User-Agent': 'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json',
      'dfid': '-',
      'clienttime': clienttime.toString(),
      'mid': mid,
      'kg-rc': '1',
      'kg-thash': '5d816a0',
      'kg-rec': '1',
      'kg-rf': 'B9EDA08A64250DEFFBCADDEE00F8F25F',
    },
    body: data,
  );
  print('Status: ${response.statusCode}');
  print('Body: ${response.body.substring(0, response.body.length > 300 ? 300 : response.body.length)}');
}
