package com.halo103.hls.vos {
	import com.halo103.hls.vos.changes.PlayerStateChange;
	import com.halo103.hls.services.intervals.GameInterval;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class AddablePlayerChange implements GameChange {
		
		private var _playerStateChange:PlayerStateChange;
		private var _playerId:int;
		
		public function AddablePlayerChange(playerStateChange:PlayerStateChange, playerId:int) {
			_playerStateChange = playerStateChange;
			_playerId = playerId;
		}
		
		public function addToInterval(gameInterval:GameInterval):void {
			gameInterval.addPlayerChange(_playerStateChange, _playerId);
		}
		
		public function get time():int {
			return _playerStateChange.time;
		}
		
		public function set time(time:int):void {
			_playerStateChange.time = time;
		}
		
	}

}