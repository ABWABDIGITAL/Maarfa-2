// ignore: constant_identifier_names
import 'dart:io';

// ignore: constant_identifier_names
// const String BASE_URL = "https://ma3rfa.backend.tanfeethi.tanfeethi.com.sa";
// const String BASE_URL = "https://newma3refabackend.tanfeethi.tanfeethi.com.sa";
// const String BASE_URL = "https://backend.maarefa.app/public/index.php/";
// const String BASE_URL = "https://backend.maarefa.app/public/index.php";
final String BASE_URL = Platform.isAndroid
    ? "http://10.0.2.2:8000"
    : "http://localhost:8000";
// "https://myacademy.moltaqadev.com";
// "https://moazez-alta3lemy.com";
// "https://myacademy.moltaqa-wo.net";

const appID = '27f16866203b45f59cbc5b53b0f13b08';

// "https://myacademy.hishamelgez.com";
// ignore: constant_identifier_names
// const String ApiUrl = "http://192.168.1.15:8000/api";
final String ApiUrl = "$BASE_URL/api";

String key = Platform.isAndroid
    ? "AIzaSyALwAKfasDJHbf-KjylVi4M1Yco-XyvkwQ"
    : "AIzaSyDV91tbTbnj-cJ-r-2l1Xtb7tLbskspvt0";

// Package endpoints
const String clientPackagesUrl = "/clients/packages";
const String clientPackageShowUrl = "/clients/packages/{id}/show";
const String clientPackageSubscribeUrl = "/clients/packages/{id}/subscribe";
const String clientPackageSubscriptionsUrl = "/clients/packages/subscriptions";
const String clientPackageUseSessionUrl = "/clients/packages/package-subscriptions/{id}/use";
const String providerPackagesUrl = "/providers/packages";
const String providerPackageCreateUrl = "/providers/packages/create";
const String providerPackageUpdateUrl = "/providers/packages/{id}/update";
const String providerPackageDeleteUrl = "/providers/packages/{id}/delete";

// Video Course endpoints - Client
const String clientVideoCoursesUrl = "/clients/video-courses";
const String clientVideoCourseShowUrl = "/clients/video-courses/{id}";
const String clientVideoCoursePurchaseUrl = "/clients/video-courses/{id}/purchase";
const String clientVideoUnitPurchaseUrl = "/clients/video-units/{id}/purchase";
const String clientVideoUnitStreamUrl = "/clients/video-units/{id}/stream";
const String clientVideoPurchasesUrl = "/clients/video-purchases";

// Video Course endpoints - Provider
const String providerVideoCoursesUrl = "/provider/video-courses";
const String providerVideoCourseCreateUrl = "/provider/video-courses";
const String providerVideoCourseUpdateUrl = "/provider/video-courses/{id}";
const String providerVideoCourseDeleteUrl = "/provider/video-courses/{id}";
const String providerVideoUnitAddUrl = "/provider/video-courses/{id}/units";
const String providerVideoUnitUpdateUrl = "/provider/video-units/{id}";
const String providerVideoUnitDeleteUrl = "/provider/video-units/{id}";
