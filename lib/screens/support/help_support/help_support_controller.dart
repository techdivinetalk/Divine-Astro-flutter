import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../repository/user_repository.dart';

class HelpSupportController extends GetxController {
  HelpSupportController(this.userRepository);

  final UserRepository userRepository;

  List<Map<String, dynamic>> problems = [];
  List<Map<String, dynamic>> problemsQuestions = [];
  var selectedProblem;
  selectProblemFun(data) {
    selectedProblem = data;
    update();
  }

  var selectedAnswer;
  selectAnswerFun(data) {
    selectedAnswer = data;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    List<Map<String, dynamic>> t = [
      {
        "id": "1",
        "title": "How to earn more money?",
      },
      {
        "id": "2",
        "title": "Issue with previous order?",
      },
      {
        "id": "3",
        "title": "Quality Related F&Qs",
      },
      {
        "id": "4",
        "title": "How to earn more money?",
      },
      {
        "id": "5",
        "title": "Issue with previous order?",
      },
      {
        "id": "6",
        "title": "Quality Related F&Qs",
      },
      {
        "id": "7",
        "title": "How to earn more money?",
      },
      {
        "id": "8",
        "title": "Issue with previous order?",
      },
      {
        "id": "9",
        "title": "Quality Related F&Qs",
      },
      {
        "id": "10",
        "title": "How to earn more money?",
      },
      {
        "id": "11",
        "title": "Issue with previous order?",
      },
      {
        "id": "12",
        "title": "Quality Related F&Qs",
      },
    ];

    problems = t;
    List<Map<String, dynamic>> q = [
      {
        "id": "1",
        "title": "Offers",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      },
      {
        "id": "2",
        "title": "Boosts",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      },
      {
        "id": "3",
        "title": "Boosts",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      },
      {
        "id": "4",
        "title": "Boosts",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      },
      {
        "id": "5",
        "title": "Boosts",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      },
      {
        "id": "6",
        "title": "Boosts",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      },
      {
        "id": "7",
        "title": "Boosts",
        "detail":
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      }
    ];

    problemsQuestions = q;
  }
}
