import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';
import '../data/evaluation_criteria.dart';

class EvaluationCriteriaList extends StatefulWidget {
  const EvaluationCriteriaList({Key? key, this.onTap}) : super(key: key);

  final ValueChanged<EvaluationCriteria>? onTap;

  @override
  _EvaluationCriteriaListState createState() => _EvaluationCriteriaListState();
}

class _EvaluationCriteriaListState extends State<EvaluationCriteriaList> {
  late Future<List<EvaluationCriteria>> _futureEvaluationCriteria;
  String _selectedType = 'All';

  @override
  void initState() {
    super.initState();
    _futureEvaluationCriteria = fetchEvaluationCriterias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EvaluationCriteria>>(
      future: _futureEvaluationCriteria,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final evaluationTypes =
              Set<String>.from(snapshot.data!.map((e) => e.evaluation_type));
          final options = ['All', ...evaluationTypes];
          return Column(
            children: [
              DropdownButton<String>(
                value: _selectedType,
                onChanged: (String? value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                items: options
                    .map((String option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final evaluationCriteria = snapshot.data![index];
                    if (_selectedType == 'All' ||
                        _selectedType == evaluationCriteria.evaluation_type) {
                      return ListTile(
                        title: Text(
                            evaluationCriteria.description ?? 'No description'),
                        subtitle:
                            Text(evaluationCriteria.evaluation_type ?? ''),
                        onTap: widget.onTap != null
                            ? () => widget.onTap!(evaluationCriteria)
                            : null,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
