import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class ListController extends GetxController{
  List listItems = <dynamic> [].obs;
  List listShopings = <dynamic> [].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List and Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Shopping List and Expense Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var valueText;
  var codeDialog;
  final TextEditingController _textEditingController=TextEditingController();
  List items=[];
  final ListController listController=Get.put(ListController());



  void _addshoppingList(value){
    print(value);
    setState(() {
      items.add(value);
      print(items);
      listController.listShopings.add(value);
    });
    _textEditingController.clear();
  }

  void _editShoppingList(value,index){
     print("edit");
     setState(() {
       items[index]=value;
       listController.listShopings[index]=value;
     });


    _textEditingController.clear();
  }

  void _editAlertDialog (context,value,index){
    _textEditingController.text=value;
    _showDialog(context, value, index);

  }

  void _showDialog(BuildContext context,dialogTxt,index) async{

    return showDialog(context: context,
        builder:(context){
         return AlertDialog(
          title: Text("Input list name"),
           content: TextField(
             onChanged: (value){

               setState(() {
                 if(dialogTxt!=""){

                   codeDialog=value;
                 }
                 else {
                   valueText = value;
                 }
               });
             },
             controller: _textEditingController,
           ),
           actions: [
             new MaterialButton(
               child: const Text("CANCEL"),
                 onPressed: (){
                   setState(() {
                     Navigator.pop(context);
                   });
                 }
             ),
             new MaterialButton(
                 child: const Text("OK"),
                 onPressed: (){
                   setState(() {
                     if(dialogTxt!="" &&codeDialog!=null) {

                       _editShoppingList(codeDialog,index);
                     }
                     else if(dialogTxt==""){
                       _addshoppingList(valueText);
                     }



                     Navigator.pop(context);
                   });
                 }
             ),
           ],
         );
        }
    );
  }

  void _removeItem(index){
    var arr = [];
    arr =items;
    arr.removeAt(index);
    print(arr);
    setState(() {
      items=arr;
      listController.listShopings=arr;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:Color(0xffefefefff),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.white,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,style: TextStyle(color: Colors.black,fontSize: 16),),
        centerTitle: true,
      ),
      body:items.length==0?
      Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(



          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(

              'Press the + button to add a list',
              style:TextStyle(color:Colors.grey),
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ):
      ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return Card(
              color: Colors.white,
              child:ListTile(
                onTap:() {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>
                      AddItemsPage(data:items[index])
                  ));
                },
                title: Text(items[index]),
                subtitle: Text(listController.listItems.length==0?"No items":listController.listItems.join(",")),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon:Icon(Icons.edit_outlined),
                      onPressed: () {
                          _editAlertDialog(context,items[index],index);

                      }),
                    IconButton(
                        icon:Icon(Icons.delete_outline_outlined),
                        onPressed: () {
                          _removeItem(index);
                        }),
                    IconButton(
                        icon:Icon(Icons.unfold_more),
                        onPressed: () {  }),
                  ],
                ),
              )
          );
        },

      ),
     bottomNavigationBar: items.length>0?Container(
       height: 50,
       color: Colors.white,
       child: TextButton(

         onPressed: (){
         Navigator.push(context,MaterialPageRoute(builder: (context)=>
             ExpenseTrackerPage()
         ));

       }, child: Text("Track the Expense",style: TextStyle(color:Colors.black),),
       ),
     ):null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed:(){
          _showDialog(context,"",0);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add,color: Colors.white,size: 40,),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class AddItemsPage extends StatefulWidget {
  final String data;
  const AddItemsPage({super.key, required this.data});

  @override
  State<AddItemsPage> createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  TextEditingController _textFormEditingController = TextEditingController();
  var itemVal;
  final ListController listController=Get.put(ListController());
  List itemsList=[];
  var valueAmount="";
  TextEditingController _textEditController = TextEditingController();

  void _addListItemValue (value){
    setState(() {
      itemsList.add(value);
      listController.listItems.add(value);
    });
    print(listController.listItems);

    _textFormEditingController.clear();
  }

  void _editAmount(value,index){
    setState(() {
      itemsList[index]=value;
      listController.listItems[index]=value;
    });
  }

  void _showAmountDialog(BuildContext context,dialogTxt,index) async{

    return showDialog(context: context,
        builder:(context){
          return AlertDialog(
            title: Text("Input list name"),
            content: TextField(
              onChanged: (value){

                setState(() {

                  valueAmount = value;

                });
              },
              controller: _textEditController,
            ),
            actions: [
              new MaterialButton(
                  child: const Text("CANCEL"),
                  onPressed: (){
                    setState(() {
                      Navigator.pop(context);
                    });
                  }
              ),
              new MaterialButton(
                  child: const Text("OK"),
                  onPressed: (){
                    setState(() {


                      _editAmount(valueAmount,index);




                      Navigator.pop(context);
                    });
                  }
              ),
            ],
          );
        }
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xffefefefff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.data,style:TextStyle(color: Colors.black,fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                Share.share('https://gmail.com', subject: 'Share the shopping list items');
              },
              icon: Icon(Icons.share_outlined,color: Colors.black,)),
          IconButton(

              onPressed: (){
                if(itemsList.length>0){
                   setState(() {
                     itemsList.clear();
                     listController.listItems.clear();
                   });
                }
              }
              ,
              icon: Icon(Icons.delete_outline_outlined,color: itemsList.length>0?Colors.black:Colors.grey,)),

        ],
        leading: IconButton(onPressed: (){
          if(itemsList.length>1){

          }
        }, icon: Icon(Icons.circle_outlined,size: 30,color: itemsList.length>1?Colors.black:Colors.grey,)),
      ),
        body:itemsList.length==0? Center(
         child:Text("Add text and press the + button to add an item",
         style:TextStyle(color:Colors.grey))
        ):

        ListView.builder(
          padding: EdgeInsets.only(top:2),
          itemCount: itemsList.length,

          itemBuilder: (BuildContext context, int index) {
            return Container(

                color: Colors.white,
                child:ListTile(
                 shape: RoundedRectangleBorder(
                   side: BorderSide(color: Colors.black,width:1),
                   borderRadius: BorderRadius.circular(5),
                 ),
                  leading: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.circle_outlined)),
                  title: Text(itemsList[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon:Icon(Icons.edit_outlined),
                          onPressed: () {
                          _textEditController.text=itemsList[index];
                         _showAmountDialog(context,itemsList[index], index);
                          }),

                      IconButton(
                          icon:Icon(Icons.unfold_more),
                          onPressed: () {  }),
                    ],
                  ),
                ),

            );
          },
        ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child:  TextFormField(
          controller: _textFormEditingController,
          onChanged: (value){
            setState(() {
              itemVal=value;
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            hintText: "input the amount here",
            suffixIcon: IconButton(
                onPressed: (){
                  _addListItemValue(itemVal);
                },
                icon: Icon(Icons.add_circle_outline_outlined,color: Colors.black,))
          ),
        ),
      )

    );
  }
}



class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({super.key});

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  final ListController listController=Get.put(ListController());
  List itemsList=[];
  List itemsShoppingList=[];
  var totalVal=0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemsList=listController.listItems;
    itemsShoppingList=listController.listShopings;
    for(int i=0;i<itemsList.length;i++){
      totalVal+=int.parse(itemsList[i]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xffefefefff),
      appBar: AppBar(
        title: Text("Expense Tracker"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:ListView.builder(
        padding: EdgeInsets.only(top:2),
        itemCount: itemsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child:ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black,width:1),
                borderRadius: BorderRadius.circular(5),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(itemsShoppingList[index], style: TextStyle(color: Colors.black),),
                  Text("₹ "+itemsList[index], style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        child: Center(
          child: Text(
            style: TextStyle(color: Colors.black),
              "Total:  ₹" + totalVal.toString()
          ),
        ),

      ),
    );
  }
}



