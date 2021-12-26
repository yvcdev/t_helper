import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/sentences_service.dart';
import 'package:t_helper/widgets/activity_banner.dart';

class GroupActivitiesScreen extends StatelessWidget {
  const GroupActivitiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sentenceService = Provider.of<SentenceService>(context);

    return NotificationsAppBarLayout(
        topSeparation: false,
        title: 'Group Activities',
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActivityBanner(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.ACTIVITY_SORT_SENTENCE);
                            sentenceService.getSentences();
                          },
                          status: 1,
                          description:
                              'This is the description of the activity',
                          title: 'Sort the Sentence ',
                          image:
                              'https://blog.reallygoodstuff.com/wp-content/uploads/2012/06/Classroom-Games-for-Kids.jpg'),
                    ],
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: UiConsts.normalSpacing - 10,
                  mainAxisExtent: UiConsts.largeCardHeight,
                )),
          ),
        ]);
  }
}
