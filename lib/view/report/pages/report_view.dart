import 'package:flutter/material.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  Offset update = const Offset(0, 0);
  Offset start = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails _) {
        start = _.globalPosition;
        setState(() {});
      },
      onLongPressEnd: (LongPressEndDetails _) {
        start = Offset.zero;
        update = Offset.zero;
        setState(() {});
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails _) {
        update = _.globalPosition;
        setState(() {});
      },
      child: MouseRegion(
        cursor: start == Offset.zero ? SystemMouseCursors.basic : SystemMouseCursors.grabbing,
        child: Scaffold(
          body: Stack(
            children: [
              ListView.builder(
                  itemCount: 500,
                  itemBuilder: (context, index) {
                    return Text(index.toString());
                  }),
              const Center(
                child: Text("aaaaaaaaa"),
              ),
              Positioned(
                top: update.dy - start.dy > 0 ? start.dy : -start.dy + (update.dy + start.dy).abs(),
                left: update.dx - start.dx > 0 ? start.dx : -start.dx + (update.dx + start.dx).abs(),
                child: Container(
                  width: update == Offset.zero ? 10 : (update.dx - start.dx).abs(),
                  height: update == Offset.zero ? 10 : (update.dy - start.dy).abs(),
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
