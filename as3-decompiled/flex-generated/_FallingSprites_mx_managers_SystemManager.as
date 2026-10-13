package
{
   import flash.display.LoaderInfo;
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.ISWFContext;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.RSLData;
   import mx.events.RSLEvent;
   import mx.managers.SystemManager;
   import mx.preloaders.SparkDownloadProgressBar;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class _FallingSprites_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory, ISWFContext
   {
      
      private var _info:Object;
      
      private var _preloadedRSLs:Dictionary;
      
      private var _allowDomainParameters:Vector.<Array>;
      
      private var _allowInsecureDomainParameters:Vector.<Array>;
      
      public function _FallingSprites_mx_managers_SystemManager()
      {
         super();
      }
      
      override public function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true) : *
      {
         if(param4)
         {
            return param1.apply(param2,param3);
         }
         param1.apply(param2,param3);
      }
      
      override public function create(... rest) : Object
      {
         if(rest.length > 0 && !(rest[0] is String))
         {
            return super.create.apply(this,rest);
         }
         var _loc2_:String = rest.length == 0 ? "FallingSprites" : String(rest[0]);
         var _loc3_:Class = Class(getDefinitionByName(_loc2_));
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = new _loc3_();
         if(_loc4_ is IFlexModule)
         {
            IFlexModule(_loc4_).moduleFactory = this;
         }
         return _loc4_;
      }
      
      override public function info() : Object
      {
         if(!this._info)
         {
            this._info = {
               "applicationComplete":"application1_applicationCompleteHandler(event)",
               "cdRsls":[[new RSLData("http://fpdownload.adobe.com/pub/swz/tlf/2.0.0.232/textLayout_2.0.0.232.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","8f903698240fe799f61eeda8595181137b996156bb176da70ad6f41645c64c74","SHA-256",true,true,"default"),new RSLData("textLayout_2.0.0.232.swz","","8f903698240fe799f61eeda8595181137b996156bb176da70ad6f41645c64c74","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/framework_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","9f67b1c289a5b5db7b32844af679e758541d101b46a7f75672258953804971ff","SHA-256",true,true,"default"),new RSLData("framework_4.5.0.20967.swz","","9f67b1c289a5b5db7b32844af679e758541d101b46a7f75672258953804971ff","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/spark_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","9a7dee2b537712bef484cbd9e4ddbf88c78f436ca378b2850e91bbcc343c137b","SHA-256"
               ,true,true,"default"),new RSLData("spark_4.5.0.20967.swz","","9a7dee2b537712bef484cbd9e4ddbf88c78f436ca378b2850e91bbcc343c137b","SHA-256",true,true,"default")]],
               "compiledLocales":["en_US"],
               "compiledResourceBundleNames":["collections","components","core","effects","layout","skins","styles"],
               "creationComplete":"application1_creationCompleteHandler(event)",
               "currentDomain":ApplicationDomain.currentDomain,
               "mainClassName":"FallingSprites",
               "mixins":["_FallingSprites_FlexInit","_FallingSprites_Styles"],
               "placeholderRsls":[[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/osmf_1.0.0.16316.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","b63185fca5d2bdbb568593f2bf232e87e5a20a7ea2ce2e26671d159838d598ed","SHA-256",true,true,"default"),new RSLData("osmf_1.0.0.16316.swz","","b63185fca5d2bdbb568593f2bf232e87e5a20a7ea2ce2e26671d159838d598ed","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/mx_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","76c30565f803f2587f156a8344e4091992d31b27cdcdf874e3420bb32cf6873a","SHA-256",true,true,"default"),new RSLData("mx_4.5.0.20967.swz","","76c30565f803f2587f156a8344e4091992d31b27cdcdf874e3420bb32cf6873a","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/rpc_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","d1680a46dd686b3b0cc9ec01d8c584666a78e145c5ca47537d5b7c82efcf97fd","SHA-256",true,true,"default")
               ,new RSLData("rpc_4.5.0.20967.swz","","d1680a46dd686b3b0cc9ec01d8c584666a78e145c5ca47537d5b7c82efcf97fd","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/charts_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","d937b2d0be0ba21728c3252d25a05059e9024b63e0e433bb964092f0e1cfd885","SHA-256",true,true,"default"),new RSLData("charts_4.5.0.20967.swz","","d937b2d0be0ba21728c3252d25a05059e9024b63e0e433bb964092f0e1cfd885","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/advancedgrids_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","8d1e5ee727e624dd1109d72d2244d54afee83137ccc60fc594969742fbb0a992","SHA-256",true,true,"default"),new RSLData("advancedgrids_4.5.0.20967.swz","","8d1e5ee727e624dd1109d72d2244d54afee83137ccc60fc594969742fbb0a992","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/sparkskins_4.5.0.20967.swz"
               ,"http://fpdownload.adobe.com/pub/swz/crossdomain.xml","49280e749d7318ea369bc7e61369c34ad2d228598ef893d04ef812c41fdd3eb0","SHA-256",true,true,"default"),new RSLData("sparkskins_4.5.0.20967.swz","","49280e749d7318ea369bc7e61369c34ad2d228598ef893d04ef812c41fdd3eb0","SHA-256",true,true,"default")],[new RSLData("http://fpdownload.adobe.com/pub/swz/flex/4.5.0.20967/spark_dmv_4.5.0.20967.swz","http://fpdownload.adobe.com/pub/swz/crossdomain.xml","8793ecf0639777b093d3dc134fc89715c6e432a31abf74899170b40a04eff451","SHA-256",true,true,"default"),new RSLData("spark_dmv_4.5.0.20967.swz","","8793ecf0639777b093d3dc134fc89715c6e432a31abf74899170b40a04eff451","SHA-256",true,true,"default")]],
               "preloader":SparkDownloadProgressBar
            };
         }
         return this._info;
      }
      
      override public function get preloadedRSLs() : Dictionary
      {
         if(this._preloadedRSLs == null)
         {
            this._preloadedRSLs = new Dictionary(true);
         }
         return this._preloadedRSLs;
      }
      
      override public function allowDomain(... rest) : void
      {
         var _loc2_:Object = null;
         Security.allowDomain.apply(null,rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(Boolean(_loc2_.content) && "allowDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowDomainInRSL"].apply(null,rest);
            }
         }
         if(!this._allowDomainParameters)
         {
            this._allowDomainParameters = new Vector.<Array>();
         }
         this._allowDomainParameters.push(rest);
         addEventListener(RSLEvent.RSL_ADD_PRELOADED,this.addPreloadedRSLHandler,false,50);
      }
      
      override public function allowInsecureDomain(... rest) : void
      {
         var _loc2_:Object = null;
         Security.allowInsecureDomain.apply(null,rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(Boolean(_loc2_.content) && "allowInsecureDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowInsecureDomainInRSL"].apply(null,rest);
            }
         }
         if(!this._allowInsecureDomainParameters)
         {
            this._allowInsecureDomainParameters = new Vector.<Array>();
         }
         this._allowInsecureDomainParameters.push(rest);
         addEventListener(RSLEvent.RSL_ADD_PRELOADED,this.addPreloadedRSLHandler,false,50);
      }
      
      private function addPreloadedRSLHandler(param1:RSLEvent) : void
      {
         var _loc3_:Array = null;
         var _loc2_:LoaderInfo = param1.loaderInfo;
         if(!_loc2_ || !_loc2_.content)
         {
            return;
         }
         if(allowDomainsInNewRSLs && Boolean(this._allowDomainParameters))
         {
            for each(_loc3_ in this._allowDomainParameters)
            {
               if("allowDomainInRSL" in _loc2_.content)
               {
                  _loc2_.content["allowDomainInRSL"].apply(null,_loc3_);
               }
            }
         }
         if(allowInsecureDomainsInNewRSLs && Boolean(this._allowInsecureDomainParameters))
         {
            for each(_loc3_ in this._allowInsecureDomainParameters)
            {
               if("allowInsecureDomainInRSL" in _loc2_.content)
               {
                  _loc2_.content["allowInsecureDomainInRSL"].apply(null,_loc3_);
               }
            }
         }
      }
   }
}

