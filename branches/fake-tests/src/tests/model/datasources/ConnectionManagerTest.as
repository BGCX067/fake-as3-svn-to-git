/* SVN FILE: $Id: ConnectionManagerTest.as 261 2009-06-16 16:37:50Z gwoo.cakephp $ */
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
 * @version			$Revision: 261 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-16 23:37:50 +0700 (Tue, 16 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model.datasources
{
	import com.app.model.datasources.CustomDataSource;
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

   			ts.addTest(new ConnectionManagerTest( "testGetDefaultDataSource"  ));
   			ts.addTest(new ConnectionManagerTest( "testGetAmfDataSource"  ));
   			ts.addTest(new ConnectionManagerTest( "testGetHttpDataSource"  ));
			ts.addTest(new ConnectionManagerTest( "testGetCustomDataSource"  ));
			
   			return ts;
   		}

   		public function testGetDefaultDataSource():void {
   			var ds:DataSource = ConnectionManager.instance.getDataSource();
   			assertEquals(ds, null);

   			ConnectionManager.instance.create('default', {endpoint: "http://faker.localhost", datasource: "Amf"});

   			var ds2:DataSource = ConnectionManager.instance.getDataSource();
   			assertEquals(ds2 is Class(com.fake.model.datasources.AmfDataSource), true);
   		}

   		public function testGetAmfDataSource():void {

   			ConnectionManager.instance.create('amf', {endpoint: "http://faker.localhost", datasource: "Amf"});

   			var ds:DataSource = ConnectionManager.instance.getDataSource('amf');
   			assertEquals(ds is Class(com.fake.model.datasources.AmfDataSource), true);
   		}

   		public function testGetHttpDataSource():void {

   			ConnectionManager.instance.create('http', {endpoint: "http://faker.localhost", datasource: "Http"});

   			var ds:DataSource = ConnectionManager.instance.getDataSource('http');
   			assertEquals(ds is Class(com.fake.model.datasources.HttpDataSource), true);
   		}
   		
   		public function testGetCustomDataSource():void {

   			ConnectionManager.instance.create('custom', {endpoint: "http://faker.localhost", datasource: "Custom"});

   			var ds:DataSource = ConnectionManager.instance.getDataSource('custom');
   			assertEquals(ds is Class(com.app.model.datasources.CustomDataSource), true);
   		}
	}
}