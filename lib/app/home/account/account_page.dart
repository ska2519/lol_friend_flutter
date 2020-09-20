import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/home/models/summoner_league.dart';
import 'package:lol_friend_flutter/app/repositories/data_repository.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:lol_friend_flutter/app/ui/summoner_name_card.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Provider<SummonerLeague>(
      create: (_)=> SummonerLeague(),
      child: Scaffold(backgroundColor: Colors.grey[50],
        body: 
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
        SizedBox(height: 10.0),
         Container(height: 90.0,
           child: Image.asset('assets/icons/launcher_icon.png')),
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
                icon: Icon(Icons.add),iconSize: 40.0,color: Colors.blueGrey, onPressed: (){
                }),
                Text('본인의 소환사 아이디를 등록해 주세요.',
                style: GoogleFonts.notoSans(fontSize: 17),
                ),
            ],
          ),
        ),
        SizedBox(height: 30.0),
        SummonerNameCard(
          summoner: _summoner, summonerLeague: _summonerLeague),
        ],
            ),
          ),
      ),
    );
  }
}
