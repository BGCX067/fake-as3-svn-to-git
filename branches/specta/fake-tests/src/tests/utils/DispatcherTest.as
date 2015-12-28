/* SVN FILE: $Id: DispatcherTest.as 33 2008-03-20 07:36:59Z gwoo.cakephp $ */
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
 * @version			$Revision: 33 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-20 13:36:59 +0600 (Thu, 20 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.utils.Dispatcher;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class DispatcherTest extends TestCase
	{
		public function DispatcherTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			   			
   			return ts;
   		}

	}
}