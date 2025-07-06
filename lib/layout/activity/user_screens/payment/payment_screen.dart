import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../widget/toast/toast.dart';
import '../main/main_screen.dart';

class PaymentScreen extends StatelessWidget {
  final String paymentUrl;
  final int payMethodID;
  const PaymentScreen({
    super.key,
    required this.paymentUrl,
    required this.payMethodID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: payMethodID != 4 ? null : (updateDetails) {},
        onVerticalDragUpdate: payMethodID != 4 ? null : (updateDetails) {},
        child: Scaffold(
          appBar: DefaultAppBar(title: "", isBack: true),
          body: InAppWebView(
            initialUrlRequest:
                URLRequest(url: WebUri.uri(Uri.parse(paymentUrl))),
            onLoadStop: (con, uri) async {
              // if (payMethodID == 4) {
              //   con.scrollTo(x: 370, y: 0);
              // }
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
              ),
              ios: IOSInAppWebViewOptions(
                enableViewportScale: true,
                applePayAPIEnabled: payMethodID == 4,
                // pageZoom: payMethodID == 4 ? 3 : 1,
                // maximumZoomScale: payMethodID == 4 ? 1 : 5,
                // minimumZoomScale: payMethodID == 4 ? 1 : 5,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                useWideViewPort: false,
                // initialScale: 2,
                // it makes 2 times bigger
              ),
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url.toString();
              if (url.contains("succes")) {
                showToast(
                  tr("success_pay"),
                );
                Get.offAll(() => const MainScreen());
                return NavigationActionPolicy.CANCEL;
              } else if (url.contains("fail")) {
                Get.offAll(() => const MainScreen());
                showToast(
                  tr("error_pay"),
                );
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
          ),
        ));
  }
}
