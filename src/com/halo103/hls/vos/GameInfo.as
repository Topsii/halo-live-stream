package com.halo103.hls.vos {
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameInfo {
		
		private var _mapName:String;
		private var _gameType:GameType
		
		public function GameInfo(mapName:String, gameType:GameType) {
			
			if (!mapName)
				throw new ArgumentError("Name cannot be null.");
			_mapName = mapName;
			
			if (!gameType)
				throw new ArgumentError("GameType cannot be null.");
			_gameType = gameType;
		}
		
		public function get mapName():String {
			return _mapName;
		}
		
		public function get gameType():GameType {
			return _gameType;
		}
	}
}