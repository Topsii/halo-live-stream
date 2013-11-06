package com.halo103.hls.vos.states {
	import com.halo103.hls.vos.Message
	import com.halo103.hls.vos.changes.GameStateChange;
	import com.halo103.hls.vos.states.PlayerState;
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameState {
		
		public static const PLAYER_SLOTS:int = 16;
		public static const MESSAGE_DISPLAY_TIME :int = 7000;
		
		private var _time:Number;
		private var _players:Vector.<PlayerState>;
		private var _messages:Vector.<Message>;
		
		public function GameState(time:Number, players:Vector.<PlayerState>, notices:Vector.<Message>) {
			_time = time;
			_players = players;
			_messages = notices;
		}
		
		public function clone():GameState {
			var newPlayers:Vector.<PlayerState> = _players.map(clonePlayers);
			var newMessages:Vector.<Message> = _messages.map(cloneMessages);
			
			return new GameState(_time, newPlayers, newMessages);
		}
		
		public static function clonePlayers(playerState:PlayerState, i:int, players:Vector.<PlayerState>):PlayerState {
			if (playerState != null)
				return playerState.clone();
			return null;
		}
		
		public static function cloneMessages(message:Message, i:int, notices:Vector.<Message>):Message {
			if (message != null)
				return message.clone();
			return null;
		}
		
		/**
		 * Returns a vector of PlayerStates in the same order as displayed on the scoreboard.
		 * Since the vector is sorted, the indices do not represent the player id!
		 */
		public function get scoreboard():Vector.<PlayerState> {
			var scoreData:Vector.<PlayerState> = _players.filter(dropVoidPlayers);
			scoreData.sort(compareForScoreBoard);
			return scoreData;
		}
		
		public static function dropVoidPlayers(player:PlayerState, index:int, players:Vector.<PlayerState>):Boolean {
			if (player) {
				return true;
			}
			return false;
		}
		
		public static function compareForScoreBoard(player1:PlayerState, player2:PlayerState):Number {
			var cmpVal:Number;
			(cmpVal = compareByTeam(player1, player2)) != 0 || 
			(cmpVal = compareByScore(player1, player2)) != 0 || 
			(cmpVal = compareByKills(player1, player2)) != 0 || 
			(cmpVal = compareByDeaths(player1, player2)) != 0 || 
			(cmpVal = compareByAssists(player1, player2)) != 0 
			return cmpVal;
		}
		
		public static function compareByTeam(player1:PlayerState, player2:PlayerState):Number {
			var teamGame:Boolean = player1.color == PlayerState.BLUE_TEAM || player1.color == PlayerState.RED_TEAM;
			if (teamGame && player1.color > player2.color) {
				return 1;
			} else if (teamGame && player1.color < player2.color) {
				return -1;
			} else {
				return 0;
			}
		}
		
		public static function compareByScore(player1:PlayerState, player2:PlayerState):Number {
			var score1:ScoreState = player1.score;
			var score2:ScoreState = player2.score;
			if (score1.score > score2.score) {
				return -1;
			} else if (score1.score < score2.score) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function compareByKills(player1:PlayerState, player2:PlayerState):Number {
			var score1:ScoreState = player1.score;
			var score2:ScoreState = player2.score;
			if (score1.kills > score2.kills) {
				return -1;
			} else if (score1.kills < score2.kills) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function compareByAssists(player1:PlayerState, player2:PlayerState):Number {
			var score1:ScoreState = player1.score;
			var score2:ScoreState = player2.score;
			if (score1.assists > score2.assists) {
				return -1;
			} else if (score1.assists < score2.assists) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public static function compareByDeaths(player1:PlayerState, player2:PlayerState):Number {
			var score1:ScoreState = player1.score;
			var score2:ScoreState = player2.score;
			if (score1.deaths > score2.deaths) {
				return 1;
			} else if (score1.deaths < score2.deaths) {
				return -1;
			} else {
				return 0;
			}
		}
		
		/**
		 * Creates a new PlayerState object for the specified slot with the specified name and team
		 * and with zero kills, deaths, assists and so on.
		 * 
		 * @param	slotId
		 * @param	name
		 * @param	team
		 */
		public function fillSlot(slotId:int, name:String, team:int):void {
			if (_players[validateSlotId(slotId)])
				throw new Error("The slot is already occupied.");
				
			_players[slotId] = new PlayerState(name, team, new ScoreState(0, 0, 0, 0));
		}
		
		/**
		 * After calling this function the PlayerState returned for the specified slotId will be null.
		 * 
		 * @param	slotId
		 */
		public function emptySlot(slotId:int):void {
			if (!_players[validateSlotId(slotId)])
				throw new Error("The slot is already empty.");
				
			_players[slotId] = null;
		}
		
		public function getPlayerBySlotId(slotId:int):PlayerState {
			return _players[validateSlotId(slotId)];
		}
		
		public function addMessage(message:Message):void {
			_messages.push(message);
		}
		
		public function get messages():Vector.<Message> {
			return _messages.slice();
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(time:Number):void {
			if (time < _time) {
				throw ArgumentError("Setting an earlier time is invalid.");
			}
			_messages = _messages.filter(function(msg:Message, i:int, messages:Vector.<Message>):Boolean {
					return msg.time + MESSAGE_DISPLAY_TIME >= time;
				});
			_time = time;
		}
		
		/**
		 * Throws an ArgumentError if the slotId is invalid and otherwise returns the slotId.
		 * 
		 * @param	slotId
		 * @return	valid slotId
		 */
		public static function validateSlotId(slotId:int):int {
			if (slotId < 0 || slotId >= PLAYER_SLOTS)
				throw new RangeError("slotId can only be a value from 0 to " + (PLAYER_SLOTS - 1));
			
			return slotId;
		}
		
	}

}