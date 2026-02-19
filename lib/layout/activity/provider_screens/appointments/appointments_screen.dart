import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/layout/view/connectivity/connectivity_view.dart';
import 'package:my_academy/layout/view/provider_appointments/provider_coming_appointments.dart';
import 'package:my_academy/layout/view/provider_appointments/provider_finished_appointments.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../../../../bloc/provider_appointments/provider_appointments_cubit.dart';
import '../../../view/provider_appointments/provider_appointment_view.dart';

class ProviderAppointmentsScreen extends StatefulWidget {
  const ProviderAppointmentsScreen({super.key});

  @override
  State<ProviderAppointmentsScreen> createState() =>
      _ProviderAppointmentsScreenState();
}

class _ProviderAppointmentsScreenState extends State<ProviderAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    final bloc = context.read<ProviderAppointmentsCubit>();
    switch (_tabController.index) {
      case 0:
        bloc.changeFilter("");
        break;
      case 1:
        bloc.changeFilter("comming");
        break;
      case 2:
        bloc.changeFilter("finished");
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ProviderAppointmentsCubit>(context),
      child: ConnectivityView(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: mainColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: mainColor,
                  indicatorWeight: 3,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(text: tr("all")),
                    Tab(text: tr("coming")),
                    Tab(text: tr("finished")),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    ProviderAppointments(status: ""),
                    ProviderComingAppointments(status: "comming"),
                    ProviderFinishedAppointments(status: "finished"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
