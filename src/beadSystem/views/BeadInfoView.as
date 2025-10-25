package beadSystem.views
{
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.controls.BeadFeedProgress;
   import beadSystem.controls.BeadLeadManager;
   import beadSystem.controls.DrillItemInfo;
   import beadSystem.controls.DrillSelectButton;
   import beadSystem.data.BeadEvent;
   import beadSystem.data.BeadLeadEvent;
   import beadSystem.model.BeadModel;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import store.HelpFrame;
   import store.data.HoleExpModel;
   import store.view.embed.EmbedStoneCell;
   import store.view.embed.EmbedUpLevelCell;
   import store.view.embed.HoleExpBar;
   
   public class BeadInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _character:ShowCharacter;
      
      private var _pointArray:Vector.<Point>;
      
      private var _progressLevel:BeadFeedProgress;
      
      private var _holeExpBar:HoleExpBar;
      
      public var _beadGetView:BeadGetView;
      
      private var _openHoleBtn:TextButton;
      
      private var _Cells:DictionaryData;
      
      private var _HoleOpen:DictionaryData;
      
      private var _stateList:DropList;
      
      private var _stateSelectBtn:DrillSelectButton;
      
      private var _beadHoleModel:HoleExpModel;
      
      private var _beadUpGradeTxt:FilterFrameText;
      
      private var _beadFeedCell:EmbedUpLevelCell;
      
      private var _helpButton:BaseButton;
      
      public function BeadInfoView()
      {
         super();
         this._HoleOpen = new DictionaryData();
         this.initView();
         this.initBeadEquip();
      }
      
      private function initView() : void
      {
         var _loc1_:EmbedStoneCell = null;
         var _loc2_:EmbedStoneCell = null;
         var _loc3_:EmbedStoneCell = null;
         var _loc4_:int = 0;
         var _loc5_:EmbedStoneCell = null;
         var _loc6_:EmbedStoneCell = null;
         var _loc7_:EmbedStoneCell = null;
         var _loc8_:EmbedStoneCell = null;
         var _loc10_:EmbedStoneCell = null;
         var _loc11_:EmbedStoneCell = null;
         this._Cells = new DictionaryData();
         this._bg = ComponentFactory.Instance.creatBitmap("beadSystem.info.bg");
         this.getCellsPoint();
         addChild(this._bg);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[1,1]);
         _loc1_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint1")).x;
         _loc1_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint1")).y;
         _loc1_.StoneType = 1;
         addChild(_loc1_);
         this._Cells.add(1,_loc1_);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[2,2]);
         _loc2_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint2")).x;
         _loc2_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint2")).y;
         _loc2_.StoneType = 2;
         addChild(_loc2_);
         this._Cells.add(2,_loc2_);
         _loc3_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[3,2]);
         _loc3_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint3")).x;
         _loc3_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint3")).y;
         _loc3_.StoneType = 2;
         addChild(_loc3_);
         this._Cells.add(3,_loc3_);
         _loc4_ = 4;
         while(_loc4_ <= 12)
         {
            _loc11_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[_loc4_,3]);
            _loc11_.StoneType = 3;
            _loc11_.x = this._pointArray[_loc4_ - 1].x;
            _loc11_.y = this._pointArray[_loc4_ - 1].y;
            addChild(_loc11_);
            this._Cells.add(_loc4_,_loc11_);
            _loc4_++;
         }
         _loc5_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[13,3]);
         _loc5_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint13")).x;
         _loc5_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint13")).y;
         _loc5_.StoneType = 3;
         addChild(_loc5_);
         this._Cells.add(13,_loc5_);
         this._HoleOpen.add(13,_loc5_);
         _loc6_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[14,3]);
         _loc6_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint14")).x;
         _loc6_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint14")).y;
         _loc6_.StoneType = 3;
         addChild(_loc6_);
         this._Cells.add(14,_loc6_);
         this._HoleOpen.add(14,_loc6_);
         _loc7_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[15,3]);
         _loc7_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint15")).x;
         _loc7_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint15")).y;
         _loc7_.StoneType = 3;
         addChild(_loc7_);
         this._Cells.add(15,_loc7_);
         this._HoleOpen.add(15,_loc7_);
         _loc8_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[16,3]);
         _loc8_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint16")).x;
         _loc8_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint16")).y;
         _loc8_.StoneType = 3;
         addChild(_loc8_);
         this._Cells.add(16,_loc8_);
         this._HoleOpen.add(16,_loc8_);
         var _loc9_:EmbedStoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[17,3]);
         _loc9_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint17")).x;
         _loc9_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint17")).y;
         _loc9_.StoneType = 3;
         addChild(_loc9_);
         this._Cells.add(17,_loc9_);
         this._HoleOpen.add(17,_loc9_);
         _loc10_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[18,3]);
         _loc10_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint18")).x;
         _loc10_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.Embedpoint18")).y;
         _loc10_.StoneType = 3;
         addChild(_loc10_);
         this._Cells.add(18,_loc10_);
         this._HoleOpen.add(18,_loc10_);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("beadSystem.FeedProgress");
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         this._progressLevel.scaleX = this._progressLevel.scaleY = 0.8;
         addChild(this._progressLevel);
         this._holeExpBar = ComponentFactory.Instance.creatCustomObject("beadSystem.HoleExpBar");
         this._holeExpBar.visible = true;
         this._holeExpBar.setProgress(0);
         this._holeExpBar.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.HoleNoSelect");
         addChild(this._holeExpBar);
         this._beadFeedCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedUpLevelCell");
         this._beadFeedCell.x = this._pointArray[18].x;
         this._beadFeedCell.y = this._pointArray[18].y;
         addChild(this._beadFeedCell);
         BeadLeadManager.Instance.addEventListener(BeadLeadEvent.SPALINGUPLEVELCELL,this.spalingUpLevelCell);
         this._beadGetView = ComponentFactory.Instance.creatCustomObject("beadGetView");
         addChild(this._beadGetView);
         this._openHoleBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.openHole");
         this._openHoleBtn.text = LanguageMgr.GetTranslation("ddt.beadSystem.OpenHoleText");
         this._openHoleBtn.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.OpenHoleText");
         addChild(this._openHoleBtn);
         this._stateSelectBtn = ComponentFactory.Instance.creatCustomObject("beadSystem.DrillButton");
         addChild(this._stateSelectBtn);
         this._stateList = ComponentFactory.Instance.creatComponentByStylename("beadSystem.drillList");
         this._stateList.targetDisplay = this._stateSelectBtn;
         this._stateList.showLength = 5;
         this._beadUpGradeTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.upderBeadUpgradeCell.Text");
         this._beadUpGradeTxt.text = LanguageMgr.GetTranslation("ddt.beadSystem.underBeadFeedCellTxt");
         addChild(this._beadUpGradeTxt);
         this._helpButton = ComponentFactory.Instance.creatComponentByStylename("beadSystem.btnHelp");
         addChild(this._helpButton);
         this.updateBtn();
         this.initEvent();
         this.initHoleExp();
         BeadModel._BeadCells = this._HoleOpen;
      }
      
      private function spalingUpLevelCell(param1:BeadLeadEvent) : void
      {
         if(Boolean(this._beadFeedCell))
         {
            BeadLeadManager.Instance.spalingUpLevelCell(this._beadFeedCell);
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(this.visible)
         {
            this._beadGetView.removeTimer();
         }
         super.visible = param1;
      }
      
      private function loadStateList() : void
      {
         this._stateList.dataList = BeadModel.getDrillsIgnoreBindState().list.sort(this.drillSortFun);
      }
      
      private function __stateSelectClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(this._stateList.parent == null)
         {
            addChild(this._stateList);
            this._stateList.dataList = BeadModel.getDrillsIgnoreBindState().list.sort(this.drillSortFun);
         }
         else
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function drillSortFun(param1:DrillItemInfo, param2:DrillItemInfo) : int
      {
         return param1.itemInfo.Level - param2.itemInfo.Level;
      }
      
      private function __feedCellChanged(param1:BeadEvent) : void
      {
         var _loc2_:EmbedUpLevelCell = param1.currentTarget as EmbedUpLevelCell;
         if(Boolean(_loc2_.info))
         {
            this._progressLevel.currentExp = _loc2_.invenItemInfo.Hole2;
            if(_loc2_.invenItemInfo.Hole1 < 19)
            {
               this._progressLevel.upLevelExp = ServerConfigManager.instance.getBeadUpgradeExp()[_loc2_.invenItemInfo.Hole1 + 1];
            }
            this._progressLevel.intProgress(_loc2_.invenItemInfo);
         }
         else
         {
            this._progressLevel.resetProgress();
         }
      }
      
      private function __onOpenHoleClick(param1:MouseEvent) : void
      {
         var _loc3_:EmbedStoneCell = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = this.getSelectedHoleIndex();
         if(_loc2_ == -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipHoleNotSelected"));
            return;
         }
         for each(_loc3_ in this._HoleOpen)
         {
            if(_loc3_.selected)
            {
               if(_loc3_.HoleLv == int(LanguageMgr.GetTranslation("ddt.beadSystem.MaxHoleLevel")))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.MaxHoleLevelText"));
                  break;
               }
               if(_loc2_ >= 0 && Boolean(this._stateSelectBtn.DrillItem))
               {
                  if(_loc3_.HoleLv == this._stateSelectBtn.DrillItem.Level - 1)
                  {
                     if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._stateSelectBtn.DrillItem.TemplateID) > 0)
                     {
                        SocketManager.Instance.out.sendBeadOpenHole(_loc2_,this._stateSelectBtn.DrillItem.TemplateID);
                        break;
                     }
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.noEnoughDrills"));
                     break;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipErrorDrills"));
                  break;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.tipNoDrillSelected"));
               break;
            }
         }
      }
      
      private function updateBtn() : void
      {
         if(BeadModel.getDrills().length <= 0)
         {
            this._stateSelectBtn.setValue(null);
         }
         this._stateSelectBtn.mouseChildren = this._stateSelectBtn.mouseEnabled = BeadModel.getDrills().length > 0;
         this._stateSelectBtn.filters = BeadModel.getDrills().length > 0 ? null : ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      public function startShine(param1:ItemTemplateInfo) : void
      {
         var _loc3_:EmbedStoneCell = null;
         var _loc2_:InventoryItemInfo = param1 as InventoryItemInfo;
         for each(_loc3_ in this._Cells)
         {
            if(!_loc3_.info && param1.Property2 == _loc3_.StoneType.toString() && _loc3_.isOpend)
            {
               if(_loc3_.ID < 13)
               {
                  _loc3_.startShine();
               }
               else if(beadSystemManager.Instance.judgeLevel(int(_loc2_.Hole1),_loc3_.HoleLv))
               {
                  _loc3_.startShine();
               }
            }
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:EmbedStoneCell = null;
         for each(_loc1_ in this._Cells)
         {
            _loc1_.stopShine();
         }
      }
      
      private function getSelectedHoleIndex() : int
      {
         var _loc2_:EmbedStoneCell = null;
         var _loc1_:int = -1;
         for each(_loc2_ in this._HoleOpen)
         {
            if(_loc2_.selected)
            {
               _loc1_ = _loc2_.ID;
               break;
            }
         }
         return this.getHoleIndex(_loc1_);
      }
      
      private function getHoleIndex(param1:int) : int
      {
         var _loc2_:int = -1;
         switch(param1)
         {
            case 13:
               _loc2_ = 0;
               break;
            case 14:
               _loc2_ = 1;
               break;
            case 15:
               _loc2_ = 2;
               break;
            case 16:
               _loc2_ = 3;
               break;
            case 17:
               _loc2_ = 4;
               break;
            case 18:
               _loc2_ = 5;
               break;
            default:
               _loc2_ = -1;
         }
         return _loc2_;
      }
      
      private function initEvent() : void
      {
         var _loc1_:EmbedStoneCell = null;
         beadSystemManager.Instance.addEventListener(BeadEvent.LIGHTBTN,this.__LightBtn);
         beadSystemManager.Instance.addEventListener(BeadEvent.OPENBEADHOLE,this.__onOpenHole);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.addEventListener(BeadEvent.EQUIPBEAD,this.__beadCellChanged);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__onPropBagUpdate);
         this._openHoleBtn.addEventListener(MouseEvent.CLICK,this.__onOpenHoleClick);
         this._stateSelectBtn.addEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         this._beadFeedCell.addEventListener(BeadEvent.BEADCELLCHANGED,this.__feedCellChanged);
         this._beadFeedCell.addEventListener(CellEvent.ITEM_CLICK,this.__onFeedCellClick);
         for each(_loc1_ in this._Cells)
         {
            _loc1_.addEventListener(CellEvent.ITEM_CLICK,this.__clickHandler);
            _loc1_.addEventListener(CellEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         }
         this._helpButton.addEventListener(MouseEvent.CLICK,this.__help);
      }
      
      private function removeEvent() : void
      {
         beadSystemManager.Instance.removeEventListener(BeadEvent.LIGHTBTN,this.__LightBtn);
         beadSystemManager.Instance.removeEventListener(BeadEvent.OPENBEADHOLE,this.__onOpenHole);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.removeEventListener(BeadEvent.EQUIPBEAD,this.__beadCellChanged);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__onPropBagUpdate);
         this._openHoleBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenHoleClick);
         this._stateSelectBtn.removeEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         this._beadFeedCell.removeEventListener(BeadEvent.BEADCELLCHANGED,this.__feedCellChanged);
         this._beadFeedCell.removeEventListener(CellEvent.ITEM_CLICK,this.__onFeedCellClick);
         this._helpButton.removeEventListener(MouseEvent.CLICK,this.__help);
      }
      
      private function __help(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("beadSystem.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("beadSystem.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("ddt.beadSystem.beadDisc");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __onPropBagUpdate(param1:Event) : void
      {
         this.updateBtn();
         this._stateSelectBtn.DrillItem;
      }
      
      private function __hideStateList(param1:MouseEvent) : void
      {
         if(Boolean(this._stateList.parent))
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function __onOpenHole(param1:BeadEvent) : void
      {
         this.initHoleExp();
      }
      
      private function initHoleExp() : void
      {
         if(BeadModel.drillInfo.length > 0)
         {
            this._HoleOpen[13].HoleExp = BeadModel.drillInfo[131];
            this._HoleOpen[14].HoleExp = BeadModel.drillInfo[141];
            this._HoleOpen[15].HoleExp = BeadModel.drillInfo[151];
            this._HoleOpen[16].HoleExp = BeadModel.drillInfo[161];
            this._HoleOpen[17].HoleExp = BeadModel.drillInfo[171];
            this._HoleOpen[18].HoleExp = BeadModel.drillInfo[181];
            this._HoleOpen[13].HoleLv = BeadModel.drillInfo[132];
            this._HoleOpen[14].HoleLv = BeadModel.drillInfo[142];
            this._HoleOpen[15].HoleLv = BeadModel.drillInfo[152];
            this._HoleOpen[16].HoleLv = BeadModel.drillInfo[162];
            this._HoleOpen[17].HoleLv = BeadModel.drillInfo[172];
            this._HoleOpen[18].HoleLv = BeadModel.drillInfo[182];
            this.updateHoleProgress();
         }
      }
      
      private function __LightBtn(param1:BeadEvent) : void
      {
         this._beadGetView.buttonState(param1.CellId);
      }
      
      private function __beadCellChanged(param1:Event) : void
      {
         this.initBeadEquip();
      }
      
      private function updateHoleProgress() : void
      {
         var _loc1_:EmbedStoneCell = null;
         for each(_loc1_ in this._HoleOpen)
         {
            if(_loc1_.selected)
            {
               if(_loc1_.HoleLv > BeadModel.tempHoleLv)
               {
                  _loc1_.holeLvUp();
                  BeadModel.tempHoleLv = _loc1_.HoleLv;
                  this.showDrill(_loc1_.HoleLv);
               }
               this._holeExpBar.setProgress(_loc1_.HoleExp,BeadModel.getHoleExpByLv(_loc1_.HoleLv));
               this._holeExpBar.tipData = _loc1_.HoleLv + LanguageMgr.GetTranslation("store.embem.HoleTip.Level") + ":" + _loc1_.HoleExp + "/" + BeadModel.getHoleExpByLv(_loc1_.HoleLv);
               break;
            }
         }
      }
      
      protected function __clickHandler(param1:CellEvent) : void
      {
         var _loc3_:EmbedStoneCell = null;
         var _loc4_:EmbedStoneCell = null;
         SoundManager.instance.play("008");
         var _loc2_:EmbedStoneCell = param1.currentTarget as EmbedStoneCell;
         if(_loc2_.selected)
         {
            _loc2_.dragStart();
            return;
         }
         for each(_loc3_ in this._Cells)
         {
            if(_loc3_.ID < 16)
            {
               if(_loc3_.ID == _loc2_.ID)
               {
                  this._holeExpBar.setProgress(0);
                  this._holeExpBar.tipData = LanguageMgr.GetTranslation("ddt.beadSystem.HoleNoSelect");
                  break;
               }
            }
         }
         for each(_loc4_ in this._HoleOpen)
         {
            if(_loc4_.ID == _loc2_.ID)
            {
               BeadModel.tempHoleLv = _loc4_.HoleLv;
               _loc2_.selected = true;
               this._holeExpBar.setProgress(_loc4_.HoleExp,BeadModel.getHoleExpByLv(_loc4_.HoleLv));
               this._holeExpBar.tipData = _loc4_.HoleLv + LanguageMgr.GetTranslation("store.embem.HoleTip.Level") + ":" + _loc4_.HoleExp + "/" + BeadModel.getHoleExpByLv(_loc4_.HoleLv);
               this.showDrill(_loc4_.HoleLv);
            }
            else
            {
               _loc4_.selected = false;
            }
         }
         if(_loc2_.ID < 13)
         {
            _loc2_.dragStart();
         }
      }
      
      private function showDrill(param1:int) : void
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = 11035;
               break;
            case 1:
               _loc2_ = 11036;
               break;
            case 2:
               _loc2_ = 11026;
               break;
            case 3:
               _loc2_ = 11027;
               break;
            case 4:
               _loc2_ = 11034;
         }
         var _loc3_:Array = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_loc2_);
         if(_loc3_.length == 0 || param1 == 5)
         {
            if(param1 != 5)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.Embed.OpenHole.NoDrill",param1 + 1));
            }
            return;
         }
         var _loc4_:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc2_);
         var _loc5_:DrillItemInfo = new DrillItemInfo();
         _loc5_.itemInfo = _loc3_[0];
         _loc5_.amount = _loc4_;
         this._stateSelectBtn.setValue(_loc5_);
      }
      
      private function __doubleClickHandler(param1:CellEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:EmbedStoneCell = param1.data as EmbedStoneCell;
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         SocketManager.Instance.out.sendBeadEquip(_loc3_.Place,-1);
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 1;
         while(_loc1_ <= 19)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("bead.Embedpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initBeadEquip() : void
      {
         var _loc1_:EmbedStoneCell = null;
         var _loc2_:EmbedStoneCell = null;
         for each(_loc1_ in this._Cells)
         {
            _loc1_.info = null;
         }
         for each(_loc2_ in this._Cells)
         {
            _loc2_.itemInfo = PlayerManager.Instance.Self.BeadBag.getItemAt(_loc2_.ID);
            _loc2_.info = PlayerManager.Instance.Self.BeadBag.getItemAt(_loc2_.ID);
         }
         this._beadFeedCell.invenItemInfo = this._beadFeedCell.itemInfo = PlayerManager.Instance.Self.BeadBag.getItemAt(31);
         this._beadFeedCell.info = PlayerManager.Instance.Self.BeadBag.getItemAt(31);
      }
      
      private function __onFeedCellClick(param1:CellEvent) : void
      {
         var _loc2_:EmbedUpLevelCell = param1.currentTarget as EmbedUpLevelCell;
         if(Boolean(_loc2_.info))
         {
            _loc2_.dragStart();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:EmbedStoneCell = null;
         this.removeEvent();
         this._openHoleBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenHoleClick);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._progressLevel))
         {
            ObjectUtils.disposeObject(this._progressLevel);
         }
         this._progressLevel = null;
         if(Boolean(this._holeExpBar))
         {
            ObjectUtils.disposeObject(this._holeExpBar);
         }
         this._holeExpBar = null;
         if(Boolean(this._beadGetView))
         {
            ObjectUtils.disposeObject(this._beadGetView);
         }
         this._beadGetView = null;
         if(Boolean(this._openHoleBtn))
         {
            ObjectUtils.disposeObject(this._openHoleBtn);
         }
         this._openHoleBtn = null;
         if(Boolean(this._stateList))
         {
            ObjectUtils.disposeObject(this._stateList);
         }
         this._stateList = null;
         if(Boolean(this._stateSelectBtn))
         {
            ObjectUtils.disposeObject(this._stateSelectBtn);
         }
         this._stateSelectBtn = null;
         if(Boolean(this._beadFeedCell))
         {
            ObjectUtils.disposeObject(this._beadFeedCell);
         }
         this._beadFeedCell = null;
         if(Boolean(this._beadUpGradeTxt))
         {
            ObjectUtils.disposeObject(this._beadUpGradeTxt);
         }
         this._beadUpGradeTxt = null;
         if(this._Cells.length > 0)
         {
            for each(_loc1_ in this._Cells)
            {
               _loc1_.removeEventListener(CellEvent.ITEM_CLICK,this.__clickHandler);
               _loc1_.removeEventListener(CellEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         if(Boolean(this._helpButton))
         {
            ObjectUtils.disposeObject(this._helpButton);
         }
         this._helpButton = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

