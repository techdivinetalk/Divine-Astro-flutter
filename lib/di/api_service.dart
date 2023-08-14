// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:divine_astrologer/di/shared_preference_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' as get_data;

// import 'base_model.dart';

// class ApiService {
//   final SharedPreferenceService preferenceService =
//       get_data.Get.find<SharedPreferenceService>();
//   Dio _dio = Dio();
//   String tag = "API call :";
//   CancelToken? _cancelToken;
//   static final Dio mDio = Dio();

//   static final ApiService _instance = ApiService._internal();
//   factory ApiService({bool stripeAuth = false}) {
//     mDio.options.headers['Authorization'] =
//         "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5IiwianRpIjoiYWQ4MTFkMzQ5ZDU0ZDBmMzdmN2QyNTc1OTM1MzhhYTMyOGZlYzI4YzM4ZjNlOTIxMzgwM2NlYWVjOGZjZWYxM2JkYWY0ODlhNmU2NjgyZDEiLCJpYXQiOjE2OTIwMTg0MTcuODM4MTI5LCJuYmYiOjE2OTIwMTg0MTcuODM4MTMyLCJleHAiOjE4NDk4NzEyMTcuODMwNjMsInN1YiI6IjU3MyIsInNjb3BlcyI6W119.vL2tViPgFiFCEnWjbrOHXtOl3aegAXeY05L7g6jD3QWUrHrM-gUL6awO5iKR6Tr9xL-8Ayl6JpubWofeErTsRFbc3JTa18i2vWveTP9y5uYM2_DsGsxA6WBW3AjOCOfhyHYwaux6HqH7GJpQ7_FvFggaSuob7EIhCSVUXCO7wxGopuoRBJwHf86b61Vf_ZKxnU2_17YMowErww-zJmY88KroXhkYC_ZLN3cT05S5k7v8lZUZVh3VlODxHMvHi8VGp8XQYUE86vALDn8CFrujxB8HmsifkeA1ExGkMmjV4aU_N_xe_zKDTXI1QVJRI98QG3su2FYtDP6ka7xrVXlhFhm0O25lT4bOfiru9aeTkyogDqSdO0_sZQdKnm13V_MDuUD6ScSu6V-tfIyQffTQ69W5Tk7Hiqhp4ZmBbhSvIosn02POmfM1irCFGKRZArj2oJuv-5EbTTbjuyrNTYHBIaYH5BWCcxAwqNvSerhv_PpcBFc_Ck3eysgSS_QZ3gJJeAqCl65eOtHA06V-xfUuSyn89XjCo3HJgfLbjjh6IRisjC9BR2EEfJoXm-Ff4CdSZAWs7_u_5Rm34e9gb9kQirDqsWxm8669BbmLeeuH3mMRx_EQsFDpEuvISffQgK6qTfrg6yiaT4zCFahwIAMsJrQXE3v6GtGxNCh3Z9HMQXA";
//     // "Bearer ${SharedPreference().getString(userToken)}";
//     mDio.options.headers['Accept-Version'] = "v1";
//     mDio.options.headers['Accept-Language'] = "en";
//     return _instance;
//   }

//   ApiService._internal() {
//     _dio = initApiServiceDio();
//   }

//   Dio initApiServiceDio() {
//     _cancelToken = CancelToken();
//     final baseOption = BaseOptions(
//       connectTimeout: const Duration(seconds: 60),
//       receiveTimeout: const Duration(seconds: 60),
//       baseUrl: "https://wakanda-api.divinetalk.live/admin/v6/",
//       contentType: 'application/json',
//       headers: {
//         'Authorization':
//             "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5IiwianRpIjoiZDFhNTFlOTlkNzg1MDk4NWFmNmE0NTI4NWNkZWIwZDUwNzYwMTFjODU1MzY3N2MwMzU0YjE1N2ZlOWU1MzJhZmVjZjlmYjNiZTI4YmIxNTYiLCJpYXQiOjE2OTIwMTgwMzcuNzE1MjI2LCJuYmYiOjE2OTIwMTgwMzcuNzE1MjI4LCJleHAiOjE4NDk4NzA4MzcuNzA4MDA1LCJzdWIiOiI1NzMiLCJzY29wZXMiOltdfQ.ND-hV_45MivriDSynPvwktBqlS0qEIDXPFkGP58dQXrLLfcwMM8NSvEl78imYXuhn5WhbxTCOcgyD6Tl3Np0OTLPSJe0eCxGp60rsQIEXWYSsQxL-xmAid-yDCNCAayqmFdFbmHoSo6VuMGW_nq3IO4KhnsQ3qX4Oq2mg3tYwD-WvpDFerNn87BrLLPje49c-S_MrhYiNzixVjF5SBVvRwRgSVTvS-AzP0Ep_xDWnV0QpWEtwKAftzTYCo-vs63AHUFRSfDv3Dx_aPxIG-2E0nvD3z908AFFjYLzH5nYFKvSm2wfH_5erJqT27to_rBdDRKvYDVq64f2s8suAr2818YALfBTE6dkAyYyMGW12GeOOxszmvQqxZ2nXhQ3B1FPI0GE_L3dgpdncFTzQ02YYmcwlTJc80mymnJPVkIsGidH-7iQQplnbeD0cTYUGPW3ah6kHLzJikHvJhfKq0ChTvMCwr168ePA89-22FkhesWp5NjjWtTVXvwt30NJorKY-VScn10zINbC6EmxhUzSCpGoDyCt0xEJxVlNUKPSOjLW1zECYo9tpgnY53Ur8Os_o1ukWPGgWb-POcfEPACBvyq-EmmjbPoAsIfy3M3iS0GkqHCyf8RdL7a76FtQM2fR1wr3gpelEAwZi_p7EgydvXlfJlmIjHtCQVsuE9sOgDs",
//         'Accept-Version': "v1",
//         'Accept-Language': "en",
//       },
//     );
//     mDio.options = baseOption;
//     final mInterceptorsWrapper = InterceptorsWrapper(
//       onRequest: (options, handler) {
//         debugPrint("$tag headers ${options.headers.toString()}",
//             wrapWidth: 1024);
//         debugPrint("$tag ${options.baseUrl.toString() + options.path}",
//             wrapWidth: 1024);
//         debugPrint("$tag queryParameters ${options.queryParameters.toString()}",
//             wrapWidth: 1024);
//         debugPrint("$tag ${options.data.toString()}", wrapWidth: 1024);
//         return handler.next(options);
//       },
//       onResponse: (e, handler) {
//         debugPrint("Code  ${e.statusCode.toString()}", wrapWidth: 1024);
//         debugPrint("Response ${e.toString()}", wrapWidth: 1024);
//         return handler.next(e);
//       },
//       onError: (e, handler) {
//         debugPrint("$tag ${e.error.toString()}", wrapWidth: 1024);
//         debugPrint("$tag ${e.response.toString()}", wrapWidth: 1024);
//         return handler.next(e);
//       },
//     );
//     mDio.interceptors.add(mInterceptorsWrapper);
//     return mDio;
//   }

//   void cancelRequests({CancelToken? cancelToken}) {
//     cancelToken == null
//         ? _cancelToken!.cancel('Cancelled')
//         : cancelToken.cancel();
//   }

//   Future<Response> get(
//     BuildContext context,
//     String endUrl, {
//     Map<String, dynamic>? params,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       final isConnected = await checkInternet();
//       if (!isConnected) {
//         return Future.error(BaseModel(message: "Internet not connected"));
//       }
//       return await (_dio.get(
//         endUrl,
//         queryParameters: params,
//         cancelToken: cancelToken ?? _cancelToken,
//         options: options,
//       ));
//       // .catchError((e) {
//       //   if (!checkSessionExpire(e, context)) {
//       //     return e;
//       //   }
//       // });
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         return Future.error(BaseModel(message: "Poor internet connection"));
//       }
//       rethrow;
//     }
//   }

//   Future<Response> multipartPut(
//     BuildContext context,
//     String endUrl, {
//     FormData? data,
//     Map<String, dynamic>? params,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     return await (_dio.put(
//       endUrl,
//       data: data,
//       queryParameters: params,
//       cancelToken: cancelToken ?? _cancelToken,
//       options: options,
//     ));
//   }

//   Future<Response> put(
//     BuildContext context,
//     String endUrl, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       final isConnected = await checkInternet();
//       if (!isConnected) {
//         return Future.error(BaseModel(message: "Internet not connected"));
//       }
//       return await (_dio.put(
//         endUrl,
//         data: data,
//         queryParameters: params,
//         cancelToken: cancelToken ?? _cancelToken,
//         options: options,
//       ));
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         return Future.error(BaseModel(message: "Poor internet connection"));
//       }
//       rethrow;
//     }
//   }

//   Future<Response> post(
//     BuildContext context,
//     String endUrl, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       final isConnected = await checkInternet();
//       if (!isConnected) {
//         return Future.error(BaseModel(message: "Internet not connected"));
//       }
//       return await (_dio.post(
//         endUrl,
//         data: data,
//         queryParameters: params,
//         cancelToken: cancelToken ?? _cancelToken,
//         options: options,
//       ));
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         return Future.error(BaseModel(message: "Poor internet connection"));
//       }
//       rethrow;
//     }
//   }

//   Future<Response> delete(
//     BuildContext context,
//     String endUrl, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       final isConnected = await checkInternet();
//       if (!isConnected) {
//         return Future.error(BaseModel(message: "Internet not connected"));
//       }
//       return await (_dio.delete(
//         endUrl,
//         data: data,
//         queryParameters: params,
//         cancelToken: cancelToken,
//         options: options,
//       ));
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         return Future.error(BaseModel(message: "Poor internet connection"));
//       }
//       rethrow;
//     }
//   }

//   Future<Response> multipartPost(
//     BuildContext context,
//     String endUrl, {
//     FormData? data,
//     CancelToken? cancelToken,
//     Options? options,
//   }) async {
//     try {
//       final isConnected = await checkInternet();
//       if (!isConnected) {
//         return Future.error(BaseModel(message: "Internet not connected"));
//       }
//       return await (_dio.post(
//         endUrl,
//         data: data,
//         cancelToken: cancelToken,
//         options: options,
//       ));
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         return Future.error(BaseModel(message: "Poor internet connection"));
//       }
//       rethrow;
//     }
//   }

//   Future<Response> patch(
//     BuildContext context,
//     String endUrl, {
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? params,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     try {
//       final isConnected = await checkInternet();
//       if (!isConnected) {
//         return Future.error(BaseModel(message: "Internet not connected"));
//       }
//       return await (_dio.patch(
//         endUrl,
//         data: data,
//         queryParameters: params,
//         cancelToken: cancelToken ?? _cancelToken,
//         options: options,
//       ));
//     } on DioError catch (e) {
//       if (e.type == DioErrorType.connectionTimeout) {
//         return Future.error(BaseModel(message: "Poor internet connection"));
//       }
//       rethrow;
//     }
//   }

//   Future<bool> checkInternet() async {
//     final connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
// }
