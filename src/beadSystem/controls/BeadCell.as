package beadSystem.controls
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.data.BeadEvent;
   import beadSystem.model.BeadModel;
   import beadSystem.views.BeadFeedInfoFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import store.view.embed.EmbedStoneCell;
   import store.view.embed.EmbedUpLevelCell;
   
   public class BeadCell extends BagCell
   {
      
      private var _lockIcon:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _beadFeedMC:MovieClip;
      
      private var _beadInfo:InventoryItemInfo;
      
      private var _itemInfo:InventoryItemInfo;
      
      private var beadFeedBtn:BeadFeedButton;
      
      public function BeadCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true)
      {
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellBgAsset");
         super(param1,param2,param3,_loc5_);
      }
      
      public function get beadPlace() : int
      {
         return _place;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:BaseAlerFrame = null;
         if(param1.source is EmbedUpLevelCell)
         {
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            if(Boolean(this.itemInfo) && int(this.itemInfo.Hole1) == 19)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.mostHightLevel"));
               return;
            }
            if(Boolean(this.itemInfo) && int(this.itemInfo.Hole1) == 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.lvOneCanntUpgrade"));
            }
            SocketManager.Instance.out.sendBeadEquip(31,this.beadPlace);
         }
         else if(param1.data is InventoryItemInfo)
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(param1.source is BeadCell)
            {
               SocketManager.Instance.out.sendBeadEquip(_loc2_.Place,this.beadPlace);
               DragManager.acceptDrag(this);
               return;
            }
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._beadInfo = _loc2_;
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            if(this.itemInfo && !this.itemInfo.IsBinds && param1.source != BeadCell)
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones1);
            }
            else
            {
               SocketManager.Instance.out.sendBeadEquip(_loc2_.Place,this.beadPlace);
            }
         }
         else if(param1.source is BeadLockButton)
         {
            DragManager.acceptDrag(this);
         }
         else if(param1.source is BeadFeedButton)
         {
            DragManager.acceptDrag(this);
         }
      }
      
      protected function __onBindRespones1(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._beadInfo.Property2 == this.info.Property2)
               {
                  SocketManager.Instance.out.sendBeadEquip(this._beadInfo.Place,this.beadPlace);
                  break;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.notType"));
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function set itemInfo(param1:InventoryItemInfo) : void
      {
         this._itemInfo = param1;
      }
      
      override public function get itemInfo() : InventoryItemInfo
      {
         return this._itemInfo;
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this.locked = false;
            this.dragShowPicTxt();
            return;
         }
         if(param1.action == DragEffect.MOVE)
         {
            this.locked = false;
            this.dragShowPicTxt();
         }
         if(param1.action == DragEffect.MOVE && !param1.target)
         {
            param1.action = DragEffect.NONE;
            if(!(param1.target is EmbedStoneCell) || !(param1.target is EmbedUpLevelCell))
            {
               if(!param1.target)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadCanntDestory"));
               }
            }
            this.locked = false;
         }
         this.dragShowPicTxt();
         super.dragStop(param1);
      }
      
      override public function set locked(param1:Boolean) : void
      {
         super.locked = param1;
         if(param1)
         {
            if(Boolean(_cellMouseOverFormer))
            {
               _cellMouseOverFormer.visible = true;
            }
         }
         else if(Boolean(_cellMouseOverFormer))
         {
            _cellMouseOverFormer.visible = false;
         }
      }
      
      public function FeedBead() : void
      {
         var _loc1_:BeadFeedInfoFrame = null;
         if(!this.itemInfo.IsUsed)
         {
            if(BeadModel.beadCanUpgrade && Boolean(this.info))
            {
               if(int(PlayerManager.Instance.Self.embedUpLevelCell.itemInfo.Hole1) == 19)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.mostHightLevel"));
                  return;
               }
               if(this._itemInfo.Hole1 >= 13)
               {
                  _loc1_ = ComponentFactory.Instance.creat("BeadFeedInfoFrame");
                  _loc1_.setBeadName(this.tipData["beadName"]);
                  LayerManager.Instance.addToLayer(_loc1_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
                  _loc1_.textInput.setFocus();
                  _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onConfigResponse);
                  return;
               }
               this.boxPrompts();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoFeedBead"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipLocked"));
         }
      }
      
      private function insteadString(param1:String, param2:String) : String
      {
         return param1.slice(param1.lastIndexOf(param2) + 1,param1.length);
      }
      
      private function boxPrompts() : void
      {
         var _loc1_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:FilterFrameText = null;
         if(this.itemInfo.IsBinds && !BeadModel.isBeadCellIsBind)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         }
         else
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.FeedBeadConfirm") + "\n\n" + LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this._itemInfo.Hole2),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowExpTextOneFeed");
            _loc3_.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this._itemInfo.Hole2);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
      }
      
      protected function __onConfigResponse(param1:FrameEvent) : void
      {
         var _loc2_:BeadFeedInfoFrame = param1.currentTarget as BeadFeedInfoFrame;
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(_loc2_.textInput.text == "YES" || _loc2_.textInput.text == "yes")
               {
                  this.boxPrompts();
                  _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
                  ObjectUtils.disposeObject(_loc2_);
                  break;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadPromptInfo"));
               break;
            default:
               _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
               ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      protected function __onBindRespones(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:FilterFrameText = null;
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.FeedBeadConfirm") + "\n\n" + LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this.itemInfo.Hole2),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowExpTextOneFeed");
               _loc3_.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadGetExp",this.itemInfo.Hole2);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      protected function __onFeedResponse(param1:FrameEvent) : void
      {
         (parent.parent as BagView).beadFeedBtn.dragAgain();
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(!this._beadFeedMC)
               {
                  this._beadFeedMC = ClassUtils.CreatInstance("beadSystem.feed.MC");
                  this._beadFeedMC.gotoAndPlay(1);
                  this._beadFeedMC.x = -10;
                  this._beadFeedMC.y = 130;
                  this._beadFeedMC.addEventListener("startFeedBead",this.__onFeedStart);
                  this._beadFeedMC.addEventListener("feedComplete",this.__onFeedComplete);
                  addChild(this._beadFeedMC);
               }
         }
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __onFeedComplete(param1:Event) : void
      {
         this._beadFeedMC.removeEventListener("startFeedBead",this.__onFeedStart);
         this._beadFeedMC.removeEventListener("feedComplete",this.__onFeedComplete);
         this._beadFeedMC.stop();
         ObjectUtils.disposeObject(this._beadFeedMC);
         this._beadFeedMC = null;
      }
      
      private function __onFeedStart(param1:Event) : void
      {
         var _loc2_:Array = new Array();
         _loc2_.push(this._place);
         SocketManager.Instance.out.sendBeadUpgrade(_loc2_);
         if(this.itemInfo.Hole2 + BeadModel.upgradeCellInfo.Hole2 >= ServerConfigManager.instance.getBeadUpgradeExp()[BeadModel.upgradeCellInfo.Hole1 + 1])
         {
            beadSystemManager.Instance.dispatchEvent(new BeadEvent(BeadEvent.PLAYUPGRADEMC));
         }
      }
      
      public function LockBead() : Boolean
      {
         if(!this.itemInfo)
         {
            return false;
         }
         if(!this.itemInfo.IsUsed)
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = true;
               setChildIndex(this._lockIcon,numChildren - 1);
            }
            else
            {
               this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
               this._lockIcon.scaleX = this._lockIcon.scaleY = 0.7;
               this.addChild(this._lockIcon);
               setChildIndex(this._lockIcon,numChildren - 1);
            }
            SocketManager.Instance.out.sendBeadLock(this._place);
         }
         else
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            SocketManager.Instance.out.sendBeadLock(this._place);
            this.itemInfo.IsUsed = false;
         }
         return true;
      }
      
      private function onStack2(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onStack2);
         _loc2_.dispose();
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:int = 0;
         if(Boolean(_info))
         {
            _tipData = null;
            this.locked = false;
            if(Boolean(this._nameTxt))
            {
               this._nameTxt.htmlText = "";
               this._nameTxt.visible = false;
            }
         }
         super.info = param1;
         if(Boolean(param1))
         {
            if(!this._nameTxt)
            {
               this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadCell.name");
               this._nameTxt.mouseEnabled = false;
               addChild(this._nameTxt);
            }
            this._nameTxt.text = BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).Name;
            this._nameTxt.visible = true;
            this.setChildIndex(this._nameTxt,this.numChildren - 1);
            tipStyle = "core.GoodsTip";
            _tipData = new GoodTipInfo();
            GoodTipInfo(_tipData).itemInfo = _info;
            if(this.itemInfo.Hole2 > 0)
            {
               GoodTipInfo(_tipData).exp = this.itemInfo.Hole2;
               GoodTipInfo(_tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[this.itemInfo.Hole1 + 1];
               GoodTipInfo(_tipData).beadName = this.itemInfo.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).Name + "Lv" + this.itemInfo.Hole1;
            }
            else
            {
               GoodTipInfo(_tipData).exp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel];
               GoodTipInfo(_tipData).upExp = ServerConfigManager.instance.getBeadUpgradeExp()[BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel + 1];
               GoodTipInfo(_tipData).beadName = this.itemInfo.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(param1.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(this.itemInfo.TemplateID).BaseLevel;
            }
            if(this.itemInfo.IsUsed)
            {
               if(Boolean(this._lockIcon))
               {
                  this._lockIcon.visible = true;
                  setChildIndex(this._lockIcon,numChildren - 1);
               }
               else
               {
                  this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
                  this._lockIcon.scaleX = this._lockIcon.scaleY = 0.7;
                  this.addChild(this._lockIcon);
               }
            }
            else if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            if(this.beadPlace >= 32 && this.beadPlace <= 81)
            {
               _loc2_ = 1;
            }
            else if(this.beadPlace >= 82 && this.beadPlace <= 131)
            {
               _loc2_ = 2;
            }
            else if(this.beadPlace >= 132 && this.beadPlace <= 181)
            {
               _loc2_ = 3;
            }
            dispatchEvent(new BeadEvent(BeadEvent.BEADCELLCHANGED,_loc2_));
         }
         else
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            if(Boolean(this._nameTxt))
            {
               this._nameTxt.visible = false;
            }
         }
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && _allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX + 10,stage.mouseY + 10,DragEffect.MOVE))
            {
               this.locked = true;
               this.dragHidePicTxt();
               if(Boolean(_info) && _pic.numChildren > 0)
               {
                  dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
               }
            }
         }
      }
      
      private function dragHidePicTxt() : void
      {
         this._nameTxt.visible = false;
         if(Boolean(this._lockIcon))
         {
            this._lockIcon.visible = false;
         }
      }
      
      private function dragShowPicTxt() : void
      {
         this._nameTxt.visible = true;
         if(this.itemInfo.IsUsed && Boolean(this._lockIcon))
         {
            this._lockIcon.visible = true;
         }
      }
      
      override protected function initTip() : void
      {
         tipDirctions = "7,6,2,1,5,4,0,3,6";
         tipGapV = 0;
         tipGapH = 0;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._lockIcon))
         {
            ObjectUtils.disposeObject(this._lockIcon);
         }
         this._lockIcon = null;
         if(Boolean(this._beadFeedMC))
         {
            ObjectUtils.disposeObject(this._beadFeedMC);
         }
         this._beadFeedMC = null;
         super.dispose();
      }
   }
}

