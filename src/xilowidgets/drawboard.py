import json
from typing import Any, List, Optional, Union

from flet.core.animation import AnimationValue
from flet.core.canvas.shape import Shape
from flet.core.constrained_control import ConstrainedControl
from flet.core.control import Control, OptionalNumber
from flet.core.control_event import ControlEvent
from flet.core.event_handler import EventHandler
from flet.core.ref import Ref
from flet.core.types import (
    OffsetValue,
    OptionalControlEventCallable,
    OptionalEventCallable,
    ResponsiveNumber,
    RotateValue,
    ScaleValue,
)


class Drawboard(ConstrainedControl):
    def __init__(
        self,
        shapes: Optional[List[Shape]] = None,
        content: Optional[Control] = None,
        resize_interval: OptionalNumber = None,
        on_resize=None,
        #
        # ConstrainedControl
        #
        ref: Optional[Ref] = None,
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
        on_capture: OptionalControlEventCallable = None,
        visible: Optional[bool] = None,
        disabled: Optional[bool] = None,
        data: Any = None,
    ):
        ConstrainedControl.__init__(
            self,
            ref=ref,
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
            visible=visible,
            disabled=disabled,
            data=data,
        )

        self.__on_resize = EventHandler(lambda e: DrawboardResizeEvent(e))
        self._add_event_handler("resize", self.__on_resize.get_handler())

        self.shapes = shapes
        self.content = content
        self.resize_interval = resize_interval
        self.on_resize = on_resize

        self.on_capture = on_capture

    def _get_control_name(self):
        return "drawboard"

    def _get_children(self):
        children = []
        children.extend(self.__shapes)
        if self.__content is not None:
            self.__content._set_attr_internal("n", "content")
            children.append(self.__content)
        return children

    def clean(self):
        super().clean()
        self.__shapes.clear()

    # shapes
    @property
    def shapes(self) -> List[Shape]:
        return self.__shapes

    @shapes.setter
    def shapes(self, value: Optional[List[Shape]]):
        self.__shapes = value if value is not None else []

    # content
    @property
    def content(self) -> Optional[Control]:
        return self.__content

    @content.setter
    def content(self, value: Optional[Control]):
        self.__content = value

    # resize_interval
    @property
    def resize_interval(self) -> OptionalNumber:
        return self._get_attr("resizeInterval")

    @resize_interval.setter
    def resize_interval(self, value: OptionalNumber):
        self._set_attr("resizeInterval", value)

    @property
    def on_capture(self):
        return self._get_event_handler("captured")

    @on_capture.setter
    def on_capture(self, handler):
        self._add_event_handler("captured", handler)
    
    def capture(self, width: float, height: float):
        self.invoke_method(
            "capture", 
            {
                "width": str(width), 
                "height": str(height)
            }
        )

    # on_resize
    @property
    def on_resize(self) -> OptionalEventCallable["DrawboardResizeEvent"]:
        return self.__on_resize.handler

    @on_resize.setter
    def on_resize(self, handler: OptionalEventCallable["DrawboardResizeEvent"]):
        self.__on_resize.handler = handler
        self._set_attr("onresize", True if handler is not None else None)


class DrawboardResizeEvent(ControlEvent):
    def __init__(self, e: ControlEvent) -> None:
        super().__init__(e.target, e.name, e.data, e.control, e.page)
        d = json.loads(e.data)
        self.width: float = d.get("w")
        self.height: float = d.get("h")