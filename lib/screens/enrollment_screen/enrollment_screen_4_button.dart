import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_3_button.dart';
import 'package:universal_html/js.dart' as js;
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_1_input.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';

class EnrollmentScreen4Button extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthDateController;
  final TextEditingController phoneNumberController;
  final TextEditingController requestDayController;
  final TextEditingController requestTimeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;
  final TextEditingController lessonStartDateController;
  // final TextEditingController cashReceiptNumberController;

  const EnrollmentScreen4Button({
    super.key,
    required this.nameController,
    required this.birthDateController,
    required this.phoneNumberController,
    required this.requestDayController,
    required this.requestTimeController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
    required this.lessonStartDateController,
    // required this.cashReceiptNumberController,
  });

  @override
  EnrollmentScreen4ButtonState createState() => EnrollmentScreen4ButtonState();
}

class EnrollmentScreen4ButtonState extends State<EnrollmentScreen4Button> {
  final scrollController = ScrollController();
  // String statusMessage = '';
  String errorMessage = '';
  late StudentProvider studentProvider;

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;

  // final TextEditingController phoneNumberController =
  //     TextEditingController(text: '+82');
  // final TextEditingController verificationCodeController =
  //     TextEditingController();
  // String verificationId = '';
  // bool isSent = false;
  // bool isVerified = false;
  // String selectedCountryCode = '+82'; // 추가된 부분
  // 국가 코드 목록 (필요한 경우 확장 가능)
  // List<String> countryCodes = ['+82', '+1', '+44', '+81', '+86', '+33'];

  @override
  Widget build(BuildContext context) {
    studentProvider = Provider.of<StudentProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ((screenWidth - 500) / 2)),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: [
            Text(
              errorMessageTranslate(errorMessage),
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60), // 버튼 사이즈 조정
                ),
                onPressed: submit,
                child: const Text(
                  '수강신청',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // TODO: 메일 주소 verification

  // submit 처리
  void submit() async {
    final TextEditingController pointsController = TextEditingController();
    final name = widget.nameController.text.trim();
    final birthDate = widget.birthDateController.text.trim();
    final phoneNumber = widget.phoneNumberController.text.trim();
    final requestDay = widget.requestDayController.text.trim();
    final requestTime = widget.requestTimeController.text.trim();
    final country = widget.countryController.text.trim();
    final skypeId = widget.skypeIdController.text.trim();
    final studyPurpose = widget.studyPurposeController.text.trim();
    final referralSource = widget.referralSourceController.text.trim();
    final lessonStartDate = widget.lessonStartDateController.text.trim();
    // final cashReceiptNumber = widget.cashReceiptNumberController.text.trim();
    errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        birthDate.isEmpty ||
        phoneNumber.isEmpty ||
        requestDay.isEmpty ||
        requestTime.isEmpty ||
        country.isEmpty ||
        skypeId.isEmpty ||
        lessonStartDate.isEmpty) {
      setState(() {
        // errorMessage = 'All fields are required.';
        errorMessage = '모든 필수 항목이 입력되어야 합니다.';
      });
      return;
    }

    if (!EnrollmentScreen.check) {
      setState(() {
        errorMessage = '필수 항목의 동의가 필요합니다.';
      });
      return;
    }
    try {
      setState(() {});
      bool? confirm = await ConfirmDialog.show(
        context: context,
        title: "수강료 결제",
        body: [
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: customTheme.colorScheme.secondary),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            '${EnrollmentScreen.selectedMonths.first}개월 수강권',
                          ),
                          Text(
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            '( 주${EnrollmentScreen.selectedDays.first}회 / ${EnrollmentScreen.selectedMins.first}분 )',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: customTheme.colorScheme.primary,
                          ),
                          '정가'),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          var price = EnrollmentScreen1Input.fee[
                                          EnrollmentScreen
                                              .selectedMonths.first]![
                                      EnrollmentScreen.selectedDays.first]![
                                  EnrollmentScreen.selectedMins.first]! *
                              EnrollmentScreen.selectedMonths.first;
                          return Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.primary,
                            ),
                            '${NumberFormat("###,###").format(price)} 원',
                          );
                        },
                      ),
                    ],
                  ),
                  // 적립금 사용
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: customTheme.colorScheme.primary,
                          ),
                          ' - 적립금 할인'),
                      const Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: customTheme.colorScheme.primary,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(5),
                                hintText: '0',
                                border: OutlineInputBorder(),
                              ),
                              controller: pointsController,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) {
                                int pointsHas =
                                    studentProvider.student?.data['points'] ??
                                        0;
                                int pointsUse = int.tryParse(v) ?? 0;
                                if (pointsUse > pointsHas) {
                                  pointsUse = pointsHas;
                                  pointsController.text = pointsHas.toString();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.primary,
                            ),
                            ' 원',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      style: TextStyle(
                        fontSize: 14,
                        color: customTheme.colorScheme.primary,
                      ),
                      '보유 적립금: ${NumberFormat("###,###").format(studentProvider.student?.data['points'] ?? 0)} 원',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: customTheme.colorScheme.primary,
                        ),
                        '결제금액',
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          var price = EnrollmentScreen1Input.fee[
                                          EnrollmentScreen
                                              .selectedMonths.first]![
                                      EnrollmentScreen.selectedDays.first]![
                                  EnrollmentScreen.selectedMins.first]! *
                              EnrollmentScreen.selectedMonths.first;
                          var pointDiscount =
                              int.tryParse(pointsController.text) ?? 0;
                          var finalPrice = price - pointDiscount;
                          return Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.secondary,
                            ),
                            '${NumberFormat("###,###").format(finalPrice)} 원',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
        trueButton: "결제하기",
        falseButton: "나중에 결제하기",
      );

      if (confirm == true) {
        var priceBeforeDiscount =
            EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![
                    EnrollmentScreen.selectedDays
                        .first]![EnrollmentScreen.selectedMins.first]! *
                EnrollmentScreen.selectedMonths.first;
        var pointDiscount = int.tryParse(pointsController.text) ?? 0;
        var finalPrice = priceBeforeDiscount - pointDiscount;
        var order =
            '딸기영어 수강권 (${EnrollmentScreen.selectedMonths.first}개월 주${EnrollmentScreen.selectedDays.first}회/${EnrollmentScreen.selectedMins.first}분)';
        var price = finalPrice.toDouble();
        Item item = Item();
        item.name = order; // 주문정보에 담길 상품명
        item.qty = 1; // 해당 상품의 주문 수량
        item.id =
            '${EnrollmentScreen.selectedMonths.first}MONTH_${EnrollmentScreen.selectedDays.first}TIMES_PER_WEEK_${EnrollmentScreen.selectedMins.first}MINUTES'; // 해당 상품의 고유 키
        item.price = price; // 상품의 가격

        User user = User(); // 구매자 정보
        user.username = name;
        user.email = studentProvider.student!.data['email'].split('#')[0];
        user.area = country;
        user.phone = phoneNumber;
        // user.addr = '서울시 동작구 상도로 222';

        // 성공 시 동작
        Student inputStudent = studentProvider.student!;
        // LectureState가 registeredOnly가 아니면 새로 만들어야함 (#2로)
        bool needToMakeNew = (inputStudent.getStudentLectureState() !=
            StudentState.registeredOnly);

        inputStudent.data['name'] = name;
        inputStudent.data['birthDate'] = birthDate;
        inputStudent.data['phoneNumber'] = phoneNumber;
        inputStudent.data['requestDay'] = requestDay;
        inputStudent.data['requestTime'] = requestTime;
        inputStudent.data['country'] = country;
        inputStudent.data['skypeId'] = skypeId;
        inputStudent.data['studyPurpose'] = studyPurpose;
        inputStudent.data['referralSource'] = referralSource;
        inputStudent.data['lessonStartDate'] = lessonStartDate;
        // newStudent.data['requestTime'] = '$requestDay-$requestTime';
        inputStudent.data['lessonPeriod'] = EnrollmentScreen.selectedMins.first;
        inputStudent.data['lessonDays'] = EnrollmentScreen.selectedDays.first;
        inputStudent.data['lessonMonths'] =
            EnrollmentScreen.selectedMonths.first;
        // inputStudent.data['cashReceiptNumber'] = cashReceiptNumber;
        inputStudent.data['program'] = EnrollmentScreen1Input.topic.keys
            .elementAt(EnrollmentScreen.selectedTopic);
        inputStudent.data['topic'] = EnrollmentScreen1Input.topic.values
                .elementAt(EnrollmentScreen.selectedTopic)[
            EnrollmentScreen.selectedTopicDetail];

        // 수업 종료 일자 계산
        inputStudent.data['modifiedLessonEndDate'] = inputStudent
            .data['lessonEndDate'] = DateFormat('yyyy-MM-dd').format(
          DateTime.parse(lessonStartDate).add(
            Duration(
              days: (7 * 4 * EnrollmentScreen.selectedMonths.first - 1),
            ),
          ),
        );

        // 수업 취소 횟수 계산
        inputStudent.data['cancelCountTotal'] =
            inputStudent.data['cancelCountLeft'] = EnrollmentScreen1Input
                    .cancelCount[EnrollmentScreen.selectedMonths.first]![
                EnrollmentScreen.selectedDays.first];
        inputStudent.data['cancelDates'] = [];
        inputStudent.data['cancelRequestDates'] = [];

        // 장기 홀드 횟수 계산
        inputStudent.data['holdCountTotal'] =
            inputStudent.data['holdCountLeft'] = EnrollmentScreen1Input
                    .holdCount[EnrollmentScreen.selectedMonths.first]![
                EnrollmentScreen.selectedDays.first];
        inputStudent.data['holdDates'] = [];
        inputStudent.data['holdRequestDates'] = [];

        // 결재 데이터
        // var price = EnrollmentScreen1Input
        //             .fee[EnrollmentScreen.selectedMonths.first]![
        //         EnrollmentScreen.selectedDays
        //             .first]![EnrollmentScreen.selectedMins.first]! *
        //     EnrollmentScreen.selectedMonths.first;
        // var pointDiscount = int.tryParse(pointsController.text) ?? 0;
        // var finalPrice = price - pointDiscount;
        inputStudent.data['billingAmount'] = price;
        inputStudent.data['billingDiscount'] = pointDiscount;
        inputStudent.data['billingFinal'] = finalPrice;

        // 기타 초기화 필요 항목
        inputStudent.data['tutorCancelDates'] = [];
        inputStudent.data['lessonTime'] = [];
        inputStudent.data['tutor'] = '';

        // 적립금 계산 (기존 points에서 차감)
        inputStudent.data['points'] = (inputStudent.data['points'] ?? 0) -
            (int.tryParse(pointsController.text) ?? 0);

        bootpay(
          context,
          item,
          user,
          order,
          price,
          inputStudent,
          needToMakeNew,
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }

  String webApplicationId = '66daa50286fd08d2213fc224';
  String androidApplicationId = '66daa50286fd08d2213fc225';
  String iosApplicationId = '66daa50286fd08d2213fc226';

  void bootpay(
    BuildContext context,
    Item item,
    User user,
    String orderName,
    double price,
    Student inputStudent,
    bool needToMakeNew,
  ) async {
    // bool result = false;

    Payload payload = getPayload(item, user, orderName, price);
    if (kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
      },
      onClose: () {
        print('------- onClose');
        if (!kIsWeb) {
          Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        }
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onConfirm: (String data) {
        // result = true;
        print('------- onConfirm: $data');
        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 비동기 승인 하고자 할 때
            checkQtyFromServer(data);
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        // checkQtyFromServer(data);
        return true;
      },
      onIssued: (String data) {
        // result = true;
        print('------- onIssued: $data');
        // 가상계좌 선택 시 (송금 이전) - 테스트
        var dataMap = json.decode(data)['data'];
        updateNewStudent(inputStudent, needToMakeNew);
        //TODO: 만료 처리
        // 마이페이지 내 표시 위해 저장
        // inputStudent.data['vbank_receipt_url'] = dataMap['receipt_url'];
        showConfirmedMessageForTransfer(dataMap);
      },
      onDone: (String data) {
        print('------- onDone: $data');
        updateNewStudent(inputStudent, needToMakeNew);
        showConfirmedMessageForCreditCard();
      },
    );
    // return result;
  }

  Payload getPayload(Item item, User user, orderName, price) {
    Payload payload = Payload();
    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId =
        androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id

    payload.pg = '나이스페이';
    // payload.method = '카드';
    payload.methods = [
      'card',
      'phone',
      'vbank',
      'bank',
      'kakao',
    ];
    payload.orderName = orderName; //결제할 상품명
    payload.price = price; //정기결제시 0 혹은 주석

    payload.orderId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); //주문번호, 개발사에서 고유값으로 지정해야함

    payload.metadata = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    }; // 전달할 파라미터, 결제 후 되돌려 주는 값

    // Item item1 = Item();
    // item1.name = ; // 주문정보에 담길 상품명
    // item1.qty = 1; // 해당 상품의 주문 수량
    // item1.id = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    // item1.price = 500; // 상품의 가격

    List<Item> itemList = [item];
    payload.items = itemList; // 상품정보 배열
    payload.user = user;

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '0';
    extra.separatelyConfirmed = false;
    extra.displaySuccessResult = true;
    payload.extra = extra;
    // extra.openType = 'popup';

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    return payload;
  }

  void updateNewStudent(Student inputStudent, bool needToMakeNew) {
    // 기존 학생이 수강 신청을 하지 않은 경우
    if (needToMakeNew == false) {
      studentProvider.updateStudentToFirestoreWithMap(inputStudent);

    // 기존 학생이 수강 신청을 한 이후, 신규 수강 신청을 하는 경우
    } else {
      // 새 email 찾기
      var newEmail =
          '${studentProvider.studentList!.first.data['email']}#${studentProvider.studentList!.length + 1}';
      inputStudent.data['email'] = newEmail;

      // 새 email DB 업데이트 / 새 email로 로그인 DB 변경
      studentProvider.updateStudentToFirestoreWithMap(inputStudent);
      studentProvider.setStudent(newEmail);
      // 적립그금points 업데이트      
      studentProvider.updateStudentListField('points', inputStudent.data['points'] ?? 0);
    }
  }

  void showConfirmedMessageForTransfer(
    Map<String, dynamic> dataMap,
  ) async {
    // 확인 창
    bool? confirm = await ConfirmDialog.show(
        context: context,
        title: "수강 신청 완료",
        body: [
          // 입금계좌 정보
          Text(
            '가상계좌 입금요청',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: customTheme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: customTheme.colorScheme.secondary),
              borderRadius: const BorderRadius.all(
                Radius.circular(3),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '입금 계좌번호',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${dataMap['vbank_data']['bank_name']}\n"
                  "${dataMap['vbank_data']['bank_account']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '입금 금액',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${NumberFormat("###,###").format(dataMap['price'])}원\n"
                  "${(dataMap['vbank_data']['expired_at'] as String).replaceAll('T', ' ').split('+')[0]} 만료",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "*등록자 성함을 반드시 적어서 입금해주세요.",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "입금 후, 카톡 채널로 '입금 완료'라고 말씀해주세요.\n"
            "담당자가 확인 후, 수업 확정 안내드리도록 하겠습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: customTheme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              js.context.callMethod('open', [dataMap['receipt_url']]);
            },
            child: const Text(
              '가상계좌 입금요청서 보기',
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
        trueButton: "카카오톡 채널로 문의하기",
        falseButton: "마이페이지로 이동",
        routeToOnLeft: '/student_calendar');
    if (confirm == true) {
      js.context.callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
      Navigator.of(context).pop(true);
    }
  }

  void showConfirmedMessageForCreditCard() async {
    // 확인 창
    bool? confirm = await ConfirmDialog.show(
        context: context,
        title: "수강 신청 완료",
        body: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: customTheme.colorScheme.secondary),
              borderRadius: const BorderRadius.all(
                Radius.circular(3),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: Text(
                "결제가 완료되었습니다.\n\n"
                "카톡 채널로 '결제완료'라고 말씀해주세요.\n"
                "담당자가 확인 후, 수업 확정 안내드리도록 하겠습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        trueButton: "카카오톡 채널로 문의하기",
        falseButton: "마이페이지로 이동",
        routeToOnLeft: '/student_calendar');

    if (confirm == true) {
      js.context.callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
      Navigator.of(context).pop(true);
    }
  }
}
