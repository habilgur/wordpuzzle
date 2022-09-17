import 'package:get/get.dart';

class QuestionServices extends GetxController {


  // List<Question> creteQuestionList() {
  //   List<Question> quesList = [];
  //   var theList = turkishWords.where((item) => item.length < 12).toList();
  //
  //   for (int i = 0; i <= gameQuestionLength; i++) {
  //     var question = theList[Random().nextInt(theList.length)].toLowerCase();
  //
  //     // Create User Answer Map
  //     var userAnswerMap = List.generate(question.split("").length, (index) {
  //       return AnswerKey(correctValue: question.split("")[index], correctIndex: index);
  //     });
  //
  //     // Lets create Random Keys
  //     var questionWithRandomKeys = createRandomKeys(question);
  //
  //     // Create Shuffled Chars
  //     List<PadKey> shuffledPadKeys = createShufflePadKeys(questionWithRandomKeys);
  //
  //     // Set Hinted AnswerMap for Game Start
  //     createHintThenRemoveFromShuffledKeys(userAnswerMap, shuffledPadKeys);
  //
  //     // Generate Question List
  //     quesList.add(
  //       Question(
  //         question: question,
  //         keyboardMap: shuffledPadKeys,
  //         answerMap: userAnswerMap,
  //         wrongClickLimit: userAnswerMap.length - 2,
  //       ),
  //     );
  //   }
  //
  //   return quesList;
  // }
  //
  // Question createAQuestion() {
  //   var theList = turkishWords.where((item) => item.length < 12).toList();
  //
  //   var question = theList[Random().nextInt(theList.length)].toLowerCase();
  //
  //   // Create User Answer Map
  //   var userAnswerMap = List.generate(question.split("").length, (index) {
  //     return AnswerKey(correctValue: question.split("")[index], correctIndex: index);
  //   });
  //
  //   // Lets create Random Keys
  //   var questionWithRandomKeys = createRandomKeys(question);
  //
  //   // Create Shuffled Chars
  //   List<PadKey> shuffledPadKeys = createShufflePadKeys(questionWithRandomKeys);
  //
  //   // Set Hinted AnswerMap for Game Start
  //   createHintThenRemoveFromShuffledKeys(userAnswerMap, shuffledPadKeys);
  //
  //   // Generate Question
  //   return Question(
  //     question: question,
  //     keyboardMap: shuffledPadKeys,
  //     answerMap: userAnswerMap,
  //   );
  // }
  //
  // List<String> createRandomKeys(String question) {
  //   List<String> randomList = [];
  //   var randomCharNum = question.length < 5 ? 3 : 4;
  //
  //   for (int i = 0; i < randomCharNum; i++) {
  //     var randomKey = turkishAlphabet[Random().nextInt(turkishAlphabet.length)].toLowerCase();
  //     randomList.add(randomKey);
  //   }
  //
  //   List<String> questionWithRandomKeys = [question.split(""), randomList].expand((x) => x).toList();
  //   return questionWithRandomKeys;
  // }
  //
  // List<PadKey> createShufflePadKeys(List<String> questionWithRandomKeys) {
  //   List<PadKey> shuffledCharsKeyPad = [];
  //   for (int i = 0; i < questionWithRandomKeys.length; i++) {
  //     shuffledCharsKeyPad.add(
  //       PadKey(
  //         value: questionWithRandomKeys[i],
  //         isClicked: false,
  //       ).clone(),
  //     );
  //   }
  //   // Shuffle SChar
  //   shuffledCharsKeyPad.shuffle();
  //
  //   return shuffledCharsKeyPad;
  // }
  //
  // void createHintThenRemoveFromShuffledKeys(List<AnswerKey> userAnswerMap, List<PadKey> shuffledPadKeys) {
  //   int rand1 = 0, rand2 = 0, rand3 = 0;
  //   List<int> rndList = [];
  //   while (rand1 == rand2 || rand2 == rand3 || rand1 == rand3) {
  //     rand1 = Random().nextInt(userAnswerMap.length);
  //     rand2 = Random().nextInt(userAnswerMap.length);
  //     rand3 = Random().nextInt(userAnswerMap.length);
  //     if (rand1 != rand2 && rand2 != rand3 && rand1 != rand3) {
  //       rndList.add(rand1);
  //       rndList.add(rand2);
  //       rndList.add(rand3);
  //     }
  //   }
  //
  //   // Set how much hint display via question lenght
  //   if (userAnswerMap.length <= 4) {
  //     rndList.remove(rand1);
  //     rndList.remove(rand2); // 1 hint
  //   } else if (userAnswerMap.length <= 6) {
  //     rndList.remove(rand3); // 2 hint
  //   }
  //
  //   // change current value to correct value and hintShow true in userAnswerMap randomly according question length
  //   for (int index in rndList) {
  //     var answerKeyWithHint = userAnswerMap[index];
  //     answerKeyWithHint.hintShow = true;
  //     answerKeyWithHint.currentValue = answerKeyWithHint.correctValue;
  //
  //     // Remove hinted value from shuffle Keys
  //     var removeKeyPadWithHint = shuffledPadKeys.where((k) => k.value == answerKeyWithHint.currentValue).first;
  //     shuffledPadKeys.remove(removeKeyPadWithHint);
  //   }
  // }
  //
  // reShuffleQuestionKeyPad({required Question currentQuestion}) {
  //   if (currentQuestion.isDone) return;
  //   currentQuestion.keyboardMap!.shuffle();
  //   return currentQuestion;
  // }
}
