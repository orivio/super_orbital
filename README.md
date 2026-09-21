<img width="960" height="400" alt="KhjbeU" src="https://github.com/user-attachments/assets/d9a68f1d-c8c2-4b5a-84fa-fe8146ffaf7f" />

# Super Orbital
Super Orbital is a 2D precision platformer where you can toggle gravity midair, throw wrenches to control your momentum, and orbit black holes to slingshot around the level. In this game, you play as Vitri, a gravitational anomaly who sets out to the stars to find his own source of gravity. Vitri wears the Suit of Artifical Density, which lets him control gravity. Enjoy challenging levels, a simple storyline, and creative ways of moving through levels.

SuperOrbital features three unique platformer mechanics:
- Gravity Toggling: You can turn off your gravity suit midair. Your momentum will continue until you turn gravity on again.
- Wrench Throws: You can throw a wrench while your gravity is disabled, launching you in the opposite direction.
- Black Holes: If you enter a black hole, you will slowly get pulled into the center while orbiting. You can move away from the center or change your orbit direction.

- [Download the game from itch.io](https://obedh.itch.io/superorbital/)
- [Check out our documentation of the player script](./player.md)
- [See how we planned the story](./story.md)
- [See how we planned the cutscenes](./cutscenes.md)
- [View our plans for after stardance](./todo.md)
- [Read the credits](./CREDITS.md)
- [Read the bugs list](./bugs.md)
- [Inspect the License (MIT License)](./LICENSE)

<img width="480" height="270" alt="Navigate across the martian landscape" src="https://github.com/user-attachments/assets/a2cefc53-82f1-45c2-a3e9-86b311d7932f" />
<img width="480" height="270" alt="The player navigating through a tricky level using fun gravity mechanics" src="https://github.com/user-attachments/assets/6e8fbeb4-7894-48cc-b35a-bcc9d99b355e" />
<img width="480" height="270" alt="Loop around black holes" src="https://github.com/user-attachments/assets/4c8016a3-1c4f-4a2d-9770-a3ae944b18a7" />
<img width="480" height="270" alt="Fly through a Dangerous Facility" src="https://github.com/user-attachments/assets/9e72dd2e-cf51-429c-b812-5427556982c8" />



# How to Install and Play the Game

This game supports Windows, Linux, and MacOS on 64 bit systems.

You can download the game from GitHub Releases or from Itch.io.

For GitHub, get the latest release by clicking **Releases** in the sidebar and downloading the correct zip file for your platform.

For Itch.io, go to [https://obedh.itch.io/superorbital](https://obedh.itch.io/superorbital), and scroll down to the **Download Now** button. You can choose to donate, or press **No thanks, just take me to the downloads**. Then, download one of the files depending on what device you are on.

## Windows
Once you download **superorbital_win64.zip**, you must unzip the file. Then, double click on **superorbital.exe** to run the game. Windows Defender may give you a warning that the file is unsafe. You can bypass this by pressing **More Info** and then **Run Anyway**.
### Troubleshooting
If you run into some other antivirus message, you may need to temporarily disable your antivirus to run the game.
## MacOS
Once you download **superorbital_mac.zip**, you must unzip the file. Then, right click on **Super Orbital.app**, and press **Open**. DO NOT simply double click the file, as Gatekeeper may block the game.
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
Once you download **superorbital_linux64.tar.gz**, you must extract the file.
Using command line tools:
- Navigate to where you downloaded the file.
- Extract the file:

```tar -xf superorbital_linux64.tar.gz```
- Run the game:

```./superorbital_linux64```

If you use a graphical file manager, the exact process of extracting the file may depend on which file manager you use.
### Troubleshooting
If you get a message saying invalid permissions or permission denied, it may be that the file is not marked as executable by default.
- Give executable permissions to the file:

```chmod +x superorbital_linux64```
- Try to run again:

```./superorbital_linux64```

## Controls (remappable)
- Left and Right arrow keys to walk left and right
- Z to jump
- C to dash
- X to turn gravity on/off
- Arrow Keys + C to throw a wrench in the opposite direction to where you want to go
- C to change orbit direction while inside a black hole
- Up arrow to move away from the center of a black hole

# The Making of SuperOrbital
