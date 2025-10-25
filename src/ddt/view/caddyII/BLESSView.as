package ddt.view.caddyII
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.caddyII.bead.BeadCell;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class BLESSView extends RightView
   {
      
      public static const GOODSNUMBER:int = 25;
      
      public static const SELECT_SCALE_NUMBER:Number = 0;
      
      public static const SCALE_NUMBER:Number = 0.1;
      
      private var _bg:ScaleBitmapImage;
      
      private var _gridBGI:MovieImage;
      
      private var _lookBtn:TextButton;
      
      private var _openBtn:BaseButton;
      
      private var _turnBG:ScaleFrameImage;
      
      private var _movie:MovieImage;
      
      private var _Vipmovie:MovieImage;
      
      private var _keyBtn:BaseButton;
      
      private var _paiBtn:TextButton;
      
      private var _boxBtn:BaseButton;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectCell:BaseCell;
      
      private var _turnCell:BeadCell;
      
      private var _keyNumberTxt:FilterFrameText;
      
      private var _boxNumberTxt:FilterFrameText;
      
      private var _lookTrophy:LookTrophy;
      
      private var _keyNumber:int;
      
      private var _boxNumber:int;
      
      private var _selectedCount:int;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _templateIDList:Vector.<int>;
      
      private var _vipDescTxt:FilterFrameText;
      
      private var _vipIcon:Image;
      
      private var _endFrame:int;
      
      private var _selectSprite:Sprite;
      
      private var _turnSprite:Sprite;
      
      private var _startY:Number;
      
      private var _effect:IEffect;
      
      private var _cellMC:MovieClip;
      
      private var _GoldCell:MovieClip;
      
      private var _SiverCell:MovieClip;
      
      private var _listView:CaddyAwardListFrame;
      
      private var isActive:Boolean = false;
      
      public function BLESSView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function setType(param1:int) : void
      {
         _type = param1;
         if(_type == EquipType.BOMB_KING_BLESS)
         {
         }
         this.creatTweenMagnify();
      }
      
      override public function set item(param1:ItemTemplateInfo) : void
      {
         if(_item != param1)
         {
            _item = param1;
            if(_item.TemplateID == EquipType.BOMB_KING_BLESS)
            {
               this._cellMC.visible = true;
               this._GoldCell.visible = false;
               this._SiverCell.visible = false;
               this._boxBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBless");
            }
            else if(_item.TemplateID == EquipType.SILVER_BLESS)
            {
               this._cellMC.visible = false;
               this._GoldCell.visible = false;
               this._SiverCell.visible = true;
               this._boxBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBless2");
            }
            else if(_item.TemplateID == EquipType.GOLD_BLESS)
            {
               this._cellMC.visible = false;
               this._GoldCell.visible = true;
               this._SiverCell.visible = false;
               this._boxBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBless1");
            }
            this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_item.TemplateID);
         }
      }
      
      private function initView() : void
      {
         var _loc3_:Image = null;
         var _loc1_:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("bead.rightGrid.goldBorder");
         this._vipDescTxt = ComponentFactory.Instance.creatComponentByStylename("asset.caddy.VipDescTxt");
         this._vipDescTxt.text = LanguageMgr.GetTranslation("tank.view.caddy.VipDescTxt");
         this._vipIcon = ComponentFactory.Instance.creatComponentByStylename("caddy.VipIcon");
         var _loc2_:Image = ComponentFactory.Instance.creatComponentByStylename("caddy.GoodsNameBG");
         _loc3_ = ComponentFactory.Instance.creatComponentByStylename("caddy.numberI");
         PositionUtils.setPos(_loc3_,"CaddyViewII.numberIPos");
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.bead.openBG");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.rightBG");
         this._gridBGI = ComponentFactory.Instance.creatComponentByStylename("caddy.rightGridBGI");
         this._lookBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.LookBtn");
         this._lookBtn.text = LanguageMgr.GetTranslation("tank.view.caddy.lookTrophy");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.OpenBtn");
         this._keyBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.KeyBtn");
         this._keyBtn.addChild(this.creatShape());
         this._boxBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.BlessBtn");
         this._boxBtn.addChild(this.creatShape());
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.goodsNameTxt");
         this._keyNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.keyNumberTxt");
         this._boxNumberTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.boxNumberTxt");
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("bead.turnSprite");
         this._cellMC = ComponentFactory.Instance.creat("asset.Bless.play");
         PositionUtils.setPos(this._cellMC,"caddyII.bless.point");
         this._GoldCell = ComponentFactory.Instance.creat("asset.GoldBless.play");
         PositionUtils.setPos(this._GoldCell,"caddyII.bless.point");
         this._GoldCell.visible = false;
         this._SiverCell = ComponentFactory.Instance.creat("asset.SiverBless.play");
         PositionUtils.setPos(this._SiverCell,"caddyII.bless.point");
         this._SiverCell.visible = false;
         this._turnCell = new BeadCell();
         this._turnCell.info = ItemManager.Instance.getTemplateById(EquipType.BOMB_KING_BLESS);
         this._movie = ComponentFactory.Instance.creatComponentByStylename("bead.movieAsset");
         var _loc5_:int = 0;
         while(_loc5_ < this._movie.movie.currentLabels.length)
         {
            if(this._movie.movie.currentLabels[_loc5_].name == "endFrame")
            {
               this._endFrame = this._movie.movie.currentLabels[_loc5_].frame;
            }
            _loc5_++;
         }
         this._Vipmovie = ComponentFactory.Instance.creatComponentByStylename("bead.VipmovieAsset");
         var _loc6_:int = 0;
         while(_loc6_ < this._Vipmovie.movie.currentLabels.length)
         {
            if(this._Vipmovie.movie.currentLabels[_loc6_].name == "endFrame")
            {
               this._endFrame = this._Vipmovie.movie.currentLabels[_loc6_].frame;
            }
            _loc6_++;
         }
         this._lookTrophy = ComponentFactory.Instance.creatCustomObject("caddyII.LookTrophy");
         _autoCheck = ComponentFactory.Instance.creatComponentByStylename("AutoOpenButton");
         _autoCheck.text = LanguageMgr.GetTranslation("tank.view.award.auto");
         _autoCheck.selected = SharedManager.Instance.autoCaddy;
         var _loc7_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("caddy.bagHavingTip");
         _loc7_.text = LanguageMgr.GetTranslation("tank.view.award.bagHaving");
         this._paiBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.awardListBtn");
         this._paiBtn.text = "排行奖励";
         addChild(this._bg);
         addChild(this._gridBGI);
         addChild(_loc1_);
         addChild(this._vipDescTxt);
         addChild(this._vipIcon);
         addChild(_loc2_);
         addChild(_loc3_);
         addChild(this._lookBtn);
         addChild(this._openBtn);
         addChild(this._boxBtn);
         addChild(this._goodsNameTxt);
         addChild(_loc4_);
         this._turnSprite.addChild(this._turnCell);
         addChild(this._cellMC);
         addChild(this._GoldCell);
         addChild(this._SiverCell);
         addChild(this._boxNumberTxt);
         addChild(_loc1_);
         addChild(_autoCheck);
         addChild(_loc7_);
         this._startY = this._turnSprite.y;
         this.createSelectCell();
         addChild(this._movie);
         this._movie.movie.stop();
         this._movie.visible = false;
         addChild(this._Vipmovie);
         addChild(this._paiBtn);
         this._Vipmovie.movie.stop();
         this._Vipmovie.visible = false;
         this._keyBtn.tipData = LanguageMgr.GetTranslation("tank.view.caddy.quickBuyKey");
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.BOMB_KING_BLESS);
         this.creatTweenMagnify();
         this.creatEffect();
         this.updateItemShape();
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.addEventListener(MouseEvent.CLICK,this._look);
         this._paiBtn.addEventListener(MouseEvent.CLICK,this.paihangHander);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openClick);
         this._movie.movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._Vipmovie.movie.addEventListener(Event.ENTER_FRAME,this.__VipframeHandler);
         this._keyBtn.addEventListener(MouseEvent.CLICK,this._buyKey);
         _autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      protected function paihangHander(param1:MouseEvent) : void
      {
         this._listView = ComponentFactory.Instance.creatComponentByStylename("caddyAwardListFrame");
         LayerManager.Instance.addToLayer(this._listView,LayerManager.GAME_TOP_LAYER,true,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._bagUpdate);
         this._lookBtn.removeEventListener(MouseEvent.CLICK,this._look);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openClick);
         this._movie.movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._Vipmovie.movie.removeEventListener(Event.ENTER_FRAME,this.__VipframeHandler);
         this._keyBtn.removeEventListener(MouseEvent.CLICK,this._buyKey);
         _autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
      }
      
      private function updateItemShape() : void
      {
         this._turnCell.x = this._turnCell.width / -2;
         this._turnCell.y = -89;
      }
      
      private function createSelectCell() : void
      {
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("bead.selectCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         _loc2_.graphics.endFill();
         this._selectCell = new BaseCell(_loc2_);
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("bead.SelectSprite");
         this._selectCell.x = this._selectCell.width / -2;
         this._selectCell.y = this._selectCell.height / -2;
         this._selectSprite.addChild(this._selectCell);
         addChild(this._selectSprite);
         this._selectSprite.visible = false;
      }
      
      private function _bagUpdate(param1:BagEvent) : void
      {
         this.keyNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.CADDY_KEY);
         this.boxNumber = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_item.TemplateID);
      }
      
      private function _look(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(EquipType.isCaddy(_item) || EquipType.isBless(_item))
         {
            this._lookTrophy.show(CaddyModel.instance.getCaddyTrophy(_item.TemplateID));
         }
      }
      
      private function __openClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(CaddyModel.instance.bagInfo.itemNumber >= 25)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            return;
         }
         this.openImp();
      }
      
      private function hasKey() : Boolean
      {
         var _loc1_:BuffInfo = PlayerManager.Instance.Self.getBuff(BuffInfo.Caddy_Good);
         if(_loc1_ != null && _loc1_.ValidCount > 0)
         {
            return this.keyNumber + 1 >= 4;
         }
         return this.keyNumber >= 4;
      }
      
      private function openImp() : void
      {
         var _loc1_:Boolean = this.hasKey();
         if(this.boxNumber >= 1)
         {
            if(CaddyModel.instance.bagInfo.itemNumber < 25)
            {
               this._openBtn.enable = false;
            }
            this.getRandomTempId();
            SocketManager.Instance.out.sendRouletteBox(BagInfo.CADDYBAG,-1,_item.TemplateID);
         }
         else if(this.boxNumber < 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyBox",_item.Name));
         }
      }
      
      private function _quickBuy() : void
      {
         this._buyKey(null);
      }
      
      private function _buyKey(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._showQuickBuy(QuickBuyCaddy.CADDYKEY_NUMBER);
      }
      
      private function _showQuickBuy(param1:int) : void
      {
         var _loc2_:QuickBuyCaddy = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyCaddy");
         _loc2_.show(param1);
      }
      
      private function getRandomTempId() : void
      {
         var _loc8_:int = 0;
         var _loc1_:Vector.<BoxGoodsTempInfo> = BossBoxManager.instance.caddyBoxGoodsInfo;
         this._templateIDList = new Vector.<int>();
         var _loc2_:int = 0;
         var _loc3_:int = Math.floor(_loc1_.length / GOODSNUMBER);
         var _loc4_:int = Math.floor(Math.random() * _loc3_);
         _loc4_ = _loc4_ == 0 ? 1 : _loc4_;
         var _loc5_:int = 1;
         while(_loc5_ <= GOODSNUMBER)
         {
            if(_loc4_ * _loc5_ < _loc1_.length)
            {
               this._templateIDList.push(_loc1_[_loc4_ * _loc5_].TemplateId);
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this._templateIDList.length)
         {
            _loc8_ = Math.floor(Math.random() * this._templateIDList.length);
            _loc6_ = this._templateIDList[_loc7_];
            this._templateIDList[_loc7_] = this._templateIDList[_loc8_];
            this._templateIDList[_loc8_] = _loc6_;
            _loc7_++;
         }
      }
      
      private function __selectedChanged(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoCaddy = _autoCheck.selected;
      }
      
      private function creatShape(param1:Number = 100, param2:Number = 25) : Shape
      {
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("caddy.QuickBuyBtn.ButtonSize");
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,_loc3_.x,_loc3_.y);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      private function __frameHandler(param1:Event) : void
      {
         if(this._movie.movie.currentFrame == this._endFrame)
         {
            this._selectSprite.visible = true;
            this._goodsNameTxt.text = this._selectedGoodsInfo.Name;
            this.creatTweenSelectMagnify();
         }
      }
      
      private function __VipframeHandler(param1:Event) : void
      {
         if(this._Vipmovie.movie.currentFrame == this._endFrame)
         {
            this._selectSprite.visible = true;
            this._goodsNameTxt.text = this._selectedGoodsInfo.Name;
            this.creatTweenSelectMagnify();
         }
      }
      
      private function creatTweenSelectMagnify() : void
      {
         TweenMax.from(this._selectSprite,0.7,{
            "scaleX":SELECT_SCALE_NUMBER,
            "scaleY":SELECT_SCALE_NUMBER,
            "y":320,
            "alpha":20,
            "onComplete":this._moveOk,
            "ease":Elastic.easeOut
         });
      }
      
      private function creatTweenMagnify() : void
      {
         TweenLite.killTweensOf(this._turnSprite);
         this._turnSprite.scaleX = this._turnSprite.scaleY = 1;
         this._turnSprite.y = this._startY;
         TweenLite.from(this._turnSprite,0.5,{
            "scaleX":SCALE_NUMBER,
            "scaleY":SCALE_NUMBER
         });
         TweenLite.to(this._turnSprite,0.4,{
            "delay":0.5,
            "y":this._startY + 4,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      private function creatEffect() : void
      {
         this._effect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._turnCell,{
            "color":EffectColorType.GOLD,
            "speed":0.4,
            "blurWidth":10,
            "intensity":40,
            "strength":0.6
         });
         this._effect.play();
      }
      
      private function _moveOk() : void
      {
         setTimeout(this._toMove,400);
      }
      
      private function _toMove() : void
      {
         dispatchEvent(new Event(RightView.START_MOVE_AFTER_TURN));
         if(Boolean(this._selectCell))
         {
            this._selectCell.info = null;
         }
         if(Boolean(this._selectSprite))
         {
            this._selectSprite.visible = false;
         }
         if(_type == EquipType.BOMB_KING_BLESS)
         {
            if(Boolean(this._goodsNameTxt))
            {
               this._goodsNameTxt.text = ItemManager.Instance.getTemplateById(_type).Name;
            }
         }
      }
      
      public function set keyNumber(param1:int) : void
      {
         this._keyNumber = param1;
         this._keyNumberTxt.text = String(this._keyNumber);
      }
      
      public function get keyNumber() : int
      {
         return this._keyNumber;
      }
      
      public function set boxNumber(param1:int) : void
      {
         this._boxNumber = param1;
         this._boxNumberTxt.text = String(this._boxNumber);
      }
      
      public function get boxNumber() : int
      {
         return this._boxNumber;
      }
      
      override public function again() : void
      {
         this._turnSprite.visible = true;
         if(_item.TemplateID == EquipType.BOMB_KING_BLESS)
         {
            this._cellMC.visible = true;
            this._GoldCell.visible = false;
            this._SiverCell.visible = false;
         }
         else if(_item.TemplateID == EquipType.SILVER_BLESS)
         {
            this._cellMC.visible = false;
            this._GoldCell.visible = false;
            this._SiverCell.visible = true;
         }
         else if(_item.TemplateID == EquipType.GOLD_BLESS)
         {
            this._cellMC.visible = false;
            this._GoldCell.visible = true;
            this._SiverCell.visible = false;
         }
         this._movie.visible = false;
         this._movie.movie.gotoAndStop(1);
         this._Vipmovie.visible = false;
         this._Vipmovie.movie.gotoAndStop(1);
         this._selectSprite.visible = false;
         this._openBtn.enable = true;
         if(SharedManager.Instance.autoCaddy)
         {
            if(CaddyModel.instance.bagInfo.itemNumber >= 25)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.FullBag"));
            }
            else if(this.boxNumber < 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.EmptyBox",_item.Name));
            }
            else
            {
               this.openImp();
            }
         }
      }
      
      override public function setSelectGoodsInfo(param1:InventoryItemInfo) : void
      {
         SoundManager.instance.play("139");
         this._selectedGoodsInfo = param1;
         this._turnSprite.visible = false;
         if(_item.TemplateID == EquipType.BOMB_KING_BLESS)
         {
            this._cellMC.visible = false;
            this._GoldCell.visible = false;
            this._SiverCell.visible = false;
         }
         else if(_item.TemplateID == EquipType.SILVER_BLESS)
         {
            this._cellMC.visible = false;
            this._GoldCell.visible = false;
            this._SiverCell.visible = false;
         }
         else if(_item.TemplateID == EquipType.GOLD_BLESS)
         {
            this._cellMC.visible = false;
            this._GoldCell.visible = false;
            this._SiverCell.visible = false;
         }
         if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= ServerConfigManager.instance.getPrivilegeMinLevel(ServerConfigManager.PRIVILEGE_LOTTERYNOTIME))
         {
            this._movie.visible = false;
            this._Vipmovie.visible = true;
            this._Vipmovie.movie.play();
            this._movie.movie.stop();
         }
         else
         {
            this._movie.visible = true;
            this._Vipmovie.visible = false;
            this._Vipmovie.movie.stop();
            this._movie.movie.play();
         }
         this._selectCell.info = this._selectedGoodsInfo;
         this._startTurn();
      }
      
      private function _startTurn() : void
      {
         var _loc1_:CaddyEvent = new CaddyEvent(RightView.START_TURN);
         _loc1_.info = this._selectedGoodsInfo;
         dispatchEvent(_loc1_);
      }
      
      override public function get openBtnEnable() : Boolean
      {
         return this._openBtn.enable;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         TweenMax.killTweensOf(this._turnSprite);
         TweenMax.killTweensOf(this._selectSprite);
         if(Boolean(this._movie))
         {
            ObjectUtils.disposeObject(this._movie);
         }
         this._movie = null;
         if(Boolean(this._Vipmovie))
         {
            ObjectUtils.disposeObject(this._Vipmovie);
         }
         this._movie = null;
         if(Boolean(this._selectCell))
         {
            ObjectUtils.disposeObject(this._selectCell);
         }
         this._selectCell = null;
         if(Boolean(this._selectSprite))
         {
            ObjectUtils.disposeObject(this._selectSprite);
         }
         this._selectSprite = null;
         if(Boolean(this._turnSprite))
         {
            ObjectUtils.disposeObject(this._turnSprite);
         }
         this._turnSprite = null;
         if(Boolean(_autoCheck))
         {
            ObjectUtils.disposeObject(_autoCheck);
         }
         _autoCheck = null;
         if(Boolean(this._openBtn))
         {
            ObjectUtils.disposeObject(this._openBtn);
         }
         this._openBtn = null;
         EffectManager.Instance.removeEffect(this._effect);
      }
   }
}

