import 'dart:developer';
import 'dart:html';

import 'package:ShoolManagementSystem/src/data/campus_feedback_system.dart';
import 'package:ShoolManagementSystem/src/data/evaluation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EvaluationList extends StatefulWidget {
  const EvaluationList({super.key, this.onTap});
  final ValueChanged<Evaluation>? onTap;

  @override
  // State<EvaluationList> createState() => _EvaluationListState();
  EvaluationListState createState() => EvaluationListState(onTap);
}

class EvaluationListState extends State<EvaluationList> {
  late Future<List<Evaluation>> futureEvaluations;
  final ValueChanged<Evaluation>? onTap;

  EvaluationListState(this.onTap);

  @override
  void initState() {
    super.initState();
    futureEvaluations = fetchEvaluations();
  }

  Future<List<Evaluation>> refreshEvaluationState() async {
    futureEvaluations = fetchEvaluations();
    return futureEvaluations;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Evaluation>>(
      future: refreshEvaluationState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // log(snapshot.data!.toString());
          campusFeedbackSystemInstance.setEvaluations(snapshot.data);
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                (snapshot.data![index].grade.toString()),
              ),
              subtitle: Text(' ' +
                  (snapshot.data![index].evaluatee_id!.toString()) +
                  ' ' +
                  (snapshot.data![index].evaluator_id!.toString()) +
                  ' ' +
                  (snapshot.data![index].evaluation_criteria_id!.toString()) +
                  ' ' +
                  (snapshot.data![index].notes ?? '') +
                  ' ' +
                  (snapshot.data![index].grade!.toString()) +
                  ' ' +
                  (snapshot.data![index].response ?? '')),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () async {
                        Navigator.of(context)
                            .push<void>(
                              MaterialPageRoute<void>(
                                builder: (context) => EditEvaluationPage(
                                    evaluation: snapshot.data![index]),
                              ),
                            )
                            .then((value) => setState(() {}));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        await _deleteEvaluation(snapshot.data![index]);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
              onTap: onTap != null ? () => onTap!(snapshot.data![index]) : null,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Future<void> _deleteEvaluation(Evaluation evaluation) async {
    try {
      await deleteEvaluation(evaluation.id!.toString());
    } on Exception {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Failed to delete the Evaluation'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}

class AddEvaluationPage extends StatefulWidget {
  static const String route = '/evaluation/add';
  const AddEvaluationPage({super.key});
  @override
  _AddEvaluationPageState createState() => _AddEvaluationPageState();
}

class _AddEvaluationPageState extends State<AddEvaluationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _evaluatee_id_Controller;
  late FocusNode _evaluatee_id_FocusNode;
  late TextEditingController _evaluator_id_Controller;
  late FocusNode _evaluator_id_FocusNode;
  late TextEditingController _evaluation_criteria_id_Controller;
  late FocusNode _evaluation_criteria_id_FocusNode;
  late TextEditingController _response_Controller;
  late FocusNode _response_FocusNode;
  late TextEditingController _notes_Controller;
  late FocusNode _notes_FocusNode;
  late TextEditingController _grade_Controller;
  late FocusNode _grade_FocusNode;

  @override
  void initState() {
    super.initState();
    _evaluatee_id_Controller = TextEditingController();
    _evaluatee_id_FocusNode = FocusNode();
    _evaluator_id_Controller = TextEditingController();
    _evaluator_id_FocusNode = FocusNode();
    _evaluation_criteria_id_Controller = TextEditingController();
    _evaluation_criteria_id_FocusNode = FocusNode();
    _response_Controller = TextEditingController();
    _response_FocusNode = FocusNode();
    _notes_Controller = TextEditingController();
    _notes_FocusNode = FocusNode();
    _grade_Controller = TextEditingController();
    _grade_FocusNode = FocusNode();
  }

  @override
  void dispose() {
    _evaluatee_id_Controller.dispose();
    _evaluatee_id_FocusNode.dispose();
    _evaluator_id_Controller.dispose();
    _evaluator_id_FocusNode.dispose();
    _evaluation_criteria_id_Controller.dispose();
    _evaluation_criteria_id_FocusNode.dispose();
    _response_Controller.dispose();
    _response_FocusNode.dispose();
    _notes_Controller.dispose();
    _notes_FocusNode.dispose();
    _grade_Controller.dispose();
    _grade_FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              const Text(
                  'Fill in the details of the Evaluation you want to add'),
              TextFormField(
                controller: _evaluatee_id_Controller,
                decoration: const InputDecoration(labelText: 'Evaluatee_Id'),
                onFieldSubmitted: (_) {
                  _evaluatee_id_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _evaluator_id_Controller,
                decoration: const InputDecoration(labelText: 'Evaluator_Id'),
                onFieldSubmitted: (_) {
                  _evaluator_id_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _evaluation_criteria_id_Controller,
                decoration:
                    const InputDecoration(labelText: 'Evaluation_Criteria_Id'),
                onFieldSubmitted: (_) {
                  _evaluation_criteria_id_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _grade_Controller,
                decoration: const InputDecoration(labelText: 'Grade'),
                onFieldSubmitted: (_) {
                  _grade_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _response_Controller,
                decoration: const InputDecoration(labelText: 'Response'),
                onFieldSubmitted: (_) {
                  _response_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _notes_Controller,
                decoration: const InputDecoration(labelText: 'Notes'),
                onFieldSubmitted: (_) {
                  _notes_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addEvaluation(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  String? _mandatoryValidator(String? text) {
    return (text!.isEmpty) ? 'Required' : null;
  }

  Future<void> _addEvaluation(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final Evaluation evaluation = Evaluation(
            evaluatee_id: int.parse(_evaluatee_id_Controller.text),
            evaluator_id: int.parse(_evaluator_id_Controller.text),
            evaluation_criteria_id:
                int.parse(_evaluation_criteria_id_Controller.text),
            grade: int.parse(_grade_Controller.text),
            notes: _notes_Controller.text,
            response: _response_Controller.text);
        await createEvaluation([evaluation]);
        Navigator.of(context).pop(true);
      }
    } on Exception {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Failed to add Evaluations'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}

class EditEvaluationPage extends StatefulWidget {
  static const String route = 'evaluation/edit';
  final Evaluation evaluation;
  const EditEvaluationPage({super.key, required this.evaluation});
  @override
  _EditEvaluationPageState createState() => _EditEvaluationPageState();
}

class _EditEvaluationPageState extends State<EditEvaluationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _evaluatee_id_Controller;
  late FocusNode _evaluatee_id_FocusNode;
  late TextEditingController _evaluator_id_Controller;
  late FocusNode _evaluator_id_FocusNode;
  late TextEditingController _evaluation_criteria_id_Controller;
  late FocusNode _evaluation_criteria_id_FocusNode;
  late TextEditingController _response_Controller;
  late FocusNode _response_FocusNode;
  late TextEditingController _notes_Controller;
  late FocusNode _notes_FocusNode;
  late TextEditingController _grade_Controller;
  late FocusNode _grade_FocusNode;

  @override
  void initState() {
    super.initState();
    final Evaluation evaluation = widget.evaluation;
    _evaluatee_id_Controller =
        TextEditingController(text: evaluation.evaluatee_id.toString());
    _evaluatee_id_FocusNode = FocusNode();
    _evaluator_id_Controller =
        TextEditingController(text: evaluation.evaluator_id.toString());
    _evaluator_id_FocusNode = FocusNode();
    _evaluation_criteria_id_Controller = TextEditingController(
        text: evaluation.evaluation_criteria_id.toString());
    _evaluation_criteria_id_FocusNode = FocusNode();
    _response_Controller = TextEditingController(text: evaluation.response);
    _response_FocusNode = FocusNode();
    _notes_Controller = TextEditingController(text: evaluation.response);
    _notes_FocusNode = FocusNode();
    _grade_Controller =
        TextEditingController(text: evaluation.grade.toString());
    _grade_FocusNode = FocusNode();
  }

  @override
  void dispose() {
    _evaluatee_id_Controller.dispose();
    _evaluatee_id_FocusNode.dispose();
    _evaluator_id_Controller.dispose();
    _evaluator_id_FocusNode.dispose();
    _evaluation_criteria_id_Controller.dispose();
    _evaluation_criteria_id_FocusNode.dispose();
    _response_Controller.dispose();
    _response_FocusNode.dispose();
    _notes_Controller.dispose();
    _notes_FocusNode.dispose();
    _grade_Controller.dispose();
    _grade_FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              const Text(
                  'Fill in the details of the Evaluation you want to edit'),
              TextFormField(
                controller: _evaluatee_id_Controller,
                decoration: const InputDecoration(labelText: 'Evaluatee_id'),
                onFieldSubmitted: (_) {
                  _evaluatee_id_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _evaluator_id_Controller,
                decoration: const InputDecoration(labelText: 'Evaluator_Id'),
                onFieldSubmitted: (_) {
                  _evaluator_id_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _evaluation_criteria_id_Controller,
                decoration:
                    const InputDecoration(labelText: 'Evaluation_Criteria_Id'),
                onFieldSubmitted: (_) {
                  _evaluation_criteria_id_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _grade_Controller,
                decoration: const InputDecoration(labelText: 'Grade'),
                onFieldSubmitted: (_) {
                  _grade_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _response_Controller,
                decoration: const InputDecoration(labelText: 'Response'),
                onFieldSubmitted: (_) {
                  _response_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _notes_Controller,
                decoration: const InputDecoration(labelText: 'Notes'),
                onFieldSubmitted: (_) {
                  _notes_FocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _editEvaluation(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  String? _mandatoryValidator(String? text) {
    return (text!.isEmpty) ? 'Required' : null;
  }

  Future<void> _editEvaluation(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final Evaluation evaluation = Evaluation(
            id: widget.evaluation.id,
            evaluatee_id: int.parse(_evaluatee_id_Controller.text),
            evaluator_id: int.parse(_evaluator_id_Controller.text),
            evaluation_criteria_id:
                int.parse(_evaluation_criteria_id_Controller.text),
            grade: int.parse(_grade_Controller.text),
            response: _response_Controller.text,
            notes: _notes_Controller.text);
        await updateEvaluation(evaluation);
        Navigator.of(context).pop(true);
      }
    } on Exception {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: const Text('Failed to edit evaluation'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  )
                ],
              ));
    }
  }
}
