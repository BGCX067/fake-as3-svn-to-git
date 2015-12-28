/* SVN FILE: $Id: CloneUtil.as 93 2008-04-17 01:06:58Z xpointsh $ */
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
 * @version			$Revision: 93 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-04-17 08:06:58 +0700 (Thu, 17 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;

	/**
	* A helper utility class for cloning objects.
	**/
	public class CloneUtil
	{
		public static function clone(source:Object):*
		{
			var classPath:String = getQualifiedClassName(source).replace( "::", "." );
            var ClassRef:Class = getDefinitionByName(classPath) as Class;
			
			registerClassAlias( getQualifiedClassName(source), ClassRef );
			
		    var objectByteArray:ByteArray = new ByteArray();
		    objectByteArray.writeObject(source);
		    objectByteArray.position = 0;
		    
		    var output:Object = objectByteArray.readObject();
		    
		    return output;
		}
	}
}