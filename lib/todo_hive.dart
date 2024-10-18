import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoHive extends StatefulWidget{

  @override
State<TodoHive> createState()=>_ToDoHiveState();
}

class _ToDoHiveState extends State<TodoHive>{
  late Box box;
  TextEditingController todocontroller=TextEditingController();
  List<String>todoItems=[];

  @override
  void initState(){
    super.initState();
    box=Hive.box('myBox');
    loadToDoItes();
      }

      loadToDoItes()async{
        List<String>?tasks=box.get('todoItems')?.cast<String>();

        if (tasks !=null){
          setState(() {
            todoItems=tasks;
          });
        }
      }

      saveToDoItems()async{
        await box.put('todoItems', todoItems);
      }
      
      void _addTodoItems(String task){
        if(task.isNotEmpty){
          setState(() {
            todoItems.add(task);
          });
          saveToDoItems();
          todocontroller.clear();
                  }
      }

      void _removeTodoItem(int index){
        setState(() {
          todoItems.removeAt(index);
        });
        saveToDoItems();
      }
@override  
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: Text("ToDo with Hive"),
    ),
    body: Column(
      children: [
        Row(
          children: [
          SizedBox(
            height: 60,
            width: 250,
            child: TextField(
              controller: todocontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
              ),
              ),
            ),
          ),
          IconButton(onPressed: (){
            _addTodoItems(todocontroller.text);
          }, 
          icon: Icon(Icons.add),
          ),
          ],
        ),
        Expanded(
          child:ListView.builder(
            itemCount:todoItems.length ,
            itemBuilder:(context,index){
              return ListTile(
                title: Text(todoItems[index]),
                trailing: GestureDetector(
                  onTap: () {
                    _removeTodoItem(index);
                  },
                  child: Icon(Icons.delete)),
              );
            }
            ),
            ),
          ],
    ),
  );
}  
}