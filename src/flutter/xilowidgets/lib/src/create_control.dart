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
  aliases: ['pseudocode'],
  case_insensitive: false,
  keywords: {
    'keyword': 'INPUT OUTPUT assign IF THEN ELIF ELSE',
    'literal': 'true false',
    'built_in': 'AND OR NOT',
  },
  contains: [
    // Multi-line comments
    Mode(
      className: 'comment',
      begin: r'/\*',
      end: r'\*/',
      contains: [Mode(className: 'doctag', begin: '@[A-Za-z]+')],
    ),
    // Single-line comments
    Mode(
      className: 'comment',
      begin: r'//',
      end: r'$',
      contains: [Mode(className: 'doctag', begin: '@[A-Za-z]+')],
    ),
    // Numbers
    Mode(
      className: 'number',
      begin: r'[0-9]+(\.[0-9]+)?',
      relevance: 0,
    ),
    // Operators
    Mode(
      className: 'operator',
      begin: r'[=<>!+\-*/%]=?|==|!=|>=|<=',
      relevance: 0,
    ),
    // Identifiers/variables
    Mode(
      beginKeywords:
          'INPUT OUTPUT assign IF THEN ELIF ELSE true false AND OR NOT',
      className: 'keyword',
      relevance: 10,
    ),
    // Identifiers/variables
    Mode(
      className: 'variable',
      begin: r'\b[a-zA-Z_][a-zA-Z0-9_]*\b',
      relevance: 1,
    ),
    // Braces, parentheses
    Mode(
      className: 'punctuation',
      begin: r'[\(\)\[\]\{\}]',
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
