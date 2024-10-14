import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_edit_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/services/action_service.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController _calendarController = CalendarController();

  void calendarViewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _calendarController.selectedDate = null;
    });
  }

  _AppointmentDataSource _dataSource = _AppointmentDataSource([]);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
      title: LangUtil.getString('Application', 'MainMenu.Calendar.Header'),
      body: SfCalendar(
        view: CalendarView.month,
        controller: _calendarController,
        monthViewSettings: MonthViewSettings(showAgenda: true),
        dataSource: _dataSource,
        showDatePickerButton: true,
        allowViewNavigation: true,
        scheduleViewSettings: ScheduleViewSettings(
          monthHeaderSettings: MonthHeaderSettings(
            backgroundColor: const Color(0xFFFAFAFA),
            height: 80,
            monthTextStyle: TextStyle(
              color: Colors.black54,
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        allowedViews: <CalendarView>[
          CalendarView.day,
          CalendarView.week,
          CalendarView.workWeek,
          CalendarView.month,
          CalendarView.schedule
        ],
        loadMoreWidgetBuilder:
            (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          return FutureBuilder<void>(
            future: loadMoreAppointments(),
            builder: (context, snapShot) {
              return LinearProgressIndicator();
            },
          );
        },
        onViewChanged: calendarViewChanged,
        onTap: (e) async {
          if (e.targetElement == CalendarElement.appointment) {
            context.loaderOverlay.show();

            dynamic action =
                await ActionService().getEntity(e.appointments![0].notes);

            context.loaderOverlay.hide();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ActionEditScreen(
                    action: action.data,
                    readonly: true,
                    popScreens: 0,
                  );
                },
              ),
            );
          }
        },
      ),
      action: PsaAddButton(
        onTap: () => Navigator.pushNamed(context, '/action/type'),
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    await Future.delayed(Duration(seconds: 1));

    DateTime dateRangeState =
        DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime dateRangeEnd =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    List<dynamic> data =
        await ActionService().getByDate(dateRangeState, dateRangeEnd);

    List<Appointment> meetings = <Appointment>[];

    for (dynamic apmt in data) {
      var startDate = DateTime.parse(apmt['ACTION_DATE']);
      var endDate = DateTime.parse(apmt['ACTION_END_DATE']);
      var startTime = DateTime.parse(apmt['ACTION_TIME']);
      var endTime = DateTime.parse(apmt['ACTION_END_TIME']);

      var appointment = Appointment(
        notes: apmt['ACTION_ID'],
        startTime: DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          startTime.hour,
          startTime.minute,
        ),
        endTime: DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          endTime.hour,
          endTime.minute,
        ),
        subject: apmt['DESCRIPTION'],
        color: apmt['__ACTION_CLASS'] == 'T'
            ? Color(0xFF92d100)
            : apmt['__ACTION_CLASS'] == 'E'
                ? Color(0xFFff76bc)
                : apmt['__ACTION_CLASS'] == 'A'
                    ? Color(0xFFaa40ff)
                    : apmt['__ACTION_CLASS'] == 'L'
                        ? Color(0xFFf47b27)
                        : apmt['__ACTION_CLASS'] == 'G'
                            ? Color(0xFF1faeff)
                            : Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
      );

      if (appointments!.contains(appointment)) {
        continue;
      }

      meetings.add(appointment);
    }

    appointments!.addAll(meetings);

    notifyListeners(CalendarDataSourceAction.add, meetings);
  }
}
