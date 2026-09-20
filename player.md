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

### Dash cancelling
A dash has two phases. In the first phase, you have the most speed, and you 
can't change your trajectory by pressing any inputs. In the second phase, you 
can slightly change your trajectory using the arrow keys. You can also cancel 
the dash by pressing the jump button. You won't actually jump, but the dash 
will stop immediately.

## State Machine
The Player script has 7 states that are used in game:
- ```IdleState```: When the player is completely still and not moving while standing on the ground.
- ```WalkState```: When the player is walking left or right on the ground.
- ```JumpState```: When the player's velocity is moving upwards while being affected by normal gravity.
  - It does not necessarily mean the player literally pressed the jump button.
- ```FallState```: When the player's velocity is moving downwards while being affected by normal gravity.
  - Gravity is stronger on the way down than on the way up, to give the jump a snappier feel.
- ```FloatState```: When the player has switched off gravity and is floating in some direction.
  - In this state, the player will bounce off walls.
  - If it enters a black hole, it will transition to a ```BlackHoleState```.
  - If the player throws a wrench, the player will start moving in the opposite direction to where the wrench was thrown, while maintaining their magnitude of velocity.
- ```BlackHoleState```: When the player is inside a black hole and is being affected by its gravity.
  - The player will orbit the blackhole and get gradually pulled inwards, but the player can move away from the black hole by pressing up.
  - The player can also switch orbit direction, which is normally bound to the C key, or switch off gravity and start floating away.
- ```DashState```: When the player is performing a dash.
  - A powerful boost of velocity is applied to the player.
  - The player is not affected by normal gravity, but will transition to a ```BlackHoleState``` if it enters a black hole.
  - As mentioned before, the player can cancel the dash early by pressing Jump.
