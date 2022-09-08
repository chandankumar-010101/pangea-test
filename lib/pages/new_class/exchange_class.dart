import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:pangeachat/model/teacher_all_class_model.dart';
import 'package:pangeachat/services/services.dart';
import 'package:pangeachat/utils/url_launcher.dart';
import 'package:vrouter/vrouter.dart';
import '../../model/flag_model.dart';

class ExchangeClass extends StatefulWidget {
  const ExchangeClass({Key? key}) : super(key: key);

  @override
  State<ExchangeClass> createState() => _ExchangeClassState();
}

class _ExchangeClassState extends State<ExchangeClass> {
  List<User>? members;
  Client? client;
  final box = GetStorage();
  List languageFlagList=[];
  TeacherAllClassModel? teacherAllClassModel;
  Object? sourceLanguage;

  String get roomId => VRouter.of(context).queryParameters['class_id']??"";
  // String? get ClientId => VRouter.of(context).queryParameters['client_id'];
  getClass() async {
    teacherAllClassModel = await PangeaServices.fetchTeacherAllClassInfo(context);
    PangeaServices.createExchangeValidateRequest(roomId:roomId,teacherID: box.read("ExchangeClientID"),context: context,);
  }

  @override
  void initState() {
    super.initState();
    getClass();
  }

  @override
  Widget build(BuildContext context) {
    getClass();
    Size size = MediaQuery.of(context).size;
    String id = context.vRouter.queryParameters['class_id'] ?? "";

    return Scaffold(
        appBar: id.isEmpty
            ? AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "Exchange Class",
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontSize: 14),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          elevation: 10,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.vRouter.to("/newclass/language");
            },
          ),
        )
            : null,
        body: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                      vertical: size.height * 0.02),
                  width: size.width,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Confirm the exchange?",
                      style: TextStyle().copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 14,fontWeight: FontWeight.w700),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                //switch buttons
                Container(

                  constraints: const BoxConstraints(

                    minWidth: 100,
                    maxWidth: 500,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        constraints:
                        BoxConstraints(minWidth: 100, maxWidth: 700),
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "A space will be made where you can both create rooms for your students to chat. Students from both classes will see these rooms in the exchange tab, and be able to join and chat within them.",
                                  style: TextStyle().copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 14),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints:
                        BoxConstraints(minWidth: 100, maxWidth: 700),
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "While both teachers allow 1-to-1 chats in exchanges, students will have this permission in this exchange.",

                                  style: TextStyle().copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 14),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints:
                        BoxConstraints(minWidth: 100, maxWidth: 700),
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "Either teachers can cancel the exchange at any time,",


                                  style: TextStyle().copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 14),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints:
                        const BoxConstraints(minWidth: 100, maxWidth: 700),
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  "While both teachers allow students to create rooms in the exchange, students will have this permission.",

                                  style: TextStyle().copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 14),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: PangeaServices.fetchTeacherAllClassInfo(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text(
                                  snapshot.error.toString()));
                            } else if (snapshot.hasData) {
                              final TeacherAllClassModel data = snapshot.data! as TeacherAllClassModel;
                              return ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                itemCount:  1,
                                itemBuilder: (context,index){
                                  languageFlagList.add(data.results![index].className);
                                  //print("value of dropdown is ${languageFlagList[0].val(teacherAllClassModel?.results![index].className)}");
                                  // print("${languageFlagList[index].val(teacherAllClassModel?.results![index].className)}");
                                  var singledata=data.results![index];
                                  return Container(
                                      constraints: BoxConstraints(
                                          minWidth: 100, maxWidth: 400),
                                      padding: EdgeInsets.all(size.height * 0.01),
                                      child: //languageFlagList.isNotEmpty
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColorLight),
                                          ),
                                          child:
                                          DropdownButton(
                                            hint: sourceLanguage == null ? Center(child: Text(
                                              "Select Class",
                                              style: TextStyle().copyWith(
                                                  color: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  fontSize: 14),
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.center,
                                            ),)
                                                :  Text(" ${sourceLanguage!}"
                                                .toString(),
                                              style: TextStyle().copyWith(
                                                  color: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  fontSize: 14),
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.center,
                                            ),
                                            isExpanded: true,
                                            items: data.results!.map((map) => DropdownMenuItem(
                                              child: Text(map.className.toString()),
                                              value: map.pangeaClassRoomId,//"${map.className.toString()} (${map.pangeaClassRoomId})",// map.pangeaClassRoomId,
                                            ),
                                            ).toList(), onChanged: (value) {

                                            print(value);

                                            setState(() {
                                              sourceLanguage = value;
                                            });

                                          },
                                          )



                                      )
                                    //: Container()
                                  );;
                                },
                                separatorBuilder: (BuildContext context, int index){
                                  return SizedBox( height: 10,);
                                },

                              );

                            }
                            else {
                              return Center(child: CircularProgressIndicator());
                            }
                          } ),

                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                    vertical: size.height * 0.02,
                  ),
                  child: id.isEmpty
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "2/4",
                            style: TextStyle().copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 14),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (ModalRoute.of(context)!.settings.name ==
                              "class_permissions") {
                            // createClassPermissions();
                          } else {
                            //update
                          }
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary ==
                                  Colors.white
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary ==
                                      Colors.white
                                      ? Theme.of(context)
                                      .primaryColorLight
                                      : Theme.of(context)
                                      .colorScheme
                                      .onPrimary)),
                          child: const Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {

                          // VRouter.of(context).to('/classDetails', queryParameters: { "id":id });


                        },
                        child: Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary ==
                                  Colors.white
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary ==
                                      Colors.white
                                      ? Theme.of(context)
                                      .primaryColorLight
                                      : Theme.of(context)
                                      .colorScheme
                                      .onPrimary)),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle().copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary ==
                                      Colors.white
                                      ? Theme.of(context)
                                      .primaryColorLight
                                      : Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,

                                  fontSize: 14),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          var clientid=box.read("ExchangeClientID");
                          var toClass=box.read("toClass");
                          PangeaServices.createExchangeRequest(roomId: sourceLanguage.toString(), context: context, teacherID: clientid, toClass: roomId,);
                          // print(sourceLanguage.toString());
                          // print(sourceLanguage.toString()=="null");
                          if(sourceLanguage.toString()!="null"){
                            UrlLauncher(
                                context,
                                requestExchange:true,
                                roomId: roomId.toString(),
                                rid: clientid.toString(),
                                receivedroomID: sourceLanguage.toString(),
                                'https://matrix.to/#/${clientid.toString()}')
                                .openMatrixToUrl();

                          }
                          else{
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Select Class with whom you to merge classes")));
                          }

                        },
                        child: Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary ==
                                  Colors.white
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                  .colorScheme
                                  .onPrimary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary == Colors.white
                                      ?Theme.of(context)
                                      .primaryColorLight
                                      :Theme.of(context)
                                      .colorScheme
                                      .onPrimary)),
                          child: Center(
                            child: Text(
                              "Request",
                              style: TextStyle().copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary ==
                                      Colors.white
                                      ? Theme.of(context)
                                      .primaryColorLight
                                      : Theme.of(context)

                                      .textTheme
                                      .bodyText1!
                                      .color,
                                  fontSize: 14),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            ),
          ),
        ));
  }
}


