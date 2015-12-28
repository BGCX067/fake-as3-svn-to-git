/* SVN FILE: $Id: ConfigManagerTest.as 231 2009-01-13 15:21:51Z rafael.costa.santos $ */
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
 * @version			$Revision: 231 $
 * @modifiedby		$LastChangedBy: rafael.costa.santos $
 * @lastmodified	$Date: 2009-01-13 21:21:51 +0600 (Tue, 13 Jan 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.utils.ConfigManager;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class ConfigManagerTest extends TestCase
	{
		public function ConfigManagerTest(methodName:String=null)
		{
			super(methodName);
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new ConfigManagerTest( "testPackagesApp" ));
   			ts.addTest(new ConfigManagerTest( "testPackagesEmpty" ));
   			ts.addTest(new ConfigManagerTest( "testPackagesString" ));
   			ts.addTest(new ConfigManagerTest( "testPackagesArray" ));

   			return ts;
   		}
   		
		public function testPackagesApp():void
		{
			ConfigManager.instance.app = 'myapp';
			
			var expected:Array = ['com.myapp'];
			var result:Array = ConfigManager.instance.packages;
			
			assertEquals(expected[0], result[0]);
			assertEquals(1, result.length);
			
			/*
			// Adding an extra package
			ConfigManager.instance.packages = ['com.app'];
			
			var expected:Array = ['com.myapp','com.app'];
			var result:Array = ConfigManager.instance.packages;
			
			assertEquals(expected[0], result[0]);
			assertEquals(expected[1], result[1]);
			assertEquals(2, result.length);
			
			// Setting a package that was already included
			ConfigManager.instance.packages = ['com.app'];
			
			var expected:Array = ['com.myapp','com.app'];
			var result:Array = ConfigManager.instance.packages;
			
			assertEquals(expected[0], result[0]);
			assertEquals(expected[1], result[1]);
			assertEquals(2, result.length);
			*/
		}

		public function testPackagesEmpty():void
		{
			ConfigManager.instance.app = '';
			
			var expected:Array = ['com.app'];
			var result:Array = ConfigManager.instance.packages;
			
			assertEquals(expected[0], result[0]);
			assertEquals(1, result.length);
		}

		public function testPackagesString():void
		{
			ConfigManager.instance.packages = 'com.myapp';
			
			var expected:String = 'com.myapp';
			var result:Array = ConfigManager.instance.packages;
			
			assertEquals(expected, result[0]);
			assertEquals(1, result.length);
		}

		public function testPackagesArray():void
		{
			ConfigManager.instance.packages = ['com.app', 'com.myapp'];

			var expected:Array = ['com.app', 'com.myapp'];
			var result:Array = ConfigManager.instance.packages;

			assertEquals(ConfigManager.instance.packages[0], expected[0]);
			assertEquals(ConfigManager.instance.packages[1], expected[1]);
			assertEquals(result.length, 2);

			ConfigManager.instance.packages = 'com.another_app';

			var expectedTwo:Array = ['com.app', 'com.myapp', 'com.another_app'];

			assertEquals(ConfigManager.instance.packages[0], expectedTwo[0]);
			assertEquals(ConfigManager.instance.packages[1], expectedTwo[1]);
			assertEquals(ConfigManager.instance.packages[2], expectedTwo[2]);
			assertEquals(result.length, 3);
		}
	}
}