import 'package:equatable/equatable.dart';

class Session extends Equatable{
  bool? success;

  Session({this.success});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(success: json['success'] ?? false);
  }

  Map<String, dynamic> toJson() => {
        "success": success,
      };

  @override
  List<Object?> get props => [success];
}
