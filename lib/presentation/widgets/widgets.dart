import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../logic/bloc/movie_bloc.dart';
import '../../logic/bloc/movie_event.dart';
import '../../logic/model/movie.dart';
import '../../logic/repository/movie_respository.dart';

class MovieRating extends StatefulWidget {
  final Movie? movie;
  final bool actionsExtend;

  @override
  State<MovieRating> createState() => _MovieRatingState();

  const MovieRating({this.movie, required this.actionsExtend});
}

class _MovieRatingState extends State<MovieRating> {
  double? newRating = 0.0;

  @override
  Widget build(BuildContext context) {
    double? rating = this.widget.movie?.voteAverage;

    return this.widget.movie != null
        ? BlocProvider(
            create: (context) => MovieBloc(TMDBMovieRepository()),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Rate the Movie',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                RatingBar.builder(
                  initialRating: rating! / 2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (userRating) {
                    setState(() {
                      this.newRating = userRating * 2;
                      print('rating changed to $this.newRating');
                    });
                  },
                ),
                SizedBox(width: this.widget.actionsExtend ? 60.0 : 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 40.0,
                        height: 40.0,
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green, // Change to desired color
                            ),
                            child: IconButton(
                              icon: Icon(Icons.check),
                              color: Colors.white, // Change to desired color
                              onPressed: () {
                                BlocProvider.of<MovieBloc>(context).add(
                                    RateMovieEvent(
                                        widget.movie!.id, this.newRating!));
                              },
                            ),
                          ),
                        )),
                    SizedBox(width: 5.0),
                    Container(
                        width: 40.0,
                        height: 40.0,
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red, // Change to desired color
                            ),
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.white, // Change to desired color
                              onPressed: () {
                                BlocProvider.of<MovieBloc>(context).add(
                                    DeleteRateMovieEvent(
                                        widget.movie!.id));
                              },
                            ),
                          ),
                        )),
                    SizedBox(width: 1.0),
                  ],
                )
              ]),
            ]),
          )
        : Container();
  }
}
