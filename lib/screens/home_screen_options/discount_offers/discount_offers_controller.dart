import 'package:divine_astrologer/repository/discount_offer_repository.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:get/get.dart';

import '../../../model/home_page_model_class.dart';

class DiscountOffersController extends GetxController{
  late List<DiscountOffer> discountOffers ;
  Loading loading = Loading.initial;

  @override
  void onInit() {
    super.onInit();
    getDiscountOffers();
  }

  getDiscountOffers()async{
loading = Loading.loading;
update();

final List<DiscountOffer> discountList = await DiscountOfferRepository().getAllDiscountOffers();

discountOffers = discountList;
loading = Loading.loaded;
update();
  }
}