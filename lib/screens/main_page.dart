import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/model/Diary.dart';
import 'package:diary_app/model/user.dart';
import 'package:diary_app/services/service.dart';
import 'package:diary_app/widgets/create_profile.dart';
import 'package:diary_app/widgets/diary_list_view.dart';
import 'package:diary_app/widgets/write_diary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;
  DateTime selectedDate = DateTime.now();
  var userDiaryFilteredEntriesList;

  // List<Diary> _listOfDiaries = [];

  @override
  Widget build(BuildContext context) {
    final _titleTextController = TextEditingController();
    final _descriptionTextController = TextEditingController();
    var _listOfDiaries = Provider.of<List<Diary>>(context);
    var _user = Provider.of<User?>(context);
    var latestFilteredDiariesStream;
    var earliestFilteredDiariesStream;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        title: Row(
          children: [
            Text(
              'Your',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            Text(
              ' Story',
              style: TextStyle(fontSize: 39, color: Colors.orange.shade400),
            )
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Oldest', 'Newest'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  hint: (_dropDownText == null)
                      ? Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    if (value == 'Oldest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      latestFilteredDiariesStream =
                          DiaryService().getLatestDiaries(_user!.uid);
                      latestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    } else if (value == 'Newest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      earliestFilteredDiariesStream =
                          DiaryService().getEarliestDiaries(_user!.uid);

                      earliestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              // TODO: create profile
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final usersListStream = snapshot.data!.docs.map((docs) {
                    return MUser.fromDocument(docs);
                  }).where((muser) {
                    //print(muser.uid);
                    return (muser.uid ==
                        FirebaseAuth.instance.currentUser!.uid);
                  }).toList();

                  MUser curUser = usersListStream[0];

                  return CreateProfile(curUser: curUser);
                },
              ),
            ],
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                //color: Colors.orange,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        onSelectionChanged: (DateRangePickerSelection) {
                          setState(() {
                            selectedDate = DateRangePickerSelection.value;
                            _listOfDiaries.clear();
                            userDiaryFilteredEntriesList = DiaryService()
                                .getSameDateDiaries(
                                    Timestamp.fromDate(selectedDate).toDate(),
                                    FirebaseAuth.instance.currentUser!.uid);

                            userDiaryFilteredEntriesList.then((value) {
                              for (var item in value) {
                                setState(() {
                                  _listOfDiaries.add(item);
                                });
                              }
                            });
                          });

                          // print(DateRangePickerSelection.value.toString());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Card(
                        elevation: 4,
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.orangeAccent,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add new note',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WriteDiaryDialog(
                                    selectedDate: selectedDate,
                                    titleTextController: _titleTextController,
                                    descriptionTextController:
                                        _descriptionTextController);
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 10,
              child: DiaryListView(
                  listOfDiaries: _listOfDiaries, selectedDate: selectedDate)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return WriteDiaryDialog(
                    selectedDate: selectedDate,
                    titleTextController: _titleTextController,
                    descriptionTextController: _descriptionTextController);
              },
            );
          },
          tooltip: 'Add',
          child: Icon(
            Icons.add,
          )),
    );
  }
}
