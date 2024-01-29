import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/user_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserTMDBRepository userRepository;

  LoginBloc({required this.userRepository}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        // Replace this with your own login logic
        if (event is LoginButtonPressed) {
          try {
                await userRepository.login(event.email, event.password);
                yield LoginSuccess();
          } on Exception {
            yield LoginFailure(error: 'Unable to login user');
          }
        }

        yield LoginSuccess();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
