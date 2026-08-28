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
