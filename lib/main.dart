import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Main function
void main() {
  runApp(
      ///define material app widget
      MaterialApp(
    debugShowCheckedModeBanner: false,

    /// remove the debug mode
    title: 'Simple Interest Calculator App',
    home: SIFORM(),
    theme: ThemeData(
        brightness: Brightness.dark,

        /// it's light by default
        primaryColor: Colors.indigo,

        /// it's blue by default
        accentColor: Colors.indigoAccent

        /// color visible when screen is refresh by pulling screen down

        ),
  ));
}

// create a stateful widget
class SIFORM extends StatefulWidget {
  ///override the create method
  @override
  State<StatefulWidget> createState() {
    return _SIFORMState();
  }
}

/// Define a state with some properties
class _SIFORMState extends State<SIFORM> {
///  define some proprties to use
  var _forkKey = GlobalKey<FormState>();
  var _currencies = [
    'Kenya Shillings',
    'US Dollars',
    'Starling Pounds',
    'Other'
  ];
  var _currentItemSelected = "";

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  final double _minimumPadding = 5.0;

  TextEditingController principalController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  TextEditingController termController = TextEditingController();
  var displayResult = "";

///override the build method
  @override
  Widget build(BuildContext context) {
    /// define a texttStyle
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      /// define a scaffold with a appbar and body----as a container
      resizeToAvoidBottomPadding: false,

      /// avoid resizing beyond. It's true by default
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
        key: _forkKey,
        child: ListView(
          /// replace Column with listView to enable screen scrolling
          children: <Widget>[
            getImageAsset(),
            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  keyboardType: TextInputType.number,

                  ///change keyboard to only allow numbers
                  style: textStyle,

                  ///use textsytle define on the build function
                  controller: principalController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter principal amount';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Principal Amount',
                      hintText: 'Enter Principal Amount e.g 12000',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 18.0,
                      ),

                      /// use textStyle define on the build function
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                )),
            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  keyboardType: TextInputType.number,

                  ///change keyboard to only allow numbers
                  style: textStyle,
                  controller: interestRateController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Rate field is empty";
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Rate of Interest',
                      hintText: 'In percent(%)',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                )),

            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      ///keyboardType: TextInputType.number,
                      ///change keyboard to only allow numbers
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      style: textStyle,
                      controller: termController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Term field is empty';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Term',
                          hintText: 'Time in years',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    )),

                    //space between Term and dropdownmenu
                    Container(
                      width: _minimumPadding * 5,
                    ),

                    /// Code for dropdown button
                    /// take note of the drop down widget
                    Expanded(
                        child: DropdownButton<String>(
                      items: _currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: _currentItemSelected,

                      ///
                      /// @onChange--- automaticaly change the selected itiem
                      /// _onDropDownSelectedItem(newValueSelected)-- call the _onDropDownSelectedItem and pass the selected item
                      onChanged: (String newValueSelected) {
                        _onDropDownSelectedItem(newValueSelected);
                      },
                    )),
                  ],
                )),

            /// new row for the raised buttons
            Padding(
                padding: EdgeInsets.only(
                    top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text(
                          'Calculate',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_forkKey.currentState.validate()) {
                              this.displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                      ),
                    ),

                    /// some space between calculate and reset buttons
                    Container(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Reset',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            _resetContent();
                          });
                        },
                      ),
                    )
                  ],
                )),

            Padding(
              padding: EdgeInsets.all(
                _minimumPadding * 2,
              ),
              child: Text(displayResult),
            )
          ],
        ),
      ),
    );
  }

// create the asset image
  Widget getImageAsset() {
    //define the asset image
    AssetImage assetImage = AssetImage('images/money.png');
    //create an image out of this asset
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);

    //Wrap the image in a container and then return it
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  /// function to perform item selection
  void _onDropDownSelectedItem(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  ///
  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double term = double.parse(termController.text);
    double rate = double.parse(interestRateController.text);

    double totalAmountPayable = principal + (principal * term * rate) / 100;
    String result =
        "After $term years, your total investment  will be worth  $totalAmountPayable $_currentItemSelected";
    return result;
  }

  void _resetContent() {
    principalController.text = "";
    termController.text = "";
    interestRateController.text = "";
    displayResult = "";
    _currentItemSelected = _currencies[0];
  }
}
