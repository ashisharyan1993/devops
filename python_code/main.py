import tkinter as tk

class DragWidget(tk.Label):
    def __init__(self, parent, image):
        super().__init__(parent, image=image)

        self.image = image
        self.x = 0
        self.y = 0

    def drag_start(self, event):
        self.x = event.x
        self.y = event.y

    def drag_move(self, event):
        dx = event.x - self.x
        dy = event.y - self.y

        self.x = event.x
        self.y = event.y

        self.place(x=self.winfo_x() + dx, y=self.winfo_y() + dy)

class DropWidget(tk.Frame):
    def __init__(self, parent):
        super().__init__(parent)

        self.drop_target = None

    def allow_drop(self, event):
        self.drop_target = event.widget

    def drop(self, event):
        if self.drop_target is not None:
            self.drop_target.place(x=event.x, y=event.y)

        self.drop_target = None

if __name__ == '__main__':
    root = tk.Tk()

    image = tk.PhotoImage(file='icon.png')

    drag_widget = DragWidget(root, image)
    drop_widget = DropWidget(root)

    drag_widget.bind('<Button-1>', drag_widget.drag_start)
    drag_widget.bind('<B1-Motion>', drag_widget.drag_move)

    drop_widget.bind('<Enter>', drop_widget.allow_drop)
    drop_widget.bind('<Drop>', drop_widget.drop)

    drag_widget.place(x=0, y=0)
    drop_widget.place(x=100, y=100)

    root.mainloop()