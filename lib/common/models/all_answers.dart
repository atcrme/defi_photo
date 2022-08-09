import './answer.dart';

import './enum.dart';
import '../providers/all_questions.dart';
import '../../misc/custom_containers/map_serializable.dart';

class AllAnswers extends MapSerializable<Answer> {
  // Constructors and (de)serializer
  AllAnswers({required AllQuestions questions}) : super() {
    for (var question in questions) {
      this[question] = Answer(isActive: false);
    }
  }
  AllAnswers.fromSerialized(map) : super.fromSerialized(map);

  @override
  Answer deserializeItem(map) {
    return Answer.fromSerialized(map);
  }

  // Attributes and methods
  int get number => length;
  int get numberActive {
    int active = 0;
    forEach((answer) {
      if (answer.value.isActive) active++;
    });
    return active;
  }

  int get numberAnswered {
    int answered = 0;
    forEach((answer) {
      if (answer.value.isAnswered) answered++;
    });
    return answered;
  }

  int get numberNeedTeacherAction {
    int number = 0;
    forEach((answer) {
      if (answer.value.action == ActionRequired.fromTeacher) {
        number++;
      }
    });
    return number;
  }

  int get numberNeedStudentAction {
    int number = 0;
    forEach((answer) {
      if (answer.value.action == ActionRequired.fromStudent) {
        number++;
      }
    });
    return number;
  }

  AllAnswers fromQuestions(AllQuestions questions) {
    var out = AllAnswers(questions: AllQuestions());
    for (var question in questions) {
      out[question] = this[question]!;
    }
    return out;
  }

  AllQuestions activeQuestions(AllQuestions questions) {
    var out = AllQuestions();
    for (var question in questions) {
      if (this[question]!.isActive) out.add(question);
    }
    return out;
  }

  AllAnswers activeAnswers(AllQuestions questions) {
    var out = AllAnswers(questions: AllQuestions());
    for (var question in questions) {
      final answer = this[question]!;
      if (answer.isActive) out[question] = answer;
    }
    return out;
  }

  AllQuestions answeredQuestions(AllQuestions questions,
      {bool shouldBeActive = true}) {
    var out = AllQuestions();
    for (var question in questions) {
      final answer = this[question]!;
      var activeState = !shouldBeActive || (shouldBeActive && answer.isActive);
      if (activeState && answer.isAnswered) out.add(question);
    }
    return out;
  }

  AllQuestions unansweredQuestions(AllQuestions questions,
      {bool shouldBeActive = true}) {
    var out = AllQuestions();
    for (var question in questions) {
      final answer = this[question]!;
      var activeState = !shouldBeActive || (shouldBeActive && answer.isActive);
      if (activeState && !answer.isAnswered) out.add(question);
    }
    return out;
  }

  AllQuestions inactiveQuestions(AllQuestions questions) {
    var out = AllQuestions();
    for (var question in questions) {
      final answer = this[question]!;
      if (!answer.isActive) out.add(question);
    }
    return out;
  }
}
