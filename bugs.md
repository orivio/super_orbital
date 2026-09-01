# Movement Bugs
## Alternating Directions Halt
Details:
- When you move back and forth by alternating left and right arrow keys, you 
can sometimes get stuck where you hold one button down, but you don't move.
- Once you release the button, you can move normally as if nothing happened.
- This is not the same as pressing both buttons at the same time causing you to
stand still. That's expected behavior. This is a rare occurrence that I'm not 
completely sure how it is caused.
Replication:
- Replication is extremely difficult, and can take over 10 minutes.
- It has been replicated around 4 time so far.
- I managed to capture this behavior on an inupt recording sequence once, and I
have replayed it.
	- The part where the bug happens occurs during the part where you stay still
	for a long time. During this time, I was pressing the left arrow key and 
	only the left arrow key, but I wasn't moving.
	- I can share this file to anyone if they would like
## Players can double jump when very low to the ground due to coyote time
Details:
- If you jump up a very low amount, then, as you are falling down, you can jump 
again to gain a little bit more height.
- This might not be a problem, maybe it could be considered movement tech for 
speedrunners
- It doesn't feel very weird in game, and it's difficult to pull off 
intentionally.
Replication:
- Moderately easy to replicate.
- Turn the engine time scale to 1/16, press the jump button and quickly release
it. Just a little bit above the ground, you can press the jump button again and
you will do a double jump.
### Dash direction normalization (0, 0)
Details:
- This issue might be fixed, but just look out for if you see it.
- During some situations if you dash, the game will turn completely blank and 
a bunch of warning messages will spam the debugger, which have to do with 
trying to normalize the vector (0, 0). This warning is associated with 
player.gd:243.
Replication:
- I replicated the bug twice, but once I made a certain change, I never saw it 
again, even after I reverted the change.
- The only times I was able to replicate it happened to be on a moving platform 
in "More Platform Timing" (```res://levels/3_moving_platforms/momentum.tscn```)

# World Bugs
## Level transition bug between the moving platforms level and the bridge level

# UI Bugs
## Pressing a button during a screen fade
Details:
- Pressing the quit button on the main menu immediately after pressing the play
button
- Selecting another level after already selecting a level in the level select
screen
Replication:
- You can turn the engine time scale to 1/16 to make it easier to replicate
Progress:
- Mostly fixed.
