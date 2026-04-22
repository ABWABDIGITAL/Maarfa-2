import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../bloc/video_course/provider_video_course_cubit.dart';
import '../../../../res/value/color/color.dart';

class CreateVideoCourseScreen extends StatefulWidget {
  const CreateVideoCourseScreen({super.key});

  @override
  State<CreateVideoCourseScreen> createState() =>
      _CreateVideoCourseScreenState();
}

class _CreateVideoCourseScreenState extends State<CreateVideoCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
            tr('create_video_course'),
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
            if (state is ProviderVideoCourseCreatedState) {
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
                    // Image picker
                    Text(
                      tr('upload_image'),
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: double.infinity,
                        height: 160.h,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: borderColor),
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined,
                                      size: 40.sp, color: grey),
                                  SizedBox(height: 8.h),
                                  Text(
                                    tr('upload_image'),
                                    style: TextStyle(
                                      fontFamily: 'Shamel',
                                      fontSize: 12.sp,
                                      color: grey,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Title
                    _buildLabel(tr('course_name')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _titleController,
                      hint: tr('course_name'),
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
                      maxLines: 4,
                    ),
                    SizedBox(height: 16.h),

                    // Price
                    _buildLabel(tr('total_price')),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: _priceController,
                      hint: tr('total_price'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? tr('error_message') : null,
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
                                  final data = <String, dynamic>{
                                    'title': _titleController.text,
                                    'description':
                                        _descriptionController.text,
                                    'total_price':
                                        double.tryParse(
                                            _priceController.text) ??
                                        0,
                                  };
                                  context
                                      .read<ProviderVideoCourseCubit>()
                                      .createVideoCourse(data);
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
                                tr('create_video_course'),
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
