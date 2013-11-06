package com.halo103.hls.vos.changes {
	import com.halo103.hls.services.intervals.GameInterval;
	import com.halo103.hls.vos.Message;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.vos.states.PlayerState;
	import flash.errors.IllegalOperationError;
	/**
	 * ...
	 * @author Topsi
	 */
	public class ChatMessage implements GameStateChange {
		
		public static const ALL_CHAT:int = 0;
		public static const TEAM_CHAT:int = 1;
		public static const VEHICLE_CHAT:int = 2;
		
		private var _time:int;
		private var _text:String;
		private var _senderSlotId:int;
		private var _chattype:int;
		
		public function ChatMessage(time:int, text:String, senderSlotId:int, chattype:int) {
			_time = time;
			_text = text;
			if (senderSlotId < 0 || senderSlotId > 2) throw ArgumentError("Invalid chattype.")
			_senderSlotId = senderSlotId;
			_chattype = chattype;
		}
		
		public function apply(gameState:GameState):void {
			var text:String;
			var sender:PlayerState = gameState.getPlayerBySlotId(_senderSlotId);
			switch (_chattype) {
				case ALL_CHAT:
					text = sender.name + ": " + _text;
					gameState.addMessage(new Message(_time, text, Message.TO_ALL));
					break;
				case TEAM_CHAT:
					text = "[" + sender.name + "\]: " + _text;
					var p:PlayerState;
					for (var slotId:int = 0; slotId < GameState.PLAYER_SLOTS; slotId++) {
						if ((p = gameState.getPlayerBySlotId(slotId)) != null && p.color == sender.color) {
							gameState.addMessage(new Message(_time, text, slotId));
						}
					}
					break;
				case VEHICLE_CHAT:
					throw IllegalOperationError("Vehicle chat functionality is not supported yet.");
					break;
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