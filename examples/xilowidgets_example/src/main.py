import flet as ft
import flet.canvas as cv

from xilowidgets import Revealer, Editor, Zoomer, Switcher, Drawboard, MediaQuery, MediaQuerySizeChangeEvent, XDialog

def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    def hide(pane: Revealer):
        pane.content_hidden = not pane.content_hidden
        pane.update()
    
    def update(nays: Switcher):
        nays.switch(1)
        nays.update()
    
    def print_size(db: Drawboard, width: float, height: float):
        db.shapes[0].text = f"{width}x{height}"
        db.update()
    
    def print_mode(db: Drawboard, theme_mode: ft.ThemeMode):
        db.shapes[1].text = theme_mode.name
        db.update()
    
    def show_dialog():
        dialog = XDialog(
            title=ft.Text("Please confirm"),
            content=ft.Text("Do you really want to delete all those files?"),
            launch_direction=XDialog.LaunchDirection.CENTER,
            animation_curve=ft.AnimationCurve.ELASTIC_IN_OUT,
            minimum_scale=0.1,
            maximum_scale=1,
            offset_scale=500,
            open_duration=500,
            actions=[
                ft.TextButton("Close", on_click = lambda e: page.close(dialog)),
            ],
            actions_alignment=ft.MainAxisAlignment.END,
        )
        page.open(dialog)

    page.add(
        ft.Row(
            expand=True,
            controls = [
                Zoomer(
                    content = (
                        pane := Revealer(
                            content_length=200,
                            content=ft.Image(
                                src="https://picsum.photos/200/200?1",
                                width=250,
                                height=100
                            ),
                            width=100,
                            height=100
                        )
                    ),
                    minimum_scale=0.1,
                    maximum_scale=100.0,
                    expand=True
                ),
                db := Drawboard(
                    [
                        cv.Text(0, 0, "Resize the window"),
                        cv.Text(0, 30, "Change the System Dark Mode")
                    ],
                    expand=True
                )
            ]
        ),
        nays := Switcher(
            height=100,
            orientation=Switcher.Orientation.HORIZONTAL,
            animation_duration=3000,
            animation_curve=ft.AnimationCurve.BOUNCE_OUT,
            controls=[
                ft.ElevatedButton(
                    "SWITCH",
                    width=500,
                    on_click=lambda e: update(nays)
                ),
                ft.ElevatedButton(
                    "HIDE",
                    width=500,
                    on_click=lambda e: hide(pane)
                ),
            ]
        ),
        ft.ElevatedButton(
            "DIALOG",
            width=500,
            height=100,
            on_click=lambda e: show_dialog()
        ),
        Editor(
            expand=True,
            font_size=36,
            gutter_width=150
        ),
        MediaQuery(
            lambda ev: print_size(db, ev.window_width, ev.window_height),
            lambda ev: print_mode(db, ev.theme_mode)
        )
    )

ft.app(main)
