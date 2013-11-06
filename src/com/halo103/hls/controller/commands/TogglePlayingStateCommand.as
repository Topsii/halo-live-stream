package com.halo103.hls.controller.commands {
	
	import com.halo103.hls.services.GameReplayService;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * If triggered this command plays or pauses the replay.
	 * @author Topsi
	 */
	public class TogglePlayingStateCommand extends Command {
		
		/** The GameReplayService "singleton". **/
		[Inject] public var replay:GameReplayService;
		
		/**
		 * Checks if the replay is playing and changes that state accordingly.
		 */
		override public function execute():void {
			if (replay.playing) {
				replay.pause();
			} else {
				replay.play();
			}
		}
		
	}

}