		import com.fake.view.helper.IForm;
		
		import mx.events.FlexEvent;
	
		private var _form:IForm;
		private var _dataField:String;
		private var _defaultValue:String;
		private var _required:Boolean;
		
		private function onCreationComplete(event:FlexEvent):void
		{
			if ( !_form && (parentDocument is IForm) ){
				_form = IForm(parentDocument);
				_form.register(this);
			}
		}
		
		public function set form(value:IForm):void
		{
			_form = value;
			_form.register(this);
		}
				
		public function get form():IForm
		{
			return _form;
		}
		
		public function set dataField(value:String):void
		{
			_dataField = value;
		}
		
		public function get dataField():String
		{
			return _dataField;
		}

		public function set defaultValue(value:String):void
		{
			_defaultValue = value;
		}
		
		public function get defaultValue():String
		{
			return _defaultValue;
		}
		
		public function set required(value:Boolean):void
		{
			_required = value;
		}

		public function get required():Boolean
		{
			return _required;
		}
