package com.fake.controller
{
	import com.fake.FakeObject;
	import com.fake.controller.component.IComponent;
	import com.fake.model.Model;
	import com.fake.model.ResultSet;
	import com.fake.utils.DescribeUtil;
	import com.fake.utils.Inflector;
	
	import mx.events.FlexEvent;
	
	/**
	 * CakeController
	 *
	 * This class implements the same controller logic as Cake's Controller
	 * 
	 * It provides the following functionalities:
	 * - callbacks: beforeFilter, beforeRender, afterFilter
	 * - commnucation with server through Model using call method
	 * - extension with components (components support)
	 */ 
	public class CakeController extends Controller implements IController
	{
		//--------------------------------------------------------------------------
		//  Class Constants
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		
		/**
		 * List of components enabled to use
		 */
		private var _components:Array;
		
		/**
		 * Components organized by their name for faster access
		 */
		private var _componentsHash:FakeObject;
		
		/**
		 * Order of actions been executed. Used mainly to access then after calling the server.
		 */
		private var _actionStack:Array;
		
		/**
		 * Respective Model
		 */
		protected var model:Model;
		
		//--------------------------------------------------------------------------
		//  Initialization
		//--------------------------------------------------------------------------
		
		public function CakeController()
		{
			super();
			
			_components		= new Array;
			_componentsHash = new FakeObject;
			_actionStack	= new Array;
		}
		
		override protected function onCreationComplete(event:FlexEvent):void
		{
			super.onCreationComplete(event);
		}
		
		override protected function onInitialize(event:FlexEvent):void
		{
			super.onInitialize(event);
		}
		
		//--------------------------------------------------------------------------
		//  Components
		//--------------------------------------------------------------------------
		
		/**
		 * Set components to complement Controller's logic
		 *
		 * @param list list of components classes
		 */
		public function set components(list:*)
		{
			for each (var componentClass:Class in list)
			{
				if (componentClass is Class)
				{
					var component:IComponent = new componentClass;
					
					if (component is IComponent)
					{
						_components.push(component);
						IComponent(component).controller = this;
		
						// Creates property in Controller for faster access
						// Permits us to access it by the name as this->components->ComponentName->properties
						_componentsHash[DescribeUtil.localName(component)] = component;
					}
				}
			}
		}
		
		public function get components():*
		{
			return _componentsHash;
		}
		
		//--------------------------------------------------------------------------
		//  Server Requests
		//--------------------------------------------------------------------------
		
		/**
		 * Controller-side call method to link requests to server through Model
		 *
		 * @param action action details
		 */
		public function call(action:Action):void
		{
			_actionStack.push(action);
			
			var component:IComponent;
			for each (component in _components){
				component.initialize(action);
			}
			
			beforeFilter(action);
			
			for each (component in _components){
				component.startup(action);
			}
			
			var service:String;
			
			if (action.requestHandler)
			{
				action.requestHandler(action,onCall);
			}
			else if (model)
			{
				service = Inflector.pluralize(model.className)+'.'+action.name;
				
				for each (var param:String in action.params){
					service += '.'+param;
				}
			
				model.call(service,action.data,onCall);
			}
			else
			{
				// TODO: do something? Is it possible to not have a model set
				//model = new Model; // Creates a generic model?
			}
		}
		
		/**
		 * Result handler for call method
		 *
		 * @param result formatted result returned from server
		 */
		private function onCall(result:ResultSet):void
		{
			var action:Action = _actionStack.pop();
			
			beforeRender(action,result);
			
			var component:IComponent;
			for each (component in _components){
				component.beforeRender(action,result);
			}
			
			// Hanldles data into user interface
			if (action.resultHandler != null){
				action.resultHandler(result)
			}
			
			afterFilter(action,result);
			
			for each (component in _components){
				component.shutdown(action,result);
			}
		}
		 
		//--------------------------------------------------------------------------
		//  Callbacks
		//--------------------------------------------------------------------------
		
		protected function beforeFilter(action:Action):void
		{
			
		}
		
		protected function beforeRender(action:Action,result:ResultSet):void
		{
			
		}
		
		protected function afterFilter(action:Action,result:ResultSet):void
		{
			
		}
	}
}