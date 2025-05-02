import json
from dataclasses import dataclass, asdict
from typing import Any, List, Optional, Union, Sequence
from warnings import warn

from flet.core.animation import AnimationValue, AnimationCurve
from flet.core.badge import BadgeValue
from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber
from flet.core.ref import Ref
from flet.core.text_style import TextStyle
from flet.core.types import (
    ColorValue,
    FontWeight,
    OffsetValue,
    ResponsiveNumber,
    RotateValue,
    ScaleValue,
    TextAlign,
    DurationValue
)

try:
    from typing import Literal
except ImportError:
    from typing_extensions import Literal

import json
from dataclasses import dataclass, asdict
from typing import Any, List, Optional, Union, Sequence

from flet.core.animation import AnimationCurve
from flet.core.constrained_control import ConstrainedControl
from flet.core.control import Control, OptionalNumber
from flet.core.ref import Ref
from flet.core.text_style import TextStyle
from flet.core.types import (
    ColorValue,
    DurationValue,
    OffsetValue,
    ResponsiveNumber,
    RotateValue,
    ScaleValue,
    TextAlign,
)

try:
    from typing import Literal
except ImportError:
    from typing_extensions import Literal


@dataclass
class AnimatedText:
    text: str
    style: Optional[TextStyle] = None
    theme_style: Optional[str] = None
    align: Optional[TextAlign] = None


@dataclass
class TyperAnimatedText(AnimatedText):
    type: Literal["Typer"] = "Typer"
    speed: DurationValue = 100
    curve: AnimationCurve = "linear"


@dataclass
class RotateAnimatedText(AnimatedText):
    type: Literal["Rotate"] = "Rotate"
    duration: DurationValue = 2000


@dataclass
class FadeAnimatedText(AnimatedText):
    type: Literal["Fade"] = "Fade"
    duration: DurationValue = 2000


@dataclass
class TypewriterAnimatedText(AnimatedText):
    type: Literal["Typewriter"] = "Typewriter"
    speed: DurationValue = 100
    curve: AnimationCurve = "linear"


@dataclass
class ScaleAnimatedText(AnimatedText):
    type: Literal["Scale"] = "Scale"
    duration: DurationValue = 2000


@dataclass
class ColorizeAnimatedText(AnimatedText):
    type: Literal["Colorize"] = "Colorize"
    colors: List[ColorValue] = None
    speed: DurationValue = 100

class AnimatedTextKit(ConstrainedControl):
    """
    AnimatedTextKit Control.
    """
    def __init__(
        self,
        texts: Optional[Sequence[AnimatedText]] = None,
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

        self.texts = texts

    def _get_control_name(self):
        return "animated_text_kit"
    
    def _get_children(self):
        return []
    
    @property
    def texts(self) -> List[AnimatedText]:
        return self.__texts

    @texts.setter
    def texts(self, value: Optional[Sequence[AnimatedText]]):
        self.__texts = list(value) if value else []