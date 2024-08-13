class MasterDataResponse {
  final MasterData? data;

  MasterDataResponse({
    this.data,
  });

  MasterDataResponse.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String,dynamic>?) != null ? MasterData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.toJson()
  };
}

class MasterData {
  final int? call;
  final int? camera;
  final int? chat;
  final int? chatAssistance;
  final int? ecom;
  final int? gifts;
  final int? homePage;
  final int? isLiveCall;
  final int? kundli;
  final int? live;
  final int? queue;
  final int? remidies;
  final int? tarrotCard;
  final int? templates;
  final int? truecaller;
  final int? voip;
  final int? isPrivacyPolicy;
  final int? isServerMaintenance;
  final int? maximumStorySize;

  MasterData({
    this.call,
    this.camera,
    this.chat,
    this.chatAssistance,
    this.ecom,
    this.gifts,
    this.isPrivacyPolicy,
    this.homePage,
    this.isLiveCall,
    this.kundli,
    this.live,
    this.queue,
    this.remidies,
    this.tarrotCard,
    this.templates,
    this.truecaller,
    this.voip,
    this.isServerMaintenance,
    this.maximumStorySize,
  });

  MasterData.fromJson(Map<String, dynamic> json)
      : call = json['call'] as int?,
        camera = json['camera'] as int?,
        chat = json['chat'] as int?,
        isPrivacyPolicy = json['isPrivacyPolicy'] as int?,
        chatAssistance = json['chat_assistance'] as int?,
        ecom = json['ecom'] as int?,
        gifts = json['gifts'] as int?,
        homePage = json['homePage'] as int?,
        isLiveCall = json['isLiveCall'] as int?,
        kundli = json['kundli'] as int?,
        live = json['live'] as int?,
        queue = json['queue'] as int?,
        remidies = json['remidies'] as int?,
        tarrotCard = json['tarrotCard'] as int?,
        templates = json['templates'] as int?,
        truecaller = json['truecaller'] as int?,
        maximumStorySize = json['maximumStorySize'] as int?,
        isServerMaintenance = json['isServerMaintenance'] as int?,
        voip = json['voip'] as int?;

  Map<String, dynamic> toJson() => {
    'call' : call,
    'camera' : camera,
    'chat' : chat,
    'chat_assistance' : chatAssistance,
    'ecom' : ecom,
    'gifts' : gifts,
    'homePage' : homePage,
    'isLiveCall' : isLiveCall,
    'kundli' : kundli,
    'isPrivacyPolicy' : isPrivacyPolicy,
    'live' : live,
    'queue' : queue,
    'remidies' : remidies,
    'tarrotCard' : tarrotCard,
    'templates' : templates,
    'truecaller' : truecaller,
    'maximumStorySize' : maximumStorySize,
    'isServerMaintenance' : isServerMaintenance,
    'voip' : voip
  };
}