import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/action/dynamic_action_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/company/dynamic_company_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/contact/dynamic_contact_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/opportunity/dynamic_opportunity_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/project/dynamic_project_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/screens/quotation/dynamic_quotation_tab.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/utils/date_util.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/lang_util.dart';

class DynamicProjectListItemWidget extends EntityListItemWidget {
  const DynamicProjectListItemWidget({
    Key? key,
    required entity,
    required refresh,
    bool isSelectable = false,
    required bool isEditable,
    this.onEdit,
    this.onDelete,
    required this.type,
  })  : assert(entity != null),
        super(
          key: key,
          entity: entity,
          refresh: refresh,
          isSelectable: isSelectable,
          isEditable: isEditable,
        );

  final Function()? onEdit;
  final Function()? onDelete;
  final String type;

  @override
  _ProjectListItemWidgetState createState() => _ProjectListItemWidgetState();
}

class _ProjectListItemWidgetState
    extends EntityListItemWidgetState<DynamicProjectListItemWidget> {
  List<dynamic> currencyDefaultValues = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  bool isStringDate(String input) {
    try {
      List<String> formats = [
        "yyyy-MM-dd'T'HH:mm:ss", // ISO 8601 format
      ];
      for (var format in formats) {
        var dateFormat = DateFormat(format);
        DateTime dateTime = dateFormat.parseStrict(input);
        if (dateTime != null) {
          return true;
        }
      }
      return false; // None of the formats matched
    } catch (e) {
      return false; // Parsing error means it's not a date
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'COMPANY') {
      return ListTile(
        subtitle: ListView.builder(
          itemCount:  widget.entity.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final key =  widget.entity.keys.elementAt(index);
            final value =  widget.entity[key];
            String contextId =
                key.contains("_") ? key.substring(0, key.indexOf('_')) : key;
            String itemId =
                key.contains("_") ? key.substring(key.indexOf("_") + 1) : key;
            List<String> parts = key.split('_');
            bool containsCurrencyValue = currencyDefaultValues.any((entry) =>
                entry["FIELD_NAME"] ==
                LangUtil.getString(contextId, itemId).toUpperCase());
            if (key.contains("_ID") && parts.length < 3) {
              return SizedBox();
            } else {
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${LangUtil.getString(contextId, itemId)} :',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff3cab4f)),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value != null
                                ? (value is String && isStringDate(value))
                                    ? DateUtil.getFormattedDate(value)
                                    : key.contains("TIME")
                                        ? DateUtil.getFormattedTime(value)
                                        : containsCurrencyValue == true
                                            ? DateUtil.getCurrencyValue(value)
                                            : value.toString()
                                : "",
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(context.platformIcons.rightChevron),
          ],
        ),
        onTap: () async {
          if (widget.isSelectable) {
            Navigator.pop(context, {
              'ID': widget.entity['ACCT_ID'],
              'TEXT': widget.entity['ACCOUNT_ACCTNAME'],
              'ACCT_ID': widget.entity['PROJECT_ID'],
              'ACCTNAME': widget.entity['PROJECT_TITLE'],
            });
            return;
          }
          context.loaderOverlay.show();
          dynamic project = await DynamicProjectService()
              .getEntityById(widget.type, widget.entity['ACCT_ID']);
          context.loaderOverlay.hide();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DynamicCompanyTabScreen(
                  entity: project.data,
                  title: widget.entity['ACCOUNT_ACCTNAME'] != null
                      ? widget.entity['ACCOUNT_ACCTNAME']
                      : "",
                  readonly: true,
                  moduleId: "003",
                  entityType: widget.type,
                  isRelatedEntity: false,
                );
              },
            ),
          );
        },
      );
    } else {
      if (widget.type == 'OPPORTUNITY') {
        return ListTile(
          subtitle: ListView.builder(
            itemCount:  widget.entity.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final key =  widget.entity.keys.elementAt(index);
              final value =  widget.entity[key];
              String contextId = key.substring(0, key.indexOf('_'));
              String itemId =
                  key.contains("_") ? key.substring(key.indexOf("_") + 1) : key;
              List<String> parts = key.split('_');
              bool containsCurrencyValue = currencyDefaultValues.any((entry) =>
                  entry["FIELD_NAME"] ==
                  LangUtil.getString(contextId, itemId).toUpperCase());
              if (value is String) {
                isStringDate(value);
              }
              if (key.contains("_ID") && parts.length < 4) {
                return SizedBox();
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${LangUtil.getString(contextId, itemId)} :',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffA4C400)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value != null
                                  ? (value is String && isStringDate(value))
                                      ? DateUtil.getFormattedDate(value)
                                      : key.contains("TIME")
                                          ? DateUtil.getFormattedTime(value)
                                          : containsCurrencyValue == true
                                              ? DateUtil.getCurrencyValue(value)
                                              : value.toString()
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(context.platformIcons.rightChevron),
            ],
          ),
          onTap: () async {
            if (widget.isSelectable) {
              Navigator.pop(context, {
                'ID': widget.entity['ACCT_ID'],
                'TEXT': widget.entity['ACCOUNT_ACCTNAME'],
                'ACCT_ID': widget.entity['PROJECT_ID'],
                'ACCTNAME': widget.entity['PROJECT_TITLE'],
              });
              return;
            }
            context.loaderOverlay.show();
            dynamic project = await DynamicProjectService()
                .getEntityById(widget.type, widget.entity['DEAL_ID']);
            context.loaderOverlay.hide();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DynamicOpportunityTabScreen(
                    entity: project.data,
                    title: widget.entity['PROJECT_TITLE'] != null
                        ? widget.entity['PROJECT_TITLE']
                        : "",
                    readonly: true,
                    moduleId: "006",
                    entityType: widget.type,
                    isRelatedEntity: false,
                  );
                },
              ),
            );
          },
        );
      } else {
        if (widget.type == 'CONTACT') {
          return ListTile(
            subtitle: ListView.builder(
              itemCount:  widget.entity.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final key =  widget.entity.keys.elementAt(index);
                final value =  widget.entity[key];
                List<String> parts = key.split('_');
                String contextId = key.contains("_")
                    ? key.substring(0, key.indexOf('_'))
                    : "CONTACT";
                String itemId = key.contains("_")
                    ? key.substring(key.indexOf("_") + 1)
                    : key;
                bool containsCurrencyValue = currencyDefaultValues.any(
                    (entry) =>
                        entry["FIELD_NAME"] ==
                        LangUtil.getString(contextId, itemId).toUpperCase());
                if (key.contains("_ID") && parts.length < 3) {
                  return SizedBox();
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${LangUtil.getString(contextId, itemId)} :',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff4C99E0)),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value != null
                                    ? (value is String && isStringDate(value))
                                        ? DateUtil.getFormattedDate(value)
                                        : key.contains("TIME")
                                            ? DateUtil.getFormattedTime(value)
                                            : containsCurrencyValue == true
                                                ? DateUtil.getCurrencyValue(
                                                    value)
                                                : value.toString()
                                    : "",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(context.platformIcons.rightChevron),
              ],
            ),
            onTap: () async {
              if (widget.isSelectable) {
                Navigator.pop(context, {
                  'ID': widget.entity['ACCT_ID'],
                  'TEXT': widget.entity['FIRSTNAME'],
                  'ACCT_ID': widget.entity['ACCT_ID'],
                  'ACCTNAME': widget.entity['SURNAME'],
                });
                return;
              }
              context.loaderOverlay.show();
              dynamic project = await DynamicProjectService()
                  .getEntityById(widget.type, widget.entity['CONT_ID']);
              context.loaderOverlay.hide();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DynamicContactTabScreen(
                      entity: project.data,
                      title: widget.entity['PROJECT_TITLE'] != null
                          ? widget.entity['PROJECT_TITLE']
                          : "",
                      readonly: true,
                      moduleId: "004",
                      entityType: widget.type,
                      isRelatedEntity: false,
                    );
                  },
                ),
              );
            },
          );
        } else {
          if (widget.type == 'PROJECT') {
            return ListTile(
              subtitle: ListView.builder(
                itemCount:  widget.entity.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final key =  widget.entity.keys.elementAt(index);
                  final value =  widget.entity[key];
                  String contextId = key.substring(0, key.indexOf('_'));
                  String itemId = key.contains("_")
                      ? key.substring(key.indexOf("_") + 1)
                      : key;
                  List<String> parts = key.split('_');
                  bool containsCurrencyValue = currencyDefaultValues.any(
                      (entry) =>
                          entry["FIELD_NAME"] ==
                          LangUtil.getString(contextId, itemId).toUpperCase());
                  if (key.contains("_ID") && parts.length < 3) {
                    return SizedBox();
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${LangUtil.getString(contextId, itemId)} :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xffE67E6B)),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value != null
                                      ? (value is String && isStringDate(value))
                                          ? DateUtil.getFormattedDate(value)
                                          : key.contains("TIME")
                                              ? DateUtil.getFormattedTime(value)
                                              : containsCurrencyValue == true
                                                  ? DateUtil.getCurrencyValue(
                                                      value)
                                                  : value.toString()
                                      : "",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(context.platformIcons.rightChevron),
                ],
              ),
              onTap: () async {
                if (widget.isSelectable) {
                  Navigator.pop(context, {
                    'ID': widget.entity['PROJECT_ID'],
                    'TEXT': widget.entity['PROJECT_TITLE'],
                    'ACCT_ID': widget.entity['PROJECT_ID'],
                    'ACCTNAME': widget.entity['PROJECT_TITLE'],
                  });
                  return;
                }
                context.loaderOverlay.show();

                dynamic project = await ProjectService()
                    .getEntity(widget.entity['PROJECT_ID']);
                context.loaderOverlay.hide();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DynamicProjectTabScreen(
                        entity: project.data,
                        title: widget.entity['PROJECT_TITLE'] != null
                            ? widget.entity['PROJECT_TITLE']
                            : "",
                        readonly: true, moduleId: "005",
                        entityType: widget.type,
                        isRelatedEntity: false,
                      );
                    },
                  ),
                );
              },
            );
          } else {
            if (widget.type == 'ACTION') {
              return ListTile(
                subtitle: ListView.builder(
                  itemCount:  widget.entity.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final key =  widget.entity.keys.elementAt(index);
                    final value =  widget.entity[key];
                    List<String> parts = key.split('_');
                    print("sadrtfYDJHSCF${key}${parts.length - 1}");
                    String contextId = key.contains("__")
                        ? "ACTION"
                        : key.contains("_")
                            ? key.substring(0, key.indexOf('_'))
                            : "ACTION";
                    String itemId = key.contains("_")
                        ? key.substring(key.indexOf("_") + 1)
                        : key;
                    bool containsCurrencyValue = currencyDefaultValues.any(
                        (entry) =>
                            entry["FIELD_NAME"] ==
                            LangUtil.getString(contextId, itemId)
                                .toUpperCase());
                    if ((key.contains("_ID") && parts.length < 3) ||
                        key.contains("__") ||
                        key == "ACTION_SAUSER") {
                      return SizedBox();
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${LangUtil.getString(contextId, itemId)} :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xffae1a3e)),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value != null
                                        ? (value is String && isStringDate(value))
                                            ? DateUtil.getFormattedDate(value)
                                            : key.contains("TIME")
                                                ? DateUtil.getFormattedTime(
                                                    value)
                                                : containsCurrencyValue == true
                                                    ? DateUtil.getCurrencyValue(
                                                        value)
                                                    : value.toString()
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(context.platformIcons.rightChevron),
                  ],
                ),
                onTap: () async {
                  if (widget.isSelectable) {
                    Navigator.pop(context, {
                      'ID': widget.entity['ACCT_ID'],
                      'TEXT': widget.entity['ACCOUNT_ACCTNAME'],
                      'ACCT_ID': widget.entity['PROJECT_ID'],
                      'ACCTNAME': widget.entity['PROJECT_TITLE'],
                    });
                    return;
                  }

                  context.loaderOverlay.show();
                  dynamic project = await DynamicProjectService().getEntityById(widget.type, widget.entity['ACTION_ID']);
                  context.loaderOverlay.hide();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DynamicActionTabScreen(
                          entity: project.data,
                          title: widget.entity['PROJECT_TITLE'] != null
                              ? widget.entity['PROJECT_TITLE']
                              : "",
                          readonly: true,
                          moduleId: "009",
                          entityType: widget.type,
                          isRelatedEntity: false,
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              if (widget.type == 'QUOTATION') {
                return ListTile(
                  subtitle: ListView.builder(
                    itemCount:  widget.entity.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final key =  widget.entity.keys.elementAt(index);
                      final value =  widget.entity[key];
                      String contextId = key.substring(0, key.indexOf('_'));
                      String itemId = key.contains("_")
                          ? key.substring(key.indexOf("_") + 1)
                          : key;
                      List<String> parts = key.split('_');
                      print("parts$key${parts.length}");
                      print("conetxtsdbid${contextId}");
                      print("erfafxsgasjf${itemId}");
                      print("erfafxsgasjf${itemId}");
                      bool containsCurrencyValue = currencyDefaultValues.any(
                          (entry) =>
                              entry["FIELD_NAME"] ==
                              LangUtil.getString(contextId, itemId)
                                  .toUpperCase());
                      if (key.contains("_ID")) {
                        return SizedBox();
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${LangUtil.getString(contextId, itemId)} :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff00aba9)),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value != null
                                          ? (value is String && isStringDate(value))
                                              ? DateUtil.getFormattedDate(value)
                                              : key.contains("TIME")
                                                  ? DateUtil.getFormattedTime(
                                                      value)
                                                  : containsCurrencyValue ==
                                                          true
                                                      ? DateUtil
                                                          .getCurrencyValue(
                                                              value)
                                                      : value.toString()
                                          : "",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(context.platformIcons.rightChevron),
                    ],
                  ),
                  onTap: () async {
                    if (widget.isSelectable) {
                      Navigator.pop(context, {
                        'ID': widget.entity['QUOTATION_QUOTE_ID'],
                        'TEXT': widget.entity['QUOTATION_DESCRIPTION'],
                        'ACCT_ID': widget.entity['QUOTATION_QUOTE_ID'],
                        'ACCTNAME': widget.entity['QUOTATION_REPRESENTATIVE'],
                      });
                      return;
                    }
                    context.loaderOverlay.show();
                    dynamic project = await DynamicProjectService()
                        .getEntityById(
                            widget.type, widget.entity['QUOTATION_QUOTE_ID']);
                    context.loaderOverlay.hide();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DynamicQuotationTabScreen(
                            entity: project.data,
                            title: widget.entity['DESCRIPTION'] != null
                                ? widget.entity['DESCRIPTION']
                                : "",
                            readonly: true,
                            moduleId: "007",
                            entityType: widget.type,
                            isRelatedEntity: false,
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return SizedBox();
              }
            }
          }
        }
      }
    }
  }
}
