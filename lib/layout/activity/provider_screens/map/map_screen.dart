import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_academy/layout/activity/provider_screens/add_contant/add_course_screen.dart';

import '../../../../bloc/location/location_cubit.dart';
import '../../../../model/location_model/predictions_model.dart';
import '../../../../res/value/color/color.dart';
import '../../../../service/location/location_service.dart';
import '../../../../widget/buttons/master/master_button.dart';
import '../../../../widget/space/space.dart';

class MapScreen extends StatelessWidget {
  final bool isAddress;
  final dynamic data;
  final bool isEdit;
  const MapScreen(
      {super.key, this.isAddress = false, this.data, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    // final bloc = BlocProvider.of<LocationCubit>(context);
    return BlocProvider(
        create: (BuildContext context) {
          final cubit = LocationCubit();
          cubit.getLocation();
          return cubit;
        },
        child: BlocConsumer<LocationCubit, LocationState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = LocationCubit.get(context);
              return BlocBuilder<LocationCubit, LocationState>(
                  builder: (context, state) {
                // bloc.getLocation();
                final isKeyboard =
                    MediaQuery.of(context).viewInsets.bottom != 0;
                // var provider = bloc.of<LocationProvider>(context);
                var location = LocationService();
                return Scaffold(
                  body: SafeArea(
                    child: Stack(
                      children: [
                        /// Map & Address & set Location
                        Column(
                          children: [
                            /// Map
                            Expanded(
                              child: GoogleMap(
                                mapType: MapType.normal,
                                markers: bloc.markers,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(bloc.lat ?? 30.044256,
                                      bloc.lng ?? 30.044256),
                                  zoom: 14.4746,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  bloc.mapController.complete(controller);
                                },
                                onTap: (point) {
                                  bloc.setPointManual(point);
                                },
                              ),
                            ),

                            /// Address
                            Container(
                              width: double.infinity,
                              height: 40,
                              color: white,
                              child: Center(
                                child: Text(
                                  bloc.address,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 14.sp,
                                          color: black,
                                          height: 1),
                                ),
                              ),
                            ),

                            /// set Location Buttons
                            MasterButton(
                                sidePadding: 15,
                                // buttonStyle: TextStyles.appBarStyle
                                //     .copyWith(color: mainColor),
                                buttonRadius: 30,
                                buttonText: tr("set_location"),
                                onPressed:
                                    // isAddress
                                    //     ?
                                    () {
                                  bloc.getAddress(bloc.lat!, bloc.lng!);
                                  // bloc.setMapAddress(bloc.address);

                                  // BlocProvider.of<ContentCubit>(context)
                                  //     .chooseSpecialization(data);

                                  Get.to(() => const AddCourseScreen(
                                      // isEdit: isEdit,
                                      // data: data,
                                      ));
                                  bloc.markers.clear();
                                }
                                //     : () {
                                //         bloc.getAddress(bloc.lat, bloc.lng);
                                //         Get.to(() => const HomeScreen());
                                //         bloc.markers.clear();
                                //       },
                                ),
                            const Space(
                              boxHeight: 20,
                            ),
                            // buildButton(
                            //   context,
                            //   background: redColor,
                            //   text: 'Set Location',
                            //   fontSize: 16.sp,
                            //   height: 40,
                            //   onPress: () {
                            //     Navigator.pop(context);
                            //     bloc.markers.clear();
                            //     print('Lng : ${bloc.lng} \n Lat : ${bloc.lat}');
                            //   },
                            // ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 12, bottom: 180),
                            child: SizedBox(
                              height: 38,
                              width: 38,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Material(
                                  color: transparent,
                                  child: InkWell(
                                    onTap: () {
                                      bloc.getLocation();
                                    },
                                    borderRadius: BorderRadius.circular(2),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.location_on,
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, right: 10, left: 10),
                              child: Row(
                                children: [
                                  Card(
                                    color: white,
                                    elevation: 2,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    semanticContainer: true,
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                        bloc.markers.clear();
                                      },
                                      child: SizedBox(
                                        height: 55.h,
                                        width: 55.h,
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Card(
                                  //     color: white,
                                  //     elevation: 2,
                                  //     clipBehavior: Clip.antiAliasWithSaveLayer,
                                  //     semanticContainer: true,
                                  //     child: SizedBox(
                                  //         height: 55.h,
                                  //         child: Row(
                                  //           children: [
                                  //             // const SizedBox(
                                  //             //   child: Image(
                                  //             //     image: AssetImage(googleLocation),
                                  //             //     height: 40,
                                  //             //   ),
                                  //             // ),
                                  //             Expanded(
                                  //               child: LocationTextField(
                                  //                 onChanged: (value) {
                                  //                   location.searchPlace(value);
                                  //                 },
                                  //                 textEditingController:
                                  //                     location.searchController,
                                  //                 hintText: tr("search_here"),
                                  //                 fontSize: 18.sp,
                                  //                 maxLines: 1,
                                  //                 cursorHeight: 30,
                                  //                 textHeight: 1.5,
                                  //                 hintStyle: Theme.of(context)
                                  //                     .textTheme
                                  //                     .caption!
                                  //                     .copyWith(
                                  //                         fontSize: 18.sp,
                                  //                         fontWeight:
                                  //                             FontWeight.normal,
                                  //                         height: 2),
                                  //                 contentPadding:
                                  //                     const EdgeInsets
                                  //                             .symmetric(
                                  //                         horizontal: 10),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         )),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            if (isKeyboard)
                              Expanded(
                                child: StreamBuilder<PredictionsModel?>(
                                  stream: location.searchStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          color: transparent,
                                        );
                                      }
                                      final data = snapshot.data;

                                      /// List of Auto Complete Text
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 65, right: 10),
                                        child: Card(
                                          elevation: 2,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          color: white,
                                          child: ListView.builder(
                                            itemCount:
                                                data!.predictions!.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () async {
                                                  var place =
                                                      await LocationService()
                                                          .getPlace(data
                                                              .predictions![
                                                                  index]
                                                              .description!);
                                                  await bloc.goToPlace(place);
                                                  bloc.setPointManual(place);
                                                },
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: SizedBox(
                                                        height: 70,
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            data
                                                                .predictions![
                                                                    index]
                                                                .description!,
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.right,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        20.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      color: grey,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      color: transparent,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            }));
  }
}
