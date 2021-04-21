import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:union_player_app/ui/my_app_bar.dart';

const LOG_TAG = "UPA -> ";
late Logger logger = Logger();

class FeedbackScreen extends StatefulWidget {
  bool _isPlaying;

  FeedbackScreen({required bool isPlaying}):_isPlaying = isPlaying;

  @override
  State<StatefulWidget> createState(){
    return FeedbackScreenState(isPlaying: _isPlaying);
  }
}

class FeedbackScreenState extends State {
  final _formKey = GlobalKey<FormState>();
  IconData _appBarIcon = Icons.play_circle_outline;
  bool _isPlaying = false;

  FeedbackScreenState({required bool isPlaying}):_isPlaying = isPlaying;

  void _onButtonAppBarTapped(){
    _isPlaying = !_isPlaying;
    setState(() {
      if(_isPlaying) _appBarIcon = Icons.pause_circle_outline;
      else _appBarIcon = Icons.play_circle_outline;
    });
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: MyAppBar(_onButtonAppBarTapped, _appBarIcon),
          body: SingleChildScrollView(padding: EdgeInsets.all(10.0), child:
          new Form(
              key: _formKey,
              child: new Column(children:
              <Widget>[
                new Text('Ваше имя:', style: TextStyle(fontSize: 20.0),),
                new TextFormField(validator: (value){
                  if (value!.isEmpty) return 'Пожалуйста, введите свое имя';
                }),

                new SizedBox(height: 20.0),

                new Text('Контактный E-mail:', style: TextStyle(fontSize: 20.0),),
                new TextFormField(validator: (value){
                  if (value!.isEmpty) return 'Пожалуйста, введите свой Email';
                  String p = "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
                  RegExp regExp = new RegExp(p);
                  if (regExp.hasMatch(value)) return null;
                  return 'Неверно введен E-mail';
                }),

                new SizedBox(height: 20.0),

                new Text('Контактный телефон:', style: TextStyle(fontSize: 20.0),),
                new TextFormField(validator: (value){
                  if (value!.isEmpty) return 'Пожалуйста, введите свой номер телефона';
                  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = new RegExp(pattern);
                  if (regExp.hasMatch(value)) return null;
                  return 'Неверно введен номер';
                }),

                new SizedBox(height: 20.0),

                new Text('Текст обращения:', style: TextStyle(fontSize: 20.0),),
                new TextFormField(validator: (value){
                  if (value!.isEmpty) return 'Напишите нам';
                  if (value.length <= 400) return null;
                  return 'Длина сообщения не должна превышать 400 символов';
                }),

                new SizedBox(height: 20.0),

                new RaisedButton(onPressed: () {
                  late String text;
                  late Color color;
                  if (_formKey.currentState!.validate()) {
                    text = "Форма успешно заполнена";
                    color = Colors.green;
                  }
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(text), backgroundColor: color,));
                },
                  child: Text('Отправить'), color: Colors.blue, textColor: Colors.white,
                ),
              ],
              )
          )
          ),
        ));
  }
}