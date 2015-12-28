package com.fake.view.helper.form
{
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	public class FieldBase extends Canvas implements IField
	{
		// CAUTION: This kind of implementation is only mentioned in Adobe's Guide for Programming in Actionscript 3.
		// It is not used to import but to insert a piece of code from an .as file into another .as file.
		// In this case we have implemented some basic methods from IField that won't change and are needed for every Field.
		// We haven't implemented them directly here because some of the Fields will extend a basic Flex control, and since
		// Actionscript does not allow us to extend two classes this sort of implementation will be used for every Field.
		include "AbstractField.as";
		
		//--------------------------------------------------------------------------
		//  Initialization
		//--------------------------------------------------------------------------
		
		public function FieldBase()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//--------------------------------------------------------------------------
		//  Intarface basic implementations
		//--------------------------------------------------------------------------
		
		public function load():void
		{
		}
		
		public function validate():String
		{
			return null;
		}
		
		public function capture():*
		{
			return null;
		}
		
		public function reset():void
		{
		}
		
		/* Already implemented by default in Canvas
		public function set errorString(value:String):void
		{
		}
		*/
	}
}