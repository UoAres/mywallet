import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:decimal/decimal.dart';

class NetWorkUtils {
  static Map<String, Dio> dios = {};

  static Dio getDio() {
    BaseOptions options = new BaseOptions(
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 5000),
    );

    Dio dio = Dio(options);
    dio.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate =
          (httpClient) => httpClient..maxConnectionsPerHost = 100;
    return dio;
  }

  static Future<Map> sendFutureGetRequest<T>(String url, [int? iRety]) async {
    Map data = {};
    Dio dio = getDio();
    try {
      String msg = "";
      print("GET: ${url}");
      var response = await dio.get(url);

      if (response.statusCode == HttpStatus.ok) {
        var jsonData;
        if (response.data is String) {
          jsonData = jsonDecode(response.data);
        } else {
          jsonData = response.data;
        }
        data = jsonData;
      } else {
        String errMsg = "网络访问错误：" + response.statusCode.toString();
        msg = (errMsg);
      }
      if (msg != "") Future.error(msg);
      return Future.value(data);
    } on DioError catch (e) {
      print(e);
      return Future.error(e);
    } on Error catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  static Future<Map> sendFuturePostRequest<T>(String url,
      [Map<String, dynamic>? argv, int? iRety]) async {
    Dio dio = getDio();
    try {
      final resp = await dio.post(url, data: argv);

      if (resp.data != null) {
        if (resp.data is String) {
          resp.data = json.decode(resp.data);
        }
        return Future.value(resp.data);
      } else {
        return Future.error("返回数据不符合规范：" + resp.toString());
      }
    } on DioError catch (e) {
      print(e);
      return Future.error(e);
    } on Error catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}

class RelativeDateFormat {
  static final num ONE_MINUTE = 60000;
  static final num ONE_HOUR = 3600000;
  static final num ONE_DAY = 86400000;
  static final num ONE_WEEK = 604800000;
  static final num ONE_YEAR = 31536000000;

  static final String ONE_SECOND_AGO = "seconds ago";
  static final String ONE_MINUTE_AGO = "minutes ago";
  static final String ONE_HOUR_AGO = "hours ago";
  static final String ONE_DAY_AGO = "days ago";
  static final String ONE_MONTH_AGO = "months ago";
  static final String ONE_YEAR_AGO = "years ago";
  static final String ONE_YEAR_CENTURY_AGO = "centurys ago ";

  static final String ONE_SECOND_AFTER = "seconds after";
  static final String ONE_MINUTE_AFTER = "minutes after";
  static final String ONE_HOUR_AFTER = "hours after";
  static final String ONE_DAY_AFTER = "days after";
  static final String ONE_MONTH_AFTER = "months after";
  static final String ONE_YEAR_AFTER = "years after";
  static final String ONE_YEAR_CENTURY_AFTER = "centurys after";

  static String format(DateTime date) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (delta < -100 * ONE_YEAR) {
      num centurys = toCenturys(delta);
      return (centurys = centurys).abs().toInt().toString() +
          " " +
          ONE_YEAR_CENTURY_AFTER;
    }
    if (delta < -1 * ONE_YEAR) {
      num years = toYears(delta);
      return (years = years).abs().toInt().toString() + " " + ONE_YEAR_AFTER;
    }
    if (delta < -30 * ONE_DAY) {
      num months = toMonths(delta);
      return (months = months).abs().toInt().toString() + " " + ONE_MONTH_AFTER;
    }
    if (delta < -48 * ONE_HOUR) {
      num days = toDays(delta);
      return (days = days).abs().toInt().toString() + " " + ONE_DAY_AFTER;
    }
    if (delta < -24 * ONE_HOUR) {
      return "Tomorrow";
    }
    if (delta < -60 * ONE_MINUTE) {
      num hours = toHours(delta);
      return (hours = hours).abs().toInt().toString() + " " + ONE_HOUR_AFTER;
    }
    if (delta < -1 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes = minutes).abs().toInt().toString() +
          " " +
          ONE_MINUTE_AFTER;
    }
    if (delta < 0) {
      num seconds = toSeconds(delta);
      return (seconds = seconds).abs().toInt().toString() +
          " " +
          ONE_SECOND_AFTER;
    }

    if (delta < 1 * ONE_MINUTE) {
      num seconds = toSeconds(delta);
      return (seconds = seconds).abs().toInt().toString() +
          " " +
          ONE_SECOND_AGO;
    }
    if (delta < 60 * ONE_MINUTE) {
      num minutes = toMinutes(delta);
      return (minutes = minutes).abs().toInt().toString() +
          " " +
          ONE_MINUTE_AGO;
    }
    if (delta < 24 * ONE_HOUR) {
      num hours = toHours(delta);
      return (hours = hours).abs().toInt().toString() + " " + ONE_HOUR_AGO;
    }
    if (delta < 48 * ONE_HOUR) {
      return "Yesterday";
    }
    if (delta < 30 * ONE_DAY) {
      num days = toDays(delta);
      return (days = days).abs().toInt().toString() + " " + ONE_DAY_AGO;
    }
    if (delta < 12 * 4 * ONE_WEEK) {
      num months = toMonths(delta);
      return (months = months).abs().toInt().toString() + " " + ONE_MONTH_AGO;
    }
    if (delta < 100 * ONE_YEAR) {
      num years = toYears(delta);
      return (years = years).abs().toInt().toString() + " " + ONE_YEAR_AGO;
    } else
    // if (delta >= 100 * ONE_YEAR)
    {
      num centurys = toCenturys(delta);
      return (centurys = centurys).abs().toInt().toString() +
          " " +
          ONE_YEAR_CENTURY_AGO;
    }
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 12;
  }

  static num toCenturys(num date) {
    return toYears(date) / 100;
  }
}

class DataUtils {
  static String formatNum(double num, int postion) {
    try {
      if (num != null && num is double) {
        if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
            postion) {
          //小数点后有几位小数
          return (num.toStringAsFixed(postion)
              .substring(0, num.toString().lastIndexOf(".") + postion + 1)
              .toString());
        } else {
          return (num.toString()
              .substring(0, num.toString().lastIndexOf(".") + postion + 1)
              .toString());
        }
      } else {
        throw Exception("格式化数字时，必须传入数字${num}");
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  static String formatNumInTrade(String num) {
    try {
      if (num != null && num != "" && num != "null" && num != "未知") {
        double n = double.parse(num);
        bool isNegative = false;
        if (n < 0) isNegative = true;
        n = n.abs();
        String s = num;
        if (n < 10) {
          //数字太小会有精度问题
          s = Decimal.parse(num).toStringAsFixed(8);
        } else {
          if (n > 100000000) {
            s = formatNum(n, 0);
          } else if (n >= 1000000) {
            s = formatNum(n, 0);
          } else if (n >= 1000000) {
            s = formatNum(n, 1);
          } else if (n >= 100000) {
            s = formatNum(n, 2);
          } else if (n >= 10000) {
            s = formatNum(n, 3);
          } else if (n >= 1000) {
            s = formatNum(n, 4);
          } else if (n >= 100) {
            s = formatNum(n, 5);
          } else if (n >= 10) {
            s = formatNum(n, 6);
          } else if (n >= 1) {
            s = formatNum(n, 7);
          } else {
            s = formatNum(n, 8);
          }
          if (isNegative) s = "-" + s;
        }
        return s;
      } else {
        return num;
      }
    } catch (e) {
      print(e);
      return num;
    }
  }

  static String formatNumInNum(String num) {
    try {
      if (num != null && num != "" && num != "null" && num != "未知") {
        double n = double.parse(num);
        bool isNegative = false;
        if (n < 0) isNegative = true;
        n = n.abs();
        String s = num;
        if (n >= 100000000000000000000000000.0) {
          s = formatNum(n / 1000000000000000000000000.0, 2) + "Y";
        } else if (n >= 10000000000000000000000000.0) {
          s = formatNum(n / 1000000000000000000000000.0, 3) + "Y";
        } else if (n >= 1000000000000000000000000.0) {
          s = formatNum(n / 1000000000000000000000000.0, 4) + "Y";
        } else if (n >= 100000000000000000000000.0) {
          s = formatNum(n / 1000000000000000000000.0, 2) + "Z";
        } else if (n >= 10000000000000000000000.0) {
          s = formatNum(n / 1000000000000000000000.0, 3) + "Z";
        } else if (n >= 1000000000000000000000.0) {
          s = formatNum(n / 1000000000000000000000.0, 4) + "Z";
        } else if (n >= 100000000000000000000.0) {
          s = formatNum(n / 1000000000000000000, 2) + "E";
        } else if (n >= 10000000000000000000.0) {
          s = formatNum(n / 1000000000000000000, 3) + "E";
        } else if (n >= 1000000000000000000.0) {
          s = formatNum(n / 1000000000000000000, 4) + "E";
        } else if (n >= 100000000000000000) {
          s = formatNum(n / 1000000000000000, 2) + "P";
        } else if (n >= 10000000000000000) {
          s = formatNum(n / 1000000000000000, 3) + "P";
        } else if (n >= 1000000000000000) {
          s = formatNum(n / 1000000000000000, 4) + "P";
        } else if (n >= 100000000000000) {
          s = formatNum(n / 1000000000000, 2) + "T";
        } else if (n >= 10000000000000) {
          s = formatNum(n / 1000000000000, 3) + "T";
        } else if (n >= 1000000000000) {
          s = formatNum(n / 1000000000000, 4) + "T";
        } else if (n >= 100000000000) {
          s = formatNum(n / 1000000000, 2) + "G";
        } else if (n >= 10000000000) {
          s = formatNum(n / 1000000000, 3) + "G";
        } else if (n >= 1000000000) {
          s = formatNum(n / 1000000000, 4) + "G";
        } else if (n >= 100000000) {
          s = formatNum(n / 1000000, 2) + "M";
        } else if (n >= 10000000) {
          s = formatNum(n / 1000000, 3) + "M";
        } else if (n >= 1000000) {
          s = formatNum(n / 1000000, 4) + "M";
        } else if (n >= 100000) {
          s = formatNum(n / 1000, 2) + "K";
        } else if (n >= 10000) {
          s = formatNum(n / 1000, 3) + "K";
        } else if (n >= 1000) {
          s = formatNum(n / 1000, 4) + "K";
        } else if (n >= 100) {
          s = formatNum(n, 3);
        } else if (n >= 10) {
          s = formatNum(n, 4);
        } else if (n >= 1) {
          s = formatNum(n, 5);
        } else {
          s = formatNum(n, 5);
        }
        if (isNegative) s = "-" + s;
        return s;
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return num;
    }
  }
}
