import json
from typing import Any, Optional

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber
from flet.core.types import ColorEnums, ColorValue, OptionalEventCallable, ControlEvent, ThemeMode
from flet.core.event_handler import EventHandler


class MediaQuery(ConstrainedControl):
    """
    MediaQuery Control.
    """

    def __init__(
        self,
        on_size_change: OptionalEventCallable["MediaQuerySizeChangeEvent"] = None,
        on_theme_mode_change: OptionalEventCallable["MediaQueryThemeModeChangeEvent"] = None,
        #
        # Control
        #
        opacity: OptionalNumber = None,
        tooltip: Optional[str] = None,
        visible: Optional[bool] = None,
        data: Any = None,
        #
        # ConstrainedControl
        #
        left: OptionalNumber = None,
        top: OptionalNumber = None,
        right: OptionalNumber = None,
        bottom: OptionalNumber = None,
    ):
        ConstrainedControl.__init__(
            self,
            tooltip=tooltip,
            opacity=opacity,
            visible=visible,
            data=data,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
        )

        self.__on_size_change = EventHandler(lambda e: MediaQuerySizeChangeEvent(e))
        self._add_event_handler("size_change", self.__on_size_change.get_handler())

        self.__on_theme_mode_change = EventHandler(lambda e: MediaQueryThemeModeChangeEvent(e))
        self._add_event_handler("theme_mode_change", self.__on_theme_mode_change.get_handler())

        self.on_size_change = on_size_change
        self.on_theme_mode_change = on_theme_mode_change

    def _get_control_name(self):
        return "mediaquery"

    # size
    @property
    def on_size_change(self) -> OptionalEventCallable["MediaQuerySizeChangeEvent"]:
        return self.__on_size_change.handler

    @on_size_change.setter
    def on_size_change(self, handler: OptionalEventCallable["MediaQuerySizeChangeEvent"]):
        self.__on_size_change.handler = handler
        self._set_attr("onSizeChange", True if handler is not None else None)
    
    @property
    def on_theme_mode_change(self) -> OptionalEventCallable["MediaQueryThemeModeChangeEvent"]:
        return self.__on_theme_mode_change.handler

    @on_theme_mode_change.setter
    def on_theme_mode_change(self, handler: OptionalEventCallable["MediaQueryThemeModeChangeEvent"]):
        self.__on_theme_mode_change.handler = handler
        self._set_attr("onThemeModeChange", True if handler is not None else None)

class MediaQuerySizeChangeEvent(ControlEvent):
    def __init__(self, e: ControlEvent):
        super().__init__(e.target, e.name, e.data, e.control, e.page)
        d = json.loads(e.data)
        self.window_width: float = d.get("width")
        self.window_height: float = d.get("height")

class MediaQueryThemeModeChangeEvent(ControlEvent):
    def __init__(self, e: ControlEvent):
        super().__init__(e.target, e.name, e.data, e.control, e.page)
        d = json.loads(e.data)
        self.theme_mode: ThemeMode = ThemeMode.DARK if bool(d.get("theme_mode")) else ThemeMode.LIGHT