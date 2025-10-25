package ddt.view.caddyII
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class LookTrophy extends Frame
   {
      
      public static const SUM_NUMBER:int = 20;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<BagCell>;
      
      private var _prevBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _pageTxt:FilterFrameText;
      
      private var _boxTempIDList:Vector.<InventoryItemInfo>;
      
      private var _page:int = 1;
      
      public function LookTrophy()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc5_:BagCell = null;
         var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("caddy.TrophyBGI");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.caddy.lookFont");
         this._list = ComponentFactory.Instance.creatCustomObject("caddy.TrophyList",[5]);
         var _loc3_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("caddy.PageCountBg");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.pageTxt");
         this._prevBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.prevBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.nextBtn");
         this._items = new Vector.<BagCell>();
         this._list.beginChanges();
         var _loc4_:int = 0;
         while(_loc4_ < SUM_NUMBER)
         {
            _loc5_ = new BagCell(_loc4_);
            this._items.push(_loc5_);
            this._list.addChild(_loc5_);
            _loc4_++;
         }
         this._list.commitChanges();
         addToContent(_loc1_);
         addToContent(_loc3_);
         addToContent(_loc2_);
         addToContent(this._list);
         addToContent(this._pageTxt);
         addToContent(this._prevBtn);
         addToContent(this._nextBtn);
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("tank.view.caddy.lookTrophy");
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._prevBtn.addEventListener(MouseEvent.CLICK,this._prevClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this._nextClick);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._prevBtn))
         {
            this._prevBtn.removeEventListener(MouseEvent.CLICK,this._prevClick);
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.removeEventListener(MouseEvent.CLICK,this._nextClick);
         }
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.hide();
         }
      }
      
      private function _nextClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this.page;
         if(this.page > this.pageSum())
         {
            this.page = 1;
         }
         this.fillPage();
      }
      
      private function _prevClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this.page;
         if(this.page < 1)
         {
            this.page = this.pageSum();
         }
         this.fillPage();
      }
      
      private function fillPage() : void
      {
         var _loc1_:int = (this.page - 1) * SUM_NUMBER;
         var _loc2_:int = this.page * SUM_NUMBER;
         var _loc3_:int = 0;
         var _loc4_:int = _loc1_;
         while(_loc4_ < _loc2_)
         {
            if(_loc3_ < this._items.length && _loc4_ < this._boxTempIDList.length)
            {
               this._items[_loc3_].info = this._boxTempIDList[_loc4_];
            }
            else
            {
               this._items[_loc3_].info = null;
            }
            _loc4_++;
            _loc3_++;
         }
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      public function set page(param1:int) : void
      {
         this._page = param1;
         this._pageTxt.text = this._page + "/" + this.pageSum();
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function pageSum() : int
      {
         return Math.ceil(this._boxTempIDList.length / SUM_NUMBER);
      }
      
      public function show(param1:Vector.<InventoryItemInfo>) : void
      {
         this._boxTempIDList = param1;
         this.page = 1;
         this.fillPage();
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvents();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._prevBtn))
         {
            ObjectUtils.disposeObject(this._prevBtn);
         }
         this._prevBtn = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
         }
         this._pageTxt = null;
         if(this._items != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               ObjectUtils.disposeObject(this._items[_loc1_]);
               _loc1_++;
            }
            this._items = null;
         }
         this._boxTempIDList = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

