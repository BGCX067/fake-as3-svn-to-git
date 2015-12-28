/* SVN FILE: $Id: CloneUtil.as 218 2008-10-06 13:26:37Z xpointsh $ */
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
 * @version			$Revision: 218 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-10-06 06:26:37 -0700 (Mon, 06 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import mx.core.IFactory;

	public class FakeFactory implements IFactory
	{
		public var properties:Object = null;
		public var generator:Class;
		public var useClone:Boolean = false;
		public var constructParams:Array = [];
		
		public var onCreation:Function = null;
		
		private var _template:Object = null;
		
		public function FakeFactory(generator:Class = null, ... params)
		{
			this.generator = generator;
			
			if(params)
				constructParams = params
			
			super();
		}
		
		public function newInstance():*
		{
			var instance:Object
			
			if(!useClone)
				instance = construct();
			else
				instance = CloneUtil.clone(template);
			 
			
			if(properties && !template && !useClone)
			{
				SetUtil.merge(instance, properties);
			}
			else if(template && !useClone)
			{
				SetUtil.merge(instance, template);
			}
			  
			if(onCreation != null)
				onCreation(instance);
			   
			return instance;
		}
		
		public function construct():*
		{
			var obj:Object;
			
			var params:Array = DescribeUtil.restFormat(constructParams);
			
			switch (params.length)
			{
				case 0: obj = new generator(); break;
				case 1: obj = new generator(params[0]); break;
				case 2: obj = new generator(params[0], params[1]); break;
				case 3: obj = new generator(params[0], params[1], params[2]); break;
				case 4: obj = new generator(params[0], params[1], params[2], params[3]); break;
				case 5: obj = new generator(params[0], params[1], params[2], params[3], params[4]); break;
				case 6: obj = new generator(params[0], params[1], params[2], params[3], params[4], params[5]); break;
				case 7: obj = new generator(params[0], params[1], params[2], params[3], params[4], params[5], params[6]); break;
				case 8: obj = new generator(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]); break;
				case 9: obj = new generator(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]); break;
				case 10: obj = new generator(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]); break;

				default: throw(new Error("up to 10 params supported"));	
			}
			
			return obj;
		}
		
		public function get template():Object {
			return _template;
		}
		
		public function set template(value:Object):void
		{
			generator = DescribeUtil.classReference(value);
			_template = value;
		}
	}
}