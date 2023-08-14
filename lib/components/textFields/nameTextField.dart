import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/bloc/formBloc/form_bloc.dart';

class NameTextField extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return BlocBuilder<FormBloc, FormsValidateState>(
      builder:(context, state) {
        return(
          TextField(
            onChanged: (text) {
              context.read<FormBloc>().add(FormNameChangedEVent(text));
              },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),          
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),          
              ),
              hintText: 'Name',
              errorText: !state.isNameValid
                ? 'Заполните поле!'
                : null,
              fillColor: Colors.grey[200],
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: Icon(Icons.person)
            ),
          )
        );
      },
    );
  }
}