/* SVN FILE: $Id: LSOItem.as 223 2008-10-20 23:50:22Z xpointsh $ */
/**
 * Description
 *
 * Fake
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake
 * @subpackage		com.fake.utils
 * @since			2008-03-06
 * @version			$Revision: 223 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-10-21 06:50:22 +0700 (Tue, 21 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils.lso
{
	public class LSOItem
	{
		public var type:String;
		public var source:Object;
		
		public function LSOItem(type:String = "", source:Object = null)
		{
			this.type = type;
			this.source = source;
		}

	}
}