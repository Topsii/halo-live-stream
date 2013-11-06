package com.halo103.hls.interfaces {
	import com.halo103.hls.vos.Message;
	
	/**
	 * ...
	 * @author Topsi
	 */
	public interface MessagesPlayerDisplay extends PlayerDependent {
		
		function displayMessages(messages:Vector.<Message>):void;
		
	}
	
}