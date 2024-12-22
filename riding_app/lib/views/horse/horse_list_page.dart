import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'horse_detail_page.dart';
import 'horse_add_page.dart';

class HorseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HorseService>(
        builder: (context, horseService, child) {
          final horses = horseService.getHorses();
          if (horses.isEmpty) {
            return Center(
              child: Text('馬が登録されていません。'),
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
            ),
            itemCount: horses.length,
            itemBuilder: (context, index) {
              final horse = horses[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HorseDetailPage(horse: horse),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      horse.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HorseAddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
