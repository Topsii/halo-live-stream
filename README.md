### Flash client for (live) Replays of Halo: Combat Evolved (PC) multiplayer games

This project is not working, because [Flash support was discontinued by Adobe](https://www.adobe.com/products/flashplayer/end-of-life.html)

Further this client is only one of three components:
1. [Phasor](https://haloapps.wordpress.com/) script to record game information live and either save it to a file or send it to a distribution server
2. Replay distribution server that is capable of streaming replays from a database of currently running or finished games
3. Flash client running in the browser of a spectator.
 

The client displays game information from a replay file or livestream including:
 - Animated player movement in the 3D game world such as
   - the paths taken by the players
   - their head/camera orientations
   - consistent strafing animation
 - Player scores
 - Chat activity

The client supports 
 - a first person camera for each player 
 - a free roaming spectator controlled camera with the same controls as the built-in `debug_camera` from the Halo game.
 - pausing
 - instantaneous seeking to every moment in the game

There is further documentation in German:
 - [Projekt.pdf](Projekt.pdf)
 - [Praesentation.pdf](Praesentation.pdf)