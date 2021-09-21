import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import '../../api/api.dart';

class ShigaWaitingArguments {
  final String ticketId;

  ShigaWaitingArguments(this.ticketId);
}

class ShigaWaitingPage extends StatefulWidget {
  _ShigaWaitingPageState createState() => _ShigaWaitingPageState();
}

class _ShigaWaitingPageState extends State<ShigaWaitingPage> {
  Timer? getTicketTimer;
  Timer? secCountTimer;
  CancelableOperation<void>? getTicketFuture;
  int male = 0;
  int female = 0;
  int remainsSec = 60;

  void setStateIfMounted(void Function() setStateCallback) {
    if (this.mounted) {
      setState(setStateCallback);
    }
  }

  void setMale(int num) {
    setStateIfMounted(() {
      male = num;
    });
  }

  void setFemale(int num) {
    setStateIfMounted(() {
      female = num;
    });
  }

  void getTicketLoop(String ticketId) {
    void getTicketLoopCallback() {
      getTicketFuture = CancelableOperation.fromFuture(
          getTicket(ticketId: ticketId).then((response) {
        print(response.matchingInfo.toString());
        setMale(response.matchingInfo.male);
        setFemale(response.matchingInfo.female);
        if (response.ticket.assignment == null) {
          if (this.mounted) {
            getTicketTimer = Timer(Duration(seconds: 5), getTicketLoopCallback);
          }
        } else {
          // TODO: jump other
          print("jump");
        }
      }).catchError((err) {
        print(err);
      }));
    }

    getTicketLoopCallback();
  }

  @override
  void initState() {
    secCountTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainsSec == 0) {
        secCountTimer?.cancel();
      } else {
        setStateIfMounted(() {
          remainsSec = remainsSec - 1;
        });
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(this.context)!.settings.arguments
        as ShigaWaitingArguments;
    if (getTicketTimer == null) {
      getTicketLoop(args.ticketId);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctx) {
    final args =
        ModalRoute.of(ctx)!.settings.arguments as ShigaWaitingArguments;
    return CupertinoPageScaffold(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(args.ticketId),
        Text(male.toString()),
        Text(female.toString()),
        Text(remainsSec.toString()),
        CupertinoButton(
            child: Text('Shiga'),
            onPressed: () {
              Navigator.popAndPushNamed(ctx, "/");
            })
      ]),
    );
  }

  @override
  void dispose() {
    getTicketFuture?.cancel();
    getTicketTimer?.cancel();
    secCountTimer?.cancel();
    super.dispose();
  }
}
