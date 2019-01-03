
import 'dart:async';
import 'cache_sqlite.dart';
import 'remote_api.dart';
import '../models/item_model.dart';

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}

class Repository{
  List<Source> sources = <Source>[
    sqlite /* newsDbProvider */,
    NewsApiProvider(),
  ];
  List<Cache> caches = <Cache>[sqlite];

  Future<List<int>> fetchTopIds() => sources[1].fetchTopIds();

  Future<ItemModel> fetchItem(int id) async {
      ItemModel item;
      var source;

      for(source in sources){
        item = await source.fetchItem(id);
        if(item != null){
          break;
        }
      }

       //若沒有快取,則進行快取
      for(var cache in caches){
        if(cache != source) {
          cache.addItem(item);
        }
      }
      return item;
  }

  clearCache() async {
    for(var cache in caches){
      await cache.clear();
    }
  }
}