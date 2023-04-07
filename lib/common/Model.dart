class Block {
  String fromIp = "";
  int height = 0;

  int timestamp = 0;

  int blockSize = 0;

  String generatorPublicKey = "";

  String generatorAddress = "";

  String? generatorSecondPublicKey = "";

  String generatorEquity = "";

  int numberOfTransactions = 0;

  String payloadHash = "";

  int payloadLength = 0;

  String previousBlockSignature = "";

  String totalAmount = "";

  String totalFee = "";

  String reward = "";

  String magic = "";

  String blockParticipation = "";

  String signature = "";

  String? signSignature = "";

  Map remark = {};

  Map asset = {};
  int version = 0;
  Map statisticInfo = {};
  Map roundOfflineGeneratersHashMap = {};
  DateTime? dateCreated;

  String mrklroot = "";
  int nonce = 0;
  int weight = 0;
  List tx = [];
}
