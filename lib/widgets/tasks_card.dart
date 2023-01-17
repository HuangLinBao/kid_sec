import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../core/constants/colors/kolors.dart';
import '../utils/logger.dart';

class TaskCard extends StatefulWidget {
  late TextStyle style;
  late String task;
  late String id;
  late void Function(String) deleteTask;
  TaskCard(String taskDescription, String taskId, void Function(String) delete, {Key? key }) : super(key: key) {
    task = taskDescription;
    id = taskId;
    deleteTask = delete;
    style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:Color(0xff222227));
  }




  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>  with SingleTickerProviderStateMixin{
  final log = logger(TaskCard);

 



  @override
  void initState(){

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Card(
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:  const BorderSide(
          color:Kolors.KBlack,
          width: 3,
        ),

      ),
      elevation: 0,

      color: Kolors.KWhite,
      margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),

      child:
      SizedBox(
        height: 75,
        child: InkWell(
          onTap: (){},
          child: Center(
            child: Stack(
              children: [
                ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),//or 15.0
                      child:  SizedBox(
                        height: 60.0,
                        width: 50.0,
                        child: SvgPicture.network(
                          'https://www.svgrepo.com/show/474665/check.svg',
                          height: 128,
                        ),
                      ),
                    ),
                    title: Text(
                      widget.task,
                      style: widget.style,
                    ),

                    trailing:FloatingActionButton(
                      heroTag: 'deleteFAB${widget.id}',
                      shape: const CircleBorder(
                        side: BorderSide(color: Kolors.KBlack, width: 2),
                      ),
                      elevation: 0,
                      onPressed: (){
                        widget.deleteTask(widget.id);
                      },
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.network(
                          'https://www.svgrepo.com/show/261229/garbage-bin-trash-can.svg',
                          height: 35,
                        ),

                    )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}