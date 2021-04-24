import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class WelcomeScreen extends StatefulWidget {
 static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin{
  AnimationController controller;
  AnimationController controller2;
  Animation<double> _hieght;

  Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller2 = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,);
    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

     animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

       _hieght = TweenSequence(
           <TweenSequenceItem<double>>[
             TweenSequenceItem<double>(
               tween: Tween<double>(begin: 60.0 ,end: 200.0),
               weight: 50,
             ),
             TweenSequenceItem<double>(
               tween: Tween<double>(begin: 200.0,end: 60.0),
               weight: 50,
             ),
           ]
       ).animate(controller);


    controller.forward();
    controller.addListener(() {
      setState(() {
        print(_hieght.value);
      });

    });
    controller2.addListener(() {
      setState(() {

      });
    });


  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 5000),
                        child: Image.asset('images/logo.png',),
                        height: _hieght.value,
                        width: (_hieght.value),

                      ),
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    isRepeatingAnimation: false,
                    speed: Duration(milliseconds: 300),
                    text: ['Flash Chat'],
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,

                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Rounded_button(
                color: Colors.lightBlueAccent,
                text: 'Log In',
                onpressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
                //Go to login screen.
              },),
              Rounded_button(
                color: Colors.blueAccent,
                text: 'Registration',
                onpressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                  //Go to login screen.
                },),
            ],
          ),
        ),
      ),
    );
  }
}

class Rounded_button extends StatelessWidget {
  Rounded_button({this.text,this.color,this.onpressed});
  final Color color;
  final String text;
  final Function onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
