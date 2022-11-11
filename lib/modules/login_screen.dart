import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_animation/modules/animation_enum.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  final GlobalKey<FormState>formKey=GlobalKey<FormState>();
  String testEmail='nada1234@gmail.com';
  String testPassword='123456';
  final passwordFocusNode=FocusNode();
  bool isLookingLeft=false;
  bool isLookingRight=false;
  void removeAllControllers(){
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft=false;
    isLookingRight=false;

  }
  void addIdleController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint('idle');
  }
  void addHandsUpController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    debugPrint('hands up');
  }
  void addHandsDownController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    debugPrint('hands Down');
  }
  void addLookLeftController(){
    removeAllControllers();
    isLookingLeft=true;
    riveArtboard?.artboard.addController(controllerLookLeft);
    debugPrint('look left');
  }
  void addLookRightController(){
    removeAllControllers();
    isLookingRight=true;
    riveArtboard?.artboard.addController(controllerLookRight);
    debugPrint('look right');
  }
  void addSuccessController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint(' success');
  }
  void addFailController(){
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint('fail');
  }
  void checkForPasswordFocusNodeToChangeAnimationState(){
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus){
        addHandsUpController();
      }else if(!passwordFocusNode.hasFocus){
        addHandsDownController();
      }

    });
  }
  void validateEmailAndPassword(){
    Future.delayed(const Duration(seconds: 1),(){
      if(formKey.currentState!.validate()){
        addSuccessController();
      }else{
        addFailController();
      }

    });

  }

 @override
  void initState() {
    super.initState();
    controllerIdle=SimpleAnimation(AnimatiomEnum.idle.name);
    controllerHandsUp=SimpleAnimation(AnimatiomEnum.Hands_up.name);
    controllerHandsDown=SimpleAnimation(AnimatiomEnum.hands_down.name);
    controllerLookLeft=SimpleAnimation(AnimatiomEnum.Look_down_left.name);
    controllerLookRight=SimpleAnimation(AnimatiomEnum.Look_down_right.name);
    controllerSuccess=SimpleAnimation(AnimatiomEnum.success.name);
    controllerFail=SimpleAnimation(AnimatiomEnum.fail.name);


    rootBundle.load('assets/login.riv').then((data)  {

      final file=RiveFile.import(data);
      final artboard=file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard=artboard;
      });

    });
checkForPasswordFocusNodeToChangeAnimationState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text('Animated Login')),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height/3,
                child: riveArtboard==null? const SizedBox.shrink(): Rive(artboard: riveArtboard!,


                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:  InputDecoration(
                        labelText: 'Enter Email ',
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)
                            )
                      ),
                      validator: (value)=>
                      value!=testEmail?'Enter Correct Email':null,
                      onChanged: (value){
                        if(value.isNotEmpty&&value.length<16 && !isLookingLeft){
                          addLookLeftController();
                        }else if(value.isNotEmpty&&value.length>16 && !isLookingRight){
                          addLookRightController();

                        }
                      },

                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/25,),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )
                      ),
                      focusNode: passwordFocusNode,
                      validator: (value)=>
                      value!=testPassword?'Wrong password':null,

                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/18,),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/8),

                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: (){
                          validateEmailAndPassword();
                          passwordFocusNode.unfocus();



                        },
                        child: Text('login',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                      ),
                    )


                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
