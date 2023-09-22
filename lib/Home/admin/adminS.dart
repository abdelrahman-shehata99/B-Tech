import 'dart:convert';

import 'package:btech/Home/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminS extends StatefulWidget {
  const AdminS({Key? key}) : super(key: key);

  @override
  _AdminSState createState() => _AdminSState();
}

class _AdminSState extends State<AdminS> {
  final TextEditingController notifi = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchFromMission() async {
    final snapshot = await FirebaseFirestore.instance.collection('roles').get();
    return snapshot.docs.map((doc) {
      // Include the document ID in the data
      final data = doc.data();
      data['documentId'] = doc.id;

      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchFromRoles() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('missions').get();
    return snapshot.docs.map((doc) {
      // Include the document ID in the data
      final data = doc.data();
      data['documentId'] = doc.id;

      return data;
    }).toList();
  }

  sendNotificationNow({required String token}) async {
    var responseNotification;
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAzNhXhuY:APA91bHdpjWaAmiRRrf5dqicQqvJ-C0yvPjYL1LBPNLrGcdgU44lhsCD5xJjepg9EPvA-fRAu7heW9ZQW2aIZQ-xNQDR229u347Vn26mcea0P2NMK23VjeQHUfTjII_2VQElEfU8cfMy'
    };

    Map bodyNotification = {
      "body": " طلب جديد علي متجرك  ",
      "title": " عرض الطلب الان   "
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      //   "rideRequestId": docId
    };
    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    try {
      print('try send notification');
      responseNotification = http
          .post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat),
      )
          .then((value) {
        print('NOTIFICATION SENT ==$value');
      });
    } catch (e) {
      print("NOTIFICATION ERROR===$e");
    }
    return responseNotification;
  }



  Widget _buildStatusCell(String status, String collection, String? docId) {
    Color textColor = Colors.black; // Default text color
    if (status == 'Not Approved') {
      textColor = Colors.red; // Set text color to red for "Not Approved"
    } else if (status == 'Approved') {
      textColor = Colors.green; // Set text color to green for "Approved"
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: textColor),
      onPressed: () {
        setState(() async {
          await FirebaseFirestore.instance
              .collection(collection)
              .doc(docId)
              .update({
            'status': status == 'Approved' ? 'Not Approved' : 'Approved'
          }).then((_) {
            if (status == 'Approved') {
              notify(context, 'Status updated successfully.', 'Not Approved');
              sendNotificationNow(token: notifi.text);
            } else {
              notify(context, 'Status updated successfully.', 'Approved');
              sendNotificationNow(token: notifi.text);
            }
          }).catchError((error) {
            notifyE('Error updating status: $error');
          });
        });
      },
      child: Text(
        status,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> dataR = [];

  List<Map<String, dynamic>> filteredData1 = [];
  List<Map<String, dynamic>> filteredData2 = [];

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  final TextEditingController searchController1 = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  final TextEditingController idDoc = TextEditingController();
  @override
  void initState() {
    fetchFromMission().then((result) {
      setState(() {
        data = result;
        filteredData1 = data; // Initialize filteredData1 with all data
      });
    });
    fetchFromRoles().then((result) {
      setState(() {
        dataR = result;
        filteredData2 = dataR; // Initialize filteredData2 with all data
      });
    });
    super.initState();
  }

  void _sort<T>(
    Comparable<T> Function(Map<String, dynamic>) getField,
    int columnIndex,
    bool ascending,
  ) {
    data.sort((a, b) {
      if (!ascending) {
        final temp = a;
        a = b;
        b = temp;
      }
      final aValue = getField(a);
      final bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    dataR.sort((a, b) {
      if (!ascending) {
        final temp = a;
        a = b;
        b = temp;
      }
      final aValue = getField(a);
      final bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void filterData1(String searchText) {
    setState(() {
      filteredData1 = data.where((item) {
        final status = item['status'].toString().toLowerCase();
        final driverName = item['driverName'].toString().toLowerCase();
        final represent = item['represent'].toString().toLowerCase();
        final oms = item['oms'].toString().toLowerCase();
        final carId = item['carId'].toString().toLowerCase();
        final product = item['product'].toString().toLowerCase();
        final floor = item['floor'].toString().toLowerCase();
        final date = item['date'].toString().toLowerCase();

        return status.contains(searchText) ||
            driverName.contains(searchText) ||
            represent.contains(searchText) ||
            oms.contains(searchText) ||
            carId.contains(searchText) ||
            product.contains(searchText) ||
            floor.contains(searchText) ||
            date.contains(searchText);
      }).toList();
    });
  }

  void filterData2(String searchText) {
    setState(() {
      filteredData2 = dataR.where((item) {
        final status = item['status'].toString().toLowerCase();
        final driverName = item['driverName'].toString().toLowerCase();
        final represent = item['represent'].toString().toLowerCase();
        final destination = item['destination'].toString().toLowerCase();
        final late = item['late'].toString().toLowerCase();
        final paper = item['paper'].toString().toLowerCase();
        final date = item['date'].toString().toLowerCase();
        final branch = item['branch'].toString().toLowerCase();
        final permission = item['permission'].toString().toLowerCase();
        final productNumber = item['product number'].toString().toLowerCase();
        final round = item['round'].toString().toLowerCase();

        return status.contains(searchText) ||
            driverName.contains(searchText) ||
            represent.contains(searchText) ||
            destination.contains(searchText) ||
            late.contains(searchText) ||
            paper.contains(searchText) ||
            date.contains(searchText) ||
            branch.contains(searchText) ||
            permission.contains(searchText) ||
            productNumber.contains(searchText) ||
            round.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterData1(value.toLowerCase());
              },
              controller: searchController1,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                hintText: 'بيانات الدور',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: pageIn(
                'بيانات الدور',
                'الحالة',
                'status',
                'السائق',
                'driverName',
                'المناديب',
                'represent',
                'OMS',
                'oms',
                'السيارة',
                'carId',
                'المنتجات',
                'product',
                'الدور',
                'floor',
                'التاريخ',
                'date',
                '',
                '',
                '',
                '',
                '',
                '',
                MyDataSource(filteredData1, _buildStatusCell)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController2,
              onChanged: (value) {
                filterData2(value.toLowerCase());
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                hintText: 'بيانات الماموريات',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: pageIn(
                'بيانات الماوريات',
                'الحالة',
                'status',
                'السائق',
                'driverName',
                'المندوب',
                'represent',
                'الوجهة',
                'destination',
                'التاخير',
                'late',
                'الايصالات',
                'paper',
                'التاريخ',
                'date',
                'اسم الفرع',
                'branch',
                'رقم الاذن',
                'permission',
                'عدد البضاعة',
                'product number',
                'الجولة',
                'round',
                MyDataSourceR(filteredData2, _buildStatusCell)),
          ),
        ],
      ),
    );
  }

  pageIn(
      String head,
      String txt1,
      String txt11,
      String txt2,
      String txt22,
      String txt3,
      String txt33,
      String txt4,
      String txt44,
      String txt5,
      String txt55,
      String txt6,
      String txt66,
      String txt7,
      String txt77,
      String txt8,
      String txt88,
      String txt9,
      String txt99,
      String txtx,
      String txtxx,
      String txty,
      String txtyy,
      DataTableSource src) {
    return PaginatedDataTable(
      sortAscending: _sortAscending,
      sortColumnIndex: _sortColumnIndex,
      header: Text(
        head,
        textAlign: TextAlign.center,
      ),
      columns: [
        DataColumn(
          label: Text(txt1),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt11].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt2),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt22].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt3),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt33].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt4),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item2) => item2[txt44].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt5),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt55].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt6),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt66].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt7),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt77].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt8),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item2) => item2[txt88].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txt9),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txt99].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txtx),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txtxx].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
        DataColumn(
          label: Text(txty),
          onSort: (columnIndex, ascending) {
            _sort<String>(
              (item) => item[txtyy].toString(),
              columnIndex,
              ascending,
            );
          },
        ),
      ],
      source: src, // Use your data source here
      rowsPerPage: 5, // Set the number of rows to display per page
    );
  }
}

class MyDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;
  final Function(String, String, String?) _buildStatusCell;

  MyDataSource(this._data, this._buildStatusCell);

  @override
  DataRow getRow(int index) {
    final item2 = _data[index];
    return DataRow(
      cells: [
        DataCell(
          _buildStatusCell(item2['status'].toString(), 'roles',
              item2['documentId'].toString()),
        ),
        DataCell(Text(item2['driverName'].toString())),
        DataCell(Text(item2['represent'].toString())),
        DataCell(Text(item2['oms'].toString())),
        DataCell(Text(item2['carId'].toString())),
        DataCell(Text(item2['product'].toString())),
        DataCell(Text(item2['floor'].toString())),
        DataCell(Text(item2['date'].toString())),
        DataCell(Text(item2[''].toString())),
        DataCell(Text(item2[''].toString())),
        DataCell(Text(item2[''].toString())),
      ],
    );
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class MyDataSourceR extends DataTableSource {
  final List<Map<String, dynamic>> _dataR;
  final Function(String, String, String?) _buildStatusCell;

  MyDataSourceR(this._dataR, this._buildStatusCell);

  @override
  DataRow getRow(int index) {
    final item = _dataR[index];

    return DataRow(
      cells: [
        DataCell(
          _buildStatusCell(item['status'].toString(), 'missions',
              item['documentId'].toString()),
        ),
        DataCell(Text(item['driverName'].toString())),
        DataCell(Text(item['represent'].toString())),
        DataCell(Text(item['destination'].toString())),
        DataCell(Text(item['late'].toString())),
        DataCell(Text(item['paper'].toString())),
        DataCell(Text(item['date'].toString())),
        DataCell(Text(item['branch'].toString())),
        DataCell(Text(item['permission'].toString())),
        DataCell(Text(item['product number'].toString())),
        DataCell(Text(item['round'].toString())),
      ],
    );
  }

  @override
  int get rowCount => _dataR.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
