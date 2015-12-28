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
	
	import flash.display.DisplayObjectContainer;
	
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.controls.RadioButton;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	public class FieldInsertAdapter extends FormAdapter
	{
		public var defaultFindTypes:Array = [
			NumericStepper, CheckBox, TextInput, TextArea, ComboBox, RadioButton
		];
		
		public var uiHash:Object = {};
		
		
		public var radioButtonGroups:Array;
		
		public function FieldInsertAdapter(value:IController = null)
		{
			super(value);
		}
		
		public function insertFromModel(dataSet:DataSet):void
		{
			this.radioButtonGroups = [];
			var foundUIComponents:Array = ControllerUtil.findByType(defaultFindTypes);
			var uiHash:Object = {};
			
			for each(var uiComponent:UIComponent in foundUIComponents)
			{
				uiHash[uiComponent.id] = uiComponent;
				
				insertToComponent(uiComponent, dataSet);
			}
		}
		
		public function insertFromObject(container:DisplayObjectContainer, data:Object, types:Array = null):void
		{
			this.radioButtonGroups = [];
			if (types === null)
			{
				types = this.defaultFindTypes;
			}
			var foundUIComponents:Array = ControllerUtil.findByType(types, container);
			
			for each (var uiComponent:UIComponent in foundUIComponents)
			{
				this.insertToComponent(uiComponent, data);
			}
		}
		
		public function insertToComponent(uiComponent:UIComponent, data:Object):void
		{
			var fieldName:String;
			if (uiComponent.id !== null) 
			{
				fieldName = uiComponent.id.split("_")[2];
				var typePrefix:String = uiComponent.id.split("_")[0];
				
				switch(typePrefix)
				{
					case "num":
						(NumericStepper(uiComponent).value = int(data[fieldName]));
						return;
					case "chk":
						(CheckBox(uiComponent).selected = Boolean(data[fieldName]));
						return;
					case "txti":
						(TextInput(uiComponent).text = String(data[fieldName]));
						return;
					case "txta":
						(TextArea(uiComponent).text = String(data[fieldName]));
						return;
					case "cb":
						if(!ComboBox(uiComponent).restrict) 
						{
							var cb:ComboBox = uiComponent as ComboBox;
							for each (var item:Object in cb.dataProvider)
							{
								if ((item.hasOwnProperty('data') && item.data == data[fieldName]) || item == data[fieldName])
								{
									cb.selectedItem = data[fieldName];
									return;
								}
							}
						}
						return;
				}
			}
			
			if (uiComponent is RadioButton)
			{
				var radioButton:RadioButton = uiComponent as RadioButton;
				if (this.radioButtonGroups.indexOf(radioButton.groupName) == -1)
				{
					fieldName = radioButton.groupName.split('_')[2];
					this.radioButtonGroups.push(radioButton.groupName);
					
					radioButton.group.selectedValue = String(data[fieldName]);
					return;
				}
			}
		}
	}
}