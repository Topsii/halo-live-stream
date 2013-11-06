package com.halo103.hls.vos.states {
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class ScoreState {
		
		private var _score:int;
		private var _kills:int;
		private var _assists:int;
		private var _deaths:int;
		
		public function ScoreState(score:int, kills:int, assists:int, deaths:int) {
			_score = score;
			_kills = kills;
			_assists = assists;
			_deaths = deaths;
		}
		
		public function clone():ScoreState {
			return new ScoreState(_score, _kills, _assists, _deaths);
		}
		
		public function get score():int {
			return _score;
		}
		
		public function set score(score:int):void {
			_score = score;
		}
		
		public function get kills():int {
			return _kills;
		}
		
		public function set kills(kills:int):void {
			_kills = kills;
		}
		
		public function get assists():int {
			return _assists;
		}
		
		public function set assists(assists:int):void {
			_assists = assists;
		}
		
		public function get deaths():int {
			return _deaths;
		}
		
		public function set deaths(deaths:int):void {
			_deaths = deaths;
		}
		
	}

}