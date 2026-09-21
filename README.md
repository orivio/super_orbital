<img width="960" height="400" alt="KhjbeU" src="https://github.com/user-attachments/assets/d9a68f1d-c8c2-4b5a-84fa-fe8146ffaf7f" />

# Super Orbital
**Super Orbital is a 2D precision platformer where you can toggle gravity midair, throw wrenches to control your momentum, and orbit black holes to slingshot around the level.**

In this game, you play as Vitri, a gravitational anomaly who sets out to the stars to find his own source of gravity. Vitri wears the Suit of Artifical Density, which lets him control gravity. Enjoy challenging levels, a simple storyline, and creative ways of moving through levels.

*This project was made for [Stardance](http://stardance.hackclub.com/).*

<img width="49%" alt="Navigate across the martian landscape" src="https://github.com/user-attachments/assets/a2cefc53-82f1-45c2-a3e9-86b311d7932f" />
<img width="49%" alt="The player navigating through a tricky level using fun gravity mechanics" src="https://github.com/user-attachments/assets/6e8fbeb4-7894-48cc-b35a-bcc9d99b355e" />
<img width="49%" alt="Loop around black holes" src="https://github.com/user-attachments/assets/4c8016a3-1c4f-4a2d-9770-a3ae944b18a7" />
<img width="49%" alt="Fly through a Dangerous Facility" src="https://github.com/user-attachments/assets/9e72dd2e-cf51-429c-b812-5427556982c8" />

## Trailer
[INSERT TRAILER]

# How to Play

This game supports Windows, Linux, and macOS on 64 bit systems.

**You can download the game from [GitHub Releases](https://example.com/) or from [Itch.io](https://obedh.itch.io/superorbital).**

For GitHub, find the latest release (v.1.0.0-alpha) and expand **Assets** at the bottom. Then, download the correct file depending on your platform.

For Itch.io, click the **Download Now** button. You can choose to donate, or press **No thanks, just take me to the downloads**. Then, download one of the files depending on what device you are on.

## Windows
Once you download **superorbital_win.zip**, you must unzip the file. Then, double click on **superorbital.exe** to run the game. Windows Defender may give you a warning that the file is unsafe. You can bypass this by pressing **More Info** and then **Run Anyway**.
### Troubleshooting
Some antiviruses might incorrectly flag this game as suspicious because the executable is not digitally signed. You may have to temporarily allow the game through your antivirus software panel.
## macOS
Once you download **superorbital_mac.tar.gz**, you must unzip the file. Then, right click on the app **SuperOrbital**, and press **Open**. DO NOT simply double click the file, as Gatekeeper may block the game.
### Troubleshooting
On some newer Apple devices, the above mentioned method for bypassing Gatekeeper might not work. You can try this method, though:
- Open **System Settings**
- Go to **Security & Privacy**
- Scroll all the way down to **Security**
- Look for a message that says something like **"Super Orbital was blocked to protect your Mac."**
- Click **Open Anyway**.
- Type in your password in the next popup.
- Then try again to open the application.
## Linux
Once you download **superorbital_linux.tar.gz**, you must extract the file.
Using command line tools:
- Navigate to where you downloaded the file.
- Extract the file:

```tar -xf superorbital_linux64.tar.gz```
- Run the game:

```./superorbital_linux64.x86_64```

If you use a graphical file manager, the exact process of extracting the file depends on which file manager you use.
### Troubleshooting
If you get a message saying invalid permissions or permission denied, it may be that the file is not marked as executable by default.
- Give executable permissions to the file:

```chmod +x superorbital_linux64.x86_64```
- Try to run again:

```./superorbital_linux64.x86_64```
# Features
SuperOrbital features these unique platformer mechanics that are used in creative ways to make fun levels:
- Gravity Toggling: You can turn off your gravity suit midair. Your momentum will continue until you turn gravity on again.
- Wrench Throws: You can throw a wrench while your gravity is disabled, launching you in the opposite direction.
- Black Holes: If you enter a black hole, you will slowly get pulled into the center while orbiting. You can move away from the center or change your orbit direction.


# Links
- [Download the game from itch.io](https://obedh.itch.io/superorbital/)
- [Check out our documentation of the player script](./player.md)
- [See how we planned the story](./story.md)
- [See how we planned the cutscenes](./cutscenes.md)
- [View our plans for after stardance](./todo.md)
- [Read the credits](./CREDITS.md)
- [Read the bugs list](./bugs.md)
- [Inspect the License (MIT License)](./LICENSE)





## Controls (remappable)
|Key|Action|
|-|-|
|Left|Walk left|
|Right|Walk right|
|Z|Jump (hold the button longer to jump higher)|
|C|Dash (use arrow keys to dash in a specific direction)|
|X|Toggle gravity|
|Arrow Keys + C|Throw a Wrench (launching you in the opposite direction)|
|C (inside a black hole)|Reverse orbit direction|
|Up (inside a black hole)|Move away from the center of the black hole|

# The Making of SuperOrbital
