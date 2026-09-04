Russlan:
- Re assign the music to the rooms (I'm sorry)
- Finish the banner
- Feedback on Obed and Wally's song (the intro song)
- Make an image for the title
- Dynamic lighting or whatever he was talking about

Obed:
- Fix level transition bug in room_cant_stop and room_perchrit where a room is skipped
- Should I add a buffer to the float state such that right after you land from 
a regular jump, if you press the grav switch button, you will bounce as if you 
had been floating the entire time? It could improve the game juice, but I don't
know how to implement it
- Draw the holographic planet lookup scene in the intro cutscene
- Make a better background
- Make the player camera follow the player better
- Implement the black hole mechanic
- Clean up jump_state.gd's coming_from_dash spaghetti code
- Make the dash afterimage effect look better
- Redo player movement
	- Which will involve redesigning some levels
- Add variation to tileset...
- Refine room_gilganas (it just kind of feels like a boring level when it has a
lot of potential)
- Add more black hole levels
- Make the level select screen start on the page where your last completed level
is
- Fix the text shifting on the buttons
- Make the impact particles not be dust particles if you're colliding with
metallic ground
- Add different jump landing sound effects depending on what surface you land 
on
- Fine tune the dash timing
- Maybe a player death animation
- Clean up the slightly spaghetti code with reloading levels, really, Play 
should be responsible for deciding to reload the level, and level_manager 
shouldn't care if the player had just died
- Potentially add checkpoints
- Fix tile inconsistencies across many levels


Both, or whoever wants to:
- Make a better favicon
	- I think we have something good
- Make sound effects for movement, ui, and dialogue


Stuff more later (after stardance):
- Make room transitions seamless and have the camera quickly shift like in Celeste
or Zelda
- Make challenge levels
- Finish all the acts of the game

Playtesting questions:
- Should the caution tiles always be next to the spikes? If so, wouldn't it be
too much caution tiles?
- Is the pacing good?
- Does the UI look bad?
- Do the difficulty settings properly accomodate all or most types of players?
