package com.halo103.hls.services.intervals {
	import com.halo103.hls.vos.GameChange;
	import com.halo103.hls.vos.changes.PlayerStateChange;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.changes.GameStateChange;
	
	/**
	 * As an interval class the GameInterval class has the task to calculate 
	 * and return the state of the GameState for any given time within the 
	 * interval.
	 * @author Topsi
	 */
	public class GameInterval {
		
		private var _calcBaseGameState:GameState;
		private var _changes:Vector.<GameStateChange>;
		private var _playerChanges:Vector.<Vector.<PlayerStateChange>>;
		
		public function GameInterval(calcBaseGameState:GameState) {
			_calcBaseGameState = calcBaseGameState;
			_changes = new Vector.<GameStateChange>();
			_playerChanges = new Vector.<Vector.<PlayerStateChange>>(16, true);
			for (var i:int = 0; i < 16; i++) {
				_playerChanges[i] = new Vector.<PlayerStateChange>();
			}
		}
		
		/**
		 * Calculates and returns the current game state.
		 * 
		 * Calculates and returns the GameState of a given currentTime.
		 * Each GameInterval has access to the values of a GameState applicable for time = 0
		 * which is the base for all operations to calculate the currentState. But it
		 * is also possible to pass a previously known GameState-time-pair to be used
		 * as base for the operations instead.
		 * 
		 * @param	currentTime
		 * @param	previousGameState
		 * @param	previousTime
		 * @return	currentGameState
		 */
		public function getGameState(curTime:int, prevGameState:GameState = null, prevTime:int = 0):GameState {
			
			//todo: make the prevGameState and prevTime a cache property of this class -> ensures that it is a gamestate that can be calculated from the information stored in this instance + easier usage of this class
			
			//Declare the game state that will be returned.
			var curGameState:GameState;
			
			//Set it to a known state with its corresponding known time.
			if (prevGameState && prevTime != 0) {
				curGameState = prevGameState.clone();
			} else {
				//If there was nothing passed, then go with previousTime=0,
				//since the PlayerState of that time is known.
				curGameState = _calcBaseGameState.clone();
			}
			
			//apply all changes
			for each (var change:GameStateChange in _changes) {
				if (change.time <= curTime) {
					change.apply(curGameState);
				} else {
					break;
				}
			}
			
			var time:int = prevTime;
			
			//since join/leave events were applied to determine the relevant player ids.. :
			for (var slotId:int = 0; slotId < GameState.PLAYER_SLOTS; slotId++) {
				
				var curPlayerState:PlayerState = curGameState.getPlayerBySlotId(slotId);
				if (curPlayerState != null) {
					time = prevTime;
					var playerChanges:Vector.<PlayerStateChange> = _playerChanges[slotId];
					for each (var playerChange:PlayerStateChange in playerChanges) {
						playerChange.apply(curPlayerState, curTime, time);
						if (playerChange.time <= curTime) {
							time = playerChange.time;
						} else {
							break;
						}
					}
					if (curPlayerState.token) curPlayerState.token.removeUnnecessaryMoveInfo();
				}
			}
			
			curGameState.time = curTime;
			
			return curGameState;
		}
		
		public function addChange(change:GameStateChange):void {
			var length:int = _changes.length;
			var time:int = change.time;
			if (length > 0) {
				if (_changes[length - 1].time < time) {
					_changes.push(change);
					return;
				}
				for (var k:int = 0; k < length; k++) {
					if (_changes[k].time < time) {
						_changes.splice(k + 1, 0, change);
						break;
					}
				}
			} else if (time > 0 && length == 0) {
				_changes[0] = change;
			}
			
		}
		
		public function addPlayerChange(playerChange:PlayerStateChange, playerId:int):void {
			
			var changes:Vector.<PlayerStateChange> = _playerChanges[playerId];
			var length:int = changes.length;
			var time:int = playerChange.time;

			if (length > 0) {
				if (changes[length - 1].time < time) {
					changes.push(playerChange);
					return;
				}
				for (var l:int = 0; l < length; l++) {
					if (changes[l].time < time) {
						changes.splice(l + 1, 0, playerChange);
						break;
					}
				}
			} else if (time > 0 && length == 0) {
				changes[0] = playerChange;
			}
		}
		
		public function set calcBaseGameState(calcBaseGameState:GameState):void {
			_calcBaseGameState = calcBaseGameState;
		}
		
		public function get calcBaseGameState():GameState {
			return _calcBaseGameState;
		}
		
		private function compareChanges(info1:GameChange, info2:GameChange):Number {
			if (info1.time < info2.time) {
				return -1;
			} else if (info1.time > info2.time) { 
				return 1;
			} 
			else { 
				return 0; 
			} 
		}
		
	}

}