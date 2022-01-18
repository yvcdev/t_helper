import 'package:flutter/material.dart';

import 'package:t_helper/layouts/layouts.dart';

class CSortSentenceScreen extends StatelessWidget {
  const CSortSentenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
      title: 'Sort The Sentence',
      children: [Text('Sort the sentence Creator')],
    );
  }
}
