import 'package:btech/Home/pages/third.dart';
import 'package:btech/Home/widgets/float.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class First extends StatefulWidget {
  const First({Key? key}) : super(key: key);

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  final TextEditingController searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchDataFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('roles')
        .where('uid', isEqualTo: userId)
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
        final oms = item['oms'].toString().toLowerCase();
        final floor = item['floor'].toString().toLowerCase();
        final represent = item['represent'].toString().toLowerCase();
        final product = item['product'].toString().toLowerCase();

        return date.contains(searchText) ||
            oms.contains(searchText) ||
            floor.contains(searchText) ||
            represent.contains(searchText) ||
            product.contains(searchText);
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
              'بيانات الدور',
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
                label: Text('OMS'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['oms'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              DataColumn(
                label: Text('الدور'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['floor'].toString(),
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
                label: Text('المنتجات'),
                onSort: (columnIndex, ascending) {
                  _sort<String>(
                    (item) => item['product'].toString(),
                    columnIndex,
                    ascending,
                  );
                },
              ),
              // Add more DataColumn widgets as needed
            ],
            source: MyDataSource(filteredData), // Use the filtered data source
            rowsPerPage: 5, // Set the number of rows to display per page
          ),
        ],
      ),
      floatingActionButton: Fun(context, Third()),
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
        DataCell(Text(item['oms'].toString())),
        DataCell(Text(item['floor'].toString())),
        DataCell(Text(item['represent'].toString())),
        DataCell(Text(item['product'].toString())),
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
