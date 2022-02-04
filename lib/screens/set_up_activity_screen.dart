import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/routes/route_converter.dart';
import 'package:t_helper/widgets/widgets.dart';

class SetUpActivityScreen extends StatelessWidget {
  const SetUpActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ActivitiesController activitiesController = Get.find();

    return Obx(() => DefaultAppBarLayout(
            loading: activitiesController.isLoading.value,
            topSeparation: false,
            drawer: false,
            title: 'Set Up Activity',
            children: [
              activitiesController.activities == null
                  ? const Center(
                      child: Text('There are no activities to show'),
                    )
                  : activitiesController.activities!.isEmpty
                      ? const Center(
                          child: Text('There are no activities to show'),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activitiesController.activities!.length,
                          itemBuilder: (context, index) {
                            final activity =
                                activitiesController.activities![index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageDescriptionCard(
                                    index: index,
                                    onTap: () {
                                      Get.to(() =>
                                          routeConverter[activity.namedId]!);
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
            ]));
  }
}
