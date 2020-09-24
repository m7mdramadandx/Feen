import 'package:Fen/ui/service/Database.dart';
import 'package:Fen/util/colors.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext _context) {
    DatabaseService.loadHistory();
    return getHistory(_context);
  }

  Widget getHistory(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        color: backgroundColor,
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: screenSize.height * 0.6,
        child: new ListView(
            children: DatabaseService.objectHistory.map((atm) {
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            child: ExpansionTileCard(
              leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset('lib/assets/icons/atm.png')),
              title: Text(
                atm.name != null ? atm.name : "اسم الماكينة",
                style: TextStyle(fontFamily: 'Cairo'),
                textDirection: TextDirection.rtl,
              ),
              subtitle: Text(
                'إضغط لمزيم من التفاصيل',
                style: TextStyle(fontFamily: 'Cairo', color: grey),
                textDirection: TextDirection.rtl,
              ),
              baseColor: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              expandedColor: silver,
              children: <Widget>[
                Divider(thickness: 1.0, height: 1.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      atm.vicinity != null ? atm.vicinity : "عنوان الماكينة",
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Column(
                        children: <Widget>[
                          Icon(FlutterIcons.timer_mco,
                              color: primaryColor, size: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text(atm.time != null ? atm.time : "وقت الزيارة",
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.black87,
                                  fontSize: 12)),
                        ],
                      ),
                      onPressed: null,
                    ),
                    FlatButton(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            MaterialIcons.date_range,
                            color: primaryColor,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text(atm.date != null ? atm.date : "تاريخ الزيارة",
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.black87,
                                  fontSize: 12)),
                        ],
                      ),
                      onPressed: null,
                    ),
                    FlatButton(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            FlutterIcons.atm_mco,
                            color: primaryColor,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text(atm.type != null ? atm.type : "نوع الماكينة",
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.black87,
                                  fontSize: 12)),
                        ],
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList()));
  }
}
