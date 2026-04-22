import 'package:flutter/cupertino.dart';

import '../../../model/common/packages/package_model.dart';
import '../../../model/user/package_subscriptions/package_subscription_model.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class PackageRepository {
  // Client: Get all available packages
  Future<List<PackageModel>?> getPackages({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await DioService()
          .get('/clients/packages', queryParams: queryParams)
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          List<PackageModel> packages = (r['data']['packages'] as List)
              .map((e) => PackageModel.fromJson(e))
              .toList();
          return packages;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Client: Get package details
  Future<PackageModel?> getPackageDetails(int id) async {
    try {
      return await DioService()
          .get('/clients/packages/$id/show')
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          return PackageModel.fromJson(r['data']);
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Client: Subscribe to a package
  Future<PackageSubscriptionModel?> subscribeToPackage(int packageId) async {
    try {
      return await DioService()
          .post('/clients/packages/$packageId/subscribe')
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          return PackageSubscriptionModel.fromJson(r['data']);
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Client: Get my subscriptions
  Future<List<PackageSubscriptionModel>?> getMySubscriptions() async {
    try {
      return await DioService()
          .get('/clients/packages/subscriptions')
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          List<PackageSubscriptionModel> subscriptions =
              (r['data']['subscriptions'] as List)
                  .map((e) => PackageSubscriptionModel.fromJson(e))
                  .toList();
          return subscriptions;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Client: Use a session from subscription (with booking)
  Future<PackageSubscriptionModel?> useSession(
    int subscriptionId, {
    required String date,
    required String timeFrom,
    required String timeTo,
  }) async {
    try {
      return await DioService()
          .post(
            '/clients/packages/package-subscriptions/$subscriptionId/use',
            body: {
              'date': date,
              'time_from': timeFrom,
              'time_to': timeTo,
            },
          )
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          return PackageSubscriptionModel.fromJson(r['data']['subscription'] ?? r['data']);
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Provider: Get my packages
  Future<List<PackageModel>?> getProviderPackages() async {
    try {
      return await DioService()
          .get('/providers/packages')
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          List<PackageModel> packages = (r['data']['packages'] as List)
              .map((e) => PackageModel.fromJson(e))
              .toList();
          return packages;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Provider: Create a package
  Future<PackageModel?> createPackage(Map<String, dynamic> data) async {
    try {
      return await DioService()
          .post('/providers/packages/create', body: data)
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          return PackageModel.fromJson(r['data']);
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Provider: Update a package
  Future<PackageModel?> updatePackage(
      int packageId, Map<String, dynamic> data) async {
    try {
      return await DioService()
          .put('/providers/packages/$packageId/update', body: data)
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return null;
        }, (r) {
          return PackageModel.fromJson(r['data']);
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Provider: Delete a package
  Future<bool> deletePackage(int packageId) async {
    try {
      return await DioService()
          .delete('/providers/packages/$packageId/delete')
          .then((value) {
        return value.fold((l) {
          showToast(l);
          return false;
        }, (r) {
          return true;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
