package com.rhino.AS3TemplateApp.assets
{
  import com.rhino.util.Log;

  public class AssetDirectories
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    // full directory paths, all with trailing '/'
    private var mBaseDir:String;
    private var mSpritesheetImageDir:String;
    private var mSpritesheetImageExt:String;
    private var mBackgroundTileImageDir:String;
    private var mBackgroundTileImageExt:String;

    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    /**
     * @param assetBaseDir    Absolute path to assets directory, assumed to include a trailing '/'.
     */
    public function AssetDirectories(assetBaseDir:String)
    {
      // save base dir
      mBaseDir = assetBaseDir;
      
      // spritesheet/tile image directories and filename extensions
      var imgfmt:AssetImageFormat = new AssetImageFormat();
      mSpritesheetImageDir = mBaseDir + SUBDIR_SPRITESHEETS + imgfmt.spritesheetDirectory + '/';
      mSpritesheetImageExt = imgfmt.spritesheetFileExtension;
      mBackgroundTileImageDir = mBaseDir + SUBDIR_TILES + imgfmt.tileDirectory + '/';
      mBackgroundTileImageExt = imgfmt.tileFileExtension;
    }
    
    /**************************************************************************
     * INSTANCE METHODS - ACCESSORS
     **************************************************************************/
    
    public function get baseDir():String { return mBaseDir; }
    public function get imagesDir():String { return mBaseDir + SUBDIR_IMAGES; }
    public function get spritesheetImageDir():String { return mSpritesheetImageDir; }
    public function get spritesheetImageExt():String { return mSpritesheetImageExt; }
    public function get backgroundTileImageDir():String { return mBackgroundTileImageDir; }
    public function get backgroundTileImageExt():String { return mBackgroundTileImageExt; }
    public function get spritesheetXmlDir():String { return mBaseDir + SUBDIR_SPRITESHEETS + 'xml/'; }
    public function get spritesheetImagePngExclusiveDir():String { return mBaseDir + SUBDIR_SPRITESHEETS + 'png-exclusive/'; }
    public function get soundsDir():String { return mBaseDir + 'sounds/'; }
    public function get interactionsDir():String { return mBaseDir + 'interactions/'; }
    public function get activityBackgroundsDir():String { return mBaseDir + SUBDIR_IMAGES + 'activity-backgrounds/'; }
    
    /**************************************************************************
     * INSTANCE METHODS
     **************************************************************************/
    
    public function logSummary(summaryPrefix:String, verbose:Boolean=false):void
    {
      Log.out(summaryPrefix + ' asset directories');
      Log.out(  '  base dir ........................ : ' + this.baseDir);
      if(verbose) {
        Log.out('  spritesheet XML ................. : ' + this.spritesheetXmlDir);
        Log.out('  spritesheet images .............. : ' + this.spritesheetImageDir + '*' + this.spritesheetImageExt);
        Log.out('  spritesheet images, PNG exclusive : ' + this.spritesheetImagePngExclusiveDir);
        Log.out('  background tile images .......... : ' + this.backgroundTileImageDir + '*' + this.backgroundTileImageExt);
        Log.out('  sounds .......................... : ' + this.soundsDir);
        Log.out('  interactions .................... : ' + this.interactionsDir);
        Log.out('  activity backgrounds ............ : ' + this.activityBackgroundsDir);
      }
    }
    
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    // subdirs of base directory
    private const SUBDIR_IMAGES:String        = 'images/';
    private const SUBDIR_SPRITESHEETS:String  = SUBDIR_IMAGES + 'spritesheets/';
    private const SUBDIR_TILES:String         = SUBDIR_IMAGES + 'tiles/';
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
    
  }
}