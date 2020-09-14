class Match{
 int gameId;
 String gameMode;
 Team teams;
 Ban bans;
 Participant participants;
 ParticipantIdentity participantIdentities;
}

class Team{
  int teamId;
  String win;
}

class Ban{
  int championId;
  int pickTurn;
}

class Participant{
  int championId;
  int spell1Id;
  int spell2Id;
}

class ParticipantIdentity{
  int participantId;
  Player player;
  }
  
class Player {
    String accountId;
    String summonerName;
    String summonerId;
    int profileIcon;
}