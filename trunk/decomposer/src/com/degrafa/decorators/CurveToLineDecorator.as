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
	import com.degrafa.decorators.*;

	import flash.display.Graphics;
	import flash.geom.Rectangle

	public class CurveToLineDecorator extends Decorator
	{
		public function CurveToLineDecorator()
		{
			super();
			types = [CommandStackItem.CURVE_TO];
		}

		override public function delegate(graphics:Graphics,rc:Rectangle,stack:CommandStack):void
		{
			var cursor:CommandCursor = new CommandCursor(stack.source);

			if(cursor.moveNextCommand(CommandStackItem.CURVE_TO))
   			{
   				cursor.current.type = CommandStackItem.LINE_TO;
   				cursor.current.x = cursor.current.x1;
   				cursor.current.y = cursor.current.y1;
   			}
		}
	}
}