import 'package:http/http.dart' as http;

void main() async {
  final client = http.Client();

  print('=== 1. 搜索歌曲 (直接HTTP请求) ===');
  final searchUrl = Uri.parse('https://gateway.kugou.com/v3/search/song').replace(
    queryParameters: {
      'keyword': '周杰伦',
      'page': '1',
      'pagesize': '5',
      'albumhide': '0',
      'iscorrection': '1',
      'nocollect': '0',
      'platform': 'AndroidFilter',
    },
  );
  final searchResp = await client.get(searchUrl, headers: {
    'User-Agent': 'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
    'x-router': 'complexsearch.kugou.com',
  });
  print('Status: ${searchResp.statusCode}');
  print('Body (前500字): ${searchResp.body.substring(0, searchResp.body.length > 500 ? 500 : searchResp.body.length)}');

  print('\n=== 2. 热搜 (直接HTTP请求) ===');
  final hotUrl = Uri.parse('https://gateway.kugou.com/api/v3/search/hot_tab').replace(
    queryParameters: {
      'navid': '1',
      'plat': '2',
    },
  );
  final hotResp = await client.get(hotUrl, headers: {
    'User-Agent': 'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
    'x-router': 'msearch.kugou.com',
  });
  print('Status: ${hotResp.statusCode}');
  print('Body (前500字): ${hotResp.body.substring(0, hotResp.body.length > 500 ? 500 : hotResp.body.length)}');

  print('\n=== 3. 搜索建议 (直接HTTP请求) ===');
  final suggestUrl = Uri.parse('https://gateway.kugou.com/v2/getSearchTip').replace(
    queryParameters: {
      'keyword': '周',
      'AlbumTipCount': '10',
      'MusicTipCount': '10',
    },
  );
  final suggestResp = await client.get(suggestUrl, headers: {
    'User-Agent': 'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
    'x-router': 'searchtip.kugou.com',
  });
  print('Status: ${suggestResp.statusCode}');
  print('Body (前500字): ${suggestResp.body.substring(0, suggestResp.body.length > 500 ? 500 : suggestResp.body.length)}');

  client.close();
}
