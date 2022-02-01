import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/routes/route_converter.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/widgets/widgets.dart';

class SetUpActivityScreen extends StatelessWidget {
  const SetUpActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activitiesService = Provider.of<FBActivitiesService>(context);

    return DefaultAppBarLayout(
        loading: activitiesService.isLoading,
        topSeparation: false,
        drawer: false,
        title: 'Set Up Activity',
        children: [
          activitiesService.activities == null
              ? const Center(
                  child: Text('There are no activities to show'),
                )
              : activitiesService.activities!.isEmpty
                  ? const Center(
                      child: Text('There are no activities to show'),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activitiesService.activities!.length,
                      itemBuilder: (context, index) {
                        final activity = activitiesService.activities![index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageDescriptionCard(
                                index: index,
                                onTap: () {
                                  Get.to(
                                      () => routeConverter[activity.namedId]!);
                                },
                                status: 1,
                                description: activity.description,
                                title: activity.name,
                                image: activity.coverImage!),
                          ],
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: UiConsts.normalSpacing - 10,
                        mainAxisExtent: UiConsts.largeCardHeight,
                      )),
        ]);
  }
}
