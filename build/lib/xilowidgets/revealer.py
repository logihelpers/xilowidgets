from typing import Any, List, Optional, Tuple, Union
from enum import Enum
from flet.core.alignment import Alignment
from flet.core.badge import BadgeValue
from flet.core.border import Border
from flet.core.box import (
    BoxDecoration,
    BoxShadow,
    BoxShape,
    ColorFilter,
)
from flet.core.constrained_control import ConstrainedControl
from flet.core.animation import AnimationCurve
from flet.core.control import Control, OptionalNumber
from flet.core.ref import Ref
from flet.core.theme import Theme
from flet.core.tooltip import TooltipValue
from flet.core.types import (
    BorderRadiusValue,
    ClipBehavior,
    MarginValue,
    PaddingValue,
    ResponsiveNumber,
    RotateValue,
    ScaleValue,
    ThemeMode,
)

class Revealer(ConstrainedControl):
    class Orientation(Enum):
        VERTICAL: str = "VERTICAL"
        HORIZONTAL: str = "HORIZONTAL"

    def __init__(
        self,
        content: Optional[Control] = None,
        content_hidden: Optional[bool] = False,
        padding: Optional[PaddingValue] = None,
        margin: Optional[MarginValue] = None,
        alignment: Optional[Alignment] = None,
        content_length: OptionalNumber = None,
        orientation: Orientation = Orientation.HORIZONTAL,
        animation_duration: OptionalNumber = None,
        animation_curve: Optional[AnimationCurve] = None,
        content_fill: Optional[bool] = None,
        border: Optional[Border] = None,
        border_radius: Optional[BorderRadiusValue] = None,
        shape: Optional[BoxShape] = None,
        clip_behavior: Optional[ClipBehavior] = None,
        theme: Optional[Theme] = None,
        dark_theme: Optional[Theme] = None,
        theme_mode: Optional[ThemeMode] = None,
        color_filter: Optional[ColorFilter] = None,
        ignore_interactions: Optional[bool] = None,
        foreground_decoration: Optional[BoxDecoration] = None,
        #
        # ConstrainedControl and AdaptiveControl
        #
        ref: Optional[Ref] = None,
        key: Optional[str] = None,
        width: OptionalNumber = None,
        height: OptionalNumber = None,
        left: OptionalNumber = None,
        top: OptionalNumber = None,
        right: OptionalNumber = None,
        bottom: OptionalNumber = None,
        expand: Union[None, bool, int] = None,
        expand_loose: Optional[bool] = None,
        col: Optional[ResponsiveNumber] = None,
        opacity: OptionalNumber = None,
        rotate: Optional[RotateValue] = None,
        scale: Optional[ScaleValue] = None,
        tooltip: Optional[TooltipValue] = None,
        badge: Optional[BadgeValue] = None,
        visible: Optional[bool] = None,
        disabled: Optional[bool] = None,
        data: Any = None,
        rtl: Optional[bool] = None,
    ):
        ConstrainedControl.__init__(
            self,
            ref=ref,
            key=key,
            width=width,
            height=height,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
            expand=expand,
            expand_loose=expand_loose,
            col=col,
            opacity=opacity,
            rotate=rotate,
            scale=scale,
            tooltip=tooltip,
            badge=badge,
            visible=visible,
            disabled=disabled,
            data=data,
            rtl=rtl,
        )

        self.content = content
        self.content_hidden = content_hidden
        self.orientation = orientation
        self.animation_duration = animation_duration
        self.content_fill = content_fill
        self.padding = padding
        self.margin = margin
        self.alignment = alignment
        self.animation_curve = animation_curve
        self.content_length = content_length
        self.border = border
        self.border_radius = border_radius
        self.shape = shape
        self.clip_behavior = clip_behavior
        self.theme = theme
        self.dark_theme = dark_theme
        self.theme_mode = theme_mode
        self.color_filter = color_filter
        self.ignore_interactions = ignore_interactions
        self.foreground_decoration = foreground_decoration

    def _get_control_name(self):
        return "revealer"

    def before_update(self):
        super().before_update()
        assert (
            self.__shape != BoxShape.CIRCLE or self.__border_radius is None
        ), "border_radius is not supported with shape=BoxShape.CIRCLE"
        self._set_attr_json("borderRadius", self.__border_radius)
        self._set_attr_json("border", self.__border)
        self._set_attr_json("margin", self.__margin)
        self._set_attr_json("content_length", self.__content_length)
        self._set_attr_json("padding", self.__padding)
        self._set_attr_json("alignment", self.__alignment)
        self._set_attr_json("theme", self.__theme)
        self._set_attr_json("darkTheme", self.__dark_theme)
        self._set_attr_json("colorFilter", self.__color_filter)
        self._set_attr_json("foregroundDecoration", self.__foreground_decoration)

    def _get_children(self):
        children = []
        if self.__content is not None:
            self.__content._set_attr_internal("n", "content")
            children.append(self.__content)

        return children

    # alignment
    @property
    def alignment(self) -> Optional[Alignment]:
        """:obj:`Alignment`, optional: Align the child control within the container.

        Alignment is an instance of `alignment.Alignment` class object with `x` and `y` properties
        representing the distance from the center of a rectangle.
        """
        return self.__alignment

    @alignment.setter
    def alignment(self, value: Optional[Alignment]):
        self.__alignment = value

    # padding
    @property
    def padding(self) -> Optional[PaddingValue]:
        return self.__padding

    @padding.setter
    def padding(self, value: Optional[PaddingValue]):
        self.__padding = value

    # foreground_decoration
    @property
    def foreground_decoration(self) -> Optional[BoxDecoration]:
        return self.__foreground_decoration

    @foreground_decoration.setter
    def foreground_decoration(self, value: Optional[BoxDecoration]):
        self.__foreground_decoration = value

    # margin
    @property
    def margin(self) -> Optional[MarginValue]:
        return self.__margin

    @margin.setter
    def margin(self, value: Optional[MarginValue]):
        self.__margin = value
    
    @property
    def content_length(self) -> OptionalNumber:
        return self.__content_length

    @content_length.setter
    def content_length(self, value: OptionalNumber):
        self.__content_length = value
    
    @property
    def animation_duration(self) -> OptionalNumber:
        return self._get_attr("animationDuration")

    @animation_duration.setter
    def animation_duration(self, value: OptionalNumber):
        self._set_attr("animationDuration", value)
    
    @property
    def orientation(self) -> Orientation:
        return self._get_attr("orientation")

    @orientation.setter
    def orientation(self, value: Orientation = Orientation.HORIZONTAL):
        self._set_attr("orientation", value.value)
    
    @property
    def content_hidden(self) -> Optional[bool]:
        return self._get_attr("content_hidden", data_type="bool", def_value=False)

    @content_hidden.setter
    def content_hidden(self, value: Optional[bool]):
        self._set_attr("content_hidden", value)
    
    @property
    def content_fill(self) -> Optional[bool]:
        return self._get_attr("content_fill", data_type="bool", def_value=False)

    @content_fill.setter
    def content_fill(self, value: Optional[bool]):
        self._set_attr("content_fill", value)

    # shadow
    @property
    def shadow(self) -> Union[None, BoxShadow, List[BoxShadow]]:
        return self.__shadow

    @shadow.setter
    def shadow(self, value: Union[None, BoxShadow, List[BoxShadow]]):
        self.__shadow = value if value is not None else []

    # color_filter
    @property
    def color_filter(self) -> Optional[ColorFilter]:
        return self.__color_filter

    @color_filter.setter
    def color_filter(self, value: Optional[ColorFilter]):
        self.__color_filter = value

    # border
    @property
    def border(self) -> Optional[Border]:
        return self.__border

    @border.setter
    def border(self, value: Optional[Border]):
        self.__border = value

    # border_radius
    @property
    def border_radius(self) -> Optional[BorderRadiusValue]:
        return self.__border_radius

    @border_radius.setter
    def border_radius(self, value: Optional[BorderRadiusValue]):
        self.__border_radius = value

    # ignore_interactions
    @property
    def ignore_interactions(self) -> Optional[bool]:
        return self._get_attr("ignoreInteractions", data_type="bool", def_value=False)

    @ignore_interactions.setter
    def ignore_interactions(self, value: Optional[str]):
        self._set_attr("ignoreInteractions", value)

    # content
    @property
    def content(self) -> Optional[Control]:
        return self.__content

    @content.setter
    def content(self, value: Optional[Control]):
        self.__content = value

    # shape
    @property
    def shape(self) -> Optional[BoxShape]:
        return self.__shape

    @shape.setter
    def shape(self, value: Optional[BoxShape]):
        self.__shape = value
        self._set_enum_attr("shape", value, BoxShape)

    # clip_behavior
    @property
    def clip_behavior(self) -> Optional[ClipBehavior]:
        return self.__clip_behavior

    @clip_behavior.setter
    def clip_behavior(self, value: Optional[ClipBehavior]):
        self.__clip_behavior = value
        self._set_enum_attr("clipBehavior", value, ClipBehavior)
    # theme
    @property
    def theme(self) -> Optional[Theme]:
        return self.__theme

    @theme.setter
    def theme(self, value: Optional[Theme]):
        self.__theme = value

    # dark_theme
    @property
    def dark_theme(self) -> Optional[Theme]:
        return self.__dark_theme

    @dark_theme.setter
    def dark_theme(self, value: Optional[Theme]):
        self.__dark_theme = value

    # theme_mode
    @property
    def theme_mode(self) -> Optional[ThemeMode]:
        return self.__theme_mode

    @theme_mode.setter
    def theme_mode(self, value: Optional[ThemeMode]):
        self.__theme_mode = value
        self._set_enum_attr("themeMode", value, ThemeMode)
    
    @property
    def animation_curve(self) -> Optional[AnimationCurve]:
        return self.__animation_curve

    @animation_curve.setter
    def animation_curve(self, value: Optional[AnimationCurve]):
        self.__animation_curve = value
        self._set_enum_attr("curve", value, AnimationCurve)