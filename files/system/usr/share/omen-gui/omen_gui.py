import sys, os, subprocess, json, shutil

# --- LOGIKA INSTALACJI ZALEŻNOŚCI DLA FEDORY ---
def ensure_fedora_deps():
    """Sprawdza i instaluje brakujące zależności systemowe na Fedorze przed startem GUI."""
    deps_to_install = []

    # 1. Sprawdź bibliotekę PySide6
    try:
        import PySide6
    except ImportError:
        deps_to_install.append("python3-pyside6")

    # 2. Sprawdź krytyczne biblioteki XCB dla Qt6 na Fedorze
    if not os.path.exists("/usr/lib64/libxcb-cursor.so.0"):
        deps_to_install.append("xcb-util-cursor")

    if deps_to_install:
        print(f"Wykryto brakujące pakiety: {', '.join(deps_to_install)}")
        try:
            cmd = f"sudo dnf install -y {' '.join(deps_to_install)}"
            subprocess.run(cmd, shell=True, check=True)
        except Exception as e:
            print(f"BŁĄD INSTALACJI: {e}")

# Uruchom sprawdzenie przed importami
ensure_fedora_deps()

from PySide6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                                QHBoxLayout, QPushButton, QComboBox, QSlider,
                                QLabel, QColorDialog, QMessageBox, QFrame,
                                QGridLayout, QScrollArea, QInputDialog, QMenu,
                                QFileDialog, QToolTip, QSystemTrayIcon, QStyle,
                                QCheckBox, QDialog, QLineEdit)
from PySide6.QtGui import QFont, QColor, QAction, QIcon, QShortcut, QKeySequence, QPixmap, QPainter, QConicalGradient, QPalette
from PySide6.QtCore import Qt, QPointF, QPropertyAnimation, QVariantAnimation, QEasingCurve, QTimer

# KONFIGURACJA ŚCIEŻEK
BASE_PATH = "/sys/devices/platform/omen-rgb-keyboard/rgb_zones"
DEFAULT_CONFIG_DIR = os.path.join(os.path.expanduser("~"), ".config", "omen_master")
GLOBAL_CONFIG_POINTER = os.path.join(os.path.expanduser("~"), ".omen_master_path")

def get_current_config_dir():
    if os.path.exists(GLOBAL_CONFIG_POINTER):
        try:
            with open(GLOBAL_CONFIG_POINTER, "r") as f:
                path = f.read().strip()
                if os.path.exists(path): return path
        except: pass
    return DEFAULT_CONFIG_DIR

STRINGS = {
    "pl": {
        "title": "HP OMEN RGB - Ultimate Master v10.0",
        "zones_cfg": "KONFIGURACJA STREF",
        "save_preset_btn": "ZAPISZ JAKO NOWY PRESET",
        "mode_label": "Tryb:", "speed_label": "Prędkość:", "bright_label": "Jasność:",
        "turn_off": "WYŁĄCZ", "apply": "ZASTOSUJ ZMIANY", "my_presets": "MOJE PRESETY",
        "settings": "Ustawienia", "lang_select": "Język / Language:",
        "tray_min": "Minimalizuj do tray przy zamykaniu", "dyn_icon": "Dynamiczna ikona Tray",
        "cfg_path_label": "Folder presetów:", "browse": "Przeglądaj...", "cancel": "Anuluj",
        "apply_settings": "Zastosuj", "new_preset_name": "Nazwa profilu:",
        "new_preset_title": "Nowy Preset", "rename_title": "Zmień nazwę", "del_ask": "Usunąć ten profil?",
        "tip_settings": "Ustawienia programu", "tip_import": "Importuj presety JSON",
        "tip_export": "Exportuj aktualne kolory", "tip_off": "Wyłącz podświetlenie",
        "tip_apply": "Zastosuj zmiany (Ctrl+S)", "tip_load": "Wczytaj profil",
        "tip_rename": "Zmień nazwę profilu", "tip_delete": "Usuń profil", "tip_zone": "Wybierz kolor",
        "tip_mode": "Tryb animacji", "tip_speed": "Szybkość animacji", "tip_bright": "Jasność (0-100%)",
        "gen_grad": "GENERUJ GRADIENT (S1 -> S4)", "show_win": "Pokaż okno", "quit_app": "Zakończ",
        "sudo_title": "Wymagane Sudo", "sudo_msg": "Wprowadź hasło (sudo), aby sterować klawiaturą:"
    },
    "en": {
        "title": "HP OMEN RGB - Ultimate Master v10.0",
        "zones_cfg": "ZONE CONFIGURATION",
        "save_preset_btn": "SAVE AS NEW PRESET",
        "mode_label": "Mode:", "speed_label": "Speed:", "bright_label": "Brightness:",
        "turn_off": "TURN OFF", "apply": "APPLY CHANGES", "my_presets": "MY PRESETS",
        "settings": "Settings", "lang_select": "Language:",
        "tray_min": "Minimize to tray on close", "dyn_icon": "Dynamic Tray Icon",
        "cfg_path_label": "Presets Folder:", "browse": "Browse...", "cancel": "Cancel",
        "apply_settings": "Apply", "new_preset_name": "Profile name:",
        "new_preset_title": "New Preset", "rename_title": "Rename", "del_ask": "Delete this profile?",
        "tip_settings": "Open settings", "tip_import": "Import JSON presets",
        "tip_export": "Export current colors", "tip_off": "Turn off all lighting",
        "tip_apply": "Apply changes (Ctrl+S)", "tip_load": "Load this profile",
        "tip_rename": "Rename profile", "tip_delete": "Delete profile", "tip_zone": "Pick color for zone",
        "tip_mode": "Select animation mode", "tip_speed": "Adjust animation speed", "tip_bright": "Adjust brightness (0-100%)",
        "gen_grad": "GENERATE GRADIENT (S1 -> S4)", "show_win": "Show Window", "quit_app": "Quit",
        "sudo_title": "Sudo Required", "sudo_msg": "Enter password (sudo) to control keyboard:"
    }
}

class SettingsDialog(QDialog):
    def __init__(self, parent=None, stay_in_tray=True, dynamic_icon=True, lang="pl", cfg_path=""):
        super().__init__(parent); self.lang = lang; s = STRINGS[lang]; self.setWindowTitle(s["settings"]); self.setMinimumWidth(450)
        layout = QVBoxLayout(self); self.lang_box = QComboBox(); self.lang_box.addItems(["Polski", "English"])
        self.lang_box.setCurrentIndex(0 if lang == "pl" else 1); layout.addWidget(QLabel(s["lang_select"])); layout.addWidget(self.lang_box)
        layout.addWidget(QLabel(s["cfg_path_label"])); path_h = QHBoxLayout(); self.path_edit = QLineEdit(cfg_path)
        btn_browse = QPushButton(s["browse"]); btn_browse.clicked.connect(self.browse_folder); path_h.addWidget(self.path_edit); path_h.addWidget(btn_browse); layout.addLayout(path_h)
        self.tray_checkbox = QCheckBox(s["tray_min"]); self.tray_checkbox.setChecked(stay_in_tray); layout.addWidget(self.tray_checkbox)
        self.icon_checkbox = QCheckBox(s["dyn_icon"]); self.icon_checkbox.setChecked(dynamic_icon); layout.addWidget(self.icon_checkbox); layout.addStretch()
        btns = QHBoxLayout(); btn_cancel = QPushButton(s["cancel"]); btn_cancel.clicked.connect(self.reject); self.btn_apply = QPushButton(s["apply_settings"]); self.btn_apply.clicked.connect(self.accept); btns.addWidget(btn_cancel); btns.addWidget(self.btn_apply); layout.addLayout(btns)
    def browse_folder(self):
        dir_path = QFileDialog.getExistingDirectory(self, "Select Folder", self.path_edit.text())
        if dir_path: self.path_edit.setText(dir_path)

class OmenUltimateMaster(QMainWindow):
    def __init__(self):
        super().__init__(); self.user_password = ""; self.current_preset_name = "current_preset"; self._anims = {}
        self.config_dir = get_current_config_dir(); self.presets_dir = os.path.join(self.config_dir, "presets")
        os.makedirs(self.presets_dir, exist_ok=True); self.presets_file = os.path.join(self.config_dir, "presets.json")
        self.lang = "pl"; self.strefy_hex = ["FF0000", "00FF00", "0000FF", "FFFFFF"]; self.previews = []
        self.load_settings_only(); self.ask_for_sudo_password()
        self.apply_theme_engine(); self.check_driver(); self.init_ui(); self.init_tray(); self.init_shortcuts()

        # GPU Timer
        self.gpu_timer = QTimer(self); self.gpu_timer.timeout.connect(self.sync_with_gpu)

        self.read_current_config_direct(); self.load_user_presets(); self.update_tray_icon()

    def ask_for_sudo_password(self):
        s = STRINGS[self.lang]; passw, ok = QInputDialog.getText(None, s["sudo_title"], s["sudo_msg"], QLineEdit.Password)
        if ok and passw: self.user_password = passw
        else: sys.exit()

    def check_driver(self):
        if not os.path.exists(BASE_PATH):
            cmds = ["depmod -a", "modprobe omen-rgb-keyboard"]
            full_cmd = f"echo '{self.user_password}' | sudo -S sh -c \"{' ; '.join(cmds)}\""
            subprocess.run(full_cmd, shell=True, capture_output=True)

    def apply_theme_engine(self):
        pal = self.palette(); bg, txt, base = pal.window().color().name(), pal.windowText().color().name(), pal.base().color().name()
        self.accent_color = pal.highlight().color().name()
        border = pal.window().color().lighter(115).name() if pal.window().color().value() < 128 else pal.window().color().darker(110).name()
        self.setStyleSheet(f"QMainWindow {{ background: {bg}; color: {txt}; }} QFrame#styledCard {{ background: {pal.alternateBase().color().name()}; border: 1px solid {border}; border-radius: 12px; }} QLabel {{ color: {txt}; }} QPushButton {{ background: {pal.button().color().name()}; color: {pal.buttonText().color().name()}; border: 1px solid {border}; border-radius: 8px; padding: 6px; }} QPushButton:hover {{ background: {self.accent_color}; color: {pal.highlightedText().color().name()}; }} QComboBox, QLineEdit {{ background: {base}; color: {txt}; border: 1px solid {border}; padding: 4px; border-radius: 4px; }} QSlider::handle:horizontal {{ background: {self.accent_color}; border-radius: 5px; width: 14px; height: 14px; }} QScrollArea {{ border: none; background: transparent; }}")

    def animate_zone_ui(self, idx, target_hex):
        start_color = QColor(self.previews[idx].palette().window().color())
        end_color = QColor(f"#{target_hex.lstrip('#')}")
        anim = QVariantAnimation(self); anim.setDuration(400); anim.setStartValue(start_color); anim.setEndValue(end_color); anim.setEasingCurve(QEasingCurve.InOutQuad)
        border_col = self.palette().windowText().color().name()
        anim.valueChanged.connect(lambda c: self.previews[idx].setStyleSheet(f"background-color: {c.name()}; border: 2px solid {border_col}; border-radius: 8px;"))
        anim.start(); self._anims[idx] = anim

    def init_ui(self):
        s = STRINGS[self.lang]; self.setWindowTitle(s["title"]); central = QWidget(); self.setCentralWidget(central); main_layout = QHBoxLayout(central); left_panel = QVBoxLayout()
        zone_card = QFrame(); zone_card.setObjectName("styledCard"); zone_layout = QVBoxLayout(zone_card); header = QHBoxLayout(); header.addWidget(QLabel(f"<b>{s['zones_cfg']}:</b>"))
        self.btn_set = QPushButton(); self.btn_set.setIcon(self.style().standardIcon(QStyle.SP_FileDialogDetailedView)); self.btn_set.setFixedSize(40, 40); self.btn_set.clicked.connect(self.open_settings); header.addStretch(); header.addWidget(self.btn_set); zone_layout.addLayout(header)
        grid = QGridLayout(); border_col = self.palette().windowText().color().name()
        for i in range(4):
            vbox = QVBoxLayout(); prev = QFrame(); prev.setFixedSize(100, 50); prev.setStyleSheet(f"background: #000; border: 2px solid {border_col}; border-radius: 8px;")
            self.previews.append(prev); btn = QPushButton(f"S{i+1}"); btn.clicked.connect(lambda ch, idx=i: self.pick_zone_color(idx)); btn.setToolTip(f"{s['tip_zone']} {i+1}"); vbox.addWidget(prev); vbox.addWidget(btn); grid.addLayout(vbox, 0, i)
        zone_layout.addLayout(grid); self.btn_grad = QPushButton(s["gen_grad"]); self.btn_grad.clicked.connect(self.generate_gradient); zone_layout.addWidget(self.btn_grad)
        self.btn_save_main = QPushButton(s["save_preset_btn"]); self.btn_save_main.setFixedHeight(45); self.btn_save_main.clicked.connect(self.save_current_as_preset); zone_layout.addWidget(self.btn_save_main); left_panel.addWidget(zone_card)
        anim_card = QFrame(); anim_card.setObjectName("styledCard"); anim_grid = QGridLayout(anim_card); self.mode_box = QComboBox(); self.mode_box.addItems(["static", "breathing", "rainbow", "wave", "pulse", "chase", "sparkle", "candle", "aurora", "disco", "gradient", "NVIDIA Sync"])
        anim_grid.addWidget(QLabel(s["mode_label"]), 0, 0); anim_grid.addWidget(self.mode_box, 0, 1)
        self.mode_box.currentTextChanged.connect(self.handle_mode_change)
        self.speed_slider = QSlider(Qt.Horizontal); self.speed_slider.setRange(1, 9); self.speed_slider.setValue(5); anim_grid.addWidget(QLabel(s["speed_label"]), 1, 0); anim_grid.addWidget(self.speed_slider, 1, 1)
        self.bright_slider = QSlider(Qt.Horizontal); self.bright_slider.setRange(0, 100); self.bright_slider.setValue(100); anim_grid.addWidget(QLabel(s["bright_label"]), 2, 0); anim_grid.addWidget(self.bright_slider, 2, 1); left_panel.addWidget(anim_card); left_panel.addStretch()
        actions = QHBoxLayout(); self.btn_off = QPushButton(s["turn_off"]); self.btn_off.setFixedHeight(70); self.btn_off.setStyleSheet("background: #a93226; color: white; font-weight: bold;"); self.btn_off.clicked.connect(self.turn_off_all)
        self.btn_app = QPushButton(s["apply"]); self.btn_app.setFixedHeight(70); self.btn_app.setStyleSheet(f"background: {self.accent_color}; color: white; font-weight: bold;"); self.btn_app.clicked.connect(self.apply_all_combined); actions.addWidget(self.btn_off, 30); actions.addWidget(self.btn_app, 70); left_panel.addLayout(actions); main_layout.addLayout(left_panel, 40)
        right_panel = QVBoxLayout(); presets_card = QFrame(); presets_card.setObjectName("styledCard"); presets_layout = QVBoxLayout(presets_card); p_header = QHBoxLayout(); p_header.addWidget(QLabel(f"<b>{s['my_presets']}:</b>"))
        self.btn_i = QPushButton(); self.btn_i.setIcon(self.style().standardIcon(QStyle.SP_DialogOpenButton)); self.btn_i.setFixedSize(40, 40); self.btn_i.clicked.connect(self.import_preset_from_file); self.btn_e = QPushButton(); self.btn_e.setIcon(self.style().standardIcon(QStyle.SP_DialogSaveButton)); self.btn_e.setFixedSize(40, 40); self.btn_e.clicked.connect(self.export_preset_to_file); p_header.addStretch(); p_header.addWidget(self.btn_i); p_header.addWidget(self.btn_e); presets_layout.addLayout(p_header)
        self.scroll = QScrollArea(); self.scroll.setWidgetResizable(True); self.p_widget = QWidget(); self.p_layout = QGridLayout(self.p_widget); self.p_layout.setAlignment(Qt.AlignTop); self.scroll.setWidget(self.p_widget); presets_layout.addWidget(self.scroll); right_panel.addWidget(presets_card); main_layout.addLayout(right_panel, 60)

    def handle_mode_change(self, mode):
        if mode == "NVIDIA Sync": self.gpu_timer.start(2000)
        else: self.gpu_timer.stop()

    def sync_with_gpu(self):
        try:
            res = subprocess.run(["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"], capture_output=True, text=True)
            if res.returncode == 0:
                temp = int(res.stdout.strip())
                r = int(min(255, max(0, (temp - 35) * 6.375))) # Start od 35st
                g = int(min(255, max(0, 255 - (temp - 35) * 6.375)))
                gpu_hex = f"{r:02X}{g:02X}00"
                self.strefy_hex = [gpu_hex] * 4
                for i in range(4): self.animate_zone_ui(i, gpu_hex)
                self.apply_all_combined()
        except: self.gpu_timer.stop()

    def apply_all_combined(self):
        if not os.path.exists(BASE_PATH): return
        m, s, b, cmds = self.mode_box.currentText(), self.speed_slider.value(), self.bright_slider.value(), []
        if m == "static" or m == "NVIDIA Sync":
            for i in range(4): cmds.append(f"echo {self.strefy_hex[i]} > {os.path.join(BASE_PATH, f'zone0{i}')}")
            cmds.append(f"echo 'static' > {os.path.join(BASE_PATH, 'animation_mode')}")
        elif m == "gradient":
            cmds.append(f"echo '0,1,2:FF0000,00FF00,0000FF;3:800080,FFA500' > {os.path.join(BASE_PATH, 'gradient_config')}")
            cmds.append(f"echo 'gradient' > {os.path.join(BASE_PATH, 'animation_mode')}")
        else:
            cmds.append(f"echo {' '.join(self.strefy_hex)} > {os.path.join(BASE_PATH, 'all')}"); cmds.append(f"echo {m} > {os.path.join(BASE_PATH, 'animation_mode')}")
        cmds.append(f"echo {s} > {os.path.join(BASE_PATH, 'animation_speed')}"); cmds.append(f"echo {b} > {os.path.join(BASE_PATH, 'brightness')}")
        full_cmd = f"echo '{self.user_password}' | sudo -S sh -c \"{' ; '.join(cmds)}\""
        if subprocess.run(full_cmd, shell=True, capture_output=True).returncode != 0: self.ask_for_sudo_password()
        self.update_tray_icon()

    def load_user_presets(self):
        s = STRINGS[self.lang]; [self.p_layout.takeAt(0).widget().deleteLater() for _ in range(self.p_layout.count()) if self.p_layout.itemAt(0).widget()]
        if not os.path.exists(self.presets_file): return
        try:
            with open(self.presets_file, "r") as f:
                data = json.load(f)
                for i, p in enumerate(data.get("presets", [])):
                    cl = p['colors']; card = QFrame(); card.setObjectName("styledCard"); card.setFixedHeight(100); layout = QHBoxLayout(card); ring = QFrame(); ring.setFixedSize(54, 54)
                    g = f"qconicalgradient(cx:0.5, cy:0.5, angle:0, stop:0 #{cl[0]}, stop:0.25 #{cl[1]}, stop:0.5 #{cl[2]}, stop:0.75 #{cl[3]}, stop:1 #{cl[0]})"
                    ring.setStyleSheet(f"border-radius: 27px; border: 2px solid white; background: {g};"); layout.addWidget(ring); layout.addWidget(QLabel(f"<b>{p['name']}</b>")); layout.addStretch()
                    for icon, tip, func in [("⚡", s["tip_load"], lambda ch, pr=p: self.quick_apply(pr)), ("✏️", s["tip_rename"], lambda ch, n=p['name']: self.rename_preset(n)), ("🗑️", s["tip_delete"], lambda ch, n=p['name']: self.delete_preset(n))]:
                        b = QPushButton(icon); b.setFixedSize(38, 38); b.setToolTip(tip); b.clicked.connect(func); layout.addWidget(b)
                    self.p_layout.addWidget(card, i // 2, i % 2)
        except: pass
        self.update_tray_menu()

    def rename_preset(self, old_name):
        s = STRINGS[self.lang]; n, ok = QInputDialog.getText(self, s["rename_title"], s["new_preset_name"], text=old_name)
        if ok and n:
            with open(self.presets_file, "r") as f: data = json.load(f)
            for p in data.get("presets", []):
                if p['name'] == old_name: p['name'] = n; break
            with open(self.presets_file, "w") as f: json.dump(data, f, indent=4)
            self.load_user_presets()

    def delete_preset(self, name):
        s = STRINGS[self.lang]
        if QMessageBox.question(self, "Preset", f"{s['del_ask']} ({name})") == QMessageBox.Yes:
            with open(self.presets_file, "r") as f: data = json.load(f)
            data["presets"] = [p for p in data["presets"] if p['name'] != name]
            with open(self.presets_file, "w") as f: json.dump(data, f, indent=4)
            self.load_user_presets()

    def generate_gradient(self):
        c1, c4 = QColor(f"#{self.strefy_hex[0]}"), QColor(f"#{self.strefy_hex[3]}")
        for i in range(1, 3):
            ratio = i / 3.0; r, g, b = [int(getattr(c1, x)() + (getattr(c4, x)() - getattr(c1, x)()) * ratio) for x in ["red", "green", "blue"]]
            new_hex = QColor(r, g, b).name().lstrip('#').upper(); self.strefy_hex[i] = new_hex; self.animate_zone_ui(i, new_hex)
        self.update_tray_icon()

    def update_tray_icon(self):
        if not self.dynamic_icon: self.tray_icon.setIcon(self.style().standardIcon(QStyle.SP_ComputerIcon)); return
        try:
            pix = QPixmap(64, 64); pix.fill(Qt.transparent); p = QPainter(pix); p.setRenderHint(QPainter.Antialiasing); grad = QConicalGradient(QPointF(32, 32), 0)
            for i in range(4): grad.setColorAt(i*0.25, QColor(f"#{self.strefy_hex[i]}"))
            grad.setColorAt(1, QColor(f"#{self.strefy_hex[0]}")); p.setBrush(grad); p.setPen(Qt.NoPen); p.drawEllipse(4, 4, 56, 56); p.end(); self.tray_icon.setIcon(QIcon(pix))
        except: pass

    def load_preset(self, pr):
        self.strefy_hex = list(pr['colors']); self.current_preset_name = pr.get('name', 'current_preset')
        for i, c in enumerate(self.strefy_hex): self.animate_zone_ui(i, c)
        idx = self.mode_box.findText("static"); [self.mode_box.setCurrentIndex(idx) if idx >= 0 else None]; self.update_tray_icon()

    def pick_zone_color(self, idx):
        color = QColorDialog.getColor(QColor(f"#{self.strefy_hex[idx]}"), self)
        if color.isValid():
            new_h = color.name().lstrip('#').upper(); self.strefy_hex[idx] = new_h; self.animate_zone_ui(idx, new_h); self.update_tray_icon()

    def turn_off_all(self):
        if not os.path.exists(BASE_PATH): return
        full_cmd = f"echo '{self.user_password}' | sudo -S sh -c \"echo 0 > {os.path.join(BASE_PATH, 'brightness')}\""; subprocess.run(full_cmd, shell=True); self.bright_slider.setValue(0); self.update_tray_icon()

    def save_current_as_preset(self):
        s = STRINGS[self.lang]; n, ok = QInputDialog.getText(self, s["new_preset_title"], s["new_preset_name"]); [self.add_to_presets(n, list(self.strefy_hex)) if ok and n else None]

    def add_to_presets(self, name, colors):
        os.makedirs(self.presets_dir, exist_ok=True); data = {"presets": [], "stay_in_tray": True, "dynamic_icon": True, "lang": self.lang}
        if os.path.exists(self.presets_file):
            with open(self.presets_file, "r") as f: data = json.load(f)
        data["presets"] = [p for p in data.get("presets", []) if p['name'] != name]; data["presets"].append({"name": name, "colors": colors})
        with open(self.presets_file, "w") as f: json.dump(data, f, indent=4)
        self.load_user_presets()

    def import_preset_from_file(self):
        paths, _ = QFileDialog.getOpenFileNames(self, "Import", self.presets_dir, "JSON (*.json)")
        if paths:
            for path in paths:
                with open(path, "r") as f: imp = json.load(f); self.add_to_presets(imp.get("name", "Imported"), imp["colors"])

    def export_preset_to_file(self):
        path, _ = QFileDialog.getSaveFileName(self, "Export", os.path.join(self.presets_dir, f"{self.current_preset_name}.json"), "JSON (*.json)")
        if path:
            with open(path, "w") as f: json.dump({"name": self.current_preset_name, "colors": list(self.strefy_hex)}, f, indent=4)

    def read_current_config_direct(self):
        if not os.path.exists(BASE_PATH): return
        try:
            for i in range(4):
                f_p = os.path.join(BASE_PATH, f"zone0{i}")
                if os.path.exists(f_p):
                    with open(f_p, "r") as f:
                        val = f.read().strip().replace('#', '').upper(); [self.animate_zone_ui(i, val) if len(val) == 6 else None]; self.strefy_hex[i] = val
            b_p = os.path.join(BASE_PATH, "brightness")
            if os.path.exists(b_p):
                with open(b_p, "r") as f: self.bright_slider.setValue(int(f.read().strip()))
        except: pass

    def load_settings_only(self):
        if os.path.exists(self.presets_file):
            try:
                with open(self.presets_file, "r") as f: data = json.load(f); self.stay_in_tray, self.dynamic_icon, self.lang = data.get("stay_in_tray", True), data.get("dynamic_icon", True), data.get("lang", "pl")
            except: pass
        else: self.stay_in_tray, self.dynamic_icon = True, True

    def save_settings_only(self):
        data = {"presets": [], "stay_in_tray": self.stay_in_tray, "dynamic_icon": self.dynamic_icon, "lang": self.lang}
        if os.path.exists(self.presets_file):
            with open(self.presets_file, "r") as f: data["presets"] = json.load(f).get("presets", [])
        with open(self.presets_file, "w") as f: json.dump(data, f, indent=4)

    def init_tray(self): self.tray_icon = QSystemTrayIcon(self); self.update_tray_icon(); self.update_tray_menu(); self.tray_icon.show()
    def update_tray_menu(self):
        s = STRINGS[self.lang]; menu = QMenu(); menu.addAction(s["show_win"], self.showNormal); menu.addSeparator()
        if os.path.exists(self.presets_file):
            try:
                with open(self.presets_file, "r") as f:
                    for p in json.load(f).get("presets", []): menu.addAction(f"⚡ {p['name']}", lambda pr=p: self.quick_apply(pr))
            except: pass
        menu.addSeparator(); menu.addAction(s["quit_app"], QApplication.instance().quit); self.tray_icon.setContextMenu(menu)

    def quick_apply(self, pr): self.load_preset(pr); self.apply_all_combined()
    def init_shortcuts(self): QShortcut(QKeySequence("Ctrl+S"), self).activated.connect(self.apply_all_combined)
    def open_settings(self):
        d = SettingsDialog(self, self.stay_in_tray, self.dynamic_icon, self.lang, self.config_dir)
        if d.exec(): self.stay_in_tray, self.dynamic_icon, self.lang = d.tray_checkbox.isChecked(), d.icon_checkbox.isChecked(), ("pl" if d.lang_box.currentIndex() == 0 else "en"); self.save_settings_only(); self.update_ui_texts(); self.update_tray_icon(); self.apply_theme_engine()
    def update_ui_texts(self): s = STRINGS[self.lang]; self.setWindowTitle(s["title"]); self.btn_save_main.setText(s["save_preset_btn"]); self.btn_off.setText(s["turn_off"]); self.btn_app.setText(s["apply"]); self.btn_grad.setText(s["gen_grad"]); self.load_user_presets()
    def closeEvent(self, event): [self.hide() if self.stay_in_tray else QApplication.quit(), event.ignore() if self.stay_in_tray else None]

if __name__ == "__main__":
    app = QApplication(sys.argv); window = OmenUltimateMaster(); window.show(); sys.exit(app.exec())
