import 'package:btech/Home/pages/fourth.dart';
import 'package:btech/Home/widgets/float.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Secound extends StatefulWidget {
  const Secound({Key? key}) : super(key: key);

  @override
  _SecoundState createState() => _SecoundState();
}

class _SecoundState extends State<Secound> {
  final TextEditingController searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('missions')
        .where('uid', isEqualTo: uid)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  List<Map<String, dynamic>> filteredData = [];
  List<Map<String, dynamic>> data = [];
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore().then((result) {
      setState(() {
        data = result;
        filteredData = data; // Initialize filteredData with all data
      });
    });
  }

  void filterData(String searchText) {
    setState(() {
      filteredData = data.where((item) {
        final date = item['date'].toString().toLowerCase();
        final destination = item['destination'].toString().toLowerCase();
        final represent = item['represent'].toString().toLowerCase();
        final paper = item['paper'].toString().toLowerCase();
        final late = item['late'].toString().toLowerCase();
        final total = item['total'].toString().toLowerCase();
        final branch = item['branch'].toString().toLowerCase();
        final permission = item['permission'].toString().toLowerCase();
        final productNumber = item['product number'].toString().toLowerCase();
        final round = item['round'].toString().toLowerCase();

        return date.contains(searchText) ||
            destination.contains(searchText) ||
            represent.contains(searchText) ||
            paper.contains(searchText) ||
            late.contains(searchText) ||
            total.contains(searchText) ||
            branch.contains(searchText) ||
            permission.contains(searchText) ||
            productNumber.contains(searchText) ||
            round.contains(searchText);
      }).toList();
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 30),
            child: Text(
              'بيانات الماموريات',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          PaginatedDataTable(
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            header: TextFormField(
              controller: searchController,
              onChanged: filterData,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            columns: [
              DataColumn(
                label: Text('التاريخ'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['date'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('الوجهة'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['destination'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('المندوب'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['represent'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('الايصالات'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['paper'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('التاخير'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['late'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('العداد'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['total'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('الفرع'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['branch'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('رقم الاذن'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['permission'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('عدد البضاعة'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['product number'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('رقم الجولة'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['round'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
            ],
            source: MyDataSource(filteredData), // Use the filtered data source
            // Use your data source here
            rowsPerPage: 5, // Set the number of rows to display per page
          ),
        ],
      ),
      floatingActionButton: Fun(context, Fourth()),
    );
  }
}

class MyDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  MyDataSource(this._data);

  @override
  DataRow getRow(int index) {
    final item = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(item['date'].toString())),
        DataCell(Text(item['destination'].toString())),
        DataCell(Text(item['represent'].toString())),
        DataCell(Text(item['paper'].toString())),
        DataCell(Text(item['late'].toString())),
        DataCell(Text(item['total'].toString())),
        DataCell(Text(item['branch'].toString())),
        DataCell(Text(item['permission'].toString())),
        DataCell(Text(item['product number'].toString())),
        DataCell(Text(item['round'].toString())),
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
