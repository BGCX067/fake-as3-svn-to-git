package com.fake.view.helper.form
{
	import com.fake.utils.ModelUtil;
	import com.fake.view.helper.Form;
	
	import mx.controls.Label;
	
	public class ForeignLabel extends mx.controls.Label implements IField
	{
		private var _selectedId:uint;
		
		include "AbstractField.as";
		
		public function ForeignLabel()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function load():void
		{
			_selectedId = uint(ModelUtil.searchDepth(dataField,Form(form).model));
			
			if(_selectedId == 0 && defaultValue && defaultValue.length > 0)
			{
				_selectedId = uint(defaultValue);
			}
			
			var _text:String = ModelUtil.getForeignKeyLabel(dataField,_selectedId,form);
			
			if ( _text && _text.length > 0 ){
				text = _text;
			}
		}
		
		public function capture():*
		{
			return _selectedId;
		}
		
		public function reset():void
		{
		}
		
		public function validate():String
		{
			return null;
		}
		
	}
}