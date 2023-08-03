import 'package:get/get.dart';

class PriceChangeReqController extends GetxController {
  var listData = <PriceListModelClass>[
    PriceListModelClass('Customer Satisfaction', '74%', '*Customer Satisfaction must be Excellent which means >=66%*'),
    PriceListModelClass('30 Days Busy Time', '3 hours', '*Last 30 days average busy time must be >=4 hours*'),
    PriceListModelClass('Eligible for price change?', 'Not Eligible', ''),
  ].obs;
}

class PriceListModelClass {
  String? priceTag, amount, description;

  PriceListModelClass(this.priceTag, this.amount, this.description);
}
