import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';

loader(){
  return Center(child: CircularProgressIndicator(color: buttonColor));
}

Widget popUpOne(BuildContext context, String text, String type, VoidCallback onTap) {
  String heading = "Warning";
  Color textColor = const Color(0xFFFFA000);
  Icon icon = const Icon(Icons.warning,color: Color(0xFFFFA000));
  switch(type){
    case 'S':{
      heading = "Success";
      textColor = Colors.green;
      icon = const Icon(Icons.check,color: Colors.green);
      break;
    }
    case 'E':{
      heading = "Error";
      textColor = Colors.red;
      icon = const Icon(Icons.error,color: Colors.red);
      break;
    }
    default:{
      heading = "Warning";
      textColor = const Color(0xFFFFA000);
      icon = const Icon(Icons.warning,color: Color(0xFFFFA000));
      break;
    }
  }
  return Container(
    height: 200,
    width: 200,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start,children:[icon,Text(heading,style: GoogleFonts.inter(color: textColor, fontSize:18, fontWeight: FontWeight.bold, decoration: TextDecoration.none))]),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400, decoration: TextDecoration.none),maxLines: 3,overflow: TextOverflow.ellipsis,softWrap: true,),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: textColor,// Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none)),
          ),
        )
      ],
    ),
  );
}

Widget popUpTwo(BuildContext context, String text,String yesName, String noName, VoidCallback onYes, VoidCallback onNo) {
  return Container(
    height: 200,
    width: 220,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400, decoration: TextDecoration.none),maxLines: 3,overflow: TextOverflow.ellipsis,softWrap: true,),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            GestureDetector(
          onTap: onYes,
          child: Container(
            height: 40,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor,// Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(yesName, style: const TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none)),
          ),
        ),

        GestureDetector(
          onTap: onNo,
          child: Container(
            height: 40,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor,// Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(noName, style: const TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.none)),
          ),
        )
          ],
        ),
      ],
    ),
  );
}


void showCustomPopupOne(BuildContext context, String text, String type, VoidCallback onTap) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black54, // dim background
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: FadeTransition(
            opacity: animation,
            child: popUpOne(context,text,type,onTap),
          ),
        );
      },
    ),
  );
}

void showCustomPopupTwo(BuildContext context, String text, String yesName, String noName, VoidCallback onYes, VoidCallback onNo) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black54, // dim background
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: FadeTransition(
            opacity: animation,
            child: popUpTwo(context,text,yesName, noName,onYes,onNo),
          ),
        );
      },
    ),
  );
}

noData(String text){
  return Center(
    child: Text(text,style:GoogleFonts.caveat(color: textColor, fontSize:30, fontWeight:FontWeight.bold)),
  );
}
