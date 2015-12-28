/* SVN FILE: $Id: CloneUtilTest.as 242 2009-03-02 17:01:11Z gwoo.cakephp $ */
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
 * @subpackage		tests.utils
 * @since			2008-03-06
 * @version			$Revision: 242 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-03-02 23:01:11 +0600 (Mon, 02 Mar 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils {
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class CloneUtilTest extends TestCase {
		import com.fake.utils.CloneUtil;
		import com.app.objects.TestObject;
		
		public function CloneUtilTest(methodName:String=null) {
			super(methodName);
		}
		
		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new CloneUtilTest( "testClone" ));
   			ts.addTest(new CloneUtilTest( "testCloneWithHiddenClassDef" ));

   			return ts;
   		}
   		
   		public function testClone() : void {
   			var testObject:TestObject = new TestObject();
   			var clone:TestObject = CloneUtil.clone(testObject);
   			assertFalse(clone === testObject);
   			assertFalse(clone.foo === testObject.foo);
   			assertEquals(testObject.foo.testVar, clone.foo.testVar);
   		}
   	
   	/**
   	 * So this shows that you cannot use the clone method
   	 * to clone objects that have instances of classes
   	 * that you have defined in a private scope. All
   	 * classes involved must be public classes in a package.
   	 */
   		public function testCloneWithHiddenClassDef() : void {
   			var testObject:TestObject = new TestObject();
   			testObject.createHidden();
   			var clone:TestObject = CloneUtil.clone(testObject);
   			assertTrue(clone === testObject);
   			assertTrue(clone.foo === testObject.foo);
   			assertEquals(testObject.foo.testVar, clone.foo.testVar);
   		}
	}
}