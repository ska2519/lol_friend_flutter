import 'package:flutter/foundation.dart';
import 'package:lol_friend_flutter/app/services/api_keys.dart';


class API{
  API({@required this.apiKey});
  final String apiKey;

//return an API object using the developmentApiKey key
  factory API.development() => API(apiKey: APIKeys.developmentApiKey);

  static final String host = 'kr.api.riotgames.com';
  String name = 'null';

  Uri getSummonerDataByNameUri (summonersName) => Uri(
    scheme: 'https',
    host: host,
    path: 'lol/summoner/v4/summoners/by-name/${summonersName != null ? summonersName : name}',
  );

  Uri getMatchDataByAccountUri (accountId) => Uri(
    scheme: 'https',
    host: host,
    path: 'lol/match/v4/matchlists/by-account/${accountId != null ? accountId : null}',
  );

}