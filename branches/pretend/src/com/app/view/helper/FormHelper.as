/* SVN FILE: $Id: FormHelper.as 30 2008-03-15 22:59:05Z gwoo.cakephp $ */
/**
 * Description
 *
 * Pretend
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			pretend
 * @subpackage		com.app.view.helper
 * @since			2008-03-06
 * @version			$Revision: 30 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-16 04:59:05 +0600 (Sun, 16 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.view.helper
{
	import com.fake.model.Model;
	import com.fake.utils.DescribeUtil;
	import com.fake.utils.Inflector;
	
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.controls.CheckBox;
	import mx.controls.NumericStepper;
	import mx.controls.TextInput;
	import mx.core.UIComponent;

	public class FormHelper extends Form
	{
		[Bindable] public var model:Model;
		
		public var hash:Object = {};
		
		public function FormHelper()
		{
			super();
		}
		
		/**
		 *  displays the form based on a model
		 * 
		 */
		public function display():void
		{						
			var desc:XML = DescribeUtil.instance.describe(model);
			var fobj:Object = Object(model);
			
			for each(var variable:XML in desc..variable)
			{
				if((variable.metadata == null || variable.metadata.@name != "Transient") && variable.@name != model.primaryKey)
				{
					var fItem:FormItem = new FormItem();
							
					var uiComp:UIComponent = generateInput(variable.@name, variable.@type);
					
					if(uiComp == null) continue;
					
					hash[variable.@name] = uiComp;
					
					fItem.label = Inflector.humanize(variable.@name);
					fItem.addChild(uiComp);
					
					this.addChild(fItem);	
				}		
				
				if (variable.@name == model.primaryKey)
				{
					if (variable.@value == null)
					{
						//we could change the button label here
					}
				}
			}
			this.visible = true;
		}
		
		/**
		 * Generates a form input from the name and type 
		 * @param name
		 * @param type
		 * @return 
		 * 
		 */
		public function generateInput(name:String, type:String):UIComponent
		{
			var fobj:Object = Object(model);
			
			if(type == "int")
			{
				var num:NumericStepper = new NumericStepper();
				num.id = "num"+name;
				num.name = name
				num.maximum = 999999;
				
				if(fobj[name] != null)
				{
					num.value = int(fobj[name]);
				}
				
				return num;
			}
			else if(type == "Boolean")
			{
				var bool:CheckBox = new CheckBox();
				bool.id = "chk"+name;
				bool.name = name;
				
				if(fobj[name] != null)
				{
					bool.selected = Boolean(fobj[name]);
				}
				
				return bool;
			}
			else if(type == "String")
			{
				var txt:TextInput = new TextInput();
				txt.id = "txt"+name;
				txt.name = name;
				
				if(fobj[name] != null)
				{
					txt.text = String(fobj[name]);
				}
				
				return txt;
			}
			
			return null;
		}
		
		/**
		 * Captures the value object that was submitted 
		 * 
		 */
		public function capture():void
		{
			var desc:XML = DescribeUtil.instance.describe(model);
			var fobj:Object = Object(model);
			
			for each(var variable:XML in desc..variable)
			{
				var name:String = variable.@name;
				
				var uiComp:UIComponent = UIComponent(hash[name]);
				
				if(uiComp == null) continue;
				
				var prefix:String = uiComp.id.split(name)[0];
				
				if(prefix == "num")
				{
					fobj[name] = NumericStepper(uiComp).value;
				}
				else if(prefix == "chk")
				{
					fobj[name] = CheckBox(uiComp).selected;
				}
				else if(prefix == "txt")
				{
					fobj[name] = TextInput(uiComp).text;
				}
			}
		}
		
		public function reset():void
		{
			var desc:XML = DescribeUtil.instance.describe(model);
			
			for each(var variable:XML in desc..variable)
			{
				var name:String = variable.@name;
				var uiComp:UIComponent = UIComponent(hash[name]);
			
				if(uiComp == null) continue;
				
				var prefix:String = uiComp.id.split(name)[0];
				
				if(prefix == "num")
				{
					NumericStepper(uiComp).value = 0;
				}
				else if(prefix == "chk")
				{
					CheckBox(uiComp).selected = false;
				}
				else if(prefix == "txt")
				{
					TextInput(uiComp).text = "";
				}
			}
		}
	}
}