package bagAndInfo.info
{
   import bagAndInfo.bag.NecklacePtetrochemicalView;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import bagAndInfo.energyData.EnergyData;
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import baglocked.BaglockedManager;
   import beadSystem.data.BeadEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.LoadInterfaceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.Directions;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.view.selfConsortia.Badge;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.Experience;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.ShortcutBuyEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.buff.BuffControl;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.common.KingBlessIcon;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.MarriedIcon;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import game.GameManager;
   import gemstone.GemstoneManager;
   import gemstone.info.GemstListInfo;
   import im.IMController;
   import kingBless.KingBlessManager;
   import magicStone.data.MagicStoneInfo;
   import powerUp.PowerUpMovieManager;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import shop.manager.ShopBuyManager;
   import texpSystem.view.TexpInfoTipArea;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import vip.VipController;
   
   public class PlayerInfoView extends Sprite implements Disposeable
   {
      
      private var _info:PlayerInfo;
      
      private var _showSelfOperation:Boolean;
      
      private var _cellPos:Array;
      
      private var _energyData:EnergyData;
      
      private var _honorNameTxt:FilterFrameText;
      
      private var _honorNameCell:BaseCell;
      
      private var _playerInfoEffortHonorView:PlayerInfoEffortHonorView;
      
      private var _nickNameTxt:FilterFrameText;
      
      private var _consortiaTxt:FilterFrameText;
      
      private var _dutyField:FilterFrameText;
      
      private var _storeBtn:SimpleBitmapButton;
      
      private var _reputeField:FilterFrameText;
      
      private var _gesteField:FilterFrameText;
      
      private var _iconContainer:VBox;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _marriedIcon:MarriedIcon;
      
      private var _kingBlessIcon:KingBlessIcon;
      
      private var _badge:Badge;
      
      private var _bagDefinitionGroup:SelectedButtonGroup;
      
      private var _bagDefinitionBtnI:SelectedCheckButton;
      
      private var _bagDefinitionBtnII:SelectedCheckButton;
      
      private var _battle:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      private var _hiddenControlsBg:Bitmap;
      
      private var _hideHatBtn:SelectedCheckButton;
      
      private var _hideGlassBtn:SelectedCheckButton;
      
      private var _hideSuitBtn:SelectedCheckButton;
      
      private var _hideWingBtn:SelectedCheckButton;
      
      private var _energyBg:Bitmap;
      
      private var _energyTextBitmap:Bitmap;
      
      private var _energyAddBtn:SimpleBitmapButton;
      
      private var _energyProgress:EnergyProgress;
      
      private var _achvEnable:Boolean = true;
      
      private var _addFriendBtn:TextButton;
      
      private var _buyAvatar:TextButton;
      
      private var _attackTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _magicAttackTxt:FilterFrameText;
      
      private var _magicDefenceTxt:FilterFrameText;
      
      private var _attackTxt1:FilterFrameText;
      
      private var _agilityTxt1:FilterFrameText;
      
      private var _defenceTxt1:FilterFrameText;
      
      private var _luckTxt1:FilterFrameText;
      
      private var _attackButton:GlowPropButton;
      
      private var _agilityButton:GlowPropButton;
      
      private var _defenceButton:GlowPropButton;
      
      private var _luckButton:GlowPropButton;
      
      private var _magicAttackButton:GlowPropButton;
      
      private var _magicDefenceButton:GlowPropButton;
      
      private var _damageTxt:FilterFrameText;
      
      private var _damageButton:PropButton;
      
      private var _armorTxt:FilterFrameText;
      
      private var _armorButton:PropButton;
      
      private var _HPText:FilterFrameText;
      
      private var _hpButton:PropButton;
      
      private var _vitality:FilterFrameText;
      
      private var _vitalityBuntton:PropButton;
      
      private var _textLevelPrpgress:FilterFrameText;
      
      private var _progressLevel:LevelProgress;
      
      private var _cellContent:Sprite;
      
      private var _character:RoomCharacter;
      
      private var _cells:Vector.<PersonalInfoCell>;
      
      private var _buff:BuffControl;
      
      private var _dragDropArea:PersonalInfoDragInArea;
      
      private var _offerLabel:Bitmap;
      
      private var _offerSourcePosition:Point;
      
      private var _vipName:GradientText;
      
      private var _showEquip:Sprite;
      
      private var _showCard:Sprite;
      
      private var _cardEquipView:CardEquipView;
      
      private var _bg:MutipleImage;
      
      private var _bg1:MovieImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _textBg1:Scale9CornerImage;
      
      private var _textBg2:Scale9CornerImage;
      
      private var _textBg3:Scale9CornerImage;
      
      private var _textBg4:Scale9CornerImage;
      
      private var _textBg5:Scale9CornerImage;
      
      private var _textBg6:Scale9CornerImage;
      
      private var _bg2:MovieImage;
      
      private var _gongxunbg:MovieImage;
      
      private var _characterSprite:TexpInfoTipArea;
      
      private var _isVisible:Boolean = true;
      
      private var _openNecklacePtetrochemicalView:SimpleBitmapButton;
      
      private var _necklacePtetrochemicalView:NecklacePtetrochemicalView;
      
      private var _switchShowII:Boolean = true;
      
      private var _isTextTips:Boolean;
      
      public function PlayerInfoView()
      {
         super();
         this.initView();
         this.initProperties();
         this.initPos();
         this.creatCells();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset2");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bg");
         addChild(this._bg1);
         this._energyBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.energyBg");
         addChild(this._energyBg);
         this._energyTextBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.energyText");
         addChild(this._energyTextBitmap);
         this._energyProgress = ComponentFactory.Instance.creatComponentByStylename("EnergyProgress");
         this._energyProgress.tipData = LanguageMgr.GetTranslation("tank.view.energy.tip");
         addChild(this._energyProgress);
         this._energyAddBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.energyAddBtn");
         this._energyAddBtn.tipData = LanguageMgr.GetTranslation("tank.view.energy.addtip");
         addChild(this._energyAddBtn);
         if(!ServerConfigManager.instance.isMissionEnergyEnable)
         {
            this._energyBg.visible = false;
            this._energyTextBitmap.visible = false;
            this._energyProgress.visible = false;
            this._energyAddBtn.visible = false;
         }
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.ddtbg");
         this._bg2.visible = this._showSelfOperation;
         addChild(this._bg2);
         this._dragDropArea = new PersonalInfoDragInArea();
         addChild(this._dragDropArea);
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextView");
         addChild(this._textBg);
         this._textBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewI");
         addChild(this._textBg1);
         this._textBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewII");
         addChild(this._textBg2);
         this._textBg3 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewIII");
         addChild(this._textBg3);
         this._textBg4 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewIV");
         addChild(this._textBg4);
         this._textBg5 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewV");
         addChild(this._textBg5);
         this._textBg6 = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfoTextViewVI");
         addChild(this._textBg6);
         this._gongxunbg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.gongxunBg");
         addChild(this._gongxunbg);
         this._honorNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameText");
         this._honorNameTxt.setTextFormat(this._honorNameTxt.getTextFormat());
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,120,20);
         _loc1_.graphics.endFill();
         this._honorNameCell = new BaseCell(_loc1_,null,true,true);
         this._honorNameCell.tipDirctions = Directions.DIRECTION_R + "," + Directions.DIRECTION_TR + "," + Directions.DIRECTION_BR;
         this._honorNameCell.tipGapV = 10;
         this._honorNameCell.tipGapH = 10;
         this._honorNameCell.tipStyle = "core.CallPropTxtTips";
         this._honorNameCell.visible = false;
         if(PathManager.solveAchieveEnable())
         {
            addChild(this._honorNameTxt);
            addChild(this._honorNameCell);
            this._honorNameCell.x = this._honorNameTxt.x - 10;
            this._honorNameCell.y = this._honorNameTxt.y;
         }
         this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNickNameText");
         this._consortiaTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewConsortiaText");
         addChild(this._consortiaTxt);
         this._bagDefinitionBtnI = ComponentFactory.Instance.creat("bag.DefinitionBtnI");
         addChild(this._bagDefinitionBtnI);
         this._bagDefinitionBtnII = ComponentFactory.Instance.creat("bag.DefinitionBtnII");
         addChild(this._bagDefinitionBtnII);
         this._bagDefinitionGroup = new SelectedButtonGroup();
         this._bagDefinitionGroup.addSelectItem(this._bagDefinitionBtnI);
         this._bagDefinitionGroup.addSelectItem(this._bagDefinitionBtnII);
         this._bagDefinitionBtnI.visible = false;
         this._bagDefinitionBtnII.visible = false;
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAttackText");
         addChild(this._attackTxt);
         this._attackButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AttackButton");
         this._attackButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
         this._attackButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.attactDetail");
         this._attackButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._attackButton);
         addChild(this._attackButton);
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAgilityText");
         addChild(this._agilityTxt);
         this._agilityButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AgilityButton");
         this._agilityButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
         this._agilityButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.agilityDetail");
         this._agilityButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._agilityButton);
         addChild(this._agilityButton);
         this._defenceTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDefenceText");
         addChild(this._defenceTxt);
         this._defenceButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DefenceButton");
         this._defenceButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
         this._defenceButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.defenseDetail");
         this._defenceButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._defenceButton);
         addChild(this._defenceButton);
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLuckText");
         addChild(this._luckTxt);
         this._luckButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.LuckButton");
         this._luckButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
         this._luckButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.luckDetail");
         this._luckButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0,0,0,0,0);
         ShowTipManager.Instance.addTip(this._luckButton);
         addChild(this._luckButton);
         this._magicAttackTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewMagicAttackText");
         addChild(this._magicAttackTxt);
         this._magicAttackButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.MagicAttackButton");
         this._magicAttackButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttack");
         this._magicAttackButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDetail");
         this._magicAttackButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",0);
         ShowTipManager.Instance.addTip(this._magicAttackButton);
         addChild(this._magicAttackButton);
         this._magicDefenceTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewMagicDefenceText");
         addChild(this._magicDefenceTxt);
         this._magicDefenceButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.MagicDefenceButton");
         this._magicDefenceButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicDefence");
         this._magicDefenceButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicDefenceDetail");
         this._magicDefenceButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",0);
         ShowTipManager.Instance.addTip(this._magicDefenceButton);
         addChild(this._magicDefenceButton);
         this._damageTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDamageText");
         addChild(this._damageTxt);
         this._damageButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DamageButton");
         this._damageButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.damage");
         this._damageButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.damageDetail");
         (this._damageButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.damagePropertySourceTxt",0,0,0);
         ShowTipManager.Instance.addTip(this._damageButton);
         addChild(this._damageButton);
         this._armorTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewArmorText");
         addChild(this._armorTxt);
         this._armorButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.ArmorButton");
         this._armorButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.recovery");
         this._armorButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryDetail");
         (this._armorButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryPropertySourceTxt",0,0,0);
         ShowTipManager.Instance.addTip(this._armorButton);
         addChild(this._armorButton);
         this._HPText = ComponentFactory.Instance.creatComponentByStylename("personInfoViewHPText");
         addChild(this._HPText);
         this._hpButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.HPButton");
         this._hpButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.hp");
         this._hpButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpDetail");
         (this._hpButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxt",0,0,0,0);
         ShowTipManager.Instance.addTip(this._hpButton);
         addChild(this._hpButton);
         this._vitality = ComponentFactory.Instance.creatComponentByStylename("personInfoViewVitalityText");
         addChild(this._vitality);
         this._vitalityBuntton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.VitalityButton");
         this._vitalityBuntton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.energy");
         this._vitalityBuntton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.energyDetail");
         ShowTipManager.Instance.addTip(this._vitalityBuntton);
         addChild(this._vitalityBuntton);
         this._storeBtn = ComponentFactory.Instance.creatComponentByStylename("personInfoViewStoreButton");
         this._storeBtn.tipData = LanguageMgr.GetTranslation("tank.view.shortcutforge.tip");
         addChild(this._storeBtn);
         this._storeBtn.visible = true;
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("addFriendBtn1");
         PositionUtils.setPos(this._addFriendBtn,"bagAndInfo.FritendBtn.Pos");
         this._addFriendBtn.text = LanguageMgr.GetTranslation("tank.view.im.addFriendBtn");
         this._reputeField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.ReputeField");
         addChild(this._reputeField);
         this._gesteField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.GesteField");
         addChild(this._gesteField);
         this._offerLabel = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.OfferLabel");
         addChild(this._offerLabel);
         this._offerLabel.visible = false;
         this._offerSourcePosition = new Point(this._offerLabel.x,this._offerLabel.y);
         this._dutyField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.DutyField");
         addChild(this._dutyField);
         this._playerInfoEffortHonorView = new PlayerInfoEffortHonorView();
         if(PathManager.solveAchieveEnable())
         {
            addChild(this._playerInfoEffortHonorView);
         }
         this._showEquip = new Sprite();
         addChild(this._showEquip);
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.bagAndInfo.iconContainer");
         this._showEquip.addChild(this._iconContainer);
         this._showCard = new Sprite();
         addChild(this._showCard);
         this._showCard.visible = false;
         this._battle = ComponentFactory.Instance.creatComponentByStylename("personInfoViewBattleText");
         this._showEquip.addChild(this._battle);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLevelText");
         this._showEquip.addChild(this._levelTxt);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("LevelProgress");
         this._showEquip.addChild(this._progressLevel);
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
         this._showEquip.addChild(this._hideGlassBtn);
         this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideGlassCheckBox");
         this._showEquip.addChild(this._hideHatBtn);
         this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideSuitCheckBox");
         this._showEquip.addChild(this._hideSuitBtn);
         this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
         this._showEquip.addChild(this._hideWingBtn);
         this._buyAvatar = ComponentFactory.Instance.creatComponentByStylename("addFriendBtn2");
         this._buyAvatar.text = LanguageMgr.GetTranslation("ddt.bagandinfo.buyOtherCloth");
         this._buyAvatar.x = 138;
         this._buyAvatar.y = 82;
         this._showEquip.addChild(this._buyAvatar);
         this._cellContent = new Sprite();
         this._showEquip.addChild(this._cellContent);
         this._buff = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.buff");
         this._showEquip.addChild(this._buff);
         this._attackTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAttackText");
         addChild(this._attackTxt1);
         PositionUtils.setPos(this._attackTxt1,"personInfoViewAttackTextPos");
         this._attackTxt1.visible = false;
         this._agilityTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAgilityText");
         addChild(this._agilityTxt1);
         PositionUtils.setPos(this._agilityTxt1,"personInfoViewAgilityPos");
         this._agilityTxt1.visible = false;
         this._defenceTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDefenceText");
         addChild(this._defenceTxt1);
         PositionUtils.setPos(this._defenceTxt1,"personInfoViewDefencePos");
         this._defenceTxt1.visible = false;
         this._luckTxt1 = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLuckText");
         addChild(this._luckTxt1);
         PositionUtils.setPos(this._luckTxt1,"personInfoViewLuckPos");
         this._luckTxt1.visible = false;
         this._openNecklacePtetrochemicalView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.OpenBtn");
         addChild(this._openNecklacePtetrochemicalView);
      }
      
      protected function __addEnergyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._energyData = PlayerManager.Instance.energyData[PlayerManager.Instance.Self.buyEnergyCount + 1];
         if(!this._energyData)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.energy.cannotbuyEnergy"));
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.view.energy.buyEnergy",this._energyData.Money,this._energyData.Energy),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
      }
      
      protected function __alertBuyEnergy(param1:FrameEvent) : void
      {
         var _loc3_:BaseAlerFrame = null;
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyEnergy);
                  ObjectUtils.disposeObject(param1.currentTarget);
                  return;
               }
               if(PlayerManager.Instance.Self.energy < 300 && PlayerManager.Instance.Self.energy > 250)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.energy.energyEnough"));
                  _loc2_.dispose();
                  return;
               }
               if(_loc2_.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     _loc2_.dispose();
                     _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     _loc3_.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  _loc2_.dispose();
                  _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  _loc3_.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               SocketManager.Instance.out.sendBuyEnergy(_loc2_.isBand);
         }
         _loc2_.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function onResponseHander(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            SocketManager.Instance.out.sendBuyEnergy(false);
         }
         param1.currentTarget.dispose();
      }
      
      private function checkMoney(param1:Boolean) : Boolean
      {
         if(param1)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._energyData.Money)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._energyData.Money)
         {
            return false;
         }
         return true;
      }
      
      private function removeFromStageHandler(param1:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(param1:ShortcutBuyEvent) : void
      {
         param1.stopImmediatePropagation();
         dispatchEvent(new ShortcutBuyEvent(param1.ItemID,param1.ItemNum));
      }
      
      private function __createCardView(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_CARD_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createCardView);
            this.createCardEquip();
         }
      }
      
      private function createCardEquip() : void
      {
         try
         {
            this._cardEquipView = ComponentFactory.Instance.creatCustomObject("cardEquipView");
            this._showCard.addChild(this._cardEquipView);
            if(Boolean(this._info))
            {
               this._cardEquipView.playerInfo = this._info;
            }
            this._cardEquipView.clickEnable = this._switchShowII;
         }
         catch(pe:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createCardView);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_CARD_SYSTEM);
         }
      }
      
      public function switchShow(param1:Boolean) : void
      {
         LoadInterfaceManager.traceMsg("0");
         this._isTextTips = param1;
         this._showEquip.visible = !param1;
         this._showCard.visible = param1;
         this._bg.visible = !param1;
         this._bg1.visible = !param1;
         this._bg2.visible = this._showSelfOperation;
         this._nickNameTxt.visible = !param1;
         this._consortiaTxt.visible = !param1;
         this._dutyField.visible = !param1;
         this._reputeField.visible = !param1;
         this._damageTxt.visible = !param1;
         this._damageButton.visible = !param1;
         this._armorTxt.visible = !param1;
         this._armorButton.visible = !param1;
         this._HPText.visible = !param1;
         this._hpButton.visible = !param1;
         this._vitality.visible = !param1;
         this._vitalityBuntton.visible = !param1;
         if(this._vipName != null)
         {
            this._vipName.visible = !param1;
            this._isVisible = !param1;
         }
         this._textBg1.visible = !param1;
         this._textBg2.visible = !param1;
         this._textBg3.visible = !param1;
         this._textBg4.visible = !param1;
         this._textBg5.visible = !param1;
         this._textBg6.visible = !param1;
         this._attackTxt.visible = !param1;
         this._attackButton.visible = !param1;
         this._agilityTxt.visible = !param1;
         this._agilityButton.visible = !param1;
         this._defenceTxt.visible = !param1;
         this._defenceButton.visible = !param1;
         this._luckTxt.visible = !param1;
         this._luckButton.visible = !param1;
         this._magicAttackTxt.visible = !param1;
         this._magicAttackButton.visible = !param1;
         this._magicDefenceTxt.visible = !param1;
         this._magicDefenceButton.visible = !param1;
         this._attackTxt1.visible = param1;
         this._agilityTxt1.visible = param1;
         this._defenceTxt1.visible = param1;
         this._luckTxt1.visible = param1;
         this.__onUpdatePlayerProperty(null);
         if(param1 && this._cardEquipView == null)
         {
            this.createCardEquip();
         }
         if(this._showSelfOperation && this._showEquip.visible)
         {
            this._openNecklacePtetrochemicalView.visible = true;
         }
         else
         {
            this._openNecklacePtetrochemicalView.visible = false;
         }
         LoadInterfaceManager.traceMsg("1");
      }
      
      public function cardEquipShine(param1:CardInfo) : void
      {
         if(param1.templateInfo.Property8 == "1")
         {
            this._cardEquipView.shineMain();
         }
         else
         {
            this._cardEquipView.shineVice();
         }
      }
      
      public function switchShowII(param1:Boolean) : void
      {
         this._switchShowII = !param1;
         this.switchShow(param1);
         if(Boolean(this._cardEquipView))
         {
            this._cardEquipView.clickEnable = this._showSelfOperation;
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
         }
      }
      
      private function initProperties() : void
      {
         this._storeBtn.transparentEnable = true;
         this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
      }
      
      private function initPos() : void
      {
         this._cellPos = [ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos1"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos2"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos3"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos4"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos5"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos6"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos7"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos8"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos9"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos10"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos11"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos12"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos13"),ComponentFactory.Instance
         .creatCustomObject("bagAndInfo.info.equip.pos14"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos15"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos16"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos17"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos18"),ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.equip.pos19")];
      }
      
      private function initEvents() : void
      {
         this._storeBtn.addEventListener(MouseEvent.CLICK,this.__storeBtnClickHandler);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__addFriendClickHandler);
         if(Boolean(this._energyAddBtn))
         {
            this._energyAddBtn.addEventListener(MouseEvent.CLICK,this.__addEnergyHandler);
         }
         this._buyAvatar.addEventListener(MouseEvent.CLICK,this.__buyAvatarClickHandler);
         this._hideGlassBtn.addEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.addEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.addEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.addEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._bagDefinitionGroup.addEventListener(Event.CHANGE,this._definitionGroupChange);
         this._openNecklacePtetrochemicalView.addEventListener(MouseEvent.CLICK,this.__openNecklacePtetrochemicalView);
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdatePlayerProperty);
      }
      
      protected function __openNecklacePtetrochemicalView(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._necklacePtetrochemicalView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.necklacePtetrochemicalView");
         this._necklacePtetrochemicalView.show();
         this._necklacePtetrochemicalView.addEventListener(FrameEvent.RESPONSE,this.__onNecklacePtetrochemicalClose);
      }
      
      protected function __onNecklacePtetrochemicalClose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._necklacePtetrochemicalView.removeEventListener(FrameEvent.RESPONSE,this.__onNecklacePtetrochemicalClose);
            ObjectUtils.disposeObject(this._necklacePtetrochemicalView);
            this._necklacePtetrochemicalView = null;
         }
      }
      
      protected function __onUpdatePlayerProperty(param1:Event) : void
      {
         var _loc7_:String = null;
         var _loc8_:DictionaryData = null;
         var _loc17_:DictionaryData = null;
         var _loc18_:String = null;
         if(this._info.propertyAddition == null)
         {
            return;
         }
         var _loc2_:Vector.<GlowPropButton> = Vector.<GlowPropButton>([this._attackButton,this._defenceButton,this._agilityButton,this._luckButton]);
         var _loc3_:Array = ["Attack","Defence","Agility","Luck"];
         var _loc4_:int = 0;
         var _loc5_:String = LanguageMgr.GetTranslation("tank.data.EquipType.suit");
         var _loc6_:String = LanguageMgr.GetTranslation("tank.data.EquipType.gem");
         for each(_loc7_ in _loc3_)
         {
            _loc17_ = this._info.getPropertyAdditionByType(_loc7_);
            if(Boolean(_loc17_))
            {
               _loc18_ = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",_loc17_["Texp"],_loc17_["Card"],_loc17_["Pet"],_loc17_["Totem"],_loc17_["gem"],_loc17_["Bead"],_loc17_["Avatar"],_loc17_["MagicStone"]);
               if(!PathManager.solveGemstoneSwitch)
               {
                  _loc18_ = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt.noGemstone",_loc17_["Texp"],_loc17_["Card"],_loc17_["Pet"],_loc17_["Totem"],_loc17_["Bead"],_loc17_["Avatar"],_loc17_["MagicStone"]);
               }
               if(PathManager.suitEnable)
               {
                  _loc18_ += "\n" + _loc5_ + "+" + _loc17_["Suit"];
               }
               _loc2_[_loc4_].propertySource = _loc18_;
            }
            if(_loc4_ >= 4)
            {
               break;
            }
            _loc4_++;
         }
         _loc8_ = this._info.getPropertyAdditionByType("MagicAttack");
         if(Boolean(_loc8_))
         {
            GlowPropButton(this._magicAttackButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",_loc8_["MagicStone"]);
         }
         var _loc9_:DictionaryData = this._info.getPropertyAdditionByType("MagicDefence");
         if(Boolean(_loc9_))
         {
            GlowPropButton(this._magicDefenceButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.magicAttackDefencePropertySourceTxt",_loc9_["MagicStone"]);
         }
         var _loc10_:DictionaryData = this._info.getPropertyAdditionByType("HP");
         if(Boolean(_loc10_))
         {
            GlowPropButton(this._hpButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxt",_loc10_["Texp"],_loc10_["Pet"],_loc10_["Totem"],_loc10_["Bead"],_loc10_["Avatar"]);
            if(PathManager.solveGemstoneSwitch)
            {
               GlowPropButton(this._hpButton).propertySource = GlowPropButton(this._hpButton).propertySource + ("\n" + _loc6_ + "+" + _loc10_["gem"]);
            }
            if(PathManager.suitEnable && Boolean(_loc10_))
            {
               GlowPropButton(this._hpButton).propertySource = GlowPropButton(this._hpButton).propertySource + ("\n" + _loc5_ + "+" + _loc10_["Suit"]);
            }
         }
         var _loc11_:DictionaryData = this._info.getPropertyAdditionByType("Armor");
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         if(Boolean(_loc11_))
         {
            _loc12_ = int(_loc11_["Totem"]);
            _loc13_ = int(_loc11_["Bead"]);
            _loc14_ = int(_loc11_["Avatar"]);
         }
         var _loc15_:DictionaryData = this._info.getPropertyAdditionByType("Guard");
         GlowPropButton(this._armorButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryPropertySourceTxt",StaticFormula.getCardRecoveryAddition(this._info),_loc12_,_loc13_,_loc14_);
         GlowPropButton(this._armorButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryPropertySourceTxt",StaticFormula.getCardRecoveryAddition(this._info),_loc12_,_loc13_);
         if(PathManager.suitEnable && Boolean(_loc15_))
         {
            GlowPropButton(this._armorButton).propertySource = GlowPropButton(this._armorButton).propertySource + ("\n" + _loc5_ + "+" + _loc15_["Suit"]);
         }
         var _loc16_:DictionaryData = this._info.getPropertyAdditionByType("Damage");
         _loc12_ = 0;
         _loc13_ = 0;
         _loc14_ = 0;
         if(Boolean(_loc16_))
         {
            _loc12_ = int(_loc16_["Totem"]);
            _loc13_ = int(_loc16_["Bead"]);
            _loc14_ = int(_loc16_["Avatar"]);
         }
         GlowPropButton(this._damageButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.damagePropertySourceTxt",StaticFormula.getCardDamageAddition(this._info),_loc12_,_loc13_,_loc14_);
         GlowPropButton(this._damageButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.damagePropertySourceTxt",StaticFormula.getCardDamageAddition(this._info),_loc12_,_loc13_);
         if(PathManager.suitEnable && Boolean(_loc16_))
         {
            GlowPropButton(this._damageButton).propertySource = GlowPropButton(this._damageButton).propertySource + ("\n" + _loc5_ + "+" + _loc16_["Suit"]);
         }
         if(Boolean(PlayerManager.Instance.Self.Bag.items[12]))
         {
            if(!this._openNecklacePtetrochemicalView.parent)
            {
               addChild(this._openNecklacePtetrochemicalView);
            }
         }
         else if(Boolean(this._openNecklacePtetrochemicalView.parent))
         {
            this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
         }
      }
      
      private function removeEvent() : void
      {
         this._storeBtn.removeEventListener(MouseEvent.CLICK,this.__storeBtnClickHandler);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__addFriendClickHandler);
         if(Boolean(this._energyAddBtn))
         {
            this._energyAddBtn.removeEventListener(MouseEvent.CLICK,this.__addEnergyHandler);
         }
         this._buyAvatar.removeEventListener(MouseEvent.CLICK,this.__buyAvatarClickHandler);
         this._hideGlassBtn.removeEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.removeEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.removeEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.removeEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._openNecklacePtetrochemicalView.removeEventListener(MouseEvent.CLICK,this.__openNecklacePtetrochemicalView);
         if(this._info is PlayerInfo)
         {
            this._info.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            if(this._info is SelfInfo)
            {
               (this._info as SelfInfo).magicStoneBag.removeEventListener(BagEvent.UPDATE,this.__equipMagicStone);
            }
         }
         PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
         this._bagDefinitionGroup.removeEventListener(Event.CHANGE,this._definitionGroupChange);
         PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdatePlayerProperty);
      }
      
      private function __storeBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            if(PlayerManager.Instance.Self.Grade < 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
               return;
            }
         }
         BagStore.instance.show();
         BagStore.instance.isFromBagFrame = true;
      }
      
      private function __addFriendClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IMController.Instance.addFriend(this._info.NickName);
      }
      
      private function __buyAvatarClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ShopBuyManager.Instance.buyAvatar(this._info);
      }
      
      private function __hideGlassClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.GLASS,this._hideGlassBtn.selected);
      }
      
      private function __hideHatClickHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.HEAD,this._hideHatBtn.selected);
      }
      
      private function __hideSuitClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.SUITS,this._hideSuitBtn.selected);
      }
      
      private function __hideWingClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendHideLayer(EquipType.WING,this._hideWingBtn.selected);
      }
      
      private function creatCells() : void
      {
         var _loc2_:PersonalInfoCell = null;
         this._cells = new Vector.<PersonalInfoCell>();
         var _loc1_:int = 0;
         while(_loc1_ < 19)
         {
            _loc2_ = CellFactory.instance.createPersonalInfoCell(_loc1_) as PersonalInfoCell;
            switch(_loc1_)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 11:
               case 13:
                  break;
               default:
                  _loc2_.addEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
                  _loc2_.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
            }
            _loc2_.x = this._cellPos[_loc1_].x;
            _loc2_.y = this._cellPos[_loc1_].y;
            this._cellContent.addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearCells() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            if(Boolean(this._cells[_loc1_]))
            {
               if(this._cells[_loc1_].hasEventListener(CellEvent.ITEM_CLICK))
               {
                  this._cells[_loc1_].removeEventListener(CellEvent.ITEM_CLICK,this.__cellClickHandler);
               }
               if(this._cells[_loc1_].hasEventListener(CellEvent.DOUBLE_CLICK))
               {
                  this._cells[_loc1_].removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClickHandler);
               }
               if(Boolean(this._cells[_loc1_].parent))
               {
                  this._cells[_loc1_].parent.removeChild(this._cells[_loc1_] as PersonalInfoCell);
               }
               this._cells[_loc1_].dispose();
               this._cells[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function set info(param1:*) : void
      {
         PlayerInfoViewControl.currentPlayer = param1;
         if(this._info == param1)
         {
            return;
         }
         if(PlayerInfoViewControl._isBattle)
         {
            this._info = param1;
            this.updateView(PlayerInfoViewControl._isBattle);
            return;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
            PlayerManager.Instance.removeEventListener(BeadEvent.EQUIPBEAD,this.__onBeadBagUpdate);
            this._info.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCells);
            if(this._info is SelfInfo)
            {
               (this._info as SelfInfo).magicStoneBag.removeEventListener(BagEvent.UPDATE,this.__equipMagicStone);
            }
            this._info = null;
         }
         this._info = param1;
         if(Boolean(this._info))
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE,this.__upVip);
            this._info.Bag.addEventListener(BagEvent.UPDATE,this.__updateCells);
            if(this._info is SelfInfo)
            {
               (this._info as SelfInfo).magicStoneBag.addEventListener(BagEvent.UPDATE,this.__equipMagicStone);
            }
            if(Boolean(this._cardEquipView))
            {
               this._cardEquipView.playerInfo = this._info;
            }
            ItemManager.Instance.playerInfo = this._info;
         }
         this.updateView();
      }
      
      protected function __onBeadBagUpdate(param1:Event) : void
      {
         this.updatePersonInfo();
      }
      
      private function __changeHandler(param1:PlayerPropertyEvent) : void
      {
         this.updatePersonInfo();
         this.updateHide();
         this.updateIcons();
         this.setTexpViewProTxt();
         if(Boolean(this._info) && Boolean(this._characterSprite))
         {
            this._characterSprite.info = this._info;
         }
      }
      
      private function __upVip(param1:Event) : void
      {
         this.__changeHandler(null);
      }
      
      private function __updateCells(param1:BagEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               this._cells[_loc3_].info = this._info.Bag.getItemAt(_loc3_);
            }
            if(Boolean(GemstoneManager.Instance.getByPlayerInfoList(_loc3_,this._info.ID)))
            {
               if(Boolean(this._cells[_loc3_].info))
               {
                  (this._cells[_loc3_].info as InventoryItemInfo).gemstoneList = GemstoneManager.Instance.getByPlayerInfoList(_loc3_,this._info.ID);
               }
            }
         }
         this.updateCells();
      }
      
      private function __equipMagicStone(param1:BagEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         for(_loc2_ in param1.changedSlots)
         {
            _loc3_ = int(_loc2_);
            if(_loc3_ <= BagInfo.PERSONAL_EQUIP_COUNT)
            {
               this.updateCells();
               break;
            }
         }
      }
      
      private function __cellClickHandler(param1:CellEvent) : void
      {
         var _loc2_:PersonalInfoCell = null;
         if(this._showSelfOperation)
         {
            _loc2_ = param1.data as PersonalInfoCell;
            _loc2_.dragStart();
         }
      }
      
      private function __cellDoubleClickHandler(param1:CellEvent) : void
      {
         var _loc2_:PersonalInfoCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(this._showSelfOperation)
         {
            _loc2_ = param1.data as PersonalInfoCell;
            if(Boolean(_loc2_) && Boolean(_loc2_.info))
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc3_.Place,BagInfo.EQUIPBAG,-1,_loc3_.Count);
            }
         }
      }
      
      private function updateView(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.updatePersonInfo();
            this.updateCharacter();
            return;
         }
         this.updateCharacter();
         this.updateCells();
         this.updatePersonInfo();
         this.updateHide();
         this.updateIcons();
         this.updateShowOperation();
      }
      
      private function updateHide() : void
      {
         if(Boolean(this._info))
         {
            this._hideGlassBtn.selected = this._info.getGlassHide();
            this._hideHatBtn.selected = this._info.getHatHide();
            this._hideSuitBtn.selected = this._info.getSuitesHide();
            this._hideWingBtn.selected = this._info.wingHide;
         }
      }
      
      private function updateCharacter() : void
      {
         if(Boolean(this._info))
         {
            if(Boolean(this._character))
            {
               this._character.dispose();
               this._character = null;
            }
            this._character = CharactoryFactory.createCharacter(this._info,"room") as RoomCharacter;
            this._character.showGun = false;
            this._character.show(false,-1);
            this._character.x = 267;
            this._character.y = 108;
            this._showEquip.addChildAt(this._character,0);
            if(!this._characterSprite)
            {
               this._characterSprite = new TexpInfoTipArea();
               this._characterSprite.x = this._character.x;
               this._characterSprite.y = this._character.y;
               this._characterSprite.scaleX = -1;
               this._showEquip.addChildAt(this._characterSprite,0);
            }
            this._characterSprite.info = this._info;
         }
         else
         {
            this._character.dispose();
            this._character = null;
            ObjectUtils.disposeObject(this._characterSprite);
            this._characterSprite = null;
         }
      }
      
      private function updateCells() : void
      {
         var _loc1_:PersonalInfoCell = null;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:MagicStoneInfo = null;
         for each(_loc1_ in this._cells)
         {
            if(!this._info)
            {
               break;
            }
            _loc2_ = this._info.Bag.getItemAt(_loc1_.place);
            _loc1_.info = _loc2_;
            if(Boolean(_loc2_))
            {
               _loc2_.gemstoneList = GemstoneManager.Instance.getByPlayerInfoList(_loc1_.place,this._info.ID);
               if(this._info == PlayerManager.Instance.Self)
               {
                  _loc3_ = PlayerManager.Instance.Self.magicStoneBag.getItemAt(_loc1_.place);
                  if(!_loc3_)
                  {
                     _loc2_.magicStoneAttr = null;
                  }
                  else
                  {
                     _loc4_ = new MagicStoneInfo();
                     _loc4_.templateId = _loc3_.TemplateID;
                     _loc4_.level = _loc3_.StrengthenLevel;
                     _loc4_.attack = _loc3_.AttackCompose;
                     _loc4_.defence = _loc3_.DefendCompose;
                     _loc4_.agility = _loc3_.AgilityCompose;
                     _loc4_.luck = _loc3_.LuckCompose;
                     _loc4_.magicAttack = _loc3_.MagicAttack;
                     _loc4_.magicDefence = _loc3_.MagicDefence;
                     _loc2_.magicStoneAttr = _loc4_;
                  }
               }
            }
         }
         if(Boolean(PlayerManager.Instance.Self.Bag.items[12]))
         {
            if(!this._openNecklacePtetrochemicalView.parent)
            {
               addChild(this._openNecklacePtetrochemicalView);
            }
         }
         else if(Boolean(this._openNecklacePtetrochemicalView.parent))
         {
            this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
         }
      }
      
      private function getList(param1:int) : Vector.<GemstListInfo>
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(Boolean(PlayerManager.Instance.gemstoneInfoList[_loc2_]))
            {
               if(param1 == PlayerManager.Instance.gemstoneInfoList[_loc2_].equipPlace)
               {
                  return PlayerManager.Instance.gemstoneInfoList[_loc2_].list;
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      public function allowLvIconClick() : void
      {
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.allowClick();
         }
      }
      
      private function updateIcons() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._info))
         {
            if(this._levelIcon == null)
            {
               this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.levelIcon");
               if(this._info.IsVIP)
               {
                  this._levelIcon.x += 1;
               }
            }
            this._levelIcon.setSize(LevelIcon.SIZE_BIG);
            _loc1_ = 1;
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               _loc1_ = GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) == null ? -1 : GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team;
            }
            this._levelIcon.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,true,false,_loc1_);
            this._showEquip.addChild(this._levelIcon);
            if(this._info.ID == PlayerManager.Instance.Self.ID || this._info.IsVIP)
            {
               if(this._vipIcon == null)
               {
                  this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.VipIcon");
                  this._iconContainer.addChild(this._vipIcon);
               }
               this._vipIcon.setInfo(this._info);
               if(!this._info.IsVIP)
               {
                  this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               else
               {
                  this._vipIcon.filters = null;
               }
            }
            else if(Boolean(this._vipIcon))
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            if(this._info.ID == PlayerManager.Instance.Self.ID)
            {
               if(this._kingBlessIcon == null)
               {
                  this._kingBlessIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.KingBlessIcon");
                  this._iconContainer.addChild(this._kingBlessIcon);
               }
               this._info.isOpenKingBless = KingBlessManager.instance.getRemainTimeTxt().isOpen;
               this._kingBlessIcon.setInfo(this._info.isOpenKingBless,true);
            }
            else if(!this._info.isOpenKingBless)
            {
               if(Boolean(this._kingBlessIcon))
               {
                  this._kingBlessIcon.dispose();
                  this._kingBlessIcon = null;
               }
            }
            else
            {
               if(this._kingBlessIcon == null)
               {
                  this._kingBlessIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.KingBlessIcon");
                  this._iconContainer.addChild(this._kingBlessIcon);
               }
               this._kingBlessIcon.setInfo(this._info.isOpenKingBless,false);
            }
            if(this._info.SpouseID > 0)
            {
               if(this._marriedIcon == null)
               {
                  this._marriedIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.MarriedIcon");
               }
               this._marriedIcon.tipData = {
                  "nickName":this._info.SpouseName,
                  "gender":this._info.Sex
               };
               this._iconContainer.addChild(this._marriedIcon);
            }
            else if(Boolean(this._marriedIcon))
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
            if(this._info.ConsortiaID > 0 && this._info.badgeID > 0)
            {
               if(this._badge == null)
               {
                  this._badge = new Badge();
                  this._badge.x = 21;
                  this._badge.badgeID = this._info.badgeID;
                  this._badge.showTip = true;
                  this._badge.tipData = this._info.ConsortiaName;
                  this._iconContainer.addChild(this._badge);
               }
            }
            else if(Boolean(this._badge))
            {
               this._badge.dispose();
               this._badge = null;
            }
         }
         else
         {
            if(Boolean(this._levelIcon))
            {
               this._levelIcon.dispose();
               this._levelIcon = null;
            }
            if(Boolean(this._vipIcon))
            {
               this._vipIcon.dispose();
               this._vipIcon = null;
            }
            if(Boolean(this._marriedIcon))
            {
               this._marriedIcon.dispose();
               this._marriedIcon = null;
            }
            if(Boolean(this._kingBlessIcon))
            {
               this._kingBlessIcon.dispose();
               this._kingBlessIcon = null;
            }
            if(Boolean(this._badge))
            {
               this._badge.dispose();
               this._badge = null;
            }
         }
      }
      
      private function updatePersonInfo() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._info == null)
         {
            return;
         }
         this._levelTxt.text = this._info.Grade + "";
         if(PlayerInfoViewControl._isBattle)
         {
            this._attackTxt.htmlText = this.getHtmlTextByString(String(this._info.Attack <= 0 ? "" : this._info.Attack),0);
            this._defenceTxt.htmlText = this.getHtmlTextByString(String(this._info.Defence <= 0 ? "" : this._info.Defence),0);
            this._agilityTxt.htmlText = this.getHtmlTextByString(String(this._info.Agility <= 0 ? "" : this._info.Agility),0);
            this._luckTxt.htmlText = this.getHtmlTextByString(String(this._info.Luck <= 0 ? "" : this._info.Luck),0);
            this._magicAttackTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicAttack <= 0 ? "" : this._info.MagicAttack),0);
            this._magicDefenceTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicDefence <= 0 ? "" : this._info.MagicDefence),0);
            this._damageTxt.htmlText = this.getHtmlTextByString(String(this._info.Damage),1);
            this._armorTxt.htmlText = this.getHtmlTextByString(String(this._info.Guard),1);
            this._HPText.htmlText = this.getHtmlTextByString(String(this._info.Blood),1);
            this._vitality.htmlText = this.getHtmlTextByString(String(this._info.Energy),1);
            return;
         }
         this.__onUpdatePlayerProperty(null);
         this._reputeField.text = this._info == null ? "" : this._info.Repute.toString();
         this._gesteField.text = this._info == null ? "" : this._info.Offer.toString();
         this._dutyField.text = this._info.DutyName == null || this._info.DutyName == "" ? "" : (this._info.ConsortiaID > 0 ? "< " + this._info.DutyName + " >" : "");
         this._honorNameTxt.text = this._info.honor == null ? "" : this._info.honor;
         if(this._honorNameTxt.text == "")
         {
            this._honorNameCell.visible = false;
         }
         else
         {
            this._honorNameCell.visible = true;
            _loc1_ = this._info.honor;
            if(Boolean(PlayerManager.Instance.callPropData) && Boolean(PlayerManager.Instance.callPropData[_loc1_]))
            {
               this._honorNameCell.tipData = PlayerManager.Instance.callPropData[_loc1_] as CallPropTxtTipInfo;
            }
            else
            {
               this._honorNameCell.tipData = new CallPropTxtTipInfo();
            }
         }
         this._nickNameTxt.text = this._info.NickName == null ? "" : this._info.NickName;
         if(this._info.IsVIP)
         {
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = VipController.instance.getVipNameTxt(114,this._info.typeVIP);
            this._vipName.x = this._nickNameTxt.x;
            this._vipName.y = this._nickNameTxt.y;
            this._vipName.text = this._nickNameTxt.text;
            this._vipName.visible = this._isVisible;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._nickNameTxt);
         }
         else
         {
            addChild(this._nickNameTxt);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._consortiaTxt.text = this._info.ConsortiaName == null ? "" : (this._info.ConsortiaID > 0 ? this._info.ConsortiaName : "");
         this._dutyField.x = this._consortiaTxt.x + this._consortiaTxt.width + 6;
         if(this._dutyField.x + this._dutyField.width > 267)
         {
            this._dutyField.autoSize = TextFieldAutoSize.NONE;
            this._dutyField.isAutoFitLength = true;
            _loc2_ = 260 - this._dutyField.x;
            this._dutyField.width = _loc2_;
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._gesteField.visible = true;
            this._gongxunbg.visible = true;
            this._bg2.visible = this._showSelfOperation;
         }
         else
         {
            this._storeBtn.visible = true;
            this._storeBtn.enable = false;
            this._gesteField.visible = false;
            this._gongxunbg.visible = false;
            this._bg2.visible = false;
         }
         if(this._info.ConsortiaID > 0 && this._dutyField.x + this._dutyField.width > this._offerSourcePosition.x)
         {
            this._offerLabel.x = this._dutyField.x + this._dutyField.width;
         }
         else
         {
            this._offerLabel.x = this._offerSourcePosition.x + 32;
         }
         PowerUpMovieManager.isInPlayerInfoView = true;
         if(this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._attackTxt.htmlText = this.getHtmlTextByString(String(this._info.Attack <= 0 ? "" : this._info.Attack),0);
            this._defenceTxt.htmlText = this.getHtmlTextByString(String(this._info.Defence <= 0 ? "" : this._info.Defence),0);
            this._agilityTxt.htmlText = this.getHtmlTextByString(String(this._info.Agility <= 0 ? "" : this._info.Agility),0);
            this._luckTxt.htmlText = this.getHtmlTextByString(String(this._info.Luck <= 0 ? "" : this._info.Luck),0);
            this._magicAttackTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicAttack <= 0 ? "" : this._info.MagicAttack),0);
            this._magicDefenceTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicDefence <= 0 ? "" : this._info.MagicDefence),0);
            this._damageTxt.htmlText = this.getHtmlTextByString(String(Math.round(StaticFormula.getDamage(this._info)) <= 0 ? "" : Math.round(StaticFormula.getDamage(this._info))),1);
            this._armorTxt.htmlText = this.getHtmlTextByString(String(StaticFormula.getRecovery(this._info) <= 0 ? "" : StaticFormula.getRecovery(this._info)),1);
            this._HPText.htmlText = this.getHtmlTextByString(String(StaticFormula.getMaxHp(this._info)),1);
            this._vitality.htmlText = this.getHtmlTextByString(String(StaticFormula.getEnergy(this._info) <= 0 ? "" : StaticFormula.getEnergy(this._info)),1);
            if(this._info.isSelf)
            {
               this._battle.htmlText = this.getHtmlTextByString(String(this._info.FightPower),2);
            }
            else if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               if(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) != null && GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team == GameManager.Instance.Current.selfGamePlayer.team)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else
               {
                  this._battle.htmlText = "";
               }
            }
         }
         else
         {
            if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               if(RoomManager.Instance.current.selfRoomPlayer.playerInfo.ID == this._info.ID)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else if(GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID) != null && GameManager.Instance.Current.findLivingByPlayerID(this._info.ID,this._info.ZoneID).team == GameManager.Instance.Current.selfGamePlayer.team)
               {
                  this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
               }
               else
               {
                  this._battle.htmlText = "";
               }
            }
            else
            {
               this._battle.htmlText = this.getHtmlTextByString(this._info == null ? "" : this._info.FightPower.toString(),2);
            }
            this._attackTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Attack < 0 ? 0 : this._info.Attack),0);
            this._agilityTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Agility < 0 ? 0 : this._info.Agility),0);
            this._defenceTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Defence < 0 ? 0 : this._info.Defence),0);
            this._luckTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Luck < 0 ? 0 : this._info.Luck),0);
            this._magicAttackTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicAttack <= 0 ? 0 : this._info.MagicAttack),0);
            this._magicDefenceTxt.htmlText = this.getHtmlTextByString(String(this._info.MagicDefence <= 0 ? 0 : this._info.MagicDefence),0);
            this._damageTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(Math.round(StaticFormula.getDamage(this._info))),1);
            this._armorTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getRecovery(this._info)),1);
            this._HPText.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getMaxHp(this._info)),1);
            this._vitality.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(StaticFormula.getEnergy(this._info)),1);
         }
         if(Boolean(this._info))
         {
            this._progressLevel.setProgress(Experience.getExpPercent(this._info.Grade,this._info.GP) * 100,100);
            _loc3_ = Experience.expericence[this._info.Grade] - Experience.expericence[this._info.Grade - 1];
            _loc4_ = this._info.GP - Experience.expericence[this._info.Grade - 1];
            if(this._info.Grade < Experience.expericence.length)
            {
               _loc4_ = _loc4_ > _loc3_ ? _loc3_ : _loc4_;
            }
            if(StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this._progressLevel.tipData = "0/" + _loc3_;
            }
            else if(_loc4_ > 0 && this._info.Grade < Experience.expericence.length)
            {
               this._progressLevel.tipData = _loc4_ + "/" + _loc3_;
            }
            else if(this._info.Grade == Experience.expericence.length)
            {
               this._progressLevel.tipData = _loc4_ + "/0";
            }
            else
            {
               this._progressLevel.tipData = "0/" + _loc3_;
            }
         }
         if(Boolean(this._info) && this._info.ID == PlayerManager.Instance.Self.ID)
         {
            this._definitionGroupChange();
         }
      }
      
      private function setTexpViewProTxt() : void
      {
         var _loc1_:DictionaryData = this._info.getPropertyAdditionByType("Attack");
         var _loc2_:DictionaryData = this._info.getPropertyAdditionByType("Defence");
         var _loc3_:DictionaryData = this._info.getPropertyAdditionByType("Agility");
         var _loc4_:DictionaryData = this._info.getPropertyAdditionByType("Luck");
         if(!_loc3_)
         {
            return;
         }
         this._attackTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(_loc1_["Card"] < 0 ? 0 : _loc1_["Card"]),0);
         this._agilityTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(_loc3_["Card"] < 0 ? 0 : _loc3_["Card"]),0);
         this._defenceTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(_loc2_["Card"] < 0 ? 0 : _loc2_["Card"]),0);
         this._luckTxt1.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(_loc4_["Card"] < 0 ? 0 : _loc4_["Card"]),0);
      }
      
      private function getHtmlTextByString(param1:String, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case 0:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FFF6C9\' ><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 1:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FFF6C9\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 2:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'Arial\' SIZE=\'14\' COLOR=\'#FFF6C9\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
         }
         return _loc3_ + param1 + _loc4_;
      }
      
      public function dispose() : void
      {
         PowerUpMovieManager.isInPlayerInfoView = false;
         this.removeEvent();
         this.clearCells();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._energyAddBtn))
         {
            ObjectUtils.disposeObject(this._energyAddBtn);
            this._energyAddBtn = null;
         }
         if(Boolean(this._energyBg))
         {
            ObjectUtils.disposeObject(this._energyBg);
            this._energyBg = null;
         }
         if(Boolean(this._energyTextBitmap))
         {
            ObjectUtils.disposeObject(this._energyTextBitmap);
            this._energyTextBitmap = null;
         }
         if(Boolean(this._energyProgress))
         {
            ObjectUtils.disposeObject(this._energyProgress);
            this._energyProgress = null;
         }
         ObjectUtils.disposeObject(this._attackTxt);
         this._attackTxt = null;
         ObjectUtils.disposeObject(this._agilityTxt);
         this._agilityTxt = null;
         ObjectUtils.disposeObject(this._defenceTxt);
         this._defenceTxt = null;
         ObjectUtils.disposeObject(this._luckTxt);
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._magicAttackTxt);
         this._magicAttackTxt = null;
         ObjectUtils.disposeObject(this._magicDefenceTxt);
         this._magicDefenceTxt = null;
         ObjectUtils.disposeObject(this._damageTxt);
         this._damageTxt = null;
         ObjectUtils.disposeObject(this._armorTxt);
         this._armorTxt = null;
         ObjectUtils.disposeObject(this._HPText);
         this._HPText = null;
         ObjectUtils.disposeObject(this._vitality);
         this._vitality = null;
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         ObjectUtils.disposeObject(this._iconContainer);
         this._iconContainer = null;
         this._vipIcon = null;
         this._marriedIcon = null;
         this._kingBlessIcon = null;
         if(Boolean(this._attackButton))
         {
            ShowTipManager.Instance.removeTip(this._attackButton);
            ObjectUtils.disposeObject(this._attackButton);
            this._attackButton = null;
         }
         if(Boolean(this._agilityButton))
         {
            ShowTipManager.Instance.removeTip(this._agilityButton);
            ObjectUtils.disposeObject(this._agilityButton);
            this._agilityButton = null;
         }
         if(Boolean(this._defenceButton))
         {
            ShowTipManager.Instance.removeTip(this._defenceButton);
            ObjectUtils.disposeObject(this._defenceButton);
            this._defenceButton = null;
         }
         if(Boolean(this._luckButton))
         {
            ShowTipManager.Instance.removeTip(this._luckButton);
            ObjectUtils.disposeObject(this._luckButton);
            this._luckButton = null;
         }
         if(Boolean(this._magicAttackButton))
         {
            ShowTipManager.Instance.removeTip(this._magicAttackButton);
            ObjectUtils.disposeObject(this._magicAttackButton);
            this._magicAttackButton = null;
         }
         if(Boolean(this._magicDefenceButton))
         {
            ShowTipManager.Instance.removeTip(this._magicDefenceButton);
            ObjectUtils.disposeObject(this._magicDefenceButton);
            this._magicDefenceButton = null;
         }
         if(Boolean(this._damageButton))
         {
            ShowTipManager.Instance.removeTip(this._damageButton);
            ObjectUtils.disposeObject(this._damageButton);
            this._damageButton = null;
         }
         if(Boolean(this._armorButton))
         {
            ShowTipManager.Instance.removeTip(this._armorButton);
            ObjectUtils.disposeObject(this._armorButton);
            this._armorButton = null;
         }
         if(Boolean(this._hpButton))
         {
            ShowTipManager.Instance.removeTip(this._hpButton);
            ObjectUtils.disposeObject(this._hpButton);
            this._hpButton = null;
         }
         if(Boolean(this._vitalityBuntton))
         {
            ShowTipManager.Instance.removeTip(this._vitalityBuntton);
            ObjectUtils.disposeObject(this._vitalityBuntton);
            this._vitalityBuntton = null;
         }
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         if(Boolean(this._buff))
         {
            this._buff.dispose();
         }
         this._buff = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bg1);
         this._bg1 = null;
         ObjectUtils.disposeObject(this._showEquip);
         ObjectUtils.disposeObject(this._textBg);
         this._textBg = null;
         ObjectUtils.disposeObject(this._textBg1);
         this._textBg1 = null;
         ObjectUtils.disposeObject(this._textBg2);
         this._textBg2 = null;
         ObjectUtils.disposeObject(this._textBg3);
         this._textBg3 = null;
         ObjectUtils.disposeObject(this._textBg4);
         this._textBg4 = null;
         ObjectUtils.disposeObject(this._textBg5);
         this._textBg5 = null;
         ObjectUtils.disposeObject(this._textBg6);
         this._textBg6 = null;
         ObjectUtils.disposeObject(this._bg2);
         this._bg2 = null;
         this._showEquip = null;
         ObjectUtils.disposeObject(this._showCard);
         this._showCard = null;
         ObjectUtils.disposeObject(this._cardEquipView);
         this._cardEquipView = null;
         ObjectUtils.disposeObject(this._honorNameTxt);
         this._honorNameTxt = null;
         ObjectUtils.disposeObject(this._honorNameCell);
         this._honorNameCell = null;
         ObjectUtils.disposeObject(this._nickNameTxt);
         this._nickNameTxt = null;
         ObjectUtils.disposeObject(this._consortiaTxt);
         this._consortiaTxt = null;
         ObjectUtils.disposeObject(this._battle);
         this._battle = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._characterSprite);
         this._characterSprite = null;
         ObjectUtils.disposeObject(this._progressLevel);
         this._progressLevel = null;
         ObjectUtils.disposeObject(this._reputeField);
         this._reputeField = null;
         ObjectUtils.disposeObject(this._gesteField);
         this._gesteField = null;
         ObjectUtils.disposeObject(this._dutyField);
         this._dutyField = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._hideGlassBtn);
         this._hideGlassBtn = null;
         ObjectUtils.disposeObject(this._hideHatBtn);
         this._hideHatBtn = null;
         ObjectUtils.disposeObject(this._hideSuitBtn);
         this._hideSuitBtn = null;
         ObjectUtils.disposeObject(this._hideWingBtn);
         this._hideWingBtn = null;
         ObjectUtils.disposeObject(this._storeBtn);
         this._storeBtn = null;
         ObjectUtils.disposeObject(this._buyAvatar);
         this._buyAvatar = null;
         ObjectUtils.disposeObject(this._bagDefinitionBtnI);
         this._bagDefinitionBtnI = null;
         ObjectUtils.disposeObject(this._bagDefinitionGroup);
         this._bagDefinitionGroup = null;
         ObjectUtils.disposeObject(this._bagDefinitionBtnII);
         this._bagDefinitionBtnII = null;
         ObjectUtils.disposeObject(this._playerInfoEffortHonorView);
         this._playerInfoEffortHonorView = null;
         ObjectUtils.disposeObject(this._cellContent);
         this._cellContent = null;
         ObjectUtils.disposeObject(this._offerLabel);
         this._offerLabel = null;
         ObjectUtils.disposeObject(this._dragDropArea);
         this._dragDropArea = null;
         ObjectUtils.disposeObject(this._openNecklacePtetrochemicalView);
         this._openNecklacePtetrochemicalView = null;
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         this._energyData = null;
      }
      
      public function startShine(param1:ItemTemplateInfo) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1.NeedSex == 0 || param1.NeedSex == (PlayerManager.Instance.Self.Sex ? 1 : 2))
         {
            _loc2_ = this.getCellIndex(param1).split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(int(_loc2_[_loc3_]) >= 0)
               {
                  (this._cells[int(_loc2_[_loc3_])] as PersonalInfoCell).shine();
               }
               _loc3_++;
            }
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:PersonalInfoCell = null;
         for each(_loc1_ in this._cells)
         {
            (_loc1_ as PersonalInfoCell).stopShine();
         }
         if(Boolean(this._cardEquipView))
         {
            this._cardEquipView.stopShine();
         }
      }
      
      private function getCellIndex(param1:ItemTemplateInfo) : String
      {
         if(EquipType.isWeddingRing(param1))
         {
            return "9,10,16";
         }
         switch(param1.CategoryID)
         {
            case EquipType.HEAD:
               return "0";
            case EquipType.GLASS:
               return "1";
            case EquipType.HAIR:
               return "2";
            case EquipType.EFF:
               return "3";
            case EquipType.CLOTH:
               return "4";
            case EquipType.FACE:
               return "5";
            case EquipType.ARM:
               return "6";
            case EquipType.ARMLET:
            case EquipType.TEMPARMLET:
               return "7,8";
            case EquipType.RING:
            case EquipType.TEMPRING:
               return "9,10";
            case EquipType.SUITS:
               return "11";
            case EquipType.NECKLACE:
               return "12";
            case EquipType.WING:
               return "13";
            case EquipType.CHATBALL:
               return "14";
            case EquipType.OFFHAND:
               return "15";
            case EquipType.HEALSTONE:
               return "18";
            case EquipType.TEMPWEAPON:
               return "6";
            case EquipType.BADGE:
               return "17";
            default:
               return "-1";
         }
      }
      
      public function get showSelfOperation() : Boolean
      {
         return this._showSelfOperation;
      }
      
      public function set showSelfOperation(param1:Boolean) : void
      {
         this._showSelfOperation = param1;
         this.updateShowOperation();
      }
      
      private function updateShowOperation() : void
      {
         this._honorNameTxt.visible = !this.showSelfOperation;
         this._playerInfoEffortHonorView.visible = this.showSelfOperation;
         this._storeBtn.visible = true;
         this._storeBtn.enable = this._showSelfOperation;
         this._buff.visible = this._showSelfOperation;
         this._buyAvatar.visible = !this._showSelfOperation && this._info != null && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID) && PlayerManager.Instance.Self.Grade > 2 && StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW && StateManager.currentStateType != StateType.TRAINER1 && StateManager.currentStateType != StateType.TRAINER2 && StateManager.currentStateType != StateType.HOT_SPRING_ROOM && StateManager.currentStateType != StateType.CHURCH_ROOM && StateManager.currentStateType != StateType.LITTLEGAME && StateManager.currentStateType != StateType.ROOM_LOADING;
         if(this._info is SelfInfo)
         {
            this._buyAvatar.visible = false;
         }
         this._hideGlassBtn.visible = this._hideHatBtn.visible = this._hideSuitBtn.visible = this._hideWingBtn.visible = this._showSelfOperation;
         this._info != null && this._info.ID != PlayerManager.Instance.Self.ID && (this._info.ZoneID == 0 || this._info.ZoneID == PlayerManager.Instance.Self.ZoneID);
         this._energyProgress.visible = this._energyBg.visible = this._energyTextBitmap.visible = this._energyAddBtn.visible = false;
         if(this._showSelfOperation && this._showEquip.visible)
         {
            this._openNecklacePtetrochemicalView.visible = true;
         }
         else
         {
            this._openNecklacePtetrochemicalView.visible = false;
         }
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(Boolean(this._openNecklacePtetrochemicalView.parent))
            {
               this._openNecklacePtetrochemicalView.parent.removeChild(this._openNecklacePtetrochemicalView);
            }
         }
         else if(!this._openNecklacePtetrochemicalView.parent && Boolean(PlayerManager.Instance.Self.Bag.items[12]))
         {
            addChild(this._openNecklacePtetrochemicalView);
         }
         if(!this._info || this._info.ID != PlayerManager.Instance.Self.ID || !this._showSelfOperation)
         {
            this._bagDefinitionBtnI.visible = false;
            this._bagDefinitionBtnII.visible = false;
            return;
         }
         this._bagDefinitionBtnI.visible = true;
         this._bagDefinitionBtnII.visible = true;
         if(Boolean(this._info))
         {
            if(this._info.IsShowConsortia && Boolean(this._info.ConsortiaName))
            {
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(!this._info.IsShowConsortia && EffortManager.Instance.getHonorArray().length > 0)
            {
               this._bagDefinitionGroup.selectIndex = 0;
            }
            else if(!this._info.IsShowConsortia && Boolean(this._info.ConsortiaName))
            {
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(this._info.IsShowConsortia && EffortManager.Instance.getHonorArray().length > 0)
            {
               this._bagDefinitionGroup.selectIndex = 0;
            }
            else
            {
               this._bagDefinitionBtnI.visible = false;
               this._bagDefinitionBtnII.visible = false;
            }
         }
      }
      
      private function getShowAcademyIcon() : Boolean
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(this._info.apprenticeshipState != AcademyManager.NONE_STATE)
            {
               return true;
            }
            return false;
         }
         if(this._info.ID == PlayerManager.Instance.Self.ID)
         {
            return true;
         }
         if(this._info.apprenticeshipState != AcademyManager.NONE_STATE)
         {
            return true;
         }
         return false;
      }
      
      public function setAchvEnable(param1:Boolean) : void
      {
         this._achvEnable = param1;
         this.updateShowOperation();
      }
      
      private function _definitionGroupChange(param1:Event = null) : void
      {
         if(param1 != null)
         {
            SoundManager.instance.play("008");
         }
         var _loc2_:Array = EffortManager.Instance.getHonorArray();
         if(_loc2_.length < 1 && !this._info.ConsortiaName)
         {
            this._bagDefinitionBtnI.visible = false;
            this._bagDefinitionBtnII.visible = false;
            return;
         }
         if(this._bagDefinitionGroup.selectIndex == 0)
         {
            if(_loc2_.length < 1)
            {
               if(Boolean(param1))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagInfo.notDesignation"));
               }
               this._bagDefinitionGroup.selectIndex = 1;
            }
            else if(Boolean(param1))
            {
               PlayerManager.Instance.Self.IsShowConsortia = false;
            }
         }
         else if(!this._info.ConsortiaName)
         {
            if(Boolean(param1))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagInfo.notSociaty"));
            }
            this._bagDefinitionGroup.selectIndex = 0;
         }
         else if(Boolean(param1))
         {
            PlayerManager.Instance.Self.IsShowConsortia = true;
         }
         if(Boolean(param1))
         {
            SocketManager.Instance.out.sendChangeDesignation(PlayerManager.Instance.Self.IsShowConsortia);
         }
      }
   }
}

