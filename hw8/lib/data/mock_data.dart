import '../models/course_model.dart';
import '../models/subject_model.dart';
import '../models/user_profile_model.dart';

class AppData {
  static const List<SubjectModel> subjects = [
    SubjectModel(title: 'Математика'),
    SubjectModel(title: 'Физика'),
    SubjectModel(title: 'Химия'),
    SubjectModel(title: 'Биология'),
    SubjectModel(title: 'История'),
    SubjectModel(title: 'География'),
    SubjectModel(title: 'Информатика'),
    SubjectModel(title: 'Литература'),
  ];

  static const List<CourseModel> courses = [
    CourseModel(
      title: 'Flutter базовый',
      imagePath: 'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
    ),
    CourseModel(
      title: 'Dart основы',
      imagePath: 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Dart_programming_language_logo.svg',
    ),
    CourseModel(
      title: 'UI практика',
      imagePath: 'https://upload.wikimedia.org/wikipedia/commons/3/39/Flutter_logo.png',
    ),
    CourseModel(
      title: 'Layouts',
      imagePath: 'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
    ),
  ];

  static const UserProfileModel profile = UserProfileModel(
    fullName: 'Amir Mahmud',
    locationLabel: 'Бишкек',
    birthYear: 2009,
    avatarPath: '',
  );
}
