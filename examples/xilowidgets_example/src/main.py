import flet as ft

from xilowidgets import Revealer


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.theme_mode = ft.ThemeMode.LIGHT

    def hide(pane: Revealer):
        pane.content_hidden = not pane.content_hidden
        pane.update()

    page.add(
        pane := Revealer(
            content_length=200,
            content=ft.Container(
                content=ft.Text("Hallelujah")
            ),
            width=600,
            height = 500
        ),
        ft.ElevatedButton(
            "HIDE",
            width=500,
            on_click=lambda e: hide(pane)
        )
    )


ft.app(main)
