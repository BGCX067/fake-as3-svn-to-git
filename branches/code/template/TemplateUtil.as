package template
{
	import flash.utils.getQualifiedClassName;
	
	public class TemplateUtil
	{
		
		public function TemplateUtil()
		{
		}
		
		public static function findVars(source:String):Array
		{
			var matches:Array = [];
			
			var findReg:RegExp = /\${\w+}/g
			
			for each(var match:String in source.match(findReg))
			{
				if(matches.indexOf(match) == -1)
					matches.push(match);
			}
			
			return matches;
		}
		
		public static function getVarRegex(value:String):RegExp
		{
			return new RegExp("\\${" + value + "}");
		}
		
		public static function replaceRegex(source:String, replaceMatch:String, replaceWith:String):String
		{
			var regex:RegExp = getVarRegex(replaceMatch);
			
			while(source != source.replace(regex, replaceWith))
			{
				source = source.replace(regex, replaceWith)
			}
			
			return source;
		}
	}
}