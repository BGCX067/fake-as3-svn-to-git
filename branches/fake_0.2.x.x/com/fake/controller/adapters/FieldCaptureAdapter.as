/* SVN FILE: $Id:FieldCaptureAdapter.as 95 2008-04-21 23:34:12Z xpointsh $ */
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
	import com.fake.model.Model;

	import flash.display.DisplayObjectContainer;

	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.NumericStepper;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;

	public class FieldCaptureAdapter extends FormAdapter
	{
		private var __radioButtonGroups:Array;

		public function FieldCaptureAdapter(value:IController=null)
		{
			super(value);
		}

		// Delegates
		public var beforeCapture:Function = new Function();
		public var afterSingleCapture:Function// public function afterSingleCapture(model:Model, result:Object, uiComp:UIComponent, modelType:Class = null):void
		public var afterMultipleCapture:Function; // public function afterMultipleCapture(modelArray:Array, result:Object, uiComp:UIComponent):void
		public var defaultFindTypes:Array = [NumericStepper, CheckBox, TextInput, TextArea, ComboBox, RadioButton];


		public function captureSingleModel(source:DisplayObjectContainer = null, types:Array = null, modelType:Class = null):Model
		{
			var componentArray:Array = [];
			var model:Model = new modelType();
			this.__radioButtonGroups = [];

			if(types != null) {
				componentArray = ControllerUtil.findByType(types, source);
			} else {
				componentArray = ControllerUtil.findByType(defaultFindTypes, source);
			}

			for each(var uiComponent:UIComponent in componentArray)
			{
				var result:Object = null;

				beforeCapture(uiComponent);

				result = parseResult(uiComponent);

				if (result !== null)
				{
					afterSingleCapture(model, result, uiComponent, modelType);
				}
			}

			return model;
		}

		public function captureMultipleModel(source:DisplayObjectContainer = null, types:Array = null):Array
		{
			var componentArray:Array = [];
			var modelArray:Array = [];
			this.__radioButtonGroups = [];

			if(types != null) {
				componentArray = ControllerUtil.findByType(types, source);
			} else {
				componentArray = ControllerUtil.findByType(defaultFindTypes, source);
			}

			for each(var uiComponent:UIComponent in componentArray)
			{
				var result:Object = null;

				beforeCapture(uiComponent);

				result = parseResult(uiComponent);

				if (result !== null)
				{
					afterMultipleCapture(modelArray, result, uiComponent);
				}
			}
			return modelArray;
		}

		public function captureCheckBox(source:CheckBox, fieldName:String):Object
		{
			return {field: fieldName, value: source.selected};
		}

		public function captureRadioButtonGroup(source:RadioButtonGroup, fieldName:String):Object
		{
			return {field: fieldName, value: source.selectedValue};
		}

		public function captureComboBox(source:ComboBox, fieldName:String):Object
		{
			var result:Object = {field: fieldName};

			if(source.selectedItem !== null && source.selectedItem.hasOwnProperty("data"))
			{
				result.value = source.selectedItem.data;
				return result;
			}
			result.value = source.selectedLabel;
			return result;
		}

		public function captureNumericStepper(source:NumericStepper, fieldName:String):Object
		{
			return {field: fieldName, value: source.value.toString()};
		}

		public function captureTextArea(source:TextArea, fieldName:String):Object
		{
			return {field: fieldName, value: source.text};
		}

		public function captureTextInput(source:TextInput, fieldName:String):Object
		{
			return {field: fieldName, value: source.text};
		}

		public function parseResult(uiComponent:UIComponent):Object
		{
			var fieldName:String;
			if (uiComponent.id !== null)
			{
				fieldName = uiComponent.id.split("_")[2];
				var typePrefix:String = uiComponent.id.split("_")[0];

				switch(typePrefix)
				{
					case "num":
						return captureNumericStepper(NumericStepper(uiComponent), fieldName);
						break;
					case "chk":
						return captureCheckBox(CheckBox(uiComponent), fieldName);
						break;
					case "txti":
						return captureTextInput(TextInput(uiComponent), fieldName);
						break;
					case "txta":
						return captureTextArea(TextArea(uiComponent), fieldName);
						break;
					case "cb":
						if(!ComboBox(uiComponent).restrict)
							return captureComboBox(ComboBox(uiComponent), fieldName);
						break;
				}
			}

			if (uiComponent is RadioButton)
			{
				var radioButton:RadioButton = uiComponent as RadioButton;
				if (this.__radioButtonGroups.indexOf(radioButton.groupName) == -1)
				{
					fieldName = radioButton.groupName.split("_")[2];
					this.__radioButtonGroups.push(radioButton.groupName);

					return this.captureRadioButtonGroup(RadioButtonGroup(radioButton.group), fieldName);
				}
			}
			return null;
		}
	}
}