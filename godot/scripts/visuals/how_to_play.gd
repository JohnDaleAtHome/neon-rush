extends RefCounted
# Read-only reference. Keep these mappings aligned with main.gd input handlers.
const SECTIONS = [
 ["KEYBOARD", "Move: Left / Right arrows or A / D.\nJump: Space, Up arrow or W.\nSlide: Down arrow or S in Story, Chase and Mission.\nFire moonlight: F during Guardian fights.\nPause / resume: P or Escape. Sound: M."],
 ["TOUCH", "Swipe left / right to change lanes, up to jump, down to slide. Slide works in Story, Chase and Mission.\nTap the open play area to jump when Tap to jump is on.\nUse the movement buttons or hide them in Settings. FIRE stays visible during Guardian fights. Tap PAUSE to stop the run."],
 ["STORY AND SAVES", "Gather six dew drops on Earth in the Meadow. Silver Dunes is on the Silver Moon, Cinnamon Grove on the Cinnamon Moon, and Storm Sea on the Storm Moon. Dunes through Comet show path progress. Treats add score; they are not bridge pieces.\nCollect all five bridge pieces in order. Help the firefly, greet the turtle and offer the shadow a treat.\nStory saves completed level checkpoints in this browser. A retry starts the current level again, not where you fell. Clearing browser data can remove saves. JSON / CSV exports contain stats, not a restorable journey save."],
 ["READ THE TRACK", "JUMP marks a low obstacle. SLIDE marks an arch. Dodge tall obstacles by changing lanes.\nIn the Shadow Comet, collect light and avoid hits to keep the shadow back.\nAt the Guardian, line up with its lane and fire when the shield opens. After two hits in one opening, wait for the next green shield."],
]
static func open(game):
 var list = game.popup_frame("HOW TO PLAY")
 var panel = list.get_parent().get_parent() as PanelContainer
 for section in SECTIONS:
  var heading = Label.new()
  heading.text = section[0]
  heading.add_theme_font_size_override("font_size",18)
  list.add_child(heading)
  var body = Label.new()
  body.text = section[1]
  body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
  body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  body.add_theme_font_size_override("font_size",15)
  list.add_child(body)
 var close = Button.new()
 close.text = "DONE - CLOSE HELP"
 close.custom_minimum_size.y = 44
 close.pressed.connect(func(): panel.queue_free())
 list.add_child(close)
 load("res://scripts/visuals/hud_theme.gd").style_popup(list)
 list.get_child(1).grab_focus()
 return list
