import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/services/opportunity_service.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/services/company_service.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/services/contact_service.dart';
import 'package:salesachiever_mobile/modules/5_project/services/project_service.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/entity_list_item.dart';
import 'package:salesachiever_mobile/utils/error_util.dart';
import 'package:salesachiever_mobile/utils/message_util.dart';

class LinkedCompanyListItemWidget extends EntityListItemWidget {
  const LinkedCompanyListItemWidget({
    Key? key,
    required entity,
    required refresh,
    required bool isSelectable,
    required bool isEditable,
    this.onEdit,
    this.onDelete,
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

  @override
  _LinkedCompanyListItemWidgetState createState() =>
      _LinkedCompanyListItemWidgetState();
}

class _LinkedCompanyListItemWidgetState
    extends EntityListItemWidgetState<LinkedCompanyListItemWidget> {
  late Future<dynamic> _future;

  @override
  void initState() {
    if (widget.entity['LINK_ID'] != null) {
      _future =
          ProjectService().getProjectAccountLink(widget.entity['LINK_ID']);
    } else {
      _future =
          OpportunityService().getCompanyOppLink(widget.entity['MULTI_ID']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String companyName = widget.entity['ACCTNAME'] ?? '';

    return Container(
      child: FutureBuilder<dynamic>(
          future: _future,
          builder: (context, snapshot) {
            return ListTile(
              dense: true,
              title: Text(
                companyName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      snapshot.data?['SITE_TOWN'] ?? '',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Row(
                          children: [
                            Text(
                              'Contact: ',
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                try {
                                  context.loaderOverlay.show();

                                  dynamic contact = await ContactService()
                                      .getEntity(snapshot.data?['CONT_ID']);

                                  dynamic company = await CompanyService()
                                      .getEntity(snapshot.data?['ACCT_ID']);

                                  contact.data['ACCTNAME'] =
                                      company.data['ACCTNAME'];

                                  context.loaderOverlay.hide();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ContactEditScreen(
                                          contact: contact.data,
                                          readonly: true,
                                        );
                                      },
                                    ),
                                  ).then((value) => widget.refresh());
                                } on DioError catch (e) {
                                  ErrorUtil.showErrorMessage(
                                      context, e.message);
                                } catch (e) {
                                  ErrorUtil.showErrorMessage(
                                      context, MessageUtil.getMessage('500'));
                                } finally {
                                  context.loaderOverlay.hide();
                                }
                              },
                              child: Text(
                                '${snapshot.data?['FIRSTNAME'] ?? ''} ${snapshot.data?['SURNAME'] ?? ''}',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.isEditable)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: widget.onEdit,
                          child: Text('Edit'),
                        ),
                        TextButton(
                          onPressed: widget.onDelete,
                          child: Text('Delete'),
                        )
                      ],
                    )
                ],
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
                    'TEXT': widget.entity['ACCTNAME']
                  });
                  return;
                }

                context.loaderOverlay.show();

                dynamic company =
                    await CompanyService().getEntity(widget.entity['ACCT_ID']);

                context.loaderOverlay.hide();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CompanyEditScreen(
                        company: company.data,
                        readonly: true,
                      );
                    },
                  ),
                ).then((value) => widget.refresh());
              },
            );
          }),
    );
  }
}
