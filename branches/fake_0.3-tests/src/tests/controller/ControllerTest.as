/* SVN FILE: $Id: ControllerTest.as 191 2008-09-16 15:09:38Z gwoo.cakephp $ */
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
 * @subpackage		tests.controller
 * @since			2008-03-06
 * @version			$Revision: 191 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-16 22:09:38 +0700 (Tue, 16 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.controller
{	
	import com.app.controller.SomeCtrl;
	
	import flexunit.framework.TestSuite;
	
	import lib.FakeTestCase;
	
	import mx.containers.VBox;
	import mx.controls.Button;

	public class ControllerTest extends FakeTestCase
	{
		public var ctrl:SomeCtrl;
		public var vbox:VBox;
		public var btn:Button;
		public var btn2:Button;
		
		public function ControllerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new ControllerTest( "testConstructor" ));
   			ts.addTest(new ControllerTest( "testByType" ));
   			ts.addTest(new ControllerTest( "testByTypeSubContainer" ));
   			ts.addTest(new ControllerTest( "testGetByID" ));
   			ts.addTest(new ControllerTest( "testGetByIDSubContainer" ));
   			
   			return ts;
   		}
   		
   		public function testConstructor():void 
   		{   			
   			assertEquals(ctrl.className, 'Controller');
   		}
   		
   		public function testByType():void
   		{	
   			//assertEquals(3, ctrl.findByType([VBox, Button]).length);
   		}
   		
   		public function testByTypeSubContainer():void
   		{   			
   			//assertEquals(2, ctrl.findByType([Button]).length);
   		}
   		
   		public function testGetByID():void
   		{   			
   			//assertEquals(btn, ctrl.findByID("butt1"));
   		}
   		
   		public function testGetByIDSubContainer():void
   		{   			
   			//assertEquals(btn2, ctrl.findByID("butt2", vbox));
   		}
   		
   		override public function setUp():void
   		{
   			ctrl = new SomeCtrl();
   			vbox = new VBox();
			btn = new Button();
			btn2 = new Button();
		
   			vbox.id = "test";
   			ctrl.addChild(vbox);
   			
   			btn.id = "butt1";
   			vbox.addChild(btn);
   			
   			btn2.id = "butt2";
			vbox.addChild(btn2);
   		}
	}
}