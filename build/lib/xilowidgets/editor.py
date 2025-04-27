from enum import Enum
from typing import Any, Optional, Union

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber, Ref
from flet.core.scrollable_control import ScrollableControl

from flet.core.types import (
    OffsetValue,
    ResponsiveNumber,
    RotateValue,
    ScaleValue,
)

class EditorTheme(Enum):
    A11Y_DARK = "a11y-dark"
    A11Y_LIGHT = "a11y-light"
    AGATE = "agate"
    ANDROID_STUDIO = "androidstudio"
    ARTA = "arta"
    ATOM_ONE_DARK = "atom-one-dark"
    DEFAULT = "default"
    DARK = "dark"
    MONOKAI = "monokai"
    MONOKAI_SUBLIME = "monokai-sublime"
    OBSIDIAN = "obsidian"
    SOLARIZED_LIGHT = "solarized-light"
    SOLARIZED_DARK = "solarized-dark"
    VS2015 = "vs2015"
    XCODE = "xcode"
    IDEA = "idea"

class Editor(ConstrainedControl, ScrollableControl):
    """
    Codeeditor Control description.
    """

    def __init__(
        self,
        show_line_numbers: Optional[bool] = True,
        editor_theme: Optional[EditorTheme] = EditorTheme.DEFAULT,
        font_family: Optional[str] = None,
        font_size: OptionalNumber = None,
        value: Optional[str] = None,
        on_change = None,
        gutter_width: OptionalNumber = None,
        wrap: Optional[bool] = False,
        autocomplete: Optional[bool] = False,
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
        ref: Optional[Ref] = None,
        width: OptionalNumber = None,
        height: OptionalNumber = None,
        expand: Union[None, bool, int] = None,
        expand_loose: Optional[bool] = None,
        col: Optional[ResponsiveNumber] = None,
        rotate: Optional[RotateValue] = None,
        scale: Optional[ScaleValue] = None,
        offset: Optional[OffsetValue] = None,
        aspect_ratio: OptionalNumber = None,
        disabled: Optional[bool] = None,
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
            ref=ref,
            width=width,
            height=height,
            expand=expand,
            expand_loose=expand_loose,
            col=col,
            rotate=rotate,
            scale=scale,
            offset=offset,
            aspect_ratio=aspect_ratio,
            disabled=disabled
        )

        self.show_line_numbers = show_line_numbers
        self.editor_theme = editor_theme
        self.font_family = font_family
        self.font_size = font_size
        self.value = value
        self.on_change = on_change
        self.gutter_width = gutter_width
        self.wrap = wrap
        self.autocomplete = autocomplete

    def _get_control_name(self):
        return "editor"

    # value
    @property
    def show_line_numbers(self) -> bool:
        return self._get_attr("showLineNumbers")

    @show_line_numbers.setter
    def show_line_numbers(self, show: bool):
        self._set_attr("show_line_numbers", show)
    
    @property
    def wrap(self) -> bool:
        return self._get_attr("wrap")

    @wrap.setter
    def wrap(self, show: bool):
        self._set_attr("wrap", show)
    
    @property
    def autocomplete(self) -> bool:
        return self._get_attr("autocomplete")

    @autocomplete.setter
    def autocomplete(self, autocomplete: bool):
        self._set_attr("autocomplete", autocomplete)
    
    # value
    @property
    def editor_theme(self) -> EditorTheme:
        return self._get_attr("editorTheme")

    @editor_theme.setter
    def editor_theme(self, theme: EditorTheme):
        self._set_attr("editorTheme", theme.value)
    
    # value
    @property
    def font_size(self) -> float:
        return self._get_attr("fontSize")

    @font_size.setter
    def font_size(self, size: float):
        self._set_attr("fontSize", size)
    
    @property
    def gutter_width(self) -> float:
        return self._get_attr("gutterWidth")

    @gutter_width.setter
    def gutter_width(self, size: float):
        self._set_attr("gutterWidth", size)
    
    @property
    def font_family(self) -> str:
        return self._get_attr("fontFamily")

    @font_family.setter
    def font_family(self, font: str):
        self._set_attr("fontFamily", font)
    
    @property
    def value(self) -> str:
        return self._get_attr("value")

    @value.setter
    def value(self, val: str):
        self._set_attr("value", val)
    
    @property
    def on_change(self):
        return self._get_event_handler("change")

    @on_change.setter
    def on_change(self, handler):
        self._add_event_handler("change", handler)
