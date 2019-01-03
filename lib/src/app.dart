import 'package:flutter/material.dart';
import 'blocs/stories_provider.dart';
import 'models/item_model.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return StoriesProvider(
      child: MaterialApp(
        title: "News!",
        home:Scaffold( 
          appBar: AppBar( 
            title: Text('TopNews'),
          ),
          body: NewList()
        ),
      ),
    );
  }
}

class NewList extends StatelessWidget {

  _fetchTopIds(StoriesBloc bloc){
    bloc.fetchTopIds();
  }

  Widget build(ctx) {

    final bloc = StoriesProvider.of(ctx);
     _fetchTopIds(bloc);

    return StreamBuilder( 
      stream: bloc.topIds,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
       
        if(!snapshot.hasData) {
          return Center( 
            child: CircularProgressIndicator()
          );
        }

        return ListView.builder( 
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index){  

            bloc.fetchItem(snapshot.data[index]);

             return NewsListTile(itemId:snapshot.data[index]);
          },
        );
      },
    );
  }
}


class NewsListTile extends StatelessWidget{
  final int itemId;
  NewsListTile({this.itemId});

  Widget build(context){
    final bloc = StoriesProvider.of(context);
    return StreamBuilder( 
      stream: bloc.items,
      builder: (ctx, AsyncSnapshot<Map<int,Future<ItemModel>>> snapshot){
       
        if(!snapshot.hasData){
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (ctx, AsyncSnapshot<ItemModel> itemSnapshot){
            if(!itemSnapshot.hasData){
              return LoadingContainer();
            }
            return buildTile(ctx,itemSnapshot.data);
          }
        );
        
      }
    );
  }

  Widget buildTile(BuildContext context, ItemModel item){
    return Column( 
      children: <Widget>[
        ListTile( 
          title: Text(item.title),
          subtitle: Text('${item.score}'),
          trailing: Column( 
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}')
            ],
          ),
        )
      ],
    );
  }
}


class LoadingContainer extends StatelessWidget{

  Widget build(context){
    return Column( 
      children: [
        ListTile( 
          title: buildContainer(),
          subtitle: buildContainer(),
        )
      ],
    );
  }

  Widget buildContainer(){
    return Container( 
      color: Colors.grey[200],
      height:24.0,
      width: 150.0,
      margin: EdgeInsets.only(top:5.0, bottom: 5.0),
    );
  }
}