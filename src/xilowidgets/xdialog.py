from typing import Any, List, Optional, Union
from enum import Enum

from flet.core.adaptive_control import AdaptiveControl
from flet.core.alignment import Alignment
from flet.core.animation import AnimationCurve
from flet.core.buttons import OutlinedBorder
from flet.core.control import Control, OptionalNumber
from flet.core.ref import Ref
from flet.core.text_style import TextStyle
from flet.core.types import (
    ClipBehavior,
    ColorEnums,
    ColorValue,
    MainAxisAlignment,
    OptionalControlEventCallable,
    PaddingValue,
)


class XDialog(AdaptiveControl):
    """
    An alert dialog informs the user about situations that require acknowledgement. An alert dialog has an optional title and an optional list of actions. The title is displayed above the content and the actions are displayed below the content.

    Example:
    ```
    import flet as ft


    def main(page: ft.Page):
        page.title = "XDialog examples"
        page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

        dlg = ft.XDialog(
            title=ft.Text("Hi, this is a non-modal dialog!"),
            on_dismiss=lambda e: page.add(ft.Text("Non-modal dialog dismissed")),
        )

        def handle_close(e):
            page.close(dlg_modal)
            page.add(ft.Text(f"Modal dialog closed with action: {e.control.text}"))

        dlg_modal = ft.XDialog(
            modal=True,
            title=ft.Text("Please confirm"),
            content=ft.Text("Do you really want to delete all those files?"),
            actions=[
                ft.TextButton("Yes", on_click=handle_close),
                ft.TextButton("No", on_click=handle_close),
            ],
            actions_alignment=ft.MainAxisAlignment.END,
            on_dismiss=lambda e: page.add(
                ft.Text("Modal dialog dismissed"),
            ),
        )

        page.add(
            ft.ElevatedButton("Open dialog", on_click=lambda e: page.open(dlg)),
            ft.ElevatedButton("Open modal dialog", on_click=lambda e: page.open(dlg_modal)),
        )


    ft.app(target=main)
    ```
    -----

    Online docs: https://flet.dev/docs/controls/XDialog
    """
    class LaunchDirection(Enum):
        TOP = "top"
        BOTTOM = "bottom"
        RIGHT = "right"
        LEFT = "left"
        TOP_LEFT = "top-left"
        TOP_RIGHT = "top-right"
        BOTTOM_LEFT = "bottom-left"
        BOTTOM_RIGHT = "bottom-right"
        CENTER = "center"

    def __init__(
        self,
        modal: bool = False,
        title: Optional[Union[Control, str]] = None,
        content: Optional[Control] = None,
        actions: Optional[List[Control]] = None,
        bgcolor: Optional[ColorValue] = None,
        elevation: OptionalNumber = None,
        open_duration: OptionalNumber = None,
        animation_curve: Optional[AnimationCurve] = None,
        launch_direction: Optional[LaunchDirection] = None,
        offset_scale: OptionalNumber = None,
        minimum_scale: OptionalNumber = None,
        maximum_scale: OptionalNumber = None,
        icon: Optional[Control] = None,
        open: bool = False,
        title_padding: Optional[PaddingValue] = None,
        content_padding: Optional[PaddingValue] = None,
        actions_padding: Optional[PaddingValue] = None,
        actions_alignment: Optional[MainAxisAlignment] = None,
        shape: Optional[OutlinedBorder] = None,
        inset_padding: Optional[PaddingValue] = None,
        icon_padding: Optional[PaddingValue] = None,
        action_button_padding: Optional[PaddingValue] = None,
        surface_tint_color: Optional[ColorValue] = None,
        shadow_color: Optional[ColorValue] = None,
        icon_color: Optional[ColorValue] = None,
        scrollable: Optional[bool] = None,
        actions_overflow_button_spacing: OptionalNumber = None,
        alignment: Optional[Alignment] = None,
        content_text_style: Optional[TextStyle] = None,
        title_text_style: Optional[TextStyle] = None,
        clip_behavior: Optional[ClipBehavior] = None,
        semantics_label: Optional[str] = None,
        barrier_color: Optional[ColorValue] = None,
        on_dismiss: OptionalControlEventCallable = None,
        #
        # AdaptiveControl
        #
        ref: Optional[Ref] = None,
        disabled: Optional[bool] = None,
        visible: Optional[bool] = None,
        data: Any = None,
        adaptive: Optional[bool] = None,
    ):
        Control.__init__(
            self,
            ref=ref,
            disabled=disabled,
            visible=visible,
            data=data,
        )

        AdaptiveControl.__init__(self, adaptive=adaptive)

        self.open = open
        self.bgcolor = bgcolor
        self.elevation = elevation
        self.icon = icon
        self.modal = modal
        self.title = title
        self.title_padding = title_padding
        self.content = content
        self.content_padding = content_padding
        self.actions = actions
        self.actions_padding = actions_padding
        self.actions_alignment = actions_alignment
        self.shape = shape
        self.inset_padding = inset_padding
        self.semantics_label = semantics_label
        self.on_dismiss = on_dismiss
        self.clip_behavior = clip_behavior
        self.action_button_padding = action_button_padding
        self.shadow_color = shadow_color
        self.surface_tint_color = surface_tint_color
        self.icon_padding = icon_padding
        self.icon_color = icon_color
        self.scrollable = scrollable
        self.actions_overflow_button_spacing = actions_overflow_button_spacing
        self.alignment = alignment
        self.content_text_style = content_text_style
        self.title_text_style = title_text_style
        self.barrier_color = barrier_color

        self.open_duration = open_duration
        self.animation_curve = animation_curve
        self.launch_direction = launch_direction
        self.offset_scale = offset_scale
        self.minimum_scale = minimum_scale
        self.maximum_scale = maximum_scale

    def _get_control_name(self):
        return "xdialog"

    def before_update(self):
        super().before_update()
        assert (
            self.__title or self.__content or self.__actions
        ), "XDialog has nothing to display. Provide at minimum one of the following: title, content, actions"
        self._set_attr_json("actionsPadding", self.__actions_padding)
        self._set_attr_json("contentPadding", self.__content_padding)
        self._set_attr_json("titlePadding", self.__title_padding)
        self._set_attr_json("shape", self.__shape)
        self._set_attr_json("insetPadding", self.__inset_padding)
        self._set_attr_json("iconPadding", self.__icon_padding)
        self._set_attr_json("actionButtonPadding", self.__action_button_padding)
        self._set_attr_json("alignment", self.__alignment)
        if isinstance(self.__content_text_style, TextStyle):
            self._set_attr_json("contentTextStyle", self.__content_text_style)
        if isinstance(self.__title_text_style, TextStyle):
            self._set_attr_json("titleTextStyle", self.__title_text_style)

    def _get_children(self):
        children = []
        if isinstance(self.__title, Control):
            self.__title._set_attr_internal("n", "title")
            children.append(self.__title)
        if self.__icon:
            self.__icon._set_attr_internal("n", "icon")
            children.append(self.__icon)
        if self.__content:
            self.__content._set_attr_internal("n", "content")
            children.append(self.__content)
        for action in self.__actions:
            action._set_attr_internal("n", "action")
            children.append(action)
        return children

    # open
    @property
    def open(self) -> bool:
        return self._get_attr("open", data_type="bool", def_value=False)

    @open.setter
    def open(self, value: Optional[bool]):
        self._set_attr("open", value)
    
    @property
    def open_duration(self) -> OptionalNumber:
        return self._get_attr("duration", data_type="int", def_value=250)

    @open_duration.setter
    def open_duration(self, value: OptionalNumber = 250):
        self._set_attr("duration", value)
    
    @property
    def offset_scale(self) -> OptionalNumber:
        return self._get_attr("offset_scale", data_type="float", def_value=100.0)

    @offset_scale.setter
    def offset_scale(self, value: OptionalNumber = 100.0):
        self._set_attr("offset_scale", value)

    @property
    def minimum_scale(self) -> OptionalNumber:
        return self._get_attr("minimum_scale", data_type="float", def_value=0.1)

    @minimum_scale.setter
    def minimum_scale(self, value: OptionalNumber = 0.1):
        self._set_attr("minimum_scale", value)
    
    @property
    def maximum_scale(self) -> OptionalNumber:
        return self._get_attr("maximum_scale", data_type="float", def_value=1.0)

    @maximum_scale.setter
    def maximum_scale(self, value: OptionalNumber = 1.0):
        self._set_attr("maximum_scale", value)
    
    @property
    def animation_curve(self) -> Optional[AnimationCurve]:
        return self._get_attr("animation_curve")

    @animation_curve.setter
    def animation_curve(self, value: Optional[AnimationCurve] = AnimationCurve.LINEAR):
        value = AnimationCurve.LINEAR if value is None else value
        self._set_attr("animation_curve", value.value)
    
    @property
    def launch_direction(self) -> Optional[LaunchDirection]:
        return self._get_attr("transitionFrom")

    @launch_direction.setter
    def launch_direction(self, value: Optional[LaunchDirection] = LaunchDirection.CENTER):
        value = XDialog.LaunchDirection.CENTER if value is None else value
        self._set_attr("transitionFrom", value.value)

    # bgcolor
    @property
    def bgcolor(self) -> Optional[ColorValue]:
        return self.__bgcolor

    @bgcolor.setter
    def bgcolor(self, value: Optional[ColorValue]):
        self.__bgcolor = value
        self._set_enum_attr("bgcolor", value, ColorEnums)

    # shadow_color
    @property
    def shadow_color(self) -> Optional[ColorValue]:
        return self.__shadow_color

    @shadow_color.setter
    def shadow_color(self, value: Optional[ColorValue]):
        self.__shadow_color = value
        self._set_enum_attr("shadowColor", value, ColorEnums)

    # barrier_color
    @property
    def barrier_color(self) -> Optional[ColorValue]:
        return self.__barrier_color

    @barrier_color.setter
    def barrier_color(self, value: Optional[ColorValue]):
        self.__barrier_color = value
        self._set_enum_attr("barrierColor", value, ColorEnums)

    # surface_tint_color
    @property
    def surface_tint_color(self) -> Optional[ColorValue]:
        return self.__surface_tint_color

    @surface_tint_color.setter
    def surface_tint_color(self, value: Optional[ColorValue]):
        self.__surface_tint_color = value
        self._set_enum_attr("surfaceTintColor", value, ColorEnums)

    # icon_color
    @property
    def icon_color(self) -> Optional[ColorValue]:
        return self.__icon_color

    @icon_color.setter
    def icon_color(self, value: Optional[ColorValue]):
        self.__icon_color = value
        self._set_enum_attr("iconColor", value, ColorEnums)

    # elevation
    @property
    def elevation(self) -> OptionalNumber:
        return self._get_attr("elevation", data_type="float")

    @elevation.setter
    def elevation(self, value: OptionalNumber):
        self._set_attr("elevation", value)

    # actions_overflow_button_spacing
    @property
    def actions_overflow_button_spacing(self) -> OptionalNumber:
        return self._get_attr("actionsOverflowButtonSpacing", data_type="float")

    @actions_overflow_button_spacing.setter
    def actions_overflow_button_spacing(self, value: OptionalNumber):
        self._set_attr("actionsOverflowButtonSpacing", value)

    # scrollable
    @property
    def scrollable(self) -> bool:
        return self._get_attr("scrollable", data_type="bool", def_value=False)

    @scrollable.setter
    def scrollable(self, value: Optional[bool]):
        self._set_attr("scrollable", value)

    # alignment
    @property
    def alignment(self) -> Optional[Alignment]:
        return self.__alignment

    @alignment.setter
    def alignment(self, value: Optional[Alignment]):
        self.__alignment = value

    # content_text_style
    @property
    def content_text_style(self) -> Optional[TextStyle]:
        return self.__content_text_style

    @content_text_style.setter
    def content_text_style(self, value: Optional[TextStyle]):
        self.__content_text_style = value

    # title_text_style
    @property
    def title_text_style(self) -> Optional[TextStyle]:
        return self.__title_text_style

    @title_text_style.setter
    def title_text_style(self, value: Optional[TextStyle]):
        self.__title_text_style = value

    # modal
    @property
    def modal(self) -> bool:
        return self._get_attr("modal", data_type="bool", def_value=False)

    @modal.setter
    def modal(self, value: Optional[bool]):
        self._set_attr("modal", value)

    # title
    @property
    def title(self) -> Optional[Union[Control, str]]:
        return self.__title

    @title.setter
    def title(self, value: Optional[Union[Control, str]]):
        self.__title = value
        if not isinstance(value, Control):
            self._set_attr("title", value)

    # icon
    @property
    def icon(self) -> Optional[Control]:
        return self.__icon

    @icon.setter
    def icon(self, value: Optional[Control]):
        self.__icon = value

    # title_padding
    @property
    def title_padding(self) -> Optional[PaddingValue]:
        return self.__title_padding

    @title_padding.setter
    def title_padding(self, value: Optional[PaddingValue]):
        self.__title_padding = value

    # content
    @property
    def content(self) -> Optional[Control]:
        return self.__content

    @content.setter
    def content(self, value: Optional[Control]):
        self.__content = value

    # content_padding
    @property
    def content_padding(self) -> Optional[PaddingValue]:
        return self.__content_padding

    @content_padding.setter
    def content_padding(self, value: Optional[PaddingValue]):
        self.__content_padding = value

    # actions
    @property
    def actions(self) -> List[Control]:
        return self.__actions

    @actions.setter
    def actions(self, value: Optional[List[Control]]):
        self.__actions = value if value is not None else []

    # actions_padding
    @property
    def actions_padding(self) -> Optional[PaddingValue]:
        return self.__actions_padding

    @actions_padding.setter
    def actions_padding(self, value: Optional[PaddingValue]):
        self.__actions_padding = value

    # actions_alignment
    @property
    def actions_alignment(self) -> Optional[MainAxisAlignment]:
        return self.__actions_alignment

    @actions_alignment.setter
    def actions_alignment(self, value: Optional[MainAxisAlignment]):
        self.__actions_alignment = value
        self._set_attr(
            "actionsAlignment",
            value.value if isinstance(value, MainAxisAlignment) else value,
        )

    # shape
    @property
    def shape(self) -> Optional[OutlinedBorder]:
        return self.__shape

    @shape.setter
    def shape(self, value: Optional[OutlinedBorder]):
        self.__shape = value

    # inset_padding
    @property
    def inset_padding(self) -> Optional[PaddingValue]:
        return self.__inset_padding

    @inset_padding.setter
    def inset_padding(self, value: Optional[PaddingValue]):
        self.__inset_padding = value

    # icon_padding
    @property
    def icon_padding(self) -> Optional[PaddingValue]:
        return self.__icon_padding

    @icon_padding.setter
    def icon_padding(self, value: Optional[PaddingValue]):
        self.__icon_padding = value

    # action_button_padding
    @property
    def action_button_padding(self) -> Optional[PaddingValue]:
        return self.__action_button_padding

    @action_button_padding.setter
    def action_button_padding(self, value: Optional[PaddingValue]):
        self.__action_button_padding = value

    # semantics_label
    @property
    def semantics_label(self) -> Optional[str]:
        return self._get_attr("semanticsLabel")

    @semantics_label.setter
    def semantics_label(self, value: Optional[str]):
        self._set_attr("semanticsLabel", value)

    # clip_behavior
    @property
    def clip_behavior(self) -> Optional[ClipBehavior]:
        return self.__clip_behavior

    @clip_behavior.setter
    def clip_behavior(self, value: Optional[ClipBehavior]):
        self.__clip_behavior = value
        self._set_enum_attr("clipBehavior", value, ClipBehavior)

    # on_dismiss
    @property
    def on_dismiss(self) -> OptionalControlEventCallable:
        return self._get_event_handler("dismiss")

    @on_dismiss.setter
    def on_dismiss(self, handler: OptionalControlEventCallable):
        self._add_event_handler("dismiss", handler)