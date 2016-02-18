package com.rhino.AS3TemplateApp.screens
{
  import com.greensock.TweenLite;
  import com.rhino.AS3TemplateApp.RootSprite;
  import com.rhino.AS3TemplateApp.themes.AppMobileTheme;

  import feathers.controls.Label;
  import feathers.controls.ProgressBar;
  import feathers.controls.Screen;
  import feathers.display.Scale9Image;
  import feathers.events.FeathersEventType;
  import feathers.layout.VerticalLayout;

  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;

  import starling.events.Event;

  public class LoadingSplashScreen extends Screen
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mCompleted:Signal;
    private var mProgressBar:ProgressBar;
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function LoadingSplashScreen()
    {
      super();
      
      // init
      mCompleted = new Signal();
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
      this.removeEventListener(FeathersEventType.CREATION_COMPLETE,onCreationComplete);
      updateAssetPacks();
    }
        
    private function updateAssetPacks():void
    {
      // TODO: setup asset packs for download

      /**/
      mProgressBar.value = 1.0;
      TweenLite.to(mProgressBar,1.0,{ alpha:0.0, onComplete:function():void {
        mCompleted.dispatch();
      }});
      /**/

/*
      // update assets
      var astpckupd:AssetPackUpdater = new AssetPackUpdater(
        AS3TemplateApp.createAssetPackClient(),
        new <AssetPackInfo>[
          new AssetPackInfo(Assets.API_CORE)
        ]
      );
      astpckupd.progressChanged.add(function(ratio:Number):void {
        mProgressBar.value = ratio;
      });
      astpckupd.completed.add(function():void {
        Log.out("asset pack update successful");
        TweenLite.to(mProgressBar,1.0,{ alpha:0.0, onComplete:function():void {
          mCompleted.dispatch();
        }});
      });
      astpckupd.failed.add(function():void {
        var dlymls:Number = 5000;
        Log.out("failed to update asset packs; trying again in " + (dlymls/1000) + " seconds...");
        setTimeout(updateAssetPacks,dlymls);
      });
      astpckupd.update();
*/
    }
    
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
  }
}