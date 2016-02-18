package com.rhino.AS3TemplateApp.screens
{
  import com.rhino.AS3TemplateApp.RootSprite;
  import com.rhino.AS3TemplateApp.themes.AppMobileTheme;

  import feathers.controls.Button;
  import feathers.controls.Label;
  import feathers.controls.Screen;
  import feathers.layout.VerticalLayout;

  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;

  import starling.events.Event;

  public class MainMenuScreen extends Screen
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    private var mReloadButtonPressed:Signal;
    private var mMenuButtonPressed:Signal;

    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function MainMenuScreen()
    {
      super();
      
      // init
      mReloadButtonPressed = new Signal();
      mMenuButtonPressed = new Signal();
    }
    
    /**************************************************************************
     * INSTANCE METHODS - PUBLIC
     **************************************************************************/
    
    /**
     * A Signal dispatched when the reload button was pressed
     * Listener form: function():void
     */
    public function get reloadButtonPressed():ISignal { return mReloadButtonPressed; }

    /**
     * A Signal dispatched when a menu button was pressed
     * Listener form: function():void
     */
    public function get menuButtonPressed():ISignal { return mMenuButtonPressed; }


    /**************************************************************************
     * INSTANCE METHODS - INTERNAL
     **************************************************************************/

    override protected function initialize():void
    {
      // always call
      super.initialize();
      
      // setup screen layout
      var vrtlyt:VerticalLayout = new VerticalLayout();
      vrtlyt.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
      vrtlyt.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
      vrtlyt.gap = RootSprite.sUnit(20);
      this.layout = vrtlyt;
      
      // add a test label
      var lbl:Label = new Label();
      lbl.styleNameList.add(AppMobileTheme.LBL_OVERLAY_HEADER);
      lbl.text = "Main Menu";
      this.addChild(lbl);

      // menu button
      var mnubtn:Button = new Button();
      mnubtn.styleNameList.add(AppMobileTheme.BTN_SECONDARY);
      mnubtn.label = "Menu Button";
      mnubtn.addEventListener(Event.TRIGGERED,onMenuButtonTriggered);
      this.addChild(mnubtn);

      // reload button
      var rldbtn:Button = new Button();
      rldbtn.styleNameList.add(AppMobileTheme.BTN_PRIMARY);
      rldbtn.label = "Reload";
      rldbtn.addEventListener(Event.TRIGGERED,onReloadButtonTriggered);
      this.addChild(rldbtn);

    }
    
    /**************************************************************************
     * INSTANCE METHODS - LISTENERS
     **************************************************************************/

    private function onMenuButtonTriggered(event:Event):void
    {
      // dispatch signal
      mMenuButtonPressed.dispatch();
    }

    private function onReloadButtonTriggered(event:Event):void
    {
      // dispatch signal
      mReloadButtonPressed.dispatch();
    }

    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
  }
}