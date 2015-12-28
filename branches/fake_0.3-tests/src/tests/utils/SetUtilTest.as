/* SVN FILE: $Id: SetUtilTest.as 133 2008-06-22 23:21:16Z gwoo.cakephp $ */
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
 * @version			$Revision: 133 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-06-23 06:21:16 +0700 (Mon, 23 Jun 2008) $
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
   			
   			return ts;
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