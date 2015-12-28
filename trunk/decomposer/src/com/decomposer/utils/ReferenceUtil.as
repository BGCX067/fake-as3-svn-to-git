/* SVN FILE: $Id: ReferenceUtil.as 18 2008-09-10 16:34:34Z xpoint%playerb.net $ */
/**
 * Description
 *
 * DeComposer
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Commercial License
 * Redistributions of files prohibited
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @package			DeComposer
 * @subpackage		com.DeComposer.utils
 * @since			2008-03-06
 * @version			$Revision: 18 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-09-10 09:34:34 -0700 (Wed, 10 Sep 2008) $
 * @license			Commercial
 */
package com.DeComposer.utils
{
	import com.degrafa.GeometryComposition;
	import com.degrafa.geometry.*;
	import com.degrafa.paint.*;

	public class ReferenceUtil
	{
		public function ReferenceUtil()
		{
		}

		public static function bigSwitch(node:String):Class
		{
			switch(node)
			{
				case "AdvancedRectangle":
					return AdvancedRectangle;
				case "Circle":
					return Circle;
				case "Ellipse":
					return Ellipse;
				case "EllipticalArc":
					return EllipticalArc;
				case "HorizontalLine":
					return HorizontalLine;
				case "Path":
					return Path;
				case "Polygon":
					return Polygon;
				case "Polyline":
					return Polyline;
				case "RegularRectangle":
					return RegularRectangle;
				case "RoundedRectangle":
					return RoundedRectangle;
				case "RoundedRectangleComplex":
					return RoundedRectangleComplex;
				case "VerticalLine":
					return VerticalLine;
				case "SolidFill":
					return SolidFill;
				case "LinearGradientFill":
					return LinearGradientFill;
				case "GradientStop":
					return GradientStop;
				case "RadialGradientFill":
					return RadialGradientFill;
				case "SolidStroke":
					return SolidStroke;
				case "LinearGradientStroke":
					return LinearGradientStroke;
				case "RadialGradientStroke":
					return RadialGradientStroke;
				case "GeometryComposition":
					return GeometryComposition;
			}
			return null
		}
	}
}