import 'package:flutter/foundation.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/home/models/summonerLeague.dart';
import 'package:lol_friend_flutter/app/services/api_service.dart';

class DataRepository {
  DataRepository({@required this.apiService});
  final APIService apiService;

  Future<Summoner> getSummonerDataByName(String summonersName) async =>
      await apiService.getSummonerDataByName(summonersName: summonersName);

  Future<SummonerLeague> getSummonerLeagueDataByName(String summonerId) async =>
      await apiService.getSummonerLeagueDataByName(summonerId: summonerId);
}
