/* SVN FILE: $Id: InflectorTest.as 275 2009-06-18 18:09:54Z gwoo.cakephp $ */
/**
 * Description
 *
 * Fake Tests
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Based on InflectTest for ASUnit
 * Copyright (c) 2008 Akeem Philbert
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
 * @version			$Revision: 275 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-19 01:09:54 +0700 (Fri, 19 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{

	import com.fake.utils.Inflector;

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class InflectorTest extends TestCase {

		public function InflectorTest(testMethod:String = null) {
			super(testMethod);
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new InflectorTest( "testPluralize" ));
   			ts.addTest(new InflectorTest( "testPluralizeeMutlipleTimes" ));
   			ts.addTest(new InflectorTest( "testSingularize" ));
   			ts.addTest(new InflectorTest( "testSingularizeMutlipleTimes" ));
   			ts.addTest(new InflectorTest( "testCamelize" ));
   			ts.addTest(new InflectorTest( "testUnderscore" ));
   			ts.addTest(new InflectorTest( "testHumanize" ));
   			ts.addTest(new InflectorTest( "testSlug" ));

   			return ts;
   		}

		public function testPluralize():void
		{
			assertEquals("quizzes",Inflector.pluralize("quiz"));

			assertEquals("statuses", Inflector.pluralize("status"));

			assertEquals("oxen", Inflector.pluralize("ox"));

			assertEquals("lice", Inflector.pluralize("louse"));

			assertEquals("matrices", Inflector.pluralize("matrix"));

			assertEquals("boxes", Inflector.pluralize("box"));

			assertEquals("hives", Inflector.pluralize("hive"));

			assertEquals("halves", Inflector.pluralize("half"));

			assertEquals("bases", Inflector.pluralize("basis"));

			assertEquals("consortia", Inflector.pluralize("consortium"));

			assertEquals("people", Inflector.pluralize("person"));

			assertEquals("men", Inflector.pluralize("man"));

			assertEquals("children", Inflector.pluralize("child"));

			assertEquals("potatoes", Inflector.pluralize("potato"));

			assertEquals("syllabi", Inflector.pluralize("syllabus"));

			assertEquals("buses", Inflector.pluralize("bus"));

			assertEquals("aliases", Inflector.pluralize("alias"));

			assertEquals("axes", Inflector.pluralize("axis"));

			assertEquals("batfish", Inflector.pluralize("batfish"));

			assertEquals("numina", Inflector.pluralize("numen"));

		}

		public function testPluralizeeMutlipleTimes():void
		{
			assertEquals(Inflector.pluralize("test"), Inflector.pluralize("test"));
		}

		public function testSingularize():void
		{
			assertEquals("quiz",Inflector.singularize("quizzes"));

			assertEquals("status", Inflector.singularize("statuses"));

			assertEquals("ox", Inflector.singularize("oxen"));

			assertEquals("louse", Inflector.singularize("lice"));

			assertEquals("matrix", Inflector.singularize("matrices"));

			assertEquals("box", Inflector.singularize("boxes"));

			assertEquals("hive", Inflector.singularize("hives"));

			assertEquals("half", Inflector.singularize("halves"));

			assertEquals("basis", Inflector.singularize("bases"));

			assertEquals("consortium", Inflector.singularize("consortia"));

			assertEquals("person", Inflector.singularize("people"));

			assertEquals("man", Inflector.singularize("men"));

			assertEquals("child", Inflector.singularize("children"));

			assertEquals("potato", Inflector.singularize("potatoes"));

			assertEquals("syllabus", Inflector.singularize("syllabi"));

			assertEquals("bus", Inflector.singularize("buses"));

			assertEquals("alias", Inflector.singularize("aliases"));

			assertEquals("axis", Inflector.singularize("axes"));

			assertEquals("batfish", Inflector.singularize("batfish"));

			assertEquals("numen", Inflector.singularize("numina"));

		}

		public function testSingularizeMutlipleTimes():void
		{
			assertEquals(Inflector.singularize("tests"), Inflector.singularize("tests"));
		}

		public function testCamelize():void
		{
			assertEquals("camelCase", Inflector.camelize("camel_case"));
		}

		public function testUnderscore():void
		{
			assertEquals("camel_case", Inflector.underscore("CamelCase"));
			assertEquals("camel_case_two", Inflector.underscore("CamelCaseTwo"));
			assertEquals("camel_case_three", Inflector.underscore("CamelCaseThree"));
		}

		public function testHumanize():void
		{
			assertEquals("Lower Case Underscore", Inflector.humanize("lower_case_underscore"));
		}

		public function testSlug():void
		{
			assertEquals("indoor_novice", Inflector.slug("Indoor (Novice)"));
			assertEquals("some_slug", Inflector.slug("some @#slug"));
		}
	}
}
