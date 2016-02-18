package com.rhino.AS3TemplateApp.assets
{
  import com.rhino.assetPack.AssetPackClient;
  import com.rhino.util.Log;

  import flash.display.BitmapData;
  import flash.display.DisplayObjectContainer;
  import flash.display.Loader;
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.UncaughtErrorEvent;
  import flash.media.SoundTransform;
  import flash.net.URLRequest;
  import flash.system.ApplicationDomain;
  import flash.system.LoaderContext;
  import flash.utils.Dictionary;

  import starling.core.Starling;
  import starling.textures.Texture;
  import starling.textures.TextureAtlas;

  public class Assets
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mUnscaledManager:CustomAssetManager = null;           // AssetManager for single resolution assets
    private var mScaledManager:CustomAssetManager = null;             // AssetManager for multi-resolution assets
    private var mAppDirectories:AssetDirectories;                     // defines app-bundled asset directories
    private var mCoreDirectories:AssetDirectories;                    // defines core downloaded asset directories
    private var mLoadedSecondarySwfs:Dictionary = new Dictionary();   // all loaded secondary SWFs, keyed by path
    private var mMasterVolume:Number;

    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR (SINGLETON)
     **************************************************************************/
    
    public function Assets()
    {
      // singleton pattern
      if(sInstance) { throw new Error("Singleton... use instance()"); } 
      sInstance = this;
      
      // init
      mMasterVolume = 1.0;
      
      // reset Asset Managers
      resetAssetManagers();
      Log.out('using ' + mScaledManager.scaleFactor + 'X scaled assets');
      
      // init app-bundled asset directories
      mAppDirectories = new AssetDirectories('assets/');
      mAppDirectories.logSummary('app bundled');
      
      // init core and brand asset directories
      var astpckclt:AssetPackClient = AS3TemplateApp.createAssetPackClient();
      astpckclt.getLocalAssetPack(Assets.API_CORE,function(url:String):void {
        mCoreDirectories = new AssetDirectories(url);
        mCoreDirectories.logSummary(Assets.API_CORE);
      });
    }

    /**************************************************************************
     * INSTANCE METHODS - ACCESSORS
     **************************************************************************/
    
    public function get appDirectories():AssetDirectories { return mAppDirectories; }
    public function get coreDirectories():AssetDirectories { return mCoreDirectories; }

    /**************************************************************************
     * INSTANCE METHODS - ASSET PACK SUBDIRS
     **************************************************************************/
    
    /**
     * @return an object with core asset pack selected subdirs.
     */
    public function coreAssetPackSubdirs():Object {
      var imgfmt:AssetImageFormat = new AssetImageFormat();
      return { spritesheets:[imgfmt.spritesheetDirectory,"xml","png-exclusive"] };
    }
    
    /**************************************************************************
     * INSTANCE METHODS - ASSET DEFINITIONS
     **************************************************************************/

    // asset definition example
/*
    public function getWelcomeAssets():Vector.<AssetItem>
    {
      var astcvt:Vector.<AssetItem> = new <AssetItem>[
        new AssetItem( AssetItem.TYP_SPRITESHEET_SCALED,    'welcomeItems0-{scale}'                   , '.png'  , mCoreDirectories),
        new AssetItem( AssetItem.TYP_SPRITESHEET_SCALED,    'welcomeItems1-{scale}'                   , '.png'  , mCoreDirectories),
        new AssetItem( AssetItem.TYP_SPRITESHEET_SCALED,    'subscriptions0-{scale}'                  , '.png'  , mCoreDirectories),
        new AssetItem( AssetItem.TYP_SPRITESHEET_SCALED,    'allFishSwim{scale}'                      , null    , mCoreDirectories),
        new AssetItem( AssetItem.TYP_SOUND,                 SoundId.SELECT                            , null    , mCoreDirectories),
        new AssetItem( AssetItem.TYP_SOUND,                 SoundId.EXIT                              , null    , mCoreDirectories),
      ];
      return astcvt;
    }
*/

    /**************************************************************************
     * INSTANCE METHODS - ASSET LOAD / DISPOSE
     **************************************************************************/

    public function resetAssetManagers():void
    {
      // setup scaled manager
      if(mScaledManager) { mScaledManager.dispose(); }
      mScaledManager = new CustomAssetManager();
      mScaledManager.verbose = false;
      mScaledManager.useMipMaps = false;
      var sclfct:int = Starling.contentScaleFactor;                 // get current Starling content scale factor as integer
      if(sclfct!=1 && sclfct!=2) { sclfct=1; }                      // must be integer: 1 or 2
      mScaledManager.scaleFactor = sclfct;                          // assign scale factor to scaled asset manager
      
      // setup unscaled manager
      if(mUnscaledManager) { mUnscaledManager.dispose(); }
      mUnscaledManager = new CustomAssetManager();
      mUnscaledManager.verbose = false;
      mUnscaledManager.useMipMaps = false;
      
      Log.out('reset asset managers');
    }
    
    public function enqueueAssets(assetItems:Vector.<AssetItem>, directories:AssetDirectories=null):void
    {
      var sclfct:int = mScaledManager.scaleFactor;                  // scale factor as an int
      var sprimgdir:String;                                         // spritesheet image directory
      
      // enqueue each asset item
      for each(var itm:AssetItem in assetItems)
      {
        // select directories used to find this item
        var itmdrs:AssetDirectories = itm.directories || directories || mAppDirectories;
        
        // replace {scale} token in item name with actual scale factor integer
        var itmnam:String = itm.name.replace(new RegExp('{scale}','g'),sclfct);
        
        switch(itm.type) {
          case AssetItem.TYP_SPRITESHEET_SCALED: {
            sprimgdir = (itm.extension == '.png') ? itmdrs.spritesheetImagePngExclusiveDir : itmdrs.spritesheetImageDir;
            mScaledManager.enqueue(sprimgdir + itmnam + (itm.extension || itmdrs.spritesheetImageExt));
            mScaledManager.enqueue(itmdrs.spritesheetXmlDir + itmnam + '.xml');
          } break;
          case AssetItem.TYP_SPRITESHEET_UNSCALED: {
            sprimgdir = (itm.extension == '.png') ? itmdrs.spritesheetImagePngExclusiveDir : itmdrs.spritesheetImageDir;
            mUnscaledManager.enqueue(sprimgdir + itmnam + (itm.extension || itmdrs.spritesheetImageExt));
            mUnscaledManager.enqueue(itmdrs.spritesheetXmlDir + itmnam + '.xml');
          } break;
          case AssetItem.TYP_IMAGE_SCALED: {
            mScaledManager.enqueue(itmdrs.imagesDir + itmnam + (itm.extension || ''));
          } break;
          case AssetItem.TYP_IMAGE_UNSCALED: {
            mUnscaledManager.enqueue(itmdrs.imagesDir + itmnam + (itm.extension || '.png'));
          } break;
          case AssetItem.TYP_SOUND: {
            mUnscaledManager.enqueue(itmdrs.soundsDir + itmnam + (itm.extension || '.mp3'));
          } break;
          case AssetItem.TYP_OTHER: {
            mUnscaledManager.enqueue(itmdrs.baseDir + itmnam + (itm.extension || ''));
          } break;
          default: {
            // do nothing with unknown asset types
          }
        }
      }
    }
    
    public function loadEnqueuedAssets(onProgress:Function):void
    {
      var nonsclprg:Number  = 0.0;              // non-scaled manager progress
      var sclprg:Number     = 0.0;              // scaled manager progress
      var astmgrcnt:int     = 0;                // asset manager count
      
      // load all enqueued assets in both managers
      if(mUnscaledManager.numQueuedAssets>0) {
        astmgrcnt++;
        mUnscaledManager.loadQueue(function(ratio:Number):void {
          nonsclprg = ratio;
          onProgress(totalRatio());
        });
      }
      if(mScaledManager.numQueuedAssets>0) {
        astmgrcnt++;
        mScaledManager.loadQueue(function(ratio:Number):void {
          sclprg = ratio;
          onProgress(totalRatio());
        });
      }
      
      // helper
      function totalRatio():Number { return (nonsclprg + sclprg) / Number(astmgrcnt); }
    }
    
    /**
     * Loads a single texture (unscaled) and calls the onLoaded function when complete.
     * 
     * @param path        path of the image file to load
     * @param onLoaded    (optional) Callback function of the form: onLoaded(assetName:String):void
     */
    public function loadTexture(path:String, onLoaded:Function):void
    {
      var astnam:String = mUnscaledManager.getAssetName(path);
      mUnscaledManager.enqueue(path);
      mUnscaledManager.loadQueue(function(ratio:Number):void {
        if(ratio==1.0) { onLoaded(astnam); }
      });
    }
    
    /**
     * Removes and disposes the texture with the given name.
     */
    public function removeTexture(assetName:String, dispose:Boolean=true):void
    {
      mUnscaledManager.removeTexture(assetName,dispose);
      mScaledManager.removeTexture(assetName,dispose);
    }
    
    /**************************************************************************
     * INSTANCE METHODS - LOADED ASSET ACCESS
     **************************************************************************/
    
    // gets a texture from either asset manager
    public function getTexture(name:String):Texture
    {
      var txr:Texture = mUnscaledManager.getTexture(name);
      if(!txr) { txr = mScaledManager.getTexture(name); }
      return txr;
    }
    
    // gets texture names from either asset manager
    private function getTextureNames(prefix:String):Vector.<String>
    {
      var txrnms:Vector.<String> = mUnscaledManager.getTextureNames(prefix);
      if(txrnms.length==0) { txrnms = mScaledManager.getTextureNames(prefix); }
      return txrnms;
    }
    
    /**
     * Returns all textures that start with a certain string and are within frame number bounds, sorted alphabetically.
     * 
     * @param prefix              string prefix of texture names
     * @param startFrameNumber    starting frame number (first frame is 1)
     * @param endFrameNumber      ending frame number (must be greater than starting frame number)
     * 
     * Texture Naming Assumptions:
     * - Texture names have four digit frame numbers immediately after the prefix.
     * - Texture frame numbers start at 0000, but frame number parameters to this function start at 1.
     */
    public function getTextures(prefix:String, startFrameNumber:int=1, endFrameNumber:int=int.MAX_VALUE):Vector.<Texture>
    {
      // validate
      if(startFrameNumber<1 || endFrameNumber<startFrameNumber) { return new Vector.<Texture>(); } // return empty Vector
      
      // pass off simple case to Starling functions
      if(startFrameNumber==1 && endFrameNumber==int.MAX_VALUE) {
        var vct:Vector.<Texture> = mUnscaledManager.getTextures(prefix);
        if(vct.length==0) { vct = mScaledManager.getTextures(prefix); }
        return vct;
      }
      
      // offset frame numbers for zero based system
      startFrameNumber--;
      endFrameNumber--;
      
      // get names of all Textures with the given prefix
      var txrnms:Vector.<String> = getTextureNames(prefix);
      
      // remove names not within frame range
      for(var xa:int=0; xa<txrnms.length; /*intentionally omitted*/)
      {
        var frmnbr:int = parseInt(txrnms[xa].substr(-4,4),10);    // convert last four characters to a number
        if(frmnbr<startFrameNumber || frmnbr>endFrameNumber) {
          txrnms.splice(xa,1);                                    // remove name if not in frame range
          continue;                                               // important: do not increment xa since we just removed that element
        }
        xa++;
      }
      
      // build and return Texture Vector
      var txrvct:Vector.<Texture> = new Vector.<Texture>(txrnms.length);
      for(var xb:int = 0; xb<txrnms.length; xb++) { txrvct[xb] = getTexture(txrnms[xb]); }
      return txrvct;
    }
    
    public function getXml(name:String):XML
    {
      return mUnscaledManager.getXml(name);
    }
    
    public function playSound(name:String, volume:Number=1.0):void
    {
      var vol:Number = volume * mMasterVolume;
      var sndtrs:SoundTransform = ((vol==1.0) ? null : new SoundTransform(vol));
      mUnscaledManager.playSound(name,0,0,sndtrs);
    }
    
    /**
     * Sets master volume for Assets.playSound SFX playback.
     */
    public function setMasterVolume(volume:Number):void{
      mMasterVolume = volume;
    }
    
    /**************************************************************************
     * INSTANCE METHODS - SWF ASSET UTILITY
     **************************************************************************/
    
    /**
     * Dynamically loads an animation SWF as a MovieClip.
     * The animation SWF is assumed to have no ActionScript code so it can load/unload on iOS.
     * 
     * @param path        The path of the SWF to load.
     * @param onComplete  Completion function of the form: function(movieClip:MovieClip, loader:Loader):void
     */
    public function loadSwfAnimationAsMovieClip(path:String, onComplete:Function):void
    {
      var ldr:Loader = new Loader();
      ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
        ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,arguments.callee); // immediately remove listener (this anonymous function)
        if(!event.target) {
          onComplete(null);
          return;
        }
        onComplete(event.target.content as MovieClip,ldr);
      });
      var lodctx:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
      ldr.load(new URLRequest(path),lodctx);
    }
    
    /**
     * Dynamically loads a secondary SWF and passes it to the onComplete function as a Loader object.
     * The Loader object is not initially visible (visible=false).
     * Important: Loader objects are cached once loaded and are never destroyed or loaded twice (iOS restriction).
     * 
     * @param path        The path of the SWF to load.
     * @param parent      A native Flash DisplayObjectContainer.  If supplied, then the SWF loader is added as a child before
     *                    loading starts so the parent and stage are accessible to the secondary SWF init code.  If this parameter
     *                    is null, then the SWF loader is not added as a child to any parent.
     * @param onComplete  The function called when the secondary SWF has loaded.  This function is passed the Loader object
     *                    as its only parameter: onComplete(loader:Loader)
     */
    public function loadSwfAsLoader(path:String, parent:DisplayObjectContainer, onComplete:Function):void
    {
      var ldr:Loader;             // Loader variable
      
      ldr = mLoadedSecondarySwfs[path];
      if(!ldr)
      {
        // create new loader object
        ldr = new Loader();
        
        // define completion and error functions
        var completionFunction:Function = function(event:Event):void {
          removeListeners(ldr); // remove listeners
          //Log.out('secondary SWF loaded with dimensions ' + ldr.width + 'x' + ldr.height);
          mLoadedSecondarySwfs[path] = ldr; // save in cache!
          onComplete(ldr);
        };
        var ioErrorFunction:Function = function(event:Event):void {
          removeListeners(ldr); // remove listeners
          Log.out(event);
          onComplete(null);
        };
        
        // add listeners
        ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,completionFunction);
        ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorFunction);
        
        // function to remove listeners
        function removeListeners(loader:Loader):void {
          loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completionFunction);
          loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorFunction);
        }
        
        // add uncaught error handling
        ldr.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, AS3TemplateApp.uncaughtErrorHandler);
        ldr.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, AS3TemplateApp.uncaughtErrorHandler);
        
        // initially hide loader
        ldr.visible = false;
        
        // optional: add to parent before load so stage is accessible to secondary SWF init code
        if(parent) { parent.addChild(ldr); }
        
        // iOS requirement: load the SWF using the same application domain as the parent SWF
        var lodctx:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
        ldr.load(new URLRequest(path),lodctx);
        return; // load listeners will call onComplete()
      }
      
      // Loader is cached; pass along a reference
      ldr.visible = false;
      if(parent && (!ldr.stage || ldr.parent!=parent)) { parent.addChild(ldr); } // optionally add loader as child to parent
      onComplete(ldr);
    }

    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    // singleton pattern: there may be only one of these objects ever created
    private static var sInstance:Assets = null;
    
    // theme texture atlas
    private static var sThemeTextureAtlas:TextureAtlas = null;
    
    // asset pack IDs
    public static const API_CORE                    :String = "core";
    public static const API_MISC_PARTNER_BRAND      :String = "misc-partner-brand";

    /**************************************************************************
     * STATIC PROPERTIES - EMBEDS
     **************************************************************************/
    
    // theme atlas
    
    [Embed(source="../../../../../assets/images/spritesheets/png-exclusive/swimAndPlayTheme.png")]
    private static const THEME_ATLAS_IMAGE:Class;
    
    [Embed(source="../../../../../assets/images/spritesheets/xml/swimAndPlayTheme.xml",mimeType="application/octet-stream")]
    private static const THEME_ATLAS_XML:Class;
    
    // fonts
    
    [Embed(source="../../../../../assets/fonts/TangoCom.ttf", embedAsCFF="true", fontFamily="Tango Com CFF", fontWeight="normal", mimeType="application/x-font")]
    private static const TangoComFontCFF:Class;
    
    [Embed(source="../../../../../assets/fonts/VAGRounded.ttf", embedAsCFF="true", fontFamily="VAG Rounded CFF", fontWeight="normal", mimeType="application/x-font")]
    private static const VAGRoundedFontCFF:Class;
    
    [Embed(source="../../../../../assets/fonts/TangoCom.ttf", embedAsCFF="false", fontFamily="Tango Com noCFF", fontWeight="normal", mimeType="application/x-font")]
    private static const TangoComFontNoCFF:Class;
    
    [Embed(source="../../../../../assets/fonts/VAGRounded.ttf", embedAsCFF="false", fontFamily="VAG Rounded noCFF", fontWeight="normal", mimeType="application/x-font")]
    private static const VAGRoundedFontNoCFF:Class;
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
    
    // singleton pattern
    public static function get instance():Assets
    {
      if(!sInstance) { new Assets(); } 
      return sInstance;
    }

    /**************************************************************************
     * STATIC METHODS - THEME ATLAS
     **************************************************************************/

    public static function getThemeTextureAtlas():TextureAtlas
    {
      if(!sThemeTextureAtlas) {
        const bmpdta:BitmapData = (new THEME_ATLAS_IMAGE()).bitmapData;
        sThemeTextureAtlas = new TextureAtlas(Texture.fromBitmapData(bmpdta, false), XML(new THEME_ATLAS_XML()));
      }
      return sThemeTextureAtlas;
    }

  }
}

import starling.utils.AssetManager;

/**************************************************************************
 * PRIVATE HELPER CLASS
 **************************************************************************/

class CustomAssetManager extends AssetManager {
  
  /**************************************************************************
   * INSTANCE PROPERTIES
   **************************************************************************/
  
  /**************************************************************************
   * INSTANCE CONSTRUCTOR
   **************************************************************************/
  
  public function CustomAssetManager()
  {
  }
  
  /**************************************************************************
   * INSTANCE METHODS
   **************************************************************************/
  
  // expose protected method
  public function getAssetName(rawAsset:Object):String {
    return this.getName(rawAsset);
  }
  
  /**************************************************************************
   * STATIC PROPERTIES
   **************************************************************************/
  
  /**************************************************************************
   * STATIC METHODS
   **************************************************************************/
}