////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008 The Degrafa Team : http://www.Degrafa.com/team
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
////////////////////////////////////////////////////////////////////////////////
package com.degrafa.decorators
{
	import com.degrafa.geometry.command.*;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	public class CurveDecorator extends Decorator
	{
		public var cx:Number = 1.5;
		public var cy:Number = 1.5;
		
		public function CurveDecorator()
		{
			super();
			types = [CommandStackItem.CURVE_TO];
		}
		
		override public function delegate(graphics:Graphics,rc:Rectangle,stack:CommandStack):void
		{
			var cursor:CommandCursor = new CommandCursor(stack.source);
			cursor.currentIndex = stack.cursor.currentIndex;
			
			var cmd:CommandStackItem = cursor.nextCommand(CommandStackItem.CURVE_TO);
			
			cmd.cx *= cx;
			cmd.cy *= cy;
		}
	}
}