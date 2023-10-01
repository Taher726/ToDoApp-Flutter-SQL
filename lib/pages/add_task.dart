import 'package:flutter/material.dart';
import 'package:todoapp_sql/data/sqldb.dart';
import 'package:todoapp_sql/pages/home_page.dart';

class AddTask extends StatefulWidget {
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();

  SqlDb sqlDb = SqlDb();
  String? valueChoose;
  List priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Color(0xFFEEEFF5),
          appBar: AppBar(
            backgroundColor: Color(0xFFEEEFF5),
            elevation: 0,
            iconTheme: IconThemeData(
                color: Color(0xFFDA4040),
                size: 30
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(32, 20, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Task",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 30,),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: "Task Name",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[700] as Color,
                              )
                          ),
                        ),
                        cursorColor: Colors.grey[700],
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickdate = await showDatePicker(
                            builder: (context, child){
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFFDA4040),
                                    onPrimary: Colors.white,
                                    onSurface: Color(0xFFDA4040),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if(pickdate != null){
                            date.text = "${pickdate.year}-${pickdate.month.toString().padLeft(2, '0')}-${pickdate.day.toString().padLeft(2, '0')}";
                          }
                        },
                        controller: date,
                        decoration: InputDecoration(
                          labelText: "Task Date",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[700] as Color,
                              )
                          ),
                        ),
                        cursorColor: Colors.grey[700],
                      ),
                      SizedBox(height: 30,),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Select priority :",
                          labelStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[700] as Color,
                              )
                          ),
                        ),
                        value: valueChoose,
                        onChanged: (newvalue) {
                          setState(() {
                            valueChoose = newvalue.toString();
                          });
                        },
                        items: priorities.map((valueItem) {
                          return DropdownMenuItem(
                            child: Text(valueItem),
                            value: valueItem,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20,),
                      TextButton(
                        onPressed: () async{
                          int response = await sqlDb.insertData("INSERT INTO 'notes' ('name','task_date','priority') VALUES ('${name.text}','${date.text}','${valueChoose}')");
                          if(response>0){
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                          }
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFDA4040),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
