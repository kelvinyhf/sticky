# Sticky
He looks like a sticky note, doesn't he?

<img src="./sticky/default.png" alt="Sticky" width="240" height="240" />

## Try to...
- Hover it!
- Drag it!
- Double-click it!

## How I Made It
I made all the textures (idle, blink, and happy) using Pixen on my iPhone, and the executable using Godot.
Here's an example of how it blinks:
```
sprite.texture = tex_blink
await get_tree().create_timer(0.1).timeout
sprite.texture = tex_normal
```
This sets the sprite's texture to blink, waits for 0.1 seconds, and changes it back to normal. Kinda simple :)

Same logic for hovering, just change it to a happy face when the mouse enters the window (hovering over the pet):
```
func _on_mouse_entered():
	is_hovering = true
	sprite.texture = tex_happy
func _on_mouse_exited():
	is_hovering = false
	sprite.texture = tex_normal
```

Since it looks like a sticky note, it should be able to take notes! This is called when double-clicked:
```
if event.double_click:
  OS.shell_open("https://gist.github.com/")
```
And it opens GitHub Gist in a new tab for quick note-taking!
(I tried to implement my own note-taking system, but it was too hard :/)
