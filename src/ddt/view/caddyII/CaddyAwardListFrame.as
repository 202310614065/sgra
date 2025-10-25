package ddt.view.caddyII
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.items.AwardListItem;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class CaddyAwardListFrame extends Frame implements Disposeable
   {
      
      private var _panel:ScrollPanel;
      
      private var _btn:TextButton;
      
      private var _list:VBox;
      
      private var _listArray:Vector.<AwardListItem>;
      
      private var _titleBitmap:Bitmap;
      
      private var _bg:Bitmap;
      
      private var _Vline:MutipleImage;
      
      private var _descripTxt1:FilterFrameText;
      
      private var _descripTxt2:FilterFrameText;
      
      private var _descripTxt3:FilterFrameText;
      
      private var sortTitleTxt:FilterFrameText;
      
      private var NametitleTxt:FilterFrameText;
      
      private var NumbertitleTxt:FilterFrameText;
      
      private var _dataList:Object;
      
      public function CaddyAwardListFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:Bitmap = null;
         var _loc4_:AwardListItem = null;
         titleText = "Ödül değişimi";
         this._bg = ComponentFactory.Instance.creatBitmap("asset.caddy.goods.bigBack");
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc1_.x = 189;
         _loc1_.y = 123;
         _loc2_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc2_.x = 402;
         _loc2_.y = 123;
         this.sortTitleTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.paiTxt");
         this.sortTitleTxt.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.sortTitletxt");
         this.NametitleTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.nameTxt");
         this.NametitleTxt.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.nameTitletxt");
         this.NumbertitleTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.goodsTxt");
         this.NumbertitleTxt.text = LanguageMgr.GetTranslation("caddy.badLuck.propertyText.text");
         this._descripTxt1 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.goodsTxt");
         this._descripTxt1.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText6.text");
         this._descripTxt1.x = 40;
         this._descripTxt1.y = 92;
         this._descripTxt2 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.goodsTxt");
         this._descripTxt2.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText7.text");
         this._descripTxt2.x = 39;
         this._descripTxt2.y = 342;
         this._descripTxt3 = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.goodsTxt");
         this._descripTxt3.text = LanguageMgr.GetTranslation("caddy.badLuck.regulationText1.text") + "\n" + LanguageMgr.GetTranslation("caddy.badLuck.regulationText2.text") + "\n" + LanguageMgr.GetTranslation("caddy.badLuck.regulationText3.text") + "\n" + LanguageMgr.GetTranslation("caddy.badLuck.regulationText4.text") + "\n" + LanguageMgr.GetTranslation("caddy.badLuck.regulationText5.text");
         this._descripTxt3.x = 49;
         this._descripTxt3.y = 375;
         this._listArray = new Vector.<AwardListItem>();
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.caddy.titlle");
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.luckpaihangBox");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("caddy.btn1");
         this._btn.text = "Onayla";
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHander);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.LuckpaihangScrollpanel");
         this._panel.setView(this._list);
         var _loc3_:int = 1;
         while(_loc3_ < 11)
         {
            _loc4_ = new AwardListItem();
            _loc4_.initView("rezerve et" + _loc3_,"ürünler" + _loc3_,"url" + _loc3_,_loc3_);
            _loc4_.y = _loc3_ * 25;
            this._list.addChild(_loc4_);
            this._listArray.push(_loc4_);
            _loc3_++;
         }
         this._panel.invalidateViewport();
         addToContent(this._bg);
         addToContent(this.sortTitleTxt);
         addToContent(this.NametitleTxt);
         addToContent(this.NumbertitleTxt);
         addToContent(this._descripTxt1);
         addToContent(this._descripTxt2);
         addToContent(this._descripTxt3);
         addToContent(this._titleBitmap);
         addToContent(this._panel);
         addToContent(this._btn);
         addToContent(_loc1_);
         addToContent(_loc2_);
         addEventListener(FrameEvent.RESPONSE,this._response);
         RouletteManager.instance.addEventListener(CaddyEvent.LUCKSTONE_RANK_LIMIT,this.getBadLuckHandler);
         SocketManager.Instance.out.sendQequestLuckky();
      }
      
      private function getBadLuckHandler(param1:CaddyEvent) : void
      {
         this._dataList = param1.dataList;
         this.updateData();
      }
      
      private function updateData() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < 10 && _loc1_ < this._dataList.length)
         {
            _loc2_ = this._dataList[_loc1_];
            this._listArray[_loc1_].upDataUserName(_loc2_);
            _loc1_++;
         }
      }
      
      private function clickHander(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function upDataUserName() : void
      {
         var _loc1_:int = 10;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._listArray[_loc2_].upDataUserName("asdasd");
            _loc2_++;
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      override public function dispose() : void
      {
         RouletteManager.instance.removeEventListener(CaddyEvent.LUCKSTONE_RANK_LIMIT,this.getBadLuckHandler);
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHander);
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
         if(Boolean(this._btn))
         {
            ObjectUtils.disposeObject(this._btn);
         }
         this._btn = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.sortTitleTxt))
         {
            ObjectUtils.disposeObject(this.sortTitleTxt);
         }
         this.sortTitleTxt = null;
         if(Boolean(this.NametitleTxt))
         {
            ObjectUtils.disposeObject(this.NametitleTxt);
         }
         this.NametitleTxt = null;
         if(Boolean(this.NumbertitleTxt))
         {
            ObjectUtils.disposeObject(this.NumbertitleTxt);
         }
         this.NumbertitleTxt = null;
         if(Boolean(this._descripTxt1))
         {
            ObjectUtils.disposeObject(this._descripTxt1);
         }
         this._descripTxt1 = null;
         if(Boolean(this._descripTxt2))
         {
            ObjectUtils.disposeObject(this._descripTxt2);
         }
         this._descripTxt2 = null;
         if(Boolean(this._descripTxt3))
         {
            ObjectUtils.disposeObject(this._descripTxt3);
         }
         this._descripTxt3 = null;
         if(Boolean(this._titleBitmap))
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         if(Boolean(this._Vline))
         {
            ObjectUtils.disposeObject(this._Vline);
         }
         this._Vline = null;
      }
   }
}

