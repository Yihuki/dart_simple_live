import 'package:flutter/material.dart';
import 'package:simple_live_app/app/controller/base_controller.dart';
import 'package:simple_live_app/widgets/status/app_empty_widget.dart';
import 'package:simple_live_app/widgets/status/app_error_widget.dart';
import 'package:simple_live_app/widgets/status/app_loadding_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

class PageGridView extends StatelessWidget {
  final BasePageController pageController;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets? padding;
  final bool refreshOnStart;
  final Function()? onLoginSuccess;
  final bool showPageLoadding;
  final double crossAxisSpacing, mainAxisSpacing;
  final int crossAxisCount;
  const PageGridView({
    required this.itemBuilder,
    required this.pageController,
    this.padding,
    this.refreshOnStart = false,
    this.showPageLoadding = false,
    this.onLoginSuccess,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    required this.crossAxisCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          EasyRefresh(
            header: MaterialHeader(
              processedDuration: const Duration(milliseconds: 400),
            ),
            footer: MaterialFooter(
              processedDuration: const Duration(milliseconds: 400),
            ),
            //scrollController: pageController.scrollController,
            controller: pageController.easyRefreshController,
            refreshOnStart: refreshOnStart,
            onLoad: pageController.loadData,
            onRefresh: pageController.refreshData,
            child: MasonryGridView.count(
              padding: padding,
              itemCount: pageController.list.length,
              itemBuilder: itemBuilder,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
          ),
          Offstage(
            offstage: !pageController.pageEmpty.value,
            child: AppEmptyWidget(
              onRefresh: () => pageController.refreshData(),
            ),
          ),
          Offstage(
            offstage: !(showPageLoadding && pageController.pageLoadding.value),
            child: const AppLoaddingWidget(),
          ),
          Offstage(
            offstage: !pageController.pageError.value,
            child: AppErrorWidget(
              errorMsg: pageController.errorMsg.value,
              onRefresh: () => pageController.refreshData(),
            ),
          ),
        ],
      ),
    );
  }
}
