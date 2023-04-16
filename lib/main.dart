import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Interest Calculator",
    home: ICalc(),
    theme: ThemeData(
      brightness: Brightness.dark,
      //Change or remove it and see the appbar color
      primarySwatch: Colors.red,
    ),
  ));
}

class ICalc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ICalcFun();
  }
}

class _ICalcFun extends State<ICalc> {

  var formKey = GlobalKey<FormState>();

  var _currencies = ['BDT', 'INR', 'USD'];
  final _minimumPadding = 5.0;
  var _currentSelected = 'BDT';

  TextEditingController principleController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .titleLarge;
    return Scaffold(
      //resizeToAvoidBottomInset: false, //Use this when used Column instead of ListView
        appBar: AppBar(
          title: Text("Interest Calculator"),
        ),
        body: Form(
          key: formKey,
          child: Padding(
              padding: EdgeInsets.all(_minimumPadding * 6),
              child: ListView(
              children: <Widget>[
              getImageAssets(),
          Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding, bottom: _minimumPadding),
              child: TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter principle amount';
                  }
                },
                style: textStyle,
                controller: principleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 18.0
                  ),
                    labelStyle: textStyle,
                    labelText: "Principle",
                    hintText: "e.g. 1000",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: _minimumPadding, bottom: _minimumPadding),
              child: TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter rate of interest';
                  }
                },
                style: textStyle,
                controller: roiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 18.0
                  ),
                    labelStyle: textStyle,
                    labelText: "Rate of interest",
                    hintText: "e.g. 5",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding,
                          bottom: _minimumPadding,
                          right: _minimumPadding),
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter term in years';
                          }
                        },
                        style: textStyle,
                        controller: termController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 18.0
                          ),
                            labelStyle: textStyle,
                            labelText: "Term",
                            hintText: "Time in years",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ))),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding,
                          bottom: _minimumPadding,
                          left: _minimumPadding),
                      child: DropdownButton<String>(
                        items: _currencies.map((String dropDownItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownItem,
                            child: Text(
                              dropDownItem,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (newItem) {
                          setState(() {
                            this._currentSelected = newItem!;
                          });
                        },
                        value: _currentSelected,
                      ))),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _minimumPadding, bottom: _minimumPadding),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding,
                            bottom: _minimumPadding,
                            right: _minimumPadding * 2),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            elevation: 6,
                          ),
                          onPressed: () {
                            setState(() {
                              if(formKey.currentState!.validate()){
                                this.displayResult = _calculatetotalReturns();
                              }
                            });
                          },
                          child: Text(
                            "Calculate",
                            textScaleFactor: 1.7,
                            style: textStyle,
                          ),
                        ))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding,
                            bottom: _minimumPadding,
                            right: _minimumPadding * 2),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                            elevation: 6,
                          ),
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                          child: Text(
                            "Reset",
                            textScaleFactor: 1.7,
                            style: textStyle,
                          ),
                        )))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: _minimumPadding, bottom: _minimumPadding),
            child: Center(
              child: Text(
                this.displayResult,
                style:
                TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
          ],
        )),)
    );
  }

  Widget getImageAssets() {
    AssetImage assetImage = AssetImage('images/bank.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  String _calculatetotalReturns() {
    double principle = double.parse(principleController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalPayable = principle + (principle * roi * term) / 100;
    String result =
        'After $term years, your investment will be worth $totalPayable $_currentSelected';
    return result;
  }

  void _reset() {
    principleController.text = '';
    roiController.text = '';
    termController.text = '';
    _currentSelected = _currencies[0];
  }
}
