import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'RegisterEmailChanged { email :$email }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegisterPasswordChanged { password: $password }';
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  const RegisterConfirmPasswordChanged({@required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];

  @override
  String toString() => 'RegisterConfirmPasswordChanged { confirm password: $confirmPassword }';
}

class RegisterNameChanged extends RegisterEvent {
  final String name;

  const RegisterNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'name { name : $name }';
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  const RegisterSubmitted({
    @required this.email,
    @required this.password,
    @required this.name,
  });

  @override
  List<Object> get props => [email, password, name];

  @override
  String toString() {
    return 'RegisterSubmitted { email: $email, password: $password, name: $name }';
  }
}
