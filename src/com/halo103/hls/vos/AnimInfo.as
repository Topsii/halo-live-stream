package com.halo103.hls.vos {
	/**
	 * ...
	 * @author Topsi
	 */
	public class AnimInfo {
		
		public static var MOVE_BACK:int = 0;
		public static var MOVE_FRONT:int = 1;
		public static var MOVE_LEFT:int = 2;
		public static var MOVE_RIGHT:int = 3;
		public static var MOVE_IDLE:int = 4;
		
		public static var TURN_LEFT:int = 5;
		public static var TURN_RIGHT:int = 6;
		
		private var _time:Number;
		private var _animationType:int;
		
		public function AnimInfo(time:Number, animationType:int) {
			_time = time;
			_animationType = animationType;
		}
		
		public function clone():AnimInfo {
			return new AnimInfo(_time, _animationType);
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function get animationType():int {
			return _animationType;
		}
		
		public function set time(value:Number):void {
			_time = value;
		}
		
		public function set animationType(value:int):void {
			_animationType = value;
		}
		
		public function toString():String {
			
			var typeName:String;
			switch(_animationType) { 
				case 0:
					typeName = "move-back";
					break; 
				case 1:
					typeName = "move-front";
					break; 
				case 2:
					typeName = "move-left";
					break; 
				case 3:
					typeName = "move-right"; 
					break; 
				case 4:
					typeName = "idle"; 
					break; 
				case 5:
					typeName = "turn-left";
					break; 
				case 6:
					typeName = "turn-right";
					break; 
				default:
					typeName = "unknown"; 
					break; 
			}
			
			return "AnimInfo: type: " + typeName + ", time: " + time;
			
		}
		
	}

}