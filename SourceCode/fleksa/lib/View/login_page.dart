import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleksa/SharedPreferences/sharedpreferences.dart';
import 'package:fleksa/View/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {


  List <Map> symbol = [
    {
      'id' : '1',
      'image' : 'assets/in.png'
    },
    {
      'id' : '2',
      'image' : 'assets/io.png'
    },
    {
      'id' : '3',
      'image' : 'assets/iq.png'
    },
    {
      'id' : '4',
      'image' : 'assets/ir.png'
    }
  ];
  String _selected = '1' ;



  TextEditingController phonecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();
  OtpFieldController otp = OtpFieldController();
  OtpFieldController otp2 = OtpFieldController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationId = "";
  String hold ="";
  String hold2 ="";

  bool isVisibleE = false;
  bool isVisibleP = false;
  bool isVisibleB = true;
  bool isVisibleB2 = true;

  late EmailAuth emailAuth;
  @override
  void initState()
  {
    super.initState();
    emailAuth = new EmailAuth(sessionName: "Sample");
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: HexColor("#fed701"),
              statusBarIconBrightness: Brightness.dark),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.arrow_back,color: Colors.black,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login",style: TextStyle(fontSize: 30,fontFamily: 'Poppins',fontWeight: FontWeight.w600)),
                  SizedBox(height: 7),
                  Text("Please enter your Phone or Email",style: TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.w200)),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: TabBar(
                        labelColor: Colors.black54,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: HexColor("#fed701"),
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 5.0,color: HexColor("#fed701")),
                        ),
                        tabs: [
                          Tab(text : 'Phone Number',),
                          Tab(text : 'Email')
                        ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 12,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Divider(
                      height: 0.5,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: size.height*0.9,
                    width: size.width*0.98,
                    child: TabBarView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Column(
                                  children:[
                                    Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey.withOpacity(0.5))
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                  padding: EdgeInsets.all(5),
                                                  child: DropdownButton<String>(
                                                    value:_selected,
                                                    onChanged: (newValue){
                                                      setState(() {
                                                        _selected = newValue!;
                                                      });
                                                    },
                                                    items: symbol.map((v) => DropdownMenuItem(
                                                        value: v['id'].toString(),
                                                        child: Image.asset(v['image'],
                                                        width: 20,)
                                                    )).toList(),
                                                  )
                                              ),
                                              SizedBox(
                                                width: size.width*0.7,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                  child: TextFormField(
                                                      controller: phonecontroller,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: 'Enter Phone Number',
                                                        hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey,fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                                                      ),
                                                      validator: (value) => null
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                      SizedBox(height: 50),
                                      Visibility(
                                        visible: isVisibleB,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:HexColor("#fed701"),
                                            minimumSize: Size(320, 55),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: (){
                                            _fetchotp();
                                            setState(() {
                                              isVisibleP = !isVisibleP;
                                              isVisibleB = !isVisibleB;
                                            });
                                          },
                                          child: Text("Send OTP",style: TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.w500)),
                                        ),
                                      )
                                        ]
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Visibility(
                                      visible: isVisibleP,
                                      child: Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Enter OTP",style: TextStyle(fontSize: 17,fontFamily: 'Poppins',fontWeight: FontWeight.w500)),
                                              Text("We've sent the code verification to your phone \nnumber",style: TextStyle(fontSize: 13,fontFamily: 'Poppins',fontWeight: FontWeight.w300,color: Colors.grey)),
                                              SizedBox(height: 30),
                                              OTPTextField(
                                                controller: otp,
                                                length: 6,
                                                width: size.width,
                                                fieldWidth: 50,
                                                style: TextStyle(
                                                    fontSize: 17
                                                ),
                                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                                fieldStyle: FieldStyle.box,
                                                outlineBorderRadius: 15,
                                                onCompleted: (String verificationCode) {
                                                  setState(() {
                                                    hold = verificationCode;
                                                  });
                                                }
                                              ),
                                              SizedBox(height: 50),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:HexColor("#fed701"),
                                                    minimumSize: Size(320, 55),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                    ),
                                                  ),
                                                  onPressed: () => verify(),
                                                  child: Text("Login",style: TextStyle(fontSize: 17.0, color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.w600)),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Center(
                                                child: Text("By clicking Login, you accept our",
                                                    style: TextStyle(fontSize: 15.0, color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.w400)
                                                ),
                                              ),
                                              Center(
                                                child: Text("Terms & Condition",
                                                    style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,fontFamily: 'Poppins',fontWeight: FontWeight.w500)
                                                ),
                                              )
                                            ],
                                    )
                                ),
                              ),
                            ],
                          ),


                          //EMAIL
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Column(
                                    children:[
                                      Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.withOpacity(0.5))
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width*0.7,
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                    child: TextFormField(
                                                        controller: emailcontroller,
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: 'Enter Email',
                                                          hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey,fontFamily: 'Poppins',fontWeight: FontWeight.w500),
                                                        ),
                                                        validator: (value) => null
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                      Visibility(
                                        visible: isVisibleB2,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:HexColor("#fed701"),
                                            minimumSize: Size(320, 55),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: (){
                                            sendOtp();
                                            setState(() {
                                              isVisibleE = !isVisibleE;
                                              isVisibleB2 = !isVisibleB2;
                                            });
                                          },
                                          child: Text("Send OTP",style: TextStyle(fontSize: 16.0, color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.w500)),
                                        ),
                                      )
                                    ]
                                ),
                              ),
                              SizedBox(height: 20,),
                              Visibility(
                                visible: isVisibleE,
                                child: Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Enter OTP",style: TextStyle(fontSize: 17,fontFamily: 'Poppins',fontWeight: FontWeight.w500)),
                                        Text("We've sent the code verification to your phone \nnumber",style: TextStyle(fontSize: 13,fontFamily: 'Poppins',fontWeight: FontWeight.w300,color: Colors.grey)),
                                        SizedBox(height: 30),
                                        OTPTextField(
                                            controller: otp2,
                                            length: 6,
                                            width: size.width,
                                            fieldWidth: 50,
                                            style: TextStyle(
                                                fontSize: 17
                                            ),
                                            textFieldAlignment: MainAxisAlignment.spaceAround,
                                            fieldStyle: FieldStyle.box,
                                            outlineBorderRadius: 15,
                                            onCompleted: (String verificationCode) {
                                              setState(() {
                                                hold2 = verificationCode;
                                              });
                                            }
                                        ),
                                        SizedBox(height: 50),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:HexColor("#fed701"),
                                              minimumSize: Size(320, 55),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                            ),
                                            onPressed: () => verifyE(),
                                            child: Text("Login",style: TextStyle(fontSize: 17.0, color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Center(
                                          child: Text("By clicking Login, you accept our",
                                              style: TextStyle(fontSize: 15.0, color: Colors.black,fontFamily: 'Poppins',fontWeight: FontWeight.w400)
                                          ),
                                        ),
                                        Center(
                                          child: Text("Terms & Condition",
                                              style: TextStyle(fontSize: 15.0, color: Colors.blueAccent,fontFamily: 'Poppins',fontWeight: FontWeight.w500)
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: emailcontroller.value.text, otpLength: 6
    );
    if(result)
    {
      showToast(" OTP sent succesfully ");
    }
    else
    {
      showToast(" Invalid Email ");
    }

  }

  void verifyE() {
    bool res =  (emailAuth.validateOtp(
        recipientMail: emailcontroller.value.text,
        userOtp: hold2));
    if(res)
    {
      ShareP.setToken(hold2);
      showToast(" OTP verified ");

      Timer(Duration(seconds: 2), () {});

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Welcome()));
    }
    else
    {
      showToast(" Invalid OTP ");
    }
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential = await auth
          .signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        ShareP.setToken(hold2);
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  Welcome()));
      }
    } on FirebaseAuthException catch (e) {
      showToast(' Something went wrong ');
    }
  }

  Future<void> verify() async {
    PhoneAuthCredential phoneAuthCredential =
    PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: hold);

    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  _fetchotp() async {
    await auth.verifyPhoneNumber(
        phoneNumber: "+91 "+phonecontroller.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    },

    verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number')
        {
            showToast(' Invalid Phone Number ');
        }
    },
    codeSent: (String verificationId, int? resendToken) async {
      this.verificationId = verificationId;
      showToast(" OTP sent succesfully ");

    },

    codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
    },
    timeout: Duration(seconds: 120)
    );
  }
}

void showToast(String text) => Fluttertoast.showToast
  (
  msg: text,
  fontSize: 13.0,
  backgroundColor: HexColor("#fed701"),
  textColor: Colors.black,
  gravity: ToastGravity.BOTTOM,
);

