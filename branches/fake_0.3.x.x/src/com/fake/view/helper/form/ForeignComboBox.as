package com.fake.view.helper.form
{
	import com.fake.I18n;
	import com.fake.utils.Inflector;
	import com.fake.utils.ModelUtil;
	import com.fake.view.helper.Form;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;
	
	public class ForeignComboBox extends ComboBox implements IField
	{
		include "AbstractField.as";
			
		public function ForeignComboBox()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function load():void
		{
			var value:String = ModelUtil.searchDepth(dataField,Form(form).model);
			
			if (!value && defaultValue) value = defaultValue;
			// Building association alias (For example: user_created_by_id => UserCreatedBies)
			var assocName:String;
			// Extract "_id" (Ex: user_created_by)
			assocName = dataField.substr(0,dataField.length-3);
			// Extract "_" and make the following char uppercase (Ex: userCreatedBy)
			assocName = Inflector.camelize(assocName);
			// Make the first char uppercase (Ex: UserCreatedBy)
			assocName = Inflector.ucfirst(assocName);
			// Get list of options
			assocName = Inflector.pluralize(assocName);// Pluralize the resulted string (Ex: UserCreatedBies)
			//var list:Object = formData[assocName];
			var list:Object = Form(form).data[assocName];
			
			// Create list of items for combobox
			var listItems:ArrayCollection = new ArrayCollection;
			var previousSelectedItem:Object;
			for (var key:* in list)
			{
				var item:Object = {label:list[key], id:key};
				listItems.addItem(item);
				
				// Identify pre-selected value (or default value)
				if (value && (value == key)){
					previousSelectedItem = item; 
				}
				
				/* TRADUCAO DOS TEXTOS DA COMBOBOX
				var listItem:Object;
				if ( fieldOptions.hasOwnProperty('translate') && fieldOptions.translate ){
					listItem = {label:Localizator.__(dataAssocList[key]), id:key};
				} else {
					listItem = {label:dataAssocList[key], id:key};
				}
				listItems.addItem(listItem);
				*/
			}
			
			/* POSSIBILIDADE DE ORDENACAO
			var sort:Sort = new Sort();
			// Define which type of sort the system will apply to the list
			if ( fieldOptions.hasOwnProperty('descending') ) {
				sort.fields = [new SortField("label",true,fieldOptions.descending)];
			} else {
				// Ascending Sort (This is the default sort method in SortField)
				sort.fields = [new SortField("label",true)];
			}
			// Assign the Sort object to the view.
			listItems.sort = sort;
			// Apply the sort to the collection.
			listItems.refresh();
			listItems.sort = null;
			*/
			
			//if ( !fieldOptions.hasOwnProperty('required') || !fieldOptions.required )
			//{
				// Add empty item 'select' in the first position after sorting
				// IMPORTANT: We are not using prompt property, because it disappears in edit mode,
				// disabling the possibility to unselect. Adding an extra empty item is how this is
				// done in CakePHP also.
				var emptyItem:Object = {label:I18n.translate('selectItem'), id:''};
				listItems.addItemAt(emptyItem,0);
			//}
			
			dataProvider = listItems;
			
			if (previousSelectedItem){
				selectedItem = previousSelectedItem;
			}
		}		
		
		public function capture():*
		{
			if (selectedItem) {
				return selectedItem.id;
			} else {
				return null;
			}
		}
		
		public function reset():void
		{
			selectedIndex = 0;
		}
		
		public function validate():String
		{
			if (required && !selectedItem){
				return I18n.translate('fieldRequired');
			}
			
			return null;
		}
	}
}