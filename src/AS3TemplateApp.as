package
{
  import com.rhino.AS3TemplateApp.RootSprite;
  import com.rhino.assetPack.AssetPackClient;
  import com.rhino.net.WebServiceData;
  import com.rhino.util.Log;
  import com.rhino.util.RemoteLogger;
  import com.rhino.util.Util;
  
  import flash.desktop.NativeApplication;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display3D.Context3DProfile;
  import flash.events.Event;
  import flash.events.InvokeEvent;
  import flash.events.UncaughtErrorEvent;
  import flash.geom.Rectangle;
  
  import org.osflash.signals.Signal;
  
  import starling.core.Starling;
  
  // specify information for the SWF header of this ActionScript application
  [SWF(width="768",height="1024",backgroundColor="#000000",frameRate="60")] // note: frame rate should match TARGET_FRAME_RATE constant
  
  public class AS3TemplateApp extends Sprite
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mStarling:Starling;
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function AS3TemplateApp()
    {
      super();
      
      // setup a global uncaught error handler
      this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, AS3TemplateApp.uncaughtErrorHandler);
      
      // output app name, version, and purchase model
      Log.out(CONFIG::APP_LONG_NAME + ' ' + CONFIG::VERSION_LABEL);
      
      // display iOS device detail
      if(Util.isIos()) {
        var ipdinf:Object = Util.getIosDeviceInfo();
        Log.out('running on [' + ipdinf.dsc + '], group ID is [' + ipdinf.grp + ']');
      }
      
      // some NativeApplication objects/methods in Flash Player cause exceptions, so do conditional compile
      CONFIG::MOBILE {
        // setup native application handlers
        Log.out('Adobe AIR runtime: ' + NativeApplication.nativeApplication.runtimeVersion);
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,onInvoke);
        NativeApplication.nativeApplication.addEventListener(Event.SUSPEND,onSuspend);
        NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,onActivate);
        NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,onDeactivate);
        NativeApplication.nativeApplication.addEventListener(Event.EXITING,onExiting);
        NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE,onNetworkChange);
      }

      /**
       * Scaling strategy: "smart object placement"
       * App will adapt to any device resolution by placing UI objects aligned to screen edges.
       * Starling viewport will always match full screen resolution.
       * Starling stage size will always be a divisor of the Starling viewport.
       * Assets are available at high (HD) and standard (SD) resolutions, and are selected based on screen width.
       */
  
      // setup stage
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      // determine viewport dimensions (pixels)
      var vpt:Rectangle = new Rectangle();
      if(Util.isAndroid() || Util.isIos()) {    // mobile devices: use screen dimensions
        vpt.width = stage.fullScreenWidth;
        vpt.height = stage.fullScreenHeight;
      }
      else {                                    // desktop / other: use native Flash stage size
        vpt.width = stage.stageWidth;
        vpt.height = stage.stageHeight;
      }
      Log.out('viewport is ' + vpt.width + 'x' + vpt.height + ' pixels, aspect ratio is ' + (vpt.width/vpt.height));
      
      // determine Starling stage size (should always be the viewport divided by a whole-number factor, e.g. 1,2,3)
      // note: the ratio of screen size to stage size will determine which resolution assets are used
      var strstgwth:Number = vpt.width;         // Starling stage width
      var strstghgt:Number = vpt.height;        // Starling stage height
      if(vpt.width>=1600) { // if the viewport width is greater than this amount, use HD assets
        strstgwth /= 2.0;
        strstghgt /= 2.0;
      }
      
      // launch Starling framework
      Log.out('Starling framework: ' + Starling.VERSION);
      Log.out('Starling stage size is ' + strstgwth + 'x' + strstghgt);
      Starling.handleLostContext = !Util.isIos(); // not required on iOS
      // note: BASELINE profile should be safe to use: http://forum.starling-framework.org/topic/constrained-and-baseline-mode-what-devices-are-supported
      var c3dprf:String = Context3DProfile.BASELINE;
      Log.out('using Context3D profile [' + c3dprf + ']');
      mStarling = new Starling(RootSprite, stage, vpt, null, "auto", c3dprf);
      mStarling.stage.stageWidth = strstgwth;
      mStarling.stage.stageHeight = strstghgt;
      mStarling.antiAliasing = 1; // 1-16, 16 == highest level of anti-aliasing
      mStarling.start();
    }
    
    /**************************************************************************
     * INSTANCE METHODS
     **************************************************************************/

CONFIG::MOBILE {
    
    /**
     * Dispatched when an application is invoked.
     * Triggered on iOS on initial launch and when returning from a suspended state.  
     */
    protected function onInvoke(event:InvokeEvent):void
    {
      Log.out('app invoked');
      sAppInvokedSignal.dispatch();
    }
    
    /**
     * Dispatched when the application is about to be suspended by the operating system.
     * Note: AIR iOS only.
     */
    protected function onSuspend(event:Event):void
    {
      Log.out('app suspended');
      sAppSuspendedSignal.dispatch();
    }
    
    /**
     * Dispatched when this application becomes the active desktop application.
     * Triggered on iOS when returning to the app from the app switcher screen or when the app is returned to from a suspended state.  Not triggered on initial app launch.
     */
    protected function onActivate(event:Event):void
    {
      Log.out('app activated');
      sAppActivatedSignal.dispatch();
    }
    
    /**
     * Dispatched when the desktop focus is switched to a different application.
     * Triggered on iOS when entering the app switcher screen or when returning to the home screen.
     */
    protected function onDeactivate(event:Event):void
    {
      Log.out('app deactivated');
      sAppDeactivatedSignal.dispatch();
    }
    
    /**
     * Dispatched when the application exit sequence is started.
     */
    protected function onExiting(event:Event):void
    {
      Log.out('app exiting');
    }
    
    /**
     * Dispatched when either a new network connection becomes available or an existing network connection is lost.
     */
    protected function onNetworkChange(event:Event):void
    {
      Log.out('network connection change detected');
    }
    
} // end CONFIG::MOBILE
  
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/

    // signals
    public static var sAppInvokedSignal:Signal = new Signal();
    public static var sAppSuspendedSignal:Signal = new Signal();
    public static var sAppActivatedSignal:Signal = new Signal();
    public static var sAppDeactivatedSignal:Signal = new Signal();
    
    // web services
    private static const SERVICES_BASE_URL:String = "http://fraboom.com/something/web/services/";
    public static const WSD_ASSET_PACK_INFO:WebServiceData = new WebServiceData(SERVICES_BASE_URL, "asset-pack/asset-pack.php", "asset-pack web service");
    
    /**************************************************************************
     * STATIC METHODS - WEB SERVICE CLIENTS
     **************************************************************************/
    
    public static function createAssetPackClient():AssetPackClient {
      return new AssetPackClient(WSD_ASSET_PACK_INFO,CONFIG::APP_ID,CONFIG::BUILD_NUMBER);
    }
    
    /**************************************************************************
     * STATIC METHODS - REMOTE LOGGING
     **************************************************************************/
    
    /**
     * Globally handles uncaught AS3 Errors and attempts to send an error report to the remote logging server.
     */
    public static function uncaughtErrorHandler(event:UncaughtErrorEvent):void
    {
      event.stopImmediatePropagation();
      
      // create error reference ID
      var refid:String = RemoteLogger.generateRandomReferenceId(7);
      Log.out('**** uncaught error **** reference ID is ' + refid);
      Log.out(event.error);
      
      // TODO: LOG THIS ERROR REMOTELY AND HALT THE PROGRAM
      exitApp();
    }
    
    /**
     * Force-exits the app.
     */
    private static function exitApp():void
    {
      // exit app (only works on non-iOS platforms)
      NativeApplication.nativeApplication.exit();
    }

  }
}