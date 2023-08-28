import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/ui/utils/getx_snackbar.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/models/summary_count_model.dart';
import '../../../data/models/task_list_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class SummaryCountController extends GetxController {

  bool _getCountSummaryInProgress = false;
  get getCountSummaryInProgress => _getCountSummaryInProgress;


  SummaryCountModel _summaryCountModel = SummaryCountModel();
  SummaryCountModel get summaryCountModel => _summaryCountModel;

  Future<bool> getCountSummary() async {
    _getCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.summaryCount);

    _getCountSummaryInProgress = false;

    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
      return true;
    } else {
        update();
        showGetXSnackBar("Summary count","Get summary count failed", Colors.red[500], false);
        return false;
    }


  }



}




