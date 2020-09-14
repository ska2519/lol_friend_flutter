import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/models/summoner.dart';
import 'package:provider/provider.dart';



class SummonerNameCard extends StatelessWidget {
  const SummonerNameCard({Key key, this.summoner}) : super(key: key);
  final Summoner summoner;

  

  @override
  Widget build(BuildContext context) {
    Provider.of<Summoner>(context, listen: false);

    return Card(
      child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 33.0,
              child:
              Text(summoner == null ? 'null' : '${summoner.summonerLevel}',
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700),),
              backgroundImage: summoner == null ? null : NetworkImage('http://ddragon.leagueoflegends.com/cdn/10.18.1/img/profileicon/${summoner.profileIconId}.png',)
            ),
            SizedBox(width: 20.0,),

            Text(summoner == null ? 'null' : '${summoner.name}',
            style: TextStyle(fontSize: 27.0,fontWeight: FontWeight.w700),),
            
          ]
        ),
      ), 
    );
  }
}
