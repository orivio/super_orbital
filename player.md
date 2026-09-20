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

## Juice Mechanics
The player's movement has several features which help make the game feel more fun to play.
- Variable Jump Height
  - If you hold down the jump button for longer, you will jump higher.
  - This gives the player more control over their jumps, and lends itself to new level designs.
  - <img width="249" height="253" alt="jump_gif" src="https://github.com/user-attachments/assets/a1a99240-04f2-4c51-b499-10ff1b3c8fc3" />
- Input Buffering
  - If you press a button a little too early, you can still perform the action as soon as you are able.
  - This mechanic is applied to jumping, starting a dash, entering the float state, and throwing a wrench.
  - INSERT GIF
- Coyote Time
  - If you press the jump button a little too late, you can still jump even after you have started falling.
  - INSERT GIF
- Fall Multiplier
  - When you start falling down after a jump, your gravity is increased by a multiplier, making you fall faster.
  - This makes your jump feel more controlled and less floaty.
  - INSERT GIF
- Shockwave Warp Effect
  - This effect happens when you disable gravity, making the action feel a little more responsive.
  - INSERT GIF
- Camera Shake
  - The camera shakes a little bit to signify some kind of impact.
  - This effect is toggleable under Settings > Graphics > Camera Shake.
  - This effect is applied to player death, turning off gravity, turning on gravity, bouncing off a wall while in ```FloatState```, or starting a dash.
  - INSERT GIF
- Hitstop (aka Freeze Frames)
  - The game freezes for a fraction of a second, also signifying impact.
  - This effect is toggleable under Settings > Graphics > Hitstop.
  - This effect is applied to player death, throwing a wrench, turning off gravity, turning on graivty, bouncing off a wall while in ```FloatState```, or starting a dash.
  - INSERT GIF
- Clip Nudges
  - If you are jumping or dashing into a ledge and you are just barely about to hit the ledge, the game will nudge you to correct your trajectory and avoid the ledge.
  - This makes gameplay easier and feel more fair.
  - INSERT GIF
