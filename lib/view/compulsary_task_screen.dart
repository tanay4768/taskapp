import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:outtaskapp/view/temprory_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../provider/compulsorytask_provider.dart';


class CompulsoryTaskScreen extends StatefulWidget {
  const CompulsoryTaskScreen({super.key});
  @override
  State<CompulsoryTaskScreen> createState() => _CompulsoryTaskScreenState();
}

class _CompulsoryTaskScreenState extends State<CompulsoryTaskScreen> {
  
  final TextEditingController _controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    getData();
  }
    
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white24, // Status bar color
      statusBarIconBrightness: Brightness.light, // Light icons for status bar
    ));
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.task_alt, color: Colors.black,), label: "Today's Task"),
        BottomNavigationBarItem(icon: Icon(Icons.local_fire_department_rounded, color: Colors.blue,),
        label: "Daily Task")
      ],
        onTap: (index){
          if(index==0){
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const TaskScreen(),
              ),
            );
          }
          else if(index==1){
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const CompulsoryTaskScreen(),
              ),
            );
          }
        },

      ),
      appBar: AppBar(
        title: const Text('Daily Tasks'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Consumer<CompulsoryTaskProvider>(
                builder: (context, taskProvider, child) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: GridView.count(
                      padding: const EdgeInsets.all(10),
                      childAspectRatio: 0.8/1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 20.0,
                      children: List.generate(
                        taskProvider.tasks.length,
                            (index){
                          final task = taskProvider.tasks[index];
                          bool isDone = task.isComplete;
                          return TapRegion(
                            onTapOutside: (PointerDownEvent){
                              task.showDeleteOpt=false;
                              taskProvider.notifyProvider();
                            },
                            child: GestureDetector(
                              onLongPress: (){
                                task.showDeleteOpt=true;
                                taskProvider.notifyProvider();
                              },

                             child: Stack(
                                children: [
                                  Opacity(
                                    opacity: task.showDeleteOpt ? 0.4:1 ,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color:task.isComplete ? Colors.blueAccent:const Color(
                                          0x9AACE7DF),borderRadius: BorderRadius.circular(20)),
                                      
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(value:isDone, onChanged: (value)async{
                                                final docref = db.collection("username");
                                                task.isComplete = !task.isComplete;
                                                await docref.doc(task.time.toString()).update({"done": task.isComplete});

                                                taskProvider.notifyProvider();
                                              }),
                                              const SizedBox(width: 10,),
                                              Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: task.imagePath != null ? Image.file(File(task.imagePath!), errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                              return Image.asset("images/img.png");
                                            },) : Image.asset("images/img.png"),
                                          ),
                                          const SizedBox(height: 10,),
                                          if(isDone)Text(" 🔥  ${task.streak+1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          if(!isDone) Text("😴 ${task.streak+1}❔", style: const TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(task.showDeleteOpt)Positioned(
                                    child: Center(
                                      child: Container(
                                        constraints: const BoxConstraints.expand(),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red.withOpacity(0.5),),
                                        alignment: Alignment.center,
                                        child: IconButton(onPressed: (){
                                          taskProvider.removeTask(index);
                                        }, icon: const Icon(Icons.delete, size: 100, color: Colors.red,)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ),
                          );},
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left:20 , right: 20, ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(labelText: 'Add a new task'),
                    ),
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          await  _pickImage(context);
                          _controller.clear();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: const  Icon(Icons.add),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final provider = Provider.of<CompulsoryTaskProvider>(context, listen: false);
    //always try to use provider before any await to avoid any future error
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
     provider.addTask(_controller.text, image.path);
      _controller.clear();
    }
  }
  
  void getData()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final docref = db.collection("username");
    final diff = BigInt.parse(DateTime.timestamp().millisecondsSinceEpoch.toString() )- BigInt.parse(prefs.get("today").toString());
    if(diff >=BigInt.from(86400000) && diff<BigInt.from(172800000)){
      prefs.setString("today", DateTime.timestamp().millisecondsSinceEpoch.toString());
      await docref.get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            if (docSnapshot.id != "youtube") {
              if(docSnapshot['done']){
                docref.doc(docSnapshot.id).update({
                  'done' : false,
                  'streak': docSnapshot['dayCount'],
                  'dayCount': docSnapshot['dayCount']+1,
                });
              }
              else{
                docref.doc(docSnapshot.id).update({
                  'done' : false,
                  'streak': 0,
                  'dayCount': 1,
                });
              }

            }
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    final val= Provider.of<CompulsoryTaskProvider>(context, listen: false);
    val.removeAll();
    await docref.get().then(
          (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            if (docSnapshot.id != "youtube") {
              val.addTaskList(docSnapshot['title'], docSnapshot['image'],
                  docSnapshot['time'].toString(), docSnapshot['streak'], docSnapshot['done']);
            }
          }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

}


