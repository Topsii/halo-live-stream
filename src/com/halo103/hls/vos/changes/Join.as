package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.Message;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.ScoreState;
	import com.halo103.hls.services.intervals.GameInterval;
	
	public class Join implements GameStateChange {
		
		private var _time:int;
		private var _slotId:int;
		private var _name:String;
		private var _color:int;
		
		public function Join(time:int, slotId:int, name:String, color:int) {
			_time = time;
			_slotId = slotId;
			_name = name;
			_color = color;
		}
		
		public function apply(gameState:GameState):void {
			gameState.fillSlot(_slotId, _name, _color);
			var text:String = "Welcome " + gameState.getPlayerBySlotId(_slotId).name;
			gameState.addMessage(new Message(_time, text, Message.TO_ALL));
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
