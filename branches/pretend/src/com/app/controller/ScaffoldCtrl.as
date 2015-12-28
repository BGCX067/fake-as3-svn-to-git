/* SVN FILE: $Id: ScaffoldCtrl.as 74 2008-04-03 18:03:56Z gwoo.cakephp $ */
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
 * @subpackage		com.app.controller
 * @since			2008-03-06
 * @version			$Revision: 74 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-04-04 01:03:56 +0700 (Fri, 04 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.controller
{
	import com.app.model.SchemaLoader;
	import com.app.view.helper.FormHelper;
	import com.fake.model.Model;
	import com.fake.model.ResultSet;
	import com.fake.utils.DescribeUtil;
	import com.fake.utils.Router;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ListEvent;

	public class ScaffoldCtrl extends Canvas
	{
		[Bindable] public var model:Model;

		public var modelName:String;
		public var properties:DataGrid;

		public var grid:DataGrid;

		public var form:FormHelper;
		public var btnSubmit:Button;
		public var btnReset:Button;

		public var tabs:TabNavigator;

		public function ScaffoldCtrl()
		{
			this.addEventListener(FlexEvent.INITIALIZE, init);
			this.addEventListener(FlexEvent.CREATION_COMPLETE, list);
		}

		/**
		 * Initialize the scaffold on creation complete
		 * @param event
		 *
		 */
		protected function init(event:Event):void
		{
			var SL:SchemaLoader = new SchemaLoader();

			//var ModelRef:Model = new Model();
			model = Model.getModel(modelName);

			tabs.addEventListener(IndexChangedEvent.CHANGE, onTabChange);

			var desc:XML = DescribeUtil.instance.describe(model);
			properties.dataProvider = desc..variable;

			Router.instance.init(this);
		}

		/**
		 * handle the tabs
		 * @param event
		 *
		 */
		public function onTabChange(event:IndexChangedEvent):void
		{
			switch(event.newIndex)
			{
				case 0:
					Router.instance.call('Scaffold.list');
				break;
				case 1:
					Router.instance.call('Scaffold.add');
				break;
			}
		}

		/**
		 * The List Action
		 * @param event
		 *
		 */
		public function list(event:Event):void
		{
			model.index(onList);
		}

		/**
		 * The Submit Action
		 * @param event
		 *
		 */
		public function submit(event:Event):void
		{
			form.model = model;

			if (event.type == 'click') {
				form.capture();
				model.add(onList, model);
			} else if (!form.initialized) {
				form.display();
				btnSubmit.addEventListener(MouseEvent.CLICK, submit);
				btnReset.addEventListener(MouseEvent.CLICK, reset);
			}

			tabs.selectedIndex = 1;
		}

		public function reset(event:Event):void
		{
			form.reset();
		}

		/**
		 * Handle DataSet results
		 * @param result
		 *
		 */
		private function onList(result:ResultSet):void
		{
			if (result.dataSet.data.Post.list.length > 0)
			{
				tabs.selectedIndex = 0;
				grid.visible = true;
				grid.dataProvider = result.dataSet.data.Post.list;
				grid.addEventListener(ListEvent.ITEM_CLICK, onItemClick);
			}
			else
			{
				tabs.selectedIndex = 1;
			}
		}

		/**
		 * Handle DataGrid item click
		 * @param event
		 *
		 */
		private function onItemClick(event:ListEvent):void
		{

			form = new FormHelper();
			btnSubmit = new Button();
			btnSubmit.label = "Update";
			btnReset = new Button();

			if (grid.selectedItem)
			{
				model.ro = grid.selectedItem;
			}

			Router.instance.call("Scaffold.edit", model);
		}
	}
}