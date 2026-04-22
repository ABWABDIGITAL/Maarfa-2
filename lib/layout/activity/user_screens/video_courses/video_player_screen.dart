import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/value/color/color.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String youtubeUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.youtubeUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  String? _extractYoutubeId(String url) {
    final regExp = RegExp(
      r'(?:youtu\.be/|youtube\.com/(?:watch\?v=|embed/|v/|shorts/))([a-zA-Z0-9_-]{11})',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  String _buildYoutubeHtml(String videoId) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
      <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
          background: #000;
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 100vh;
        }
        .video-container {
          position: relative;
          width: 100%;
          padding-bottom: 56.25%;
          height: 0;
        }
        .video-container iframe {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
        }
      </style>
    </head>
    <body>
      <div class="video-container">
        <iframe
          src="https://www.youtube.com/embed/$videoId?autoplay=1&playsinline=1&rel=0&modestbranding=1"
          frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen>
        </iframe>
      </div>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final videoId = _extractYoutubeId(widget.youtubeUrl);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title.isNotEmpty ? widget.title : tr('watch_video'),
          style: TextStyle(
            fontFamily: 'Shamel',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: white),
          onPressed: () => Get.back(),
        ),
      ),
      body: videoId == null
          ? Center(
              child: Text(
                tr('invalid_video_url'),
                style: TextStyle(color: white, fontSize: 16.sp),
              ),
            )
          : Stack(
              children: [
                InAppWebView(
                  initialData: InAppWebViewInitialData(
                    data: _buildYoutubeHtml(videoId),
                    mimeType: 'text/html',
                    encoding: 'utf-8',
                  ),
                  initialSettings: InAppWebViewSettings(
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                    javaScriptEnabled: true,
                    useWideViewPort: true,
                    supportZoom: false,
                  ),
                  onLoadStop: (controller, url) {
                    setState(() => _isLoading = false);
                  },
                  onLoadStart: (controller, url) {
                    setState(() => _isLoading = true);
                  },
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: mainColor),
                  ),
              ],
            ),
    );
  }
}
