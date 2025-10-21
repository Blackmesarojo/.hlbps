	/*==========================================================================
	
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠉⠁⠄⠄⠄⠄⠄⠄⠄⢈⣉⣙⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⡃⠄⠄⠄⢀⠄⠄⠄⠄⠄⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠄⠈⠙⡁⠉⠁⠄⠄⠄⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠄⠄⠄⠄⠄⡱⠄⠄⠄⠄⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠄⠄⠄⠄⠄⢸⠄⠄⠄⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠄⠄⠄⠄⠄⠄⠄⠄⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠄⠄⠄⠄⠄⠄⠄⠄⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⢀⠄⠄⠄⠄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠄⠄⠄⠈⠳⠤⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠄⠄⠄⣤⣀⡀⠄⠄⠄⠄⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢛⣩⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠄⠄⠄⣠⣾⣿⣿⣿⣿⣶⣦⣤⣀⠄⠄⠄⠈⠙⠻⢿⣿⣿⡿⠿⠛⢉⣡⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣄⠄⠄⠄⣽⣯⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠄⠄⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠄⠄⠈⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠄⠄⠄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠄⡀⠄⠄⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠄⠘⠉⠛⠻⠿⣿⣿⣿⣿⡿⠁⠄⠈⠄⠄⡄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠁⠄⠄⠄⠄⣀⠄⠄⠄⠄⠈⠉⠉⠄⠄⠄⠄⢀⣾⣷⣿⣿⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠄⢀⣀⣀⣤⣤⣤⣤⣤⡀⠄⠄⠄⠄⠄⠄⠄⢸⣿⣿⣿⣿⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⠉⠳⣤⠄⢹⠋⠄⠄⠄⠄⢿⣿⣿⡟⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⣿⠄⠄⠄⠄⠄⠄⠄⠈⢿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⢸⠃⠄⢀⠄⠄⠄⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠟⡄⠄⣀⠄⠄⠰⠄⠐⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⢠⠁⠘⠉⡆⢃⡠⠆⠠⢤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠄⣾⡀⡆⢠⠁⢸⠁⠄⠇⠄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⢀⠄⣿⣧⣧⢸⡆⢸⠄⢰⡀⠄⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠸⠄⣿⣿⣿⣿⣷⣼⣧⣸⡇⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠈⡏⣿⣿⣿⣿⣿⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠄⠄⠧⠃⢻⢩⡟⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠄⠂⠐⢉⢸⠄⣿⠄⣿⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠄⢈⠄⡠⢻⠄⡇⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠈⠄⠄⠘⠆⢁⠄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠄⠄⠄⠈⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠄⠄⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	
	------------------ Gameplay modification: Mutation Knight ------------------
	
	----------------------
	--- Licensing Info ---
	----------------------
	
	Copyright (C) 2023 by 1xAero
	
	This program is free software: you can redistribute it and/or modify
	it, share, upload wherever you want without author's permisson.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	
	-------------------
	--- Description ---
	-------------------
	
	Mutation Knight is a Counter-Strike server side gameplay 
	modification, developed as an AMX Mod X plugin.
	
	At the beginning of the round, a random players will be selected and 
	will become Mutants. The goal of the Mutant is to turn other players
	into Mutants. The Mutant levels up after picking up a supply crate 
	or after turning another player into a Mutant or damaging the Knight. 
	After reaching level 4, the Mutant turns into an Armored Terminator. 
	The goal of the Soldiers is to survive. A team of Soldiers 
	automatically increases their level and damage every 30 seconds. 
	At 4th level, all Soldiers transforming into the Knights, which has the 
	abilities to block damage with its sword and random 1 hit kill. 
	The goal of the Knights is to kill all Mutants and Terminators or
	just to survive till round end.
	
	Abilities:
	
	- Mutant: SpeedUp at Level 2+, HP increases every Level
	
	- Terminator: Invincibility for 10 seconds, every soldier staying close 
	to Terminator while he uses skill, drops their weapon.
	
	- Soldiers: Second Level gives additional ammo, Third Level gives
	Heartbeat sensor (allows to detect Mutants/Terminators on radar) and
	additional ammo multiplied x2. After reaching level Four, all soldiers
	will become Knights (Ghostblades).
	
	- Ghostblade: Can randomly 1 hit kill depended on enemy health and
	ability to block front damage with defence stance.
	
	Supply Crate:
	
	- Mutants: Increases Mutant Level by one
	
	- Soldiers: Randomly gives Backpack Ammo, Nano Armor or Stun Grenade.
		
	--------------------
	--- Requirements ---
	--------------------
	
	* Mods: Counter-Strike 1.6 build 8684 + /HLDS 8684 +
	* Metamod 1.21p38: 
	  - https://metamod-p.sourceforge.net/
	* AMXX Version 1.10: 
	  - https://www.amxmodx.org/downloads-new.php?branch=master
	* Orpheu module 2.6.3: 
	  - https://forums.alliedmods.net/showthread.php?t=116393
	* Animation module: 
	  - https://forums.alliedmods.net/showpost.php?p=2286051&postcount=7
	* Noroundend module: 
	  - https://forums.alliedmods.net/showthread.php?t=95705
	* Round terminator: 
	  - https://forums.alliedmods.net/showthread.php?p=1122356
	
	--------------------
	--- Installation ---
	--------------------
	
	Extract the contents from the .zip file to your server's mod directory
	("cstrike").
	
	-----------------
	--- Changelog ---
	-----------------
	
	* v1.0: (May 9 2023)
	   - First public release
	   
	* v1.1: (May 10 2023)
	   - Fix buy cmd

	* v1.2 Quality of Life: (May 21 2023)
	   - No grenade damage against Soldier team
	   - Fix CSBot teamattacking all the time
	   - Grenade damage increased, applied random damage
	   
	* v1.3 Quality of Life: (May 31 2023)
	   - Fixed blood spreading from teammates	
	
	===========================================================================*/

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <round_terminator>

#define PLUGIN "Mutation Knight"
#define VERSION "1.3"
#define AUTHOR "1xAero"

#include "ghostblade/nano_0x0000_settings.sma"	
#include "ghostblade/nano_0x0001_precache.sma"
#include "ghostblade/nano_0x0002_ghostblade.sma"
#include "ghostblade/nano_0x0003_terminator.sma"
#include "ghostblade/nano_0x0004_soldier.sma"
#include "ghostblade/nano_0x0005_mutant.sma"
#include "ghostblade/nano_0x0006_animation.sma"
#include "ghostblade/nano_0x0007_hamsandwich.sma"
#include "ghostblade/nano_0x0008_forward.sma"
#include "ghostblade/nano_0x0009_event.sma"
#include "ghostblade/nano_0x0010_message.sma"
#include "ghostblade/nano_0x0011_ability.sma"
#include "ghostblade/nano_0x0012_functions.sma"
#include "ghostblade/nano_0x0013_taskdata.sma"
#include "ghostblade/nano_0x0014_natives.sma"

#if defined DEBUG_INFO

	#include "ghostblade/nano_0x0015_debug_cmd.sma"
	
#endif	

public plugin_init()
{	
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	//Class skills and first person animations
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "HamF_Weapon_PrimaryAttack_Post", TRUE);	
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "HamF_Weapon_PrimaryAttack", FALSE);	
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "HamF_Weapon_SecondaryAttack_Post", TRUE);
	RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "HamF_Weapon_SecondaryAttack", FALSE);
	RegisterHam(Ham_Item_Deploy, "weapon_knife", "HamF_ViewmodelDeploy_Post", TRUE);	
	RegisterHam(Ham_Weapon_WeaponIdle, "weapon_knife", "HamF_Weapon_WeaponIdle", FALSE);
			
	//Setup team, respawn and register csbot
	RegisterHam(Ham_Spawn, "player", "HamF_PlayerSpawn_Post", TRUE, true);
	RegisterHam(Ham_Spawn, "player", "HamF_PlayerSpawn", FALSE, true);
	
	//Multiply damage, count mutated players and register csbot
	RegisterHam(Ham_TakeDamage, "player", "HamF_TakeDamage_Post", TRUE, true);
	RegisterHam(Ham_TakeDamage, "player", "HamF_TakeDamage", FALSE, true);	
	RegisterHam(Ham_Killed, "player", "HamF_Killed_Post", TRUE, true);
	
	//Change blood color and register csbot
	RegisterHam(Ham_BloodColor, "player", "HamF_BloodColor", FALSE, true);
	
	//Block teamattack blood spreading
	RegisterHam(Ham_TraceAttack, "player", "HamF_TraceAttack", FALSE, true);
	
	//Prevent mutants/terminators/ghostblades/special characters from picking items
	for(new iWeaponBox = NULL; iWeaponBox < sizeof Armoury_Data; iWeaponBox ++)
		RegisterHam(Ham_Touch, Armoury_Data[iWeaponBox], "HamF_TouchWeaponBox", FALSE);	

	//SupplyBox pickup
	RegisterHam(Ham_Touch, "info_target", "HamF_TouchSupplyBox", FALSE);
	
	//Client updatedata (Ghostblade sword)
	register_forward(FM_UpdateClientData, "Forward_UpdateClientData_Post", TRUE);
	
	//Player models keys
	register_forward(FM_SetClientKeyValue, "Forward_SetClientKeyValue", FALSE);

	//Prevent them to set from console
	register_forward(FM_ClientUserInfoChanged, "Forward_ClientUserInfoChanged", FALSE);	
	
	//Sound block/emit
	register_forward(FM_EmitSound, "Forward_EmitSound", FALSE);	
	
	//Hook client commands
	register_forward(FM_ClientCommand, "Forward_ClientCommand", FALSE);
	
	//If trying to abuse kill
	register_forward(FM_ClientKill, "Forward_ClientKill", FALSE);
	
	//Game description
	register_forward(FM_GetGameDescription, "Forward_GameDescription", FALSE);

	//Game rules
	register_event("HLTV", "Event_HLTV", "a", "1=0", "2=0");
	register_event("ResetHUD", "Event_ResetHUD", "be");
	register_logevent("LogEvent_RoundStart", 2, "1=Round_Start");
	register_logevent("LogEvent_RoundEnd", 2, "1=Round_End");
	
	//Prevent mutants/terminators/ghostblades from buying
	g_msgStatusIcon = get_user_msgid("StatusIcon");
	register_message(g_msgStatusIcon, "Message_StatusIcon");	
	
	//Get ingame messages
	g_msgTextMsg = get_user_msgid("TextMsg");
	register_message(g_msgTextMsg, "Message_TextMsg");
	
	//Block win sounds
	g_msgSendAudio = get_user_msgid("SendAudio");
	register_message(g_msgSendAudio, "Message_SendAudio");
	
	//Additional team score for mutation/killing
	g_msgTeamScore = get_user_msgid("TeamScore");
	register_message(g_msgTeamScore, "Message_TeamScore");
	
	//VGUI team menu
	g_msgVGUIMenu = get_user_msgid("VGUIMenu");
	register_message(g_msgVGUIMenu, "Message_VGUIMenu");

	//Old style team menu
	g_msgShowMenu = get_user_msgid("ShowMenu");
	register_message(g_msgShowMenu, "Message_ShowMenu");
	
	//MOTD block and player variables update
	g_msgMOTD = get_user_msgid("MOTD");
	register_message(g_msgMOTD, "Message_MOTD");
	
	//No money draw for restricted class
	g_msgMoney = get_user_msgid("HideWeapon");
	register_message(g_msgMoney, "Message_Money");	
	
	//TE_BLOODSTREAM
	register_message(SVC_TEMPENTITY, "Message_BloodStream");

	//Draw mutants and terminators on radar
	g_msgHostagePos = get_user_msgid("HostagePos");
	g_msgHostageK = get_user_msgid("HostageK");

	//Armor Type
	g_msgArmorType = get_user_msgid("ArmorType");
	
	//Screenshake
	g_msgScreenShake = get_user_msgid("ScreenShake");
	
	//ScreenFade
	g_msgScreenFade = get_user_msgid("ScreenFade");
	
	//Crosshair
	g_msgCrosshair = get_user_msgid("Crosshair");

	//Set a bonus for mutation/killing
	g_msgDeathMsg = get_user_msgid("DeathMsg");
	g_msgScoreAttrib = get_user_msgid("ScoreAttrib");
	g_msgTeamInfo = get_user_msgid("TeamInfo");
	
	//Menuselect 3/5/6/8 we don't need sgren, flash, shield and nvg
	for(new iCommand = NULL; iCommand < sizeof Restricted_Command; iCommand ++)
		register_clcmd(Restricted_Command[iCommand], "MenuSelect");
	
	//For debug
	#if defined DEBUG_INFO
	
		register_clcmd("say soldier", "Debug_Soldier");
		register_clcmd("say ghostblade", "Debug_Ghostblade");
		register_clcmd("say mutant", "Debug_Mutant");
		register_clcmd("say terminator", "Debug_Terminator");
		
	#endif	

	//Supplybox spawns
	Cache_Supplybox_Spawns();
	
	//Setup cvar values for models with lambert flag
	Setup_World_Brightness();
	
	#if defined WORLD_LIGHTNING
	
		//Set map light
		engfunc(EngFunc_LightStyle, NULL, "f");
		
	#endif	
}