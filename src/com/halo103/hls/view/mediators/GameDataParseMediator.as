package com.halo103.hls.view.mediators {
	import com.halo103.hls.controller.signals.GameDataParsed;
	import com.halo103.hls.controller.signals.GameDataParsingProgressed;
	import com.halo103.hls.interfaces.IGameDataParseProgressView;
	import org.robotlegs.mvcs.SignalMediator;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GameDataParseMediator extends SignalMediator {
		
		[Inject] public var progressView:IGameDataParseProgressView;
		
		[Inject] public var parsingGameDataCompleted:GameDataParsed;
		[Inject] public var parsingGameDataProgressed:GameDataParsingProgressed;
		
		private function handleGameDataParsingProgressed(centisecondsParsed:int, centisecondsTotal:int ):void {
			progressView.setParseGameDataProgress(centisecondsParsed / centisecondsTotal);
		}
		
		private function handleGameDataParsed():void {
			progressView.setParseGameDataProgress(1);
			signalMap.removeFromSignal(parsingGameDataProgressed, handleGameDataParsingProgressed);
		}
		
		override public function onRegister():void {
			addOnceToSignal(parsingGameDataCompleted, handleGameDataParsed);
			addToSignal(parsingGameDataProgressed, handleGameDataParsingProgressed);
		}
		
	}

}