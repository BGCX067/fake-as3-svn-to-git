/* SVN FILE: $Id: SetUtilTest.as 319 2009-07-16 20:09:26Z gwoo.cakephp $ */
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
 * @version			$Revision: 319 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-07-17 03:09:26 +0700 (Fri, 17 Jul 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.utils.SetUtil;

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class SetUtilTest extends TestCase
	{
		public function SetUtilTest(methodName:String=null)
		{
			super(methodName);
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new SetUtilTest( "testMerge" ));
   			ts.addTest(new SetUtilTest( "testValues" ));

   			return ts;
   		}

   		public function testValues():void
   		{
   			var obj1:Object = {
   				key1: "value1",
   				key2: "value2",
   				key3: "value3"
   			};
   			var result:Array = SetUtil.values(obj1);

			assertEquals(3, result.length);

   			assertTrue(result.indexOf('value2') == 0);
   			assertTrue(result.indexOf('value3') == 1);
   			assertTrue(result.indexOf('value1') == 2);

   			var obj2:Object = { };
   			result = SetUtil.values(obj2);
   			assertEquals(0, result.length);
   		}

   		public function testMerge():void
   		{
   			var obj1:Object = {
   				key: "some key",
   				token: "some token"
   			};

   			var obj2:Object = {
   				other_key: "some other key",
   				other_token: "some other token"
   			};

   			var result:Object = SetUtil.merge(obj1, obj2);

   			assertEquals(result.key, obj1.key);
   			assertEquals(result.other_key, obj2.other_key);
   		}
	}
}