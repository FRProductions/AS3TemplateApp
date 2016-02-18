package com.rhino.AS3TemplateApp.themes
{
  import com.rhino.AS3TemplateApp.RootSprite;
  import com.rhino.AS3TemplateApp.assets.Assets;
  import com.rhino.util.Log;

  import feathers.controls.Button;
  import feathers.controls.ImageLoader;
  import feathers.controls.Label;
  import feathers.controls.LayoutGroup;
  import feathers.controls.ProgressBar;
  import feathers.controls.Slider;
  import feathers.controls.TextArea;
  import feathers.controls.TextInput;
  import feathers.controls.text.TextBlockTextRenderer;
  import feathers.core.PopUpManager;
  import feathers.display.Scale3Image;
  import feathers.display.Scale9Image;
  import feathers.textures.Scale3Textures;
  import feathers.textures.Scale9Textures;
  import feathers.themes.MetalWorksMobileTheme;

  import flash.filters.GlowFilter;
  import flash.geom.Rectangle;
  import flash.text.TextFormat;
  import flash.text.engine.CFFHinting;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.FontDescription;
  import flash.text.engine.FontLookup;
  import flash.text.engine.FontPosture;
  import flash.text.engine.FontWeight;
  import flash.text.engine.RenderingMode;

  import starling.core.Starling;
  import starling.display.DisplayObject;
  import starling.display.Quad;
  import starling.filters.ColorMatrixFilter;
  import starling.textures.Texture;
  import starling.textures.TextureAtlas;
  import starling.utils.HAlign;

  /**
   * An extension of the Feathers MetalWorksMobileTheme.
   */
  public class AppMobileTheme extends MetalWorksMobileTheme
  {
    /**************************************************************************
     * INSTANCE PROPERTIES
     **************************************************************************/
    
    protected var mExtendedAtlas:TextureAtlas;                      // an atlas additional to the base atlas

    // font descriptions
    protected var mPrimaryFontDescription:FontDescription;
    protected var mSecondaryFontDescription:FontDescription;
    
    // element formats
    protected var mPrimaryHeaderElementFormat:ElementFormat;
    protected var mTabButtonDefaultLabelElementFormat:ElementFormat;
    protected var mTabButtonSelectedLabelElementFormat:ElementFormat;
    protected var mTextInputPromptElementFormat:ElementFormat;
    protected var mTextInputChatPromptElementFormat:ElementFormat;
    protected var mTextInputDigitsPromptElementFormat:ElementFormat;
    protected var mDotsElementFormat:ElementFormat;
    protected var mFinePrintElementFormat:ElementFormat;
    protected var mProductHeaderElementFormat:ElementFormat;
    protected var mProductPriceElementFormat:ElementFormat;
    protected var mProductPriceDescriptionElementFormat:ElementFormat;
    // light
    protected var mPrimaryVeryLargeLightElementFormat:ElementFormat;
    protected var mPrimaryLarge1LightElementFormat:ElementFormat;
    protected var mPrimaryLarge2LightElementFormat:ElementFormat;
    protected var mPrimaryLarge3LightElementFormat:ElementFormat;
    protected var mPrimaryMedium1LightElementFormat:ElementFormat;
    protected var mPrimaryMediumLightElementFormat:ElementFormat;
    // dark
    protected var mPrimaryLargeDarkElementFormat:ElementFormat;
    protected var mPrimaryMediumDarkElementFormat:ElementFormat;
    protected var mPrimarySmallDarkElementFormat:ElementFormat;
    // custom
    protected var mPrimaryLargeBlueElementFormat:ElementFormat;
    protected var mPrimaryMediumBlueElementFormat:ElementFormat;
    protected var mSecondaryLargeYellowElementFormat:ElementFormat;
    protected var mPrimaryMediumYellowElementFormat:ElementFormat;
    
    // textures
    protected var mBrownYellowBackgroundSkinTextures:Scale9Textures;
    protected var mPrimaryButtonUpSkinTextures:Scale3Textures;
    protected var mSecondaryButtonUpSkinTextures:Scale3Textures;
    protected var mProductGroupSkinTextures:Scale9Textures;
    protected var mGrayHalfBorderSkinTextures:Scale9Textures;
    protected var mProgressBarBorderSkinTextures:Scale9Textures;
    protected var mProgressBarFillSkinTextures:Scale9Textures;
    protected var mMapProgressBarBorderSkinTextures:Scale9Textures;
    protected var mMapProgressBarFillSkinTextures:Scale9Textures;
    protected var mSliderTrackSkinTextures:Scale3Textures;
    
    // filter scale
    private var mFilterScale:Number;
    
    /**************************************************************************
     * INSTANCE CONSTRUCTOR
     **************************************************************************/
    
    public function AppMobileTheme()
    {
      super(false);
    }
    
    /**************************************************************************
     * INSTANCE METHODS - INITIALIZE
     **************************************************************************/
    
    /**
     * Setup an extended atlas for theme
     */
    override protected function initialize():void
    {
      mExtendedAtlas = Assets.getThemeTextureAtlas();
      super.initialize();
    }
    
    override protected function initializeScale():void
    {
      super.initializeScale();
      this.scale = RootSprite.scale * 0.5;
      Log.out('theme scale is ' + this.scale);
      mFilterScale = Starling.contentScaleFactor;
      Log.out('theme filter scale is ' + mFilterScale);
    }
    
    private function fScale(value:Number):Number { return value * mFilterScale; }

    override protected function initializeFonts():void
    {
      super.initializeFonts();
      
      // font descriptions
      mPrimaryFontDescription = new FontDescription(FONT_NAME_VAG_CFF, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
      mSecondaryFontDescription = new FontDescription(FONT_NAME_TANGO_CFF, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);

      // element formats
      mPrimaryHeaderElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(90 * this.scale), COLOR_BROWN);
      mTabButtonDefaultLabelElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(70 * this.scale), COLOR_LIGHT_YELLOW);
      mTabButtonSelectedLabelElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(70 * this.scale), COLOR_WHITE);
      mTextInputPromptElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(70 * this.scale), COLOR_GRAY);
      mTextInputChatPromptElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(50 * this.scale), COLOR_GRAY);
      mTextInputDigitsPromptElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(100 * this.scale), COLOR_GRAY);
      mDotsElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(40 * this.scale), COLOR_BROWN);
      mFinePrintElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(20 * this.scale), COLOR_BROWN);
      mProductHeaderElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(60 * this.scale), COLOR_BROWN);
      mProductPriceElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(100 * this.scale), COLOR_WHITE); mProductPriceElementFormat.baselineShift = 5.0; // adjust so '$' character displays fully
      mProductPriceDescriptionElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(40 * this.scale), COLOR_WHITE);
      // light
      mPrimaryVeryLargeLightElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(150 * this.scale), COLOR_WHITE);
      mPrimaryLarge1LightElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(140 * this.scale), COLOR_WHITE);
      mPrimaryLarge2LightElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(110 * this.scale), COLOR_WHITE);
      mPrimaryLarge3LightElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(90 * this.scale), COLOR_WHITE);
      mPrimaryMedium1LightElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(60 * this.scale), COLOR_WHITE);
      mPrimaryMediumLightElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(40 * this.scale), COLOR_WHITE);
      // dark
      mPrimaryLargeDarkElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(90 * this.scale), COLOR_BROWN);
      mPrimaryMediumDarkElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(40 * this.scale), COLOR_BROWN);
      mPrimarySmallDarkElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(30 * this.scale), COLOR_BROWN);
      // custom
      mSecondaryLargeYellowElementFormat = new ElementFormat(mSecondaryFontDescription, Math.round(110 * this.scale), COLOR_LIGHT_YELLOW);
      mPrimaryMediumYellowElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(40 * this.scale), COLOR_LIGHT_YELLOW);
      mPrimaryLargeBlueElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(60 * this.scale), COLOR_BLUE);
      mPrimaryMediumBlueElementFormat = new ElementFormat(mPrimaryFontDescription, Math.round(40 * this.scale), COLOR_BLUE);
    }
    
    override protected function initializeTextures():void
    {
      super.initializeTextures();
      
      mBrownYellowBackgroundSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("background-brown-yellow"), new Rectangle(76, 76, 48, 48));
      mPrimaryButtonUpSkinTextures = new Scale3Textures(mExtendedAtlas.getTexture("button-rounded-purple"), BUTTON_SCALE3_REGIONS[0], BUTTON_SCALE3_REGIONS[1]);
      mSecondaryButtonUpSkinTextures = new Scale3Textures(mExtendedAtlas.getTexture("button-rounded-blue"), BUTTON_SCALE3_REGIONS[0], BUTTON_SCALE3_REGIONS[1]);
      mProductGroupSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("background-brown-border-skin"), BROWN_BORDER_BACKGROUND_SCALE9_GRID);
      mGrayHalfBorderSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("background-gray-half-border"), new Rectangle(10, 10, 44, 44));
      mProgressBarBorderSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("progress-bar-border"), PROGRESS_BAR_BORDER_SCALE9_GRID);
      mProgressBarFillSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("progress-bar-fill"), PROGRESS_BAR_FILL_SCALE9_GRID);
      mMapProgressBarBorderSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("map-progress-bar-border"), MAP_PROGRESS_BAR_BORDER_SCALE9_GRID);
      mMapProgressBarFillSkinTextures = new Scale9Textures(mExtendedAtlas.getTexture("map-progress-bar-fill"), MAP_PROGRESS_BAR_FILL_SCALE9_GRID);
      mSliderTrackSkinTextures = new Scale3Textures(mExtendedAtlas.getTexture("slider-track"), 49, 60);
    }
    
    /**
     * Initializes global variables (not including global style providers).
     */
    override protected function initializeGlobals():void
    {
      super.initializeGlobals();
      
      // override base theme's popup overlay factory with our own (to change color)
      PopUpManager.overlayFactory = AppMobileTheme.popUpOverlayFactory;
    }
    
    /**
     * Sets the stage background color.
     */
    override protected function initializeStage():void
    {
      super.initializeStage();
      
      // override the base theme's background color
      Starling.current.stage.color = COLOR_BLACK;
      Starling.current.nativeStage.color = COLOR_BLACK;
    }
    
    /**
     * Sets global style providers for all components.
     */
    override protected function initializeStyleProviders():void
    {
      super.initializeStyleProviders();

      // buttons
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_RECTANGLE_SELECT, this.setButtonRectangleSelectStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_RECTANGLE_CANCEL, this.setButtonRectangleCancelStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_RECTANGLE_SELECT_SMALL, this.setButtonRectangleSelectSmallStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_RECTANGLE_CANCEL_SMALL, this.setButtonRectangleCancelSmallStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_CIRCLE_BACK, this.setButtonCircleBackStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_CIRCLE_CANCEL, this.setButtonCircleCancelStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_CIRCLE_SELECT, this.setButtonCircleSelectStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_PRIMARY, this.setPrimaryButtonStyles);
      this.getStyleProviderForClass(Button).setFunctionForStyleName(BTN_SECONDARY, this.setSecondaryButtonStyles);
      
      // labels
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_OVERLAY_HEADER, this.setStylesForOverlayHeader);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_OVERLAY_MESSAGE, this.setStylesForOverlayMessage);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_DIALOG_HEADER, this.setStylesForDialogHeader);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_DIALOG_MESSAGE, this.setStylesForDialogMessage);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_LEARN_MORE_TITLE, this.setStylesForLearnMoreTitle);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_LEARN_MORE_PARAGRAPH, this.setStylesForLearnMoreParagraph);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_LEARN_MORE_LINK, this.setStylesForLearnMoreLink);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_BADGE_ICON_COUNTER, this.setStylesForBadgeIconCounter);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_ON_DEMAND_CATEGORY_TITLE, this.setStylesForOnDemandCategoryTitle);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_ON_DEMAND_ITEM_TITLE, this.setStylesForOnDemandItemTitle);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_CHAT_NAME, this.setStylesForChatName);
      this.getStyleProviderForClass(Label).setFunctionForStyleName(LBL_CHAT_TEXT, this.setStylesForChatText);
      
      // text input
      this.getStyleProviderForClass(TextArea).setFunctionForStyleName(TEXT_AREA_REPORT_PROBLEM, this.setTextAreaReportProblemStyles);
      this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TEXT_INPUT, this.setSNPTextInputStyles);
      this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TEXT_INPUT_CHAT, this.setTextInputChatStyles);
      this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TEXT_INPUT_NICKNAME, this.setTextInputNicknameStyles);
      this.getStyleProviderForClass(TextInput).setFunctionForStyleName(TEXT_INPUT_DIGITS, this.setTextInputDigitsStyles);
      
      // other
      this.getStyleProviderForClass(ProgressBar).setFunctionForStyleName(PRGBAR_MAP, this.setMapProgressBarStyles);
      this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName(LYTGRP_DIALOG_BOX, this.setDialogBoxStyles);
      this.getStyleProviderForClass(Slider).defaultStyleFunction = setSliderStyles;
      this.getStyleProviderForClass(Button).setFunctionForStyleName(Slider.DEFAULT_CHILD_STYLE_NAME_THUMB, this.setThumbButtonStyles);
    }
    
    /**************************************************************************
     * INSTANCE METHODS - BUTTONS
     **************************************************************************/
    
    private function autoImageButton(button:Button, textureName:String):void {
      autoGenerateButtonSkins(button,mExtendedAtlas.getTexture(textureName));
    }
    
    private function setButtonRectangleSelectStyles(button:Button):void { autoImageButton(button,"button-rectangle-green-select"); }
    private function setButtonRectangleCancelStyles(button:Button):void { autoImageButton(button,"button-rectangle-red-cancel"); }
    private function setButtonRectangleSelectSmallStyles(button:Button):void { autoImageButton(button,"button-rectangle-green-select-small"); }
    private function setButtonRectangleCancelSmallStyles(button:Button):void { autoImageButton(button,"button-rectangle-red-cancel-small"); }
    private function setButtonCircleBackStyles(button:Button):void { autoImageButton(button,"button-round-purple-back"); }
    private function setButtonCircleCancelStyles(button:Button):void { autoImageButton(button,"button-round-red-close"); }
    private function setButtonCircleSelectStyles(button:Button):void { autoImageButton(button,"button-round-green-check"); }

    private function setFlexibleButtonStyles(button:Button, scale3Textures:Scale3Textures):void
    {
      // skins
      button.defaultSkin = new Scale3Image(scale3Textures, this.scale);
      button.downSkin = new Scale3Image(scale3Textures, this.scale);
      var clrmtxftr:ColorMatrixFilter = new ColorMatrixFilter();
      clrmtxftr.adjustBrightness(-0.10); // darken image
      button.downSkin.filter = clrmtxftr;
      
      // font
      button.defaultLabelProperties.elementFormat = mPrimaryLarge3LightElementFormat;
      button.defaultLabelProperties.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
      button.defaultLabelProperties.leading = -5;
      
      // padding
      button.paddingLeft = button.paddingRight = scaleUnit(90);
      button.paddingTop = button.paddingBottom = scaleUnit(18);
    }
    
    private function setPrimaryButtonStyles(button:Button):void
    {
      this.setFlexibleButtonStyles(button,mPrimaryButtonUpSkinTextures);
    }
    
    private function setSecondaryButtonStyles(button:Button):void
    {
      this.setFlexibleButtonStyles(button,mSecondaryButtonUpSkinTextures);
    }

    /**************************************************************************
     * INSTANCE METHODS - LABELS
     **************************************************************************/
    
    protected function setStylesForOverlayHeader(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryLarge1LightElementFormat;
      label.textRendererProperties.nativeFilters = [new GlowFilter(COLOR_BLACK,1.0,fScale(10),fScale(10),30)];
    }
    
    protected function setStylesForOverlayMessage(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryLarge2LightElementFormat;
      label.textRendererProperties.nativeFilters = [new GlowFilter(COLOR_BLACK,1.0,fScale(7),fScale(7),20)];
      label.textRendererProperties.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
    }
    
    protected function setStylesForDialogHeader(label:Label):void
    {
      label.textRendererProperties.elementFormat = mPrimaryLargeDarkElementFormat;
      label.textRendererProperties.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
    }
    
    protected function setStylesForDialogMessage(label:Label):void
    {
      label.textRendererProperties.elementFormat = mPrimaryMediumDarkElementFormat;
      label.textRendererProperties.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
      label.textRendererProperties.leading = 5; // increase vertical spacing between lines
    }
    
    protected function setStylesForLearnMoreTitle(label:Label):void {
      label.textRendererProperties.elementFormat = mSecondaryLargeYellowElementFormat;
    }
    
    protected function setStylesForLearnMoreParagraph(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryMediumLightElementFormat;
    }
    
    protected function setStylesForLearnMoreLink(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryMediumYellowElementFormat;
    }
    
    protected function setStylesForBadgeIconCounter(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryVeryLargeLightElementFormat;
      label.textRendererProperties.nativeFilters = [new GlowFilter(COLOR_BLACK,1.0,fScale(5),fScale(5),5)];
    }
    
    protected function setStylesForOnDemandCategoryTitle(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryMedium1LightElementFormat;
    }
    
    protected function setStylesForOnDemandItemTitle(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryMediumBlueElementFormat;
    }
    
    protected function setStylesForChatName(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimarySmallDarkElementFormat;
    }
    
    protected function setStylesForChatText(label:Label):void {
      label.textRendererProperties.elementFormat = mPrimaryLargeBlueElementFormat;
    }
    
    /**************************************************************************
     * INSTANCE METHODS - TEXT INPUT
     **************************************************************************/
    
    protected function setTextAreaReportProblemStyles(textArea:TextArea):void
    {
      super.setTextAreaStyles(textArea);
      
      // set background skin
      textArea.stateToSkinFunction = null;
      textArea.backgroundSkin = new Scale9Image(mGrayHalfBorderSkinTextures, this.scale);
      
      textArea.textEditorProperties.textFormat = new TextFormat(FONT_NAME_VAG_FULL, Math.round(40 * this.scale), COLOR_BLUE);
      textArea.textEditorProperties.disabledTextFormat = new TextFormat(FONT_NAME_VAG_FULL, Math.round(40 * this.scale), DISABLED_TEXT_COLOR);
    }
    
    protected function setSNPTextInputStyles(input:TextInput):void
    {
      this.setBaseTextInputStyles(input);
      
      // remove all skins
      input.stateToSkinFunction = null;
      
      // text editor
      input.textEditorProperties.fontFamily = FONT_NAME_VAG_FULL;
      input.textEditorProperties.fontSize = 70 * this.scale;
      input.textEditorProperties.textAlign = HAlign.CENTER;
      input.textEditorProperties.color = COLOR_BLUE;
      
      // prompt
      input.promptProperties.elementFormat = mTextInputPromptElementFormat;
      input.promptProperties.alpha = 0.5;
      input.promptProperties.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
    }
    
    protected function setTextInputChatStyles(input:TextInput):void
    {
      this.setSNPTextInputStyles(input);
      
      // set background skin
      input.backgroundSkin = new Scale9Image(mGrayHalfBorderSkinTextures, this.scale);
      
      // change font size and color
      input.textEditorProperties.fontSize = 50 * this.scale;
      input.textEditorProperties.color = COLOR_BLUE;
      input.promptProperties.elementFormat = mTextInputChatPromptElementFormat;
    }
    
    protected function setTextInputNicknameStyles(input:TextInput):void
    {
      this.setSNPTextInputStyles(input);
      
      // set background skin
      input.backgroundSkin = new Scale9Image(mGrayHalfBorderSkinTextures, this.scale);
    }
    
    protected function setTextInputDigitsStyles(input:TextInput):void
    {
      this.setSNPTextInputStyles(input);
      
      // set background skin
      input.backgroundSkin = new Scale9Image(mGrayHalfBorderSkinTextures, this.scale);
      
      // increase font size
      input.textEditorProperties.fontSize = 100 * this.scale;
      input.promptProperties.elementFormat = mTextInputDigitsPromptElementFormat;
      
      // set prompt and size
      input.prompt = 'XXXX';
      input.maxChars = 4;
      input.restrict = "0-9";
      input.padding = 30 * this.scale;
      input.width = 600 * this.scale;
    }
    
    /**************************************************************************
     * INSTANCE METHODS - OTHER
     **************************************************************************/
    
    // default progress bar style
    override protected function setProgressBarStyles(progress:ProgressBar):void
    {
      var backgroundSkin:Scale9Image = new Scale9Image(mProgressBarBorderSkinTextures, this.scale);
      backgroundSkin.width = this.wideControlSize;
      backgroundSkin.height = this.smallControlSize;
      progress.backgroundSkin = backgroundSkin;
      
      var fillSkin:Scale9Image = new Scale9Image(mProgressBarFillSkinTextures, this.scale);
      fillSkin.width = this.smallControlSize;
      fillSkin.height = this.smallControlSize;
      progress.fillSkin = fillSkin;
    }
    
    // map progress bar style
    protected function setMapProgressBarStyles(progress:ProgressBar):void
    {
      var backgroundSkin:Scale9Image = new Scale9Image(mMapProgressBarBorderSkinTextures, this.scale);
      backgroundSkin.width = this.wideControlSize;
      backgroundSkin.height = this.smallControlSize;
      progress.backgroundSkin = backgroundSkin;
      
      var fillSkin:Scale9Image = new Scale9Image(mMapProgressBarFillSkinTextures, this.scale);
      fillSkin.width = this.smallControlSize;
      fillSkin.height = this.smallControlSize;
      progress.fillSkin = fillSkin;
    }
    
    protected function setDialogBoxStyles(dialog:LayoutGroup):void
    {
      dialog.backgroundSkin = new Scale9Image(mBrownYellowBackgroundSkinTextures, this.scale);
      dialog.maxWidth = scaleUnit(2000);
    }
    
    override protected function setSliderStyles(slider:Slider):void
    {
      slider.trackLayoutMode = Slider.TRACK_LAYOUT_MODE_SINGLE;
      slider.customMinimumTrackStyleName = THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK;
    }
    
    override protected function setHorizontalSliderMinimumTrackStyles(track:Button):void
    {
      track.defaultSkin = new Scale3Image(mSliderTrackSkinTextures,this.scale);
      track.stateToSkinFunction = null;
      track.hasLabelTextRenderer = false;
    }
    
    private function setThumbButtonStyles(button:Button):void
    {
      var skn:ImageLoader = new ImageLoader();
      skn.source = mExtendedAtlas.getTexture("slider-thumb");
      skn.textureScale = this.scale;
      button.defaultSkin = skn;
      button.stateToSkinFunction = null;
      button.hasLabelTextRenderer = false;
    }
    
    /**************************************************************************
     * INSTANCE METHODS - UTILITY
     **************************************************************************/
    
    /**
     * Creates and sets a Button's defaultSkin, downSkin, and disabledSkin.
     * 
     * @param button            The button to create skins for.
     * @param texture           (optional) The texture to use to create skins.
     *                          If a texture is provided, it is used and will replace any existing default skin.
     *                          If no texture is provided, the Button is expected to already have an ImageLoader default skin set.
     * @param applyThemeScale   If true, apply theme scale to each skin.  Otherwise do not apply scale.
     */
    protected function autoGenerateButtonSkins(button:Button, texture:Texture=null, applyThemeScale:Boolean=true):void
    {
      var dftskn:ImageLoader = null;              // default skin ImageLoader
      
      // set default (up) skin
      if(texture!=null) {
        dftskn = new ImageLoader();
        dftskn.source = texture;
        if(applyThemeScale) { dftskn.textureScale = this.scale; }
        button.defaultSkin = dftskn;
      }
      else if(button.defaultSkin!=null) {
        dftskn = button.defaultSkin as ImageLoader;
        if(dftskn && applyThemeScale) { dftskn.textureScale = this.scale; }
      }
      
      // if no ImageLoader default skin, nothing more to do!
      if(!dftskn) { return; }
      
      // set down skin
      var dwnskn:ImageLoader = new ImageLoader();
      dwnskn.source = dftskn.source;
      if(applyThemeScale) { dwnskn.textureScale = this.scale; }
      button.downSkin = dwnskn;
      var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
      colorMatrixFilter.adjustBrightness(-0.10); // darken image
      button.downSkin.filter = colorMatrixFilter;
      
      // set disabled skin
      var dsbskn:ImageLoader = new ImageLoader();
      dsbskn.source = dftskn.source;
      if(applyThemeScale) { dsbskn.textureScale = this.scale; }
      button.disabledSkin = dsbskn;
      button.disabledSkin.alpha = 0.5;
    }
    
    private function scaleUnit(value:Number):Number
    {
      return Math.round(value * this.scale);
    }
    
    /**************************************************************************
     * STATIC PROPERTIES
     **************************************************************************/

    // colors
    protected static const COLOR_BLACK:uint         = 0x000000;
    protected static const COLOR_BROWN:uint         = 0x7b3d00;
    protected static const COLOR_LIGHT_YELLOW:uint  = 0xffde6a;
    protected static const COLOR_WHITE:uint         = 0xffffff;
    public    static const COLOR_BLUE:uint          = 0x0085be;
    protected static const COLOR_GRAY:uint          = 0x8a8a8a;
    protected static const COLOR_PURPLE:uint        = 0x97479c;

    // scale9 grids
    protected static const BROWN_BORDER_BACKGROUND_SCALE9_GRID:Rectangle = new Rectangle(27, 27, 46, 46);
    protected static const PROGRESS_BAR_BORDER_SCALE9_GRID:Rectangle = new Rectangle(29, 29, 6, 6);
    protected static const PROGRESS_BAR_FILL_SCALE9_GRID:Rectangle = new Rectangle(29, 29, 6, 6);
    protected static const MAP_PROGRESS_BAR_BORDER_SCALE9_GRID:Rectangle = new Rectangle(12, 12, 40, 40);
    protected static const MAP_PROGRESS_BAR_FILL_SCALE9_GRID:Rectangle = new Rectangle(14, 14, 36, 36);

    // scale3 regions
    protected static const BUTTON_SCALE3_REGIONS:Array = [108, 134];
    
    // fonts
    public static const FONT_NAME_VAG_CFF:String          = "VAG Rounded CFF";
    public static const FONT_NAME_VAG_NO_CFF:String       = "VAG Rounded noCFF";
    public static const FONT_NAME_VAG_POSTSCRIPT:String   = "VAGRoundedBT-Regular";         // Font Book reports: PostScript name
    public static const FONT_NAME_VAG_FULL:String         = "VAGRounded BT";                // Font Book reports: Full name, Family
    public static const FONT_NAME_VAG_UNIQUE:String       = "VAG Rounded, Informal 801";    // Font Book reports: Unique name
    
    public static const FONT_NAME_TANGO_CFF:String        = "Tango Com CFF";
    public static const FONT_NAME_TANGO_NO_CFF:String     = "Tango Com noCFF";
    public static const FONT_NAME_TANGO_POSTSCRIPT:String = "TangoCom-Regular";
    public static const FONT_NAME_TANGO_FULL:String       = "Tango Com";  
    public static const FONT_NAME_TANGO_UNIQUE:String     = "ITC - Tango Com";

    // style names: buttons
    public static const BTN_RECTANGLE_SELECT:String           = "snp-Button-rectangle-select";
    public static const BTN_RECTANGLE_CANCEL:String           = "snp-Button-rectangle-cancel";
    public static const BTN_RECTANGLE_SELECT_SMALL:String     = "snp-Button-rectangle-select-small";
    public static const BTN_RECTANGLE_CANCEL_SMALL:String     = "snp-Button-rectangle-cancel-small";
    public static const BTN_CIRCLE_BACK:String                = "snp-Button-circle-back";
    public static const BTN_CIRCLE_CANCEL:String              = "snp-Button-circle-cancel";
    public static const BTN_CIRCLE_SELECT:String              = "snp-Button-circle-select";
    public static const BTN_PRIMARY:String                    = "snp-button-primary";
    public static const BTN_SECONDARY:String                  = "snp-button-secondary";
    
    // style names: labels
    public static const LBL_OVERLAY_HEADER:String             = "snp-Label-overlay-header";
    public static const LBL_OVERLAY_MESSAGE:String            = "snp-Label-overlay-message";
    public static const LBL_DIALOG_HEADER:String              = "snp-Label-dialog-header";
    public static const LBL_DIALOG_MESSAGE:String             = "snp-Label-dialog-message";
    public static const LBL_LEARN_MORE_TITLE:String           = "snp-Label-learn-more-title";
    public static const LBL_LEARN_MORE_PARAGRAPH:String       = "snp-Label-learn-more-paragraph";
    public static const LBL_LEARN_MORE_LINK:String            = "snp-Label-learn-more-link";
    public static const LBL_BADGE_ICON_COUNTER:String         = "snp-Label-badge-icon-counter";
    public static const LBL_ON_DEMAND_CATEGORY_TITLE:String   = "snp-Label-on-demand-category-title";
    public static const LBL_ON_DEMAND_ITEM_TITLE:String       = "snp-Label-on-demand-item-title";
    public static const LBL_CHAT_NAME:String                  = "snp-Label-chat-name";
    public static const LBL_CHAT_TEXT:String                  = "snp-Label-chat-text";
    
    // style names: text
    public static const TEXT_AREA_REPORT_PROBLEM:String       = "snp-TextArea-report-problem";
    public static const TEXT_INPUT:String                     = "snp-TextInput";
    public static const TEXT_INPUT_CHAT:String                = "snp-TextInput-chat";
    public static const TEXT_INPUT_NICKNAME:String            = "snp-TextInput-nickname";
    public static const TEXT_INPUT_DIGITS:String              = "snp-TextInput-digits";
    
    // style names: other
    public static const PRGBAR_MAP:String                     = "snp-ProgressBar-map";
    public static const LYTGRP_DIALOG_BOX:String              = "snp-LayoutGroup-dialogBox";
    
    /**************************************************************************
     * STATIC METHODS
     **************************************************************************/
    
    /**
     * Provides an overlay to display behind popups.
     */
    protected static function popUpOverlayFactory():DisplayObject
    {
      var quad:Quad = new Quad(100, 100, COLOR_BLACK);
      quad.alpha = 0.5;
      return quad;
    }
    
  }
}
