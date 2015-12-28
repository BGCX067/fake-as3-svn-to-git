package com.fake.utils
{
	import com.fake.model.Model;
	import com.fake.view.helper.Form;
	import com.fake.view.helper.IForm;
	
	import mx.collections.ArrayCollection;
	
	public class ModelUtil
	{
		public static function dataFieldToValue(dataField:String,data:*):String
		{
			if (data)
			{
				if ( !ModelUtil.isForeignKey(dataField) )
				{
	        		return ModelUtil.searchDepth(dataField,data);
				}
				else
				{
					return ModelUtil.getForeignKeyLabelFromModel(dataField,data);
				}
			}
			else
			{
				return null;
			}
		}

		//public static function searchDepth(data:*,depth:String):*
		public static function searchDepth(dataField:String,data:Object):*
		{
			var depthArray:Array = String(dataField).split('.');
			
			for each (var path:String in depthArray)
			{
				try {
					// System Vetify (report if path does not exist)
					if ( data[path] ){
						data = data[path];
					} else if ( data.hasOwnProperty(path) && data[path] is Boolean && data[path] == false ){
						// Specific for data[path] == Boolean with 'false' value
						data = data[path];
					} else if ( data.hasOwnProperty(path) && data[path] == 0 ){
						// Specific for data[path] == uint or Number with '0' value
						data = data[path];
					} else {
						return null;
					}
				} catch (error:Error) {
					return null;
				}
			}
			
			return data;
		}
		
		public static function getModelLabel(model:Object):String
		{
			if ( model.hasOwnProperty('labelField') )
			{
				return ModelUtil.searchDepth(model.labelField,model);
			}
			else if ( model.hasOwnProperty("name"))
			{
				return model["name"];
			}
			else if ( model.hasOwnProperty("title"))
			{
				return model["title"];
			}
			return null;
		}
		
		public static function isForeignKey(dataField:String):Boolean
		{
			if (dataField.substr(-3,3) == "_id"){
				return true;
			} else {
				return false;
			}
		}
		
		public static function getForeignKeyLabelFromModel(dataField:String,model:*):String
		{
			if (model)
			{
				var value:String;
				
				if ( model is Model )
				{
					var associationName:String;
					associationName = dataField.substr(0,dataField.length-3);
					associationName = Inflector.camelize(associationName);
					associationName = Inflector.ucfirst(associationName);
					
					if ( model[associationName] )
					{
						value = getModelLabel(model[associationName]);
					}
				}
				
				return value;
			}
			
			return null;
		}
		
		public static function getForeignKeyLabelFromLists(dataField:String, id:uint, lists:*):String
		{
			if (lists)
			{
				var associationName:String;
				associationName = dataField.substr(0,dataField.length-3);
				associationName = Inflector.camelize(associationName);
				associationName = Inflector.ucfirst(associationName);
				associationName = Inflector.pluralize(associationName);
				
				var list:Object = lists[associationName];
				
				if (list && list[id]){
					return list[id];
				}
			}
			
			return null;
		}
		
		public static function getForeignKeyLabel(dataField:String,id:uint,form:IForm):String
		{
			var label:String = getForeignKeyLabelFromModel(dataField,Form(form).model);
			
			if (label && label.length > 0){
				return label;
			} else {
				return getForeignKeyLabelFromLists(dataField,id,Form(form).data)
			}
		}
		
		public static function convertListToArrayCollection(list:Object):ArrayCollection
		{
			var array:ArrayCollection = new ArrayCollection;
			for (var key:* in list)
			{
				var listItem:Object = {label:list[key], id:key};
				array.addItem(listItem);
			}
			return array;
		}
		
		// Building association alias (For example: user_created_by_id => UserCreatedBies)
		public static function convertToListName(dataField:String):String
		{
			var parts:Array = dataField.split('.');
			var listName:String = parts[parts.length-1];
			
			// Extract "_id" (Ex: user_created_by)
			listName = listName.substr(0,listName.length-3);
			// Extract "_" and make the following char uppercase (Ex: userCreatedBy)
			listName = Inflector.camelize(listName);
			// Make the first char uppercase (Ex: UserCreatedBy)
			listName = Inflector.ucfirst(listName);
			// Get list of options
			listName = Inflector.pluralize(listName);// Pluralize the resulted string (Ex: UserCreatedBies)
			
			return listName;
		}
		
		public static function getList(dataField:String,data:Object):ArrayCollection
		{
			var listName:String = convertToListName(dataField);
			var list:Object = data[listName];
			
			return convertListToArrayCollection(list);
		}

	}
}