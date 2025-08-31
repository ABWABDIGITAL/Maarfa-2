part of 'bank_account_cubit.dart';

@immutable
abstract class BankAccountState {}

class BankAccountInitial extends BankAccountState {}

class ValidateState extends BankAccountState {}

class AddAccountMessageState extends BankAccountState {}

class SameCityState extends BankAccountState {}

class ChangeCityState extends BankAccountState {}

class ChooseCityState extends BankAccountState {}

class RequestPayState extends BankAccountState {}
class SelectPayment extends BankAccountState {}
