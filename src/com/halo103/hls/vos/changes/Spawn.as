package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.PlayerTokenState;
	import com.halo103.hls.services.intervals.GameInterval;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Spawn implements PlayerStateChange {
		
		private var _time:int;
		private var _position:Vector3D;
		private var _rotation:Number;
		private var _perspDirection:Vector3D;
		
		public function Spawn(time:int, position:Vector3D, rotation:Number, perspDirection:Vector3D) {
			_time = time;
			_position = position;
			_rotation = rotation;
			_perspDirection = perspDirection;
		}
		
		public function apply(player:PlayerState, curTime:int, prevTime:int):void {
			if (curTime >= _time) {
				player.token = new PlayerTokenState(_position, _rotation, _perspDirection, true);
			}
		}
		
		public function get time():int {
			return _time;
		}
		
		public function set time(time:int):void {
			_time = time;
		}
		
	}

}