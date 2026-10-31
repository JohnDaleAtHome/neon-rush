extends Node3D

const LANES = [-2.2, 0.0, 2.2]
const LEVEL_NAMES = ["Neon Meadow", "Silver Dunes", "Cinnamon Grove", "Storm Sea", "Shadow Comet", "Guanghan Palace"]
const PIECES = ["Moon Dew Vial", "Silver Lantern", "Cinnamon Blossom", "Tide Pearl", "Eclipse Key"]
const COLORS = [Color("194b36"), Color("a49db7"), Color("745032"), Color("184b68"), Color("38253f"), Color("b18c67")]
var mode = "story"
var discard_pending = ""
var fresh_button: Button
var guardian_feedback = ""
var guardian_feedback_time = 0.0
var mode_select: OptionButton
var mode_names = ["story", "easy", "normal", "hard", "chase", "mission"]
var score = 0.0
var distance = 0.0
var collected = 0
var chain = 0
var chain_time = 0.0
var chain_bonus = 0
var jump_bonus = 0
var jump_buffer = 0.0
var risk_bonus = 0
var pickup_feedback = ""
var pickup_feedback_time = 0.0
var shield = false
var shield_time = 12.0
var magnet_time = 0.0
var stats: Dictionary = {}
var options: Dictionary = {"sound": false, "light": false, "motion": false, "buttons": true, "large": false, "contrast": false, "tap": true, "swipe": 45, "stars": true, "guides": true, "compact": false, "banners": true, "hand": "center", "color": "pink", "gold": false}
var audio_players: Array[AudioStreamPlayer] = []
var music_player: AudioStreamPlayer
var status_label: Label
var pause_button: Button
var menu_button: Button
var sound_button: Button
var stats_button: Button
var options_button: Button
var unlock = false
var unlock_time = 0.0
var gate: Node3D
var footprints: Array[Node3D] = []
var mission_phase = 0
var mission_cores = 0
var mission_time = 0.0
var touch_origin = Vector2.ZERO
var touch_active = false
var touch_moved = false
var scenery: Node3D
var side_planes: Array[MeshInstance3D] = []
var env_world: WorldEnvironment
var moons: Array[MeshInstance3D] = []
var story_props: Array[Node3D] = []
var settings_panel: PanelContainer
var stats_panel: PanelContainer
var history: Array = []
var gold_unlocked = false
var run_goal = false
var campaign_run_recorded = false
var storage_warning = ""
var jump_scored: Dictionary = {}
var overlay_root: Control
var progress_label: Label
var dimmer: ColorRect
var scene_props: Array[Node3D] = []
var sky_stars: MultiMeshInstance3D
var ground_scroll = 0.0
var lane_guides: Array[MeshInstance3D] = []
var running = false
var paused = false
var lane = 1
var height = 0.0
var velocity = 0.0
var slide_time = 0.0
var speed = 12.0
var elapsed = 0.0
var spawn_time = 1.5
var hearts = 3
var dew = 0
var level = 0
var pieces: Array = []
var entities: Array[Node3D] = []
var player: Node3D
var bunny: Node3D
var animator: AnimationPlayer
var animation_names: Array[StringName] = []
var camera: Camera3D
var ground: MeshInstance3D
var hud: Label
var message: Label
var panel: VBoxContainer
var action: Button
var controls: HBoxContainer
var current_action = ""
var guard = 0.0
var shadow_gap = 20.0
var boss_hp = 4
var boss_clock = 0.0
var boss_lane = 1
var boss: MeshInstance3D
var boss_hits = 0
var last_open = false
var fire_time = 0.0
var pending_advance = false
var rng = RandomNumberGenerator.new()

func material(color: Color, glow = false) -> StandardMaterial3D:
 var m = StandardMaterial3D.new()
 m.albedo_color = color
 m.roughness = 0.9
 if glow:
  m.emission_enabled = true
  m.emission = color * 0.4
 return m

func box(size: Vector3, pos: Vector3, color: Color) -> MeshInstance3D:
 var m = MeshInstance3D.new()
 var mesh = BoxMesh.new()
 mesh.size = size
 m.mesh = mesh
 m.material_override = material(color)
 m.position = pos
 add_child(m)
 return m

func _ready():
 rng.randomize()
 var env = WorldEnvironment.new()
 env_world = env
 var e = Environment.new()
 e.background_mode = Environment.BG_COLOR
 e.background_color = Color("08091c")
 e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
 e.ambient_light_color = Color("b5b4dc")
 e.ambient_light_energy = 0.65
 e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
 env.environment = e
 add_child(env)
 var sun = DirectionalLight3D.new()
 sun.rotation_degrees = Vector3(-40, -25, 0)
 sun.light_energy = 1.7
 add_child(sun)
 camera = Camera3D.new()
 camera.position = Vector3(0, 4.0, 8.5)
 add_child(camera)
 camera.look_at(Vector3(0, 1.0, -10))
 camera.current = true
 ground = MeshInstance3D.new()
 var plane_mesh = PlaneMesh.new()
 plane_mesh.size = Vector2(7.2,150)
 ground.mesh = plane_mesh
 ground.position = Vector3(0,-0.05,-62)
 add_child(ground)
 for lane_x in [-1.1,1.1]:
  var guide = box(Vector3(0.035,0.02,150),Vector3(lane_x,0.025,-62),Color("acc9d3"))
  lane_guides.append(guide)
 for side in [-1, 1]:
  box(Vector3(0.08, 0.08, 150), Vector3(side * 3.6, 0.02, -62), Color("ef67b9"))
 for i in range(3):
  var moon = MeshInstance3D.new()
  var sphere = SphereMesh.new()
  sphere.radius = 4.0 - i * 0.7
  sphere.height = sphere.radius * 2
  moon.mesh = sphere
  var mm = material(Color("b9b4d1"))
  mm.albedo_texture = load("res://assets/moon.jpg")
  moon.material_override = mm
  moon.position = Vector3(-12 + i * 12, 10 + i * 5, -50 - i * 15)
  add_child(moon)
  moons.append(moon)
 player = Node3D.new()
 add_child(player)
 bunny = load("res://assets/bunny.glb").instantiate()
 player.add_child(bunny)
 bunny.scale = Vector3.ONE * 0.55
 find_animator(bunny)
 hide_carrot(bunny)
 build_scenery()
 build_stars()
 var layer = CanvasLayer.new()
 add_child(layer)
 var root = Control.new()
 root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 layer.add_child(root)
 overlay_root = root
 dimmer = ColorRect.new()
 dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 dimmer.color = Color(0.025,0.03,0.06,0.78)
 dimmer.mouse_filter = Control.MOUSE_FILTER_IGNORE
 root.add_child(dimmer)
 hud = Label.new()
 hud.position = Vector2(16, 16)
 hud.add_theme_font_size_override("font_size", 17)
 root.add_child(hud)
 message = Label.new()
 message.position = Vector2(18, 145)
 message.size = Vector2(354, 170)
 message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 message.add_theme_font_size_override("font_size", 16)
 root.add_child(message)
 panel = VBoxContainer.new()
 panel.position = Vector2(25, 365)
 panel.size = Vector2(340, 310)
 root.add_child(panel)
 action = Button.new()
 action.text = "FOLLOW THE SILVER BELL"
 action.custom_minimum_size.y = 56
 action.pressed.connect(on_action)
 panel.add_child(action)
 mode_select = OptionButton.new()
 for label in ["STORY - Moon Bridge", "CHILL", "CLASSIC", "RUSH", "CHASE", "MISSION"]: mode_select.add_item(label)
 mode_select.item_selected.connect(func(i):
  if running: return
  pending_advance = false
  mode = mode_names[i]
  action.text = "START " + mode.to_upper()
  fresh_button.show()
 )
 mode_select.custom_minimum_size.y = 48
 panel.add_child(mode_select)
 fresh_button = Button.new()
 var fresh = fresh_button
 fresh.text = "NEW JOURNEY"
 fresh.custom_minimum_size.y = 48
 fresh.pressed.connect(on_fresh_pressed)
 panel.add_child(fresh)
 sound_button = Button.new()
 sound_button.text = "SOUND OFF"
 sound_button.custom_minimum_size.y = 44
 sound_button.pressed.connect(toggle_sound)
 panel.add_child(sound_button)
 options_button = Button.new()
 options_button.text = "SETTINGS"
 options_button.custom_minimum_size.y = 44
 options_button.pressed.connect(open_settings)
 panel.add_child(options_button)
 stats_button = Button.new()
 stats_button.text = "THIS BROWSER STATS"
 stats_button.custom_minimum_size.y = 44
 stats_button.pressed.connect(show_stats)
 panel.add_child(stats_button)
 menu_button = Button.new()
 menu_button.text = "DISCARD RUN / MAIN MENU"
 menu_button.custom_minimum_size.y = 44
 menu_button.pressed.connect(func(): request_discard("menu"))
 panel.add_child(menu_button)
 menu_button.hide()
 controls = HBoxContainer.new()
 controls.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
 controls.offset_top = -88
 controls.offset_bottom = -24
 controls.offset_left = 8
 controls.offset_right = -8
 root.add_child(controls)
 for entry in [["LEFT", -1], ["JUMP", 0], ["SLIDE", 2], ["RIGHT", 1], ["FIRE", 3]]:
  var btn = Button.new()
  btn.text = entry[0]
  btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  btn.custom_minimum_size = Vector2(68, 56)
  var code: int = entry[1]
  btn.pressed.connect(func(): input_action(code))
  controls.add_child(btn)
 pause_button = Button.new()
 pause_button.text = "PAUSE"
 pause_button.position = Vector2(286, 62)
 pause_button.size = Vector2(88, 44)
 pause_button.pressed.connect(toggle_pause)
 root.add_child(pause_button)
 pause_button.hide()
 status_label = Label.new()
 status_label.position = Vector2(16, 112)
 status_label.size = Vector2(350, 28)
 status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 root.add_child(status_label)
 progress_label = Label.new()
 progress_label.position = Vector2(20,200)
 progress_label.size = Vector2(350,34)
 progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 root.add_child(progress_label)
 get_window().size_changed.connect(configure_window)
 configure_window()
 get_viewport().size_changed.connect(adapt_layout)
 adapt_layout()
 var had_engine_options = FileAccess.file_exists("user://options.json")
 load_stats()
 load_options()
 setup_audio()
 import_legacy_data()
 import_legacy_preferences(had_engine_options)
 load_checkpoint()
 apply_options()
 apply_world(level if mode == "story" else -1)
 show_beat("Mochi and the Moon Bridge", "Mochi is Chang'e's rabbit. The eclipse shattered the bridge. Her silver bell still rings. Gather five pieces and find your way home.", "BEGIN / RESUME JOURNEY")
 print("GODOT_READY ", Engine.get_version_info().string, " animations=", animation_names)

func hide_carrot(node: Node):
 if node is GeometryInstance3D and String(node.name).begins_with("Carrot"): node.hide()
 for child in node.get_children(): hide_carrot(child)

func find_animator(node: Node):
 if node is AnimationPlayer:
  animator = node
  animation_names.assign(animator.get_animation_list())
 for child in node.get_children():
  find_animator(child)

func play_animation(suffix: String):
 if animator == null or current_action == suffix: return
 for name in animation_names:
  if String(name).ends_with(suffix):
   if suffix == "Run" or suffix == "Idle": animator.get_animation(name).loop_mode = Animation.LOOP_LINEAR
   animator.play(name, 0.12)
   current_action = suffix
   return

func input_action(code: int):
 if not running or paused or unlock: return
 if code == -1 or code == 1: lane = clampi(lane + code, 0, 2)
 elif code == 0:
  if height <= 0.01:
   velocity = 9.0
   jump_buffer = 0
   sound("jump")
  else: jump_buffer = 0.12
 elif code == 2 and height <= 0.01 and mode in ["story", "mission", "chase"]: slide_time = 0.65
 elif code == 3 and ((mode == "story" and level == 5) or (mode == "mission" and mission_phase == 2)) and fire_time <= 0:
  fire_time = 0.3
  var shot = box(Vector3(0.1, 0.1, 0.9), Vector3(player.position.x, 1.4, -1), Color("aaffdd"))
  shot.set_meta("kind", "shot")
  entities.append(shot)

func _unhandled_key_input(event):
 if not event.is_pressed() or event.is_echo(): return
 match event.keycode:
  KEY_LEFT, KEY_A: input_action(-1)
  KEY_RIGHT, KEY_D: input_action(1)
  KEY_SPACE, KEY_UP, KEY_W: input_action(0)
  KEY_DOWN, KEY_S: input_action(2)
  KEY_F: input_action(3)
  KEY_M: toggle_sound()
  KEY_P, KEY_ESCAPE: toggle_pause()

func toggle_pause():
 if not running: return
 paused = not paused
 reset_discard_prompt()
 if animator: animator.speed_scale = 0.0 if paused else 1.0
 if paused:
  dimmer.show()
  stop_audio()
  controls.hide()
  panel.show()
  action.text = "RESUME RUN"
  mode_select.hide()
  fresh_button.text = "RESTART RUN"
  fresh_button.show()
  menu_button.show()
  message.text = "PAUSED - your run is frozen."
 else:
  dimmer.hide()
  panel.hide()
  controls.visible = options.buttons
  message.text = ""
  if options.sound: music_player.play()
 pause_button.text = "RESUME" if paused else "PAUSE"

func reset_discard_prompt():
 discard_pending = ""
 fresh_button.text = "NEW JOURNEY"
 menu_button.text = "DISCARD RUN / MAIN MENU"

func on_fresh_pressed():
 if paused:
  request_discard("restart")
  return
 mode = "story"
 mode_select.select(0)
 level = 0
 pieces = []
 pending_advance = false
 save_checkpoint()
 start_level()

func request_discard(destination: String):
 if not running or not paused: return
 if discard_pending != destination:
  discard_pending = destination
  action.text = "KEEP RUN"
  fresh_button.text = "DISCARD & RESTART?" if destination == "restart" else "RESTART RUN"
  menu_button.text = "DISCARD & MENU?" if destination == "menu" else "DISCARD RUN / MAIN MENU"
  message.text = "Your run is paused. Confirm discard, or KEEP RUN."
  return
 if destination == "restart":
  if mode == "story" and elapsed > 0: record_story_attempt("discarded for restart")
  start_level()
 else: return_menu()

func return_menu():
 reset_discard_prompt()
 if mode == "story" and elapsed > 0 and not campaign_run_recorded: record_story_attempt("discarded")
 running = false
 paused = false
 for item in entities: item.queue_free()
 entities.clear()
 if boss: boss.queue_free(); boss = null
 if gate: gate.queue_free(); gate = null
 unlock = false
 pending_advance = false
 for foot in footprints: foot.queue_free()
 footprints.clear()
 stop_audio()
 show_beat("Mochi and the Moon Bridge", "Choose a journey. STORY saves each level checkpoint; endless modes save separate local bests.", "START " + mode.to_upper())
 mode_select.show()
 menu_button.hide()
 pause_button.hide()

func show_beat(title: String, words: String, label: String):
 dimmer.show()
 running = false
 stop_audio()
 status_label.text = ""
 progress_label.text = ""
 menu_button.hide()
 mode_select.visible = not pending_advance
 pause_button.hide()
 hud.hide()
 panel.show()
 controls.hide()
 message.text = title + "\n\n" + words
 action.text = label
 fresh_button.visible = label != "NEW JOURNEY"
 adapt_layout()
 play_animation("Idle")

func on_action():
 if paused:
  toggle_pause()
  return
 if pending_advance:
  begin_unlock()
  return
 start_level()

func start_level():
 reset_discard_prompt()
 campaign_run_recorded = false
 clear_encounter()
 for item in entities: item.queue_free()
 entities.clear()
 dimmer.hide()
 running = true
 pending_advance = false
 unlock = false
 run_goal = false
 jump_scored.clear()
 for foot in footprints: foot.queue_free()
 footprints.clear()
 hud.show()
 pause_button.show()
 pause_button.text = "PAUSE"
 paused = false
 panel.hide()
 controls.visible = options.buttons
 apply_options()
 adapt_layout()
 elapsed = 0
 score = 0
 distance = 0
 collected = 0
 chain = 0
 chain_time = 0
 chain_bonus = 0
 jump_bonus = 0
 risk_bonus = 0
 pickup_feedback_time = 0
 pickup_feedback = ""
 shield = false
 shield_time = 12
 magnet_time = 0
 mission_phase = 0
 mission_cores = 0
 mission_time = 0
 spawn_time = 1.5
 hearts = 3
 dew = 0
 height = 0
 velocity = 0
 jump_buffer = 0
 lane = 1
 speed = 16 if mode == "story" and level == 4 else 10 if mode == "easy" else 19 if mode == "hard" else 14 if mode != "story" else 12
 guard = 0
 shadow_gap = 20
 boss_hp = 4
 boss_clock = 0
 boss_hits = 0
 guardian_feedback = ""
 guardian_feedback_time = 0
 last_open = false
 apply_world(level if mode == "story" else 0 if mode == "mission" else -1)
 message.text = ["Gather six glowing dew drops. Jump bales, dodge bees.", "Silver Moon: long hops over crater lips.", "Cinnamon Moon: slide under branches; help a firefly.", "Storm Moon: jump waves, slide under lightning arches.", "Gather light: +1.4m. Hits cost4.5m. Keep the shadow away.", "Five lights open the palace. Align and FIRE when shield falls."][level]
 if boss: boss.queue_free(); boss = null
 if mode == "story" and level == 5:
  assert(pieces.size() == 5)
  boss = box(Vector3(1.7, 1.7, 1.7), Vector3(0, 1.8, -18), Color("b056b1"))
 if mode != "story": message.text = "CHASE: collect light and avoid hits. SLIDE under blue arches." if mode == "chase" else "MISSION: gather six mochi, cross the frost moon, face the guardian." if mode == "mission" else "Jump low blocks, dodge tall blocks. Three treats build a chain and a short magnet."
 apply_options()
 if options.sound: music_player.play()

func spawn_wave():
 var l = rng.randi_range(0, 2)
 var safe = (l + 1 + rng.randi_range(0, 1)) % 3
 var kind = "low"
 if mode in ["easy", "normal", "hard"]: kind = "tall" if rng.randf() > 0.45 else "low"
 if mode == "story" and level == 1: kind = "tall" if rng.randf() > 0.5 else "low"
 if (mode == "story" and level in [2,3]) or (mode == "mission" and mission_phase == 1): kind = "beam" if rng.randf() > 0.5 else "low"
 if mode == "chase" or (mode == "story" and level == 4): kind = ["low", "tall", "beam"][rng.randi_range(0, 2)]
 var size = Vector3(1.4, 0.8, 1.2) if kind == "low" else Vector3(1.4, 2.5, 1.2)
 if kind == "beam": size.y = 0.4
 var hazard = box(size, Vector3(LANES[l], 1.65 if kind == "beam" else size.y / 2, -44), Color("9eccec") if kind == "beam" else Color("e4a35b") if kind == "low" else Color("b84569"))
 decorate_hazard(hazard, kind)
 hazard.set_meta("kind", kind)
 hazard.set_meta("lane", l)
 if mode == "story" and level in [0,1,3,4] and kind == "tall": hazard.set_meta("sway", true)
 add_cue(hazard, kind)
 entities.append(hazard)
 for z in [-34, -39]:
  var orb = MeshInstance3D.new()
  var shape = SphereMesh.new()
  shape.radius = 0.23
  shape.height = 0.35
  orb.mesh = shape
  orb.position = Vector3(LANES[safe],1.0,z)
  orb.material_override = material(Color("b8ffff") if mode == "story" and level == 0 else Color("ffe4b8"), true)
  add_child(orb)
  orb.set_meta("kind", "orb")
  entities.append(orb)

func hurt():
 if not running or paused or guard > 0: return
 if shield:
  shield = false
  guard = 0.8
  status_label.text = "SHIELD SAVED YOU"
  return
 if mode in ["easy", "normal", "hard"]:
  sound("hurt")
  finish_run("Jump low blocks. Dodge tall blocks.")
  return
 hearts -= 1
 guard = 1.2
 sound("hurt")
 if mode == "chase" or (mode == "story" and level == 4): shadow_gap -= 4.5
 if hearts <= 0:
  if mode == "story":
   record_story_attempt("checkpoint retry")
   show_beat("The silver bell rings", "Your bridge pieces are safe. Jump low hazards, dodge tall ones, slide under arches.", "RETRY CHECKPOINT")
   sound("bell")
  else: finish_run("Three hits ended this journey. Try a new route.")

func _process(dt):
 if OS.has_feature("web") and OS.has_feature("debug"):
  var debug_entities = []
  for item in entities: debug_entities.append({"kind":item.get_meta("kind"),"x":item.position.x,"z":item.position.z,"lane":item.get_meta("lane",-1)})
  JavaScriptBridge.eval("window.neonQA="+JSON.stringify({"mode":mode,"level":level,"lane":lane,"height":height,"running":running,"paused":paused,"unlock":unlock,"pending":pending_advance,"action":action.text,"entities":debug_entities,"boss_lane":boss_lane,"boss_open":last_open,"boss_hp":boss_hp,"message":message.text,"pieces":pieces,"hearts":hearts,"dew":dew,"stats":stats,"options":options})+";",true)
 if not running or paused: return
 elapsed += dt
 ground_scroll = fmod(ground_scroll + speed * dt / 25.0, 1.0)
 ground.material_override.uv1_offset.y = -ground_scroll
 if not options.motion:
  for p in scene_props:
   p.position.z += speed * dt
   if p.position.z > 10: p.position.z -= 145
  if scenery and scenery.visible:
   for p in scenery.get_children():
    p.position.z += speed * dt
    if p.position.z > 10: p.position.z -= 85
 distance += speed * dt
 score += speed * dt * 2
 if not run_goal and distance >= 250 and collected >= 10 and mode not in ["story","mission"]:
  run_goal = true
  gold_unlocked = true
  options.gold = true
  save_options()
  apply_options()
  message.text = "GOLD ACCENTS UNLOCKED - 250m + 10 treats"
 chain_time = maxf(0, chain_time - dt)
 magnet_time = maxf(0, magnet_time - dt)
 if chain_time <= 0: chain = 0
 if mode in ["easy", "normal", "hard"]:
  speed = minf(23 if mode == "easy" else 38 if mode == "hard" else 32, speed + dt * (0.2 if mode == "easy" else 0.42 if mode == "hard" else 0.35))
  shield_time -= dt
  if shield_time <= 0:
   var shield_pickup = box(Vector3(0.6, 0.6, 0.6), Vector3(LANES[rng.randi_range(0,2)], 1.0, -40), Color("6cffb9"))
   shield_pickup.set_meta("kind", "shield")
   entities.append(shield_pickup)
   shield_time = 18
 if unlock:
  update_unlock(dt)
  return
 guard = maxf(0, guard - dt)
 slide_time = maxf(0, slide_time - dt)
 if (elapsed > 7 or not options.banners) and not unlock: message.text = ""
 fire_time = maxf(0, fire_time - dt)
 guardian_feedback_time = maxf(0, guardian_feedback_time - dt)
 pickup_feedback_time = maxf(0, pickup_feedback_time - dt)
 player.position.x = lerpf(player.position.x, LANES[lane], minf(1, dt * 12))
 jump_buffer = maxf(0, jump_buffer - dt)
 velocity -= (19 if mode == "story" and level == 1 else 26) * dt
 height = maxf(0, height + velocity * dt)
 if height == 0:
  velocity = 0
  if jump_buffer > 0: input_action(0)
 player.position.y = height
 play_animation("Duck" if slide_time > 0 else "Jump_Idle" if height > 0.05 else "Run")
 if animator and current_action == "Run" and not animator.is_playing(): current_action = ""; play_animation("Run")
 if mode == "chase" or (mode == "story" and level == 4):
  shadow_gap -= dt * 1.1
  if shadow_gap <= 2.5:
   if mode == "story":
    record_story_attempt("shadow checkpoint retry")
    show_beat("The silver bell rings", "The shadow caught up. Gather light to push it back.", "RETRY CHECKPOINT")
   else: finish_run("The shadow caught up. Treats push it back.")
   return
 if not ((mode == "story" and level == 5) or (mode == "mission" and mission_phase == 2)):
  spawn_time -= dt
  if spawn_time <= 0: spawn_wave(); spawn_time = 1.7 if mode == "chase" or (mode == "story" and level == 4) else 1.3 if mode in ["easy", "normal", "hard"] else 2.5
  if mode == "mission":
   mission_time += dt
   if mission_phase == 0 and mission_cores >= 6: mission_phase = 1; mission_time = 0; apply_world(1)
   elif mission_phase == 1 and mission_time >= 18:
    mission_phase = 2
    apply_world(5)
    boss = box(Vector3(1.7, 1.7, 1.7), Vector3(0, 1.8, -18), Color("b056b1"))
    apply_options()
  if mode == "story" and ((level == 0 and dew >= 6) or (level > 0 and elapsed >= [24,25,26,27,28][level])):
   pending_advance = true
   var choice = ["TAKE MOON DEW VIAL", "LIFT SILVER LANTERN", "HELP THE FIREFLY", "SPEAK KINDLY TO THE TURTLE", "OFFER A MOCHI"][level]
   var words = ["The vial is full. Moon Dew lights the launch pad. Bell's ringing louder. That way, toward the Moon.", "Chang'e's lantern lies in the dunes. Her footprints. I'm on the right path.", "A firefly is caught in crystal vines. Free it before asking Wu Gang for the blossom.", "A sleepy moon-turtle guards the pearl. Wake a friend with a kind word.", "The shadow corners Mochi. You don't have to be dark alone. Have a mochi."][level]
   show_beat(LEVEL_NAMES[level], words, choice)
   show_story_encounter(level)
 else:
  boss_clock += dt
  var opened = fmod(boss_clock, 4.8) >= 2.4
  if opened and not last_open: boss_hits = 0
  last_open = opened
  if not opened:
   boss_lane = int(boss_clock / 2.4) % 3
  boss.position.x = lerpf(boss.position.x, LANES[boss_lane], minf(1, dt * 4))
  boss.material_override = material(Color("e3b45e") if opened and boss_hits >= 2 else Color("6fcfae") if opened else Color("a862b5"))
  spawn_time -= dt
  if spawn_time <= 0 and not opened: spawn_wave(); spawn_time = 2.3
 for item in entities.duplicate():
  if not running: break
  var kind: String = item.get_meta("kind")
  if kind == "orb" and not options.motion: item.rotation.y += dt * 2
  if item.has_meta("sway"):
   item.position.x = LANES[int(item.get_meta("lane"))] + sin(elapsed * 2 + float(item.get_instance_id() % 9)) * 0.8
  item.position.z += (-65 if kind == "shot" else speed) * dt
  if kind == "shot":
   if item.position.z <= -18:
    if ((mode == "story" and level == 5) or (mode == "mission" and mission_phase == 2)) and last_open and boss_hits < 2 and absf(item.position.x - boss.position.x) < 1.2:
     boss_hp -= 1
     boss_hits += 1
     guardian_feedback = "HIT! Guardian %d / 4" % boss_hp
     guardian_feedback_time = 0.9
     sound("coin")
     if boss_hp <= 0:
      if mode == "mission":
       finish_run("Mission complete! Mochi gathered, frost crossed, guardian calmed.")
       entities.erase(item); item.queue_free()
       return
      record_completion()
      level = 0
      pieces = []
      save_checkpoint()
      show_beat("The Mooncake of Reunion", "Chang'e: You came all this way. Sit. Share this mooncake with me. Wu Gang joins them beneath the cinnamon tree.", "NEW JOURNEY")
    else:
     guardian_feedback = "Shield closed - wait for green" if not last_open else "Two hits landed - wait for green" if boss_hits >= 2 else "Missed - align with guardian"
     guardian_feedback_time = 0.9
    entities.erase(item); item.queue_free()
   continue
  if kind == "tall" and mode in ["easy","normal","hard","chase"]:
   var dx = absf(item.position.x - player.position.x)
   if absf(item.position.z) < 2.2 and dx >= 1.0 and dx < 1.8: item.set_meta("near_seen",true)
   if item.position.z >= 1.1 and not item.get_meta("near_paid",false):
    item.set_meta("near_paid",true)
    if item.get_meta("near_seen",false) and dx >= 1.0 and height < 0.65 and guard <= 0:
     score += 15
     risk_bonus += 15
     pickup_feedback = "+15 NEAR MISS"
     pickup_feedback_time = 0.9
  if kind == "low" and absf(item.position.z) < 1.1 and height > 0.65 and absf(item.position.x - player.position.x) < 1.0:
   item.set_meta("jump_clear",true)
  if item.position.z > 1.1 and kind == "low" and item.get_meta("jump_clear",false) and height > 0.65 and absf(item.position.x - player.position.x) < 1.0 and not jump_scored.has(item.get_instance_id()):
   jump_scored[item.get_instance_id()] = true
   jump_bonus += 20
   score += 20
   pickup_feedback = "+20 JUMP CLEAR"
   pickup_feedback_time = 0.9
  if item.position.z > 10: entities.erase(item); jump_scored.erase(item.get_instance_id()); item.queue_free(); continue
  if absf(item.position.z) < (2.2 if magnet_time > 0 and kind == "orb" else 1.1) and absf(item.position.x - player.position.x) < (3.4 if magnet_time > 0 and kind == "orb" else 1.0):
   if kind == "orb" and height < 1.8:
    dew += 1
    collected += 1
    score += 50
    sound("coin")
    if mode == "mission" and mission_phase == 0: mission_cores += 1
    if mode in ["easy", "normal", "hard", "chase"]:
     chain += 1
     chain_time = 4
     if chain >= 3:
      chain = 0
      score += 25
      chain_bonus += 25
      if magnet_time <= 0: magnet_time = 3
    if mode == "chase" or (mode == "story" and level == 4): shadow_gap = minf(28, shadow_gap + 1.4)
    entities.erase(item); item.queue_free()
   elif kind == "shield" and height < 1.8:
    shield = true
    entities.erase(item); item.queue_free()
   elif kind != "orb":
    var collision = not (slide_time > 0 and height < 0.1) if kind == "beam" else height < (0.65 if kind == "low" else 2.3)
    if collision: hurt(); entities.erase(item); item.queue_free()
 update_hud()

func update_hud():
 if mode == "story":
  hud.text = "STORY  %d / 6 %s\nHearts %d   Bridge %d / 5\nDew %d   Time %ds" % [level + 1, LEVEL_NAMES[level], hearts, pieces.size(), dew, int(elapsed)]
 elif mode == "mission":
  hud.text = "MISSION  %d / 3\nHearts %d  Mochi %d / 6\nTime %ds" % [mission_phase + 1, hearts, mission_cores, int(elapsed)]
 else:
  hud.text = "%s  %d pts\n%d m  %d treats  %ds\nBest %d" % [display_mode(mode), int(score), int(distance), collected, int(elapsed), int(stats.get(mode, {}).get("best", 0))]
 if mode == "chase" or (mode == "story" and level == 4): hud.text += "  Shadow %.1fm" % shadow_gap
 if (mode == "story" and level == 5) or (mode == "mission" and mission_phase == 2): hud.text += "  Guardian %d / 4" % boss_hp
 if mode == "story" and running and not unlock:
  progress_label.text = "DEW %d / 6 TO LIGHT THE LAUNCH PAD" % mini(dew,6) if level == 0 else "PATH TO %s: %d%%" % [PIECES[level].to_upper(),mini(100,int(elapsed/[24,25,26,27,28][level]*100))] if level < 5 else "TWO HITS - WAIT FOR NEXT GREEN" if boss_hits >= 2 and last_open else "SHIELD OPEN - ALIGN AND FIRE" if last_open else "SHIELD CLOSED - ALIGN AND WAIT"
 elif mode == "mission" and running and mission_phase == 2:
  progress_label.text = "TWO HITS - WAIT FOR NEXT GREEN" if boss_hits >= 2 and last_open else "SHIELD OPEN - ALIGN AND FIRE" if last_open else "SHIELD CLOSED - ALIGN AND WAIT"
 elif running and mode in ["easy","normal","hard","chase"]:
  progress_label.text = "GOAL COMPLETE" if run_goal else "EARN GOLD: %d / 250m + %d / 10 TREATS" % [mini(250,int(distance)),mini(10,collected)]
 elif unlock: progress_label.text = "BRIDGE CROSSING %d%%" % mini(100,int(unlock_time/5*100))
 else: progress_label.text = ""
 status_label.text = guardian_feedback if guardian_feedback_time > 0 and ((mode == "story" and level == 5) or (mode == "mission" and mission_phase == 2)) else pickup_feedback if pickup_feedback_time > 0 else "SHIELD READY" if shield else "MAGNET %.1fs" % magnet_time if magnet_time > 0 else "CHAIN %d / 3" % chain if chain > 0 else ""

func save_checkpoint():
 var f = FileAccess.open("user://journey.json", FileAccess.WRITE)
 if f: f.store_string(JSON.stringify({"level": level, "pieces": pieces}))

func load_checkpoint():
 if not FileAccess.file_exists("user://journey.json"): return
 var f = FileAccess.open("user://journey.json", FileAccess.READ)
 if not f: return
 var v = JSON.parse_string(f.get_as_text())
 if v is Dictionary and v.get("level") is float and int(v.level) >= 0 and int(v.level) <= 5 and v.get("pieces") is Array and v.pieces.size() == int(v.level):
  for i in range(v.pieces.size()):
   if v.pieces[i] != PIECES[i]: return
  level = int(v.level)
  pieces = v.pieces

func add_cue(hazard: Node3D, kind: String):
 var label = Label3D.new()
 label.text = "DOWN" if kind == "beam" else "UP" if kind == "low" else "X"
 label.font_size = 64
 label.pixel_size = 0.008
 label.position = Vector3(0, 0, 0.62)
 label.no_depth_test = false
 hazard.add_child(label)

func apply_world(index: int):
 var m = material(Color.WHITE if index >= 0 and index < 4 else COLORS[index] if index >= 0 else Color("77708e"))
 var theme = ["meadow", "sand", "grove", "sea", "comet", "palace"][maxi(index,0)]
 if index >= 0 and index < 4: m.albedo_texture = load("res://assets/textures/ground_" + theme + ".png")
 m.uv1_scale = Vector3(1, 6, 1)
 if index >= 0:
  env_world.environment.background_color = [Color("102619"),Color("1b112b"),Color("2f1c0d"),Color("0c2237"),Color("211021"),Color("28213d")][index]
 else: env_world.environment.background_color = Color("08091c")
 for side in side_planes:
  var sm = material(Color("8c8c8c"))
  sm.albedo_texture = load("res://assets/textures/side_" + theme + ".png") if index >= 0 else load("res://assets/moon.jpg")
  sm.uv1_scale = Vector3(5, 20, 1)
  side.material_override = sm
 if index == -1 or index >= 4:
  m.albedo_texture = load("res://assets/moon.jpg")
  m.uv1_scale = Vector3(2, 24, 1)
 ground.material_override = m
 var grades = [Color("e8f2de"),Color("e0eaff"),Color("ffd3a2"),Color("aec9ea"),Color("c59fba"),Color("ffe6b0")]
 for i in range(moons.size()):
  var mm = material(grades[maxi(index,0)] if index >= 0 else Color("ddd4ef"))
  mm.albedo_texture = load("res://assets/moon.jpg")
  mm.normal_enabled = true
  mm.normal_texture = load("res://assets/moon-normal.png")
  mm.normal_scale = 2.0
  mm.uv1_scale = Vector3(2,1,1)
  moons[i].material_override = mm
  moons[i].visible = options.stars
 if scenery: scenery.visible = index == 2 and not options.light
 build_level_props(index)
 var environment = env_world.environment
 environment.fog_enabled = true
 environment.fog_density = 0.0035
 environment.fog_light_color = environment.background_color
 environment.fog_light_energy = 1.0
 environment.fog_sky_affect = 0.0
 var sky = Sky.new()
 var sky_material = ProceduralSkyMaterial.new()
 sky_material.sky_top_color = Color("060918")
 sky_material.sky_horizon_color = environment.background_color
 sky_material.ground_horizon_color = environment.background_color
 sky_material.ground_bottom_color = Color("080a14")
 sky_material.sun_angle_max = 1
 sky.sky_material = sky_material
 environment.sky = sky
 environment.background_mode = Environment.BG_SKY
 sky_stars.visible = options.stars and not options.light

func build_scenery():
 scenery = Node3D.new()
 add_child(scenery)
 for side in [-1,1]:
  var plane = box(Vector3(24,0.1,150), Vector3(side * 15.7,-0.18,-62), Color("77708e"))
  side_planes.append(plane)
 for i in range(16):
  var side = -1 if i % 2 == 0 else 1
  var trunk = box(Vector3(0.25, 2.4, 0.25), Vector3(side * (5.5 + (i % 3)), 1.2, -i * 5 - 10), Color("70422a"))
  remove_child(trunk); scenery.add_child(trunk)
  var top = box(Vector3(1.8, 1.4, 1.8), trunk.position + Vector3(0, 1.6, 0), Color("927641"))
  remove_child(top); scenery.add_child(top)

func begin_unlock():
 dimmer.hide()
 clear_encounter()
 pending_advance = false
 running = true
 unlock = true
 unlock_time = 0
 panel.hide()
 controls.show()
 hud.show()
 pause_button.show()
 for item in entities: item.queue_free()
 entities.clear()
 if gate: gate.queue_free()
 gate = box(Vector3(5.7, 0.2, 0.4), Vector3(0, 2.3, -18), Color("aaffcc"))
 message.text = ["MOON DEW lights the launch pad. Hop toward the Silver Moon.", "SILVER LANTERN reveals Chang'e's footprints.", "CINNAMON BLOSSOM opens Wu Gang's gate.", "TIDE PEARL calms the waves. Hazards move slower.", "ECLIPSE KEY opens the palace and weakens the Guardian."][level]
 speed = 7 if level == 3 else 12
 if level == 1:
  for i in range(14):
   var foot = box(Vector3(0.16, 0.02, 0.3), Vector3(0.2 if i%2 else -0.2, 0.04, -i * 2 - 2), Color("ffeebb"))
   footprints.append(foot)

func update_unlock(dt: float):
 unlock_time += dt
 if gate:
  gate.position.z += speed * dt
  gate.position.y += dt * 0.5
 if level == 0 and unlock_time > 1.4 and unlock_time - dt <= 1.4: velocity = 13
 velocity -= 19 * dt
 height = maxf(0, height + velocity * dt)
 player.position.y = height
 play_animation("Jump_Idle" if height > 0.1 else "Run")
 for foot in footprints:
  foot.position.z += speed * dt
 update_hud()
 if unlock_time >= 5:
  if gate: gate.queue_free(); gate = null
  for foot in footprints: foot.queue_free()
  footprints.clear()
  record_story_attempt("level complete")
  pieces.append(PIECES[level])
  level += 1
  save_checkpoint()
  start_level()

func finish_run(reason: String):
 var record: Dictionary = stats.get(mode, {"best": 0, "distance": 0, "treats": 0, "seconds": 0, "runs": 0})
 record.best = maxi(int(record.best), int(score))
 record.distance = maxi(int(record.distance), int(distance))
 record.treats = maxi(int(record.treats), collected)
 record.seconds = maxi(int(record.seconds), int(elapsed))
 record.runs = int(record.runs) + 1
 stats[mode] = record
 history.push_front({"mode":mode,"score":int(score),"distance":int(distance),"treats":collected,"seconds":int(elapsed),"completed_at":Time.get_datetime_string_from_system()})
 history = history.slice(0,20)
 save_stats()
 show_beat("MISSION COMPLETE" if mode == "mission" and boss_hp <= 0 else "RUN COMPLETE", "%s\n%d points / %dm / %d treats / %ds\nBest %d\n%s" % [reason, int(score), int(distance), collected, int(elapsed), int(record.best),score_breakdown()], "RETRY RUN")
 mode_select.show()

func score_breakdown() -> String:
 var travel = maxi(0,int(score)-collected*50-chain_bonus-jump_bonus-risk_bonus)
 return "%d distance + %d treats\n%d chain + %d jump + %d near miss" % [travel,collected*50,chain_bonus,jump_bonus,risk_bonus]

func show_stats():
 open_stats()

func save_stats():
 var f = FileAccess.open("user://stats.json", FileAccess.WRITE)
 if f: f.store_string(JSON.stringify({"records":stats,"history":history}))
 else: storage_warning = "Saving unavailable. This session only. Export your stats."

func load_stats():
 if not FileAccess.file_exists("user://stats.json"): return
 var f = FileAccess.open("user://stats.json", FileAccess.READ)
 if f:
  var data = JSON.parse_string(f.get_as_text())
  if data is Dictionary:
   var records = data.get("records",{})
   if records is Dictionary:
    for key in mode_names:
     var v = records.get(key,{})
     if v is Dictionary:
      var record = {}
      for metric in ["best","distance","treats","seconds","runs"]:
       var n = v.get(metric,0)
       record[metric] = int(n) if (n is float or n is int) and n >= 0 and n < 1e12 else 0
      stats[key] = record
   var h = data.get("history",[])
   if h is Array:
    for r in h.slice(0,20):
     if r is Dictionary and r.get("mode","") in mode_names and r.get("score") is float: history.append(r)

func save_options():
 var f = FileAccess.open("user://options.json", FileAccess.WRITE)
 if f:
  var out = options.duplicate()
  out.gold_unlocked = gold_unlocked
  f.store_string(JSON.stringify(out))

func load_options():
 if not FileAccess.file_exists("user://options.json"): return
 var f = FileAccess.open("user://options.json", FileAccess.READ)
 if f:
  var data = JSON.parse_string(f.get_as_text())
  if data is Dictionary:
   for key in options.keys():
    if data.has(key) and typeof(data[key]) == typeof(options[key]): options[key] = data[key]
   gold_unlocked = data.get("gold_unlocked",false) == true
 options.sound = false

func setup_audio():
 music_player = AudioStreamPlayer.new()
 music_player.stream = load("res://assets/music.wav")
 music_player.volume_db = -16
 add_child(music_player)
 music_player.finished.connect(func():
  if options.sound and running and not paused: music_player.play()
 )

func toggle_sound():
 options.sound = not options.sound
 sound_button.text = "SOUND ON" if options.sound else "SOUND OFF"
 if not options.sound: stop_audio()
 elif running and not paused: music_player.play()

func sound(kind: String):
 if not options.sound: return
 var p = AudioStreamPlayer.new()
 p.stream = load("res://assets/" + kind + ".wav")
 p.volume_db = -8
 add_child(p)
 audio_players.append(p)
 p.finished.connect(func(): audio_players.erase(p); p.queue_free())
 p.play()

func stop_audio():
 if music_player: music_player.stop()
 for p in audio_players:
  p.stop()
  p.queue_free()
 audio_players.clear()

func _input(event):
 if not running or paused: return
 if event is InputEventScreenTouch:
  if event.pressed:
   touch_origin = event.position
   touch_active = true
   touch_moved = false
  elif touch_active:
   if options.tap and not touch_moved and event.position.y > 250 and event.position.y < get_viewport().get_visible_rect().size.y - 140: input_action(0)
   touch_active = false
 elif event is InputEventScreenDrag and touch_active:
  var delta = event.position - touch_origin
  if absf(delta.x) > int(options.swipe) and absf(delta.x) > absf(delta.y):
   input_action(1 if delta.x > 0 else -1)
   touch_origin = event.position
   touch_moved = true
  elif delta.y < -55:
   input_action(0); touch_origin = event.position; touch_moved = true
  elif delta.y > 55:
   input_action(2); touch_origin = event.position; touch_moved = true

func _notification(what):
 if what == NOTIFICATION_APPLICATION_FOCUS_OUT and running and not paused: toggle_pause()

func clear_encounter():
 for item in story_props: item.queue_free()
 story_props.clear()

func story_label(text: String, at: Vector3):
 var label = Label3D.new()
 label.text = text
 label.position = at
 label.font_size = 44
 label.pixel_size = 0.007
 add_child(label)
 story_props.append(label)

func show_story_encounter(which: int):
 if which == 2:
  var firefly = box(Vector3(0.16,0.16,0.16),Vector3(0,1.3,-2),Color("ffde7e"))
  story_props.append(firefly)
  for side in [-1,1]:
   var vine = box(Vector3(0.08,1.6,0.08),Vector3(side*0.4,1,-2),Color("7d5380"))
   story_props.append(vine)
  story_label("TRAPPED FIREFLY",Vector3(0,2.2,-2))
 elif which == 3:
  var turtle = MeshInstance3D.new()
  var shell = SphereMesh.new()
  shell.radius = 0.7
  shell.height = 0.8
  turtle.mesh = shell
  turtle.material_override = material(Color("77a891"))
  turtle.position = Vector3(0,0.5,-2)
  add_child(turtle)
  story_props.append(turtle)
  story_label("SLEEPY MOON-TURTLE",Vector3(0,1.7,-2))
 elif which == 4:
  var shadow = box(Vector3(1.4,2.2,0.8),Vector3(0,1.1,-3),Color("443149"))
  story_props.append(shadow)
  story_label("A SHADOW, ALONE",Vector3(0,2.6,-3))

func decorate_hazard(hazard: MeshInstance3D, kind: String):
 if kind == "low":
  var shape = CylinderMesh.new()
  shape.top_radius = 0.44
  shape.bottom_radius = 0.44
  shape.height = 1.4
  hazard.mesh = shape
  hazard.rotation_degrees.z = 90
  if mode == "story" and level == 3:
   hazard.mesh = BoxMesh.new()
   hazard.mesh.size = Vector3(1.5,0.65,0.6)
   hazard.rotation = Vector3.ZERO
   hazard.material_override = material(Color("70aabf"))
 elif kind == "beam":
  for side in [-1,1]:
   var post = MeshInstance3D.new()
   var shape = CylinderMesh.new()
   shape.top_radius = 0.07
   shape.bottom_radius = 0.07
   shape.height = 1.8
   post.mesh = shape
   post.position = Vector3(side*0.73,-0.7,0)
   post.material_override = material(Color("7db4d6"))
   hazard.add_child(post)
 else:
  var shape = PrismMesh.new()
  shape.size = Vector3(1.4,2.5,1.2)
  hazard.mesh = shape

func record_completion():
 record_story_attempt("reunion")

func record_story_attempt(outcome: String):
 if campaign_run_recorded: return
 campaign_run_recorded = true
 var record: Dictionary = stats.get("story",{"best":0,"distance":0,"treats":0,"seconds":0,"runs":0})
 record.best = maxi(int(record.get("best",0)),int(score))
 record.distance = maxi(int(record.get("distance",0)),int(distance))
 record.treats = maxi(int(record.get("treats",0)),collected)
 record.seconds = maxi(int(record.get("seconds",0)),int(elapsed))
 record.runs = int(record.get("runs",0))+1
 stats.story = record
 history.push_front({"mode":"story","score":int(score),"distance":int(distance),"treats":collected,"seconds":int(elapsed),"completed_at":Time.get_datetime_string_from_system(),"outcome":outcome,"level":level+1})
 history = history.slice(0,20)
 save_stats()

func apply_options():
 if not is_instance_valid(controls): return
 controls.visible = running and not paused and options.buttons
 controls.get_child(2).visible = mode in ["story","mission","chase"]
 controls.get_child(4).visible = (mode == "story" and level == 5) or (mode == "mission" and mission_phase == 2)
 controls.offset_top = -110 if options.large else -88
 for child in controls.get_children(): child.custom_minimum_size.y = 78 if options.large else 56
 hud.add_theme_font_size_override("font_size",14 if options.compact else 17)
 if options.contrast:
  hud.add_theme_color_override("font_color",Color("ffffb0"))
 else: hud.add_theme_color_override("font_color",Color.WHITE)
 for guide in lane_guides: guide.visible = options.guides
 adapt_layout()
 for moon in moons: moon.visible = options.stars
 if sky_stars: sky_stars.visible = options.stars and not options.light
 if scenery: scenery.visible = not options.light and mode == "story" and level == 2
 if animator and options.motion: animator.speed_scale = 0
 elif animator and not paused: animator.speed_scale = 1
 apply_bunny_tint(bunny)

func apply_bunny_tint(node: Node):
 if node is MeshInstance3D:
  for i in range(node.get_surface_override_material_count()):
   var src = node.mesh.surface_get_material(i)
   if src is StandardMaterial3D:
    var m = src.duplicate()
    if String(src.resource_name) == "Bunny_Secondary": m.albedo_color = Color("9ed6af") if options.color == "mint" else Color("ba9cdd") if options.color == "violet" else Color("e7a3ba")
    if String(src.resource_name) == "Eye_White" and options.gold and gold_unlocked: m.albedo_color = Color("ffdc78")
    node.set_surface_override_material(i,m)
 for child in node.get_children(): apply_bunny_tint(child)

func popup_frame(title: String) -> VBoxContainer:
 var bg = PanelContainer.new()
 var viewport_size = get_viewport().get_visible_rect().size
 bg.position = Vector2((viewport_size.x-370)/2,20 if viewport_size.y < 650 else 70)
 bg.size = Vector2(370,minf(690,viewport_size.y-(40 if viewport_size.y < 650 else 90)))
 var style = StyleBoxFlat.new()
 style.bg_color = Color("121728")
 style.corner_radius_top_left = 16
 style.corner_radius_top_right = 16
 style.corner_radius_bottom_left = 16
 style.corner_radius_bottom_right = 16
 style.content_margin_left = 16
 style.content_margin_right = 16
 style.content_margin_top = 16
 style.content_margin_bottom = 16
 bg.add_theme_stylebox_override("panel",style)
 overlay_root.add_child(bg)
 var scroll = ScrollContainer.new()
 scroll.custom_minimum_size = Vector2(338,minf(650,viewport_size.y-(80 if viewport_size.y < 650 else 130)))
 bg.add_child(scroll)
 var list = VBoxContainer.new()
 list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 list.add_theme_constant_override("separation",9)
 scroll.add_child(list)
 var heading = Label.new()
 heading.text = title
 heading.add_theme_font_size_override("font_size",22)
 list.add_child(heading)
 var close = Button.new()
 close.text = "CLOSE"
 close.custom_minimum_size.y = 44
 close.pressed.connect(func(): bg.queue_free())
 list.add_child(close)
 return list

func open_settings():
 var list = popup_frame("SETTINGS - THIS BROWSER")
 for entry in [["light","Light quality"],["motion","Reduced motion"],["buttons","On-screen buttons"],["large","Large controls"],["contrast","High contrast HUD"],["tap","Tap to jump"],["stars","Show moons"],["guides","Lane guides"],["compact","Compact HUD"],["banners","Story guidance"]]:
  var key: String = entry[0]
  var button = CheckButton.new()
  button.text = entry[1]
  button.button_pressed = options[key]
  button.custom_minimum_size.y = 42
  button.toggled.connect(func(on): options[key] = on; save_options(); apply_options())
  list.add_child(button)
 var hand = OptionButton.new()
 for title in ["Controls: center","Controls: left","Controls: right"]: hand.add_item(title)
 hand.selected = ["center","left","right"].find(options.hand)
 hand.item_selected.connect(func(i): options.hand = ["center","left","right"][i]; save_options(); apply_options())
 list.add_child(hand)
 var sensitivity = OptionButton.new()
 for label in ["Swipe: sensitive","Swipe: standard","Swipe: deliberate"]: sensitivity.add_item(label)
 sensitivity.selected = [30,45,65].find(int(options.swipe))
 sensitivity.item_selected.connect(func(i): options.swipe = [30,45,65][i]; save_options())
 list.add_child(sensitivity)
 var colors = OptionButton.new()
 for label in ["Rabbit accents: pink","Rabbit accents: mint","Rabbit accents: violet"]: colors.add_item(label)
 colors.selected = ["pink","mint","violet"].find(options.color)
 colors.item_selected.connect(func(i): options.color = ["pink","mint","violet"][i]; save_options(); apply_options())
 list.add_child(colors)
 var gold = CheckButton.new()
 gold.text = "Gold accents" if gold_unlocked else "Gold: reach 250m + 10 treats"
 gold.disabled = not gold_unlocked
 gold.button_pressed = options.gold and gold_unlocked
 gold.toggled.connect(func(on): options.gold = on; save_options(); apply_options())
 list.add_child(gold)

func open_stats():
 var list = popup_frame("THIS BROWSER STATS")
 if storage_warning != "":
  var warning = Label.new()
  warning.text = storage_warning
  warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
  list.add_child(warning)
 var records = Label.new()
 for key in mode_names:
  var r: Dictionary = stats.get(key,{})
  records.text += "%s: %d pts / %dm\n%d treats / %ds / %d runs\n\n" % [display_mode(key),int(r.get("best",0)),int(r.get("distance",0)),int(r.get("treats",0)),int(r.get("seconds",0)),int(r.get("runs",0))]
 records.add_theme_font_size_override("font_size",15)
 list.add_child(records)
 var exports = HBoxContainer.new()
 for kind in ["JSON","CSV"]:
  var button = Button.new()
  button.text = "EXPORT " + kind
  button.custom_minimum_size = Vector2(145,44)
  button.pressed.connect(func(): export_stats(kind))
  exports.add_child(button)
 list.add_child(exports)
 var filter = OptionButton.new()
 filter.add_item("History: all modes")
 for key in mode_names: filter.add_item(display_mode(key))
 list.add_child(filter)
 var order = OptionButton.new()
 for title in ["Newest","Top score","Longest distance","Most treats","Longest survival"]: order.add_item(title)
 list.add_child(order)
 var limit = CheckButton.new()
 limit.text = "Show 20 runs (otherwise 5)"
 list.add_child(limit)
 var history_label = Label.new()
 history_label.add_theme_font_size_override("font_size",14)
 list.add_child(history_label)
 var refresh = func():
  var rows = history.duplicate()
  if filter.selected > 0: rows = rows.filter(func(r): return r.mode == mode_names[filter.selected-1])
  if order.selected > 0:
   var key = ["","score","distance","treats","seconds"][order.selected]
   rows.sort_custom(func(a,b): return a.get(key,0) > b.get(key,0))
  var shown = rows.slice(0,20 if limit.button_pressed else 5)
  history_label.text = "SHOWN RUNS / LAST 20 SAVED\n" + shown_average(shown)
  for r in shown:
   var details = "Level %d - %s\n" % [int(r.get("level",1)),str(r.get("outcome","attempt"))] if r.mode == "story" and r.has("level") else ""
   history_label.text += "%s %d pts / %dm\n%d treats / %ds\n%s%s\n\n" % [display_mode(r.mode),r.score,r.distance,r.treats,r.seconds,details,r.get("completed_at","")]
  if rows.is_empty(): history_label.text += "No saved runs yet."
 filter.item_selected.connect(func(_i): refresh.call())
 order.item_selected.connect(func(_i): refresh.call())
 limit.toggled.connect(func(_on): refresh.call())
 refresh.call()

func shown_average(rows: Array) -> String:
 if rows.is_empty(): return ""
 var sums = {"score":0.0,"distance":0.0,"treats":0.0,"seconds":0.0}
 for row in rows:
  for metric in sums: sums[metric] += float(row.get(metric,0))
 return "Shown average (%d runs):\n%d pts / %dm / %.1f treats / %ds\n\n" % [rows.size(),roundi(sums.score/rows.size()),roundi(sums.distance/rows.size()),sums.treats/rows.size(),roundi(sums.seconds/rows.size())]

func display_mode(key: String) -> String:
 return {"easy":"CHILL","normal":"CLASSIC","hard":"RUSH","story":"STORY","mission":"MISSION","chase":"CHASE"}.get(key,key.to_upper())

func export_stats(kind: String):
 var text = JSON.stringify({"game":"Mochi and the Moon Bridge","format_version":2,"scope":"This browser only, last 20 completed runs","records":stats,"history":history},"  ")
 if kind == "CSV":
  text = "mode,score,distance_m,treats,seconds,completed_at\n"
  for r in history: text += "%s,%d,%d,%d,%d,%s\n" % [r.mode,r.score,r.distance,r.treats,r.seconds,r.get("completed_at","")]
 if OS.has_feature("web"): JavaScriptBridge.download_buffer(text.to_utf8_buffer(),"neon-rush-stats."+kind.to_lower(),"text/csv" if kind == "CSV" else "application/json")
 else:
  var f = FileAccess.open("user://neon-rush-stats."+kind.to_lower(),FileAccess.WRITE)
  if f: f.store_string(text)

func import_legacy_data():
 if not OS.has_feature("web") or FileAccess.file_exists("user://legacy-imported"): return
 # Import only validated saved data from the earlier game on this same origin.
 var raw = JavaScriptBridge.eval("(()=>{try{return JSON.stringify({best:localStorage.getItem('neonrush_best'),easy:localStorage.getItem('neonrush_best_easy'),hard:localStorage.getItem('neonrush_best_hard'),chase:localStorage.getItem('neonrush_best_chase'),mission:localStorage.getItem('neonrush_best_mission'),story:localStorage.getItem('neonrush_best_story'),journey:localStorage.getItem('neonrush_story'),stats:localStorage.getItem('neonrush_stats'),gold:localStorage.getItem('neonrush_gold')})}catch(e){return null}})()",true)
 if raw is String:
  var data = JSON.parse_string(raw)
  if data is Dictionary:
   for key in mode_names:
    var n = str(data.get("best" if key == "normal" else key,"0"))
    if n.is_valid_int() and int(n) >= 0 and int(n) < 1e12:
     var record: Dictionary = stats.get(key,{"best":0,"distance":0,"treats":0,"seconds":0,"runs":0})
     record.best = maxi(int(record.best),int(n))
     stats[key] = record
   var old_stats = JSON.parse_string(data.stats if data.get("stats") is String else "null")
   if old_stats is Dictionary:
    var records = old_stats.get("records",{})
    for key in mode_names:
     var r = records.get(key,{}) if records is Dictionary else {}
     if r is Dictionary:
      var rec: Dictionary = stats.get(key,{"best":0,"distance":0,"treats":0,"seconds":0,"runs":0})
      for mapping in [["distance","distance"],["orbs","treats"],["seconds","seconds"]]:
       var n = r.get(mapping[0],0)
       if (n is int or n is float) and n >= 0 and n < 1e12: rec[mapping[1]] = maxi(int(rec.get(mapping[1],0)),int(n))
      stats[key] = rec
    var hist = old_stats.get("history",[])
    if hist is Array and history.is_empty():
     for r in hist.slice(0,20):
      if r is Dictionary and r.get("mode","") in mode_names and r.get("score") is float:
       history.append({"mode":r.mode,"score":maxi(0,int(r.score)),"distance":maxi(0,int(r.get("distance",0))),"treats":maxi(0,int(r.get("orbs",0))),"seconds":maxi(0,int(r.get("seconds",0))),"completed_at":legacy_date(r.get("completedAt",""))})
   var journey = JSON.parse_string(data.journey if data.get("journey") is String else "null")
   if valid_legacy_journey(journey) and not FileAccess.file_exists("user://journey.json"):
    var f = FileAccess.open("user://journey.json",FileAccess.WRITE)
    if f: f.store_string(JSON.stringify(journey))
   gold_unlocked = gold_unlocked or data.get("gold") == "1"
   save_stats()
   save_options()
 var mark = FileAccess.open("user://legacy-imported",FileAccess.WRITE)
 if mark: mark.store_string("1")

func legacy_date(value) -> String:
 var text = str(value)
 if (value is int or value is float or text.is_valid_float()) and text != "":
  var stamp = float(value)
  if stamp > 0 and stamp < 1e14:
   return Time.get_datetime_string_from_unix_time(int(stamp / 1000.0)) + "Z"
  return ""
 return text if text.contains("T") else ""

func valid_legacy_journey(value) -> bool:
 if not value is Dictionary: return false
 var n = value.get("level",-1)
 if not (n is float or n is int) or n != int(n) or n < 0 or n > 5: return false
 var p = value.get("pieces",null)
 if not p is Array or p.size() != int(n): return false
 for i in range(p.size()):
  if p[i] != PIECES[i]: return false
 return true

func mapped_legacy_options(value: Dictionary) -> Dictionary:
 var result = {}
 for pair in [["quality","light"],["buttons","buttons"],["large","large"],["contrast","contrast"],["tapJump","tap"],["stars","stars"],["laneGuides","guides"],["compactHud","compact"],["banners","banners"],["goldTrim","gold"],["motion","motion"]]:
  if value.get(pair[0]) is bool: result[pair[1]] = value[pair[0]]
 if value.get("hand") in ["left","center","right"]: result.hand = value.hand
 if value.get("swipe") in ["short","standard","long"]: result.swipe = {"short":30,"standard":45,"long":65}[value.swipe]
 if value.get("runnerColor") in ["cyan","mint","violet"]: result.color = "pink" if value.runnerColor == "cyan" else value.runnerColor
 return result

func import_legacy_preferences(had_engine_options: bool):
 if not OS.has_feature("web") or FileAccess.file_exists("user://legacy-preferences-v2"): return
 # Never replace settings already saved in the engine. Old localStorage stays untouched.
 var raw = JavaScriptBridge.eval("(()=>{try{return localStorage.getItem('neonrush_options')}catch(e){return null}})()",true)
 if not had_engine_options and raw is String:
  var old = JSON.parse_string(raw)
  if old is Dictionary:
   options.merge(mapped_legacy_options(old),true)
   if not gold_unlocked: options.gold = false
   save_options()
 var changed = false
 for row in history:
  var old = row.get("completed_at","")
  if str(old).is_valid_float():
   row.completed_at = legacy_date(old)
   changed = true
 if changed: save_stats()
 var mark = FileAccess.open("user://legacy-preferences-v2",FileAccess.WRITE)
 if mark: mark.store_string("1")

func build_level_props(index: int):
 for p in scene_props: p.queue_free()
 scene_props.clear()
 if index < 0 or options.light: return
 for i in range(30):
  var side = -1 if i % 2 == 0 else 1
  var at = Vector3(side * (5.2 + (i%3)*1.6),0.1,-i*4.5-8)
  if index == 0:
   var grass = MeshInstance3D.new()
   var plane = QuadMesh.new()
   plane.size = Vector2(1.8,1.4)
   grass.mesh = plane
   var gm = material(Color("c5dbad"))
   gm.albedo_texture = load("res://assets/textures/sprite_grass.png")
   gm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
   gm.cull_mode = BaseMaterial3D.CULL_DISABLED
   grass.material_override = gm
   grass.position = at+Vector3(0,0.7,0)
   add_child(grass)
   scene_props.append(grass)
  elif index in [1,4]:
   var rock = MeshInstance3D.new()
   var mesh = SphereMesh.new()
   mesh.radius = 0.6 + (i%3)*0.3
   mesh.height = mesh.radius
   rock.mesh = mesh
   rock.position = at
   rock.material_override = material(Color("b0a9bd") if index == 1 else Color("5a455f"))
   add_child(rock)
   scene_props.append(rock)
  elif index == 3:
   var ring = MeshInstance3D.new()
   var mesh = TorusMesh.new()
   mesh.inner_radius = 0.7
   mesh.outer_radius = 0.85
   ring.mesh = mesh
   ring.position = at
   ring.material_override = material(Color("a8dbe3"))
   add_child(ring)
   scene_props.append(ring)
  elif index == 5:
   var column = box(Vector3(0.35,4,0.35),at+Vector3(0,2,0),Color("963e3a"))
   scene_props.append(column)
   var lantern = box(Vector3(0.7,0.7,0.7),at+Vector3(0,3.5,0),Color("ffd48a"))
   scene_props.append(lantern)

func build_stars():
 sky_stars = MultiMeshInstance3D.new()
 var mesh = SphereMesh.new()
 mesh.radius = 0.07
 mesh.height = 0.14
 mesh.radial_segments = 8
 mesh.rings = 4
 var mm = MultiMesh.new()
 mm.transform_format = MultiMesh.TRANSFORM_3D
 mm.mesh = mesh
 mm.instance_count = 140
 var star_rng = RandomNumberGenerator.new()
 star_rng.seed = 2896
 for i in range(140):
  var pos = Vector3(star_rng.randf_range(-65,65),star_rng.randf_range(12,65),star_rng.randf_range(-110,-60))
  mm.set_instance_transform(i,Transform3D(Basis.IDENTITY,pos))
 sky_stars.multimesh = mm
 var m = material(Color("d5e8f9"),true)
 m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
 sky_stars.material_override = m
 add_child(sky_stars)

func adapt_layout():
 var size = get_viewport().get_visible_rect().size
 if not is_instance_valid(panel): return
 var compact = size.y < 650
 panel.position = Vector2((size.x-340)/2,155 if compact else 365)
 message.position.y = 15 if compact and not running else 100 if compact else 145
 message.size.y = 120 if compact else 170
 message.add_theme_font_size_override("font_size",15 if compact else 16)
 progress_label.position.y = 155 if compact else 200
 message.position.x = (size.x-354)/2
 pause_button.position.x = size.x-104
 status_label.position.x = (size.x-350)/2
 progress_label.position.x = (size.x-350)/2
 var width = minf(480,size.x-16) if options.hand == "center" else minf(360,size.x-16)
 var center = size.x/2 if options.hand == "center" else width/2+8 if options.hand == "left" else size.x-width/2-8
 controls.anchor_left = 0
 controls.anchor_right = 0
 controls.offset_left = center-width/2
 controls.offset_right = center+width/2

func configure_window():
 var physical = get_window().size
 if physical.x > physical.y:
  get_window().content_scale_size = Vector2i(maxi(700,physical.x),maxi(500,physical.y))
 else: get_window().content_scale_size = Vector2i(390,844)
