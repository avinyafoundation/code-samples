import 'package:flutter/material.dart';

import '../data.dart';
import '../routing.dart';

class ApplicationDetails extends StatefulWidget {
  const ApplicationDetails({super.key, this.onTap});
  final ValueChanged<Application>? onTap;

  @override
  // ignore: no_logic_in_create_state
  ApplicationDetailsState createState() => ApplicationDetailsState(onTap);
}

class ApplicationDetailsState extends State<ApplicationDetails> {
  late Future<Application> futureApplication;
  final ValueChanged<Application>? onTap;

  ApplicationDetailsState(this.onTap);

  @override
  void initState() {
    super.initState();
    if (campusFeedbackSystemInstance.getStudentPerson().id == null) {
      campusFeedbackSystemInstance.fetchPersonForUser();
    }
    if (campusFeedbackSystemInstance.getStudentPerson().id != null) {
      futureApplication =
          fetchApplication(campusFeedbackSystemInstance.getStudentPerson().id!);
    }
  }

  Future<Application> refreshApplicationState() async {
    if (campusFeedbackSystemInstance.getStudentPerson().id == null) {
      campusFeedbackSystemInstance.fetchPersonForUser();
    }
    if (campusFeedbackSystemInstance.getStudentPerson().id != null) {
      futureApplication =
          fetchApplication(campusFeedbackSystemInstance.getStudentPerson().id!);
    }
    return futureApplication;
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    try {
      campusFeedbackSystemInstance
          .fetchPersonForUser(); // do a fetch to help cross check
      Person person = campusFeedbackSystemInstance.getStudentPerson();
      if (campusFeedbackSystemInstance.getJWTSub() != person.jwt_sub_id) {
        // the person has not logged in
        routeState.go('/signin');
        return Container();
      }
    } catch (e) {
      routeState.go('/signin');
      return Container();
    }
    return FutureBuilder<Application>(
      future: refreshApplicationState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          campusFeedbackSystemInstance.setApplication(snapshot.data);
          return ListView.builder(
            itemCount: snapshot.data!.statuses.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                'Application submitted on ' + snapshot.data!.application_date!,
              ),
              subtitle: Text(
                ' ' +
                    snapshot.data!.statuses[index].status! +
                    ' ' +
                    snapshot.data!.statuses[index].updated! +
                    ' ',
              ),
              onTap: onTap != null ? () => onTap!(snapshot.data!) : null,
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
}
