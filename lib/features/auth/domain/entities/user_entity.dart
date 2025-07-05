import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
  });

  @override
  List<Object?> get props => [uid, name, email];
}
