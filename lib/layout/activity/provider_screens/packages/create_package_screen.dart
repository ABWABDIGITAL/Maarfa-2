import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/package/package_cubit.dart';
import '../../../../model/common/packages/package_model.dart';
import '../../../../repository/common/packages/package_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../widget/toast/toast.dart';
import '../../../view/connectivity/connectivity_view.dart';

class CreatePackageScreen extends StatefulWidget {
  final PackageModel? package;

  const CreatePackageScreen({super.key, this.package});

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = '4_sessions';
  bool _isActive = true;

  final List<Map<String, String>> _packageTypes = [
    {'value': '4_sessions', 'label': '4 Sessions'},
    {'value': '8_sessions', 'label': '8 Sessions'},
    {'value': '12_sessions', 'label': '12 Sessions'},
    {'value': 'full_term', 'label': 'Full Term'},
  ];

  bool get isEditing => widget.package != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _selectedType = widget.package!.type ?? '4_sessions';
      _priceController.text = widget.package!.price?.toString() ?? '';
      _descriptionController.text = widget.package!.description ?? '';
      _isActive = widget.package!.isActive ?? true;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageCubit(PackageRepository()),
      child: Scaffold(
        appBar: DefaultAppBar(
          title: isEditing ? tr("edit") : tr("create_package"),
        ),
        body: ConnectivityView(
          child: BlocConsumer<PackageCubit, PackageState>(
            listener: (context, state) {
              if (state is PackageCreatedState ||
                  state is PackageUpdatedState) {
                showToast(tr("success"));
                Get.back();
              }
              if (state is PackageErrorState) {
                showToast(state.message);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Package Type Selector
                      Text(
                        tr("package_type"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: _packageTypes.map((type) {
                            final isSelected =
                                _selectedType == type['value'];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedType = type['value']!;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? mainColor.withValues(alpha: 0.1)
                                      : white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: borderColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: isSelected ? mainColor : grey,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      _getTypeTranslation(type['value']!),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: isSelected
                                            ? mainColor
                                            : blackColor,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Price Input
                      Text(
                        tr("package_price"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: tr("package_price"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: mainColor),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr("required_field");
                          }
                          if (double.tryParse(value) == null) {
                            return tr("invalid_number");
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Description
                      Text(
                        tr("description"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: tr("description"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: mainColor),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Active Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr("active"),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: blackColor,
                            ),
                          ),
                          Switch(
                            value: _isActive,
                            activeThumbColor: mainColor,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: state is PackageLoadingState
                              ? null
                              : () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: state is PackageLoadingState
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: const CircularProgressIndicator(
                                    color: white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isEditing
                                      ? tr("edit")
                                      : tr("create_package"),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'type': _selectedType,
      'price': double.parse(_priceController.text),
      'description': _descriptionController.text,
      'is_active': _isActive,
    };

    if (isEditing) {
      PackageCubit.get(context).updatePackage(widget.package!.id!, data);
    } else {
      PackageCubit.get(context).createPackage(data);
    }
  }

  String _getTypeTranslation(String type) {
    switch (type) {
      case '4_sessions':
        return tr("sessions_4");
      case '8_sessions':
        return tr("sessions_8");
      case '12_sessions':
        return tr("sessions_12");
      case 'full_term':
        return tr("full_term");
      default:
        return type;
    }
  }
}
