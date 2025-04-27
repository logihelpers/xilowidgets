from enum import Enum
from typing import Any, Optional, Union

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber, Control, Ref

from flet.core.types import ResponsiveNumber, RotateValue, ScaleValue, OffsetValue, OptionalControlEventCallable
from flet.core.animation import AnimationValue
from flet.core.tooltip import TooltipValue
from flet.core.badge import BadgeValue

class Zoomer(ConstrainedControl):
    """
    Zoomer Control description.
    """

    def __init__(
        self,
        content: Optional[Control],
        minimum_scale: OptionalNumber = None,
        maximum_scale: OptionalNumber = None,
        #
        # ConstrainedControl
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
        offset: Optional[OffsetValue] = None,
        aspect_ratio: OptionalNumber = None,
        animate_opacity: Optional[AnimationValue] = None,
        animate_size: Optional[AnimationValue] = None,
        animate_position: Optional[AnimationValue] = None,
        animate_rotation: Optional[AnimationValue] = None,
        animate_scale: Optional[AnimationValue] = None,
        animate_offset: Optional[AnimationValue] = None,
        on_animation_end: OptionalControlEventCallable = None,
        tooltip: Optional[TooltipValue] = None,
        badge: Optional[BadgeValue] = None,
        visible: Optional[bool] = None,
        disabled: Optional[bool] = None,
        data: Any = None,
        rtl: Optional[bool] = None,
        adaptive: Optional[bool] = None,
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
            offset=offset,
            aspect_ratio=aspect_ratio,
            animate_opacity=animate_opacity,
            animate_size=animate_size,
            animate_position=animate_position,
            animate_rotation=animate_rotation,
            animate_scale=animate_scale,
            animate_offset=animate_offset,
            on_animation_end=on_animation_end,
            tooltip=tooltip,
            badge=badge,
            visible=visible,
            disabled=disabled,
            data=data,
            rtl=rtl,
        )

        self.content = content
        self.minimum_scale = minimum_scale
        self.maximum_scale = maximum_scale

    def _get_control_name(self):
        return "zoomer"
    
    def _get_children(self):
        children = []
        if self.__content is not None:
            self.__content._set_attr_internal("n", "content")
            children.append(self.__content)
        return children

    # value
    @property
    def content(self) -> Optional[Control]:
        return self.__content

    @content.setter
    def content(self, value: Optional[Control]):
        self.__content = value
    
    @property
    def minimum_scale(self) -> OptionalNumber:
        return self._get_attr("minimum_scale")

    @minimum_scale.setter
    def minimum_scale(self, value: OptionalNumber):
        self._set_attr("minimum_scale", value)
    
    @property
    def maximum_scale(self) -> OptionalNumber:
        return self._get_attr("maximum_scale")

    @maximum_scale.setter
    def maximum_scale(self, value: OptionalNumber):
        self._set_attr("maximum_scale", value)
