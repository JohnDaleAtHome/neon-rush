extends RefCounted
# The source notice must remain in every export that contains the adapted house.
const NOTICE_PATH="res://HAN-HOUSE-LICENSE.txt"
const CONTRIBUTORS="Other reused art (CC0)\nQuaternius: bunny rig/animations and Stylized Nature MegaKit.\nhttps://poly.pizza/m/irZjWFARyl\nhttps://quaternius.com/packs/stylizednaturemegakit.html\n\nPoly Haven: Moon 01 and Aerial Beach 01 textures.\nhttps://polyhaven.com/a/moon_01\nhttps://polyhaven.com/a/aerial_beach_01\n\nVVayToyek: Chinese four-corner pavilion.\nhttps://vvaytoyek.itch.io/chinese-four-corner-pavilion-free\n\nInnerscene: Buddhist Temple Pagoda.\nhttps://www.innerscene.com/tools/library/3d-parts/buddhist-temple-pagoda-c5ebacdc\n\nPixor: Turtle.\nhttps://pixor.art/library/creatures/turtle/\n\nMish7913: Hay Bale.\nhttps://opengameart.org/content/hay-bale-0\n\nCC0 terms: https://creativecommons.org/publicdomain/zero/1.0/\nModels/textures are adapted as recorded in the source repository. Original story illustrations, interface art and synthesized audio were made for this game. No endorsement is implied.\n\n"
static func text() -> String:
 return "Han house / 0 A.D.\nOriginal author: Wildfire Games\nhttps://www.wildfiregames.com/\nCC BY-SA 3.0\nhttps://creativecommons.org/licenses/by-sa/3.0/\n\nAdapted for this game: static DAE converted to GLB, coordinate transform applied, texture reduced and alpha removed. The adapted model remains CC BY-SA 3.0. This notice does not relicense independent game code or imply endorsement.\n\n"+CONTRIBUTORS+"Full Han house source and license notice:\n\n"+FileAccess.get_file_as_string(NOTICE_PATH)
static func open(game):
 var blocker=Control.new()
 blocker.name="ArtCreditsBlocker"
 blocker.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 blocker.mouse_filter=Control.MOUSE_FILTER_STOP
 game.overlay_root.add_child(blocker)
 var list=game.popup_frame("ART CREDITS")
 var panel=list.get_parent().get_parent() as PanelContainer
 var arrange=func():
  var size=game.get_viewport().get_visible_rect().size
  var width=minf(370,size.x-20)
  panel.position=Vector2((size.x-width)/2,20 if size.y<650 else 70)
  panel.size=Vector2(width,minf(690,size.y-(40 if size.y<650 else 90)))
  list.get_parent().custom_minimum_size=Vector2(width-32,minf(650,size.y-(80 if size.y<650 else 130)))
 arrange.call()
 game.get_viewport().size_changed.connect(arrange)
 panel.tree_exiting.connect(func():
  blocker.queue_free()
  if game.get_viewport().size_changed.is_connected(arrange):game.get_viewport().size_changed.disconnect(arrange)
 )
 var body=Label.new()
 body.name="ArtCreditsNotice"
 body.text=text()
 body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 body.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 body.add_theme_font_size_override("font_size",15)
 list.add_child(body)
 var close=Button.new()
 close.text="DONE - CLOSE CREDITS"
 close.custom_minimum_size.y=44
 close.pressed.connect(func(): panel.queue_free())
 list.add_child(close)
 return list
