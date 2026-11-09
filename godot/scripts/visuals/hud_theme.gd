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

# Quiet ink, jade and bronze treatment. No copied reference art or glyphs.
const INK := Color("171e19")
const PANEL_BG := Color("1c2823")
const PANEL_BORDER := Color("a78b52")
const ACCENT := Color("d8bc78")
const ACCENT_TEXT := Color("fff0c9")
const ACCENT_GLOW := Color(0, 0, 0, 0)
const TEXT_MAIN := Color("f3eedc")
const TEXT_DIM := Color("b7c3b4")
const GOLD := Color("d8bc78")
const OUTLINE := Color(0.025, 0.035, 0.025, 0.92)
const DIMMER := Color(0.025, 0.035, 0.025, 0.62)

const BTN_BG := Color(0.10, 0.16, 0.13, 0.94)
const BTN_BG_HOVER := Color("344d3b")
const BTN_BG_PRESSED := Color("15261c")
const BTN_BORDER := Color("8d8059")
const PRIMARY_BG := Color("244333")
const PRIMARY_BG_HOVER := Color("3c5840")
const PRIMARY_BG_PRESSED := Color("172c21")
const PAD_BG := Color(0.07, 0.12, 0.09, 0.78)
const PAD_BG_HOVER := Color(0.15, 0.24, 0.17, 0.88)
const PAD_BG_PRESSED := Color(0.22, 0.34, 0.23, 0.95)
const PAD_BORDER := Color(0.73, 0.64, 0.40, 0.80)

const MOON_CHIP := "res://assets/visuals/ui/moon_chip.png"
const TOGGLE_ON_PNG := "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"
const TOGGLE_OFF_PNG := "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"

# Shortened copy: same meaning, less screen coverage.
const INTRO_WORDS := "The eclipse shattered the Moon Bridge. Gather the five pieces and guide Mochi home."
const LEVEL_HINTS := [
	"Gather six dew drops. Jump the bales, dodge the bees.",
	"Silver Moon: long hops over the crater lips.",
	"Cinnamon Moon: slide under branches. Help the firefly.",
	"Storm Moon: jump waves. Slide under lightning arches.",
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
	frame.add_theme_stylebox_override("panel", _flat(PANEL_BG, PANEL_BORDER, 1, 4, Color(0, 0, 0, 0.45), 14))
	_style_tree(frame)


static func style_primary(btn: Button) -> void:
	_apply_button(btn,
		_flat(PRIMARY_BG, ACCENT, 2, 4),
		_flat(PRIMARY_BG_HOVER, ACCENT, 2, 4),
		_flat(PRIMARY_BG_PRESSED, ACCENT_TEXT, 2, 4))
	var icon: Texture2D = load(MOON_CHIP) if ResourceLoader.exists(MOON_CHIP) else null
	if icon != null: btn.icon = icon; btn.add_theme_color_override("icon_normal_color", GOLD); btn.add_theme_color_override("icon_hover_color", ACCENT_TEXT); btn.add_theme_color_override("icon_pressed_color", ACCENT_TEXT)


static func style_pad(btn: Button) -> void:
	_apply_button(btn,
		_flat(PAD_BG, PAD_BORDER, 1, 5),
		_flat(PAD_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 5),
		_flat(PAD_BG_PRESSED, ACCENT, 1, 5))


static func style_small_ghost(btn: Button) -> void:
	_apply_button(btn,
		_flat(PAD_BG, PAD_BORDER, 1, 4),
		_flat(BTN_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 4),
		_flat(BTN_BG_PRESSED, ACCENT, 1, 4))


static func style_hud(label: Label) -> void:
	_label(label, TEXT_MAIN, 2)
	# Content-sized telemetry chip, never a full-width gameplay mask.
	var chip := _flat(Color(0.07,0.12,0.09,0.72),PAD_BORDER,0,5)
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
	return Color("c9b783")


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
			_flat(BTN_BG, BTN_BORDER, 1, 4),
			_flat(BTN_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 4),
			_flat(BTN_BG_PRESSED, ACCENT, 1, 4))
	elif node is Label:
		_label(node, TEXT_MAIN, 0)
	elif node is PanelContainer:
		node.add_theme_stylebox_override("panel", _flat(PANEL_BG, PANEL_BORDER, 1, 4))


static func _apply_button(btn: Button, normal: StyleBoxFlat, hover: StyleBoxFlat, pressed: StyleBoxFlat) -> void:
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_stylebox_override("focus", _flat(Color(0, 0, 0, 0), ACCENT, 1, 4))
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
	var on_icon: Texture2D = _toggle_texture(true)
	var off_icon: Texture2D = _toggle_texture(false)
	if on_icon != null: btn.add_theme_icon_override("checked", on_icon)
	if off_icon != null: btn.add_theme_icon_override("unchecked", off_icon)
	btn.add_theme_stylebox_override("hover", _flat(PAD_BG_HOVER, Color(0, 0, 0, 0), 0, 4))
	btn.add_theme_stylebox_override("focus", _flat(Color(0, 0, 0, 0), ACCENT, 1, 4))
	btn.add_theme_color_override("font_color", TEXT_MAIN)
	btn.add_theme_color_override("font_hover_color", ACCENT_TEXT)
	btn.add_theme_color_override("font_disabled_color", TEXT_DIM.darkened(0.35))


static func _style_option(ob: OptionButton) -> void:
	_apply_button(ob,
		_flat(BTN_BG, BTN_BORDER, 1, 4),
		_flat(BTN_BG_HOVER, ACCENT_SOFT_BORDER(), 1, 4),
		_flat(BTN_BG_PRESSED, ACCENT, 1, 4))
	var popup := ob.get_popup()
	popup.add_theme_stylebox_override("panel", _flat(PANEL_BG, PANEL_BORDER, 1, 10, Color(0, 0, 0, 0.5), 10))
	popup.add_theme_stylebox_override("hover", _flat(BTN_BG_HOVER, Color(0, 0, 0, 0), 0, 6))
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

# Exact tiny palette variants are embedded for offline text-only source recovery.
static var _toggle_on: Texture2D
static var _toggle_off: Texture2D
static func _toggle_texture(enabled: bool) -> Texture2D:
	if enabled and _toggle_on != null: return _toggle_on
	if not enabled and _toggle_off != null: return _toggle_off
	var image := Image.new()
	var error := image.load_png_from_buffer(Marshalls.base64_to_raw(TOGGLE_ON_PNG if enabled else TOGGLE_OFF_PNG))
	if error != OK: return null
	var texture := ImageTexture.create_from_image(image)
	if enabled: _toggle_on = texture
	else: _toggle_off = texture
	return texture
