
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart'as http;
import 'package:phlox_animations/phlox_animations.dart';
import 'package:untitled3/core/helpers/extensions.dart';

import '../../../chat/Api/service/chat_controller.dart';
import '../../../chat/modules/chat_page.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_localizations.dart';
import '../../../core/theming/styles.dart';
import '../../../networking/api_constants.dart';
import '../../add/widget/shared_preferences.dart';



enum _Tab {
  requirement,
  about,
}

class DetailSuggestionScreen extends StatefulWidget {
  const DetailSuggestionScreen({super.key});

  @override
  State<DetailSuggestionScreen> createState() => _DetailSuggestionScreenState();
}

class _DetailSuggestionScreenState extends State<DetailSuggestionScreen> {
  final selectedTab = ValueNotifier(_Tab.requirement);
  String extractPath(String fullPath) {
    var pathParts = fullPath.split('\\');

    return pathParts.sublist(pathParts.length - 1).join('/');
  }
  String token=  CachData.getData(key: 'access_token');
  Future <void> ApplyToCompany(int id)async{
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':'Bearer $token'

    };
    var request = http.Request('POST', Uri.parse('${ApiConstants.apiBaseUrl}applications/create'));
    request.body = json.encode({
      "post_id": id
    });


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.access_alarm_outlined,
            color: Colors.green,
            size: 32,
          ),
          content: Text(
            'Job Application Has Been Submitted Successfully',
            style: TextStyles.font15DarkBlueMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                'Ok',
                style: TextStyles.font14BlueSemiBold,
              ),
            ),
          ],
        ),
      );
      print(await response.stream.bytesToString());
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 32,
          ),
          content: Text(
            'Sorry, your request has been sent previously, it cannot be sent again',
            style: TextStyles.font15DarkBlueMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                'Ok',
                style: TextStyles.font14BlueSemiBold,
              ),
            ),
          ],
        ),
      );

      print(response.reasonPhrase);
      print(id);
    }

  }




  dynamic baseUrl = ApiConstants.Url;
  // dynamic companyLogo = 'defaults/company_default.png';


  @override
  Widget build(BuildContext context) {
    ChatsController controller = Get.find<ChatsController>();

    final job = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var extractedPath = extractPath(job['company_logo']!);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("details"),
          style: Theme.of(context).textTheme.headlineSmall,
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Expanded(
          child: Column(
            children: [

              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Image.network(
                        // extractedPath,
                        // job['company_logo'],
                        // job['company_logo'],
                        job['company_logo'] != null && job['company_logo']!.isNotEmpty
                            ? baseUrl + extractedPath
                            : '',
                        width: 96,
                        height: 96,
                      ),
                    ),
                    Text(
                      job['general_job_title'],
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job['company_name'],
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.place_outlined,
                                  color: AppColor.primaryColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                job['detailed_location'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.attach_money_rounded,
                                    color: AppColor.primaryColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  job['expected_salary'],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.card_travel_rounded,
                                    color: AppColor.primaryColor,
                                    size: 28,
                                  ),
                                ),


                                const SizedBox(height: 8),
                                Text(
                                  job['enrollment_status'],//jopType
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {
                        return Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                left: value == _Tab.requirement
                                    ? 0
                                    : (MediaQuery.of(context).size.width - 48) / 2,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  height: 40,
                                  width: (MediaQuery.of(context).size.width - 48) / 2,
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value = _Tab.requirement;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: Text(
                                            AppLocalizations.of(context)!.translate("requirments"),
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black38),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedTab.value = _Tab.about;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          color: Colors.transparent,
                                          alignment: Alignment.center,
                                          child: Text(
                                            AppLocalizations.of(context)!.translate("about"),
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black38),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: selectedTab,
                      builder: (context, value, child) {

                        return value == _Tab.requirement
                            ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          //recentJobs.requirements.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "- ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(height: 1.4),
                                ),
                                Expanded(
                                  child: Text(
                                    job['requirements'],
                                    // recentJobs.requirements[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(height: 1.4),
                                  ),
                                )
                              ],
                            );
                          },
                        )
                            : Text(
                          job['job_information'],
                          // recentJobs.about,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(height: 1.4),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 56,
                child: ElevatedButton(

                  onPressed: () {
                    ApplyToCompany(job['id']);

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:const Color(0xffff962d),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  child:  Text(
                    AppLocalizations.of(context)!.translate("aplly"),
                    style:TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                    // Theme.of(context)
                    //     .textTheme
                    //     .bodyLarge
                    //     ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 12.h,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 56,
                child: PhloxAnimations(
                  duration: const Duration(milliseconds: 1000),
                  fromX: 200,
                  child: ElevatedButton(

                    onPressed: () {
                      controller.addChat(idUser: job['user_id']);
                      ChatPage();
                      //     job['user_id'];
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:const Color(0xffff962d),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        )),
                    child:  Text(
                      AppLocalizations.of(context)!.translate("chat"),
                      style:TextStyle(
                          color: Colors.white,
                          fontSize: 18
                      ),
                      // Theme.of(context)
                      //     .textTheme
                      //     .bodyLarge
                      //     ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


