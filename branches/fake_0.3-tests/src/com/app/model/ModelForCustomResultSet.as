/* SVN FILE: $Id: ModelForCustomResultSet.as 267 2009-06-16 21:09:20Z gwoo.cakephp $ */
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
 * @subpackage		com.app.model
 * @since			2008-03-06
 * @version			$Revision: 267 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 04:09:20 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.fake.utils.FakeEvent;
	
	import mx.utils.UIDUtil;

	public class ModelForCustomResultSet extends ModelForResultSet
	{
		public function ModelForCustomResultSet()
		{
			super();
			_resultSet = 'CustomResultSet';
		}
	}
}