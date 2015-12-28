package com.fake.view.helper.form
{
	import com.fake.utils.ModelUtil;
	import com.fake.view.helper.Form;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;

	public class TextInput extends mx.controls.TextInput implements IField
	{
		
		include "AbstractField.as";
				
		public function TextInput()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
		}
			
		public function load():void
		{
			var value:String = ModelUtil.dataFieldToValue(dataField,Form(form).model);
			
			if (value && value.length > 0){
				text = value;
			} else if (defaultValue && defaultValue.length > 0) {
				text = defaultValue;
			}
		}		
		
		public function capture():*
		{
			return text;
		}
		
		public function reset():void
		{
			text = '';
		}
		
		public function validate():String
		{
			if (required && (text.length == 0)){
				//return Localizator.__('fieldRequired');
			}
			
			return null;
		}

	}
}