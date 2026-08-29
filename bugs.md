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
## Player gets stuck in the floor when starting the game on the first level
Details:
- The player sometimes starts off inside the floor, glitching sideways a bit.
- You can't get out by just pressing keys.
Replication:
- Very easy to replicate, happens often.
- So far, it never happens the first time you open the game.
	- It only happens when reloading the level
- Sometimes it can be inconsistent and difficult to replicate for a little 
while.
- So far, only happens in the first level.
- I have not managed to get this bug when the engine scale is on 1/16.

# UI Bugs
## Pressing a button during a screen fade
Details:
- Pressing the quit button on the main menu immediately after pressing the play
button
- Selecting another level after already selecting a level in the level select
screen
Replication:
- You can turn the engine scale to 1/16 to make it easier to replicate
