package com.halo103.hls.vos.states {
	import com.halo103.hls.vos.AnimInfo;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class PlayerTokenState {
		
		public static const MOVE_ANIM_FADE_DUR:int = 200;
		
		private var _position:Vector3D;
		private var _rotation:Number;
		private var _perspDirection:Vector3D;
		private var _alive:Boolean;
		private var _prevMoveInfo:Vector.<AnimInfo>;
		private var _prevTurnInfo:Vector.<AnimInfo>;
		
		public function PlayerTokenState(position:Vector3D, rotation:Number, perspDirection:Vector3D, alive:Boolean,
				prevMoveInfo:Vector.<AnimInfo> = null, prevTurnInfo:Vector.<AnimInfo> = null) {
			_position = position;
			_rotation = rotation;
			_perspDirection = perspDirection;
			_alive = alive;
			if (prevMoveInfo == null) {
				_prevMoveInfo = new Vector.<AnimInfo>();
			} else {
				_prevMoveInfo = prevMoveInfo;
			}
			if (prevTurnInfo == null) {
				_prevTurnInfo = new Vector.<AnimInfo>();
			} else {
				_prevTurnInfo = prevTurnInfo;
			}
		}
		
		public function clone():PlayerTokenState {
			var newPrevMoveInfo:Vector.<AnimInfo> = _prevMoveInfo.map(cloneAnimInfos);
			var newPrevTurnInfo:Vector.<AnimInfo> = _prevTurnInfo.map(cloneAnimInfos);
			var newPosition:Vector3D;
			if (_position != null) {
				newPosition = _position.clone();
			}
			var newPerspDirection:Vector3D;
			if (_perspDirection != null) {
				newPerspDirection = _perspDirection.clone();
			}
			return new PlayerTokenState(newPosition, _rotation, newPerspDirection, _alive, newPrevMoveInfo, newPrevTurnInfo);
		}
		
		public static function cloneAnimInfos(animInfo:AnimInfo, i:int, animInfos:Vector.<AnimInfo>):AnimInfo {
			if (animInfo != null)
				return animInfo.clone();
			return null;
		}
		
		public function addMoveInfo(moveInfo:AnimInfo):void {
			if (_prevMoveInfo.length > 0 && _prevMoveInfo[_prevMoveInfo.length - 1].animationType == moveInfo.animationType) {
				_prevMoveInfo[_prevMoveInfo.length - 1].time += moveInfo.time;
			} else {
				_prevMoveInfo.push(moveInfo);
			}
		}
		
		public function removeUnnecessaryMoveInfo():void {
			while (_prevMoveInfo.length > 1 && prevMoveInfoDur - _prevMoveInfo[0].time > MOVE_ANIM_FADE_DUR) {
				_prevMoveInfo.shift();
			}
		}
		
		public function getPrevMoveInfo(index:int):AnimInfo {
			return _prevMoveInfo[index];
		}
		
		public function get prevMoveInfoLength():int {
			return _prevMoveInfo.length;
		}
		
		public function get prevMoveInfoDur():int {
			var time:int;
			for each (var moveInfo:AnimInfo in _prevMoveInfo) {
				time += moveInfo.time;
			}
			return time;
		}
		
		public function get prevTurnInfo():Vector.<AnimInfo> {
			return _prevTurnInfo;
		}
		
		public function set prevTurnInfo(value:Vector.<AnimInfo>):void {
			_prevTurnInfo = value;
		}
		
		public function get position():Vector3D {
			return _position;
		}
		
		public function set position(value:Vector3D):void {
			_position = value;
		}
		
		public function get rotation():Number {
			return _rotation;
		}
		
		public function set rotation(value:Number):void {
			_rotation = value;
		}
		
		public function get perspDirection():Vector3D {
			return _perspDirection;
		}
		
		public function set perspDirection(value:Vector3D):void {
			_perspDirection = value;
		}
		
		public function get alive():Boolean {
			return _alive;
		}
		
		public function set alive(value:Boolean):void {
			_alive = value;
		}
		
	}

}