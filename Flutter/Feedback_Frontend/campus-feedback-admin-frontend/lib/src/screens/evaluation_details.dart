import 'package:ShoolManagementSystem/src/data/evaluation.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class EvaluationDetailsScreen extends StatelessWidget {
  final Evaluation? evaluation;

  const EvaluationDetailsScreen({
    super.key,
    this.evaluation,
  });

  @override
  Widget build(BuildContext context) {
    if (evaluation == null) {
      return const Scaffold(
          body: Center(
        child: Text('No Evaluation found'),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(evaluation!.id!.toString()),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              evaluation!.evaluatee_id!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.evaluator_id!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.evaluation_criteria_id!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.activity_instance_id!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.grade!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.response!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.notes!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              evaluation!.updated!.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
