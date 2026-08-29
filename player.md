# Player Script
## Movement Tech
### Jumping while slightly above the ground
In order to detect whether the player is on the ground and whether a jump is 
available, the player script uses a downward raycast. This raycast points 
slightly below the player's collision shape, so even if you are a tiny bit 
above the ground, you can still jump.

### More control when falling
When you are in the falling part of your jump, you have more control over where
you land, because it takes less time to accelerate to your maximum speed.
