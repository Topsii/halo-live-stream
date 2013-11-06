package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.services.intervals.GameInterval;
	
	public class TeamChange implements GameStateChange {
		
		private var _time:int;
		private var _slotId:int;
		private var _color:int;
		
		public function TeamChange(time:int, slotId:int, color:int) {
			this._time = time;
			this._slotId = slotId;
			this._color = color;
		}
		
		public function apply(gameState:GameState):void {
			gameState.getPlayerBySlotId(_slotId).color = _color;
			gameState.getPlayerBySlotId(_slotId).score.score = 0;
		}
		
		public function addToInterval(gameInterval:GameInterval):void {
			gameInterval.addChange(this);
		}
		
		public function get time():int {
			return this._time;
		}
		
		public function set time(time:int):void {
			_time = time;
		}
	}
}
