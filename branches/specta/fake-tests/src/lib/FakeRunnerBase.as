/* SVN FILE: $Id: FakeRunnerBase.as 193 2008-09-16 19:57:15Z gwoo.cakephp $ */
/**
 * Based on FlexUnit TestRunnerBase
 *
 * Fake Tests
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake-tests
 * @subpackage		tests.lib
 * @since			2008-03-06
 * @version			$Revision: 193 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-17 02:57:15 +0700 (Wed, 17 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package lib
{
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import flexunit.flexui.IFlexWriter;
	
	import mx.containers.Accordion;
	import mx.containers.TabNavigator;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.ProgressBar;
	import mx.controls.TextArea;
	import mx.controls.Tree;
	import mx.events.FlexEvent;

	public class FakeRunnerBase extends VBox implements IFlexWriter
	{
		import flexunit.framework.TestSuite;

		import flexunit.framework.TestCase;
		import flexunit.framework.Test;
		import flexunit.framework.AssertionFailedError;
		import flexunit.flexui.TestRunner;
		import flexunit.flexui.IFlexWriter;

		import mx.collections.ListCollectionView;

		public function FakeRunnerBase()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		private var _totalTests:uint = 0;
		private var _totalErrors:uint = 0;
		private var _totalFailures:uint = 0;
		private var _numTestsRun:uint = 0;

		public var progressBar:ProgressBar;
		public var treeTestCases:Tree;
		public var testFailures:List;
		public var allTestsList:List;
		public var stackTrace:TextArea;
		public var console:Accordion;
		public var runLabel:Label;
		public var errorsLabel:Label;
		public var failuresLabel:Label;
		public var testTabs:TabNavigator;
		public var currentTest:String;
		public var testCases:Array;
		public var testCaseList:XMLList;


		/* private function onCreationComplete(event:FlexEvent):void
		{
			var req:URLRequest = new URLRequest('config.xml');
			var loader:URLLoader = new URLLoader();
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, onLoad);
 		} */

 		private function onCreationComplete(event:Event):void
 		{
			treeTestCases.dataProvider = testCaseList;
 		}


		public function run():void
		{
			progressBar.minimum = 0;
			_totalTests = 0;
			_totalFailures = 0;
			_totalErrors = 0;
			_numTestsRun = 0;
			testFailures.dataProvider = new Array();
			allTestsList.dataProvider = new Array();

			console.removeAllChildren();

 			var selectedTree:XMLList = new XMLList(treeTestCases.selectedItem);
			testCases = _findCases(selectedTree);

			if (testCases.length > 0)
			{
				runNextCase();
			}
			else
			{
				Alert.show('No test cases were selected');
			}
		}

		public function runNextCase():void
		{
			var i:int = testCases.indexOf(currentTest);
			currentTest = testCases[++i];

			if (currentTest)
			{
				try {
					var classRef:Object = getDefinitionByName(currentTest);
					var test:Test = classRef.suite();
				} catch (e:Error) {
					trace(e.name + ':' + e.message);
					trace(currentTest);
				}

				if (test) {
					progressBar.label = "Running " + currentTest;
 					progressBar.visible = true;
 					this.startTest(test);
				}
				else
				{
					runNextCase();
				}
			}
		}

		public function getLabel(item:XML):String
		{
			var label:String;

			if (item.@label) {
				label = item.@label;
			}

			if (!label && item.@name) {
				var str:String = item.@name.toString();
				var nameArray:Array = str.split(" ");
				label = String(nameArray[1]).substring(0, String(nameArray[1]).length - 1);
			}
			return label;
		}

		protected function _findCases(list:XMLList, parent:Array = null):Array
		{
			var result:Array = [];

			for each (var item:XML in list)
			{
				var name:String = getLabel(item);
				var children:XMLList = item.children();

				if (!parent)
				{
					parent = _getParent(item);
				}

				if (children.length() > 0)
				{
					parent.push(name);

					if (result.length > 0)
					{
						result = result.concat(_findCases(children, parent));
					}
					else
					{
						result = _findCases(children, parent);
					}
				}
				else if (item is XML)
				{
					name = getLabel(item);

					if (!space)
					{
						var space:String = parent.join('.');
						parent.pop();
					}
					result.push(space + '.' + name);
				}
			}

			return result;
		}

		protected function _getParent(item:Object, parent:Array = null):Array
		{
			if (!parent) {
				parent = [];
			}
			var mom:Object = item.parent();
			if (mom is XML)
			{
				var parentName:String = mom.@label;
				parent.unshift(parentName);
				parent = _getParent(mom, parent);
			}
			return parent;
		}

		public function startTest(test:Test):void
		{
			if( test != null )
			{
				_totalTests = _totalTests + test.countTestCases();
				updateLabels();
				flexunit.flexui.TestRunner.run(test, this);
			}
		}

		private function updateLabels():void
		{
			runLabel.htmlText = "<b>Run:</b> "+_numTestsRun.toString()+"/"+_totalTests.toString();
			errorsLabel.htmlText = "<b>Errors:</b> "+_totalErrors.toString();
			failuresLabel.htmlText = "<b>Failures:</b> "+_totalFailures.toString();
		}

		private function updateProgress():void
		{
			progressBar.setProgress( _numTestsRun, _totalTests );

			if( _totalErrors > 0 || _totalFailures > 0 ) {
				progressBar.setStyle("barColor",0xFF0000);
			}
		}

		private function addFailureToList( test:Test, error:Error ):void
		{
			var t:TestCase = test as TestCase;
			if( t != null )
			{
				ListCollectionView(testFailures.dataProvider).addItem( {label:t.methodName+" - "+t.className, test:test, error:error} );
				testFailures.selectedIndex = testFailures.dataProvider.length;
				testFailures.verticalScrollPosition = testFailures.maxVerticalScrollPosition;
				onTestSelected();
			}
		}

		private function addTestToList( success:Boolean, test:Test, error:Error = null ):void
		{
			var t:TestCase = test as TestCase;
			if( t != null )
			{
				var label:String = ( success ) ? "[PASS] " : "[FAIL] ";
				ListCollectionView(allTestsList.dataProvider).addItem( {label:label+t.methodName+" - "+t.className, test:test, error:error} );
				allTestsList.selectedIndex = allTestsList.dataProvider.length;
				allTestsList.verticalScrollPosition = allTestsList.maxVerticalScrollPosition;
				onTestSelected();
			}
		}

		public function onTestSelected():void
		{
			var list:List = (testTabs.selectedIndex == 0) ? allTestsList : testFailures;

			if( list.selectedItem != null )
				if( list.selectedItem.error != null )
					stackTrace.text = list.selectedItem.error.getStackTrace();
				else
					stackTrace.text = "";
		}

		public function onTestStart( test:Test ) : void
		{

		}

		public function onTestEnd( test:Test ) : void
		{
			_numTestsRun++;
			updateLabels();
			updateProgress();
		}

		public function onAllTestsEnd() : void
		{
			progressBar.setProgress(100,100);
			progressBar.label = "Done";
			runNextCase();
		}

		public function onSuccess( test:Test ):void
		{
			addTestToList( true, test );
		}

		public function onError( test:Test, error:Error ) : void
		{
			_totalErrors++;
			addFailureToList( test, error );
			addTestToList( false, test, error );
		}

		public function onFailure( test:Test, error:AssertionFailedError ) : void
		{
			_totalFailures++;
			addFailureToList( test, error );
			addTestToList( false, test, error );
		}
	}
}