/* SVN FILE: $Id: TestInnerObjectAfterConstruct.as 268 2009-06-16 22:17:36Z gwoo.cakephp $ */
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
 * @version			$Revision: 268 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 05:17:36 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.objects {
	
	import com.app.objects.TestInnerObject;
	
	public class TestInnerObjectAfterConstruct {
		public var foo:TestInnerObject = null;
		public var testHiddenFail:Object = null;
		public var extraInternalVar:TestInnerObject = null;
		
		public function TestInnerObjectAfterConstruct(value:int = 5) {
			this.foo = new TestInnerObject(value);
		}
		
		public function addExtraObject(value:int = 10):void {
			this.extraInternalVar = new TestInnerObject(value);
		}
		
		public function createHidden() : void{
			this.testHiddenFail = new HiddenTestClass();
		}
	}
}

class HiddenTestClass {
	public var nar:String = 'gah';
}