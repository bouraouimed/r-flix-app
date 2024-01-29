import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_flix_app/logic/bloc/login_bloc.dart';
import 'package:r_flix_app/logic/repository/user_repository.dart';
import 'package:http/http.dart' as http;

import 'package:r_flix_app/presentation/screens/login_screen.dart';


void main() {
  runApp(RFlixApp());
}

class RFlixApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'R-Flix App',
      home: BlocProvider(
        create: (context) => LoginBloc(userRepository: UserTMDBRepository()),
        child: LoginScreen(),
      ),
    );
  }
}
