import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/common_widgets/constants.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';

import 'package:lol_friend_flutter/app/repositories/data_repository.dart';

import 'package:lol_friend_flutter/app/services/api_service.dart';
import 'package:lol_friend_flutter/app/ui/summoner_name_card.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key, this.apiService}) : super(key: key);
  final APIService apiService;
  

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _searchNameController = TextEditingController();

  String _searchSummonerName;
  Summoner _summoner;
  


  Future<void> _submit() async {
    
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _summoner = await dataRepository.getSummonerDataByName(_searchSummonerName);
    print('_summoner.name ${_summoner.name}');
    FocusScope.of(context).unfocus();
    _searchNameController.value = TextEditingValue(text: '${_summoner.name}');
    //setState(() => _summonerName = summoner.name);
    //print('_summoner ${_summonerName}');
 }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(toolbarHeight: 50.0,
        centerTitle: true,
        backgroundColor: Colors.blueGrey[50],
        title: Text('롤 친구',style: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.w300),),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            
           crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 15.0),
               Container(height: 90.0,
                 child: Image.asset('assets/icon.ico')),
               SizedBox(height: 20.0),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                    width: 250.0,
                    child: TextFormField(
                      key: _formKey,
                      controller: _searchNameController,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _submit,
                      onChanged: (value) => _searchSummonerName = value,
                      textAlign: TextAlign.center,
                      decoration: kSearchTextFieldDecoration,
                    ), 
                  ),
                  SizedBox(width: 7.0),
                  IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 33,
                    color: Colors.blueGrey,
                    onPressed: _submit,
                
                    ),
                 ],
               ),
              SizedBox(height: 30.0),
              Container(
                height: 150.0,               
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
                      icon: Icon(Icons.add),iconSize: 40.0,color: Colors.blueGrey, onPressed: (){}),
                      Text('본인의 소환사 아이디를 등록해 주세요.',
                      style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              SummonerNameCard(summoner: _summoner),
                
              //_buildCard(),          
            ],
          ),
        ),
      ),
    );
  }
}
