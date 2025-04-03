import 'package:flet/flet.dart';

import 'revealer.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "revealer":
      return RevealerControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        backend: args.backend
      );
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}
