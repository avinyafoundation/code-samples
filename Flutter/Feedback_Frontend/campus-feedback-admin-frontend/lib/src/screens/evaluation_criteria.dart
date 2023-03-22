import 'package:ShoolManagementSystem/src/data/evaluation.dart';
import 'package:ShoolManagementSystem/src/data/evaluation_criteria.dart';
import 'package:ShoolManagementSystem/src/widgets/evaluation_criteria.dart';

import 'package:ShoolManagementSystem/src/widgets/evaluation_list.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../routing.dart';

class EvaluationCriteriaScreen extends StatefulWidget {
  const EvaluationCriteriaScreen({super.key});

  @override
  State<EvaluationCriteriaScreen> createState() =>
      _EvaluationCriteriaScreenState();
}

class _EvaluationCriteriaScreenState extends State<EvaluationCriteriaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newPath = _routeState.route.pathTemplate;
    if (newPath.startsWith('/evaluation_criteria/all')) {
      _tabController.index = 0;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Evaluation Criteria"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'All Evaluations Criteria',
                icon: Icon(Icons.list_alt),
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            EvaluationCriteriaList(
              onTap: _handleEvaluationTapped,
            ),
          ],
        ),
      );

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleEvaluationTapped(EvaluationCriteria evaluationCriteria) {
    _routeState.go('/evaluation_criteria/${evaluationCriteria.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 0:
      default:
        _routeState.go('/evaluation_criteria/all');
        break;
    }
  }
}
