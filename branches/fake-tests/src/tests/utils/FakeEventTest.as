/* SVN FILE: $Id: FakeEventTest.as 21 2008-03-11 22:29:22Z gwoo.cakephp $ */
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
 * @version			$Revision: 21 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-12 04:29:22 +0600 (Wed, 12 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.utils.FakeEvent;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class FakeEventTest extends TestCase
	{
		public function FakeEventTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			
   			//NOT IMPLEMENTED YET
   			
   			return ts;
   		}
	}
}