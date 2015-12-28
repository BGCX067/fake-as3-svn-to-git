/* SVN FILE: $Id: FakeTestCase.as 99 2008-04-23 23:16:20Z gwoo.cakephp $ */
/**
 * Description
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
 * @version			$Revision: 99 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-04-24 06:16:20 +0700 (Thu, 24 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package lib
{
	import com.fake.model.ResultSet;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	import mx.containers.VBox;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.utils.ObjectUtil;

	public class FakeTestCase extends TestCase
	{
		public var assertTimer:Timer;
		public var currentCall:String = "";
		public var finishedCall:String = "";

		public function FakeTestCase(methodName:String=null)
		{
			super(methodName);
		}

		public function suite():TestSuite
		{
			return null;
		}

		public function assertService(currentCall:String, interval:int = 1000):void
   		{
   			this.currentCall = currentCall;
   			assertTimer = new Timer(interval);
   			assertTimer.addEventListener(TimerEvent.TIMER, addAsync(assertServiceCheck, interval))
   			assertTimer.start();
   		}

   		public function assertServiceCheck(event:TimerEvent):void
		{
			assertEquals(currentCall,finishedCall);
		}

   		public function assertServiceDone(finishedCall:String, resultSet:ResultSet):void
   		{
   			this.finishedCall = finishedCall;
			this.addToResult(finishedCall, resultSet);
   		}

   		public function addToResult(label:String, result:Object):void
   		{
   			var vbox:VBox = new VBox();
   			vbox.label = label;
   			vbox.percentWidth = 100;
   			vbox.percentHeight = 100;

   			var text:TextArea = new TextArea();
   			text.text = ObjectUtil.toString(result);
   			text.percentWidth = 100;
   			text.percentHeight = 100;
   			text.wordWrap = false;

   			vbox.addChild(text);
   			runner(Application.application).testRunner.console.addChild(vbox);
   		}

   		public function assertObjectEquals(exp:Object, act:Object):void
   		{
   			if (exp == null && act == null) {
				return;
			}

			if (exp != null)
			{
				if (exp == act) {
					return;
				}
				else if (ObjectUtil.compare(exp, act) == 0)
				{
					return;
				}
				else
				{
					var result:String = __objectNotEqual(exp, act);
					if (result != "")
					{
						Assert.fail(result);
					}
				}
			}
		}

		private function __objectNotEqual(exp:*, act:*):String
		{
			var result:String = "";

			for (var prop:* in exp)
			{
				if (exp[prop] is String)
				{
					if (exp[prop] != act[prop])
					{
						result += prop + ": " + exp[prop] + ' is not equal to '+ act[prop] + "\n";
					}
				}
				else if (exp[prop] is Array || exp[prop] is Object)
				{
					if (exp[prop] == null)
					{
						result += prop + " with value " + act[prop] + " was not found in object\n";
					}
					else if (act[prop] == null)
					{
						result += prop + " with value " + exp[prop] + " was not found in object\n";
					}
					else if (ObjectUtil.compare(exp, act) != 0)
					{
						result += __objectNotEqual(exp[prop], act[prop]);
					}
				}
			}
			return result;
		}
	}
}