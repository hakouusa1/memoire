import 'package:flutter/material.dart';
import '../pages/seearchPage.dart';

class MyTextField extends StatefulWidget {
  final double hiegh;
  final Function()? ontap;
  final Color? fieldColor;
  final double widh;
  final double num;
  final Icon? iconSuffix;
  final TextInputType? textInputtt;
  final bool isPassword;
  final String hinttexttt;
  final controler;
  final Icon? iconnn;
  final bool? maybe;

  const MyTextField({
    Key? key,
    this.textInputtt,
    required this.isPassword,
    required this.hinttexttt,
    this.controler,
    this.iconnn,
    this.iconSuffix,
    required this.num,
    required this.widh,
    this.fieldColor,
    required this.hiegh,
    this.maybe,
    this.ontap,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.widh),
      child: SizedBox(
        height: widget.hiegh,
        child: TextField(
          onSubmitted: (value) {
            // Navigate to search page here
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage(title: value)),
            );
          },
          onTap: widget.ontap,
          readOnly: widget.maybe ?? false,
          controller: widget.controler,
          keyboardType: widget.textInputtt,
          obscureText: widget.isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: widget.iconnn,
            suffixIcon: widget.isPassword
                ? IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: _isPasswordVisible
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
            )
                : widget.iconSuffix,
            hintText: widget.hinttexttt,
            hintStyle: TextStyle(
              color: Colors.grey[600],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.num),
              borderSide: BorderSide(color: Color.fromARGB(255, 95, 94, 94)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.num),
              borderSide: BorderSide(
                color: Colors.grey.shade900,
              ),
            ),
            filled: true,
            fillColor: widget.fieldColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
