package template
{
	public class GetSetTemplate
	{
		public function GetSetTemplate()
		{
		}
		
		public static var text:XML = <text>
<![CDATA[package sean.candace.test
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import mx.controls.Button;
	import mx.events.ResizeEvent;
	
	public class SeanChatman extends MovieClip
	{
		public var ${testThis}:Object;
		public var ${testThat}:MouseEvent;
		private var _${coolStuff}:Button;
		private var _coolStuffTwo:ResizeEvent;
		
		public function get ${coolStuff}():Button { return _${coolStuff}; }
		
		public function set ${coolStuff}(value:Button):void { _${coolStuff} = value; }
		
		public function get coolStuffTwo():ResizeEvent { return _coolStuffTwo; }
		
		public function set coolStuffTwo(value:ResizeEvent):void { _coolStuffTwo = value; }
		
	}
	
}
]]>
</text>
	}
}