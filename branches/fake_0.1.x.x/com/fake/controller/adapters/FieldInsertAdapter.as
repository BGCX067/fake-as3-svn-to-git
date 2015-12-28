/* SVN FILE: $Id:FieldInsertAdapter.as 95 2008-04-21 23:34:12Z xpointsh $ */
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
	import com.fake.controller.utils.ControllerUtil;
	import com.fake.model.DataSet;
	
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	public class FieldInsertAdapter extends FormAdapter
	{
		public var defaultFindTypes:Array = [NumericStepper, CheckBox, TextInput, TextArea, ComboBox];
		public var uiHash:Object = {};
		
		public function FieldInsertAdapter(value:IController)
		{
			super(value);
		}
		
		public function insertFromModel(dataSet:DataSet):void
		{
			var foundUIComponents:Array = ControllerUtil.findByType(defaultFindTypes);
			var uiHash:Object = {};
			
			for each(var uiComponent:UIComponent in foundUIComponents)
			{
				uiHash[uiComponent.id] = uiComponent;
				
				insertToComponent(uiComponent, dataSet);
			}
		}
		
		public function insertToComponent(uiComponent:UIComponent, dataSet:DataSet):Object
		{
			/* var result:Object = {};
			
			var typePrefix:String = uiComponent.id.split("_")[0];
			var modelName:String = uiComponent.id.split("_")[1];
			var fieldName:String = uiComponent.id.split("_")[2];
			
			switch(typePrefix)
			{
				case "num":
					result = (NumericStepper(uiComponent).value = int(dataSet[modelName].value);
					break;
				case "chk":
					result = captureCheckBox(CheckBox(uiComponent), fieldName);
					break;
				case "txti":
					result = captureTextInput(TextInput(uiComponent), fieldName);
					break;
				case "txta":
					result = captureTextArea(TextArea(uiComponent), fieldName);
					break;
				case "cb":
					if(!ComboBox(uiComponent).restrict)
						result = captureComboBox(ComboBox(uiComponent), fieldName);
					break;
			}
			return result; */
			return {};
		}
	}
}