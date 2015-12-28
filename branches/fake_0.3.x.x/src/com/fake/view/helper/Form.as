package com.fake.view.helper
{
	import com.fake.I18n;
	import com.fake.controller.Action;
	import com.fake.controller.CakeController;
	import com.fake.controller.Controller;
	import com.fake.controller.IController;
	import com.fake.events.FormEvent;
	import com.fake.model.Model;
	import com.fake.model.ResultSet;
	import com.fake.utils.FieldUtil;
	import com.fake.utils.Inflector;
	import com.fake.view.helper.form.IField;
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;

	/**
	 * Form helper
	 *
	 * This class helps the integration between forms and Fake's system
	 * (only works with fields thast implements the IField interface)
	 * 
	 * It provides the following functionalities:
	 * - load (loads fields default values, pre-defined values sent from server or loaded values from the server)
	 * - submit (captures all fields values and submit it to the server through controller's call)
	 * - reset (reset all fields)
	 * - validation (customizable client validation before submitting)
	 * - interactive methods (submitClick, resetClick)
	 */ 
	public class Form extends Canvas implements IForm
	{
		//--------------------------------------------------------------------------
		//  Class Constants
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		
		/**
		 * Respective Controller
		 */
		private var _controller:IController;
		
		/**
		 * Respective Action
		 */
		private var _action:Action;
		
		/**
		 * List of fields related
		 */
		private var _fields:Array;
		
		private var _dataName:String;
		
		private var _domain:String;
		
		public var model:Model;
		
		public var alias:String;
		
		/**
		 * Lock to prevent user from clicking repetitive times in submit button
		 */
		private var _submitLocked:Boolean = false;
		
		//--------------------------------------------------------------------------
		//  Initialization
		//--------------------------------------------------------------------------
		
		public function Form(action:Action=null)
		{
			super();
			
			if (action){
				this.action = action;
			}
			
			_fields = new Array;
			
			addEventListener(FlexEvent.INITIALIZE,onInitialize);
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
		}
		
		protected function onInitialize(event:FlexEvent):void
		{
			load();
		}
		
		//--------------------------------------------------------------------------
		//  Setters and Getters
		//--------------------------------------------------------------------------
		
		public function set controller(value:IController):void
		{
			_controller = value;
			if ( _controller is Controller ){
				domain = Controller(_controller).domain;
			}
			
		}
		
		public function get controller():IController
		{
			return _controller;
		}
		
		public function set action(value:Action):void
		{
			_action = value;
		}
		
		public function get action():Action
		{
			return _action;
		}
		
		public function set dataName(value:String):void
		{
			_dataName = value;
		}
		
		public function get dataName():String
		{
			return _dataName;
		}
		
		//--------------------------------------------------------------------------
		//  Hanldling Fields
		//--------------------------------------------------------------------------
		
		public function register(field:IField):void
		{
			_fields.push(field);
		}
		
		public function field(name:String):IField
		{
			var field:IField; 
			for each(field in _fields){
				if (field.dataField == name){
					return field;
				}
			}
			return null;
		}
		
		//--------------------------------------------------------------------------
		//  Main methods
		//--------------------------------------------------------------------------
		
		public function load():void
		{
			var loadAction:Action = new Action(action.name,onLoad);
			loadAction.params = action.params;
			loadAction.data = action.data;
			CakeController(controller).call(loadAction);
		}
		
		protected function onLoad(result:ResultSet):void
		{
			if ( result.data )
			{
				if ( alias && result.dataSet[alias] is Model )
				{
					model = result.dataSet[alias];
				}
				else if ( result.dataSet[dataName] is Model )
				{ 
					model = result.dataSet[dataName];
				}
				
				data = result.data;
				
				var field:IField;
				for each (field in _fields){
					field.load();
				}
			}
			
			var event:FormEvent = new FormEvent(FormEvent.LOADED);
			event.data = result;
			
			dispatchEvent(event);
		}
		
		public function submit():void
		{
			if (!_submitLocked)
			{
				_submitLocked = true;
				
				var submitAction:Action = new Action(action.name,onSubmit);
				submitAction.params = action.params;
				submitAction.data = capture();
				
				var messages:Array = new Array;
				var validationErrors:Array = new Array;
				
				/*// Check required property for each field
				var field:IField;
				for each (field in _fields)
				{
					if (field.required && field.isEmpty())
					{
						messages[field.dataField] = 'fieldRequired';
					}
				}*/
				
				// Call default validation for each field
				var field:IField;
				for each (field in _fields)
				{
					var message:String = field.validate();
					if (message){
						messages[field.dataField] = message;
					}
				}
				
				// Call customizable validation
				var customMessages:Array = validate(submitAction.data);
				for (key in customMessages)
				{
					if (customMessages[key]){
						messages[key] = customMessages[key];
					}
				}
				
				// Convert messages to validationError structure
				for (var key:String in messages)
				{
					var steps:Array = key.split('.');
					
					if (steps.length == 1){
						// Main Model field (Main Model fields does not include the modelName on its name)
						if (!validationErrors.hasOwnProperty(dataName)) validationErrors[dataName] = new Array;
						validationErrors[dataName][steps[0]] = messages[key];
						validationErrors.length++;
					} else if (steps.length == 2){
						// Related Model field
						if (!validationErrors.hasOwnProperty(steps[0])) validationErrors[steps[0]] = new Array; 
						validationErrors[steps[0]][steps[1]] = messages[key];
						validationErrors.length++;
					} else {
						// TODO: Anything different is error
					}
				}
				
				if ( validationErrors.length == 0 ) {
					CakeController(controller).call(submitAction);
				} else {
					// Map Errors
					mapErrorMessages(validationErrors);
					_submitLocked = false;
					
					// TODO: Create Dialog Box with error messages
					// We can dispatch an event with error messages also
					// Sugestao Cria-la, guardar a referencia e adiciona-la com addChildAt(0)
				}
			}
		}
		
		public function capture():Object
		{
			var collectedData:Object = null;
			
			var field:IField;
			for each (field in _fields)
			{
				if (FieldUtil.isSingleField(field))
				{
					var steps:Array = field.dataField.split('.');
					var modelName:String;
					var modelField:String;
					
					if (steps.length == 1){
						// Main Model (does not include the modelName on its name)
						modelName = dataName;
						modelField = steps[0];
					} else if (steps.length == 2){
						// Related Model
						modelName = steps[0];
						modelField = steps[1];
					} else {
						// TODO: Anything different is error
					}
					
					if (!collectedData) collectedData = new Object;
					
					if (!collectedData.hasOwnProperty(modelName)) collectedData[modelName] = new Object;
					
					collectedData[modelName][modelField] = field.capture();
				}
				else if (FieldUtil.isHABTMRelation(field))
				{
					if (!collectedData) collectedData = new Object;
					if (!collectedData.hasOwnProperty(field.dataField)) collectedData[field.dataField] = new Object;
					collectedData[field.dataField][field.dataField] = field.capture();
				}
				else if (FieldUtil.isMultipleRecords(field)) 
				{
					var listName:String = Inflector.singularize(field.dataField);
					if (!collectedData) collectedData = new Object;
					collectedData[listName] = field.capture();
				}
			}
			
			return collectedData;
		}
		
		public function reset():void
		{
			var field:IField;
			for each (field in _fields){
				field.reset();
			}
		}
		
		// client validation
		public function validate(data:*):Array
		{
			return null;
		}
		
		private function onSubmit(result:ResultSet):void
		{
			if (result.data != null)
			{
				if (result.data.hasOwnProperty('validationErrors'))
				{
					// Get models array with an array of error messages for each model
					var validationErrors:Object = result.data.validationErrors;
					
					mapErrorMessages(validationErrors);
					_submitLocked = false;
					
					// TODO: Create Dialog Box with error messages
					// We can dispatch an event with error messages also
					// Sugestao Cria-la, guardar a referencia e adiciona-la com addChildAt(0)
				}
				else if (result.data.hasOwnProperty('Message') &&
					String(result.data.Message).search("could not be saved. Please, try again.") != -1 )
				{
					// TODO: Re-evaluate this
					Alert.show(_("cakeFormErrorMessage"));
					_submitLocked = false;
				}
				else
				{
					// TODO: Create FormEvent.CLOSE and FormEvent.UPDATED
					dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
					dispatchEvent(new FormEvent(FormEvent.CLOSE));
					dispatchEvent(new FormEvent(FormEvent.UPDATED));
					
					if (action.resultHandler != null){
						action.resultHandler(result)
					}
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//  Form validation error handling
		//--------------------------------------------------------------------------
		
		private function mapErrorMessages(validationErrors:Object):void
		{
			// Map error to its respective fields
			var field:IField;
			for each (field in _fields)
			{
				// Clean previous errors
				field.errorString = null;
				
				var steps:Array = field.dataField.split('.');
				var modelName:String;
				var modelField:String;
				
				if (steps.length == 1){
					// Main Model (does not include the modelName on its name)
					modelName = dataName;
					modelField = steps[0]; 
				} else if (steps.length == 2){
					// Related Model
					modelName = steps[0];
					modelField = steps[1];
				} else {
					// TODO: Anything different is error
				}
		
				if (validationErrors.hasOwnProperty(modelName) && validationErrors[modelName].hasOwnProperty(modelField))
				{
					field.errorString = _(validationErrors[modelName][modelField]);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//  Interactive Methods
		//--------------------------------------------------------------------------
		
		public function submitClick(event:Event):void
		{
			submit();
		}
		
		public function resetClick(event:Event):void
		{
			reset();
		}
		
		public function closeClick(event:Event):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			dispatchEvent(new FormEvent(FormEvent.CLOSE));
		}
		
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