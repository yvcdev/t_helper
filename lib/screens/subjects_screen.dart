import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addSubjectForm = Provider.of<AddSubjectFormProvider>(context);
    final subjectService = Provider.of<FBSubjectService>(context);

    Tween<Offset> _offset =
        Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

    return NotificationsAppBarLayout(
        scroll: false,
        colunmLayout: true,
        topSeparation: false,
        title: 'Subjects',
        loading: subjectService.loading,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: UiConsts.largePadding,
                left: UiConsts.largePadding,
                right: UiConsts.largePadding),
            decoration: BoxDecoration(
                color: Colors.white, boxShadow: [UiConsts.boxShadow]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a subject',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: UiConsts.smallFontSize, color: Colors.black),
                ),
                Text(
                  subjectService.subjectNumber == 1
                      ? 'You have ${subjectService.subjectNumber} subject'
                      : 'You have ${subjectService.subjectNumber} subjects',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: UiConsts.tinyFontSize,
                      color: subjectService.subjectNumber == 0
                          ? CustomColors.red
                          : CustomColors.green),
                ),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: subjectController,
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        autocorrect: false,
                        decoration: InputDecorations.generalInputDecoration(
                            hintText: 'Subject Name',
                            labelText: 'Subject Name',
                            prefixIcon: Icons.text_fields_rounded),
                        validator: (value) {
                          String pattern = r'^[a-zA-Z1-9ñÑ\s]*$';
                          RegExp regExp = RegExp(pattern);

                          if (subjectController.text != '') {
                            if (value!.length < 3) {
                              return 'The name should have more than 2 characters';
                            }
                            return regExp.hasMatch(value)
                                ? null
                                : 'Only alphanumerics and numbers are accepted';
                          }
                        },
                        onChanged: (value) {
                          addSubjectForm.subject = value;
                        },
                      ),
                      Positioned(
                        right: 5,
                        top: 10,
                        child: IconButton(
                            onPressed: () async {
                              await subjectsOnAddPressed(
                                  context, formKey, listKey, subjectController);
                            },
                            icon: const Icon(
                              Icons.send,
                              color: CustomColors.primary,
                            )),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: listKey,
              initialItemCount: subjectService.subjectList.length,
              itemBuilder: (context, index, animation) {
                final subject = subjectService.subjectList[index];
                return SlideTransition(
                  position: animation.drive(_offset),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: UiConsts.smallPadding,
                        vertical: UiConsts.smallPadding),
                    //padding: const EdgeInsets.all(UiConsts.normalPadding),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(UiConsts.borderRadius - 5),
                        gradient: LinearGradient(colors: [
                          UiConsts.colors[index % UiConsts.colors.length],
                          UiConsts.colors[index % UiConsts.colors.length]
                              .withOpacity(0.9)
                        ])),
                    child: SwitchListTile(
                      value: subject.active,
                      onChanged: (value) async {
                        await subjectsOnSwitchChanged(
                            context, subject.id!, value);

                        if (subjectService.error == null) {
                          subject.active = value;
                          setState(() {});
                        }
                      },
                      title: Text(
                        subject.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: UiConsts.normalFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(subject.active ? 'Active' : 'Inactive',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: UiConsts.smallFontSize,
                          )),
                      activeColor: Colors.white,
                      tileColor:
                          UiConsts.colors[index % UiConsts.colors.length],
                    ),
                  ),
                );
              },
            ),
          ),
        ]);
  }
}
