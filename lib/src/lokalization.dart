import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extension.dart';

class Lokalization extends StatefulWidget {
  final String url;
  final String dir;
  final Widget child;
  final List<Locale> supported;
  final Locale def;
  final bool code;

  const Lokalization({
    Key key,
    this.child,
    this.url,
    this.dir,
    this.supported,
    this.def,
    this.code = false,
  }) : super(key: key);

  @override
  _LokalizationState createState() => _LokalizationState();
}

class _LokalizationState extends State<Lokalization> {
  Future<void> future;
  Timer timeout;

  @override
  void initState() {
    super.initState();

    // load translate
    future = Translate.load(
      url: widget.url,
      dir: widget.dir,
      supported: widget.supported,
      def: widget.def,
      code: widget.code,
    );

    timeout = Timer(Duration(seconds: 2), () {
      setState(() {
        timeout.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || timeout.isActive) {
          return Material(
            child: Container(),
          );
        } else {
          return widget.child;
        }
      },
    );
  }
}
