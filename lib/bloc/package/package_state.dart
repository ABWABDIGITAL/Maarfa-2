part of 'package_cubit.dart';

abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoadingState extends PackageState {}

class PackageLoadedState extends PackageState {
  List<PackageModel> packages;
  PackageLoadedState({required this.packages});
}

class PackageDetailsLoadedState extends PackageState {
  PackageModel package;
  PackageDetailsLoadedState({required this.package});
}

class PackageErrorState extends PackageState {
  String message;
  PackageErrorState({required this.message});
}

class PackageCreatedState extends PackageState {
  PackageModel package;
  PackageCreatedState({required this.package});
}

class PackageUpdatedState extends PackageState {
  PackageModel package;
  PackageUpdatedState({required this.package});
}

class PackageDeletedState extends PackageState {}

class SubscriptionLoadingState extends PackageState {}

class SubscriptionsLoadedState extends PackageState {
  List<PackageSubscriptionModel> subscriptions;
  SubscriptionsLoadedState({required this.subscriptions});
}

class SubscribedToPackageState extends PackageState {
  PackageSubscriptionModel subscription;
  SubscribedToPackageState({required this.subscription});
}

class SessionUsedState extends PackageState {
  PackageSubscriptionModel subscription;
  SessionUsedState({required this.subscription});
}

class ProviderPackagesLoadedState extends PackageState {
  List<PackageModel> packages;
  ProviderPackagesLoadedState({required this.packages});
}
