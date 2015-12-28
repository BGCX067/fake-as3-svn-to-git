/* SVN FILE: $Id: Routes.as 35 2008-03-20 07:42:15Z gwoo.cakephp $ */
/**
 * Description
 *
 * Pretend
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			pretend
 * @subpackage		com.app
 * @since			2008-03-06
 * @version			$Revision: 35 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-20 13:42:15 +0600 (Thu, 20 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app
{
	import com.fake.utils.Router;
	
	public class Routes
	{
		public function Routes()
		{
			Router.instance.connect("Scaffold",[
					{name: "home", path: "/", listener: "list", options:{title: "Scaffold Index"}},
					{name: "Scaffold.list", options:{title: "Scaffold Index"}},
					{name: "Scaffold.add", path: "/scaffolds/add", listener: "submit", options:{title: "Scaffold Add"}},
					{name: "Scaffold.edit", path: "/scaffolds/edit/:id", listener: "submit", options:{title: "Scaffold Edit"}}
			]);
		}

	}
}