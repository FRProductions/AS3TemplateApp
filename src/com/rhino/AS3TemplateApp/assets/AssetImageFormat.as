package com.rhino.AS3TemplateApp.assets
{
  import com.rhino.util.Util;

  /**
   * Determines image format types to use on this device.
   */
  public class AssetImageFormat
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mTypeInfo:Object;

    private var mTileType:String;
    private var mSpritesheetType:String;
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function AssetImageFormat()
    {
      // spritesheet/tile image directories and filename extensions
      if(Util.isIos())
      {
        // use PVRTC spritesheets on all iOS devices
        mSpritesheetType = PVRTC;
        
        // choose tile format
        var iosdvcinf:Object = Util.getIosDeviceInfo(); // iOS device detail
        if([Util.IPHONE_1,Util.IPHONE_3G,Util.IPHONE_4,Util.IPHONE_4S,Util.IPAD_1,Util.IPAD_2,Util.IPAD_MINI_1,Util.IPAD_3].indexOf(iosdvcinf.grp) != -1) {
          // use PVRTC tiles on earlier iOS devices to save memory / increase speed
          mTileType = PVRTC;
        }
        else {
          // use PNG tiles on most recent (or unknown) iOS devices for best quality
          mTileType = PNG;
        }
      }
      else if(Util.isAndroid()) {
        mSpritesheetType = PNG;
        mTileType = PNG;
      }
      else {
        // PC/MAC texture formats
        mSpritesheetType = PNG;
        mTileType = DXT;
      }
      
      // define image format type info
      mTypeInfo = {};
      mTypeInfo[PNG]    = { dir:"png"  , ext:".png" };
      mTypeInfo[DXT]    = { dir:"dxt"  , ext:".atf" };
      mTypeInfo[PVRTC]  = { dir:"pvrtc", ext:".atf" };
    }
    
    /**************************************************************************
     * INSTANCE METHODS
     **************************************************************************/
    
    public function get tileType():String { return mTileType; }
    public function get spritesheetType():String { return mSpritesheetType; }
    
    /**
     * @return the tile directory name for this platform
     */
    public function get tileDirectory():String { return mTypeInfo[mTileType].dir; }

    /**
     * @return the tile file extension for this platform; includes a '.' prefix
     */
    public function get tileFileExtension():String { return mTypeInfo[mTileType].ext; }

    /**
     * @return the spritesheet directory name for this platform
     */
    public function get spritesheetDirectory():String { return mTypeInfo[mSpritesheetType].dir; }
    
    /**
     * @return the spritesheet file extension for this platform; includes a '.' prefix
     */
    public function get spritesheetFileExtension():String { return mTypeInfo[mSpritesheetType].ext; }
    
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    // image format type constants
    public static const PNG:String   = 'png';
    public static const DXT:String   = 'dxt';
    public static const PVRTC:String = 'pvr';

    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
  }
}