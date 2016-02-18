package com.rhino.AS3TemplateApp.assets
{
  
  public class AssetItem
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mType:int;
    private var mName:String;
    private var mExtension:String;
    private var mDirectories:AssetDirectories;
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function AssetItem(type:int, name:String, extension:String=null, directories:AssetDirectories=null)
    {
      mType = type;
      mName = name;
      mExtension = extension;
      mDirectories = directories;
    }
    
    /**************************************************************************
     * INSTANCE METHODS - ACCESSORS
     **************************************************************************/
    
    /**
     * Asset type of this item; a valid TYP_ constant
     */
    public function get type():int { return mType; }

    /**
     * Name of this item; a valid filename without an extension.
     * The {scale} token will be replaced with the scale factor integer.
     */
    public function get name():String { return mName; }

    /**
     * File extension of this asset (may be null).
     */
    public function get extension():String { return mExtension; }
    
    /**
     * The AssetDirectories object to use for loading this item (may be null).
     */
    public function get directories():AssetDirectories { return mDirectories; }

    /**************************************************************************
     * INSTANCE METHODS
     **************************************************************************/
    
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    // asset type ID constants
    public static const TYP_SPRITESHEET_SCALED:int     = 0;
    public static const TYP_SPRITESHEET_UNSCALED:int   = 1;
    public static const TYP_IMAGE_SCALED:int           = 2;
    public static const TYP_IMAGE_UNSCALED:int         = 3;
    public static const TYP_SOUND:int                  = 4;
    public static const TYP_OTHER:int                  = 5;
    
    // asset type string (found in XML) to internal type ID map
    private static const TYPE_ID_MAP:Object = {
      "SPRITESHEET_SCALED"    : TYP_SPRITESHEET_SCALED,
      "SPRITESHEET_UNSCALED"  : TYP_SPRITESHEET_UNSCALED,
      "IMAGE_SCALED"          : TYP_IMAGE_SCALED,
      "IMAGE_UNSCALED"        : TYP_IMAGE_UNSCALED,
      "SOUND"                 : TYP_SOUND,
      "OTHER"                 : TYP_OTHER
    };

    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
    
    public static function fromXML(xml:XML):AssetItem
    {
      var itmtyp:int = typeIdFromTypeString(xml.@type);
      var itm:AssetItem = new AssetItem(itmtyp,xml.@name);
      itm.mExtension    = xml.@extension;
      return itm;
    }
    
    private static function typeIdFromTypeString(typeString:String):int
    {
      if(TYPE_ID_MAP.hasOwnProperty(typeString)) { return TYPE_ID_MAP[typeString]; }
      return TYP_OTHER; // default
    }

  }
}