import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:task_app/core/consts/colors/app_colors.dart';
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_bloc.dart';
import 'package:task_app/features/tasks/presentation/bloc/ads/ad_state.dart';

import '../bloc/tasks_cubit.dart';
import '../bloc/tasks_state.dart';
import 'edit_task_dialog.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/images/back.png')),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.instance.lightBlue,
                AppColors.instance.darkBlue,
                AppColors.instance.darkBlue,
              ])),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
              if (state.status == TaskStatus.loading) {
                return Center(
                    child: LiquidGlassLite(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(
                      color: AppColors.instance.grey,
                    ),
                  ),
                ));
              } else if (state.status == TaskStatus.success) {
                return state.data.isEmpty
                    ? Center(
                        child: Text(
                          'Nothing committed yet',
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await context.read<TasksCubit>().getTask();
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: LiquidGlassLite(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 10),
                                    child: ListTile(
                                      onTap: () => showEditTaskDialog(
                                        context,
                                        cubit: context.read<TasksCubit>(),
                                        task: state.data[index],
                                      ),
                                      trailing: Transform.scale(
                                          scale: 1.7,
                                          child: CupertinoCheckbox(
                                              value: state.data[index]
                                                  ['isDone'],
                                              onChanged: (v) {
                                                context
                                                    .read<TasksCubit>()
                                                    .updateTask(
                                                        state.data[index]
                                                            ['documentId'],
                                                        isDone: v ?? false);
                                              })),
                                      title: Text(
                                        state.data[index]['title'],
                                        style: GoogleFonts.montserratAlternates(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Row(
                                        spacing: 40,
                                        children: [
                                          Text(
                                            DateFormat(DateFormat
                                                    .MONTH_WEEKDAY_DAY)
                                                .format(DateTime.parse(
                                                    state.data[index]['date'])),
                                            style: GoogleFonts
                                                .montserratAlternates(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Container(
                                            height: 5,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.5),
                                              color: context
                                                  .read<TasksCubit>()
                                                  .checkStatus(state.data[index]
                                                      ['priority']),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorText ?? 'Something went wrong ! ‼️',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        LiquidGlassButton(
                          label: 'Retry',
                          onPressed: () {
                            context.read<TasksCubit>().getTask();
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            }),
            SizedBox(
              height: 20,
            ),
            Text(
              'Ads',
              style: GoogleFonts.montserratAlternates(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            BlocBuilder<AdBloc, AdState>(builder: (context, state) {
              if (state.status == AdStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.status == AdStatus.success) {
                return SizedBox(
                  height: 200,
                  child: PageView.builder(scrollDirection: Axis.horizontal,
                  itemCount: state.data?.length,
                    itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("${"http://localhost:1337"}${state.data?[index]['image']['formats']['large']['url']}" ?? ''),
                          fit: BoxFit.cover,
                        ),
                        color: AppColors.instance.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            state.data?[index]['title'] ?? '',
                            style: GoogleFonts.montserratAlternates(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              } else {
                return Center(
                    child:
                        Text(state.errorText ?? 'Something went wrong ! ‼️'));
              }
            })
          ],
        ),
      ),
    );
  }
}
