package com.DeComposer.controller.panels
{
	import com.DeComposer.view.panels.*;
	import com.degrafa.core.*;
	import com.degrafa.geometry.Circle;
	import com.degrafa.paint.*;
	import com.fake.controller.*;
	import com.fake.utils.*;
	import com.fake.utils.actions.*;
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.ComboBox;
	import mx.controls.HSlider;
	import mx.controls.TextInput;
	import mx.events.*;
	
	
	
	public class FillDesignerCtrl extends Canvas implements IController
	{
		[Bindable] public var cbFill:ComboBox;
		[Bindable] public var cbStroke:ComboBox;
		
		public var fillOne:LinearGradientFill;
		public var fillTwo:RadialGradientFill;
		
		public var strokeOne:RadialGradientStroke;
		public var strokeTwo:RadialGradientStroke;
		
		public var stopBox:VBox;
		
		public var txti_saveID:TextInput;
		
		public var cbFillAction:GroupAction;
		
		public function FillDesignerCtrl()
		{
			super();
			
			addEventListener(FlexEvent.INITIALIZE, init)
		}
 		
 		[Bindable] public var savePrompt:String = "enter name";
 		
 		[Bindable] public var blendModes:Array = ["add", "alpha", "darken", "difference", "erase", "hardlight", "invert", "layer", "lighten", "multiply", "normal", "overlay", "screen", "subtract"];
		
		[Bindable] public var actionCursor:FakeCursor;
		
		[Bindable] public var circle:Circle;
		
		[Bindable] public var angleSlider:HSlider;
		
		public function init(event:FlexEvent):void
		{
			objectMap.add(fillOne);
			objectMap.add(fillTwo);
			objectMap.add(strokeOne);
			objectMap.add(strokeTwo);
			
			objectMap.selectedFill = fillOne;
			
			cbFill.selectedIndex = 0;
			cbStroke.selectedIndex = 0;
			
			actionCursor = ActionDirector.actionCursor;
			
			PropertyChangeAction.eventHelper(angleSlider, SliderEvent.THUMB_PRESS, SliderEvent.THUMB_RELEASE, ["angle"], objectMap.selectedFill);
		
			for(var i:int = 0; i < 10; i++)
			{
				var newStopper:GradientStopItem = new GradientStopItem();
				
				newStopper.addEventListener("close",remove);
				
				newStopper.visible = false;
				newStopper.includeInLayout = false;
				
				stopBox.addChild(newStopper);
			}
			
			update();
		}
		
		public function cbFillDelegate(action:DelegateAction):void {
			update();
		}
		
		public function click():void
		{
			for(var i:int = 0; i < 10; i++)
			{
				var gsi:GradientStopItem = stopBox.getChildAt(i) as GradientStopItem; 
				
				if(gsi.visible == false)
				{
					GroupAction.start("uid",
					PropertyChangeAction.start("uid", ["visible"], gsi),
					PropertyChangeAction.start("uid", ["includeInLayout"], gsi),
					RemoveAction.start("uid", currentFill.gradientStopsCollection, gsi.gradientStop));
					
					gsi.visible = true;
					gsi.includeInLayout = true;
					currentFill.gradientStopsCollection.addItemAt(gsi.gradientStop,i);
					
					GroupAction.end();
					
					stopBox.invalidateDisplayList();
					
					return;
				}
			}
		}
		
		public function remove(event:Event):void
		{
			var gsi:GradientStopItem = event.currentTarget as GradientStopItem;
			
			GroupAction.start("uid",
			PropertyChangeAction.start("uid", ["visible"], gsi),
			PropertyChangeAction.start("uid", ["includeInLayout"], gsi),
			RemoveAction.start("uid", currentFill.gradientStopsCollection, gsi.gradientStop));
			
			gsi.visible = false;
			gsi.includeInLayout = false;
			currentFill.gradientStopsCollection.removeItem(gsi.gradientStop);
			
			GroupAction.end();
		}
		
		public function save():void
		{
			var newFill:Object = CloneUtil.clone(currentFill);
			
			newFill.id = txti_saveID.text;
			
			objectMap.add(newFill);
			
			var t:Array = objectMap.IGraphicsFill
		}
		
		public function update():void
		{
			objectMap.selectedFill = cbFill.selectedItem;
			
			for(var i:int = 0; i < currentFill.gradientStops.length; i++)
			{
				var stopper:GradientStopItem = stopBox.getChildAt(i) as GradientStopItem;
				
				stopper.gradientStop = currentFill.gradientStops[i] as GradientStop;
			}
			
			circle.fill = IGraphicsFill(currentFill);
		}
		
		public function get currentFill():GradientFillBase {
			return objectMap.selectedFill as GradientFillBase;
		}
		
		public function get currentStroke():GradientStrokeBase {
			return cbStroke.selectedItem as GradientStrokeBase;
		}
			
		
		public function get objectMap():ObjectMap {
			return ObjectMap.instance;
		}
		
		public function get ctrl():CtrlRegistry {
			return CtrlRegistry.instance;
		}
	}
}