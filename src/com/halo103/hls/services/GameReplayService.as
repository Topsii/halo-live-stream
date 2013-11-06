package com.halo103.hls.services {
	import com.halo103.hls.vos.GameChange;
	import com.halo103.hls.vos.changes.GameStateChange;
	import com.halo103.hls.vos.changes.PlayerStateChange;
	import com.halo103.hls.vos.Message;
	import com.halo103.hls.vos.states.PlayerState;
	import com.halo103.hls.controller.signals.GamePaused;
	import com.halo103.hls.controller.signals.GameStarted;
	import com.halo103.hls.controller.signals.GameStateChanged;
	import com.halo103.hls.controller.signals.ReplayDurationChanged;
	import com.halo103.hls.services.intervals.GameInterval;
	import com.halo103.hls.vos.states.GameState;
	import com.halo103.hls.scene.components.GameMap3D;
	import flash.display.Shape;
	import org.robotlegs.mvcs.Actor;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameReplayService extends Actor {
		
		private static const INTERVALL_DUR:uint = 1000; //in milliseconds
		
		private static var _shape:Shape = new Shape();
		
		[Inject] public var gameStateChanged:GameStateChanged;
		
		[Inject] public var replayDurationChanged:ReplayDurationChanged;
		
		[Inject] public var gamePaused:GamePaused;
		[Inject] public var gameStarted:GameStarted;
		
		private var _playing:Boolean;
		
		//the duration of the game to be be replayed
		private var _duration:int;
		
		private var _intervals:Vector.<GameInterval>;
		
		//onEnterFrame zieht diese Zeit von der tatsächlichen Zeit ab, um den darzustellenden Spielzeitpunkt zu berechnen
		private var _timeOffset:int;
		
		//gibt an wann die spielwiedergabe zuletzt pausiert wurde
		private var _pausedSince:int;
		
		
		public function GameReplayService() {
			_intervals = new Vector.<GameInterval>();
			_intervals.push(new GameInterval(new GameState(0, new Vector.<PlayerState>(16, true), new Vector.<Message>())));
			_playing = false;
			if (!(_shape.hasEventListener(Event.ENTER_FRAME))) {
				_shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function setProgress(progress:Number):void {
			var curTime:int = progress * _duration;
			if (curTime >= 0 && curTime <= _duration) {
				pause();
				var getTime:int = getTimer();
				_timeOffset = getTime - curTime;
				_pausedSince = getTime;
				updateGameState();
			}
		}
		
		public function play():void {
			if (!_playing) {
				_playing = true;
				//addiere die zeit während das spiel pausiert war dem timeOffset hinzu
				_timeOffset += (getTimer() - _pausedSince)
			}
			gameStarted.dispatch();
			
		}
		
		public function pause():void {
			if (_playing) {
				_playing = false;
				_pausedSince = getTimer();
			}
			gamePaused.dispatch();
		}
		
		public function addGameInformation(gameInfo:GameChange):void {
			var time:Number = gameInfo.time;
			if (time > 0) {
				
				//Get the index position of the GameInterval in the _intervals vector.
				var ivIndex:int = getGameIntervalIndex(time);
				
				//If the _intervals vector already holds an interval associated with that index:
				if (_intervals.length > ivIndex) {
					
					gameInfo.addToInterval(_intervals[ivIndex]);
					
					//Set the new calculation-base GameState for all following GameIntervals
					/*while (_intervals.length > ++ivIndex) {
						trace("")
						_intervals[ivIndex].calcBaseGameState = _intervals[--ivIndex].getGameState(INTERVALL_DUR).clone();
						trace("")
					}*/
				} else {
					//Fill the vector with GameIntervals up to the ivIndex
					while (_intervals.length <= ivIndex) {
						var newIvBaseTime:Number = _intervals.length * INTERVALL_DUR;
						
						var lastInterval:GameInterval = _intervals[_intervals.length - 1];
						
						//how to handle this if the gameinfos are not being added in chronological order?
						if (ivIndex == _intervals.length) {
							gameInfo.addToInterval(lastInterval);
						}
						
						var newBaseGameState:GameState = lastInterval.getGameState(newIvBaseTime, lastInterval.calcBaseGameState, newIvBaseTime - INTERVALL_DUR)
						_intervals[_intervals.length] = new GameInterval(newBaseGameState);
					}
					gameInfo.addToInterval(_intervals[ivIndex]);
				}
				
				if (time >= _duration) {
					_duration = time;
					replayDurationChanged.dispatchValue(_duration);
				} else {
					throw new Error("So far it is only possible to add GameInformation in chronological order")
				}
			}
		}
		
		private function onEnterFrame(event:Event):void {
			updateGameState();
		}
		
		private function updateGameState():void {
			var getTime:Number = getTimer();
			var time:int;
			if (_playing) {
				time = getTime - _timeOffset;
			} else {
				//addiere zusätzlich die dauer seit das spiel pausiert ist dem timeOffset hinzu
				time = _pausedSince - _timeOffset;
			}
			if (time < _duration) {
				var ivIndex:int = getGameIntervalIndex(time);
				var ivBaseTime:int = ivIndex * INTERVALL_DUR;
				var iv:GameInterval = _intervals[ivIndex];
				gameStateChanged.dispatchValue(iv.getGameState(time, iv.calcBaseGameState, ivBaseTime));
			} else {
				pause();
			}
		}
		
		/**
		 * Returns the key matched to the GameInterval that is able to return 
		 * the correct GameState for the specified time.
		 * 
		 * @param	time
		 * @return	gameIntervalKey
		 */
		private function getGameIntervalIndex(time:int):int {
			return Math.floor(time / INTERVALL_DUR);
		}
		
		public function get playing():Boolean {
			return _playing
		}
		
		public function get duration():int {
			return _duration;
		}
		
	}

}