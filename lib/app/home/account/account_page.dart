import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/account/profile_page.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/home/models/summonerLeague.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/repositories/dataRepository.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:lol_friend_flutter/app/home/sign_in/sign_in_page.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/services/database.dart';
import 'package:lol_friend_flutter/app/ui/summoner_name_card.dart';
import 'package:lol_friend_flutter/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key, this.apiService}) : super(key: key);
  final APIService apiService;
  
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _searchNameController = TextEditingController();

  String _searchSummonerName;
  Summoner _summoner;
  SummonerLeague _summonerLeague;

  
  Future<void> _submit() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _summoner = await dataRepository.getSummonerDataByName(_searchSummonerName);
    print('_summoner.name ${_summoner.name}');
    _summonerLeague = await dataRepository.getSummonerLeagueDataByName(_summoner.summonerId);
    print('_summonerLeague ${_summonerLeague.tier}');
    FocusScope.of(context).unfocus();
    _searchNameController.value = TextEditingValue(text: '${_summoner.name}');
 }
 
  @override
  Widget build(BuildContext context) {      
    final user = Provider.of<User>(context, listen: false);
    final database = Provider.of<DataBase>(context, listen: false);
    final userProfile = Provider.of<UserProfile>(context, listen: false);
    
    Future<void> _signOut(BuildContext context) async {
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);
        await auth.signOut();
      } catch (e) {
        print(e.toString());
      }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

    return MultiProvider(
      providers:[
        Provider<Summoner>(
          create: (_)=> Summoner()),
        Provider<SummonerLeague>(
          create: (_)=> SummonerLeague()),
      ],
      child: SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.0),
              Container(height: 90.0,
                child: Hero(
                  tag: 'launcherHero',
                  child: Image.asset('assets/icons/launcher_icon.png')),
              ),
              SizedBox(height: 30.0),
            TextFormField(
              key: _formKey,
              controller: _searchNameController,
              textInputAction: TextInputAction.done,
              onChanged: (value) => _searchSummonerName = value,
              onEditingComplete: _submit,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: _submit,  iconSize: 30, color: Color(0xFF0091EA),padding: EdgeInsets.all(12.0),),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: '소환사 검색',
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                fillColor: Color(0xFFFFF4D4),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Color(0xFF0091EA), width: 1.0),
                ),
              ),
            ),
          SizedBox(height: 30.0),
          Container(
            height: 100.0,               
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueGrey,
                width: 0.6,
                style: BorderStyle.solid,
              ),    
            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add),iconSize: 40.0,color: Colors.blueGrey,
                  onPressed: (){
                    user == null ?
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => 
                    SignInPage.create(context)),
                    )
                    : 
                    ProfilePage.show(context,
                    user: user,
                    database: database,
                    userProfile: userProfile);
                  }
                ),
                Text('본인의 소환사 아이디를 등록해 주세요.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
            SizedBox(height: 30.0),
            SummonerNameCard(
              summoner: _summoner, summonerLeague: _summonerLeague),
            FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          )
            ],
          ),
        ),
      );
  }
}
