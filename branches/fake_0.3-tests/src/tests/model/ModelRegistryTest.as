/* SVN FILE: $Id: ModelRegistryTest.as 191 2008-09-16 15:09:38Z gwoo.cakephp $ */
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
 * @subpackage		tests.model
 * @since			2008-03-06
 * @version			$Revision: 191 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-16 22:09:38 +0700 (Tue, 16 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model
{
	import com.app.model.Book;
	import com.app.model.User;
	import com.fake.model.ModelRegistry;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class ModelRegistryTest extends TestCase
	{
		public function ModelRegistryTest(methodName:String=null)
		{
			super(methodName);
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new ModelRegistryTest( "testFresh" ));
   			ts.addTest(new ModelRegistryTest( "testFetch" ));
   			ts.addTest(new ModelRegistryTest( "testUpdate" ));
   			ts.addTest(new ModelRegistryTest( "testRemove" ));

   			return ts;
   		}

   		public function testFresh():void {
   			var user:User = ModelRegistry.fresh('User');
   			assertFalse(user.id);

			var userTwo:User = ModelRegistry.fetch('User', {id: 1});
   			assertEquals(userTwo.id, 1);

			assertFalse(user.id);
   		}

   		public function testFetch():void {
   			var user:User = ModelRegistry.fetch('User', {id: 1});
   			assertEquals(user.id, 1);

   			var book:Book = ModelRegistry.fetch('Book', {title: "book title"});
   			assertEquals(book.title, "book title");

   			var userTwo:User = ModelRegistry.fetch('User');
   			assertEquals(userTwo.id, 1);

   		}

   		public function testUpdate():void {
   			var user:User = ModelRegistry.update('User', {id: 2});
   			assertEquals(user.id, 2);

   			var book:Book = ModelRegistry.update('Book', {title: "another book title"});
   			assertEquals(book.title, "another book title");

   			var userTwo:User = ModelRegistry.fetch('User');
   			assertEquals(userTwo.id, 2);

   		}

   		public function testRemove():void {
   			var user:User = ModelRegistry.fetch('User');
   			assertEquals(user.id, 2);

   			ModelRegistry.remove('User');

   			var userTwo:User = ModelRegistry.fetch('User')
   			assertFalse(userTwo.id);
   		}

	}
}