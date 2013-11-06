package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.AnimInfo;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.PlayerTokenState;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Move implements PlayerStateChange {
		
		private var _time:int;
		private var _position:Vector3D;
		private var _rotation:Number;
		private var _perspDirection:Vector3D;
		
		public function Move(time:int, position:Vector3D, rotation:Number, perspDirection:Vector3D) {
			_time = time;
			_position = position;
			_rotation = norm360(rotation);
			_perspDirection = perspDirection;
		}
		
		public function apply(player:PlayerState, curTime:int, prevTime:int):void {
			var token:PlayerTokenState = player.token;
			
			if (curTime >= _time) {
				if (token != null) {
					addMoveInfos(token, _position, _rotation, _time - prevTime);
					token.perspDirection = _perspDirection;
				} else {
					throw Error("cant be");
					player.token = new PlayerTokenState(_position, _rotation, _perspDirection, false, new Vector.<AnimInfo>());
				}
			} else {
				if (token != null) {
					/**
					 * The actual position is calculated from the information 
					 * of the two PositionMoments prevPM and pm by assuming 
					 * linear movement.
					 * 
					 * Example:
					 * 
					 * The value of the player's x-coordinate at 
					 * 300 milliseconds is known to be 200 units. 
					 * (prevPos.x = 200; prevTime = 300).
					 * 
					 * The value of the player's x-coordinate at 
					 * 333 milliseconds is known to be 480 units. 
					 * (_position.x = 480; _time = 333).
					 *
					 * The current time is 320 milliseconds, so the ratio will
					 * be: 0.6060606 = (320 - 300) / (333 - 300).
					 * (about 60% of the timespan between the two know states has passed)
					 * 
					 * Assumption is that the value of the player's 
					 * x-coordinate at 320 milliseconds is 
					 * 369 = 200 + 0.6060606 * (480 - 200).
					 */
					var prevPos:Vector3D = token.position;
					var prevPersp:Vector3D = token.perspDirection;
					
					var ratio:Number = 
						(curTime - prevTime) / (_time - prevTime);
					
					var prevPosX:Number = prevPos.x;
					var prevPosY:Number = prevPos.y;
					var prevPosZ:Number = prevPos.z;
					var prevRot:Number = token.rotation;
					var prevPerspX:Number = prevPersp.x;
					var prevPerspY:Number = prevPersp.y;
					var prevPerspZ:Number = prevPersp.z;
					
					var newPosition:Vector3D = new Vector3D(
						prevPosX + ratio * (_position.x - prevPosX),
						prevPosY + ratio * (_position.y - prevPosY),
						prevPosZ + ratio * (_position.z - prevPosZ)
					);
					
					var newRotation:Number;
					if (prevRot != _rotation) {
						//to get from 30 to 340 it is more direct to subtract 50 than adding 310
						//in those cases the absolute difference is greater than 180
						var diff:Number = _rotation - prevRot;
						if (Math.abs(diff) > 180) {
							//the diff between 30 and 340 would be 310. Since 310 is positive, 
							//we subtract 360 and find out that we need to subtract 50
							if (diff < 0) {
								diff += 360; 
							} else {
								diff -= 360;
							}
						}
						newRotation = prevRot + ratio * diff;
					} else {
						newRotation = _rotation;
					}
					
					var newPersp:Vector3D = new Vector3D(
						prevPerspX + ratio * (_perspDirection.x - prevPerspX),
						prevPerspY + ratio * (_perspDirection.y - prevPerspY),
						prevPerspZ + ratio * (_perspDirection.z - prevPerspZ)
					);
					
					addMoveInfos(token, newPosition, norm360(newRotation), curTime - prevTime);
					token.perspDirection = newPersp;
				}
			}
		}
		
		private function addMoveInfos(token:PlayerTokenState, newPos:Vector3D, newRot:Number, diffTime:int):void {
			
			var prevRot:Number = token.rotation;
			
			var dPosX:Number = newPos.x - token.position.x;
			var dPosZ:Number = newPos.z - token.position.z;
			
			//if the player is moving,
			if (dPosZ != 0 || dPosX != 0) {
				
				//calculate into what absolute direction the player is moving
				var angle:Number = norm360(Math.atan2(dPosZ, dPosX) * (180 / Math.PI));
				
				//add the rotation of the player to the angle to get the relative direction for that player
				//angle += newRotation;
				
				
				/*if (prevRot != newRot) {
					//to get from 30 to 340 it is more direct to subtract 50 than adding 310
					//in those cases the absolute difference is greater than 180
					var diff:Number = newRot - prevRot;
					if (Math.abs(diff) > 180) {
						//the diff between 30 and 340 would be 310. Since 310 is positive, 
						//we subtract 360 and find out that we need to subtract 50
						if (diff < 0) {
							diff += 360; 
						} else {
							diff -= 360;
						}
					}*/
					
					/**
					 * In most cases there is only one single move animation taking place in such a short time frame.
					 * But it can happen that although the player keeps walking in the same absolute angle, that he
					 * is actually doing 1 or even 2 different additional move animations in a row, since his rotation can extremely
					 * change while he is walking. And therefore his relative angle (since relative means relative to the players rotation)
					 * would be changing in this timeframe too.
					 */
					/*var startAnim:int = moveAnimType(angle + newRot);
					var endAnim:int = moveAnimType(angle + prevRot);
					
					var additionalMoveAnims:int = Math.abs(Math.floor((angle + newRot + 45) / 90) - Math.floor((angle + prevRot + 45) / 90));
					var additionalMoveAnims:int = Math.abs(startAnim - endAnim);
					
					var i:int = 0;
					while (i < additionalMoveAnims) {
						if (diff < 0) {
							angle -= 90;
						} else {
							angle += 90;
						}
						addMoveInfo(token, angle, diffTime * (90 / diff));
						i++;
					}
					angle += diff % 90;
					addMoveInfo(token, angle, diffTime * ((diff % 90) / diff));
					//trace(additionalMoveAnims + ", " + int((angle + prevRot + 45)) + ", " + int((angle + newRot + 45)) + ", " + diff + ", " + angle);
					
				} else {*/
					//just add Move info once
					addMoveInfo(token, angle + newRot, diffTime)
				//}
				
				token.rotation = newRot;
			} else {
				/*trace(prevRot + ", " + newRot + ", " + dx + ", " + dy);
				if (prevRot == newRot) {
					var prevMoveInfoLength:int = token.prevMoveInfoLength;
					if (prevMoveInfoLength > 0) {
						var latestPrevMoveInfo:AnimInfo = token.getPrevMoveInfo(prevMoveInfoLength - 1);
						if (latestPrevMoveInfo.animationType == AnimInfo.TURN_LEFT) {
							if (latestPrevMoveInfo.time <= 198) {
								token.addMoveInfo(new AnimInfo(diffTime, AnimInfo.TURN_LEFT));
							} else {
								token.rotation = prevRot + ((newRot - prevRot) * ((latestPrevMoveInfo.time - 198) / diffTime));
								trace(prevRot + ", " + newRot + ", " + latestPrevMoveInfo.time + ", " + token.rotation);
								throw new Error("such a big turn is weird :/");
							}
						} else if (latestPrevMoveInfo.animationType == AnimInfo.TURN_RIGHT) {
							if (latestPrevMoveInfo.time <= 198) {
							token.addMoveInfo(new AnimInfo(diffTime, AnimInfo.TURN_RIGHT));
							} else {
								token.rotation = prevRot + ((newRot - prevRot) * ((latestPrevMoveInfo.time - 198) / diffTime));
								trace(Number());
								trace(Number(prevRot + ((newRot - prevRot) * ((latestPrevMoveInfo.time - 198) / diffTime))));
								trace(prevRot + ", " + newRot + ", " + latestPrevMoveInfo.time + ", " + token.rotation);
								throw new Error("such a big turn is weird :/");
							}
						} else {
							token.rotation = newRot;
							token.addMoveInfo(new AnimInfo(diffTime, AnimInfo.MOVE_IDLE));
						}
					}
				} else if (prevRot < newRot) {
					token.addMoveInfo(new AnimInfo(diffTime, AnimInfo.TURN_RIGHT));
				} else if (prevRot < newRot) {
					token.addMoveInfo(new AnimInfo(diffTime, AnimInfo.TURN_LEFT));
				} else {
					
				}*/
				token.rotation = newRot;
				token.addMoveInfo(new AnimInfo(diffTime, AnimInfo.MOVE_IDLE));
				
				//trace("idle");
				//turn left or right?
			}
			token.position = newPos;
		}
		
		private function addMoveInfo(token:PlayerTokenState, angle:Number, time:Number):void {
			if (time > 0) {
				angle = norm360(angle);
				var animType:int;
				if (angle < 65) {
					animType = AnimInfo.MOVE_BACK;
				} else if (angle < 115) {
					animType = AnimInfo.MOVE_RIGHT;
				} else if (angle < 245) {
					animType = AnimInfo.MOVE_FRONT;
				} else if (angle < 295) {
					animType = AnimInfo.MOVE_LEFT;
				} else {
					animType = AnimInfo.MOVE_BACK;
				}
				var moveInfo:AnimInfo  = new AnimInfo(time, animType);
				token.addMoveInfo(moveInfo);
			}
		}
		
		private function norm360(value:Number):Number {
			value = value % 360;
			if (value < 0) value += 360;
			return value;
		}
		
		public function get time():int {
			return _time;
		}
		
		public function set time(time:int):void {
			_time = time;
		}
		
	}

}