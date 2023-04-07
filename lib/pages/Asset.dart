import 'package:flutter/material.dart';

import '../common/Util.dart';

class AssetPage extends StatefulWidget {
  AssetPage({Key? key}) : super(key: key);
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  String myAddress = "bc1q9yn6zdkjjlh0z5y6sqpdvwq7pwkeh5r0ka28ad";
  Map myAccountInfo = {};
  @override
  void initState() {
    super.initState();
    getMyAccountInfo(myAddress);
  }

  double final_balance = 0;
  double total_received = 0;
  double total_sent = 0;
  List trsList = [];
  getMyAccountInfo(String address) async {
    try {
      String url = "https://blockchain.info/multiaddr?active=${address}";
      final Map resp = await NetWorkUtils.sendFutureGetRequest(url);
      if (resp["addresses"] != null) {
        final_balance = resp["addresses"][0]["final_balance"] / 100000000;
        total_received = resp["addresses"][0]["total_received"] / 100000000;
        total_sent = resp["addresses"][0]["total_sent"] / 100000000;

        trsList = resp["txs"];

        myAccountInfo = resp;
        setState(() {});
      } else {
        print("Can not get address ${address} account information");
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _getRunRowHead() {
    return Material(
        color: Colors.white,
        elevation: 1,
        child: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 9,
                  child: Column(children: [
                    Text(" ",
                        style: TextStyle(color: Colors.grey, fontSize: 10))
                  ])),
              Expanded(
                  flex: 30,
                  child: Column(children: [
                    Text("Fee",
                        style: TextStyle(color: Colors.grey, fontSize: 10))
                  ])),
              Expanded(
                  flex: 30,
                  child: Column(children: [
                    Text("Amount",
                        style: TextStyle(color: Colors.grey, fontSize: 10))
                  ])),
              Expanded(
                  flex: 20,
                  child: Column(children: [
                    Text("Time",
                        style: TextStyle(color: Colors.grey, fontSize: 10))
                  ])),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    double contentHeight = MediaQuery.of(context).size.height -
        220 -
        200; //You need to subtract 120 in window mode, otherwise the bottom will be left empty
    if (contentHeight < 60) contentHeight = 60;
    return Scaffold(
      appBar: AppBar(
        title: Text("BitCoin"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            //color: Color.fromARGB(255, 237, 235, 235),
            decoration: new BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20.0)],
              color: Colors.blue,
              // borderRadius: new BorderRadius.circular((20.0)),
            ),
            //color: Colors.blue,
            height: 220,
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    " ",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      "${DataUtils.formatNumInNum(final_balance.toString())}",
                                      style: TextStyle(fontSize: 26)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("BTC",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black54))
                                ]),
                            radius: 70,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(myAddress,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                  "Receivd: ${DataUtils.formatNumInNum(total_received.toString())}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                              Text(
                                  "Send: ${DataUtils.formatNumInNum(total_sent.toString())}", //
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white))
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      )
                    ],
                  ),
                ),
              ],
            )),
        Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: contentHeight, // 30 * iAccountCount + 50,
              color: Colors.white,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                _getRunRowHead(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      getMyAccountInfo(myAddress);
                      return Future.value(null);
                    },
                    child: ListView.builder(
                      itemCount: trsList.length,
                      itemBuilder: (_, index) =>
                          TransactionItem(data: trsList[index], i: index),
                    ),
                  ),
                ),
              ])),
        ])),
      ]),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final int i;
  final Map data;
  TransactionItem({Key? key, required this.data, required this.i})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 9,
                  child: Text((i + 1).toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black26))),
              Expanded(
                flex: 30,
                child: Text(
                  "${DataUtils.formatNumInNum((data["fee"] / 100000000).toString())}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Expanded(
                flex: 30,
                child: Column(
                  children: [
                    Text(
                      "${DataUtils.formatNumInNum((data["result"] / 100000000).toString())}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              data["result"] > 0 ? Colors.blue : Colors.purple),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 20,
                child: Text(
                  "${RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(data["time"] * 1000))}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
