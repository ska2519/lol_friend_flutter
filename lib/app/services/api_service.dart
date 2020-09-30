import 'dart:convert';
import 'package:lol_friend_flutter/app/home/models/matchList.dart';
import 'package:flutter/foundation.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/home/models/summonerLeague.dart';
import 'package:lol_friend_flutter/app/services/api.dart';
import 'package:http/http.dart' as http;
import 'api_keys.dart';

class APIService {
  APIService(this.api);
  final API api;

  Map<String, String> headers = {
    "X-Riot-Token": "${APIKeys.developmentApiKey}"
  };

  Future<Summoner> getSummonerDataByName({
    @required String summonersName,
  }) async {
    final uri = api.getSummonerDataByNameUri(summonersName);
    final response = await http.get(
      uri.toString(),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        print('Summoner 출력물 확인 $data');

        return Summoner(
          summonerId: data['id'],
          accountId: data['accountId'],
          puuid: data['puuid'],
          name: data['name'],
          profileIconId: data['profileIconId'],
          revisionDate: data['revisionDate'],
          summonerLevel: data['summonerLevel'],
        );
      }
    }
    print(
        'Request $uri failed\nResponse : ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<SummonerLeague> getSummonerLeagueDataByName(
      {@required String summonerId}) async {
    final uri = api.getSummonerLeagueDataByName(summonerId);
    final response = await http.get(
      uri.toString(),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        print('SummonerLeague 출력물 확인 $data');
        final Map<String, dynamic> summonerLeagueData = data[0];
        return SummonerLeague(
          summonerId: summonerLeagueData['id'],
          leagueId: summonerLeagueData['leagueId'],
          queueType: summonerLeagueData['queueType'],
          tier: summonerLeagueData['tier'],
          rank: summonerLeagueData['rank'],
          summonerName: summonerLeagueData['summonerName'],
          leaguePoints: summonerLeagueData['leaguePoints'],
          wins: summonerLeagueData['wins'],
          losses: summonerLeagueData['losses'],
        );
      }
    }
    print(
        'Request $uri failed\nResponse : ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<MatchList> getMatchListDataByAccount(
      {@required String accountId}) async {
    final uri = api.getMatchDataByAccountUri(accountId);
    final response = await http.get(
      uri.toString(),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        List<dynamic> matches = data['matches'];
        // int startIndex = data['startIndex'];
        // int endIndex = data['endIndex'];
        // int totalGames = data['totalGames'];
        print('테스트 ${matches[2]}');
        for (var match in matches) {
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
    print(
        'Request $uri \nResponse : ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }
}
