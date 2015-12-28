/* SVN FILE: $Id: TestObject.as 242 2009-03-02 17:01:11Z gwoo.cakephp $ */
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
 * @subpackage		com.app.objects
 * @since			2008-03-06
 * @version			$Revision: 242 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-03-02 23:01:11 +0600 (Mon, 02 Mar 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.objects {
	import com.app.objects.TestInnerObject;
	public class TestObject {
		public var foo:TestInnerObject = null;
		public var testHiddenFail:Object = null;
		
		public function TestObject(value:int = 5) {
			this.foo = new TestInnerObject(value);
		}
		
		public function createHidden() : void{
			this.testHiddenFail = new HiddenTestClass();
		}
	}
}

class HiddenTestClass {
	public var nar:String = 'gah';
}