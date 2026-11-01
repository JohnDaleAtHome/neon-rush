class_name NeonHudTheme
extends RefCounted
## Moon-themed HUD styling for Mochi and the Moon Bridge.
##
## Isolated visual module: pure styling, no gameplay or layout changes.
## Integration (owned by the builder agent):
##   1. After the UI is built in _ready(), call:
##        NeonHudTheme.apply(root, {
##            "primary": action, "pad": controls, "pause": pause_button,
##            "hud": hud, "title": message, "status": status_label,
##            "progress": progress_label, "dimmer": dimmer})
##   2. At the end of open_settings() and open_stats(), call:
##        NeonHudTheme.style_popup(list)
##   3. Optionally swap the long intro/banner strings for the SHORT_* /
##      LEVEL_HINTS / mode_hint() constants below.
## The module never changes custom_minimum_size, positions, anchors or
## visibility: touch targets and layout stay exactly as main.gd sets them.

# Palette sampled from docs/concept-art/mochi-main-character.webp:
# deep-space navy ground, cyan glow accents (Mochi's eyes), pale moon gold.
const INK := Color("070e1e")
const PANEL_BG := Color(0.055, 0.082, 0.18, 1.0)
const PANEL_BORDER := Color(0.24, 0.36, 0.62, 0.90)
const ACCENT := Color("67e8f9")
const ACCENT_TEXT := Color("a5f3fc")
const ACCENT_GLOW := Color(0.40, 0.85, 0.98, 0.22)
const TEXT_MAIN := Color("eaf4ff")
const TEXT_DIM := Color("9db4d8")
const GOLD := Color("ffd97a")
const OUTLINE := Color(0.015, 0.025, 0.07, 0.92)
const DIMMER := Color(0.02, 0.035, 0.09, 0.62)

const BTN_BG := Color(0.070, 0.105, 0.220, 0.82)
const BTN_BG_HOVER := Color(0.105, 0.165, 0.335, 0.92)
const BTN_BG_PRESSED := Color(0.045, 0.070, 0.150, 0.95)
const BTN_BORDER := Color(0.28, 0.42, 0.72, 0.55)
const PRIMARY_BG := Color(0.085, 0.270, 0.440, 0.96)
const PRIMARY_BG_HOVER := Color(0.125, 0.370, 0.585, 0.98)
const PRIMARY_BG_PRESSED := Color(0.055, 0.185, 0.310, 0.98)
const PAD_BG := Color(0.025, 0.045, 0.105, 0.66)
const PAD_BG_HOVER := Color(0.090, 0.140, 0.280, 0.66)
const PAD_BG_PRESSED := Color(0.140, 0.330, 0.470, 0.78)
const PAD_BORDER := Color(0.40, 0.85, 0.98, 0.35)

const MOON_CHIP := "res://assets/visuals/ui/moon_chip.png"
const TOGGLE_ON := "res://assets/visuals/ui/toggle_on.png"
const TOGGLE_OFF := "res://assets/visuals/ui/toggle_off.png"

# Shortened copy: same meaning, less screen coverage.
const INTRO_WORDS := "The eclipse shattered the Moon Bridge. Gather the five pieces and guide Mochi home."
const LEVEL_HINTS := [
	"Gather six dew drops. Jump the bales, dodge the bees.",
	"Long hops over the crater lips.",
	"Slide under the branches. Help the firefly.",
	"Jump the waves. Slide under the lightning arches.",
	"Gather light. Hits let the shadow closer.",
	"Five lights open the palace. FIRE when the shield falls.",
]

static func mode_hint(mode: String) -> String:
	match mode:
		"chase": return "Collect light, avoid hits. Slide under blue arches."
		"mission": return "Gather six mochi, cross the frost moon, face the guardian."
		_: return "Jump low blocks, dodge tall blocks. Three treats build a magnet chain."


static func apply(root: Control, roles: Dictionary = {}) -> void:
	_style_tree(root)
	if roles.get("primary") is Button: style_primary(roles["primary"])
	if roles.get("pause") is Button: style_small_ghost(roles["pause"])
	if roles.get("pad") is Container:
		for child in roles["pad"].get_children():
			if child is Button: style_pad(child)
	if roles.get("hud") is Label: style_hud(roles["hud"])
	if roles.get("title") is Label: style_title(roles["title"])
	if roles.get("status") is Label: style_status(roles["status"])
	if roles.get("progress") is Label: style_progress(roles["progress"])
	if roles.get("dimmer") is ColorRect: roles["dimmer"].color = DIMMER


## Accepts the popup PanelContainer or any Control inside it (e.g. the
## content list returned by popup_frame()).
static func style_popup(node: Control) -> void:
	var frame: Control = node
	while frame != null and not (frame is PanelContainer):
		frame = frame.get_parent()
	if frame == null: return
	frame.add_theme_stylebox_override("panel", _flat(PANEL_BG, PANEL_BORDER, 1, 16, Color(0, 0, 0, 0.45), 14))
	_style_tree(frame)


static func style_primary(btn: Button) -> void:
	_apply_button(btn,
		_flat(PRIMARY_BG, ACCENT, 2, 14, ACCENT_GLOW, 10),
		_flat(PRIMARY_BG_HOVER, ACCENT, 2, 14, ACCENT_GLOW, 14),
		_flat(PRIMARY_BG_PRESSED, ACCENT_TEXT, 2, 14, ACCENT_GLOW, 6))
	var icon: Texture2D = load(MOON_CHIP) if ResourceLoader.exists(MOON_CHIP) else null
	if icon != null: btn.icon = icon


static func style_pad(btn: Button) -> void:
	_apply_button(btn,
		_flat(PAD_BG, PAD_BORDER, 1, 5),
		_flat(PAD_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 5),
		_flat(PAD_BG_PRESSED, ACCENT, 1, 5))


static func style_small_ghost(btn: Button) -> void:
	_apply_button(btn,
		_flat(Color(0.045, 0.070, 0.150, 0.55), PAD_BORDER, 1, 10),
		_flat(BTN_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 10),
		_flat(BTN_BG_PRESSED, ACCENT, 1, 10))


static func style_hud(label: Label) -> void:
	_label(label, Color("d8ecff"), 2)
	# Content-sized telemetry chip, never a full-width gameplay mask.
	var chip := _flat(Color(0.025,0.045,0.105,0.72),Color(0.30,0.76,0.83,0.7),0,5)
	chip.border_width_left = 2
	chip.content_margin_left = 10
	chip.content_margin_right = 10
	chip.content_margin_top = 5
	chip.content_margin_bottom = 5
	label.add_theme_stylebox_override("normal",chip)


static func style_title(label: Label) -> void:
	_label(label, TEXT_MAIN, 5)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.55))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 2)


static func style_status(label: Label) -> void:
	_label(label, ACCENT_TEXT, 4)


static func style_progress(label: Label) -> void:
	_label(label, Color("ffe9b0"), 4)


static func ACCENT_SOFT_BORDER() -> Color:
	return Color(0.40, 0.85, 0.98, 0.65)


static func _style_tree(node: Control) -> void:
	_style_one(node)
	for child in node.get_children():
		if child is Control: _style_tree(child)


static func _style_one(node: Control) -> void:
	if node is CheckButton:
		_style_check(node)
	elif node is OptionButton:
		_style_option(node)
	elif node is Button:
		_apply_button(node,
			_flat(BTN_BG, BTN_BORDER, 1, 10),
			_flat(BTN_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 10),
			_flat(BTN_BG_PRESSED, ACCENT, 1, 10))
	elif node is Label:
		_label(node, TEXT_MAIN, 0)
	elif node is PanelContainer:
		node.add_theme_stylebox_override("panel", _flat(PANEL_BG, PANEL_BORDER, 1, 14))


static func _apply_button(btn: Button, normal: StyleBoxFlat, hover: StyleBoxFlat, pressed: StyleBoxFlat) -> void:
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_stylebox_override("focus", _flat(Color(0, 0, 0, 0), ACCENT, 1, 10))
	btn.add_theme_color_override("font_color", TEXT_MAIN)
	btn.add_theme_color_override("font_hover_color", ACCENT_TEXT)
	btn.add_theme_color_override("font_pressed_color", ACCENT_TEXT)
	btn.add_theme_color_override("font_focus_color", TEXT_MAIN)
	btn.add_theme_color_override("font_disabled_color", TEXT_DIM.darkened(0.35))
	btn.add_theme_color_override("icon_normal_color", TEXT_MAIN)
	btn.add_theme_color_override("icon_hover_color", ACCENT_TEXT)
	btn.add_theme_color_override("icon_pressed_color", ACCENT_TEXT)


static func _style_check(btn: CheckButton) -> void:
	# CheckButtons stay chromeless; swap the default toggle art for moon pills.
	var on_icon: Texture2D = load(TOGGLE_ON) if ResourceLoader.exists(TOGGLE_ON) else null
	var off_icon: Texture2D = load(TOGGLE_OFF) if ResourceLoader.exists(TOGGLE_OFF) else null
	if on_icon != null: btn.add_theme_icon_override("checked", on_icon)
	if off_icon != null: btn.add_theme_icon_override("unchecked", off_icon)
	btn.add_theme_stylebox_override("hover", _flat(Color(0.10, 0.16, 0.32, 0.45), Color(0, 0, 0, 0), 0, 8))
	btn.add_theme_stylebox_override("focus", _flat(Color(0, 0, 0, 0), ACCENT, 1, 8))
	btn.add_theme_color_override("font_color", TEXT_MAIN)
	btn.add_theme_color_override("font_hover_color", ACCENT_TEXT)
	btn.add_theme_color_override("font_disabled_color", TEXT_DIM.darkened(0.35))


static func _style_option(ob: OptionButton) -> void:
	_apply_button(ob,
		_flat(BTN_BG, BTN_BORDER, 1, 10),
		_flat(BTN_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 10),
		_flat(BTN_BG_PRESSED, ACCENT, 1, 10))
	var popup := ob.get_popup()
	popup.add_theme_stylebox_override("panel", _flat(PANEL_BG, PANEL_BORDER, 1, 10, Color(0, 0, 0, 0.5), 10))
	popup.add_theme_stylebox_override("hover", _flat(Color(0.16, 0.30, 0.50, 0.95), Color(0, 0, 0, 0), 0, 6))
	popup.add_theme_color_override("font_color", TEXT_MAIN)
	popup.add_theme_color_override("font_hover_color", ACCENT_TEXT)
	popup.add_theme_color_override("font_disabled_color", TEXT_DIM.darkened(0.35))
	popup.add_theme_color_override("font_separator_color", TEXT_DIM)


static func _label(label: Label, color: Color, outline: int) -> void:
	label.add_theme_color_override("font_color", color)
	if outline > 0:
		label.add_theme_color_override("font_outline_color", OUTLINE)
		label.add_theme_constant_override("outline_size", outline)


static func _flat(bg: Color, border: Color, border_w: int, radius: int, shadow: Color = Color(0, 0, 0, 0), shadow_size: int = 0) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = bg
	box.border_color = border
	box.set_border_width_all(border_w)
	box.set_corner_radius_all(radius)
	box.corner_detail = 6
	box.anti_aliasing = true
	if shadow_size > 0:
		box.shadow_color = shadow
		box.shadow_size = shadow_size
		box.shadow_offset = Vector2(0, 2)
	box.content_margin_left = 14
	box.content_margin_right = 14
	box.content_margin_top = 8
	box.content_margin_bottom = 8
	return box
