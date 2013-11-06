package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.Message;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.services.intervals.GameInterval;
	
	public class Leave implements GameStateChange {
		
		private var _time:int;
		private var _slotId:int;
		
		public function Leave(time:int, slotId:int) {
			_time = time;
			_slotId = slotId;
		}
		
		public function apply(gameState:GameState):void {
			var text:String = gameState.getPlayerBySlotId(_slotId).name + " quit";
			gameState.addMessage(new Message(_time, text, Message.TO_ALL));
			
			gameState.emptySlot(_slotId);
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
