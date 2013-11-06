package com.halo103.hls.controller.commands {
	
	import com.halo103.hls.services.GameReplayService;
	import org.robotlegs.mvcs.SignalCommand;
	
	/**
	 * If triggered this command tells the replay to make a jump in time.
	 * @author Topsi
	 */
	public class SetTimeProgressCommand extends SignalCommand {
		
		/** The GameReplayService "singleton". **/
		[Inject] public var replay:GameReplayService;
		
		/** The time passed by the signal that triggered this command. **/
		[Inject] public var timeProgress:Number;
		
		/**
		 * Tells the replay to make a jump in time.
		 */
		override public function execute():void {
			replay.setProgress(timeProgress);
		}
		
	}

}