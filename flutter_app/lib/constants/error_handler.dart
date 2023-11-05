import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:touchbase/constants/show_snackbar.dart';

dynamic httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required dynamic onSuccess,
  required dynamic onFailure
}) {
  switch (response.statusCode) {
    case 200:
      return onSuccess();
    case >= 400 && <= 599:
      return onFailure();
    default:
      showCustomSnackBar(context: context, message: response.body);
  }
}
