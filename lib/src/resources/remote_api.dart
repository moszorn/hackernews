import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import 'dart:async';

import 'repository.dart' show Source;

final _root = 'https://hacker-news.firebaseio.com/v0';

/*
讀取文章ID      https://hacker-news.firebaseio.com/v0/topstories.json
[18804742,18804639,18803328,18801531,18802405,...]

讀取文章明細     https://hacker-news.firebaseio.com/v0/item/18803923.json
{
    "by":"arikr",
    "descendants":54,
    "id":18804742,
    "kids":[18787275,18787276,..., 18787466],
    "score":67,
    "time":1546135816,
    "title":"Scott Adams’ Financial Advice (2014)",
    "type":"story",
    "url":"https://www.mattcutts.com/blog/scott-adams-financial-advice/"
}
 */

class NewsApiProvider implements Source{

  Client httpClient = Client();


/*
  讀取文章ID      https://hacker-news.firebaseio.com/v0/topstories.json
  [18804742,18804639,18803328,18801531,18802405,...]
*/
  Future<List<int>> fetchTopIds() async {
    final url = '$_root/topstories.json';
    final response = await httpClient.get(url);
    final List<dynamic> ids = json.decode(response.body);

    //cast<R> 以View的形式回傳 List<R> , 底下就是回傳 List<int>
    return ids.cast<int>();
  }

/*
讀取文章明細     https://hacker-news.firebaseio.com/v0/item/18803923.json
{
    "by":"arikr",
    "descendants":54,
    "id":18804742,
    "kids":[18787275,18787276,..., 18787466],
    "score":67,
    "time":1546135816,
    "title":"Scott Adams’ Financial Advice (2014)",
    "type":"story",
    "url":"https://www.mattcutts.com/blog/scott-adams-financial-advice/"
}
 */
  Future<ItemModel> fetchItem(int id) async {
    final url = '$_root/item/$id.json';
    final response = await httpClient.get(url);
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }

}