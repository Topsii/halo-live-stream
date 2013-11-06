package com.halo103.hls.view.components {
	
	import com.halo103.hls.controller.MDRR3DContext;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Topsi
	 */
	[SWF(backgroundColor="0x000000", frameRate="60", width="1136", height="640")]
	public class ContextView extends Sprite {
		
		private var context:MDRR3DContext;
		
		public function ContextView() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			super();
			context = new MDRR3DContext(this);
		}
		
	}

}