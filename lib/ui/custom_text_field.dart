import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final bool clearable;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool expands;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;
  final bool passwordField;
  final ValueChanged<bool>? onObscureTextChanged;
  final bool enableSuggestions;
  final bool autocorrect;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  final TextStyle? style;

  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;


  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.controller,
    this.decoration,
    this.clearable = false,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.expands = false,
    this.inputFormatters,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.passwordField = false,
    this.onObscureTextChanged,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.style,
    this.onSaved,
    this.validator,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;

    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.initialValue ?? '';

    TextSelection? selection;
    _controller.addListener(() {
      if (_controller.selection.isValid) {
        selection = _controller.selection;
      } else if (selection != null) {
        _controller.selection = selection!;
      }
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomTextFormField oldWidget) {
    _obscureText = widget.obscureText;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // An Exception happened
    // A FocusNode was used after being disposed.
    // _focusNode.dispose();

    // An Exception happened
    // A TextEditingController was used after being disposed.
    // controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: _decoration(),
      onChanged: widget.onChanged,
      focusNode: _focusNode,
      expands: widget.expands,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      obscureText: _obscureText,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      style: widget.style?.copyWith(fontSize: widget.style?.fontSize ?? 24) ?? const TextStyle(fontSize: 24),
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }

  InputDecoration? _decoration() {
    return InputDecoration(
      suffixIcon: _suffixIcon(),
      // border: InputBorder.none,
    ).copyWith(
      icon: widget.decoration?.icon,
      iconColor: widget.decoration?.iconColor,
      label: widget.decoration?.label,
      labelText: widget.decoration?.labelText,
      labelStyle: widget.decoration?.labelStyle,
      floatingLabelStyle: widget.decoration?.floatingLabelStyle,
      helperText: widget.decoration?.helperText,
      helperStyle: widget.decoration?.helperStyle,
      helperMaxLines: widget.decoration?.helperMaxLines,
      hintText: widget.decoration?.hintText,
      hintStyle: widget.decoration?.hintStyle,
      hintTextDirection: widget.decoration?.hintTextDirection,
      hintMaxLines: widget.decoration?.hintMaxLines,
      errorText: widget.decoration?.errorText,
      errorStyle: widget.decoration?.errorStyle,
      errorMaxLines: widget.decoration?.errorMaxLines,
      floatingLabelBehavior: widget.decoration?.floatingLabelBehavior,
      floatingLabelAlignment: widget.decoration?.floatingLabelAlignment,
      isCollapsed: widget.decoration?.isCollapsed,
      isDense: widget.decoration?.isDense,
      contentPadding: widget.decoration?.contentPadding ?? const EdgeInsets.all(16),
      prefixIcon: widget.decoration?.prefixIcon,
      prefix: widget.decoration?.prefix,
      prefixText: widget.decoration?.prefixText,
      prefixIconConstraints: widget.decoration?.prefixIconConstraints,
      prefixStyle: widget.decoration?.prefixStyle,
      prefixIconColor: widget.decoration?.prefixIconColor,
      suffixIcon: widget.decoration?.suffixIcon ?? _suffixIcon(),
      suffix: widget.decoration?.suffix,
      suffixText: widget.decoration?.suffixText,
      suffixStyle: widget.decoration?.suffixStyle,
      suffixIconColor: widget.decoration?.suffixIconColor,
      suffixIconConstraints: widget.decoration?.suffixIconConstraints,
      counter: widget.decoration?.counter,
      counterText: widget.decoration?.counterText,
      counterStyle: widget.decoration?.counterStyle,
      filled: widget.decoration?.filled,
      fillColor: widget.decoration?.fillColor,
      hoverColor: widget.decoration?.hoverColor,
      errorBorder: widget.decoration?.errorBorder,
      focusedBorder: widget.decoration?.focusedBorder,
      focusedErrorBorder: widget.decoration?.focusedErrorBorder,
      disabledBorder: widget.decoration?.disabledBorder,
      enabledBorder: widget.decoration?.enabledBorder,
      // border: widget.decoration?.border ?? InputBorder.none,
      border: widget.decoration?.border,
      enabled: widget.decoration?.enabled,
      semanticCounterText: widget.decoration?.semanticCounterText,
      alignLabelWithHint: widget.decoration?.alignLabelWithHint,
      constraints: widget.decoration?.constraints,
    );
  }

  Widget? _suffixIcon() {
    final suffixIcon = widget.decoration?.suffixIcon;

    if (widget.clearable || widget.passwordField) {
      final widgets = <Widget>[];
      if (suffixIcon != null) widgets.add(suffixIcon);

      if (widget.passwordField) {
        widgets.add(InkWell(
          onTap: obscure,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: Icon(
            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ));
      }

      if (widget.clearable) {
        widgets.add(InkWell(
          onTap: clear,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: const Icon(Icons.clear),
        ));
      }

      return Row(mainAxisSize: MainAxisSize.min, children: widgets);
    } else {
      return suffixIcon;
    }
  }

  void clear() {
    if (_controller.text.isNotEmpty) {
      widget.onChanged?.call('');
      _controller.clear();
    }
  }

  void obscure() {
    setState(() {
      _obscureText = !_obscureText;
      widget.onObscureTextChanged?.call(_obscureText);
    });
  }
}
