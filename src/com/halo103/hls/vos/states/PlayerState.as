package com.halo103.hls.vos.states {
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerState {
		
		public static var ANIM_TRANS_DUR:int = 100;
		
		public static const RED_TEAM:int = 0;
		public static const BLUE_TEAM:int = 1
		public static const WHITE:int = 2;
		public static const BLACK:int = 3;
		public static const RED:int = 4;
		public static const BLUE:int = 5;
		public static const GRAY:int = 6;
		public static const YELLOW:int = 7;
		public static const GREEN:int = 8;
		public static const PINK:int = 9;
		public static const PURPLE:int = 10;
		public static const CYAN:int = 11;
		public static const COBALT:int = 12;
		public static const ORANGE:int = 13;
		public static const TEAL:int = 14;
		public static const SAGE:int = 15;
		public static const BROWN:int = 16;
		public static const TAN:int = 17;
		public static const MAROON:int = 18;
		public static const SALMON:int = 19;
		
		private var _name:String;
		private var _color:int;
		private var _score:ScoreState;
		private var _token:PlayerTokenState;
		
		public function PlayerState(name:String, color:int, score:ScoreState, token:PlayerTokenState=null) {
			_name = name;
			_color = color;
			_score = score;
			_token = token;
		}
		
		public function clone():PlayerState {
			var newToken:PlayerTokenState;
			if (_token != null) {
				newToken = _token.clone();
			}
			return new PlayerState(_name, _color, _score.clone(), newToken);
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(name:String):void {
			if (name == null)
				throw new ArgumentError("name cannot be null.");
			_name = name;
		}
		
		public function get color():int {
			return _color;
		}
		
		public function set color(color:int):void {
			_color = color;
		}
		
		public function get score():ScoreState {
			return _score;
		}
		
		public function set score(score:ScoreState):void {
			if (score == null)
				throw new ArgumentError("score cannot be null.");
			_score = score;
		}
		
		public function get token():PlayerTokenState {
			return _token;
		}
		
		public function set token(value:PlayerTokenState):void {
			_token = value;
		}
		
	}

}