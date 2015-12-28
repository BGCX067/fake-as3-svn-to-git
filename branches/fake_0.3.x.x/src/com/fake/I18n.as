package com.fake
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
    /**
    * I18n
    * 
    * Internationalization and localization support.
    */
    public class I18n extends EventDispatcher
    {
    	[Bindable]
        static private var translations:Object;
        
        private static var _instance:I18n;
        
        private var charset: String;
        private var info:    Object;
        private var _language:String;
        private var _url:     String;

        private var xstream: URLStream;

        private var _domainStack:Array = new Array;
        
        public function I18n(){
        	if(_instance){
        		throw new Error("I18n is a singleton class, use I18n.instance instead");
        	}
        }

		/**
		 * Return the Singleton gettext instance
		 * 
		 * @return
		 */
		public static function get instance():I18n
		{
			if (_instance == null) {
				_instance = new I18n();
			}
			return _instance;
		}

        public final function set language(value:String):void
        {
        	_language = value;
        }
        
        public final function get language():String
        {
        	return _language;
        }
        
        public final function set url(value:String):void
        {
        	_url = value;
        }

        public final function get url():String
        {
        	return _url;
        }

        /**
         * Get language
         * 
         * @usage   gettext.getLocale();
         * @return  the current iso language
         */
        public function getLocale():String {
            return this.language;
        }

        /**
         * Request and install (via handleEvent) the specified translation
         * Load the corresponding .mo file located into {url}/{language}/LC_MESSAGES/{domain}.mo
         * 
         * @param	domain Domain of the translation (default)
         */
        public final function install(domain:String='default'):void
        {
            if (!this.url){
            	this.url = 'locale/';
            }
            
            _domainStack.push(domain);
            
			var req:URLRequest = new URLRequest(this.url + this.getLocale() + '/LC_MESSAGES/' + domain + '.mo');
            xstream = new URLStream();
            xstream.addEventListener(Event.COMPLETE,         this.handleEvent);
            xstream.addEventListener(Event.OPEN,             this.handleEvent);
            xstream.addEventListener(ProgressEvent.PROGRESS, this.handleEvent);
            xstream.addEventListener(HTTPStatusEvent.HTTP_STATUS,       this.handleEvent);
            xstream.addEventListener(IOErrorEvent.IO_ERROR,             this.handleEvent);
            xstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleEvent);
			xstream.load(req);
        }

        /**
         * Read and install tha translation
         * Manage the events returned by the xstream loader
         * 
         * @param   event
         */
        protected function handleEvent(event:Event):void
        {
            if(event.type == Event.COMPLETE)
            {
            	var domain:String = _domainStack.pop();
                var byte:ByteArray = new ByteArray();
                byte.endian = Endian.LITTLE_ENDIAN;
                event.target.readBytes(byte, 0, event.target.bytesAvailable)
                try
                {
                    var retObject:Object = GetTextParser.parse(byte);
                    if (!I18n.translations){
                    	I18n.translations = new Object; 
                    }
                    I18n.translations[domain] = retObject.translation;
                    this.info            = retObject.info;
                    this.charset         = retObject.charset;
                } catch(e:Error){
                    var errEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, true, false, "EOFError: " + e.message)
                    this.dispatchEvent(errEvent);
                    return;
                }
            }
            var evt:Event = new Event(event.type, true, true)
            this.dispatchEvent(evt);
        }

        /**
         * Try to translate a string into the current installed language
         * 
         * @usage
         * @param   id the string to be translated
         * @return  translated string, if found. Otherwise returns the passed argument
         */
        public static function translate(key:String,domain:String=null):String
        {
            try
            {
            	if(!domain)
            	{
	                if(I18n.translations['default'].hasOwnProperty(key))
	                {
	                    return I18n.translations['default'][key];
	                } else {
	                    throw new TypeError();
	                }
            	}
            	else
            	{
	                if(I18n.translations[domain].hasOwnProperty(key))
	                {
	                    return I18n.translations[domain][key];
	                } else {
	                    throw new TypeError();
	                }
            	}
            }
            catch(e:TypeError)
            {
            	return "__#"+key+"#__";
            }
            return "__#"+key+"#__";
        }

		/**
		 * Return the language definition if available
		 * 
		 * @param iso the language code in iso format
		 * @return Object An Object with following data (language, locale, charset)
		 */
        static public function findLanguageInfo(iso:String):Object
        {
        	return L10n.catalog(iso);
        }
    }
}