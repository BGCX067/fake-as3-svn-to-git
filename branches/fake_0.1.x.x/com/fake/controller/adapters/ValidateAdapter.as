/* SVN FILE: $Id:ValidateAdapter.as 95 2008-04-21 23:34:12Z xpointsh $ */
/**
 * Description
 *
 * Fake
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake
 * @subpackage		com.fake.model
 * @since			2008-03-06
 * @version			$Revision:95 $
 * @modifiedby		$LastChangedBy:xpointsh $
 * @lastmodified	$Date:2008-04-21 16:34:12 -0700 (Mon, 21 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.controller.adapters
{
	import com.fake.controller.IController;
	
	import flash.geom.Point;
	
	import mx.core.IToolTip;
	import mx.core.UIComponent;
	import mx.managers.ToolTipManager;
	
	public class ValidateAdapter extends FormAdapter
	{
		protected var errorTipHash:Object = new Object();
		
		public function ValidateAdapter(value:IController=null)
		{
			super(value);
		}
		
		public function validateEmpty(txt:Object, isValid:Object, msg:String = null, offset:Point = null):void
		{
			if(!offset)
				offset = new Point(0,0);
			if(!msg)
				msg = "this field is not valid";
				
			if(txt.text == "")
			{
				isValid.valid = false;
				
				displayError(txt, msg, offset);
			}
		}
		
		public function validateEqual(txt:Object, txt2:Object, isValid:Object, msg:String = null, offset:Point = null):void
		{
			if(!offset)
				offset = new Point(0,0);
			if(!msg)
				msg = "these fields must be equal";
				
			if(txt.text != txt2.text)
			{
				isValid.valid = false;
				
				displayError(txt, msg, offset);
			}
		}
		
		public function validateEmail(txt:Object, isValid:Object, msg:String = null, offset:Point = null):void
		{
			if(!offset)
				offset = new Point(0,0);
			if(!msg)
				msg = "not a valid email address";
			
			var emailRegExp:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
			
			if(!String(txt.text).toString().match(emailRegExp))
			{
				isValid.valid = false;
				
				displayError(txt, msg, offset);
			}
		}
		
		public function validatePrompt(txt:Object, isValid:Object, msg:String = null, offset:Point = null):void
		{
			if(!offset)
				offset = new Point(0,0);
			if(!msg)
				msg = prompt[txt.id] + " is not valid";
				
			if(txt.text == prompt[txt.id])
			{
				isValid.valid = false;
				
				displayError(txt, msg, offset);
			}
		}
		
		public function displayError(ui:Object, msg:String, offset:Point):void
		{
			var point:Point = new Point(ui.x + ui.width + offset.x, ui.y + offset.y);
			point = UIComponent(controller).localToGlobal(point);
			
			errorTipHash[ui.id] = ToolTipManager.createToolTip(msg, point.x, point.y);
			errorTipHash[ui.id].setStyle("styleName", "errorTip");
		}
		
		public function clearErrorToolTips():void
		{
			for(var tip:String in errorTipHash)
			{
				ToolTipManager.destroyToolTip(IToolTip(errorTipHash[tip]));
	            errorTipHash[tip] = null;
			}
		}
	}
}