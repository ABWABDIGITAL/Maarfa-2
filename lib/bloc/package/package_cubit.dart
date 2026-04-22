import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/common/packages/package_model.dart';
import '../../model/user/package_subscriptions/package_subscription_model.dart';
import '../../repository/common/packages/package_repository.dart';

part 'package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  PackageCubit(this.packageRepository) : super(PackageInitial());

  static PackageCubit get(BuildContext context) =>
      BlocProvider.of(context);

  PackageRepository packageRepository;

  // Client: Get all available packages
  void getPackages({Map<String, dynamic>? queryParams}) {
    emit(PackageLoadingState());
    packageRepository.getPackages(queryParams: queryParams).then((value) {
      if (value != null) {
        emit(PackageLoadedState(packages: value));
      } else {
        emit(PackageErrorState(message: 'Failed to load packages'));
      }
    });
  }

  // Client: Get package details
  void getPackageDetails(int id) {
    emit(PackageLoadingState());
    packageRepository.getPackageDetails(id).then((value) {
      if (value != null) {
        emit(PackageDetailsLoadedState(package: value));
      } else {
        emit(PackageErrorState(message: 'Failed to load package details'));
      }
    });
  }

  // Client: Subscribe to a package
  void subscribeToPackage(int packageId) {
    emit(PackageLoadingState());
    packageRepository.subscribeToPackage(packageId).then((value) {
      if (value != null) {
        emit(SubscribedToPackageState(subscription: value));
      } else {
        emit(PackageErrorState(message: 'Failed to subscribe'));
      }
    });
  }

  // Client: Get my subscriptions
  void getMySubscriptions() {
    emit(SubscriptionLoadingState());
    packageRepository.getMySubscriptions().then((value) {
      if (value != null) {
        emit(SubscriptionsLoadedState(subscriptions: value));
      } else {
        emit(PackageErrorState(message: 'Failed to load subscriptions'));
      }
    });
  }

  // Client: Use a session (with booking)
  void useSession(
    int subscriptionId, {
    required String date,
    required String timeFrom,
    required String timeTo,
  }) {
    emit(PackageLoadingState());
    packageRepository
        .useSession(subscriptionId, date: date, timeFrom: timeFrom, timeTo: timeTo)
        .then((value) {
      if (value != null) {
        emit(SessionUsedState(subscription: value));
      } else {
        emit(PackageErrorState(message: 'Failed to use session'));
      }
    });
  }

  // Provider: Get my packages
  void getProviderPackages() {
    emit(PackageLoadingState());
    packageRepository.getProviderPackages().then((value) {
      if (value != null) {
        emit(ProviderPackagesLoadedState(packages: value));
      } else {
        emit(PackageErrorState(message: 'Failed to load packages'));
      }
    });
  }

  // Provider: Create a package
  void createPackage(Map<String, dynamic> data) {
    emit(PackageLoadingState());
    packageRepository.createPackage(data).then((value) {
      if (value != null) {
        emit(PackageCreatedState(package: value));
      } else {
        emit(PackageErrorState(message: 'Failed to create package'));
      }
    });
  }

  // Provider: Update a package
  void updatePackage(int packageId, Map<String, dynamic> data) {
    emit(PackageLoadingState());
    packageRepository.updatePackage(packageId, data).then((value) {
      if (value != null) {
        emit(PackageUpdatedState(package: value));
      } else {
        emit(PackageErrorState(message: 'Failed to update package'));
      }
    });
  }

  // Provider: Delete a package
  void deletePackage(int packageId) {
    emit(PackageLoadingState());
    packageRepository.deletePackage(packageId).then((value) {
      if (value) {
        emit(PackageDeletedState());
      } else {
        emit(PackageErrorState(message: 'Failed to delete package'));
      }
    });
  }
}
