import 'package:flet/flet.dart';
import 'package:highlight/highlight_core.dart';
import 'package:xilowidgets/src/xdialog.dart';
import 'package:xilowidgets/src/media_query.dart';

import 'drawboard.dart';
import 'revealer.dart';
import 'zoomer.dart';
import 'editor.dart';
import 'switcher.dart';

final Mode pseudocode = Mode(
  className: 'pseudocode',
  case_insensitive: true, // Make keywords case-insensitive (e.g., FOR, for, For)
  keywords: {
    'keyword': [
      'for', 'to', 'if', 'then', 'else', 'end', 'print', 'while', 'do', 'begin'
    ],
  },
  contains: [
    Mode(
      className: 'string',
      begin: '"',
      end: '"',
      relevance: 0,
    ),
    Mode(
      className: 'number',
      begin: r'\b\d+\b',
      relevance: 0,
    ),
    Mode(
      className: 'comment',
      begin: r'//',
      end: r'$',
      relevance: 0,
    ),
  ],
);

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "revealer":
      return RevealerControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        backend: args.backend
      );
    case "zoomer":
      return ZoomerControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        parentAdaptive: args.parentAdaptive,
        parentDisabled: args.parentDisabled,
      );
    case "editor":
      return EditorControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        parentAdaptive: args.parentAdaptive,
        parentDisabled: args.parentDisabled,
        backend: args.backend,
      );
    case "switcher":
      return SwitcherControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        parentAdaptive: args.parentAdaptive,
        parentDisabled: args.parentDisabled,
        backend: args.backend,
      );
    case "drawboard":
      return DrawboardControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        parentDisabled: args.parentDisabled,
        parentAdaptive: args.parentAdaptive,
        backend: args.backend,
      );
    case "mediaquery":
      return MediaQueryControl(
        control: args.control, 
        backend: args.backend
      );
    case "xdialog":
      return XDialogControl(
        control: args.control, 
        children: args.children, 
        parentDisabled: args.parentDisabled, 
        parentAdaptive: args.parentAdaptive, 
        nextChild: args.nextChild, 
        backend: args.backend
      );
    default:
      return null;
  }
};

void ensureInitialized() {
  highlight.registerLanguage('pseudocode', pseudocode);
}
