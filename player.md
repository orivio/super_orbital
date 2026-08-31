# Player Script
## Movement Tech
### Jumping while slightly above the ground
In order to detect whether the player is on the ground and whether a jump is 
available, the player script uses a downward raycast. This raycast points 
slightly below the player's collision shape, so even if you are a tiny bit 
above the ground, you can still jump.
This is very difficult to pull off. I could make it easier.

### Double jumping using coyote time
Press the jump button and quickly release it. After rising up a tiny amount,
press the jump button again and hold it. You will perform a double jump in the
air, and go quite a bit higher. You have around 0.1 seconds, or 6 frames, to 
perform this, but if you want to jump absolutely as high as you possibly can,
it would be frame perfect.

### More precision when landing a jump
In the first part of you jump, your previous momentum carries over and it's 
harder to start or stop moving horizontally. Once you start falling, though, 
there is less air friction, and you can determine where you want to land more 
precisely.
