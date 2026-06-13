import sys
import os
import tarfile
import datetime
import subprocess
import glob
import json
from pathlib import Path

# --- AUTO-INSTALACJA ZALEŻNOŚCI ---
def install_deps():
    try:
        from PyQt6 import QtWidgets, QtCore, QtGui
    except ImportError:
        print("Instalowanie zależności PyQt6...")
        subprocess.run(["sudo", "rpm-ostree", "install", "-y", "python3-pyqt6"], check=True)
        os.execv(sys.executable, [sys.executable] + sys.argv)

# Jeśli nie jesteśmy w trybie cichym, sprawdź zależności GUI
if "--silent" not in sys.argv:
    install_deps()
    from PyQt6.QtWidgets import (QApplication, QMainWindow, QPushButton, QVBoxLayout, QHBoxLayout,
                                 QWidget, QFileDialog, QProgressBar, QLabel, QMessageBox, QSpinBox, QCheckBox)
    from PyQt6.QtCore import Qt, QThread, pyqtSignal

# --- KONFIGURACJA ---
HOME = Path.home()
CONFIG_FILE = HOME / ".config/kde_theme_manager.json"
DEFAULT_BACKUP_DIR = HOME / ".kde_theme_backups"

BASE_PATHS = [
    ".local/share/plasma", ".local/share/aurorae", ".local/share/color-schemes",
    ".local/share/icons", ".local/share/wallpapers", ".local/share/konsole",
    ".config/kdeglobals", ".config/plasmarc", ".config/plasmashellrc",
    ".config/plasma-org.kde.plasma.desktop-appletsrc", ".config/kglobalshortcutsrc",
    ".config/kwinrc", ".config/kwinrulesrc"
]

def load_settings():
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, 'r') as f: return json.load(f)
        except: pass
    return {"path": str(DEFAULT_BACKUP_DIR), "auto_delete": True, "days": 14}

def save_settings(settings):
    CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, 'w') as f: json.dump(settings, f)

def send_notification(title, message, icon="preferences-desktop-theme"):
    """Wysyła dymek powiadomienia do KDE."""
    subprocess.run(["notify-send", "-a", "KDE Theme Backup Manager", "-i", icon, title, message])

# --- HARMONOGRAM SYSTEMD ---
def setup_systemd_timer(enabled):
    timer_path = HOME / ".config/systemd/user/kde_backup.timer"
    service_path = HOME / ".config/systemd/user/kde_backup.service"
    timer_path.parent.mkdir(parents=True, exist_ok=True)

    if enabled:
        script_path = os.path.abspath(sys.argv[0])
        service_content = f"[Unit]\nDescription=KDE Theme Backup\n\n[Service]\nExecStart={sys.executable} {script_path} --silent\n"
        timer_content = "[Unit]\nDescription=Daily KDE Theme Backup\n\n[Timer]\nOnCalendar=daily\nPersistent=true\n\n[Install]\nWantedBy=timers.target\n"

        with open(service_path, 'w') as f: f.write(service_content)
        with open(timer_path, 'w') as f: f.write(timer_content)

        subprocess.run(["systemctl", "--user", "daemon-reload"])
        subprocess.run(["systemctl", "--user", "enable", "--now", "kde_backup.timer"])
    else:
        subprocess.run(["systemctl", "--user", "disable", "--now", "kde_backup.timer"], stderr=subprocess.DEVNULL)

# --- LOGIKA BACKUPU ---
def run_backup_logic(settings, progress_callback=None):
    dest_dir = Path(settings["path"])
    dest_dir.mkdir(parents=True, exist_ok=True)

    # Autousuwanie
    if settings.get("auto_delete"):
        now = datetime.datetime.now()
        for f in dest_dir.glob("*.tar.gz"):
            if (now - datetime.datetime.fromtimestamp(f.stat().st_mtime)).days >= settings["days"]:
                f.unlink()

    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    target = dest_dir / f"kde_smart_backup_{ts}.tar.gz"

    dynamic_paths = set(BASE_PATHS)
    for folder in [".config", ".local/share"]:
        for kw in ["darkly", "klassy", "kvantum", "darklyrc"]:
            for f in glob.glob(str(HOME / folder / f"*{kw}*")):
                dynamic_paths.add(os.path.relpath(f, HOME))

    existing = [p for p in dynamic_paths if (HOME / p).exists()]
    with tarfile.open(target, "w:gz") as tar:
        for i, p in enumerate(existing):
            tar.add(HOME / p, arcname=p, recursive=True)
            if progress_callback: progress_callback(int((i + 1) / len(existing) * 100))
    return target

# --- GUI ---
if "--silent" not in sys.argv:
    class Worker(QThread):
        progress = pyqtSignal(int)
        finished = pyqtSignal(str)

        def __init__(self, mode, file_path=None, settings=None):
            super().__init__()
            self.mode = mode
            self.file_path = file_path
            self.settings = settings

        def run(self):
            try:
                if self.mode == "backup":
                    res = run_backup_logic(self.settings, self.progress.emit)
                    self.finished.emit(f"Kopia zapisana:\n{res.name}")
                else:
                    with tarfile.open(self.file_path, "r:gz") as tar:
                        tar.extractall(path=HOME)
                    self.finished.emit("Przywrócono! Zrestartuj sesję KDE.")
            except Exception as e:
                self.finished.emit(f"BŁĄD: {str(e)}")

    class KDEBackupApp(QMainWindow):
        def __init__(self):
            super().__init__()
            self.settings = load_settings()
            self.setWindowTitle("KDE Backup Theme Manager")
            self.setFixedSize(480, 520)
            self.init_ui()

        def init_ui(self):
            layout = QVBoxLayout()

            self.status = QLabel("Zarządzaj kopiami Klassy, Darkly, Kvantum i KDE", self)
            self.status.setAlignment(Qt.AlignmentFlag.AlignCenter)
            self.status.setStyleSheet("font-weight: bold; margin-bottom: 10px;")

            # Ścieżka
            path_box = QHBoxLayout()
            self.path_label = QLabel(f"📍 {self.settings['path']}")
            btn_path = QPushButton("Zmień folder")
            btn_path.clicked.connect(self.change_path)
            path_box.addWidget(self.path_label, 1)
            path_box.addWidget(btn_path)

            # Opcje sprzątania
            clean_box = QHBoxLayout()
            self.check_del = QCheckBox("Automatyczne czyszczenie (dni):")
            self.check_del.setChecked(self.settings["auto_delete"])
            self.spin_days = QSpinBox()
            self.spin_days.setValue(self.settings["days"])
            clean_box.addWidget(self.check_del)
            clean_box.addWidget(self.spin_days)

            # Harmonogram
            self.check_timer = QCheckBox("Włącz codzienny backup w tle (Systemd)")
            timer_active = subprocess.run(["systemctl", "--user", "is-active", "kde_backup.timer"], capture_output=True, text=True).stdout.strip() == "active"
            self.check_timer.setChecked(timer_active)

            # Przyciski
            self.btn_b = QPushButton("🚀 UTWÓRZ KOPIĘ TERAZ")
            self.btn_b.clicked.connect(lambda: self.start("backup"))
            self.btn_r = QPushButton("📂 PRZYWRÓĆ MOTYW")
            self.btn_r.clicked.connect(lambda: self.start("restore"))
            self.btn_f = QPushButton("📁 OTWÓRZ FOLDER W DOLPHINIE")
            self.btn_f.clicked.connect(lambda: subprocess.run(["dolphin", self.settings["path"]]))

            self.pbar = QProgressBar()
            self.pbar.hide()

            layout.addWidget(self.status)
            layout.addLayout(path_box)
            layout.addLayout(clean_box)
            layout.addWidget(self.check_timer)
            layout.addSpacing(15)
            layout.addWidget(self.btn_b); layout.addWidget(self.btn_r); layout.addWidget(self.btn_f)
            layout.addWidget(self.pbar)

            c = QWidget(); c.setLayout(layout); self.setCentralWidget(c)

        def change_path(self):
            p = QFileDialog.getExistingDirectory(self, "Folder kopii", self.settings["path"])
            if p: self.settings["path"] = p; self.path_label.setText(f"📍 {p}"); save_settings(self.settings)

        def start(self, mode):
            self.settings["auto_delete"] = self.check_del.isChecked()
            self.settings["days"] = self.spin_days.value()
            save_settings(self.settings)
            setup_systemd_timer(self.check_timer.isChecked())

            file_path = None
            if mode == "restore":
                file_path, _ = QFileDialog.getOpenFileName(self, "Wybierz kopię", self.settings["path"], "*.tar.gz")
                if not file_path: return

            self.pbar.show(); self.btn_b.setEnabled(False)
            self.worker = Worker(mode, file_path, self.settings)
            self.worker.progress.connect(self.pbar.setValue)
            self.worker.finished.connect(self.done)
            self.worker.start()

        def done(self, msg):
            self.pbar.hide(); self.btn_b.setEnabled(True)
            QMessageBox.information(self, "KDE Manager", msg)

# --- URUCHAMIANIE ---
if __name__ == "__main__":
    if "--silent" in sys.argv:
        # Tryb tła dla Systemd
        try:
            config = load_settings()
            run_backup_logic(config)
            send_notification("Backup zakończony", f"Pomyślnie utworzono codzienną kopię motywu w {config['path']}")
        except Exception as e:
            send_notification("Błąd backupu", str(e), "error")
    else:
        # Tryb okienkowy
        app = QApplication(sys.argv)
        gui = KDEBackupApp()
        gui.show()
        sys.exit(app.exec())
