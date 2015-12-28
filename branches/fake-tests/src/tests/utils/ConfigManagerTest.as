/* SVN FILE: $Id: ConfigManagerTest.as 158 2008-09-04 23:22:23Z gwoo.cakephp $ */
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
 * @version			$Revision: 158 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-05 06:22:23 +0700 (Fri, 05 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.utils.ConfigManager;

	import flash.sampler.Sample;

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

   			ts.addTest(new ConfigManagerTest( "testPackages" ));

   			return ts;
   		}

		public function testPackages():void
		{
			ConfigManager.instance.packages = ['com.app', 'com.myapp'];

			var expected:Array = ['com.app', 'com.myapp'];
			var result:Array = ConfigManager.instance.packages;

			assertEquals(ConfigManager.instance.packages[0], expected[0]);
			assertEquals(ConfigManager.instance.packages[1], expected[1]);

			ConfigManager.instance.packages = 'com.another_app';

			var expectedTwo:Array = ['com.app', 'com.myapp', 'com.another_app'];

			assertEquals(ConfigManager.instance.packages[0], expectedTwo[0]);
			assertEquals(ConfigManager.instance.packages[1], expectedTwo[1]);
			assertEquals(ConfigManager.instance.packages[2], expectedTwo[2]);

		}
	}
}