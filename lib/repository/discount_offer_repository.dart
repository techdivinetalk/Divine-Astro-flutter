import 'dart:convert';
import 'dart:developer';

import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/model/home_page_model_class.dart';
import 'package:flutter/foundation.dart';

import '../common/app_exception.dart';
import '../model/discount_offer_response.dart';

class DiscountOfferRepository extends ApiProvider{

 Future< List<DiscountOffer>> getAllDiscountOffers()async{

   try{

     final response = await get(
       getCustomOffer,
       headers: await getJsonHeaderURL(),
     );

     if (response.statusCode == 200) {
       if (json.decode(response.body)["status_code"] == 401) {
         throw CustomException(json.decode(response.body)["error"]);
       } else {
         print("response body is ${response.body}");
         
         final discountOffersList =
         DiscountOfferData.fromJson(json.decode(response.body));
         return discountOffersList.discountOffers??[];
       }
     } else {
       print('throwing error');
       throw CustomException(json.decode(response.body)["error"]);
     }

   } catch (e,s){
     debugPrint("we got $e $s");
     rethrow;
   }

  }
}