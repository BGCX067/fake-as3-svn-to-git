/* SVN FILE: $Id: ConnectionManagerTest.as 191 2008-09-16 15:09:38Z gwoo.cakephp $ */
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
 * @subpackage		tests.model.datasources
 * @since			2008-03-06
 * @version			$Revision: 191 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-16 22:09:38 +0700 (Tue, 16 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model.datasources
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.model.datasources.DataSource;
	
	import flexunit.framework.TestSuite;
	
	import lib.FakeTestCase;

	public class ConnectionManagerTest extends FakeTestCase
	{
		public function ConnectionManagerTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new ConnectionManagerTest( "testGetDataSource" ));
   			
   			return ts;
   		}
   		
   		public function testGetDataSource():void {
   			var ds:DataSource = ConnectionManager.instance.getDataSource(null);
   			assertEquals(ds, null);
   		}
	}
}