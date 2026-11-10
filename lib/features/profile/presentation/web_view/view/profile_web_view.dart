import 'package:fitness_app/core/shared/custom_app_bar.dart';
import 'package:fitness_app/core/theme/app_colors/app_colors.dart';
import 'package:fitness_app/features/profile/presentation/web_view/args/profile_web_view_args.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileWebView extends StatefulWidget {
  final ProfileWebViewArgs args;

  const ProfileWebView({super.key, required this.args});

  @override
  State<ProfileWebView> createState() => _ProfileWebViewState();
}

class _ProfileWebViewState extends State<ProfileWebView> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _progress = progress);
          },
          onWebResourceError: (error) {
            if (!mounted) return;
            if (error.isForMainFrame ?? true) {
              setState(() => _hasError = true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.args.url));
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _progress = 0;
    });
    _controller.loadRequest(Uri.parse(widget.args.url));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.args.title),
      body: _hasError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.webViewLoadFailed,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(12.h),
                  TextButton(
                    onPressed: _retry,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_progress < 100)
                  LinearProgressIndicator(
                    value: _progress / 100,
                    color: AppColors.primary,
                  ),
              ],
            ),
    );
  }
}
