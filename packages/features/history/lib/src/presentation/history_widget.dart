import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:history/src/presentation/cubit/history_cubit.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final _cubit = GetIt.I.get<HistoryCubit>();

  @override
  void initState() {
    _cubit.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DesignText('Recently Shortened URLs', type: DesignTextType.h3),
        const SizedBox(height: 16.0),
        BlocProvider(
          create: (context) => _cubit,
          child: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoading) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return DesignListItem(
                        loading: true,
                        title: 'Loading...',
                        subtitle: '',
                      );
                    },
                  ),
                );
              } else if (state is HistoryLoaded && state.urls.isEmpty) {
                return DesignEmpty(
                  title: 'No URLs shortened yet',
                  description: 'Start by entering a URL above to shorten it.',
                  icon: Icons.link_off,
                );
              } else if (state is HistoryLoaded) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.urls.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return DesignListItem(
                        title: state.urls[index].originalUrl,
                        subtitle: 'https://short.url/$index',
                        buttonIcon: Icons.copy,
                        buttonOnPressed: () {},
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
