<head>
  <link rel="preload" href="https://github.com/user-attachments/assets/d9a68f1d-c8c2-4b5a-84fa-fe8146ffaf7f" as="image" fetchpriority="high" />
  
  <link rel="preload" href="https://github.com/user-attachments/assets/a2cefc53-82f1-45c2-a3e9-86b311d7932f" as="image" fetchpriority="high" />
  <link rel="preload" href="https://github.com/user-attachments/assets/6e8fbeb4-7894-48cc-b35a-bcc9d99b355e" as="image" type="image/gif" fetchpriority="high" />
  <link rel="preload" href="https://github.com/user-attachments/assets/4c8016a3-1c4f-4a2d-9770-a3ae944b18a7" as="image" fetchpriority="high" />
  <link rel="preload" href="https://github.com/user-attachments/assets/9e72dd2e-cf51-429c-b812-5427556982c8" as="image" type="image/gif" fetchpriority="high" />
</head>
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

**You can download the game from [GitHub Releases](https://github.com/orivio/super_orbital/releases/tag/v.1.0.0-alpha).**

For GitHub, find the latest release (**v.1.0.0-alpha**) and expand **Assets** at the bottom. Then, download the correct file depending on your platform.

## Windows
1. Download **superorbital_win.zip**.
2. Unzip the file.
3. Double click on **superorbital.exe** to run the game.

Windows Defender may give you a warning that the file is unsafe. You can bypass this by pressing **More Info** and then **Run Anyway**.
<details>
<summary>
Troubleshooting
</summary>
Some antiviruses might incorrectly flag this game as suspicious because the executable is not digitally signed. You may have to temporarily allow the game through your antivirus software panel.
</details>

## macOS
Once you download **superorbital_mac.tar.gz**, you must unzip the file. Then, right click on the app **SuperOrbital**, and press **Open**. DO NOT simply double click the file, as Gatekeeper may block the game.
<details>
<summary>
Troubleshooting
</summary>

On some newer Apple devices, the above mentioned method for bypassing Gatekeeper might not work. You can try this method, though:
1. Open **System Settings**
2. Go to **Security & Privacy**
3. Scroll all the way down to **Security**
4. Look for a message that says something like **"Super Orbital was blocked to protect your Mac."**
5. Click **Open Anyway**.
6. Type in your password in the next popup.
7. Then try again to open the application.

</details>

## Linux
Once you download **superorbital_linux.tar.gz**, you must extract the file.
Using command line tools:
1. Navigate to where you downloaded the file.
2. Extract the file:
```tar -xf superorbital_linux64.tar.gz```
3. Run the game:
```./superorbital_linux64.x86_64```

If you use a graphical file manager, the exact process of extracting the file depends on which file manager you use.

<details>
<summary>
Troubleshooting
</summary>

<p>
If you get a message saying invalid permissions or permission denied, it may be that the file is not marked as executable by default.
</p>
<ol>
<li>Give executable permissions to the file: <code>chmod +x superorbital_linux64.x86_64</code></li>
<li>Try to run again:<code>./superorbital_linux64.x86_64</code></li>
</ol>
</details>

# Features
SuperOrbital features these unique platformer mechanics that are used in creative ways to make fun levels:
- Gravity Toggling: You can turn off your gravity suit midair. Your momentum will continue until you turn gravity on again.
- Wrench Throws: You can throw a wrench while your gravity is disabled, launching you in the opposite direction.
- Black Holes: If you enter a black hole, you will slowly get pulled into the center while orbiting. You can move away from the center or change your orbit direction.


# Links
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
## The Concept
My teammate, @orivioxyz, wanted to make a platformer game. We considered making a platformer where you could build part of the level first, and then play through it, with some restrictions. This idea took some inspiration from games like Ultimate Chicken Horse or Robert Alvarez Games. However, we decided to make a precision platformer with unique gravity mechanics, like switching off gravity midair and continuing your momentum in that direction for a bit. After a bit of boredom during school downtime, our game’s story emerged. The protagonist, who we originally named "Lone Kid", was born an anomaly - the only object ever discovered to be entirely unaffected by natural gravity. As Lone Kid grew up, he came to be known as Sad Guy, due to his constant depression of being left out of normal sports and activities. His great uncle, Dr. Harfingjingles, developed a Suit of Artificial Density (S.A.D., what a pun!) which was carefully tailored to solve Sad Guy’s problems. This suit provided Sad Guy with an effective, though uncomfortable and claustrophobic, solution to his lack of gravity. Armed with this special machinery, including jets, oxygen filters, and a backpack fabricator, Sad Guy would venture out into deep space in his personal spacecraft.

Eventually, we decided to rename some of the characters.
- Lone Kid/Sad Guy &rarr; Vitri
- Assistant &rarr; Grav
- Dr. Harfingjingles &rarr; Dr. Hearth

We chose the names Grav and Vitri as a subtle play on the word Gravity.

## Artwork
The creation of the game’s artwork is an iterative process. I first created a base for the Vitri’s sprite, made of separate, individually colored layers.

<img width="513" height="512" alt="a rough block-out of Vitri's sprite using color coded layers for each limb." src="https://github.com/user-attachments/assets/5dc894ec-6aa2-4574-98ef-1b9f9cbe5c71" />

I then drew a few rough animations for Vitri moving in different ways. Doing it this way was much easier than animating a fully colored and shaded sprite because I was able to make positional early on. I did end up changing the proportions a bit, and finally, I came up with this:

<img width="410" height="430" alt="the final polished Vitri sprite" src="https://github.com/user-attachments/assets/4323dbb7-819b-4a75-a1a9-5415be8fe76b" />

Sadly, I lost access to the original .aseprite file, so all of my previous layers are gone, and I only have the final rendition of the player. This would make it hard to add new animations, but ultimately, it's fine because I finished the sprite anyway.

I used a Godot Shader to give the player an outline to convey what gravity state they are in.

<img width="800" height="450" alt="the player sprite switches between a green, red, and black outline." src="https://github.com/user-attachments/assets/75e8f6d3-8cb7-4d6c-8b4c-bfd3851f7d29" />

- A green outline means they are being affected by normal gravity.
- A red outline means gravity is turned off.
- A black outline means they are inside a black hole.

For the tileset, we decided that it should be Mars themed, with orange and brown dirt and rocks.

<img width="385" height="385" alt="part of the mars tileset" src="https://github.com/user-attachments/assets/3ff09f59-7dd3-4444-b067-b1e4a2aaac2d" />

Later, we needed more tiles for the facility section of the game, so I added a bunch more:

<img width="512" height="512" alt="full tileset" src="https://github.com/user-attachments/assets/2254e438-b60b-491f-a240-ed1743a61ad3" />

## Music
Hey everyone, ori here. I made most of the music in FL Studio. Here are the soundtracks I made:
- OST 0: lone traveler
- OST 1: quest of the anomaly
- OST 2: martian overture
These took heavy inspiration from the works of Hans Zimmer in Interstellar and Ludwig Goransson in Oppenheimer.

They’re mostly piano-based with some brass synths to add melody. The goal is to maintain a degree of ambience, so as to not sound off when juxtaposed with the pacing of the game. Though keeping it ambient can be difficult at times - I tend to get carried away - I think it’s going pretty well considering it’s my first time making music of this sort.

You can check out the OST on my [YouTube Channel](https://www.youtube.com/watch?v=3Za3iscuWWM&list=PLQn6yFmlK8lc).

Hi, this is Obed. My brother Wally and I made the song "**Origins**". We used FamiStudio, a retro music software.

We got our instruments from FamiStudio's **Instruments EPSM** pack, which is a collection of demo instruments from the EPSM expansion pack. These instruments have a retro feel and originate from the NES days, but give us more expression than just the NES's original APU.

<img width="1541" height="622" alt="The FamiStudio project of Origins" src="https://github.com/user-attachments/assets/34f3b2e2-4d8f-4bc9-bf15-7e60a6eda6dc" />

I myself have little to no music experience, but my brother has a lot, so much thanks to him.

## Level Design
This was one of the hardest parts of development, since we didn't have much experience making levels for platformer games.

Initially, we planned a highly structured ordering of levels, with 5 sections, and 5 levels per section. Each section would focus on a different mechanic, like jumping, dashing, moving platforms, black holes, etc... We would gradually increase the difficulty per section, and introduce more complex mechanics later.

But we later realized two problems with this approach.
1. It's a good idea to introduce our game's unique mechanics as soon as possible, to provide a hook that will make the player interested.
2. Levels are much more fun if they combine 2-3 different mechanics together, or even all of them at once.
We decided to reorganize all of our levels, and the result turned out much better.

### Scrapped Environment Art
For a brief period of time, I tried making more advanced environment art, detailing snow, hoodoos, and sand dunes.

<img width="49%" alt="A level from the game that shows hoodoos in the background and a sunset." src="https://github.com/user-attachments/assets/39be35a0-f549-4d24-9338-f67e9a3127f1" />

<img width="49%" alt="A level from the game that shows a snowy tileset and particles." src="https://github.com/user-attachments/assets/6f14adf5-e758-4697-a88e-fb571575a37e" />

Eventually, we decided that it didn't fit the story well enough, because the player is underground, it doesn't make sense to have snow. I would like to bring back this art in the future, though, because I think it looks great.

## Game Architecture
In order for the game to do anything at all, we had to program a bunch of systems that all worked together.
To name a few,
- The **World** system is responsible for loading and transitioning levels.
- The **Save** system is responsible for tracking data that persists between gameplay sessions. When you quit the game, your progress should stay.
- The **Dialogue** system is responsible for storing and displaying lines of dialogue.
- The **GameManager** system is responsible for orchestrating everything. It is an autoload singleton, meaning it is always loaded in memory and can be accessed from anywhere. It is responsible for performing camera shakes, hitstop, and linking different systems together.

Each one of these took a considerable amount of time to program, and they came with their fair share of bugs. I actually rewrote the world system TWICE because I wasn't satisfied with how levels were stored, how transitions happened, and the readability of the code.

To be honest, this game's architecture is not the best. There are multiple instances of code duplication, multiple sources of truth, and overreliance on global singletons. But hey, the game works just fine!

## Player Movement
We seriously underestimated how complex this would be. A player movement script that feels good to play with no bugs is VERY difficult to build. I ended up rewriting the entire player script from scratch, plus custom debugging tools.

<img width="542" height="747" alt="a small snapshot of the player movement settings" src="https://github.com/user-attachments/assets/4d68c4c2-3325-45d5-83e9-ea71af629dc0" />

Here's a small snapshot of the player's movement settings. You can probably tell that there's a lot of them, they don't all fit on the screen!

You can check out our documentation for the player script [Here](./player.md). We wrote this document to help keep ourselves organized and help others understand our code better.


https://github.com/user-attachments/assets/8ddc9a2f-f6f5-43fa-967f-d2d72e76284d

(Sorry for the bad video quality, I took this clip a while ago).

One of our most notorious bugs was what we called the **Dash Platform Bug**. Basically, if the player dashed into a moving platform, there was a TINY chance that their position would clip to infinity, crashing the game. The bug was so inconsistent and hard to replicate that even after rewriting the entire player script from scratch, I still had no clue how to fix the bug. After taking a break on this matter for a few weeks, I figured it out.

Instead of trying to address the root of the problem, I could just add a test for whether the player clipped out of bounds. If they did, they would be teleported back to where they were before. Suddenly, the bug was completely fixed, and the only thing that remained was a tiny hiccup in the player's velocity. From this, I learned that sometimes, it's best to address the symptom rather than the cause ;)

## Cutscenes

After we planned out the story, we [drafted a quick idea of what we wanted the introduction to look like](./cutscenes.md). We then let it sit for a while, because we wanted to focus on the core gameplay first. After our first playtest, many people were confused about the story, so we got to work on animating the intro cutscene.

As it turns out, animating was way harder than I thought. This scene alone took me 5+ hours:
<img width="985" height="557" alt="A frame from the intro cutscene; Vitri sitting on a bench, looking sad." src="https://github.com/user-attachments/assets/4dbf5c6a-2c54-4fc4-8812-0f9ad15a55ca" />

... And I'm still not satisfied with it.

