import 'package:flutter/material.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/common_header.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';

import '../../utils/lang_util.dart';

class DynamicSubTabListingScreen extends StatelessWidget {
  final dynamic list;
  final String title;
  final dynamic project;
  final String entityType;

  DynamicSubTabListingScreen(
      {Key? key,
      this.list,
      required this.title,
      required this.entityType,
      this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PsaScaffold(
        title: title,
        body: Column(
          children: [
            Container(
                height: 70,
                child: CommonHeader(entityType: entityType, entity: project)),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = list[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final entry in item.entries)
                                  entry.key == "SAUSER_ID"
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20, top: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 4, 0, 4),
                                                    child: Text(
                                                      '${LangUtil.getString('${entry.key.contains("_") ? entry.key.substring(0, entry.key.indexOf('_')) : ""}', '${entry.key.split('_').length < 3 ? entry.key : entry.key.contains("_") ? entry.key.substring(entry.key.indexOf("_") + 1) : entry.key}')} :',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Color(
                                                              0xffE67E6B)),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      maxLines: 2,
                                                    )),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 4, 0, 4),
                                                  child: Text(
                                                    entry.value != null
                                                        ? entry.key.contains(
                                                                "DATE")
                                                            ? DateUtil
                                                                .getFormattedDate(
                                                                    entry.value)
                                                            : entry.key
                                                                    .contains(
                                                                        "TIME")
                                                                ? DateUtil
                                                                    .getFormattedTime(
                                                                        entry
                                                                            .value)
                                                                : '${entry.value.toString()}'
                                                        : "",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : entry.key.contains("_ID") ||
                                              entry.key.contains("__") ||
                                              entry.key.contains("_DORMANT") ||
                                              entry.key.contains("DORMANT")
                                          ? SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20,
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                0, 4, 0, 4),
                                                        child: Text(
                                                          '${LangUtil.getString('${entry.key.contains("_") ? entry.key.substring(0, entry.key.indexOf('_')) : ""}', '${entry.key.split('_').length < 3 ? entry.key : entry.key.contains("_") ? entry.key.substring(entry.key.indexOf("_") + 1) : entry.key}')} :',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xffE67E6B)),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                          maxLines: 2,
                                                        )),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 4, 0, 4),
                                                      child: Text(
                                                        entry.value != null
                                                            ? entry.key
                                                                    .contains(
                                                                        "DATE")
                                                                ? DateUtil
                                                                    .getFormattedDate(
                                                                        entry
                                                                            .value)
                                                                : entry.key.contains(
                                                                        "TIME")
                                                                    ? DateUtil
                                                                        .getFormattedTime(
                                                                            entry.value)
                                                                    : '${entry.value.toString()}'
                                                            : "",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: false,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
