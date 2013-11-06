package com.halo103.hls.vos.changes {
	
	import com.halo103.hls.vos.Message;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.services.intervals.GameInterval;
	import com.halo103.hls.vos.states.PlayerState;
	
	public class Kill implements GameStateChange {
		
		public static const UNKNOWN_KILLER:int = -1;
		
		private var _time:int;
		private var _killerSlotId:int;
		private var _victimSlotId:int;
		private var _assistersSlotIds:Vector.<int>;
		
		public function Kill(time:int, killerSlotId:int, victimSlotId:int, assistPlayerIds:Vector.<int>) {
			_time = time;
			_killerSlotId = killerSlotId;
			_victimSlotId = victimSlotId;
			_assistersSlotIds = assistPlayerIds;
			trace("Killer id: " + _killerSlotId);
		}
		
		public function apply(gameState:GameState):void {
			
			var text:String;
			var p:PlayerState;
			var slotId:int;
			
			var victim:PlayerState = gameState.getPlayerBySlotId(_victimSlotId);
			
			victim.score.deaths += 1;
			
			if (_killerSlotId != UNKNOWN_KILLER) {
				
				var killer:PlayerState = gameState.getPlayerBySlotId(_killerSlotId);
				
				if (_assistersSlotIds) {
					for each (var assistPlayerId:int in _assistersSlotIds) {
						gameState.getPlayerBySlotId(assistPlayerId).score.assists += 1;
					}
				}
				
				var teamGame:Boolean = victim.color == PlayerState.BLUE_TEAM || victim.color == PlayerState.RED_TEAM;
				if (teamGame && victim.color == killer.color) {
				
					text = victim.name + " was betrayed by " + killer.name;
					gameState.addMessage(new Message(_time, text, Message.TO_SPECTATOR));
					for (slotId = 0; slotId < GameState.PLAYER_SLOTS; slotId++) {
						if ((p = gameState.getPlayerBySlotId(slotId)) != null && slotId != _killerSlotId) {
							gameState.addMessage(new Message(_time, text, slotId));
						}
					}
					text = "You betrayed " + victim.name;
					gameState.addMessage(new Message(_time, text, _killerSlotId));
					
				} else {
					
					killer.score.kills += 1;
					
					text = victim.name + " was killed by " + killer.name;
					gameState.addMessage(new Message(_time, text, Message.TO_SPECTATOR));
					for (slotId = 0; slotId < GameState.PLAYER_SLOTS; slotId++) {
						if ((p = gameState.getPlayerBySlotId(slotId)) != null && slotId != _killerSlotId) {
							gameState.addMessage(new Message(_time, text, slotId));
						}
					}
					text = "You killed " + victim.name;
					gameState.addMessage(new Message(_time, text, _killerSlotId));
				}
				
			} else {
				text = victim.name + " died";
				gameState.addMessage(new Message(_time, text, Message.TO_ALL));
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
