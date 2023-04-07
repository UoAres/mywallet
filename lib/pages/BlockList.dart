import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/Model.dart';
import '../common/Util.dart';

class Block_ListPage extends StatefulWidget {
  Block_ListPage({Key? key}) : super(key: key);
  _Block_ListPageState createState() => _Block_ListPageState();
}

class _Block_ListPageState extends State<Block_ListPage> {
  _Block_ListPageState();

  //List scrolling controller. Used to load the next page when the list scrolls to the bottom
  ScrollController _scrollController = new ScrollController();

  //Records if load all the records
  bool isFinishedLoadFully = false;

  //convert the data to block structure
  Block handleBlockFromResp(Map resp) {
    Block bl = Block();
    try {
      if (resp != null && resp["height"] != null) {
        bl.height = resp["height"]?.toInt() ?? 0;
        bl.timestamp = resp["time"]?.toInt() ?? 0;
        bl.dateCreated =
            DateTime.fromMillisecondsSinceEpoch(bl.timestamp * 1000);
        bl.blockSize = resp["size"]?.toInt() ?? 0;
        bl.signature = resp["hash"].toString();
        bl.numberOfTransactions = resp["n_tx"];
        bl.previousBlockSignature = resp["prev_block"].toString();
        bl.totalAmount = resp["bits"].toString();
        bl.totalFee = resp["fee"].toString();
        bl.version = resp["ver"];
        bl.statisticInfo = {};
        bl.mrklroot = resp["mrkl_root"].toString();
        bl.nonce = resp["nonce"];
        bl.weight = resp["weight"];
        bl.tx = resp["tx"];
      }
    } catch (e) {
      print(e);
    }
    return bl;
  }

  //search block from network by height
  Future<Block> _getBlockByHeight(int height) async {
    try {
      String url = "https://blockchain.info/rawblock/${height}";
      final Map resp = await NetWorkUtils.sendFutureGetRequest(url);
      if (resp != null) {
        Block bl = handleBlockFromResp(resp);
        return Future.value(bl);
      } else {
        return Future.error("未获取高度为${height}的区块");
      }
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  //set the max count of one page
  int maxPageCount = 20;

  //search block by page, automate conver the page number to start height and end height
  Future<List<Block>?> getBlockByPage(int ipage) async {
    int startHeight = (ipage - 1) * maxPageCount + 1;
    int endHeight = ipage * maxPageCount;

    List<Block> bls = [];
    List<Future> f = [];
    f = [];

    for (int i = startHeight; i <= endHeight; i++) {
      Future<Block> gtbs = _getBlockByHeight(i);
      f.add(gtbs);
    }
    await Future.wait(f).then((resultList) {
      resultList.forEach((bl) {
        Block b = bl as Block;
        bls.add(b);
      });
    }).onError((error, stackTrace) {
      print(error);
    }).catchError((error) {
      print(error);
    });
    return Future.value(bls);
  }

  @override
  void initState() {
    isLock = true;
    super.initState();
    _init();
  }

  _init() async {
    //automatically load the first page when application first loads
    await getNextPage();

    //Auto-load next page when sliding to the bottom
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 40) {
        if (!isLock && !isFinishedLoadFully) {
          isLock = true;
          getNextPage();
        }
      }
    });
  }

  bool isLock =
      false; //Paging lock. Since it will be triggered multiple times when scrolling to the bottom, so to avoid repeated execution of queries, it is marked as locked whenever a query is initiated here, and the locked state will not initiate queries anymore

  ValueNotifier<List> list = ValueNotifier([]); //records the block list

  int iPage = 1; //records the current page

  //search the next page
  getNextPage() async {
    Future<List<Block>?> gbba;

    gbba = getBlockByPage(iPage);

    if (mounted) {
      await gbba.then((bls) async {
        if (mounted) {
          //向下翻页时，页面数据是追加
          List oldList = list.value;
          bls?.forEach((bl) {
            oldList.add(bl);
          });
          list.value = oldList;

          //如果还没有到最后一页才翻页，到最后一页就提醒
          if (bls != null && bls.length == maxPageCount) {
            iPage++;
          } else {
            isFinishedLoadFully = true;
            print("this is the last page");
          }
          setState(() {});
          isLock = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Blocks"),
          backgroundColor: Colors.blue,
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(children: [
          Positioned(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 0.0),
              child: ValueListenableBuilder<List>(
                //Create dynamic refresh listener
                valueListenable: list,
                builder: (c, data, _) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int i) {
                      Block bl = data[i];

                      return GestureDetector(
                        onTap: (() {}),
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text(
                                    bl.height.toString(),
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.blue),
                                  ),
                                  Text(
                                    " " + bl.generatorAddress,
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.black87),
                                  ),
                                  Text(
                                    " - " +
                                        RelativeDateFormat.format(
                                                bl.dateCreated!)
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.black54),
                                  ),
                                ]),
                                Row(
                                  children: [
                                    Text(
                                      bl.numberOfTransactions.toString(),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.blue),
                                    ),
                                    Text(
                                      " Trs",
                                      style: TextStyle(
                                          fontSize: 8, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Weight: ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38)),
                                    Text(bl.weight.toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Fee: ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38)),
                                    Text(
                                        DataUtils.formatNumInNum(
                                            (double.parse(bl.totalFee) /
                                                    100000000)
                                                .toString()),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Size: ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38)),
                                    Text(
                                        DataUtils.formatNumInNum(
                                            bl.blockSize.toString()),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Nonce: ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38)),
                                    Text(bl.nonce.toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black38)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemCount: data.length,
                  );
                },
              ),
            ),
          ),
        ]));
  }
}
