package com.halo103.hls.vos {
	
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class Message {
		
		public static const TO_ALL:int = -6
		public static const TO_SPECTATOR:int = -1
		
		private var _time:int;
		private var _text:String
		private var _recipient:int;
		
		public function Message(time:int, text:String, recipient:int) {
			_time = time;
			_text = text;
			_recipient = recipient;
		}
		
		public function clone():Message {
			return new Message(_time, _text, _recipient);
		}
		
		public function get time():int {
			return _time;
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get recipient():int {
			return _recipient;
		}
		
	}

}