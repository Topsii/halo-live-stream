package com.halo103.hls.vos {
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameType {
		
		public static const CTF:int = 1;
		public static const SLAYER:int = 2;
		public static const ODDBALL:int = 3;
		public static const KOTH:int = 4;
		public static const RACE:int = 5;
		
		private var _name:String;
		private var _gameMode:int;
		private var _teamPlay:Boolean;
		
		public function GameType(name:String, gameMode:int, teamPlay:Boolean) {
			if (!name)
				throw new ArgumentError("Name cannot be null.");
			_name = name;
			
			if ( gameMode < 1 || 5 < gameMode)
				throw new ArgumentError("gameMode has to be a valid value of one"
				+ " of the constants CTF, SLAYER, ODDBALL, KORTH or RACE.");
			_gameMode = gameMode;
			
			_teamPlay = teamPlay;
		}
		
		public function get teamPlay():Boolean {
			return _teamPlay;
		}
	}

}