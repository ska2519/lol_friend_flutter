import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:lol_friend_flutter/app/home/models/summoner_league.dart';
import 'package:provider/provider.dart';



class SummonerNameCard extends StatelessWidget {
  const SummonerNameCard({Key key,@required this.summoner,@required this.summonerLeague}) : super(key: key);
  final Summoner summoner;
  final SummonerLeague summonerLeague;

  

  @override
  Widget build(BuildContext context) {
    Provider.of<Summoner>(context, listen: false);
    Provider.of<SummonerLeague>(context, listen: false);    
    
    return Card(
      child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 33.0,
              child:
              Text(summoner == null ? '99' : '${summoner.summonerLevel}',
                style: TextStyle(fontSize: 11.0,fontWeight: FontWeight.w700),),
              backgroundImage: summoner == null ? AssetImage('assets/icons/1298.png') : NetworkImage('http://ddragon.leagueoflegends.com/cdn/10.18.1/img/profileicon/${summoner.profileIconId}.png',)
            ),
            SizedBox(width: 11.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summoner == null ? '널널한 살인마' : '${summoner.name}',
                style: GoogleFonts.nanumGothic(fontSize: 22.0,fontWeight: FontWeight.w600,letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(_buildContent(summonerLeague),width: 20.0,),
                    SizedBox(width: 5.0),
                    Text(summonerLeague == null ? 'IRON' : '${summonerLeague.tier}',
                    style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),),
                    SizedBox(width: 5.0),
                    Text(summonerLeague == null ? '2' : '${summonerLeague.rank}',
                    style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),),
                    Text(' - '),
                     Text(summonerLeague == null ? '66 LP' : '${summonerLeague.leaguePoints} LP',
                    style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),),
                  ],
                ),
              ],
            ),
            
          ]
        ),
      ), 
    );
  }
}

_buildContent(summonerLeague){
 if(summonerLeague==null){
   return 'assets/ranked_emblems/Emblem_Iron.png';
 }
  if(summonerLeague.tier == 'IRON'){
    return 'assets/ranked_emblems/Emblem_Iron.png';
  } else if(summonerLeague.tier == 'BRONZE'){
    return 'assets/ranked_emblems/Emblem_Bronze.png';
  }else if(summonerLeague.tier == 'SILVER'){
    return 'assets/ranked_emblems/Emblem_Silver.png';
  }else if(summonerLeague.tier == 'GOLD'){
    return 'assets/ranked_emblems/Emblem_Gold.png';
  }else if(summonerLeague.tier == 'PLATINUM'){
    return 'assets/ranked_emblems/Emblem_Platinum.png';
  }else if(summonerLeague.tier == 'DIAMOND'){
    return 'assets/ranked_emblems/Emblem_Diamond.png';
  }else if(summonerLeague.tier == 'MASTER'){
    return 'assets/ranked_emblems/Emblem_Master.png';
  }else{
    return 'assets/ranked_emblems/Emblem_Silver.png';
  }
}