import tkinter as tk
import platform
import os
import socket

def main():
    root = tk.Tk()
    root.title("Research Environment")
    root.geometry("600x400")
    root.configure(bg="#2b2b2b")

    title = tk.Label(
        root,
        text="Research Container",
        font=("Helvetica", 20, "bold"),
        bg="#2b2b2b",
        fg="#ffffff"
    )
    title.pack(pady=20)

    info = [
        ("Hostname", socket.gethostname()),
        ("User", os.environ.get("USER", "researcher")),
        ("Python", platform.python_version()),
        ("OS", platform.system() + " " + platform.release()),
        ("Display", os.environ.get("DISPLAY", "not set")),
    ]

    for label, value in info:
        frame = tk.Frame(root, bg="#2b2b2b")
        frame.pack(fill="x", padx=40, pady=5)

        tk.Label(
            frame,
            text=label + ":",
            font=("Helvetica", 12, "bold"),
            bg="#2b2b2b",
            fg="#aaaaaa",
            width=12,
            anchor="w"
        ).pack(side="left")

        tk.Label(
            frame,
            text=value,
            font=("Helvetica", 12),
            bg="#2b2b2b",
            fg="#ffffff",
            anchor="w"
        ).pack(side="left")

    root.mainloop()

if __name__ == "__main__":
    main()