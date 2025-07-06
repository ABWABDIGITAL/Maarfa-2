import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

// import 'package:social_share/social_share.dart';

import '../../../layout/activity/user_screens/trainer/trainer_screen.dart';
import '../../../model/user/show_providers/show_providers_db_response.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class ShowProvidersRepository {
  showProviders(int id) async {
    try {
      return await DioService()
          .get('/clients/providers/$id/show')
          .then((value) => value.fold((l) => showToast(l), (r) {
                ShowProvidersDbResponse showProviders =
                    ShowProvidersDbResponse.fromJson(r);
                return showProviders.data;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Uri> getGroupDynamicLinks(BuildContext context, int id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://moazez.page.link',
      link: Uri.parse('https://moazez.com/?id=$id'),
      androidParameters: const AndroidParameters(
        packageName: 'com.moltaqa.myAcademy',
        // minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.moltaqa.myAcademy',
        // minimumVersion: '0',
        appStoreId: '1633140565',
      ),
    );
    // final link = await FirebaseDynamicLinks.instance.buildLink(parameters);
    final ShortDynamicLink shortenedLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri dynamicUrl = shortenedLink.shortUrl;
    // final ss = link.;
    // SocialShare.checkInstalledAppsForShare();
    Share.share(dynamicUrl.toString());
    return dynamicUrl;
  }

  void getLinkData() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    handleLinkData(link);
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink);
    }).onError((error) {
      debugPrint(error.message);
    });
  }

  void handleLinkData(PendingDynamicLinkData? data) {
    final Uri? uri = data?.link;
    if (uri != null) {
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        String? userName = queryParams["id"];
        Get.to(() => TrainerScreen(isUser: true, id: int.parse(userName!)));
      }
    }
  }
}
