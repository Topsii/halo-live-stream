package com.halo103.hls.controller.commands {
	
	import com.halo103.hls.services.GameReplayService;
	import org.robotlegs.mvcs.SignalCommand;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public class GoLiveCommand extends SignalCommand {
		
		[Inject] public var replay:GameReplayService;
		
		override public function execute():void {
			var duration:Number = replay.duration;
			if (duration > 5000) {
				replay.setProgress((duration - 5000) / duration)
			} else {
				replay.setProgress(0)
			}
			replay.play();
		}
		
	}

}