import flet as ft
import flet.canvas as cv

from xilowidgets import Revealer, Editor, Zoomer, Switcher, Drawboard, MediaQuery, MediaQuerySizeChangeEvent

def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.theme_mode = ft.ThemeMode.LIGHT

    def hide(pane: Revealer):
        pane.content_hidden = not pane.content_hidden
        pane.update()
    
    def update(nays: Switcher):
        nays.switch(1)
        nays.update()
    
    def print_size(db: Drawboard, width: float, height: float):
        db.shapes[0].text = f"{width}x{height}"
        db.update()

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
                        cv.Text(0, 0, "Resize the window")
                    ],
                    expand=True
                )
            ]
        ),
        nays := Switcher(
            height=100,
            orientation=Switcher.Orientation.HORIZONTAL,
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
        Editor(
            expand=True,
            font_size=36,
            gutter_width=150
        ),
        MediaQuery(lambda ev: print_size(db, ev.window_width, ev.window_height))
    )

ft.app(main)
