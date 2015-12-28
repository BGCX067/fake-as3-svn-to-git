/* SVN FILE: $Id: ResultSet.as 281 2009-06-21 15:32:22Z rafael.costa.santos $ */
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
 * @copyright           Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link                        http://code.google.com/p/fake-as3/
 * @package                     fake
 * @subpackage          com.fake.model
 * @since                       2008-03-06
 * @version                     $Revision: 281 $
 * @modifiedby          $LastChangedBy: rafael.costa.santos $
 * @lastmodified        $Date: 2009-06-21 22:32:22 +0700 (Sun, 21 Jun 2009) $
 * @license                     http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model
{
	import com.fake.FakeObject;
	import com.fake.utils.FakeCursor;
	import com.fake.utils.Inflector;

	public dynamic class ResultSet extends FakeObject
	{
		/**
		* Contains extra result objects not specifc to the dataSet
		*/
		public var data:Object = {};
		
		/**
		 * Contains extra result arrays not specifc to the dataSet
		 */
		public var list:Array = [];
		
		/**
		 * holds all the model objects
		 */
		public var dataSet:DataSet;
		
		/**
		 * private cursor
		 */
		private var __cursor:FakeCursor;
		
		public function ResultSet(source:Object)
		{
			if (source == null)
			{
				data = null;
			}
			else if (source is XML || source is String)
			{
				data = source;
			}
			else
			{
				format(source);
			}
		}

		/**
		 * This method goes through all of the results from the service call
		 * Uses reflection to determine what class that needs to be cast.
		 * results not belonging in the dataSet are placed in params
		 *
		 * @param source The objects that are taken from the service call
		 */
		public function format(source:Object):void
		{
			dataSet = new DataSet(_format(source));
		}

	    /**
	     * Recursive function to extract values from source object
	     * results not found in the dataSet are placed in data
	     * @param source
	     * 
	     * Specification (Considering the main behavior of CakePHP generated by bake)
	     * 
	     * => Cake index (recursive=0)
	     * 
	     * 		Data from Cake
	     * 
	     * 	[MainModelName/Plural] 					<= Array
	     * 		[0] 									<= Object
	     * 			[MainModelName/Singular] 				<= Object
	     * 				[field1] 								<= String, String Reference, Null, ???
	     * 				[field2]
	     * 			[RelatedModelName1/Singular]
	     * 				[fieldA]
	     * 				[fieldB]
	     * 
	     * 		Result Data for Flex
	     * 
	     *	[ResultSet]
	     * 		[dataSet] => DataSet
	     * 			[data] => Model (first item in list)
	     * 			[list] => FakeCursor
	     * 				[0] => Model (MainModelName)
	     * 					[field1]
	     * 					[field2]
	     * 					[RelatedModelName1] => Model vs DataSet
	     * 						[data] => Model
	     * 						[list] => empty FakeCursor
	     * 
	     * 		Access:
	     *
	     * 	resultSet.field1 <= field1 from first item on the list
	     * 	resultSet.RelatedModelName1.fieldA
	     * 	resultSet.dataSet.list
	     * 
	     * => Cake index (recursive=2)
	     * 
	     * 	[MainModelName/Plural]
	     * 		[0]
	     * 			[MainModelName]
	     * 				[field1]
	     * 				[field2]
	     * 			[RelatedModelName1]
	     * 				[field1]
	     * 				[field2]
	     * 				[RelatedModelNameA/Singular]
	     * 					[0]
	     * 						[field1]
	     * 						[field2]
	     * 				[RelatedModelNameB/Singular]
	     * 					[field1]
	     * 					[field2]
	     * 			[RelatedModelName2]
	     * 				[field1]
	     * 				[RelatedModelNameA/Singular]
	     * 					[0]
	     * 						[field1]
	     * 
	     * => Cake view (recursive=0)
	     * 
	     * 	[MainModelName/Singular]
	     * 		[MainModelName/Singular]
	     * 			[field1]
	     * 			[field2]
	     * 		[RelatedModelName1/Singular]
	     * 			[field1]
	     * 			[field2]
	     * 
	     * => Cake view (recursive=2) => Exemplo: clicar em uma Opportunity
	     * 
	     * 	[MainModelName/Singular]					<= Object
	     * 		[MainModelName/Singular]					<= Object
	     * 			[field1]									<= String, String Reference, Null, ???
	     * 			[field2]
	     * 		[RelatedModelName1/Singular]				<= Object
	     * 			[field1]									<= String, String Reference, Null, ???
	     * 			[field2]
	     * 			[RelatedModelNameA/Singular]				<= Array
	     * 				[0]											<= Object
	     * 					[field1]									<= String, String Reference, Null, ???
	     * 					[field2]
	     * 			[RelatedModelNameB/Singular]				<= Object
	     * 				[field1]									<= String, String Reference, Null, ???
	     * 				[field2]
	     * 		[RelatedModelName2/Singular]				<= Array				
	     * 			[0]
	     * 				[field1]
	     * 				[field2]
	     * 
	     * => Cake add (with id=null to get data from related models needed to fill comboboxes and lists)
	     * 
	     * 	[RelatedModelName1/Plural]	<= Object
	     * 		[id] => [value]				<= String
	     * 		[id] => [value]
	     * 	[RelatedModelName2/Plural]
	     * 		[id] => [value]
	     * 		[id] => [value]
 	     * 
	     * => Cake edit (with id=null to get data from related models needed to fill comboboxes and lists)
	     * 
	     * 	[RelatedModelName1/Plural]
	     * 		[id] => [value]
	     * 		[id] => [value]
	     * 	[RelatedModelName2/Plural]
	     * 		[id] => [value]
	     * 		[id] => [value]
	     * 
	     * => Cake edit (with a valid $id)
 	     * 
	     * => Alias: Cake with a table that has two different relations with the same table (ex: user_created_by, user_responsible_for)
	     *
	     */
		protected function _format(source:*, prevKey:* = null):*
		{
			var obj:Object = {};
			var array:Array = [];
			
			if ( !source ) return obj;
			
			if ( source is Array && source.length == 0 ) return array;
			
			for (var key:* in source)
			{
				// Data already loaded
				if (key == prevKey) continue;
				// Ignore data
				if (source[key] == null) continue;
				
				var model:Model;
				
				// Array item (return array)
				if (key is Number)
				{
					// [0]
					//		ModuleName
					//			id
					//			field2
					//		Relation (Array or Object)
					if ( source[key].hasOwnProperty(prevKey) )
					{
						model = getModel(prevKey,source[key][prevKey]); 
						
						if ( model )
						{
							// Get relations
							var relations:Object = _format(source[key],prevKey);
							for (var relationName:String in relations)
							{
								model.relations[relationName] = relations[relationName];
							}
							
							array.push(model);
						}
						else
						{
							if ( !data[prevKey] ){
								data[prevKey] = new Object;
							}
							data[prevKey][key] = source[key];
						}
					}
					// [0]
					//		id
					//		field2
					//		Relation (Array or Object)
					else if ( source[key].hasOwnProperty('id') )
					{
						model = getModel(prevKey,source[key]);
						 
						if ( model )
						{
							// Get relations
							//var relations:Object = _format(source[key],null);
							var relations:Object = _format(source[key],key);
							for (var relationName:String in relations)
							{
								model.relations[relationName] = relations[relationName];
							}
							
							array.push(model);
						}
						else
						{
							if ( !data[prevKey] ){
								data[prevKey] = new Object;
							}
							data[prevKey][key] = source[key];
						}
					}
					else
					{
						continue;
					}
					
				}
				// List of Records (return Object)
				else if (source[key] is Array) // IMPORTANT: Array is a type of Object
				{
					var newKey:String = Inflector.singularize(key);
					model = getModel(newKey,null);
					
					if ( model )
					{
						var arrayList:Array = _format(source[key],newKey);
						
						model.fill(arrayList);
						obj[newKey] = model;
					}
					else
					{
						// Consider prevKey ???
						data[key] = source[key];
					}
				}
				// One Main Record
				else if ( source[key] is Object )
				{
					// ModuleName
					//		ModuleName
					//			id
					//		Relation
					if ( source[key].hasOwnProperty(key) )
					{
						model = getModel(key,source[key][key]); 
						
						if ( model )
						{
							// Get relations
							var relations:Object = _format(source[key],key);
							for (var relationName:String in relations)
							{
								model.relations[relationName] = relations[relationName];
							}
							
							obj[key] = model;
						}
						else
						{
							// Consider prevKey ???
							data[key] = source[key];
						}
					}
					// ModuleName
					//		id
					//		Relation
					else if ( source[key].hasOwnProperty('id') )
					{
						model = getModel(key,source[key]); 
						
						if ( model )
						{
							// Get relations
							//var relations:Object = _format(source[key],null);
							var relations:Object = _format(source[key],key);
							for (var relationName:String in relations)
							{
								model.relations[relationName] = relations[relationName];
							}
							
							obj[key] = model;
						}
						else
						{
							// Consider prevKey ???
							data[key] = source[key];
						}
					}
					// List of options (for Combobox) or not known
					else
					{
						if ( !prevKey )
							data[key] = source[key]
						else
							continue; // Data already loaded (probably model data)
					}
				}
			}
			
			if (array.length > 0)
			{
			    return array;
			}
			return obj;
		}

		/*
		 * Try to find the model and consider possible Alias
		 */
		public function getModel(key:String, value:Object):Model
		{
			if (!key) return null; // System Verify
			
			var model:Model = Model.construct(key, value);
				
			// Try to find a respective model, considering possible Alias
			// Examples of Alias: UserResponsibleFor (model User), CompanyClient (model Company)
			if (!model){
				var pattern:RegExp = /[A-Z]{1}[a-z]+/g;
				var match:Array = key.match(pattern);
				
				// Extract each word of the Model relation name, starting from the last word
				// Ex: ContactResponsibleFor => ContactResponsible => Contact (found)
				var newKey:String = key;
				for (var i:uint = match.length-1 ; i > 0 ; i--)
				{
					// rip off the last word
					newKey = newKey.replace(match[i],'');
					
					model = Model.construct(newKey, value);
					
					if ( model ){
						break; // found
					}
				}
				
			} else {
				//modelName = key2;
			}
			
			if ( !model ){
				// System Verify
				trace('Warning:Could not find a respective Model or valid Alias for "'+key+'".');
			}
			
			return model;
		} 

		/**
		 * get a nice and tidy cursor
		 * @return
		 *
		 */
		public function get cursor():FakeCursor
		{
			if (!__cursor)
			{
				__cursor = new FakeCursor(list);
			}
			return __cursor;
		}

		/**
		 * handles magic properties
		 * @param name
		 * @return
		 *
		 */
		override protected function overloadGetProperty(name:*):*
		{
			if (dataSet && dataSet.current && dataSet.current.hasOwnProperty(name))
			{
				return dataSet.current[name];
			}
			else if (data && data.hasOwnProperty(name))
			{
				return data[name];
			}
			else if (cursor && cursor.hasOwnProperty(name))
			{
				return cursor[name];
			}
			return null;
		}

        /**
         * Handles magic methods on the list
         *
         * @param method
         * @param args
         */
		protected override function overload(method:*, arg:Array):*
		{
			if (dataSet.hasOwnProperty(method))
			{
				return dataSet[method].apply(method, arg);
			}
			else if (cursor.hasOwnProperty(method))
			{
				return cursor[method].apply(method, arg);
			}
			return null;
		}

	}
}
