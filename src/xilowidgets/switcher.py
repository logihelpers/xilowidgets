from enum import Enum
from typing import Any, List, Optional, Sequence, Union

from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber, Control, Ref

from flet.core.types import (
    OffsetValue,
    ResponsiveNumber,
    RotateValue,
    ScaleValue,
)

class Switcher(ConstrainedControl):
    """
    Switcher Control.
    """
    class Orientation(Enum):
        VERTICAL: str = "VERTICAL"
        HORIZONTAL: str = "HORIZONTAL"

    def __init__(
        self,
        controls: Optional[Sequence[Control]] = None,
        orientation: Optional[Orientation] = None,
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

        self.controls = controls
        self.orientation = orientation

    def _get_control_name(self):
        return "switcher"
    
    def _get_children(self):
        return self.__controls

    def __contains__(self, item):
        return item in self.__controls
    
    @property
    def orientation(self) -> Orientation:
        return Switcher.Orientation.VERTICAL if self._get_attr("orientation") == "VERTICAL" else Switcher.Orientation.HORIZONTAL
    
    @orientation.setter
    def orientation(self, orientation: Orientation = Orientation.VERTICAL):
        self._set_attr("orientation", orientation.value)

    # controls
    @property
    def controls(self) -> List[Control]:
        return self.__controls

    @controls.setter
    def controls(self, value: Optional[Sequence[Control]]):
        self.__controls = list(value) if value else []
    
    def switch(self, current_index: int):
        self.invoke_method("switch", {"current": str(current_index)})