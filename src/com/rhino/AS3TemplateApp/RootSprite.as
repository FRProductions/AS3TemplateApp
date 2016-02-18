package com.rhino.AS3TemplateApp
{
  import com.rhino.AS3TemplateApp.assets.Assets;
  import com.rhino.AS3TemplateApp.data.OptionsData;
  import com.rhino.AS3TemplateApp.screens.LoadingSplashScreen;
  import com.rhino.AS3TemplateApp.screens.MainMenuScreen;
  import com.rhino.AS3TemplateApp.screens.WheelSpinnerScreen;
  import com.rhino.AS3TemplateApp.themes.AppMobileTheme;
  import com.rhino.util.Log;
  
  import feathers.controls.ScreenNavigator;
  import feathers.controls.ScreenNavigatorItem;
  
  import starling.display.Sprite;
  import starling.events.Event;
  
  public class RootSprite extends Sprite
  {
    
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mScreenNavigator:ScreenNavigator;

    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function RootSprite()
    {
      super();
      
      // init
      this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    /**************************************************************************
     * INSTANCE METHODS
     **************************************************************************/
    
    private function onAddedToStage(event:Event):void
    {
      this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
      
      // calculate master scale
      sScale = this.stage.stageHeight / 1024;
      Log.out('master scale is ' + sScale);

      // init Feathers theme (must happen after Starling init and after master scale is set)
      RootSprite.sTheme = new AppMobileTheme();
      
      // initialize core singletons
      Assets.instance;
      
      // setup Feathers screen navigator and screens
      mScreenNavigator = new ScreenNavigator();
      addChild(mScreenNavigator);
      var scnitm:ScreenNavigatorItem;
      // loading splash screen
      scnitm = new ScreenNavigatorItem(LoadingSplashScreen);
      scnitm.setScreenIDForEvent("completed",SID_MAIN_MENU);
      mScreenNavigator.addScreen(SID_LOADING_SPLASH,scnitm);
      // main menu screen
      scnitm = new ScreenNavigatorItem(MainMenuScreen);
      scnitm.setScreenIDForEvent("reloadButtonPressed",SID_LOADING_SPLASH);
      mScreenNavigator.addScreen(SID_MAIN_MENU,scnitm);

      // show the initial screen
      mScreenNavigator.showScreen(SID_LOADING_SPLASH);
    }
    
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    // screen IDs
    public static const SID_LOADING_SPLASH  :String = "LoadingSplashScreen";
    public static const SID_MAIN_MENU       :String = "MainMenuScreen";

    // master UI scale
    private static var sScale:Number = 1.0;

    // theme reference
    private static var sTheme:AppMobileTheme = null;
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
    
    /**
     * Master UI scale, used to scale UI controls to work on the actual screen size.
     * 
     * @return master UI scale
     */
    public static function get scale():Number { return sScale; }
    
    /**
     * Scales a unit according to the master UI scale.
     */
    public static function sUnit(value:Number):Number
    {
      return sScale * value;
    }
    
  }
}