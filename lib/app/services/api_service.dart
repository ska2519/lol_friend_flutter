import 'dart:convert';
import 'package:lol_friend_flutter/app/home/models/match_list.dart';
import 'package:flutter/foundation.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/services/api.dart';
import 'package:http/http.dart' as http;




class APIService{
  APIService(this.api);
  final API api;
  
  
  Map<String, String> headers = {"X-Riot-Token":"RGAPI-7830bfc2-a885-4917-8914-aebd6383fa2a"};

  Future<Summoner> getSummonerDataByName({
    @required String summonersName,
    }) async {
  final uri = api.getSummonerDataByNameUri(summonersName);
  final response = await http.get(
    uri.toString(),
    headers: headers,
  );
  if(response.statusCode ==200){
     final Map<String, dynamic> data = json.decode(response.body);
    if(data.isNotEmpty){
      print('1차 출력물 확인 $data');
      
      return Summoner(
        id: data['id'],
        accountId: data['accountId'],
        puuid: data['puuid'],
        name: data['name'],
        profileIconId:data['profileIconId'],
        revisionDate: data['revisionDate'],
        summonerLevel: data['summonerLevel'],
      );
      //final SummonerData summonerData = data[_responseJsonKeys];
    }
  }

   print('Request $uri failed\nResponse : ${response.statusCode} ${response.reasonPhrase}');
   throw response;
  }


  Future<MatchList> getMatchDataByAccount({
    @required String accountId}) async {
  final uri = api.getMatchDataByAccountUri(accountId);
  final response = await http.get(
    uri.toString(),
    headers: headers,
  );
  if(response.statusCode ==200){
     final Map<String, dynamic> data = json.decode(response.body);
    if(data.isNotEmpty){
      List<dynamic> matches = data['matches'];
         
             print('테스트 ${matches[2]}');
      for(var match in matches){
        return MatchList(
          platformId: match['platformId'],
          gameId: match['gameId'],
          champion: match['champion'],
          queue: match['queue'],
          season: match['season'],
          timestamp: match['timestamp'],
          role: match['role'],
          lane: match['rolanele'],
        );

      }
    }
  }
       

        print('Request $uri \nResponse : ${response.statusCode} ${response.reasonPhrase}');
        throw response;
        }
      
      }
      
    

