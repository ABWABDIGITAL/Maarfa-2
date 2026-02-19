import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/bloc/auth/show_delete_and_payment/show_delete_and_paymnet_cubit.dart';
import 'package:my_academy/layout/activity/static/contact_us/contact_us_screen.dart';
import 'package:my_academy/layout/view/profile/managers/contact_support_service_cubit.dart';
import 'package:my_academy/layout/view/profile/profile/contact_support_service_screen.dart';
import 'package:my_academy/layout/view/profile/profile/poll_screen.dart';

import '../../../../../widget/error/page/error_page.dart';
import '../../../../bloc/auth/provider/auth_provider_cubit.dart';
import '../../../../bloc/profile/provider/provider_cubit.dart';
import '../../../../bloc/profile/user/user_cubit.dart';
import '../../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../../../repository/user/edit_profile/user_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/alert/delete/delete_alert.dart';
import '../../../activity/provider_screens/account_data/account_data_screen.dart';
import '../../../activity/provider_screens/account_data/edit_account_information_screen.dart';
import '../../../activity/provider_screens/bank_account/bank_account_screen.dart';
import '../../../activity/static/about_us/about_us_screen.dart';
import '../../../activity/static/privacy/privacy_screen.dart';
import '../../../activity/static/terms_conditions/terms_conditions_screen.dart';
import '../../../activity/user_screens/wallet/wallet_screen.dart';
import 'profile_cache_view.dart';

class ProfileView extends StatefulWidget {
  final bool isUser;

  const ProfileView({super.key, required this.isUser});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(final BuildContext context) {
    return widget.isUser
        ? BlocProvider(
            create: (BuildContext context) =>
                UserCubit(UserRepository())..getProfile(),
            child: BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is UserApiLoadedState) {
                    return _profileView(context, state.data);
                  } else if (state is ErrorUserState) {
                    return const ErrorPage();
                  } else {
                    return ProfileCacheView(isUser: widget.isUser);
                  }
                }))
        : BlocProvider(
            create: (BuildContext context) =>
                ProviderCubit(UserRepository())..getProfile(),
            child: BlocConsumer<ProviderCubit, ProviderState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ProviderLoadedState) {
                    return _profileView(context, state.data);
                  } else if (state is ErrorProviderState) {
                    return const ErrorPage();
                  } else {
                    return ProfileCacheView(isUser: widget.isUser);
                  }
                }));
  }

  Widget _profileView(BuildContext context, dynamic data) {
    return BlocProvider(
      create: (BuildContext context) =>
          AuthProviderCubit(AuthProviderRepository()),
      child: BlocConsumer<AuthProviderCubit, AuthProviderState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = AuthProviderCubit.get(context);

          final String imageUrl = widget.isUser
              ? (data.data?.image ?? data.data?.imagePath ?? '')
              : (data?.data?.imagePath ?? '');
          final String firstName = widget.isUser
              ? (data.data?.firstName ?? '')
              : (data?.data?.firstName ?? '');
          final String lastName = widget.isUser
              ? (data.data?.lastName ?? '')
              : (data?.data?.lastName ?? '');
          final String title = widget.isUser ? '' : (data?.data?.title ?? '');
          final String fullName = '$title $firstName $lastName'.trim();
          final String initial =
              fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

          final bool showDelete =
              context.read<ShowDeleteAndPaymnetCubit>().showDeleteAccount;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // ── Profile Header Card ──────────────────────────────
                _ProfileHeader(
                  imageUrl: imageUrl,
                  fullName: fullName,
                  initial: initial,
                  isUser: widget.isUser,
                  onTap: () => widget.isUser
                      ? Get.to(() => AccountDataScreen(
                            isUser: true,
                            user: data.data,
                          ))
                      : Get.to(() => EditAccountInformation(data: data.data)),
                ),

                const SizedBox(height: 20),

                // ── Account Section ──────────────────────────────────
                _SectionGroup(
                  items: [
                    _MenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: accentColor,
                      title: tr('wallet'),
                      onTap: () => widget.isUser
                          ? Get.to(() => WalletCharging(
                                isUser: true,
                                walletCredit: data.data.wallet,
                              ))
                          : Get.to(() => BankAccount(
                                balance: data?.data.wallet,
                                deservedAmount: data?.data.expectedAmount,
                                appRatio: data?.data.appRatio,
                                bankData: data?.data.bankAccount,
                              )),
                    ),
                    _MenuItem(
                      icon: Icons.poll_outlined,
                      iconColor: accentColor,
                      title: tr('polls'),
                      onTap: () => Get.to(BlocProvider(
                        create: (context) => ContactSupportServiceCubit(),
                        child: PollScreen(),
                      )),
                    ),
                    _MenuItem(
                      icon: Icons.language_rounded,
                      iconColor: accentColor,
                      title: tr('language'),
                      onTap: () => bloc.changeLocale(context),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Support Section ──────────────────────────────────
                _SectionGroup(
                  items: [
                    _MenuItem(
                      icon: Icons.headset_mic_outlined,
                      iconColor: const Color(0xFF0EA5E9),
                      title: tr('contact_support_service'),
                      onTap: () => Get.to(() => BlocProvider(
                            create: (context) => ContactSupportServiceCubit()
                              ..getAllSupportData(),
                            child: const ContactSupportServiceScreen(),
                          )),
                    ),
                    _MenuItem(
                      icon: Icons.mail_outline_rounded,
                      iconColor: const Color(0xFF0EA5E9),
                      title: tr('contact_us'),
                      onTap: () => Get.to(() => const ContactUsScreen()),
                    ),
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      iconColor: const Color(0xFF0EA5E9),
                      title: tr('about_us'),
                      onTap: () => Get.to(const AboutUsScreen()),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Legal Section ────────────────────────────────────
                _SectionGroup(
                  items: [
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: const Color(0xFF707070),
                      title: tr('privacy'),
                      onTap: () => Get.to(const PrivacyScreen()),
                    ),
                    _MenuItem(
                      icon: Icons.gavel_rounded,
                      iconColor: const Color(0xFF707070),
                      title: tr('terms'),
                      onTap: () => Get.to(TermsScreen(isUser: widget.isUser)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Danger Zone ──────────────────────────────────────
                _SectionGroup(
                  items: [
                    if (showDelete)
                      _MenuItem(
                        icon: Icons.delete_outline_rounded,
                        iconColor: const Color(0xFFDC2626),
                        title: tr('delete_account'),
                        titleColor: const Color(0xFFDC2626),
                        onTap: () =>
                            deleteAlert(deleteTap: () => bloc.deleteAccount()),
                      ),
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFDC2626),
                      title: tr('logout'),
                      titleColor: const Color(0xFFDC2626),
                      onTap: () => bloc.logout(),
                    ),
                  ],
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String fullName;
  final String initial;
  final bool isUser;
  final VoidCallback onTap;

  const _ProfileHeader({
    required this.imageUrl,
    required this.fullName,
    required this.initial,
    required this.isUser,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const bgColors = [
      Color(0xFFE8F4FD),
      Color(0xFFFFF3E0),
      Color(0xFFE8F5E9),
      Color(0xFFFCE4EC),
      Color(0xFFEDE7F6),
    ];
    const fgColors = [
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFF4527A0),
    ];
    final idx =
        initial.isNotEmpty ? initial.codeUnitAt(0) % bgColors.length : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColors[idx],
                border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
              ),
              child: ClipOval(
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Center(
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: fgColors[idx],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: fgColors[idx],
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            // Name + label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.textView16SemiBold.copyWith(
                      color: const Color(0xFF272727),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isUser ? tr('my_account') : tr('teacher_account'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF9E9E9E),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionGroup extends StatelessWidget {
  final List<Widget> items;

  const _SectionGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          return Column(
            children: [
              items[i],
              if (i < items.length - 1)
                const Divider(
                  height: 1,
                  indent: 54,
                  color: Color(0xFFF3F4F6),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = titleColor ?? const Color(0xFF272727);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 14),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: titleColor != null
                    ? titleColor!.withValues(alpha: 0.5)
                    : const Color(0xFFCCCCCC),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
