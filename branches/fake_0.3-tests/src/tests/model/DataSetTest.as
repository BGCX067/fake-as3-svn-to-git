/* SVN FILE: $Id: DataSetTest.as 118 2008-05-07 21:12:50Z gwoo.cakephp $ */
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
 * @version			$Revision: 118 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-05-08 04:12:50 +0700 (Thu, 08 May 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model
{
	import com.app.model.Book;
	import com.app.model.Comment;
	import com.app.model.Detail;
	import com.app.model.Post;
	import com.app.model.SchemaLoader;
	import com.app.model.User;
	import com.fake.model.DataSet;
	import com.fake.model.ResultSet;

	import flexunit.framework.TestSuite;

	import lib.FakeTestCase;

	public class DataSetTest extends FakeTestCase
	{
		public function DataSetTest(methodName:String=null)
		{
			super(methodName);
			var loader:SchemaLoader = new SchemaLoader();
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

			ts.addTest(new DataSetTest( "testRandom" ));
			ts.addTest(new DataSetTest( "testBasic" ));
			ts.addTest(new DataSetTest( "testString" ));
			ts.addTest(new DataSetTest( "testComplex" ));
			ts.addTest(new DataSetTest( "testStandardView" ));
			ts.addTest(new DataSetTest( "testMultipleNestedResults" ));

   			return ts;
   		}

   		public function testRandom():void
   		{
			var publishedDate:Date = new Date( 2006, 2, 20 );
   			var book:Object = {
   				title: "My Book title",
			   	pageCount: 10,
			   	publishedDate: publishedDate,
			   	inLibrary: true,
			   	random: [0,{test:1},2,3]
			};

			var message:String = "login successful";

			var result:Boolean = true;

			var session:Object = {id: 1, name: "Sean Chatman", email: "nutcase@gmail.com"};

			var testResult:ResultSet = new ResultSet({Book: book, Message: message, Result: result, Session: session});
			var testDataSet:DataSet = testResult.dataSet;

			assertEquals("My Book title",  testDataSet.data.Book.title);
			assertEquals("nutcase@gmail.com",  testResult.data.Session.email);
			assertEquals("login successful",  testResult.data.Message);
   		}

   		public function testBasic():void
   		{
   			var publishedDate:Date = new Date( 2006, 2, 20 );
   			var book:Object = {
   				title: "My Book title",
				pageCount: 10,
				publishedDate: publishedDate,
				inLibrary: true,
				random: [0,{test:1},2,3]
			};

			var testResult:ResultSet = new ResultSet({
				Book: [
					{Book: book}, {Book: book}, {Book: book}
				]
			});
			var testDataSet:DataSet = testResult.dataSet;

			assertEquals("My Book title",  testDataSet.data.Book.title);
   		}

   		public function testString():void
   		{
			var message:String = "login successful";
			var testResult:ResultSet = new ResultSet({Message: message});
			assertEquals("login successful",  testResult.data.Message);
   		}

   		public function testComplex():void
   		{
   			var publishedDate:Date = new Date( 2006, 2, 20 );
   			var book:Object = { title: "My Book title",
								   pageCount: 10,
								   publishedDate: publishedDate,
								   inLibrary: true,
								   random: [0,{test:1},2,3] };

			var message:String = "login successful";

			var testResult:ResultSet = new ResultSet({
				Book: [
					{Book: book}, {Book: book}, {Book: book}
				],
				Message: message
			});

			var testDataSet:DataSet = testResult.dataSet;

			assertEquals("My Book title",  testDataSet.data.Book.title);
			assertEquals("login successful",  testResult.data.Message);
   		}

   		public function testStandardView():void
   		{
   			var post:Object = {
   				id: 1,
   				user_id: 2,
   				title: "first post",
   				body: "the first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var user:Object = {
   				id: 2,
   				username: "joe",
   				password: "password",
   				email: "jow@email.com",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var detail:Object = {
   				id: 1,
   				post_id: 1,
   				field1: "value of field 1",
   				field2: "value of field 2",
   				field3: "value of field 3",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment1:Object = {
   				id: 1,
   				user_id: 2,
   				post_id: 1,
   				body: "first comment on first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment2:Object = {
   				id: 2,
   				user_id: 2,
   				post_id: 1,
   				body: "second comment on first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment3:Object = {
   				id: 3,
   				user_id: 2,
   				post_id: 1,
   				body: "third comment on first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

			var testResult:ResultSet = new ResultSet({
   				Post: {
   					Post: post, User: user, Detail: detail, Comment: [comment1, comment2, comment3]
   				}
   			});

			var testDataSet:DataSet = testResult.dataSet;

			assertEquals("first post",  testDataSet.data.Post.title);
			assertEquals("value of field 1", testDataSet.data.Detail.field1);
			assertEquals("joe",  testDataSet.data.User.username);
			assertEquals(1, testDataSet.data.Comment.id);
   		}

   		public function testMultipleNestedResults():void
   		{
   			var post1:Object = {
   				id: 1,
   				user_id: 1,
   				title: "first post",
   				body: "the first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var post2:Object = {
   				id: 2,
   				user_id: 2,
   				title: "second post",
   				body: "the second post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var post3:Object = {
   				id: 3,
   				user_id: 3,
   				title: "third post",
   				body: "the third post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var user1:Object = {
   				id: 1,
   				username: "joe",
   				password: "password",
   				email: "joe@email.com",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var user2:Object = {
   				id: 2,
   				username: "bob",
   				password: "password",
   				email: "bob@email.com",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};
   			var user3:Object = {
   				id: 2,
   				username: "sean",
   				password: "password",
   				email: "sean@email.com",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment1:Object = {
   				id: 1,
   				user_id: 1,
   				post_id: 1,
   				body: "first comment on first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment2:Object = {
   				id: 2,
   				user_id: 1,
   				post_id: 1,
   				body: "second comment on first post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment3:Object = {
   				id: 3,
   				user_id: 2,
   				post_id: 2,
   				body: "first comment on second post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment4:Object = {
   				id: 4,
   				user_id: 2,
   				post_id: 2,
   				body: "second comment on second post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment5:Object = {
   				id: 5,
   				user_id: 3,
   				post_id: 3,
   				body: "first comment on third post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var comment6:Object = {
   				id: 6,
   				user_id: 3,
   				post_id: 3,
   				body: "second comment on third post",
   				modified: "2008-03-31 13:45:08",
   				created: "2008-03-31-13:45:08"
   			};

   			var serviceData:Object = { Post: [
   				{
   					Post: post1, User: user1, Comment: [comment1, comment2]
   				},
   				{
   					Post: post2, User: user2, Comment: [comment3, comment4]
   				},
   				{
   					Post: post3, User: user3, Comment: [comment5, comment6]
   				},

   			]};

   			var testResult:ResultSet = new ResultSet(serviceData);

			var testDataSet:DataSet = testResult.dataSet;

			testDataSet.moveFirst();
			var i:int = 0;

			while (testDataSet.moveNext())
			{
				assertEquals(++i, testDataSet.current.Post.id);
			}
   		}
	}
}