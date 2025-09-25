import 'package:create/src/presentation/cubit/create_cubit.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateWidget extends StatefulWidget {
  const CreateWidget({super.key});

  @override
  State<CreateWidget> createState() => _CreateWidgetState();
}

class _CreateWidgetState extends State<CreateWidget> {
  final _controller = TextEditingController();
  final _cubit = GetIt.I.get<CreateCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<CreateCubit, CreateState>(
        listener: (context, state) {
          if (state is CreateSuccess) {
            DesignToast.success(context, 'URL encurtada com sucesso!');
          } else if (state is CreateError) {
            DesignToast.error(
              context,
              state.message.isNotEmpty
                  ? state.message
                  : 'Ocorreu um erro ao encurtar a URL',
            );
          }
        },
        child: BlocBuilder<CreateCubit, CreateState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: DesignTextField(
                    urlController: _controller,
                    labelText: 'Enter URL',
                  ),
                ),
                const SizedBox(width: 8.0),
                DesignButton(
                  icon: Icons.send,
                  loading: state is CreateLoading,
                  onPressed: () {
                    _cubit.create(_controller.text);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
