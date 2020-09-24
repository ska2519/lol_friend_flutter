import 'package:firebase_auth/firebase_auth.dart' as aut;
import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/sign_in/email_sign_in_page.dart';
import 'package:lol_friend_flutter/app/home/sign_in/sign_in_button.dart';
import 'package:lol_friend_flutter/app/home/sign_in/sign_in_manager.dart';
import 'package:lol_friend_flutter/app/home/sign_in/social_sign_in_button.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/common_widgets/firebaseauth_exception_alert_dialog.dart';
import 'package:provider/provider.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({
    Key key,
     @required this.manager,
     @required this.isLoading,
  }) : super(key: key);

  final SignInManager manager;
  final bool isLoading;

  //test 위해 key 만듬
  static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      // create 시 init value 뒤에 적어줘야함?? 지금은 안하면 일단 에러
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        //isLoading 값이 변경될 때 마다 Provider를 실행해 SignInManager 에 isLoading 값 전달
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading,
          context: context ),
          //Consumer로 SignInManager 변경 시 작업 지정
          child: Consumer<SignInManager>(
            //builder는 <ValueNotifier<bool>> 변경 될 때 같이 호출 딤 /SignInPage 도 rebuild
            builder: (_, manager, __) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

    //sign_in_page에서 오류 처리 하는 이유는 context가 필요
  void _showSignInError(BuildContext context, aut.FirebaseAuthException exception) {
    FirebaseAuthExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on aut.FirebaseAuthException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on aut.FirebaseAuthException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return 
    
    Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildContent(context),
      );
  }

    Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'launcherHero',
            child: Image.asset('assets/icons/launcher_icon.png',height: 90)),
          SizedBox(height: 50.0),
          _buildHeader(),
          SizedBox(height: 50.0),
          Text(                       
            '로그인을 누르시면 이용약관에 동의하는 것으로\n 간주됩니다. 롤 친구의 개인정보 취급방침 및 쿠키\n 정책에서 회원 정보 처리 방법을 확인하실 수 있습니다.',
            textAlign: TextAlign.center,style: 
            TextStyle(
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 20.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Google 계정으로 로그인',
            textColor: Colors.black87,
            color: Colors.white,
            // 로딩 중 버튼 비 활성화
            onPressed: () => isLoading ? null : _signInWithGoogle(context),
          ),
          SizedBox(height: 10.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Facebook 계정으로 로그인',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () => isLoading ? null : _signInWithFacebook(context),
          ),
          SizedBox(height: 10.0),
          SignInButton(
            key: emailPasswordKey,
            text: 'Email로 로그인',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => isLoading ? null : _signInWithEmail(context),
          ),
        ],
      ),
    );
  }

    Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      '소환사 등록을 하려면\n회원가입이 필요합니다',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}