package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.states.PlayerState;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Death implements PlayerStateChange {
		
		private var _time:int;
		
		public function Death(time:int) {
			_time = time;
			trace("death " +(time/1000))
		}
		
		public function apply(player:PlayerState, curTime:int, prevTime:int):void {
			if (curTime >= _time) {
				//replace this with proper death animation later:
				player.token.alive = false;
			}
		}
		
		public function get time():int {
			return _time;
		}
		
		public function set time(value:int):void {
			_time = value;
		}
		
	}

}