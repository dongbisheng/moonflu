import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/movie_bloc.dart';
import 'movie_detail.dart';
import '../blocs/movie_detail_bloc_provider.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() {
    return _MovieListState();
  }
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot){
          if (snapshot.hasData){
            return buildList(snapshot);
          } else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
  Widget buildList(AsyncSnapshot<ItemModel> snapshot){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, index){
        return GridTile(
          child: InkResponse(
            enableFeedback: true,
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${snapshot.data
                  .results[index].poster_path}',
              fit: BoxFit.cover,
            ),
            onTap: () => openDetailPage(snapshot.data, index),
          ),
        );
      },
      itemCount: snapshot.data.results.length,
    );
  }

  openDetailPage(ItemModel data, int index){
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return MovieDetailBlocProvider(
          child: MovieDetail(
            title: data.results[index].title,
            posterUrl: data.results[index].backdrop_path,
            description: data.results[index].overview,
            releaseDate: data.results[index].release_date,
            voteAverage: data.results[index].vote_average.toString(),
            movieId: data.results[index].id,
          ),
        );
      }
    ));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
