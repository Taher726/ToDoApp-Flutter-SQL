import 'package:flutter/material.dart';
import 'package:todoapp_sql/data/sqldb.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  SqlDb sqlDb = SqlDb();
  bool isLoading =true;
  List tasks = [];

  Future readData() async{
    List<Map> response = await sqlDb.readData("SELECT * FROM 'notes'");
    tasks.addAll(response);
    isLoading = false;
    if(this.mounted){
      setState(() {

      });
    }
  }

  int completedTasks(){
    int s=0;
    for(int i=0; i<tasks.length;i++){
      if(tasks[i]["is_completed"]==1){
        s++;
      }
    }
    return s;
  }

  /*int incompletedTasks(){
    int s=0;
    for(int i=0; i<tasks.length;i++){
      if(tasks[i]["is_completed"]==0){
        s++;
      }
    }
    return s;
  }*/

  void checkBoxChanged(bool? value, int index) async{
    int response=0;
    int taskId = tasks[index]["id"];
    if(tasks[index]["is_completed"] == 0){
      response = await sqlDb.updateData("UPDATE notes SET is_completed = 1 WHERE id = ${taskId}");
    }
    else if(tasks[index]["is_completed"] == 1){
      response = await sqlDb.updateData("UPDATE notes SET is_completed = 0 WHERE id = ${taskId}");
    }
    if(response>0){
      setState(() {
        var taskCopy = Map.from(tasks[index]);
        taskCopy["is_completed"] = taskCopy["is_completed"] == 0 ? 1 : 0;
        tasks[index] = taskCopy;
      });
    }
  }

  @override
  void initState() {
    readData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEFF5),
      body: SafeArea(
        child: isLoading == true ? Center(child: CircularProgressIndicator(),) : Padding(
          padding: EdgeInsets.symmetric(horizontal: 32,),
          child: ListView(
            children: [
              SizedBox(height: 60,),
              Text(
                "My Tasks",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "${completedTasks()} of ${tasks.length}",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 17
                ),
              ),
              SizedBox(
                height: 15,
              ),
              tasks.length == 0?
              Center(
                child: Text(
                  "Click Add Icon To Add New Tasks",
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDA4040),
                  ),
                ),
              ) :
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, i){
                  return Card(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                "${tasks[i]["name"]}",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  decoration: tasks[i]["is_completed"] == 1 ? TextDecoration.lineThrough : TextDecoration.none
                                ),
                              ),
                              subtitle: Text("${tasks[i]["task_date"]} - ${tasks[i]["priority"]}"),
                              trailing: Checkbox(
                                onChanged: (value) => checkBoxChanged(value, i),
                                value: tasks[i]["is_completed"] == 1 ? true : false,
                                activeColor: Color(0xFFDA4040),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: IconButton(
                            onPressed: () async {
                              int response = await sqlDb.deleteData("DELETE FROM notes WHERE id = ${tasks[i]['id']}");
                              if (response > 0) {
                                tasks.removeWhere((element) => element["id"] == tasks[i]["id"]);
                                setState(() {
                                });
                              }
                            },
                            icon: Icon(Icons.close, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addtask");
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFDA4040),
      ),
    );
  }
}
