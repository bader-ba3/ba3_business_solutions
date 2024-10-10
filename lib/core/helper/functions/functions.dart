import 'dart:io';

import 'package:ba3_business_solutions/controller/account/account_customer_view_model.dart';
import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/model/account/account_customer.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/app_strings.dart';
import '../../utils/pdf_invoice_api.dart';

bool getIfAccountHaveCustomers(String accId) {
  if (accId.startsWith("acc")) {
    return getAccountModelFromId(accId)?.accCustomer?.firstOrNull != null;
  } else {
    return getAccountModelFromName(accId)?.accCustomer?.firstOrNull != null;
  }
}

bool getCustomerHaveVAT(String customerName) {
  bool withVAT = true;
  withVAT = Get.find<AccountCustomerViewModel>()
          .customerMap
          .values
          .where(
            (element) => element.customerAccountName == customerName && element.customerVAT == AppStrings.mainVATCategory,
          )
          .firstOrNull !=
      null;
  return withVAT;
}

List<AccountCustomer> getAccountCustomers(String accId) {
  if (accId.startsWith("acc")) {
    return getAccountModelFromId(accId)!.accCustomer!;
  } else {
    return getAccountModelFromName(accId)!.accCustomer!;
  }
}

String getInvPayTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.invPayTypeCash:
      return "نقدي";
    case AppStrings.invPayTypeDue:
      return "اجل";
  }

  return "UNKNOWN";
}

String getGlobalTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.globalTypeBond:
      return "سند";
    case AppStrings.bondTypeCredit:
      return "سند  قبض";
    case AppStrings.bondTypeDaily:
      return "سند يومية";
    case AppStrings.bondTypeDebit:
      return "سند دفع";
    case AppStrings.bondTypeInvoice:
      return "سند قيد";
    case AppStrings.bondTypeStart:
      return "قيد افتتاحي";
    case AppStrings.chequeTypeCatch:
      return "شيك قبض";
    case AppStrings.chequeTypePay:
      return "شيك دفع";
  }

  return "فاتورة ${getPatModelFromPatternId(type).patName!}";
}

String getAccountPaidStatusFromEnum(String type, bool isPositive) {
  switch (type) {
    case AppStrings.paidStatusFullUsed:
      return isPositive ? "مقبوض كليا" : "مدفوع كليا";
    case AppStrings.paidStatusNotUsed:
      return isPositive ? "غير مقبوض" : "غير مدفوع";
    case AppStrings.paidStatusSemiUsed:
      return isPositive ? "مقبوض جزئيا" : "مدفوع جزئيا";
  }
  return type;
}

String getUserStatusFromEnum(String type) {
  switch (type) {
    case AppStrings.userStatusOnline:
      return "موجود";
    case AppStrings.userStatusAway:
      return "في الخارج";
  }
  return type;
}

String getInvTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.invoiceTypeSales:
      return "بيع";
    case AppStrings.invoiceTypeBuy:
      return "شراء";
    case AppStrings.invoiceTypeAdd:
      return "إدخال";
    case AppStrings.invoiceTypeChange:
      return "مناقلة";
    case AppStrings.invoiceTypeSalesWithPartner:
      return "مبيعات مع نسبة شريك";
  }
  return type;
}

String getChequeTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.chequeTypeCatch:
      return "شيك قبض";
    case AppStrings.chequeTypePay:
      return "شيك دفع";
  }
  return type;
}

List<String> getDatesBetween(DateTime startDate, DateTime endDate) {
  List<String> dates = [];
  DateTime currentDate = startDate;

  while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    dates.add(currentDate.toString().split(" ")[0]);
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return dates;
}

String getBondTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.bondTypeDaily:
      return "سند يومية";
    case AppStrings.bondTypeDebit:
      return "سند دفع";
    case AppStrings.bondTypeCredit:
      return "سند قبض";
    case AppStrings.bondTypeStart:
      return "قيد افتتاحي";
    case AppStrings.bondTypeInvoice:
      return "سند قيد";
  }

  return type;
}

String getBondEnumFromType(String type) {
  switch (type) {
    case "سند يومية":
      return AppStrings.bondTypeDaily;
    case "سند دفع":
      return AppStrings.bondTypeDebit;
    case "سند قبض":
      return AppStrings.bondTypeCredit;
    case "قيد افتتاحي":
      return AppStrings.bondTypeStart;
    case "سند قيد":
      return AppStrings.bondTypeInvoice;
  }

  return type;
}

String getProductTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.productTypeService:
      return "مواد خدمية";
    case AppStrings.productTypeStore:
      return "مواد مستودعية";
  }
  return type;
}

String getPatNameFromId(String id) {
// return "سند مولد من فاتورة ${Get.find<PatternViewModel>().patternModel[id]?.patName}";
  return Get.find<PatternViewModel>().patternModel[id]?.patName ?? "";
}

String getPatTypeFromId(String id) {
// return "سند مولد من فاتورة ${Get.find<PatternViewModel>().patternModel[id]?.patName}";
  return Get.find<PatternViewModel>().patternModel[id]?.patType ?? "";
}

String getAccountTypeFromEnum(String type) {
  switch (type) {
    case AppStrings.accountTypeDefault:
      return "حساب عادي";
    case AppStrings.accountTypeFinalAccount:
      return "حساب ختامي";
    case AppStrings.accountTypeAggregateAccount:
      return "حساب تجميعي";
    // case Const.accountTypeChequeCatch:
    //   return "حساب شيكات قبض";
    // case Const.accountTypeChequePay:
    //   return "حساب شيكات دفع";
    // case Const.accountTypeBank:
    //   return "حساب مصرف";
  }
  return "error";
}

String getChequeStatusFromEnum(String type) {
  switch (type) {
    case AppStrings.chequeStatusPaid:
      return "تم الدفع";
    case AppStrings.chequeStatusNotPaid:
      return "لم يتم الدفع";
    case AppStrings.chequeStatusNotAllPaid:
      return "تم الدفع جزئبا";
  }
  return "error";
}

double getVatFromName(text) {
  return text == "a"
      ? 0
      : text == "GCC"
          ? 0.05
          : 0;
}

String getRoleNameFromEnum(String type) {
  switch (type) {
    case AppStrings.roleUserRead:
      return "القراءة";
    case AppStrings.roleUserWrite:
      return "الكتابة";
    case AppStrings.roleUserUpdate:
      return "التعديل";
    case AppStrings.roleUserDelete:
      return "الحذف";
    case AppStrings.roleUserAdmin:
      return "الإدارة";
  }
  return "error";
}

String getPageNameFromEnum(String type) {
  switch (type) {
    case AppStrings.roleViewInvoice:
      return "الفواتير";
    case AppStrings.roleViewBond:
      return "السندات";
    case AppStrings.roleViewAccount:
      return "الحسابات";
    case AppStrings.roleViewProduct:
      return "المواد";
    case AppStrings.roleViewStore:
      return "المستودعات";
    case AppStrings.roleViewPattern:
      return "انماط البيع";
    case AppStrings.roleViewCheques:
      return "الشيكات";
    case AppStrings.roleViewSeller:
      return "البائعون";
    case AppStrings.roleViewReport:
      return "تقارير المبيعات";
    case AppStrings.roleViewImport:
      return "استيراد المعلومات";
    case AppStrings.roleViewTarget:
      return "التارغت";
    case AppStrings.roleViewTask:
      return "التاسكات";
    case AppStrings.roleViewInventory:
      return "الجرد";
    case AppStrings.roleViewUserManagement:
      return "إدارة المستخدمين";
    case AppStrings.roleViewDue:
      return "الاستحقاق";
    case AppStrings.roleViewStatistics:
      return "التقارير";
    case AppStrings.roleViewTimer:
      return "المؤقت";
    case AppStrings.roleViewDataBase:
      return "ادارة قواعد البيانات";
    case AppStrings.roleViewCard:
      return "ادارة البطاقات";
    case AppStrings.roleViewHome:
      return "الصفحة الرئيسية";
  }
  return "error";
}

String getNameOfRoleFromEnum(String type) {
  switch (type) {
    case AppStrings.roleUserRead:
      return "قراءة البيانات";
    case AppStrings.roleUserWrite:
      return "كتابة البيانات";
    case AppStrings.roleUserUpdate:
      return "تعديل البيانات";
    case AppStrings.roleUserDelete:
      return "حذف البيانات";
    case AppStrings.roleUserAdmin:
      return "إدارة البيانات";
  }
  return type;
}

String extractNumbersAndCalculate(String input) {
  // استبدال الفاصلة العربية بالنقطة

  input = replaceArabicNumbersWithEnglish(input);
  String cleanedInput = input.replaceAll('٫', '.');

  // تحقق مما إذا كانت السلسلة تحتوي على معاملات حسابية
  bool hasOperators = cleanedInput.contains(RegExp(r'[+\-*/]'));

  // معالجة الفواصل الزائدة بحيث تبقى فقط الفاصلة الأولى
  cleanedInput = cleanedInput.replaceAllMapped(RegExp(r'(\d+)\.(\d+)\.(\d+)'), (match) {
    return '${match.group(1)}.${match.group(2)}';
  });
  if (hasOperators) {
    // إذا كان هناك معاملات، قم باستخراج الأرقام والعمليات وإجراء الحسابات
    RegExp regex = RegExp(r'[0-9.]+|[+\-*/]');
    Iterable<Match> matches = regex.allMatches(cleanedInput);
    List<String> elements = matches.map((match) => match.group(0)!).toList();

    List<double> numbers = [];
    String? operation;

    for (var element in elements) {
      if (double.tryParse(element) != null) {
        double number = double.parse(element);
        if (operation == null) {
          numbers.add(number);
        } else {
          double lastNumber = numbers.removeLast();
          switch (operation) {
            case '+':
              numbers.add(lastNumber + number);
              break;
            case '-':
              numbers.add(lastNumber - number);
              break;
            case '*':
              numbers.add(lastNumber * number);
              break;
            case '/':
              numbers.add(lastNumber / number);
              break;
          }
          operation = null;
        }
      } else {
        operation = element;
      }
    }

    return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
  } else {
    //! إذا لم يكن هناك معاملات، فقط استخرج الأرقام /
    RegExp regex = RegExp(r'[0-9.]+');
    Iterable<Match> matches = regex.allMatches(cleanedInput);
    List<double> numbers = matches.map((match) => double.parse(match.group(0)!)).toList();

    // إذا لم توجد أرقام، قم بإرجاع 0
    return numbers.isNotEmpty ? numbers.first.toString() : "0.0";
  }
}

String formatNumberWithCommas(int number) {
  // تحويل الرقم إلى سلسلة نصية وتنسيقه باستخدام RegExp لإضافة الفاصلة كل ثلاث خانات
  return number.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
}

String formatDecimalNumberWithCommas(double number) {
  // ضبط الرقم العشري إلى رقمين بعد الفاصلة
  String formattedNumber = number.toStringAsFixed(2);

  // تحويل الرقم إلى سلسلة نصية وتجزئته إلى جزء صحيح وجزء عشري
  List<String> parts = formattedNumber.split('.');
  String integerPart = parts[0]; // الجزء الصحيح
  String decimalPart = parts[1]; // الجزء العشري المحدد إلى رقمين

  // تنسيق الجزء الصحيح باستخدام RegExp لإضافة الفاصلة كل ثلاث خانات
  String formattedIntegerPart = integerPart.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (Match match) => '${match[1]},',
  );

  return '$formattedIntegerPart.$decimalPart';
}

bool hasCommonElements(List<dynamic> list1, List<dynamic> list2) {
  // تحويل القائمتين إلى مجموعات (Sets)
  Set<dynamic> set1 = list1.toSet();
  Set<dynamic> set2 = list2.toSet();

  // التحقق من وجود أي عنصر مشترك بين المجموعتين
  return set1.intersection(set2).isNotEmpty;
}

DateTime getDueDate(String invTyp) {
  DateTime dueDate = DateTime.now();

  switch (invTyp) {
    case AppStrings.tabbySales:
      dueDate = getNextMonday();
    case AppStrings.stripSales:
      dueDate = DateTime.now().copyWith(day: dueDate.day + 5);
  }

  return dueDate;
}

bool getInvIsPay(String invTyp) {
  bool isPay = true;

  switch (invTyp) {
    case AppStrings.invoiceTypeBuy:
      isPay = false;
    case AppStrings.invoiceTypeSales:
      isPay = true;
    case AppStrings.invoiceTypeSalesWithPartner:
      isPay = false;
    default:
      isPay = true;
  }

  return isPay;
}

DateTime getNextMonday() {
  DateTime now = DateTime.now();

  // حساب الأيام المتبقية للوصول إلى الاثنين القادم
  int daysUntilMonday = DateTime.monday - now.weekday;

  // إذا كان اليوم الاثنين بالفعل، اجعل الأيام +7 للوصول إلى الاثنين القادم
  if (daysUntilMonday <= 0) {
    daysUntilMonday += 7;
  }

  // إضافة الأيام المتبقية إلى التاريخ الحالي للحصول على الاثنين القادم
  return now.add(Duration(days: daysUntilMonday));
}

String formatDateTimeFromString(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);

  // تحديد الفترة (AM/PM)
  String period = dateTime.hour >= 12 ? "PM" : "AM";

  // تحويل الساعة إلى تنسيق 12 ساعة
  int hour = dateTime.hour % 12;
  if (hour == 0) hour = 12; // تحويل الساعة 0 إلى 12

  // تنسيق التاريخ والوقت
  String formattedDateTime = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} \n"
      "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

  return formattedDateTime;
}

void sendEmail(String url, String userEmail) async {
  String username = 'ba3rak.ae@gmail.com'; // بريدك الإلكتروني
  String password = 'ggicttcumjanxath'; // كلمة المرور للتطبيق

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'اسم المرسل')
    ..recipients.add(userEmail) // البريد الإلكتروني للمستلم
    ..subject = 'الموضوع:فاتورتك الألكترونية من برج العرب للهواتف المتحركة بتاريخ ${Timestamp.now().toDate()}'
    // ..text = 'هذا هو نص الرسالة.'
    ..html = "<h1>شكرا لك لزيارتك محل برج العرب للهواتف المتحركة</h1>\n<p>لمراجعة الفاتورة يمكنك تتبع الرابط التالي \n $url</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('تم إرسال البريد الإلكتروني بنجاح: $sendReport');
  } on MailerException catch (e) {
    print('حدث خطأ أثناء الإرسال: ${e.toString()}');
    for (var p in e.problems) {
      print('مشكلة: ${p.code}: ${p.msg}');
    }
  }
}

Future<String> savePdfLocally(GlobalModel model) async {
  try {
    // توليد ملف الـ PDF
    final pdfFile = await PdfInvoiceApi.generate(model);

    // الحصول على مسار المستندات
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';

    // إنشاء ملف
    final file = File(path);

    // كتابة المحتويات إلى الملف
    await file.writeAsBytes(pdfFile);

    // تحويل المسار إلى URI للتعامل مع أي مشكلات مرتبطة بالمسارات
    final fileUri = Uri.file(path);

    print('تم حفظ الملف في المسار: $fileUri');
    return path;
  } catch (e) {
    print('حدث خطأ أثناء حفظ الملف: $e');
    return "error";
  }
}

void sendEmailWithPdfAttachment(GlobalModel model) async {
  String username = 'ba3rak.ae@gmail.com'; // بريدك الإلكتروني
  String password = 'ggicttcumjanxath'; // كلمة المرور للتطبيق

  final smtpServer = gmail(username, password);
  String pdfFilePath = await savePdfLocally(model);
  final message = Message()
    ..from = Address(username, 'اسم المرسل')
    ..recipients.add("burjalarab000@gmail.com") // البريد الإلكتروني للمستلم
    ..subject = 'الموضوع:فاتورتك الألكترونية من برج العرب للهواتف المتحركة بتاريخ ${Timestamp.now().toDate()}'
    ..html = "<h1>شكرا لك لزيارتك محل برج العرب للهواتف المتحركة</h1>\n<p>لمراجعة الفاتورة يمكنك تتبع الرابط التالي \n </p>"
    // إرفاق ملف PDF
    ..attachments.add(FileAttachment(File(pdfFilePath))
      ..location = Location.inline
      ..fileName = 'invoice.pdf'); // اسم الملف في الرسالة

  try {
    final sendReport = await send(message, smtpServer);
    print('تم إرسال البريد الإلكتروني بنجاح: $sendReport');
    // print('تم إرسال البريد الإلكتروني بنجاح: ');
  } on MailerException catch (e) {
    print('حدث خطأ أثناء الإرسال: ${e.toString()}');
    for (var p in e.problems) {
      print('مشكلة: ${p.code}: ${p.msg}');
    }
  }
}
