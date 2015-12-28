/* SVN FILE: $Id: TestInnerObject.as 243 2009-03-02 18:48:11Z gwoo.cakephp $ */
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
 * @copyright       Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link            http://code.google.com/p/fake-as3/
 * @package         fake-tests
 * @subpackage      com.app.objects
 * @since           2008-03-06
 * @version         $Revision: 243 $
 * @modifiedby      $LastChangedBy: gwoo.cakephp $
 * @lastmodified    $Date: 2009-03-03 00:48:11 +0600 (Tue, 03 Mar 2009) $
 * @license         http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.objects {
    public class TestInnerObject {
        public var testVar:int;

        public function TestInnerObject(value:int = 5) {
            this.testVar = value;
        }
    }
}

