import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';


class StoriesBloc{

  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsFetcher = PublishSubject<int>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();



  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items =>  _itemsOutput.stream;

  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }


  fetchTopIds() async {
    _topIds.sink.add(await _repository.fetchTopIds());
  }

  _itemsTransformer(){
    return ScanStreamTransformer( 
      (Map<int, Future<ItemModel>> cache, int id, index){
        //print(index.toString());
        cache[id] = _repository.fetchItem(id);
        return cache;
      }, 
      <int, Future<ItemModel>>{}
    );
  }


}