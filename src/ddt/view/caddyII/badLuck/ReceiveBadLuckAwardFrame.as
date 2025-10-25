package ddt.view.caddyII.badLuck
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.InventoryItemAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   
   public class ReceiveBadLuckAwardFrame extends BaseAlerFrame
   {
      
      private var _bg:MutipleImage;
      
      private var _bg2:MutipleImage;
      
      private var _bg3:MutipleImage;
      
      private var _bg6:Bitmap;
      
      private var _bg7:Bitmap;
      
      private var _titleBit:Bitmap;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<ReceiveBadLuckItem>;
      
      private var _goodList:Vector.<InventoryItemInfo>;
      
      private var _dataList:Vector.<Object>;
      
      private var _rankingText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _propertyText:FilterFrameText;
      
      private var _regulationText1:FilterFrameText;
      
      private var _regulationText2:FilterFrameText;
      
      private var _regulationText3:FilterFrameText;
      
      private var _regulationText4:FilterFrameText;
      
      public function ReceiveBadLuckAwardFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc3_:ReceiveBadLuckItem = null;
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("tank.ReceiveBadLuckAwardFrame.title");
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc1_.showCancel = false;
         info = _loc1_;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGI");
         this._titleBit = ComponentFactory.Instance.creatBitmap("asset.RBadLuck.FontTitle");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGII");
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadLuckBGIII");
         this._bg6 = ComponentFactory.Instance.creatBitmap("asset.RBadLuck.FontR");
         this._bg7 = ComponentFactory.Instance.creatBitmap("asset.RBadLuck.FontRbadEx");
         this._rankingText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.rankingText");
         this._rankingText.text = LanguageMgr.GetTranslation("caddy.badLuck.rankingText。text");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.nameText");
         this._nameText.text = LanguageMgr.GetTranslation("caddy.badLuck.nameText.text");
         this._propertyText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.propertyText");
         this._propertyText.text = LanguageMgr.GetTranslation("caddy.badLuck.propertyText.text");
         this._regulationText1 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.regulationText1");
         this._regulationText1.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText1.text");
         this._regulationText2 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.regulationText2");
         this._regulationText2.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText2.text");
         this._regulationText3 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.regulationText3");
         this._regulationText3.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText3.text");
         this._regulationText4 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.regulationText4");
         this._regulationText4.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText4.text");
         addToContent(this._bg);
         addToContent(this._titleBit);
         addToContent(this._bg2);
         addToContent(this._bg3);
         addToContent(this._bg6);
         addToContent(this._bg7);
         addToContent(this._rankingText);
         addToContent(this._nameText);
         addToContent(this._propertyText);
         addToContent(this._regulationText1);
         addToContent(this._regulationText2);
         addToContent(this._regulationText3);
         addToContent(this._regulationText4);
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.RbadLuckBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.RbadLuckScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addToContent(this._panel);
         this._itemList = new Vector.<ReceiveBadLuckItem>();
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("card.ReceiveBadLuckItem");
            this._list.addChild(_loc3_);
            this._itemList.push(_loc3_);
            _loc2_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function creatItemTempleteLoader() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("User_LotteryRank.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingGoodsTemplateFailure");
         _loc1_.analyzer = new InventoryItemAnalyzer(this.__loadComplete);
         _loc1_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(_loc1_);
         return _loc1_;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __loadComplete(param1:InventoryItemAnalyzer) : void
      {
         RouletteManager.instance.goodList = this._goodList = param1.list;
         this.updateData();
      }
      
      private function updateData() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc1_:Date = TimeManager.Instance.Now();
         for each(_loc2_ in this._goodList)
         {
            _loc2_.BeginDate = _loc1_.fullYear + "-" + (_loc1_.month + 1) + "-" + _loc1_.date + " " + _loc1_.hours + ":" + _loc1_.minutes + ":" + _loc1_.seconds;
         }
         _loc3_ = 0;
         while(_loc3_ < 10 && _loc3_ < this._goodList.length)
         {
            if(this._dataList == null || _loc3_ >= this._dataList.length || this._dataList[_loc3_] == null)
            {
               _loc4_ = "MyName";
            }
            else
            {
               _loc4_ = this._dataList[_loc3_].Nickname;
            }
            this._itemList[_loc3_].update(_loc3_,_loc4_,this._goodList[_loc3_]);
            _loc3_++;
         }
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function set dataList(param1:Vector.<Object>) : void
      {
         this._dataList = param1;
      }
      
      public function show() : void
      {
         if(RouletteManager.instance.goodList == null)
         {
            this.creatItemTempleteLoader();
         }
         else
         {
            this._goodList = RouletteManager.instance.goodList;
            this.updateData();
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         var _loc1_:ReceiveBadLuckItem = null;
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(Boolean(this._bg3))
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(Boolean(this._bg6))
         {
            ObjectUtils.disposeObject(this._bg6);
         }
         this._bg6 = null;
         if(Boolean(this._bg7))
         {
            ObjectUtils.disposeObject(this._bg7);
         }
         this._bg7 = null;
         if(Boolean(this._titleBit))
         {
            ObjectUtils.disposeObject(this._titleBit);
         }
         this._titleBit = null;
         if(Boolean(this._rankingText))
         {
            ObjectUtils.disposeObject(this._rankingText);
         }
         this._rankingText = null;
         if(Boolean(this._nameText))
         {
            ObjectUtils.disposeObject(this._nameText);
         }
         this._nameText = null;
         if(Boolean(this._propertyText))
         {
            ObjectUtils.disposeObject(this._propertyText);
         }
         this._propertyText = null;
         if(Boolean(this._regulationText1))
         {
            ObjectUtils.disposeObject(this._regulationText1);
         }
         this._regulationText1 = null;
         if(Boolean(this._regulationText2))
         {
            ObjectUtils.disposeObject(this._regulationText2);
         }
         this._regulationText2 = null;
         if(Boolean(this._regulationText3))
         {
            ObjectUtils.disposeObject(this._regulationText3);
         }
         this._regulationText3 = null;
         if(Boolean(this._regulationText4))
         {
            ObjectUtils.disposeObject(this._regulationText4);
         }
         this._regulationText4 = null;
         for each(_loc1_ in this._itemList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

