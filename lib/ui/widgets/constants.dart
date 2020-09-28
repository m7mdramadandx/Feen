import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

const double formContainerHeight = 430;

Widget loadResult() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: SpinKitChasingDots(
        size: 50,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: index.isEven ? primaryColor : grey,
            ),
          );
        },
      ),
    ),
  );
}

Widget noResult() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: SpinKitChasingDots(
        size: 50,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: index.isEven ? error : grey,
            ),
          );
        },
      ),
    ),
  );
}

const kTitleTextStyle = TextStyle(
  fontSize: 40.0,
  fontFamily: 'Cairo',
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const title = TextStyle(
  fontSize: 28.0,
  fontFamily: 'Cairo',
  color: primaryColor,
  fontWeight: FontWeight.bold,
);
const subtitle = TextStyle(
  fontSize: 22.0,
  fontFamily: 'Cairo',
  color: primaryColor,
  fontWeight: FontWeight.bold,
);
const normalText = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Cairo',
  color: Colors.white,
);

const smallText = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Cairo',
  color: primaryColor,
);

const kSloganTextStyle = TextStyle(
  fontSize: 18.0,
  fontFamily: 'Cairo',
  color: Colors.black87,
  fontWeight: FontWeight.bold,
);

const kStepsFontStyle = TextStyle(
  fontSize: 18.0,
  fontFamily: 'Cairo',
  color: primaryColor,
  fontWeight: FontWeight.bold,
);

const kLabelTextStyle = TextStyle(
    color: grey,
    fontWeight: FontWeight.bold,
    fontFamily: 'Cairo',
    fontSize: 16.0);

const KListTileTitle = TextStyle(
  fontSize: 16.0,
  fontFamily: 'Cairo',
  color: Colors.black87,
  fontWeight: FontWeight.w700,
);

const KListTileSubtitle = TextStyle(
  fontSize: 14.0,
  fontFamily: 'Cairo',
  color: Colors.black54,
  fontWeight: FontWeight.w600,
);

const kRoundedDecoration = InputDecoration(
  labelText: '',
  hintText: '',
  labelStyle: kLabelTextStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: grey),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

const List<String> imagePath = [
  "lib/assets/images/crowd.png",
  "lib/assets/images/map.png",
  "lib/assets/images/atm.png",
];

const List<String> description = [
  "وقتك ثمين لا تضيعه بصفوف الانتظار الطويلة",
  "تعرف على الماكينات و البنوك القريبين منك نسبة لموقعك الحالي",
  "اينما كانت وجهتك سنتيح لك معرفة ما اذا كانت الماكينة للايداع ام السحب ام تتوافر بها كلا الخدمتين",
];

const String tip000 =
    "•	السحب من ماكينة الخاصه بالبنك لا تأخذ عمولة علي عملية السحب اما في حالة استخدام بنك اخر يتم خصم عمولة قدرها 3:4 جم" +
        "\n";
const String tip001 =
    "•	يتم وضع الكارت في المكان المخصص لها في الماكينة التأكد من وضع الشريحه النحاسية للامام " +
        "\n";

const String tip002 = "•	يتم كتابة كلمه السرالمكونة من 4 أرقام" + "\n";
const String tip003 = "•	يتم الضغط علي كلمه استمرار لاستكمال العملية " + "\n";
const String tip004 = "•	يتم اختيار اللغه (العربيه /  الانجليزية )" + "\n";
const String tip005 =
    "•	سيتم إظهار بعض المبالغ التي من الممكن ان يكون احداها المطلوب أو إختيار خدمات اخري " +
        "\n";
const String tip006 =
    "•	الماكينات التي تقبل إيداع تكون في (افرع البنوك- المراكز – الاحياء – بعض المولات الكبري )" +
        "\n";

const String tip007 =
    "•	ليس كل الماكينات التي تحتوي علي بابين تكون ماكينة إيداع في بعض الاحيان يقوم البنك بتعطيل هذه الخدمة لسبب ما " +
        "\n";
const String tip008 =
    "•	اقصي مبلغ يمكن إيداعه عن طريق ماكينة الصراف الالي 20 ألف في اليوم الواحد و اذا كنت بحاجة الي إيداع مبلغ أكبر ( التوجه للبنك او تقسيم المبلغ علي كذا يوم )" +
        "\n";
const String tip009 =
    "•	ترفض الماكينة بعض العملات مثل ( الخمسة – العشرة – العشرين ) جنيه " +
        "\n";
const String tip010 = "•	درج جهه اليسارلإيدخال النقدية ( رأسي )" + "\n";
const String tip011 = "•	درج جهه اليمين لإيستلام النقدية ( أفقي )" + "\n";
const String tip012 =
    "•	لا يجوز السحب من ماكينة ATM موجود عليها ملصقات فيزا للشركات التي تقوم بدعمها" +
        "\n";
const String tip013 =
    "•	عند سحب البطاقة بعد الانتهاء من سحب الأموال، إذا لم تقوم بسحب بطاقتك في ظرف 30 ثانية، سوف تاخذها ماكينة الصراف الآلي وذلك لإجراءات أمنية لكي لا يتم سرق البطاقة" +
        "\n";
const String tip014 = "" + "\n";

const String tipp =
    "1)	معرفة رقم الماكينة (عن طريق طلب طباعة إيصال من اختيار الخدمات الاخرى – كشف حساب – طباعة إيصال )" +
        "\n";
const String tippp =
    "2)	الاتصال بخدمة العملاء و ابلاغ ممثل خدمة العملاء برقم البطاقة و رقم الماكينة في حالة استحقاقك للمال سيتم البنك باسترجاعه في أقرب وقت" +
        "\n";

/////////////////////////////معلومات عامة//////////////////////////////////
const String tip1 = "1)	يشترط وجود خدمه الايداع في الماكينه " + "\n";

const String tip2 = "2)	عليك اختيار الحساب الدي تريد استخدامه" + "\n";

const String tip3 =
    "3)	يتم تجهيز المبلغ بحداقصي 30 ورقه (يفضل البدأ بأقل مبلغ ممكن ثم باقي المبلغ مرة اخرى للتأكد من سلامة الماكينه)" +
        "\n";

const String tip4 =
    "4)	سيتم فتح الباب المخصص لوضع النقود على يسارالمستخدم" + "\n";

const String tip5 =
    "5)	يوضع المبلغ المراد إيداعه (في بعض الاحيان تقوم الماكينه برفض المبلغ اذا كانت الاوراق قديمه , مطويه , مقطوعه , مكتوب عليها ) تاكد من سلامه الورق قبل وضعه في الماكينه " +
        "\n";

const String tip6 =
    "6)	ستتم مراجعه المبلغ المقدم, اذا كان المبلغ صحيح او لا (في حالة اختيار نعم يرجى انتظار الفاتورة و بذالك تتم عملية الإيداع بنجاح اما في حاله اختيار لا ستخرج الاموال مرة اخري و عليك مراجعتها ثم وضعها مره اخري)" +
        "\n";

/////////////////////////////////خدمة الإيداع////////////////////////////////
const String tip01 = "1)	سيظهر لك المبلغ المتبقي في الحساب " + "\n";
const String tip02 =
    "2)	اذا اردت السحب منه سيتم الضغط علي خدمات اخرى لاجراء عملية السحب" + "\n";
const String tip03 =
    "3)	في حاله الاحتياج الي ايصال مطبوع يتم الضغط علي ايصال ثم انتظار خروج الايصال " +
        "\n";

////////////////////////////////خدمة معرفة الرصيد////////////////////////////////
const String tip11 = "1)	يشترط وجود خدمه الايداع في الماكينه " + "\n";
const String tip12 = "2)	يتم الضغط علي خدمات نقدية " + "\n";
const String tip13 = "3)	ثم الضغط علي تغيير عملة " + "\n";
const String tip14 =
    "4)	ستظهر شاشه بالعملات التي يقوم البنك بتحويلها ( لا يتم التحويل من الجنية المصري لاي عملة اخري )" +
        "\n";
const String tip15 = "5)	الضغط علي استمرار " + "\n";
const String tip16 =
    "6)	سيتم مراجعه المبلغ المحول ( بحد اقصي 30 ورقه ) " + "\n";
const String tip17 = "7)	الانتظار لاستيلام المبلغ المحول و الايصال " + "\n";

/////////////////////////////////خدمة التحويل من عملة الى اخرى/////////////////////////////////
const String tip101 =
    "1)	الضغط علي خدمات بدون بطاقة, ثم الضغط علي إيداع بدون بطاقة" + "\n";

const String tip102 =
    "2)	الضغط علي استمرار, ثم الضغط علي إيداع في الحساب " + "\n";

const String tip103 = "3)	كتابة رقم الحساب ( لا يقل عن 12 رقم )" + "\n";

const String tip104 =
    "4)	الضغط علي الرقم الصحيح ( بعد التاكد من صحة الرقم )" + "\n";

const String tip105 = "5)	ادخال رقم الهاتف" + "\n";

const String tip106 =
    "6)	الضغط علي الرقم الصحيح ( بعد التأكد من صحة الرقم )" + "\n";

const String tip107 =
    "7)	سيتم فتح الباب المخصص للإيداع ( الباب على يسارالمستخدم )" + "\n";

const String tip108 =
    "8)	إدخال المبلغ, ثم تأكد من صحة المبلغ و سلامة الاوراق  " + "\n";

const String tip109 =
    "9)	الضغط علي موافق ( في حالة صحة المبلغ الموضح امامك علي الشاشة )" + "\n";

const String tip1010 = "10)	استلام الايصال ثم الكارت " + "\n";

/////////////////////////////////خدمة الإيداع بدون بطاقة /////////////////////////////////
const String tip100 =
    "1)	الضغط علي مدفوعات و تبرعات ( تبرعات – سداد فواتير موبيل – سداد بطاقة ائتمان – الغاء) " +
        "\n";

const String tip110 =
    "2)	الضغط علي تبرعات, ثم اختر الحساب الذي ترغب باستخدامه" + "\n";

const String tip120 = "3)	سيظهر بعض الجهات التي تقبل التعامل مع البنك" + "\n";

const String tip130 = "4)	قم باختيار الجهة التي ترغب في التبرع لها " + "\n";

const String tip140 =
    "5)	اكتب المبلغ الذي ترغب بالتبرع به, ثم الضغط علي موافق لتأكيد البيانات " +
        "\n";

const String tip150 = "6)	انتظر الإيصال ثم الكارت " + "\n";

/////////////////////////////////خدمة التبرع /////////////////////////////////
const String tip111 =
    "1)	الضغط علي خدمات بدون بطاقة, ثم الضغط علي المحفظه الذكية, ثم الضغط على سحب نقدي" +
        "\n";
const String tip112 =
    "2)	ستظهر علي الشاشة ( هل لديك رقم سري متغير ؟ في حالة اختيار لا ستصلك رساله نصية تحتوي علي الرقم السري المتغير) " +
        "\n";
const String tip113 =
    "3)	كتابة رقم الموبيل المسجل عليه المحفظة ثم الضغط علي ادخال" + "\n";
const String tip114 = "4)	انتظار الرقم يبعت" + "\n";
const String tip115 =
    "5)	عند وصول الرقم يتم اعادة الخطوات السابقة (1و2و3) ثم في الخطوة الرابعة يتم الضغط علي نعم " +
        "\n";
const String tip116 = "6)	كتابة الرقم المرسل, ثم اختر اللغة" + "\n";
const String tip117 = "7)	كتابة المبلغ المراد سحبه " + "\n";
const String tip118 = "8)	استلام النقدية والإيصال " + "\n";

/////////////////////////////////خدمة المحفظة الذكية /////////////////////////////////

const String tip01000 = "1)	الضغط على خدمات اخرى, ثم الضغط على سحب" + "\n";

const String tip01001 =
    "2)	قم بكتابة المبلغ الذي تريده ثم التأكيد عليه ( 8 الاف جنيه حد أقصى )" +
        "\n";

const String tip01002 =
    "3)	بعد التأكيد على المبلغ الذي تريده سوف يظهر لك إذا ما كنت تريد إيصال بالعملية أم لا قم باختيار ما تريد وأنتظر لثواني ثم ستبدأ الماكينة في إخراج المال" +
        "\n";

const String tip01003 =
    "4)	استلم أموالك وتأكد منها وقم باستلام الوصل الذي يوضح رصيدك المتبقي وعملية السحب" +
        "\n";

/////////////////////////////////خدمة السحب /////////////////////////////////

const String apiKey = "AIzaSyAyLfzsvWUdO67AU6Jmpfp8BWfEI4IFTi8";

String alahlyImgUrl =
        "https://lh4.googleusercontent.com/p/AF1QipN-X45OaLPD1VR_ihiF3tjmqaJamqKHPaYLageM=s1600-w400",
    misrImgUrl =
        "https://pinjoor.com/pinjoor/wp-content/uploads/2019/06/Banque-Misr-ATM-5.jpg",
    kaheraImgUrl = "https://www.bankygate.com/upload/photo/gallery/0/0/321.jpg",
    alahlyImgUrlBank =
        "https://qryptocentral.com/wp-content/uploads/2020/02/S3Tvwyra_400x400.jpg",
    misrImgUrlBank =
        "https://www.banquemisr.com/en/aboutus/PublishingImages/Corporate%20ID/IDLogo.jpg",
    kaheraImgUrlBank =
        "https://www.fintechfutures.com/files/2019/06/banque-du-caire.jpg";
