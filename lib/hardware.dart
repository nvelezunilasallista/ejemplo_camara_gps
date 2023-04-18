import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class Hardware extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _Hardware();
  }
}

class _Hardware extends State<Hardware>{

  final ImagePicker _picker = ImagePicker();

  DecorationImage imagen = DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
  );

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Ejemplo Camra y GPS")),
      body: Container(
        width:MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: (){
                      obtenerImagen(ImageSource.camera);
                    },
                    child: Text("Cámara")),
                VerticalDivider(),
                ElevatedButton(
                    onPressed: (){
                      obtenerImagen(ImageSource.gallery);
                    },
                    child: Text("Galeria"))
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.height*0.5,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: imagen
              ),
            ),
            TextField(
              controller: latitude,
              decoration: InputDecoration(
                  helperText: "Latitud",
                  helperStyle: TextStyle(fontSize: 14.0)
              ),
            ),
            TextField(
              controller: longitude,
              decoration: InputDecoration(
                  helperText: "Longitud",
                  helperStyle: TextStyle(fontSize: 14.0)
              ),
            )
          ],
        ),
      )
    );

  }

  void obtenerImagen(ImageSource source) async{
    XFile? image = await _picker.pickImage(source: source);

    if(image != null){
      File imagenLocal = File(image.path);
      bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();

      if(servicioHabilitado){
        LocationPermission permisos = await Geolocator.checkPermission();

        permisos = await Geolocator.requestPermission();

        if(permisos == LocationPermission.always ||
            permisos == LocationPermission.whileInUse){
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation
          );
          longitude.text = position.longitude.toString();
          latitude.text = position.latitude.toString();
        }
      }

      setState(() {
        this.imagen =
            DecorationImage(
              image: FileImage(imagenLocal),
              fit: BoxFit.cover);
      });
    }


  }
}