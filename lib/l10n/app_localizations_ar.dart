// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get done => 'تم';

  @override
  String get doIt => 'ابدأ الآن';

  @override
  String get confirm => 'تأكيد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get or => 'أو';

  @override
  String stepOfTotal(int current, int total) {
    return '$current/$total';
  }

  @override
  String get personalizedPlanHint => 'هذا يساعدنا في إنشاء خطتك الخاصة';

  @override
  String get onboardingTitle1 => 'ثمن التميز هو الانضباط';

  @override
  String get onboardingTitle2 => 'اللياقة لم تكن ممتعة بهذا الشكل من قبل';

  @override
  String get onboardingTitle3 => 'لا مزيد من الأعذار. ابدأ الآن';

  @override
  String get onboardingDescription =>
      'Lorem ipsum dolor sit amet consectetur. Eu urna ut gravida quis id pretium purus. Mauris massa';

  @override
  String get loginTitleOne => 'أهلاً بك';

  @override
  String get loginTitleTwo => 'مرحباً عودتك';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب بعد؟';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get registerTitle => 'أهلاً بك، أنشئ حسابك';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get otpCode => 'رمز التحقق';

  @override
  String get enterYourOtp => 'أدخل رمز التحقق';

  @override
  String get checkYourEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get didntReceiveCode => 'لم يصلك رمز التحقق؟';

  @override
  String get resendCode => 'إعادة إرسال الرمز؟';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get passwordLengthHint => 'تأكد أنها 8 أحرف أو أكثر';

  @override
  String get genderTitle => 'حدثنا عن نفسك!';

  @override
  String get genderSubtitle => 'نحتاج إلى معرفة جنسك';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get ageTitle => 'كم عمرك؟';

  @override
  String get yearUnit => 'سنة';

  @override
  String get weightTitle => 'ما هو وزنك؟';

  @override
  String get kgUnit => 'كجم';

  @override
  String get heightTitle => 'ما هو طولك؟';

  @override
  String get cmUnit => 'سم';

  @override
  String get goalTitle => 'ما هو هدفك؟';

  @override
  String get goalGainWeight => 'زيادة الوزن';

  @override
  String get goalLoseWeight => 'خسارة الوزن';

  @override
  String get goalGetFitter => 'تحسين اللياقة';

  @override
  String get goalGainFlexibility => 'زيادة المرونة';

  @override
  String get goalLearnBasics => 'تعلم الأساسيات';

  @override
  String get activityTitle => 'ما هو مستوى نشاطك البدني المعتاد؟';

  @override
  String get activityRookie => 'مبتدئ جداً';

  @override
  String get activityTrueBeast => 'محترف بالفعل';

  @override
  String get levelBeginner => 'مبتدئ';

  @override
  String get levelIntermediate => 'متوسط';

  @override
  String get levelAdvanced => 'متقدم';

  @override
  String homeGreeting(String name) {
    return 'مرحباً $name،';
  }

  @override
  String get homeSubtitle => 'هيا نبدأ يومك';

  @override
  String get explore => 'استكشف';

  @override
  String get category => 'الفئة';

  @override
  String get categoryGym => 'الجيم';

  @override
  String get categoryFitness => 'اللياقة';

  @override
  String get categoryYoga => 'اليوغا';

  @override
  String get categoryAerobics => 'الأيروبكس';

  @override
  String get categoryTrainer => 'المدرب';

  @override
  String get recommendationToday => 'توصية اليوم';

  @override
  String get jogging => 'الجري الخفيف';

  @override
  String get pushUp => 'تمرين الضغط';

  @override
  String get squat => 'تمرين القرفصاء';

  @override
  String get upcomingWorkouts => 'التمارين القادمة';

  @override
  String get fullBody => 'الجسم كامل';

  @override
  String get chest => 'الصدر';

  @override
  String get arm => 'الذراع';

  @override
  String get arms => 'الذراعان';

  @override
  String get shoulder => 'الكتف';

  @override
  String get bodyBack => 'الظهر';

  @override
  String get legs => 'الأرجل';

  @override
  String get stomach => 'البطن';

  @override
  String get recommendationForYou => 'توصيات لك';

  @override
  String get breakfast => 'الفطور';

  @override
  String get lunch => 'الغداء';

  @override
  String get dinner => 'العشاء';

  @override
  String get popularTraining => 'التدريبات الشائعة';

  @override
  String get strengthenChest => 'تمارين تقوّي صدرك';

  @override
  String get strengthenBack => 'تمارين تقوّي ظهرك';

  @override
  String get strengthenBody => 'تمارين تقوّي جسمك';

  @override
  String tasksCount(int count) {
    return '$count مهمة';
  }

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get activityTab => 'النشاط';

  @override
  String get workouts => 'التمارين';

  @override
  String minutesShort(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String caloriesShort(int calories) {
    return '$calories سعرة';
  }

  @override
  String setsAndReps(int sets, int reps) {
    return '$sets مجموعات × $reps تكرار';
  }

  @override
  String get foodRecommendation => 'توصيات الطعام';

  @override
  String get energy => 'الطاقة';

  @override
  String get protein => 'البروتين';

  @override
  String get carbs => 'الكربوهيدرات';

  @override
  String get fat => 'الدهون';

  @override
  String get ingredients => 'المكونات';

  @override
  String get recommendation => 'التوصيات';

  @override
  String get smartCoach => 'المدرب الذكي';

  @override
  String chatGreeting(String name) {
    return 'مرحباً $name، أنا مدربك الذكي';
  }

  @override
  String get chatHelpPrompt => 'كيف يمكنني مساعدتك اليوم؟';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get previousConversations => 'المحادثات السابقة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get selectLanguage => 'اختيار اللغة';

  @override
  String get currentLanguageName => 'العربية';

  @override
  String get security => 'الأمان';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get help => 'المساعدة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get yourWeightTapToEdit => 'وزنك (اضغط للتعديل)';

  @override
  String get yourGoalTapToEdit => 'هدفك (اضغط للتعديل)';

  @override
  String get yourActivityTapToEdit => 'مستوى نشاطك (اضغط للتعديل)';

  @override
  String get closeAppConfirm => 'هل أنت متأكد أنك تريد إغلاق التطبيق؟';

  @override
  String get accepted => 'تم قبول الطلب بنجاح';

  @override
  String get orderStatusUpdatedSuccessfully => 'تم تحديث حالة الطلب بنجاح';

  @override
  String get failureInternetConnection =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get failureTimeout => 'انتهت مهلة الطلب. حاول مرة أخرى.';

  @override
  String get failureCancel => 'تم إلغاء الطلب.';

  @override
  String get failureBadCertificate =>
      'فشل الاتصال الآمن. شهادة الخادم غير صالحة.';

  @override
  String get failureBadRequest =>
      'طلب غير صالح. تحقق من بياناتك وحاول مرة أخرى.';

  @override
  String get failureUnauthorized => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get failureForbidden => 'ليس لديك صلاحية للقيام بهذا الإجراء.';

  @override
  String get failureNotFound => 'العنصر المطلوب غير موجود.';

  @override
  String get failureMethodNotAllowed => 'هذا الإجراء غير مسموح به.';

  @override
  String get failureConflict =>
      'يوجد تعارض مع الحالة الحالية. حدّث الصفحة وحاول مرة أخرى.';

  @override
  String get failureUnprocessableEntity =>
      'تعذر معالجة بياناتك. راجعها وحاول مرة أخرى.';

  @override
  String get failureTooManyRequests =>
      'طلبات كثيرة جداً. انتظر قليلاً ثم حاول مرة أخرى.';

  @override
  String get failureServerError => 'حدث خطأ في الخادم. حاول لاحقاً.';

  @override
  String get failureUnknown => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordMinLength => 'يجب ألا تقل كلمة المرور عن 8 أحرف';

  @override
  String get passwordStrongRules =>
      'يجب أن تحتوي كلمة المرور على حرف كبير وحرف صغير ورقم ورمز خاص';

  @override
  String get confirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get confirmPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get usernameMinLength => 'اسم المستخدم قصير جداً';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get firstNameOnlyLetters => 'يجب أن يحتوي الاسم الأول على أحرف فقط';

  @override
  String get lastNameRequired => 'اسم العائلة مطلوب';

  @override
  String get lastNameOnlyLetters => 'يجب أن يحتوي اسم العائلة على أحرف فقط';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get phoneInvalid => 'يرجى إدخال رقم هاتف صالح';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get fieldMinLength => 'هذا الحقل قصير جداً';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح';

  @override
  String get loggedIn => 'تم تسجيل الدخول بنجاح';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get profilePhotoUpdated => 'تم تحديث صورة الملف الشخصي';

  @override
  String get workoutSaved => 'تم حفظ التمرين';

  @override
  String get workoutCompleted => 'تم إنهاء التمرين، أحسنت!';

  @override
  String get workoutPlanStarted => 'تم بدء خطة التمرين';

  @override
  String get workoutDeleted => 'تم حذف التمرين';

  @override
  String get exerciseAddedToWorkout => 'تمت إضافة التمرين إلى جدولك';

  @override
  String get mealLogged => 'تم تسجيل الوجبة';

  @override
  String get waterLogged => 'تم تسجيل كمية المياه';

  @override
  String get weightLogged => 'تم تسجيل الوزن';

  @override
  String get measurementsSaved => 'تم حفظ القياسات';

  @override
  String get progressPhotoUploaded => 'تم رفع صورة التقدم';

  @override
  String get goalCreated => 'تم إنشاء الهدف';

  @override
  String get goalAchieved => 'تم تحقيق الهدف، مبروك!';

  @override
  String get newPersonalRecord => 'رقم شخصي جديد!';

  @override
  String get reminderSet => 'تم ضبط التذكير';

  @override
  String get settingsSaved => 'تم حفظ الإعدادات';
}
