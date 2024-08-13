// import 'package:flutter/material.dart';
//
import 'package:pluto_grid/pluto_grid.dart';
//
//
// class CustomPlutoGrid extends StatefulWidget {
//   CustomPlutoGrid(
//       {super.key,
//         required this.init,
//         required this.onSelected,
//         required this.columns,
//         required this.rows,
//         this.onRowDoubleTap,
//         this.isEmp=false,
//       });
//
//   @override
//   State<CustomPlutoGrid> createState() => _CustomPlutoGridState();
//   final Function(PlutoGridOnSelectedEvent) onSelected;
//   final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
//   final Future<List<PlutoCell>> Function() init;
// final  List<PlutoColumn> columns ;
//  final List<PlutoRow> rows ;
//
//   final bool isEmp;
// }
//
// class _CustomPlutoGridState extends State<CustomPlutoGrid> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PlutoGrid(
//       columns: widget.columns,
//       rows: widget.rows,
//       onChanged: (event) {
//         print("onChanged");
//       },
//       onLoaded: (PlutoGridOnLoadedEvent event) {
//
//       },
//       mode: PlutoGridMode.selectWithOneTap,
//
//       onRowDoubleTap: widget.onRowDoubleTap,
//       onSelected: widget.onSelected,
//       configuration: PlutoGridConfiguration(
//
//         style: PlutoGridStyleConfig(
//             enableRowColorAnimation: true,
//             activatedColor:Colors.white.withOpacity(0.5),
//             gridBackgroundColor: Colors.transparent,
//             // evenRowColor: secondaryColor.withOpacity(0.5),
//             // cellTextStyle: Styles.headLineStyle3.copyWith(color: primaryColor),
//             gridPopupBorderRadius: const BorderRadius.all(Radius.circular(15)),
//             gridBorderRadius: const BorderRadius.all(Radius.circular(15)),
//             gridBorderColor: Colors.transparent),
//         localeText: const PlutoGridLocaleText.arabic(),
//       ),
//
//       createFooter: (stateManager) {
//         stateManager.setPageSize(40, notify: false); // default 40
//         return PlutoPagination(stateManager);
//       },
//     );
//   }
// }
