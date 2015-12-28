/* SVN FILE: $Id: Router.as 123 2008-05-12 22:49:14Z gwoo.cakephp $ */
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
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake
 * @subpackage		com.fake.utils
 * @since			2008-03-06
 * @version			$Revision: 123 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-05-13 05:49:14 +0700 (Tue, 13 May 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.events.Event;

	import mx.events.BrowserChangeEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.utils.ObjectUtil;

	public class Router
	{
		/**
		 *  Title for the application
		 */
		public var title:String = "Welcome ";

		/**
		 *  Base of the url for the application
		 */
		public var base:String = null;

		/**
		 * Holds an instance of the browser manager
		 */
		private var BM:IBrowserManager;

		/**
		 * Base config from Routes.as passed through connect
		 */
		private var __config:Object = {};

		/**
		 * translated and adapted routes to handle requests
		 */
		private var __routes:Array = [];

		/**
		 * current route object
		 */
		private var __current:Object;

		/**
		 * path separator used between controller, listener, and :named params
		 */
		private var __pathSeparator:String = "/";

		/**
		 * param separator for key:value params
		 */
		private var __paramSeparator:String = ":";

		/**
		 *
		 */
		private var __named:Object = {
			id: "[0-9]+", uuid: "[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}",
			year: "[12][0-9]{3}", month: "0[1-9]|1[012]", day: "0[1-9]|[12][0-9]|3[01]"
		};

	 	/**
	 	 * Singeleton instance
	 	 */
	 	private static const __instance:Router = new Router();

		/**
		 * Constructor
		 */
		public function Router()
		{
			BM = BrowserManager.getInstance();
			BM.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, onRequest);
		}

		/**
		 * Get instance of Router
		 * @return
		 */
		public static function get instance():Router
		{
			return __instance;
		}

		/**
		 * Start the Router, preinitialie seems to work well
		 * @param base
		 *
		 */
		public function start(options:Object = null):void
		{
			if (options && options.hasOwnProperty('title'))
			{
				this.title = options.title;
			}

			BM.init("", this.title);

			/* this will eventually alleviate the need for the #
			if (options && !options.hasOwnProperty('base'))
			{
				var base:String = URLUtil.getServerName(BM.url);
			}
			var pattern:RegExp = new RegExp("((?:http)://)("+base+")", "ig");
			var fragment:String = BM.url.replace(pattern, "");

			*/

			if(BM.fragment && BM.fragment != "" ){
				var route:Object = this.__match(BM.fragment);
				this.__dispatch(route);
			}
		}

		/**
		 * Called from the controller to add listeners based on the connected routes
		 * @param Controller
		 *
		 */
		public function init(ctrl:Object):void
		{
			if (__config[ctrl.className])
			{
				for each(var config:Object in __config[ctrl.className])
				{
					if (config.hasOwnProperty("name"))
					{
						if (config.name.indexOf(".") == -1)
						{
							config.name = ctrl.className + "." + config.name;
						}
						if (!config.hasOwnProperty("path"))
						{
							config.path = config.name.split(".").join("/");
						}
						if (!config.hasOwnProperty("listener"))
						{
							var configName:Array = config.name.split(".");
							config.listener = configName[1];
						}
					}

					if (ctrl.hasOwnProperty(config.listener))
					{
						config.controller = ctrl.className;

						if (config.hasOwnProperty("name") == false)
						{
							config.name = config.controller + '.' + config.listener;
						}

						var listener:Function = ctrl[config.listener];
						Dispatcher.addEventListener(config.name, listener);

						if (!config.hasOwnProperty("regex"))
						{
							config = this.__write(config);
						}

						__routes.push(config);
					}
				}
			}
		}

		/**
		 * Call a route from the controller by name, link or object
		 * @param name is the route.name, route.path or route object
		 *
		 */
		public function call(name:*, params:Object = null, options:Object = null):void
		{
			var request:Object = this.__build(name, params, options);
			this.__dispatch(request);
		}

		/**
		 * Connect the routes in Routes.as then add <app:Routes/> to the Application mxml
		 * @param ctrl
		 * @param config
		 *
		 */
		public function connect(ctrl:String, config:Object):void
		{
			__config[ctrl] = config;
		}

		/**
		 * Reset the router instance
		 *
		 */
		public function reset():void
		{
			__routes = [];
			__config = {};
			__current = {};
		}
		/**
		 * return the current route
		 *
		 */
		public function get current():Object
		{
			return __current;
		}

		/**
		 * return all the configured routes
		 *
		 */
		public function get routes():Array
		{
			return __routes;
		}
		/**
		 * Set the path separtor, default is "/"
		 * @param sep
		 *
		 */
		public function set pathSeparator(sep:String):void
		{
			__pathSeparator = sep;
		}

		/**
		 * Set the param separator, default is ":"
		 * @param sep
		 *
		 */
		public function set paramSeparator(sep:String):void
		{
			__paramSeparator = sep;
		}

		/**
		 * Takes a route object and dispatchs Controller.listener event with route params
		 * @param request
		 *
		 */
		private function __dispatch(request:Object):void
		{
			if (request is Object && request.hasOwnProperty("path") && ObjectUtil.compare(request, this.__current) != 0)
			{
				BM.setFragment(request.path);

				if (request.options.title)
				{
					BM.setTitle(this.title + request.options.title);
				}
				this.__current = request;
				Dispatcher.run(request.name, request.params);
			}
		}

		/**
		 * Listener for BrowserChangeEvent
		 * @param event
		 *
		 */
		private function onRequest(event:Event):void
		{
			if(BM.fragment && BM.fragment != "" ) {
				var request:Object = this.__match(BM.fragment);
				this.__dispatch(request);
			}
		}

		/**
		 * Match a given path to a route
		 * @param request
		 * @return
		 *
		 */
		private function __match(fragment:String):Object
		{
			for each(var route:Object in this.__routes)
			{
				var pattern:RegExp = new RegExp(route.regex, "gi");
				var result:Array = pattern.exec(fragment);
				if (result && result.length > 0)
				{
					var request:Object = CloneUtil.clone(route);
					request.path = result[0];
					result.shift();
					for (var i : Number = 0; i < request.params.length; ++i)
					{
						if (result && result[i])
						{
							request.params[request.params[i]] = result[i];
						}
					}
					return request;
					break;
				}
			}
			return null;
		}

		/**
		 * Turn a request by name, path or object into a path with the match params
		 * @param name is the route.name, route.path or route object
		 * @param params
		 * @return
		 *
		 */
		private function __build(name:*, params:Object, options:Object):Object
		{
			var route:Object;
			var request:Object;
			var pattern:RegExp;

			if (name is String)
			{
				if (name.indexOf(".") == -1)
				{
					for each(route in this.__routes)
					{
						pattern = new RegExp(route.regex, "gi");
						var result:Array = name.match(pattern);
						if (result.length > 0)
						{
							request = CloneUtil.clone(route);
							break;
						}
					}
				}
				else
				{
					for each(route in this.__routes)
					{
						if (name === route.name)
						{
							request = CloneUtil.clone(route);
							break;
						}
					}
				}
			}
			else if (request is Object)
			{
				for each(route in this.__routes)
				{
					if (route.controller === request.controller && route.listener == request.listener)
					{
						request = CloneUtil.clone(route);
						break;
					}
				}

			}

			if (request)
			{
				if (options)
				{
					request.options = options;
				}

				if (params)
				{
					for each (var param:* in request.params)
					{
						if(params.hasOwnProperty(param))
						{
							request.params[param] = params[param];
							request.path += params[param] + __pathSeparator;
						}
					}
				}
			}

			return request;
		}

		/**
		 * Write the config routes to regex and setup params
		 * @param routes
		 * @return
		 *
		 */
		private function __write(route:Object):Object
		{
			var path:String = "";
			var params:Array = [];
			var paramPattern:RegExp = /(?!\\\\):([a-z_0-9]+)/i;

			route.regex = "^";
			var parts:Object = route.path.split(__pathSeparator);
			for each (var part:String in parts)
			{
				if (part =="" || part == null)
				{
					path = "/";
					continue;
				}

				if (part.substr(0, 1) !== ":")
				{
					if (part === '*')
					{
						route.regex += "(?:/(.*))?";
						continue;
					}
					part = Inflector.underscore(part);
					route.regex += "/" + part;
					path += part + "/";
					continue;
				}
				else
				{
					var result:Array = part.match(paramPattern);

					if (result[1])
					{
						if (route.hasOwnProperty("params") && route.params.hasOwnProperty(result[1]))
						{
							route.regex += "(?:/("+route.params[result[1]]+"+))?";
						}
						else if (__named.hasOwnProperty(result[1]))
						{
							route.regex += "(?:/("+__named[result[1]]+"))?";
						}
						else
						{
							route.regex += "(?:/([^\/]+))?";
						}
						params.push(result[1]);
						continue;
					}
				}
			}
			route.regex += "[\\/]*$";
			route.params = params;
			route.path = path;
			return route;
		}
	}
}