/* SVN FILE: $Id: ResultSetTest.as 231 2009-01-13 15:21:51Z rafael.costa.santos $ */
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
 * @version			$Revision: 231 $
 * @modifiedby		$LastChangedBy: rafael.costa.santos $
 * @lastmodified	$Date: 2009-01-13 21:21:51 +0600 (Tue, 13 Jan 2009) $
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
	import com.fake.model.ResultSet;
	
	import flexunit.framework.TestSuite;
	
	import lib.FakeTestCase;

	public class ResultSetTest extends FakeTestCase
	{
		public function ResultSetTest(methodName:String=null)
		{
			super(methodName);
			var loader:SchemaLoader = new SchemaLoader();
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();


			ts.addTest(new ResultSetTest( "testRandom" ));
			ts.addTest(new ResultSetTest( "testBasic" ));
			ts.addTest(new ResultSetTest( "testString" ));
			ts.addTest(new ResultSetTest( "testComplex" ));
			ts.addTest(new ResultSetTest( "testStandardView" ));

			ts.addTest(new ResultSetTest( "testMultipleNestedResults" ));

   			return ts;
   		}

   		public function testRandom():void
   		{
			var publishedDate:Date = new Date( 2006, 2, 20 );
   			var book:Object = {
   				id: 1,
   				title: "My Book title",
			   	pageCount: 10,
			   	publishedDate: publishedDate,
			   	inLibrary: true
			};

			var message:String = "login successful";

			var session:Object = {id: 1, name: "Sean Chatman", email: "nutcase@gmail.com"};

			var resultSet:ResultSet = new ResultSet({Book: book, Message: message, Result: true, Session: session});

			assertEquals("My Book title",  resultSet.dataSet.current.Book.title);
			assertEquals("nutcase@gmail.com",  resultSet.data.Session.email);
			assertEquals("login successful",  resultSet.data.Message);
			assertEquals(true,  resultSet.data.Result);
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

			var resultSet:ResultSet = new ResultSet({
				Book: [
					{Book: book}, {Book: book}, {Book: book}
				]
			});

			var something:* = resultSet.dataSet;

			assertEquals("My Book title",  resultSet.dataSet.current.Book.title);
   		}

   		public function testString():void
   		{
			var message:String = "login successful";
			var resultSet:ResultSet = new ResultSet({Message: message});

			var something:* = resultSet.data;

			assertEquals("login successful",  resultSet.data.Message);
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

			var resultSet:ResultSet = new ResultSet({
				Book: [
					{Book: book}, {Book: book}, {Book: book}
				],
				Message: message
			});

			var something:* = resultSet.data;

			assertEquals("My Book title",  resultSet.dataSet.current.Book.title);
			assertEquals("login successful",  resultSet.data.Message);
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

			var resultSet:ResultSet = new ResultSet({
   				Post: {
   					Post: post, User: user, Detail: detail, Comment: [comment1, comment2, comment3]
   				}
   			});
			var something:* = resultSet.dataSet;
			
			assertEquals("first post",  resultSet.dataSet.Post.title);
			assertEquals("value of field 1", resultSet.dataSet.Post.Detail.field1);
			assertEquals("joe",  resultSet.dataSet.Post.User.username);
			assertEquals(1, resultSet.dataSet.current.Post.Comment.id);
   		}
   		
   		public function testStandardRecursiveView():void
   		{
   			
   		}
   		
   		public function testStandardEdit():void
   		{
   			
   		}
   		
   		public function testStandardIndex():void
   		{
   			
   		}

   		public function testStandardRecursiveIndex():void
   		{
   			
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

   			var resultSet:ResultSet = new ResultSet(serviceData);

			var something:* = resultSet;


			resultSet.moveFirst();
			var i:int = 0;

			while (resultSet.moveNext())
			{
				resultSet.Comment.moveFirst();
				var j:int = 0;

				while (resultSet.Comment.moveNext())
				{
					var exp:Object = serviceData.Post[i]["Comment"][j];
					var res:Object = resultSet.Comment;

					assertObjectEquals(exp, res);
					j++;
				}

				assertEquals(++i, resultSet.Post.id);
			}

			//testing Posts intead of Post

			var serviceDataTwo:Object = { Posts: [
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

   			var resultSetTwo:ResultSet = new ResultSet(serviceDataTwo);

			var somethingTwo:* = resultSet;


			resultSetTwo.moveFirst();
			var iTwo:int = 0;

			while (resultSetTwo.moveNext())
			{
				resultSetTwo.Comment.moveFirst();
				var jTwo:int = 0;

				while (resultSetTwo.Comment.moveNext())
				{
					var expTwo:Object = serviceDataTwo.Posts[iTwo]["Comment"][jTwo];
					var resTwo:Object = resultSetTwo.Comment;

					assertObjectEquals(exp, res);
					jTwo++;
				}

				assertEquals(++iTwo, resultSetTwo.Post.id);
			}
   		}
	}
}