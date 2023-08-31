import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/api_client/api.dart';

import '../../widgetStyles/text/text.dart';

class UserBalanceView extends StatefulWidget {
  final List<Wallet> wallets;
  final List<Organization> organizations;

  const UserBalanceView({super.key, required this.wallets, required this.organizations});

  @override
  State<StatefulWidget> createState() => _UserBalanceViewState();
}

class _UserBalanceViewState extends State<UserBalanceView> {

  final ScrollController _scrollableController = ScrollController();
  final ScrollController _viewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollableController.dispose();
    _viewScrollController.dispose();
    super.dispose();
  }

  DataTable getStatic() {
    final columns = [
      DataColumn(
        label: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.all(0),
          child: Text(
            "Организация",
            style: TextStyles.postText(),
          ),
        )
      ),
    ];
    final rows = List.generate(
      widget.organizations.length,
      (index) => DataRow(
        cells: [
          DataCell(
              Column(
                children: [
                  Flexible(
                      child: Text(
                        widget.organizations[index].name ?? " -- ",
                        style: TextStyles.postText(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  )
                ],
              )
          ),
        ],
      ),
    );
    return DataTable(
      columns: columns,
      rows: rows,
    );
  }

  DataTable getScrollable() {

    var columns = [
      DataColumn(
        label: Text(
          "Баланс",
          style: TextStyles.postText(),
        ),
      ),
      DataColumn(
        label: Text(
          "Ожидает\nначисления",
          style: TextStyles.postText(),
        ),
      ),
    ];
    var rows = List.generate(
      widget.wallets.length,
      (index) {
        var row = DataRow(
          cells: [
            DataCell(
              Text(
                widget.wallets[index].balance?.toString() ?? "0",
                style: TextStyles.postText(),
              ),
            ),
            DataCell(
              Text(
                widget.wallets[index].pendingBalance?.toString() ?? "0",
                style: TextStyles.postText(),
              ),
            ),
          ],
        );
        return row;
      },
    );

    return DataTable(columns: columns, rows: rows);
  }

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      thumbVisibility: true,
      controller: _viewScrollController,
      child: SingleChildScrollView(
        controller: _viewScrollController,
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            getStatic(),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: _scrollableController,
                child: SingleChildScrollView(
                  controller: _scrollableController,
                  scrollDirection: Axis.horizontal,
                  child: getScrollable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
