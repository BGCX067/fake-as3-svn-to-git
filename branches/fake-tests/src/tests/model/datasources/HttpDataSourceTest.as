/* SVN FILE: $Id: HttpDataSourceTest.as 108 2008-05-02 23:40:16Z gwoo.cakephp $ */
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
 * @version			$Revision: 108 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-05-03 06:40:16 +0700 (Sat, 03 May 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model.datasources
{
	import com.fake.model.datasources.HttpDataSource;
	
	import flexunit.framework.TestSuite;
	
	import lib.FakeTestCase;

	public class HttpDataSourceTest extends FakeTestCase
	{
		public function HttpDataSourceTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new HttpDataSourceTest( "testConstructor" ));
   			
   			return ts;
   		}
   		
   		public function testConstructor():void {
   			var Http:HttpDataSource = new HttpDataSource({endpoint: "http://example.com"});
   			assertObjectEquals(Http.config, {endpoint: "http://example.com"});
   		}
	}
}