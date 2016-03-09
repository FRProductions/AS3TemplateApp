package com.rhino.AS3TemplateApp.screens
{
  import com.greensock.TweenLite;
  import com.greensock.easing.Linear;
  import com.rhino.AS3TemplateApp.RootSprite;
  import com.rhino.AS3TemplateApp.assets.AssetItem;
  import com.rhino.AS3TemplateApp.assets.Assets;
  import com.rhino.AS3TemplateApp.assets.SoundId;
  import com.rhino.AS3TemplateApp.themes.AppMobileTheme;
  import com.rhino.assetPack.AssetPackInfo;
  import com.rhino.assetPack.AssetPackUpdater;
  import com.rhino.util.LoadRatioGroup;
  import com.rhino.util.Log;

  import feathers.controls.Label;
  import feathers.controls.ProgressBar;
  import feathers.controls.Screen;
  import feathers.display.Scale9Image;
  import feathers.events.FeathersEventType;
  import feathers.layout.VerticalLayout;

  import flash.utils.setTimeout;

  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;

  import starling.events.Event;

  public class LoadingSplashScreen extends Screen
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mCompleted:Signal;
    private var mAssetPacks:Vector.<AssetPackInfo>;
    private var mAssetItems:Vector.<AssetItem>;
    private var mLoadRatioGroup:LoadRatioGroup;
    private var mProgressBar:ProgressBar;
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function LoadingSplashScreen()
    {
      super();
      
      // init
      mCompleted = new Signal();

      // specify asset packs to download
      mAssetPacks = new <AssetPackInfo>[
        new AssetPackInfo(Assets.API_CORE)
      ];

      // specify asset items to load into memory
      mAssetItems = new <AssetItem>[
        new AssetItem(AssetItem.TYP_IMAGE_UNSCALED, 'someAsset'               , '.png', Assets.instance.coreDirectories),
        new AssetItem(AssetItem.TYP_SOUND,          SoundId.LOAD_SUCCESS      , null  , Assets.instance.coreDirectories),
      ];

      // setup load ratio group
      mLoadRatioGroup = new LoadRatioGroup();
      mLoadRatioGroup.addItem(mAssetPacks);
      mLoadRatioGroup.addItem(mAssetItems);

      // add listener
      this.addEventListener(FeathersEventType.CREATION_COMPLETE,onCreationComplete);
    }
    
    /**************************************************************************
     * INSTANCE METHODS
     **************************************************************************/
    
    /** A Signal fired when asset loading / animation is completed */
    public function get completed():ISignal { return mCompleted; }
    
    override protected function initialize():void
    {
      // always call
      super.initialize();
      
      // setup screen layout
      var vrtlyt:VerticalLayout = new VerticalLayout();
      vrtlyt.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
      vrtlyt.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
      vrtlyt.gap = RootSprite.sUnit(30);
      this.layout = vrtlyt;
      
      // title label
      var ttllbl:Label = new Label();
      ttllbl.styleNameList.add(AppMobileTheme.LBL_OVERLAY_HEADER);
      ttllbl.text = CONFIG::APP_SHORT_NAME;
      this.addChild(ttllbl);
      
      // progress bar
      mProgressBar = new ProgressBar();
      mProgressBar.width = RootSprite.sUnit(400);
      mProgressBar.height = RootSprite.sUnit(30);
      mProgressBar.minimum = 0.0;
      mProgressBar.maximum = 1.0;
      mProgressBar.value = 0.0;
      this.addChild(mProgressBar);
      
      // colorize progress bar
      var fllimg:Scale9Image = (mProgressBar.fillSkin as Scale9Image);
      if(fllimg) { fllimg.color = 0x3333FF; }
      var bgdimg:Scale9Image = (mProgressBar.backgroundSkin as Scale9Image);
      if(bgdimg) { bgdimg.color = 0x333333; }
    }
    
    private function onCreationComplete(event:Event):void
    {
      // cleanup
      this.removeEventListener(FeathersEventType.CREATION_COMPLETE,onCreationComplete);

      // fade in progress bar, then start loading
      TweenLite.to(mProgressBar,1.0,{ delay:0.5, alpha:1.0, ease:Linear.ease, onComplete:function():void {
        loadAssetPacks();
      }});
    }

    private function loadAssetPacks():void
    {
      // update assets
      var astpckupr:AssetPackUpdater = new AssetPackUpdater(AS3TemplateApp.createAssetPackClient(),mAssetPacks);
      astpckupr.progressChanged.add(function(ratio:Number):void {
        mLoadRatioGroup.updateItemRatio(mAssetPacks,ratio);
        mProgressBar.value = mLoadRatioGroup.totalLoadRatio;
      });
      astpckupr.completed.add(function():void {
        mLoadRatioGroup.updateItemRatio(mAssetPacks,1.0);
        mProgressBar.value = mLoadRatioGroup.totalLoadRatio;
        Log.out("asset pack update successful");
        loadAssets();
      });
      astpckupr.failed.add(function():void {
        var dlymls:Number = 5000;
        Log.out("failed to update asset packs; trying again in " + (dlymls/1000) + " seconds...");
        setTimeout(loadAssetPacks,dlymls);
      });
      astpckupr.update();
    }

    private function loadAssets():void
    {
      Assets.instance.enqueueAssets(mAssetItems);
      Assets.instance.loadEnqueuedAssets(onAssetLoadProgress);
    }

    private function onAssetLoadProgress(ratio:Number):void
    {
      mLoadRatioGroup.updateItemRatio(mAssetItems,ratio);
      mProgressBar.value = mLoadRatioGroup.totalLoadRatio;
      if(ratio==1.0) { runLoadCompleteAnimation(); }
    }

    private function runLoadCompleteAnimation():void
    {
      Assets.instance.playSound(SoundId.LOAD_SUCCESS);

      // fade out progress bar
      TweenLite.to(mProgressBar,1.0,{ alpha:0.0, onComplete:function():void {
        setTimeout(function():void { mCompleted.dispatch(); },1000);
      }});
    }

    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
  }
}