import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:salesachiever_mobile/modules/10_opportunities/screens/opportunity_edit_screen.dart';
import 'package:salesachiever_mobile/modules/3_company/screens/company_edit_screen.dart';
import 'package:salesachiever_mobile/modules/4_contact/screens/contact_edit_screen.dart';
import 'package:salesachiever_mobile/modules/5_project/screens/project_edit_screen.dart';
import 'package:salesachiever_mobile/modules/6_action/screens/action_edit_screen.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/services/dynamic_project_service.dart';
import 'package:salesachiever_mobile/modules/dynamic_module/5_dynamic_project/widgets/dynamic_project_list_item.dart';
import 'package:salesachiever_mobile/shared/widgets/buttons/psa_add_button.dart';
import 'package:salesachiever_mobile/modules/base/entity/widgets/psa_entity_list_view.dart';
import 'package:salesachiever_mobile/shared/widgets/layout/psa_scaffold.dart';
import 'package:salesachiever_mobile/utils/text_formatting_util.dart';

class DynamicProjectListScreen extends StatelessWidget {
  final List<dynamic>? sortBy;
  final List<dynamic>? filterBy;
  final String listName;
  final String listType;
  final bool isSelectable;

  const DynamicProjectListScreen({
    Key? key,
    this.sortBy,
    this.filterBy,
    required this.listName,
    required this.listType,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("listName${listName}");
    return PsaScaffold(
      title: "${capitalizeFirstLetter(listType)} - List",
      body: PsaEntityListView(
        service: DynamicProjectService(listName: listName),
        display: (
            {required final dynamic entity, required final Function refresh}) {
          return DynamicProjectListItemWidget(
            entity: entity,
            refresh: refresh,
            isSelectable: isSelectable,
            isEditable: false,
            type:listType
          );
        },
        type: listType,
        list: listName,
        sortBy: sortBy,
        filterBy: filterBy,
      ),
      action: PsaAddButton(
        onTap: ()
        {
          print("checking list type");
          print(listType);
          if(listType=="COMPANY"){
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => CompanyEditScreen(
                  company: {},
                  readonly: false,
                ),
              ),
            );
          }
          else if(listType=="CONTACT"){
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ContactEditScreen(
                  contact: {},
                  readonly: false,
                ),
              ),
            );
          }
          else if(listType=="ACTION"){
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => ActionEditScreen(
                  action: {},
                  readonly: false, popScreens: 1,
                ),
              ),
            );
          }
          else if(listType=="OPPORTUNITY"){
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) => OpportunityEditScreen(
                  deal: {},
                  readonly: false,
                ),
              ),
            );
          }
          else if(listType == "PROJECT"){
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (BuildContext context) =>
                    ProjectEditScreen(
                      project: {},
                      readonly: false,
                    ),
              ),
            );
          }
        },
      ),
    );
  }
}
