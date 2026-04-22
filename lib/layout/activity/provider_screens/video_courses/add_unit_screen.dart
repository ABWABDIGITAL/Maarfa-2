import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/video_course/provider_video_course_cubit.dart';
import '../../../../res/value/color/color.dart';

class AddUnitScreen extends StatefulWidget {
  final int courseId;

  const AddUnitScreen({super.key, required this.courseId});

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _youtubeUrlController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderVideoCourseCubit(),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            tr('add_unit'),
            style: TextStyle(
              fontFamily: 'Shamel',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: headerColor,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: headerColor),
            onPressed: () => Get.back(),
          ),
        ),
        body: BlocConsumer<ProviderVideoCourseCubit,
            ProviderVideoCourseState>(
          listener: (context, state) {
            if (state is ProviderVideoUnitAddedState) {
              Get.back(result: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is ProviderVideoCourseLoadingState;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // YouTube URL
                    _buildLabel(tr('youtube_url')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _youtubeUrlController,
                      hint: 'https://www.youtube.com/watch?v=...',
                      validator: (v) =>
                          v == null || v.isEmpty ? tr('error_message') : null,
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    _buildLabel(tr('unit_title')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _titleController,
                      hint: tr('unit_title'),
                      validator: (v) =>
                          v == null || v.isEmpty ? tr('error_message') : null,
                    ),
                    SizedBox(height: 16.h),

                    // Description
                    _buildLabel(tr('description')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _descriptionController,
                      hint: tr('description'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.h),

                    // Duration (minutes)
                    _buildLabel(tr('video_duration')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _durationController,
                      hint: tr('video_duration'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    // Price
                    _buildLabel(tr('unit_price')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _priceController,
                      hint: tr('unit_price'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 32.h),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final durationMinutes =
                                      int.tryParse(_durationController.text) ??
                                          0;
                                  final data = <String, dynamic>{
                                    'title': _titleController.text,
                                    'description':
                                        _descriptionController.text,
                                    'youtube_url':
                                        _youtubeUrlController.text,
                                    'duration': durationMinutes * 60,
                                    'price': _priceController.text.isEmpty
                                        ? '0'
                                        : _priceController.text,
                                  };
                                  context
                                      .read<ProviderVideoCourseCubit>()
                                      .addUnitWithUrl(
                                          widget.courseId, data);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  color: white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                tr('add_unit'),
                                style: TextStyle(
                                  fontFamily: 'Shamel',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Shamel',
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontFamily: 'Shamel',
        fontSize: 13.sp,
        color: const Color(0xFF1A1A1A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Shamel',
          fontSize: 13.sp,
          color: textfieldColor,
        ),
        filled: true,
        fillColor: white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: mainColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: red),
        ),
      ),
    );
  }
}
