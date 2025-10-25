package ddt.view.caddyII.badLuck
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.CaddyEvent;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CaddyBadLuckView extends Sprite implements Disposeable
   {
      
      private var _bg:Sprite;
      
      protected var _list:VBox;
      
      protected var _panel:ScrollPanel;
      
      private var _itemList:Vector.<BadLuckItem>;
      
      private var _dataList:Vector.<Object>;
      
      private var _timer:Timer;
      
      private var _Vline:MutipleImage;
      
      public function CaddyBadLuckView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc5_:BadLuckItem = null;
         this._bg = ComponentFactory.Instance.creat("asset.caddy.badLuckBG");
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.sorttitleTxt");
         _loc1_.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.sortTitletxt");
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NametitleTxt");
         _loc2_.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.nameTitletxt");
         var _loc3_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NumbertitleTxt");
         _loc3_.text = LanguageMgr.GetTranslation("ddt.caddy.badluck.numberTitletxt");
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuckScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         this._Vline = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.Vline");
         addChild(this._bg);
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(_loc3_);
         addChild(this._panel);
         addChild(this._Vline);
         this._itemList = new Vector.<BadLuckItem>();
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc5_ = ComponentFactory.Instance.creatCustomObject("card.BadLuckItem",[_loc4_]);
            this._list.addChild(_loc5_);
            this._itemList.push(_loc5_);
            _loc4_++;
         }
         this._panel.invalidateViewport();
         this._dataList = new Vector.<Object>();
         this._timer = new Timer(30 * 60 * 1000,-1);
         this._timer.start();
         this.requestData();
      }
      
      private function initEvents() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.__oneTimer);
         RouletteManager.instance.addEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getBadLuckHandler);
      }
      
      private function removeEvents() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.__oneTimer);
         RouletteManager.instance.removeEventListener(CaddyEvent.UPDATE_BADLUCK,this.__getBadLuckHandler);
      }
      
      private function __oneTimer(param1:TimerEvent) : void
      {
         this.requestData();
      }
      
      private function requestData() : void
      {
         SocketManager.Instance.out.sendQequestBadLuck(true);
      }
      
      private function __getBadLuckHandler(param1:CaddyEvent) : void
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
            this._itemList[_loc1_].update(_loc1_,_loc2_["Nickname"],_loc2_["Count"]);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:BadLuckItem = null;
         this.removeEvents();
         for each(_loc1_ in this._itemList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._dataList = null;
         this._itemList = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
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
         if(Boolean(this._Vline))
         {
            ObjectUtils.disposeObject(this._Vline);
         }
         this._Vline = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

