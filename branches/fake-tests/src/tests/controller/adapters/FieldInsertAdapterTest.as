/* SVN FILE: $Id: FieldInsertAdapterTest.as 333 2009-07-22 20:48:49Z gwoo.cakephp $ */
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
 * @subpackage		tests.controller.adapters
 * @since			2008-03-06
 * @version			$Revision: 333 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-07-23 03:48:49 +0700 (Thu, 23 Jul 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.controller.adapters
{	
	import com.app.controller.InsertCtrl;
	import com.app.controller.SomeCtrl;
	import com.fake.controller.adapters.FieldInsertAdapter;
	
	import flexunit.framework.TestSuite;
	
	import lib.FakeTestCase;
	
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	
	public class FieldInsertAdapterTest extends FakeTestCase
	{
		public var testAdapter:FieldInsertAdapter;
		
		public var ctrl:InsertCtrl;
		
		public function FieldInsertAdapterTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
			var ts:TestSuite = new TestSuite();
			
			ts.addTest(new FieldInsertAdapterTest( "testConstructor" ));
			ts.addTest(new FieldInsertAdapterTest( "testInsertFromObject" ));
			
			return ts;
		}
		
		override public function setUp():void
		{
			this.testAdapter = new FieldInsertAdapter();
			this.ctrl = new  InsertCtrl();
			
			this.ctrl.chk = new CheckBox();
			this.ctrl.chk.id = 'chk_ModelName_checkBox1';
			
			this.ctrl.num = new NumericStepper();
			this.ctrl.num.id = 'num_ModelName_numStep1';
			
			this.ctrl.txti = new TextInput();
			this.ctrl.txti.id = 'txti_ModelName_textInput1';
			
			this.ctrl.txta = new TextArea();
			this.ctrl.txta.id = 'txta_ModelName_textArea1';
			
			this.ctrl.cb = new ComboBox();
			this.ctrl.cb.id = 'cb_ModelName_comboBox1';
			this.ctrl.cb.dataProvider = new ArrayCollection([{ label: 'test1', data: 'id1' }, { label: 'test2', data: 'id2' }]);
			
			this.ctrl.cb2 = new ComboBox();
			this.ctrl.cb2.id = 'cb_ModelName_comboBox2';
			this.ctrl.cb2.dataProvider = new ArrayCollection(['id1', 'id2']);
			
			this.ctrl.radGroup = new RadioButtonGroup();
			
			this.ctrl.rad1 = new RadioButton();
			this.ctrl.rad1.groupName = "rad_ModelName_group1";
			this.ctrl.rad1.group = this.ctrl.radGroup;
			this.ctrl.rad1.value = 'value1';
			
			this.ctrl.rad2 = new RadioButton();
			this.ctrl.rad2.groupName = "rad_ModelName_group1";
			this.ctrl.rad2.group = this.ctrl.radGroup;
			this.ctrl.rad2.value = 'value2';
			
			this.ctrl.labelvar = new Label();
			this.ctrl.labelvar.text = "Not a field";
			super.setUp();
		}
		
		public function testConstructor():void 
		{
			assertTrue(this.testAdapter is FieldInsertAdapter);
		}
		
		public function testInsertFromObject():void
		{
			var data:Object = {
				'checkBox1': true,
				'numStep1': 15,
				'textInput1': 'Some New Test String',
				'textArea1': "A great text string that is larger than the txti string.",
				'comboBox1': 'id1',
				'comboBox2': 'id1'
			};
			
			this.testAdapter.insertFromObject(this.ctrl, data);
			
			assertTrue(this.ctrl.chk.selected);
			assertEquals(15, this.ctrl.num.value);
			assertEquals("Some New Test String", this.ctrl.txti.text);
			assertEquals("A great text string that is larger than the txti string.", this.ctrl.txta.text);
			assertEquals('test1', this.ctrl.cb.selectedLabel);
			assertEquals('id1', this.ctrl.cb2.selectedItem);
		}
	}
}