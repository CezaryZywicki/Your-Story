import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:diary_app/model/Diary.dart';
import 'package:diary_app/screens/main_page.dart';
import 'package:diary_app/util/utils.dart';
import 'package:diary_app/widgets/delete_entry_dialog.dart';
import 'package:diary_app/widgets/inner_list_card.dart';
import 'package:diary_app/widgets/write_diary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required List<Diary> listOfDiaries,
    required this.selectedDate,
  })  : _listOfDiaries = listOfDiaries,
        super(key: key);
  final DateTime selectedDate;
  final List<Diary> _listOfDiaries;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('notes');
    final _user = Provider.of<User?>(context);

    var _diaryList = this._listOfDiaries;
    var filteredDiaryList = _diaryList.where((element) {
      return (element.userId == _user!.uid);
    }).toList();

    return Column(
      children: [
        Expanded(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: (filteredDiaryList.isNotEmpty)
              ? ListView.builder(
                  itemCount: filteredDiaryList.length,
                  itemBuilder: (context, index) {
                    Diary diary = filteredDiaryList[index];

                    return DelayedDisplay(
                      delay: Duration(milliseconds: 1),
                      fadeIn: true,
                      child: Card(
                        elevation: 4.0,
                        child: InnerListCard(
                            selectedDate: this.selectedDate,
                            diary: diary,
                            bookCollectionReference: bookCollectionReference),
                        // Column(
                        //   children: [
                        //     ListTile(
                        //       title: Padding(
                        //         padding: const EdgeInsets.all(10.0),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               '•${formatDateFromTimestamp(diary.entryTime)}',
                        //               style: TextStyle(
                        //                   color: Colors.blueGrey,
                        //                   fontSize: 19,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             TextButton.icon(
                        //                 icon: Icon(Icons.delete_forever,
                        //                     color: Colors.grey),
                        //                 onPressed: () {
                        //                   showDialog(
                        //                     context: context,
                        //                     builder: (context) {
                        //                       return DeleteEntryDialog(
                        //                           bookCollectionReference:
                        //                               bookCollectionReference,
                        //                           diary: diary);
                        //                     },
                        //                   );
                        //                 },
                        //                 label: Text(''))
                        //           ],
                        //         ),
                        //       ),
                        //       subtitle: Column(
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Text(
                        //                   '${formatDateFromTimestampHour(diary.entryTime)}',
                        //                   style: TextStyle(color: Colors.orange)),
                        //               TextButton.icon(
                        //                   onPressed: () {},
                        //                   icon: Icon(Icons.more_horiz),
                        //                   label: Text('')),
                        //             ],
                        //           ),
                        //           Image.network((diary.photoUrls == null)
                        //               ? 'https://picsum.photos/400/200'
                        //               : diary.photoUrls.toString()),
                        //           Row(
                        //             children: [
                        //               Flexible(
                        //                 child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Padding(
                        //                         padding: const EdgeInsets.all(8.0),
                        //                         child: Text(diary.title!,
                        //                             style: TextStyle(
                        //                                 fontWeight:
                        //                                     FontWeight.bold)),
                        //                       ),
                        //                       Padding(
                        //                         padding: const EdgeInsets.all(8.0),
                        //                         child: Text(
                        //                           diary.entry!,
                        //                         ),
                        //                       ),
                        //                     ]),
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //       onTap: () {
                        //         showDialog(
                        //           context: context,
                        //           builder: (context) {
                        //             return AlertDialog(
                        //               title: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 children: [
                        //                   Container(
                        //                     width:
                        //                         MediaQuery.of(context).size.width *
                        //                             0.3,
                        //                     child: Row(
                        //                       children: [
                        //                         Text(
                        //                           '${formatDateFromTimestamp(diary.entryTime)}',
                        //                           style: TextStyle(
                        //                               color: Colors.blueGrey,
                        //                               fontSize: 19,
                        //                               fontWeight: FontWeight.bold),
                        //                         ),
                        //                         Spacer(),
                        //                         IconButton(
                        //                             icon: Icon(Icons.edit),
                        //                             onPressed: () {
                        //                               Navigator.of(context).pop();
                        //                               showDialog(
                        //                                 context: context,
                        //                                 builder: (context) {
                        //                                   return Container();
                        //                                   // return UpdateEntryDialog()
                        //                                 },
                        //                               );
                        //                             }),
                        //                         IconButton(
                        //                             icon: Icon(Icons
                        //                                 .delete_forever_rounded),
                        //                             onPressed: () {
                        //                               Navigator.of(context).pop();
                        //                               showDialog(
                        //                                 context: context,
                        //                                 builder: (context) {
                        //                                   return DeleteEntryDialog(
                        //                                       bookCollectionReference:
                        //                                           bookCollectionReference,
                        //                                       diary: diary);
                        //                                 },
                        //                               );
                        //                             }),
                        //                       ],
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //               content: ListTile(
                        //                 subtitle: Column(
                        //                   children: [
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.spaceBetween,
                        //                       children: [
                        //                         Text(
                        //                           '•${formatDateFromTimestampHour(diary.entryTime)}',
                        //                           style: TextStyle(
                        //                               color: Colors.orange),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     SizedBox(
                        //                         width: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width *
                        //                             0.6,
                        //                         height: MediaQuery.of(context)
                        //                                 .size
                        //                                 .height *
                        //                             0.5,
                        //                         child: Image.network((diary
                        //                                     .photoUrls ==
                        //                                 null)
                        //                             ? 'https://picsum.photos/400/200'
                        //                             : diary.photoUrls.toString())),
                        //                     Row(
                        //                       children: [
                        //                         Flexible(
                        //                             child: Column(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Padding(
                        //                               padding:
                        //                                   const EdgeInsets.all(8.0),
                        //                               child: Text(
                        //                                 '${diary.title}',
                        //                                 style: TextStyle(
                        //                                     fontWeight:
                        //                                         FontWeight.bold),
                        //                               ),
                        //                             ),
                        //                             Padding(
                        //                               padding:
                        //                                   const EdgeInsets.all(8.0),
                        //                               child: Text(
                        //                                 '${diary.entry}',
                        //                                 style: TextStyle(),
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ))
                        //                       ],
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //               actions: [
                        //                 TextButton(
                        //                   onPressed: () =>
                        //                       Navigator.of(context).pop(),
                        //                   child: Text('Cancel'),
                        //                 )
                        //               ],
                        //             );
                        //           },
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    // Diary diary = _listOfDiaries[index];

                    return Card(
                      elevation: 4.0,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'You dont have any memory on ${formatDate(selectedDate)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  TextButton.icon(
                                    icon: Icon(Icons.lock_outline_sharp),
                                    label: Text('Click to add new note'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WriteDiaryDialog(
                                              selectedDate: selectedDate,
                                              titleTextController:
                                                  _titleTextController,
                                              descriptionTextController:
                                                  _descriptionTextController);
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     ListTile(
                      //       title: Padding(
                      //         padding: const EdgeInsets.all(10.0),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               '•${formatDateFromTimestamp(diary.entryTime)}',
                      //               style: TextStyle(
                      //                   color: Colors.blueGrey,
                      //                   fontSize: 19,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //             TextButton.icon(
                      //                 icon: Icon(Icons.delete_forever,
                      //                     color: Colors.grey),
                      //                 onPressed: () {
                      //                   showDialog(
                      //                     context: context,
                      //                     builder: (context) {
                      //                       return DeleteEntryDialog(
                      //                           bookCollectionReference:
                      //                               bookCollectionReference,
                      //                           diary: diary);
                      //                     },
                      //                   );
                      //                 },
                      //                 label: Text(''))
                      //           ],
                      //         ),
                      //       ),
                      //       subtitle: Column(
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                   '${formatDateFromTimestampHour(diary.entryTime)}',
                      //                   style: TextStyle(color: Colors.orange)),
                      //               TextButton.icon(
                      //                   onPressed: () {},
                      //                   icon: Icon(Icons.more_horiz),
                      //                   label: Text('')),
                      //             ],
                      //           ),
                      //           Image.network((diary.photoUrls == null)
                      //               ? 'https://picsum.photos/400/200'
                      //               : diary.photoUrls.toString()),
                      //           Row(
                      //             children: [
                      //               Flexible(
                      //                 child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       Padding(
                      //                         padding: const EdgeInsets.all(8.0),
                      //                         child: Text(diary.title!,
                      //                             style: TextStyle(
                      //                                 fontWeight:
                      //                                     FontWeight.bold)),
                      //                       ),
                      //                       Padding(
                      //                         padding: const EdgeInsets.all(8.0),
                      //                         child: Text(
                      //                           diary.entry!,
                      //                         ),
                      //                       ),
                      //                     ]),
                      //               ),
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //       onTap: () {
                      //         showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return AlertDialog(
                      //               title: Column(
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   Container(
                      //                     width:
                      //                         MediaQuery.of(context).size.width *
                      //                             0.3,
                      //                     child: Row(
                      //                       children: [
                      //                         Text(
                      //                           '${formatDateFromTimestamp(diary.entryTime)}',
                      //                           style: TextStyle(
                      //                               color: Colors.blueGrey,
                      //                               fontSize: 19,
                      //                               fontWeight: FontWeight.bold),
                      //                         ),
                      //                         Spacer(),
                      //                         IconButton(
                      //                             icon: Icon(Icons.edit),
                      //                             onPressed: () {
                      //                               Navigator.of(context).pop();
                      //                               showDialog(
                      //                                 context: context,
                      //                                 builder: (context) {
                      //                                   return Container();
                      //                                   // return UpdateEntryDialog()
                      //                                 },
                      //                               );
                      //                             }),
                      //                         IconButton(
                      //                             icon: Icon(Icons
                      //                                 .delete_forever_rounded),
                      //                             onPressed: () {
                      //                               Navigator.of(context).pop();
                      //                               showDialog(
                      //                                 context: context,
                      //                                 builder: (context) {
                      //                                   return DeleteEntryDialog(
                      //                                       bookCollectionReference:
                      //                                           bookCollectionReference,
                      //                                       diary: diary);
                      //                                 },
                      //                               );
                      //                             }),
                      //                       ],
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //               content: ListTile(
                      //                 subtitle: Column(
                      //                   children: [
                      //                     Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Text(
                      //                           '•${formatDateFromTimestampHour(diary.entryTime)}',
                      //                           style: TextStyle(
                      //                               color: Colors.orange),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     SizedBox(
                      //                         width: MediaQuery.of(context)
                      //                                 .size
                      //                                 .width *
                      //                             0.6,
                      //                         height: MediaQuery.of(context)
                      //                                 .size
                      //                                 .height *
                      //                             0.5,
                      //                         child: Image.network((diary
                      //                                     .photoUrls ==
                      //                                 null)
                      //                             ? 'https://picsum.photos/400/200'
                      //                             : diary.photoUrls.toString())),
                      //                     Row(
                      //                       children: [
                      //                         Flexible(
                      //                             child: Column(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(8.0),
                      //                               child: Text(
                      //                                 '${diary.title}',
                      //                                 style: TextStyle(
                      //                                     fontWeight:
                      //                                         FontWeight.bold),
                      //                               ),
                      //                             ),
                      //                             Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(8.0),
                      //                               child: Text(
                      //                                 '${diary.entry}',
                      //                                 style: TextStyle(),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ))
                      //                       ],
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //               actions: [
                      //                 TextButton(
                      //                   onPressed: () =>
                      //                       Navigator.of(context).pop(),
                      //                   child: Text('Cancel'),
                      //                 )
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //     ),
                      //   ],
                      // ),
                    );
                  },
                ),
        ))
      ],
    );
  }
}

/*
StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              }
              var filteredList = snapshot.data!.docs.map((diary) {
                return Diary.fromDocument(diary);
              }).where((item) {
                return (item.userId == FirebaseAuth.instance.currentUser!.uid);
              }).toList();
              return Column(
                children: [
                  Expanded(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        Diary diary = filteredList[index];

                        return Card(
                          elevation: 4.0,
                          child: InnerListCard(
                              selectedDate: this.selectedDate,
                              diary: diary,
                              bookCollectionReference: bookCollectionReference),
                          // Column(
                          //   children: [
                          //     ListTile(
                          //       title: Padding(
                          //         padding: const EdgeInsets.all(10.0),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               '•${formatDateFromTimestamp(diary.entryTime)}',
                          //               style: TextStyle(
                          //                   color: Colors.blueGrey,
                          //                   fontSize: 19,
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //             TextButton.icon(
                          //                 icon: Icon(Icons.delete_forever,
                          //                     color: Colors.grey),
                          //                 onPressed: () {
                          //                   showDialog(
                          //                     context: context,
                          //                     builder: (context) {
                          //                       return DeleteEntryDialog(
                          //                           bookCollectionReference:
                          //                               bookCollectionReference,
                          //                           diary: diary);
                          //                     },
                          //                   );
                          //                 },
                          //                 label: Text(''))
                          //           ],
                          //         ),
                          //       ),
                          //       subtitle: Column(
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Text(
                          //                   '${formatDateFromTimestampHour(diary.entryTime)}',
                          //                   style: TextStyle(color: Colors.orange)),
                          //               TextButton.icon(
                          //                   onPressed: () {},
                          //                   icon: Icon(Icons.more_horiz),
                          //                   label: Text('')),
                          //             ],
                          //           ),
                          //           Image.network((diary.photoUrls == null)
                          //               ? 'https://picsum.photos/400/200'
                          //               : diary.photoUrls.toString()),
                          //           Row(
                          //             children: [
                          //               Flexible(
                          //                 child: Column(
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Padding(
                          //                         padding: const EdgeInsets.all(8.0),
                          //                         child: Text(diary.title!,
                          //                             style: TextStyle(
                          //                                 fontWeight:
                          //                                     FontWeight.bold)),
                          //                       ),
                          //                       Padding(
                          //                         padding: const EdgeInsets.all(8.0),
                          //                         child: Text(
                          //                           diary.entry!,
                          //                         ),
                          //                       ),
                          //                     ]),
                          //               ),
                          //             ],
                          //           )
                          //         ],
                          //       ),
                          //       onTap: () {
                          //         showDialog(
                          //           context: context,
                          //           builder: (context) {
                          //             return AlertDialog(
                          //               title: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.start,
                          //                 children: [
                          //                   Container(
                          //                     width:
                          //                         MediaQuery.of(context).size.width *
                          //                             0.3,
                          //                     child: Row(
                          //                       children: [
                          //                         Text(
                          //                           '${formatDateFromTimestamp(diary.entryTime)}',
                          //                           style: TextStyle(
                          //                               color: Colors.blueGrey,
                          //                               fontSize: 19,
                          //                               fontWeight: FontWeight.bold),
                          //                         ),
                          //                         Spacer(),
                          //                         IconButton(
                          //                             icon: Icon(Icons.edit),
                          //                             onPressed: () {
                          //                               Navigator.of(context).pop();
                          //                               showDialog(
                          //                                 context: context,
                          //                                 builder: (context) {
                          //                                   return Container();
                          //                                   // return UpdateEntryDialog()
                          //                                 },
                          //                               );
                          //                             }),
                          //                         IconButton(
                          //                             icon: Icon(Icons
                          //                                 .delete_forever_rounded),
                          //                             onPressed: () {
                          //                               Navigator.of(context).pop();
                          //                               showDialog(
                          //                                 context: context,
                          //                                 builder: (context) {
                          //                                   return DeleteEntryDialog(
                          //                                       bookCollectionReference:
                          //                                           bookCollectionReference,
                          //                                       diary: diary);
                          //                                 },
                          //                               );
                          //                             }),
                          //                       ],
                          //                     ),
                          //                   )
                          //                 ],
                          //               ),
                          //               content: ListTile(
                          //                 subtitle: Column(
                          //                   children: [
                          //                     Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.spaceBetween,
                          //                       children: [
                          //                         Text(
                          //                           '•${formatDateFromTimestampHour(diary.entryTime)}',
                          //                           style: TextStyle(
                          //                               color: Colors.orange),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     SizedBox(
                          //                         width: MediaQuery.of(context)
                          //                                 .size
                          //                                 .width *
                          //                             0.6,
                          //                         height: MediaQuery.of(context)
                          //                                 .size
                          //                                 .height *
                          //                             0.5,
                          //                         child: Image.network((diary
                          //                                     .photoUrls ==
                          //                                 null)
                          //                             ? 'https://picsum.photos/400/200'
                          //                             : diary.photoUrls.toString())),
                          //                     Row(
                          //                       children: [
                          //                         Flexible(
                          //                             child: Column(
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment.start,
                          //                           children: [
                          //                             Padding(
                          //                               padding:
                          //                                   const EdgeInsets.all(8.0),
                          //                               child: Text(
                          //                                 '${diary.title}',
                          //                                 style: TextStyle(
                          //                                     fontWeight:
                          //                                         FontWeight.bold),
                          //                               ),
                          //                             ),
                          //                             Padding(
                          //                               padding:
                          //                                   const EdgeInsets.all(8.0),
                          //                               child: Text(
                          //                                 '${diary.entry}',
                          //                                 style: TextStyle(),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ))
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //               actions: [
                          //                 TextButton(
                          //                   onPressed: () =>
                          //                       Navigator.of(context).pop(),
                          //                   child: Text('Cancel'),
                          //                 )
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
                        );
                      },
                    ),
                  ))
                ],
              );
            },
          )

          */