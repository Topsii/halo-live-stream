package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.ScoreState;
	import com.halo103.hls.services.intervals.GameInterval;
	
	public class Reset implements GameStateChange {
		
		private var _time:int;
		
		public function Reset(time:int):void {
			this._time = time;
		}
		
		public function apply(gameState:GameState):void {
			
			var p:PlayerState;
			for (var slotId:int = 0; slotId < GameState.PLAYER_SLOTS; slotId++) {
				if ((p = gameState.getPlayerBySlotId(slotId)) != null) {
					var score:ScoreState = p.score;
					score.score = 0;
					score.kills = 0;
					score.assists = 0;
					score.deaths = 0;
				}
			}
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
