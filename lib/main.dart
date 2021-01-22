import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'jobDetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Active Job index of the listing that is displaying right now
  int activeIndex = -1;
  List<JobDetails> _searchResult = [];
  List<JobDetails> _jobDetails = [];
  TextEditingController _searchText = TextEditingController(text: "");

  //List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  // Get json result and convert it to model. Then add
  Future<Null> getJobDetails(String queryStr) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/json/data.json');
    final responseJson = jsonDecode(data);

    setState(() {
      //_searchResult = [];
      _jobDetails = [];

      if (queryStr != null) {
        // Get list of jobs matching the condition

        for (Map job in responseJson) {
          //_jobDetails.add(JobDetails.fromJson(job));
          if (JobDetails.fromJson(job)
                  .title
                  .toString()
                  .toLowerCase()
                  .contains(queryStr.toLowerCase()) ||
              JobDetails.fromJson(job)
                  .companyName
                  .toString()
                  .toLowerCase()
                  .contains(queryStr.toLowerCase()) ||
              JobDetails.fromJson(job)
                  .location
                  .toString()
                  .toLowerCase()
                  .contains(queryStr.toLowerCase()) ||
              JobDetails.fromJson(job)
                  .description
                  .toString()
                  .toLowerCase()
                  .contains(queryStr.toLowerCase()) ||
              JobDetails.fromJson(job)
                  .via
                  .toString()
                  .toLowerCase()
                  .contains(queryStr.toLowerCase())) {
            _jobDetails.add(JobDetails.fromJson(job));
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //getJobDetails('');
  }

  _search(String queryStr) async {
    setState(() {
      _searching = true;
    });

    getJobDetails(queryStr);

    setState(() {
      _searching = false;
    });
  }

  void _setActivePodcast(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Web Test"),
      ),
      body: Form(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text("Opportunity Search"),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      height: 60.0,
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _searchText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 80.0,
                      padding: const EdgeInsets.all(16.0),
                      child: FlatButton(
                        color: Colors.white,
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(6)),
                        onPressed: () {
                          _search(_searchText.text);
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(children: <Widget>[
                Container(
                    width: 400,
                    height: MediaQuery.of(context).size.height - 200,
                    padding: EdgeInsets.all(8),
                    //decoration: BoxDecoration(color: Colors.green),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          //                   <--- left side
                          color: Colors.black,
                          width: 1.0,
                        ),
                        top: BorderSide(
                          //                    <--- top side
                          color: Colors.black,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Expanded(
                      child: _searching == true
                          ? Center(
                              child: Text("Searching, please wait..."),
                            )
                          : _jobDetails.length == 0
                              ? Center(
                                  child: Text("No results found."),
                                )
                              : SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: Column(
                                    children: <Widget>[
                                      ListView.builder(
                                        //primary: false,
                                        shrinkWrap: true,
                                        itemCount: _jobDetails.length,
                                        itemBuilder:
                                            (BuildContext ctx, int index) {
                                          return Card(
                                            elevation: 5.0,
                                            //                           <-- Card
                                            child: GestureDetector(
                                              onTap: () {
                                                _setActivePodcast(index);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 15.0),
                                                          child: CircleAvatar(
                                                            child:
                                                                Image.network(
                                                              'https://via.placeholder.com/60x60.png?text=LOGO' +
                                                                  (index + 1)
                                                                      .toString(),
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _jobDetails[index]
                                                                  .title,
                                                              style:
                                                                  new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(_jobDetails[
                                                                    index]
                                                                .companyName),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(_jobDetails[
                                                                    index]
                                                                .location),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  '5 Aug',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width - 430,
                    height: MediaQuery.of(context).size.height - 200,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Expanded(
                        child: Row(children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, top: 25.0),
                                        child: activeIndex < 0
                                            ? Container()
                                            : Image.network(
                                                'https://via.placeholder.com/100x100.png?text=LOGO',
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit.fill),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  activeIndex < 0
                                                      ? Container()
                                                      : Text(
                                                          _jobDetails[
                                                                  activeIndex]
                                                              .companyName
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: new TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  activeIndex < 0
                                                      ? Container()
                                                      : Text(
                                                          _jobDetails[
                                                                  activeIndex]
                                                              .location
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              activeIndex < 0
                                  ? Container()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              activeIndex < 0
                                  ? Container()
                                  : const Divider(
                                      color: Colors.black,
                                      height: 1,
                                      thickness: 2,
                                      indent: 0,
                                      endIndent: 0,
                                    ),
                              activeIndex < 0
                                  ? Container()
                                  : SizedBox(
                                      height: 15.0,
                                    ),
                              activeIndex < 0
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Text(_jobDetails[activeIndex]
                                          .description
                                          .toString()),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ]))),
              ]),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
