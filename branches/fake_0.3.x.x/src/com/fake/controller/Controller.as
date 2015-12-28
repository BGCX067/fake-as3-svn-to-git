package com.fake.controller
{
	import com.fake.I18n;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	/**
	 * Controller
	 * 
	 * Base class that every controller must extend. It provides the following functionalities:
	 * - integration with Localizator throw __() method
	 */
	public class Controller extends Canvas
	{
		//--------------------------------------------------------------------------
		//  Class Constants
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		
		private var _domain:String = 'default';
		
		//--------------------------------------------------------------------------
		// Constructor and Initializations
		//--------------------------------------------------------------------------
		
		public function Controller()
		{
			// Only call refresh and update when the form where the result will appear is visible and completely created
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			addEventListener(FlexEvent.INITIALIZE,onInitialize);
		}
		
		protected function onCreationComplete(event:FlexEvent):void{}
		
		protected function onInitialize(event:FlexEvent):void{}
		
		//--------------------------------------------------------------------------
		// Localization integration
		//--------------------------------------------------------------------------
		
		/**
		 * Shortcut to translate texts using Localizator class.
		 *
		 * @param key Key needed to locate the translation.
		 *
		 * @return Translated String.
		 */
		public function _(key:String,domain:String=null):String
		{
			if (domain && domain.length > 0){
				return I18n.translate(key,domain);
			} else {
				return I18n.translate(key,_domain);
			}
		}
		
		public function set domain(value:String):void
		{
			I18n.instance.install(value);
			_domain = value;
		}
		
		public function get domain():String
		{
			return _domain;
		}
	}
}