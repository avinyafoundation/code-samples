import 'package:ShoolManagementSystem/src/data/evaluation.dart';
import 'package:ShoolManagementSystem/src/data/evaluation_criteria.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class EvaluationCriteriaDetailsScreen extends StatelessWidget {
  final EvaluationCriteria? evaluationCriteria;

  const EvaluationCriteriaDetailsScreen({
    super.key,
    this.evaluationCriteria,
  });

  @override
  Widget build(BuildContext context) {
    if (evaluationCriteria == null) {
      return const Scaffold(
          body: Center(
        child: Text('No Evaluation Criteria found'),
      ));
    }
    return Scaffold(
        appBar: AppBar(
          // title: Text(evaluationCriteria!.evaluation_type!),
        ),
        body: Container(padding: EdgeInsets.all(15)));
  }
}
