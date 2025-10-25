package ddt.manager
{
   import AvatarCollection.AvatarCollectionPackageType;
   import DDPlay.DDPlayType;
   import baglocked.BagLockedController;
   import boguAdventure.model.BoguAdventureType;
   import calendar.view.goodsExchange.SendGoodsExchangeInfo;
   import cardSystem.model.CardModel;
   import catchbeast.date.CatchBeastPackageType;
   import chickActivation.ChickActivationType;
   import christmas.data.ChristmasPackageType;
   import consortionBattle.ConsBatPackageType;
   import ddt.Version;
   import ddt.data.AccountInfo;
   import ddt.data.BagInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.socket.AcademyPackageType;
   import ddt.data.socket.ActivityPackageType;
   import ddt.data.socket.BattleGoundPackageType;
   import ddt.data.socket.CampPackageType;
   import ddt.data.socket.ChargePackageType;
   import ddt.data.socket.ChurchPackageType;
   import ddt.data.socket.ConsortiaPackageType;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.EliteGamePackageType;
   import ddt.data.socket.FarmPackageType;
   import ddt.data.socket.FightSpiritPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.HotSpringPackageType;
   import ddt.data.socket.IMPackageType;
   import ddt.data.socket.RechargePackageType;
   import ddt.data.socket.RegressPackageType;
   import ddt.data.socket.RingStationPackageType;
   import ddt.data.socket.SearchGoodsPackageType;
   import ddt.data.socket.SevenDayTargetPackageType;
   import ddt.data.socket.TreasurePackageType;
   import ddt.data.socket.ePackageType;
   import ddt.utils.CrytoUtils;
   import dragonBoat.DragonBoatPackageType;
   import email.manager.MailManager;
   import entertainmentMode.data.EntertainmentPackageType;
   import escort.EscortPackageType;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flowerGiving.data.FlowerGivingType;
   import gemstone.info.GemstnoeSendInfo;
   import godsRoads.data.GodsRoadsPkgType;
   import groupPurchase.GroupPurchasePackageType;
   import growthPackage.GrowthPackageType;
   import guildMemberWeek.data.GuildMemberWeekPackageType;
   import halloween.data.HalloweenType;
   import labyrinth.data.LabyrinthPackageType;
   import lanternriddles.data.LanternriddlesPackageType;
   import lightRoad.data.LightRoadPackageType;
   import magicStone.data.MagicStoneType;
   import newChickenBox.model.NewChickenBoxPackageType;
   import newChickenBox.view.NewChickenBoxItem;
   import playerDress.data.PlayerDressType;
   import quest.TrusteeshipPackageType;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   import road7th.math.randRange;
   import sevenDouble.SevenDoublePackageType;
   import superWinner.data.SuperWinnerPackageType;
   import trainer.controller.WeakGuildManager;
   import treasurePuzzle.data.TreasurePuzzlePackageType;
   import witchBlessing.data.WitchBlessingPackageType;
   import wonderfulActivity.data.SendGiftInfo;
   import worldBossHelper.data.WorldBossHelperTypeData;
   import worldboss.model.WorldBossGamePackageType;
   
   public class GameSocketOut
   {
      
      private var _socket:ByteSocket;
      
      public function GameSocketOut(param1:ByteSocket)
      {
         super();
         this._socket = param1;
      }
      
      public function sendLogin(param1:AccountInfo) : void
      {
         this._socket.resetKey();
         var _loc2_:Date = new Date();
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:int = randRange(100,10000);
         _loc3_.writeShort(_loc2_.fullYearUTC);
         _loc3_.writeByte(_loc2_.monthUTC + 1);
         _loc3_.writeByte(_loc2_.dateUTC);
         _loc3_.writeByte(_loc2_.hoursUTC);
         _loc3_.writeByte(_loc2_.minutesUTC);
         _loc3_.writeByte(_loc2_.secondsUTC);
         var _loc5_:Array = [Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255),Math.ceil(Math.random() * 255)];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc3_.writeByte(_loc5_[_loc6_]);
            _loc6_++;
         }
         _loc3_.writeUTFBytes(param1.Account + "," + param1.Password);
         _loc3_ = CrytoUtils.rsaEncry5(param1.Key,_loc3_);
         _loc3_.position = 0;
         var _loc7_:PackageOut = new PackageOut(ePackageType.LOGIN);
         _loc7_.writeInt(Version.Build);
         _loc7_.writeInt(DesktopManager.Instance.desktopType);
         _loc7_.writeBytes(_loc3_);
         this.sendPackage(_loc7_);
         this._socket.setKey(_loc5_);
      }
      
      public function sendWeeklyClick() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WEEKLY_CLICK_CNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendGameLogin(param1:int, param2:int, param3:int = -1, param4:String = "", param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc6_.writeInt(GameRoomPackageType.GAME_ROOM_LOGIN);
         _loc6_.writeBoolean(param5);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         if(param2 == -1)
         {
            _loc6_.writeInt(param3);
            _loc6_.writeUTF(param4);
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendFastInviteCall() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.FAST_INVITE_CALL);
         this.sendPackage(_loc1_);
      }
      
      public function sendFastAuctionCall() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.FAST_INVITE_CALL);
         this.sendPackage(_loc1_);
      }
      
      public function sendSceneLogin(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_LOGIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGameStyle(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDailyAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDaySign(param1:Date) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DAILY_AWARD);
         _loc2_.writeInt(6);
         _loc2_.writeDate(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSignAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GET_SIGNAWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGoods(param1:Array, param2:Array, param3:Array, param4:Array, param5:Array, param6:Array = null, param7:int = 0, param8:Array = null, param9:Array = null) : void
      {
         var _loc13_:Array = null;
         if(param1.length > 50)
         {
            if(Boolean(param9) && param9.length > 50)
            {
               _loc13_ = param9.splice(0,50);
            }
            else
            {
               _loc13_ = param9;
            }
            this.sendBuyGoods(param1.splice(0,50),param2.splice(0,50),param3.splice(0,50),param4.splice(0,50),param5.splice(0,50),param6.splice(0,50),param7,param8,_loc13_);
            this.sendBuyGoods(param1,param2,param3,param4,param5,param6,param7,param8,param9);
            return;
         }
         var _loc10_:PackageOut = new PackageOut(ePackageType.BUY_GOODS);
         var _loc11_:int = int(param1.length);
         _loc10_.writeInt(_loc11_);
         var _loc12_:uint = 0;
         while(_loc12_ < _loc11_)
         {
            if(!param8)
            {
               _loc10_.writeInt(1);
            }
            else
            {
               _loc10_.writeInt(param8[_loc12_]);
            }
            _loc10_.writeInt(param1[_loc12_]);
            _loc10_.writeInt(param2[_loc12_]);
            _loc10_.writeUTF(param3[_loc12_]);
            _loc10_.writeBoolean(param5[_loc12_]);
            if(param6 == null)
            {
               _loc10_.writeUTF("");
            }
            else
            {
               _loc10_.writeUTF(param6[_loc12_]);
            }
            _loc10_.writeInt(param4[_loc12_]);
            if(Boolean(param9))
            {
               _loc10_.writeBoolean(param9[_loc12_]);
            }
            else
            {
               _loc10_.writeBoolean(false);
            }
            _loc12_++;
         }
         _loc10_.writeInt(param7);
         this.sendPackage(_loc10_);
      }
      
      public function sendButTransnationalGoods(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TRANSNATIONAL_BUYGOODS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyProp(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendSellProp(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuickBuyGoldBox(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.BUY_QUICK_GOLDBOX);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBuyGiftBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BUY_GIFTBAG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPresentGoods(param1:Array, param2:Array, param3:Array, param4:Array, param5:String, param6:String, param7:Array = null, param8:Array = null) : void
      {
         var _loc9_:PackageOut = new PackageOut(ePackageType.GOODS_PRESENT);
         var _loc10_:int = int(param1.length);
         _loc9_.writeUTF(param5);
         _loc9_.writeUTF(param6);
         _loc9_.writeInt(_loc10_);
         var _loc11_:uint = 0;
         while(_loc11_ < _loc10_)
         {
            _loc9_.writeInt(param1[_loc11_]);
            _loc9_.writeInt(param2[_loc11_]);
            _loc9_.writeUTF(param3[_loc11_]);
            if(param7 == null)
            {
               _loc9_.writeUTF("");
            }
            else
            {
               _loc9_.writeUTF(param7[_loc11_]);
            }
            _loc9_.writeInt(param4[_loc11_]);
            _loc11_++;
         }
         this.sendPackage(_loc9_);
      }
      
      public function sendGoodsContinue(param1:Array) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_CONTINUE);
         _loc3_.writeInt(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeByte(param1[_loc4_][0]);
            _loc3_.writeInt(param1[_loc4_][1]);
            _loc3_.writeInt(param1[_loc4_][2]);
            _loc3_.writeByte(param1[_loc4_][3]);
            _loc3_.writeBoolean(param1[_loc4_][4]);
            _loc3_.writeInt(param1[_loc4_][5]);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendSellGoods(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEll_GOODS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateGoodsCount() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GOODS_COUNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendEmail(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEND_MAIL);
         _loc2_.writeUTF(param1.NickName);
         _loc2_.writeUTF(param1.Title);
         _loc2_.writeUTF(param1.Content);
         _loc2_.writeBoolean(param1.isPay);
         _loc2_.writeInt(param1.hours);
         _loc2_.writeInt(param1.SendedMoney);
         while(_loc3_ < MailManager.Instance.NUM_OF_WRITING_DIAMONDS)
         {
            if(Boolean(param1["Annex" + _loc3_]))
            {
               _loc2_.writeByte(param1["Annex" + _loc3_].split(",")[0]);
               _loc2_.writeInt(param1["Annex" + _loc3_].split(",")[1]);
               _loc2_.writeInt(param1.Count);
            }
            else
            {
               _loc2_.writeByte(0);
               _loc2_.writeInt(-1);
               _loc2_.writeInt(0);
            }
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateMail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.UPDATE_MAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDeleteMail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DELETE_MAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function untreadEmail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MAIL_CANCEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetMail(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GET_MAIL_ATTACHMENT);
         _loc3_.writeInt(param1);
         _loc3_.writeByte(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPint() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PING);
         this.sendPackage(_loc1_);
      }
      
      public function sendSuicide(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.SUICIDE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendKillSelf(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.KILLSELF);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemCompose(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ITEM_COMPOSE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendItemTransfer(param1:Boolean = true, param2:Boolean = true, param3:int = 12, param4:int = 0, param5:int = 12, param6:int = 1) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.ITEM_TRANSFER);
         _loc7_.writeBoolean(param1);
         _loc7_.writeBoolean(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeInt(param6);
         this.sendPackage(_loc7_);
      }
      
      public function sendItemStrength(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_STRENGTHEN);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemExalt() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ITEM_ADVANCE);
         this.sendPackage(_loc1_);
      }
      
      public function sendItemLianhua(param1:int, param2:int, param3:Array, param4:int, param5:int, param6:int, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.ITEM_REFINERY);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         var _loc9_:int = 0;
         while(_loc9_ < param3.length)
         {
            _loc8_.writeInt(param3[_loc9_]);
            _loc9_++;
         }
         _loc8_.writeInt(param4);
         _loc8_.writeInt(param5);
         _loc8_.writeInt(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendBeadEquip(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         _loc3_.writeByte(CrazyTankPackageType.RUNE_MOVEPLACE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBeadUpgrade(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         _loc2_.writeByte(CrazyTankPackageType.RUNE_UPGRADE);
         _loc2_.writeInt(param1.length);
         for each(_loc3_ in param1)
         {
            _loc2_.writeInt(_loc3_);
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenBead(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         _loc3_.writeByte(CrazyTankPackageType.RUNE_OPENPACKAGE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBeadLock(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         _loc2_.writeByte(CrazyTankPackageType.RUNE_LOCK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeadOpenHole(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.RUNE_COMMAND);
         _loc3_.writeByte(CrazyTankPackageType.RUNE_OPEN_HOLE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemEmbedBackout(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_EMBED_BACKOUT);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendItemOpenFiveSixHole(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.OPEN_FIVE_SIX_HOLE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemTrend(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.ITEM_TREND);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeInt(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendClearStoreBag() : void
      {
         PlayerManager.Instance.Self.StoreBag.items.clear();
         var _loc1_:PackageOut = new PackageOut(ePackageType.CLEAR_STORE_BAG);
         this.sendPackage(_loc1_);
      }
      
      public function sendCheckCode(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CHECK_CODE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEquipRetrieve() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EQUIP_RECYCLE_ITEM);
         this.sendPackage(_loc1_);
      }
      
      public function sendItemFusion(param1:int, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ITEM_FUSION);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendSBugle(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.S_BUGLE);
         _loc2_.writeInt(PlayerManager.Instance.Self.ID);
         _loc2_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBBugle(param1:String, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.B_BUGLE);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(PlayerManager.Instance.Self.ID);
         _loc3_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc3_.writeUTF(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendCBugle(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.C_BUGLE);
         _loc2_.writeInt(PlayerManager.Instance.Self.ID);
         _loc2_.writeUTF(PlayerManager.Instance.Self.NickName);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDefyAffiche(param1:String, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.DEFY_AFFICHE);
         _loc3_.writeBoolean(param2);
         _loc3_.writeUTF(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendGameMode(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAddFriend(param1:String, param2:int, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(param1 == "")
         {
            return;
         }
         var _loc5_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc5_.writeByte(IMPackageType.FRIEND_ADD);
         _loc5_.writeUTF(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeBoolean(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendDelFriend(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc2_.writeByte(IMPackageType.FRIEND_REMOVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendFriendState(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc2_.writeByte(IMPackageType.FRIEND_STATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBagLocked(param1:String, param2:int, param3:String = "", param4:String = "", param5:String = "", param6:String = "", param7:String = "") : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.BAG_LOCKED);
         BagLockedController.TEMP_PWD = param3 != "" ? param3 : param1;
         _loc8_.writeUTF(param1);
         _loc8_.writeUTF(param3);
         _loc8_.writeInt(param2);
         _loc8_.writeUTF(param4);
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeUTF(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendBagLockedII(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
      }
      
      public function sendConsortiaEquipConstrol(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendErrorMsg(param1:String) : void
      {
         var _loc2_:PackageOut = null;
         if(param1.length < 1000)
         {
            _loc2_ = new PackageOut(ePackageType.CLIENT_LOG);
            _loc2_.writeUTF(param1);
            this.sendPackage(_loc2_);
         }
      }
      
      public function sendItemOverDue(param1:int, param2:int) : void
      {
         if(param1 == -1)
         {
            return;
         }
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_OVERDUE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendHideLayer(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_HIDE);
         _loc3_.writeBoolean(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestAdd(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_ADD);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == 3025)
            {
            }
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestRemove(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_REMOVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQuestFinish(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.QUEST_FINISH);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestOneToFinish(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUEST_ONEKEYFINISH);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendImproveQuest(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.QUEST_LEVEL_UP);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendQuestCheck(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.QUEST_CHECK);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendItemOpenUp(param1:int, param2:int, param3:int = 1, param4:Boolean = false) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.ITEM_OPENUP);
         _loc5_.writeByte(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendItemEquip(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ITEM_EQUIP);
         if(!param2)
         {
            _loc3_.writeBoolean(true);
            _loc3_.writeInt(param1);
         }
         else if(param2)
         {
            _loc3_.writeBoolean(false);
            _loc3_.writeUTF(param1);
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendMateTime(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MATE_ONLINE_TIME);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPlayerGift(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_GET_GIFTS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendActivePullDown(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVE_PULLDOWN);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function auctionGood(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:Boolean) : void
      {
         var _loc9_:PackageOut = new PackageOut(ePackageType.AUCTION_ADD);
         _loc9_.writeByte(param1);
         _loc9_.writeInt(param2);
         _loc9_.writeByte(param3);
         _loc9_.writeInt(param4);
         _loc9_.writeInt(param5);
         _loc9_.writeInt(param6);
         _loc9_.writeInt(param7);
         _loc9_.writeBoolean(param8);
         this.sendPackage(_loc9_);
      }
      
      public function auctionCancelSell(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.AUCTION_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function auctionBid(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.AUCTION_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function syncStep(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         _loc3_.writeByte(1);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function syncWeakStep(param1:int) : void
      {
         WeakGuildManager.Instance.setStepFinish(param1);
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_ANSWER);
         _loc2_.writeByte(2);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendCreateConsortia(param1:String, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_CREATE);
         _loc3_.writeUTF(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaTryIn(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaCancelTryIn() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN);
         _loc1_.writeInt(0);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaInvate(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReleaseConsortiaTask(param1:int, param2:Boolean = true, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc4_.writeInt(ConsortiaPackageType.CONSORTIA_TASK_RELEASE);
         _loc4_.writeInt(param1);
         if(param1 == 0)
         {
            _loc4_.writeInt(param3);
         }
         else
         {
            _loc4_.writeBoolean(param2);
         }
         this.sendPackage(_loc4_);
      }
      
      public function addSpeed(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         _loc3_.writeByte(ActivityPackageType.REUSEMONEYPOINT_COMPLETE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaInvatePass(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_PASS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaInvateDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_INVITE_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdateDescription(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdatePlacard(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaUpdateDuty(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc4_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         _loc4_.writeInt(param1);
         _loc4_.writeByte(param1 == -1 ? 1 : 2);
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendConsortiaUpgradeDuty(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeByte(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsoritaApplyStatusOut(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_APPLY_STATE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_RENEGADE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaMemberGrade(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaUserRemarkUpdate(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaDutyDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_DUTY_DELETE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryinPass(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_PASS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaTryinDelete(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_TRYIN_DEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendForbidSpeak(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaDismiss() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc1_.writeInt(ConsortiaPackageType.CONSORTIA_DISBAND);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsortiaChangeChairman(param1:String = "") : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaRichOffer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_RICHES_OFFER);
         _loc2_.writeInt(param1);
         _loc2_.writeBoolean(false);
         this.sendPackage(_loc2_);
      }
      
      public function sendDonate(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.DONATE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortiaLevelUp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.CONSORTIA_LEVEL_UP);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAirPlane() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.AIRPLANE);
         this.sendPackage(_loc1_);
      }
      
      public function useDeputyWeapon() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.USE_DEPUTY_WEAPON);
         this.sendPackage(_loc1_);
      }
      
      public function sendGamePick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.PICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPetSkill(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.PET_SKILL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPackage(param1:PackageOut) : void
      {
         this._socket.send(param1);
      }
      
      public function sendMoveGoods(param1:int, param2:int, param3:int, param4:int, param5:int = 1, param6:Boolean = false) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS);
         _loc7_.writeByte(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeByte(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeBoolean(param6);
         this.sendPackage(_loc7_);
      }
      
      public function reclaimGoods(param1:int, param2:int, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.REClAIM_GOODS);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendMoveGoodsAll(param1:int, param2:Array, param3:int, param4:Boolean = false) : void
      {
         if(param2.length <= 0)
         {
            return;
         }
         var _loc5_:int = int(param2.length);
         var _loc6_:PackageOut = new PackageOut(ePackageType.CHANGE_PLACE_GOODS_ALL);
         _loc6_.writeBoolean(param4);
         _loc6_.writeInt(_loc5_);
         _loc6_.writeInt(param1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_.writeInt(param2[_loc7_].Place);
            _loc6_.writeInt(_loc7_ + param3);
            _loc7_++;
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendForSwitch() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ENTHRALL_SWITCH);
         this.sendPackage(_loc1_);
      }
      
      public function sendCIDCheck() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         this.sendPackage(_loc1_);
      }
      
      public function sendCIDInfo(param1:String, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CID_CHECK);
         _loc3_.writeBoolean(false);
         _loc3_.writeUTF(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeColor(param1:int, param2:int, param3:int, param4:int, param5:String, param6:String, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.USE_COLOR_CARD);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         _loc8_.writeInt(param3);
         _loc8_.writeInt(param4);
         _loc8_.writeUTF(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendUseCard(param1:int, param2:int, param3:Array, param4:int, param5:Boolean = false, param6:Boolean = true, param7:int = 1) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.CARD_USE);
         _loc8_.writeInt(param1);
         _loc8_.writeInt(param2);
         _loc8_.writeInt(param3.length);
         var _loc9_:int = int(param3.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_.writeInt(param3[_loc10_]);
            _loc10_++;
         }
         _loc8_.writeInt(param4);
         _loc8_.writeBoolean(param5);
         _loc8_.writeBoolean(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendUseProp(param1:int, param2:int, param3:Array, param4:int, param5:Boolean = false) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.PROP_USE);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3.length);
         var _loc7_:int = int(param3.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_.writeInt(param3[_loc8_]);
            _loc8_++;
         }
         _loc6_.writeInt(param4);
         _loc6_.writeBoolean(param5);
         this.sendPackage(_loc6_);
      }
      
      public function sendUseChangeColorShell(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USE_CHANGE_COLOR_SHELL);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChangeColorShellTimeOver(param1:int, param2:int) : void
      {
         if(param1 == -1)
         {
            return;
         }
         var _loc3_:PackageOut = new PackageOut(ePackageType.CHANGE_COLOR_OVER_DUE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRouletteBox(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendStartTurn(param1:int = 1) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LOTTERY_RANDOM_SELECT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendFinishRoulette() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LOTTERY_FINISH);
         this.sendPackage(_loc1_);
      }
      
      public function sendSellAll() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CADDY_SELL_ALL_GOODS);
         this.sendPackage(_loc1_);
      }
      
      public function sendconverted(param1:Boolean, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CADDY_CONVERTED_ALL);
         _loc4_.writeBoolean(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendExchange() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CADDY_EXCHANGE_ALL);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenAll() : void
      {
      }
      
      public function sendOpenDead(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LOTTERY_OPEN_BOX);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendRequestAwards(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CADDY_GET_AWARDS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQequestBadLuck(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CADDY_GET_BADLUCK);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendQequestLuckky(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LUCKSTONE_RANK_LIMIT);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUseReworkName(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.USE_REWORK_NAME);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUseConsortiaReworkName(param1:int, param2:int, param3:int, param4:String) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.USE_CONSORTIA_REWORK_NAME);
         _loc5_.writeInt(param1);
         _loc5_.writeByte(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeUTF(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendValidateMarry(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_STATUS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPropose(param1:int, param2:String, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.MARRY_APPLY);
         _loc5_.writeInt(param1);
         _loc5_.writeUTF(param2);
         _loc5_.writeBoolean(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendProposeRespose(param1:Boolean, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_APPLY_REPLY);
         _loc4_.writeBoolean(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUnmarry(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.DIVORCE_APPLY);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendMarryRoomLogin() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_LOGIN);
         this.sendPackage(_loc1_);
      }
      
      public function sendExitMarryRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         this.sendPackage(_loc1_);
      }
      
      public function sendCreateRoom(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:String, param7:int) : void
      {
         var _loc8_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_CREATE);
         _loc8_.writeUTF(param1);
         _loc8_.writeUTF(param2);
         _loc8_.writeInt(param3);
         _loc8_.writeInt(param4);
         _loc8_.writeInt(100);
         _loc8_.writeBoolean(param5);
         _loc8_.writeUTF(param6);
         _loc8_.writeInt(param7);
         this.sendPackage(_loc8_);
      }
      
      public function sendEnterRoom(param1:int, param2:String, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_LOGIN);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendExitRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PLAYER_EXIT_MARRY_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function sendCurrentState(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_STATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateRoomList(param1:int, param2:int, param3:int = 10000, param4:int = 1011) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.ROOMLIST_UPDATE);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         if(param1 == 2 && param2 == -2)
         {
            _loc5_.writeInt(param3);
            _loc5_.writeInt(param4);
         }
         this.sendPackage(_loc5_);
      }
      
      public function sendChurchMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc4_.writeByte(ChurchPackageType.MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendStartWedding(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.HYMENEAL);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchContinuation(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.CONTINUATION);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchInvite(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.INVITE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchLargess(param1:uint) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.LARGESS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function refund() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         _loc1_.writeByte(ChurchPackageType.CLIENTCONFIRM);
         this.sendPackage(_loc1_);
      }
      
      public function requestRefund() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc1_.writeByte(ChurchPackageType.MARRYROOMSENDGIFT);
         _loc1_.writeByte(ChurchPackageType.BEGINSENDGIFT);
         this.sendPackage(_loc1_);
      }
      
      public function sendUseFire(param1:int, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc4_.writeByte(ChurchPackageType.USEFIRECRACKERS);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendChurchKick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.KICK);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChurchMovieOver(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CHURCH_MOVIE_OVER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChurchForbid(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc2_.writeByte(ChurchPackageType.FORBID);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPosition(param1:Number, param2:Number) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.POSITION);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendModifyChurchDiscription(param1:String, param2:Boolean, param3:String, param4:String) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.MARRY_ROOM_INFO_UPDATE);
         _loc5_.writeUTF(param1);
         _loc5_.writeBoolean(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeUTF(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendSceneChange(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRY_SCENE_CHANGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGunSalute(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MARRY_CMD);
         _loc3_.writeByte(ChurchPackageType.GUNSALUTE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRegisterInfo(param1:int, param2:Boolean, param3:String = null) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MARRYINFO_ADD);
         _loc4_.writeBoolean(param2);
         _loc4_.writeUTF(param3);
         _loc4_.writeInt(param1);
         this.sendPackage(_loc4_);
      }
      
      public function sendModifyInfo(param1:Boolean, param2:String = null) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_UPDATE);
         _loc3_.writeBoolean(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendForMarryInfo(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MARRYINFO_GET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetLinkGoodsInfo(param1:int, param2:String, param3:String = "") : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.LINKREQUEST_GOODS);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendGetTropToBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function createUserGuide(param1:int = 10) : void
      {
         var _loc2_:String = String(Math.random());
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc3_.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         _loc3_.writeByte(param1);
         _loc3_.writeByte(3);
         _loc3_.writeUTF("");
         _loc3_.writeUTF(_loc2_);
         this.sendPackage(_loc3_);
      }
      
      public function enterUserGuide(param1:int, param2:int = 10) : void
      {
         var _loc3_:String = String(Math.random());
         var _loc4_:int = PlayerManager.Instance.Self.Grade < 5 ? 4 : 3;
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         _loc5_.writeInt(param1);
         _loc5_.writeByte(param2);
         _loc5_.writeBoolean(false);
         _loc5_.writeUTF(_loc3_);
         _loc5_.writeUTF("");
         _loc5_.writeByte(_loc4_);
         _loc5_.writeByte(0);
         _loc5_.writeInt(0);
         _loc5_.writeBoolean(false);
         _loc5_.writeInt(0);
         this.sendPackage(_loc5_);
      }
      
      public function userGuideStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_START);
         this.sendPackage(_loc1_);
      }
      
      public function sendSaveDB() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SAVE_DB);
         this.sendPackage(_loc1_);
      }
      
      public function createMonster() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(0);
         this.sendPackage(_loc1_);
      }
      
      public function deleteMonster() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomCreate(param1:*) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_CREATE);
         _loc2_.writeUTF(param1.roomName);
         _loc2_.writeUTF(param1.roomPassword);
         _loc2_.writeUTF(param1.roomIntroduction);
         _loc2_.writeInt(param1.maxCount);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomEdit(param1:*) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_EDIT);
         _loc2_.writeUTF(param1.roomName);
         _loc2_.writeUTF(param1.roomPassword);
         _loc2_.writeUTF(param1.roomIntroduction);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomQuickEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_QUICK_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomEnterConfirm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomEnter(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendHotSpringRoomEnterView(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_ENTER_VIEW);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomPlayerRemove() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendHotSpringRoomPlayerTargetPoint(param1:*) : void
      {
         var _loc5_:uint = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.TARGET_POINT);
         var _loc3_:Array = param1.walkPath.concat();
         var _loc4_:Array = [];
         while(_loc5_ < _loc3_.length)
         {
            _loc4_.push(int(_loc3_[_loc5_].x),int(_loc3_[_loc5_].y));
            _loc5_++;
         }
         var _loc6_:String = _loc4_.toString();
         _loc2_.writeUTF(_loc6_);
         _loc2_.writeInt(param1.playerInfo.ID);
         _loc2_.writeInt(param1.currentWalkStartPoint.x);
         _loc2_.writeInt(param1.currentWalkStartPoint.y);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1.playerDirection);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomRenewalFee(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomInvite(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_INVITE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomAdminRemovePlayer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_ADMIN_REMOVE_PLAYER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendHotSpringRoomPlayerContinue(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.HOTSPRING_CMD);
         _loc2_.writeByte(HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetTimeBox(param1:int, param2:int, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GET_TIME_BOX);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendAchievementFinish(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACHIEVEMENT_FINISH);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReworkRank(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_CHANGE_RANK);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLookupEffort(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LOOKUP_EFFORT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBeginFightNpc() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FIGHT_NPC);
         this.sendPackage(_loc1_);
      }
      
      public function sendRequestUpdate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.REQUEST_UPDATE);
         this.sendPackage(_loc1_);
      }
      
      public function sendQuestionReply(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.QUESTION_REPLY);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenVip(param1:String, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.VIP_RENEWAL);
         _loc4_.writeUTF(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendAcademyRegister(param1:int, param2:Boolean, param3:String = null, param4:Boolean = false) : void
      {
         var _loc5_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc5_.writeByte(AcademyPackageType.ACADEMY_REGISTER);
         _loc5_.writeInt(param1);
         _loc5_.writeBoolean(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendAcademyRemoveRegister() : void
      {
         var _loc1_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc1_.writeByte(AcademyPackageType.ACADEMY_REMOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendAcademyApprentice(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc3_.writeByte(AcademyPackageType.ACADEMY_FOR_APPRENTICE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyMaster(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc3_.writeByte(AcademyPackageType.ACADEMY_FOR_MASTER);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyMasterConfirm(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(param1)
         {
            _loc3_.writeByte(AcademyPackageType.MASTER_CONFIRM);
         }
         else
         {
            _loc3_.writeByte(AcademyPackageType.MASTER_REFUSE);
         }
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyApprenticeConfirm(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         if(param1)
         {
            _loc3_.writeByte(AcademyPackageType.APPRENTICE_CONFIRM);
         }
         else
         {
            _loc3_.writeByte(AcademyPackageType.APPRENTICE_REFUSE);
         }
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendAcademyFireMaster(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc2_.writeByte(AcademyPackageType.FIRE_MASTER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAcademyFireApprentice(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(AcademyPackageType.ACADEMY_FATHER);
         _loc2_.writeByte(AcademyPackageType.FIRE_APPRENTICE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUseLog(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USE_LOG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyGift(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.USER_SEND_GIFTS);
         _loc5_.writeUTF(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendReloadGift() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.USER_RELOAD_GIFT);
         this.sendPackage(_loc1_);
      }
      
      public function sendSnsMsg(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SNS_MSG_RECEIVE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function getPlayerCardInfo(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GET_PLAYER_CARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendMoveCards(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc3_.writeInt(0);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendOpenViceCard(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenCardBox(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc3_.writeInt(1);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendOpenRandomBox(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc3_.writeInt(4);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendUpGradeCard(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc2_.writeInt(2);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendUpdateSLOT(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CARDS_SLOT);
         _loc3_.writeInt(0);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendResetCardSoul(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_SLOT);
         _loc2_.writeInt(1);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendCardReset(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARD_RESET);
         _loc2_.writeInt(0);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendReplaceCardProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARD_RESET);
         _loc2_.writeInt(1);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSortCards(param1:Vector.<int>) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc2_.writeInt(2);
         var _loc3_:int = int(param1.length);
         _loc2_.writeInt(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc4_ + CardModel.EQUIP_CELLS_SUM;
            _loc2_.writeInt(_loc5_);
            _loc2_.writeInt(_loc6_);
            _loc4_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendFirstGetCards() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc1_.writeInt(3);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetCardSoul() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CARDS_DATA);
         _loc1_.writeInt(5);
         this.sendPackage(_loc1_);
      }
      
      public function sendFace(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_FACE);
         _loc2_.writeInt(param1);
         _loc2_.writeInt(0);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpition(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.OPTION_UPDATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionMail(param1:String, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTION_MAIL);
         _loc3_.writeUTF(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsortionPoll(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.POLL_CANDIDATE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortionSkill(param1:Boolean, param2:int, param3:int, param4:int = 1) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc5_.writeInt(ConsortiaPackageType.SKILL_SOCKET);
         _loc5_.writeBoolean(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendOns() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc1_.writeByte(IMPackageType.ONS_EQUIP);
         this.sendPackage(_loc1_);
      }
      
      public function sendWithBrithday(param1:Vector.<FriendListPlayer>) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FRIEND_BRITHDAY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_].ID);
            _loc2_.writeUTF(param1[_loc3_].NickName);
            _loc2_.writeDate(param1[_loc3_].BirthdayDate);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendChangeDesignation(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.USER_RANK);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendDailyRecord() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.DAILYRECORD);
         this.sendPackage(_loc1_);
      }
      
      public function sendCollectInfoValidate(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.COLLECTINFO);
         _loc4_.writeByte(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendGoodsExchange(param1:Vector.<SendGoodsExchangeInfo>, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GOODS_EXCHANGE);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_.writeInt(param1[_loc6_].id);
            _loc5_.writeInt(param1[_loc6_].place);
            _loc5_.writeInt(param1[_loc6_].bagType);
            _loc6_++;
         }
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendTexp(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.TEXP);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendCustomFriends(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc4_.writeByte(IMPackageType.ADD_CUSTOM_FRIENDS);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendOneOnOneTalk(param1:int, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.IM_CMD);
         _loc4_.writeByte(IMPackageType.ONE_ON_ONE_TALK);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendUserLuckyNum(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USER_LUCKYNUM);
         _loc3_.writeBoolean(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendPicc(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PICC);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBuyBadge(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc2_.writeInt(ConsortiaPackageType.BUY_BADGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetEliteGameState() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc1_.writeByte(EliteGamePackageType.ELITE_MATCH_TYPE);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetSelfRankSroce() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc1_.writeByte(EliteGamePackageType.ELITE_MATCH_PLAYER_RANK);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetPaarungDetail(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc2_.writeByte(EliteGamePackageType.ELITE_MATCH_RANK_DETAIL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEliteGameStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ELITEGAME);
         _loc1_.writeByte(EliteGamePackageType.ELITE_MATCH_RANK_START);
         this.sendPackage(_loc1_);
      }
      
      public function sendStartTurn_LeftGun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_SOCKET);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendEndTurn_LeftGun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LEFT_GUN_ROULETTE_COMPLETTE);
         _loc1_.writeInt(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendWishBeadEquip(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.WISHBEADEQUIP);
         _loc7_.writeInt(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeInt(param4);
         _loc7_.writeInt(param5);
         _loc7_.writeInt(param6);
         this.sendPackage(_loc7_);
      }
      
      public function sendPetMove(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.MOVE_PETBAG);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetFightUnFight(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.FIGHT_PET);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetFeed(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.FEED_PET);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendEquipPetSkill(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.EQUIP_PET_SKILL);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendPetRename(param1:int, param2:String, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.RENAME_PET);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendReleasePet(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.RELEASE_PET);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendAdoptPet(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.ADOPT_PET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendRefreshPet(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.REFRESH_PET);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendUpdatePet(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.UPDATE_PET);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPaySkill(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(CrazyTankPackageType.PAY_SKILL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAddPet(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.ADD_PET);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function enterFarm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.ENTER_FARM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function seeding(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.GROW_FIELD);
         _loc3_.writeByte(13);
         _loc3_.writeInt(param2);
         _loc3_.writeInt(param1);
         this.sendPackage(_loc3_);
      }
      
      public function arrange(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         _loc2_.writeInt(TreasurePackageType.ARRANGE_FRIEND_FARM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function enterTreasure() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         _loc1_.writeInt(TreasurePackageType.IN_TREASURE);
         this.sendPackage(_loc1_);
      }
      
      public function startTreasure() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         _loc1_.writeInt(TreasurePackageType.START_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function endTreasure() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         _loc1_.writeInt(TreasurePackageType.END_TREASURE);
         this.sendPackage(_loc1_);
      }
      
      public function doTreasure(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TREASURE_IN);
         _loc2_.writeInt(TreasurePackageType.DIG);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendCompose(param1:int, param2:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.COMPOSE_FOOD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function doMature(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc4_.writeByte(FarmPackageType.ACCELERATE_FIELD);
         _loc4_.writeByte(13);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param3);
         _loc4_.writeInt(param2);
         this.sendPackage(_loc4_);
      }
      
      public function toGather(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.GAIN_FIELD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function toSpread(param1:Array, param2:int, param3:Boolean) : void
      {
         var _loc5_:int = 0;
         if(!param1 || param1.length == 0)
         {
            return;
         }
         var _loc4_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc4_.writeByte(FarmPackageType.PAY_FIELD);
         _loc4_.writeInt(param1.length);
         for each(_loc5_ in param1)
         {
            _loc4_.writeInt(_loc5_);
         }
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendWish() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.WISHOFDD);
         this.sendPackage(_loc1_);
      }
      
      public function sendChangeSex(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.USE_CHANGE_SEX);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function toFarmHelper(param1:Array, param2:Boolean) : void
      {
         var _loc5_:Object = null;
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.HELPER_SWITCH_FIELD);
         _loc3_.writeInt(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc3_.writeInt(_loc5_.currentfindIndex);
            _loc3_.writeInt(_loc5_.currentSeedText);
            _loc3_.writeInt(_loc5_.currentSeedNum);
            _loc3_.writeInt(_loc5_.currentFertilizerText);
            _loc3_.writeInt(_loc5_.autoFertilizerNum);
            _loc3_.writeBoolean(param2);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendBeginHelper(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.HELPER_SWITCH_FIELD);
         _loc2_.writeBoolean(param1[0]);
         if(Boolean(param1[0]))
         {
            _loc2_.writeInt(param1[1]);
            _loc2_.writeInt(param1[2]);
            _loc2_.writeInt(param1[3]);
            _loc2_.writeInt(param1[4]);
            _loc2_.writeInt(param1[5]);
            _loc2_.writeInt(param1[6]);
            _loc2_.writeBoolean(param1[7]);
         }
         this.sendPackage(_loc2_);
      }
      
      public function toKillCrop(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.KILLCROP_FIELD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function toHelperRenewMoney(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc3_.writeByte(FarmPackageType.HELPER_PAY_FIELD);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function exitFarm(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.EXIT_FARM);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function fastForwardGrop(param1:Boolean, param2:Boolean, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc4_.writeByte(FarmPackageType.FRAM_GROP_FASTFORWARD);
         _loc4_.writeBoolean(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function giftPacks(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FARM);
         _loc2_.writeByte(FarmPackageType.FARM_GIFTPACKS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function getPlayerPropertyAddition() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.UPDATE_PLAYER_PROPERTY);
         this.sendPackage(_loc1_);
      }
      
      public function enterWorldBossRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.ENTER_WORLDBOSSROOM);
         this.sendPackage(_loc1_);
      }
      
      public function openOrCloseWorldBossHelper(param1:WorldBossHelperTypeData) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.ASSISTANT);
         _loc2_.writeByte(param1.requestType);
         if(param1.requestType == 2)
         {
            _loc2_.writeBoolean(param1.isOpen);
            _loc2_.writeInt(param1.buffNum);
            _loc2_.writeInt(param1.type);
            _loc2_.writeInt(param1.openType);
         }
         this.sendPackage(_loc2_);
      }
      
      public function quitWorldBossHelperView() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.ENTRYSCENES);
         _loc1_.writeBoolean(false);
         this.sendPackage(_loc1_);
      }
      
      public function sendAddPlayer(param1:Point) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.ADDPLAYERS);
         _loc2_.writeInt(param1.x);
         _loc2_.writeInt(param1.y);
         this.sendPackage(_loc2_);
      }
      
      public function sendWorldBossRoomMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc4_.writeByte(WorldBossGamePackageType.MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendWorldBossRoomStauts(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.STAUTS);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLeaveBossRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc1_.writeByte(WorldBossGamePackageType.LEAVE_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function sendBuyWorldBossBuff(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc2_.writeByte(WorldBossGamePackageType.BUFF_BUY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function gotoCardLottery() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GOTO_CARD_LOTTERY);
         this.sendPackage(_loc1_);
      }
      
      public function sendCardLotteryIds(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CARD_LOTTERY);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeInt(param1[_loc3_]);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendNewBuyWorldBossBuff(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.WORLDBOSS_CMD);
         _loc3_.writeByte(WorldBossGamePackageType.BUFF_BUY);
         _loc3_.writeInt(1);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendLuckLottery() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LUCK_LOTTERY);
         this.sendPackage(_loc1_);
      }
      
      public function sendRevertPet(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.REVER_PET);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function requestForLuckStone() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LUCKSTONE_CONFIG);
         this.sendPackage(_loc1_);
      }
      
      public function sendOpenOneTotem(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.TOTEM);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChickenBoxUseEagleEye(param1:NewChickenBoxItem) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc2_.writeInt(NewChickenBoxPackageType.USEEAGLEEYE);
         _loc2_.writeInt(param1.position);
         this.sendPackage(_loc2_);
      }
      
      public function sendChickenBoxTakeOverCard(param1:NewChickenBoxItem) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc2_.writeInt(NewChickenBoxPackageType.TAKEOVERCARD);
         _loc2_.writeInt(param1.info.Position);
         this.sendPackage(_loc2_);
      }
      
      public function sendOverShowItems() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.AllITEMSHOW);
         this.sendPackage(_loc1_);
      }
      
      public function sendFlushNewChickenBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.FLUSHCHICKENVIEW);
         this.sendPackage(_loc1_);
      }
      
      public function sendClickStartBntNewChickenBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.CLICKSTARTBNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendNewChickenBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.ENTERCHICKENVIEW);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthRequestUpdate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.REQUEST_UPDATE);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthCleanOut() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.CLEAN_OUT);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthSpeededUpCleanOut(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc2_.writeInt(LabyrinthPackageType.SPEEDED_UP_CLEAN_OUT);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function labyrinthStopCleanOut() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.STOP_CLEAN_OUT);
         this.sendPackage(_loc1_);
      }
      
      public function figSpiritUpGrade(param1:GemstnoeSendInfo) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FIGHT_SPIRIT);
         _loc2_.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_LEVELUP);
         _loc2_.writeInt(param1.autoBuyId);
         _loc2_.writeInt(param1.goodsId);
         _loc2_.writeInt(param1.type);
         _loc2_.writeInt(param1.templeteId);
         _loc2_.writeInt(param1.fightSpiritId);
         _loc2_.writeInt(param1.equipPlayce);
         _loc2_.writeInt(param1.place);
         _loc2_.writeInt(param1.pointXY);
         this.sendPackage(_loc2_);
      }
      
      public function fightSpiritRequest() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FIGHT_SPIRIT);
         _loc1_.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_INIT);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthCleanOutTimerComplete() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.CLEAN_OUT_COMPLETE);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthDouble(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc2_.writeInt(LabyrinthPackageType.DOUBLE_REWARD);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function labyrinthReset() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc1_.writeInt(LabyrinthPackageType.RESET_LABYRINTH);
         this.sendPackage(_loc1_);
      }
      
      public function labyrinthTryAgain(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.LABYRINTH);
         _loc3_.writeInt(LabyrinthPackageType.TRY_AGAIN);
         _loc3_.writeBoolean(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function getspree(param1:Object) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.RECHARGE);
         _loc2_.writeInt(RechargePackageType.REGET_SPREE);
         _loc2_.writeInt(param1.rewardId);
         _loc2_.writeInt(param1.type);
         _loc2_.writeInt(param1.regetType);
         _loc2_.writeInt(param1.time);
         this.sendPackage(_loc2_);
      }
      
      public function sendHonorUp(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.HONOR_UP_COUNT);
         _loc3_.writeByte(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendBuyPetExpItem(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PET);
         _loc2_.writeByte(FarmPackageType.BUY_PET_EXP_ITEM);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOpenKingBless(param1:int, param2:int, param3:String, param4:Boolean) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.KING_BLESS_MAIN);
         _loc5_.writeByte(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeBoolean(param4);
         this.sendPackage(_loc5_);
      }
      
      public function sendUseItemKingBless(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.KING_BLESS_USE_ITEM);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendTrusteeshipStart(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         _loc2_.writeByte(TrusteeshipPackageType.START);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendTrusteeshipCancel(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         _loc2_.writeByte(TrusteeshipPackageType.CANCEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendTrusteeshipSpeedUp(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         _loc3_.writeByte(TrusteeshipPackageType.SPEED_UP);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendTrusteeshipBuySpirit(param1:Boolean = true) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         _loc2_.writeByte(TrusteeshipPackageType.BUY_SPIRIT);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function battleGroundUpdata(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.BATTLE_GROUND);
         _loc2_.writeByte(BattleGoundPackageType.UPDATE_VALUE_REQ);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function battleGroundPlayerUpdata() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.BATTLE_GROUND);
         _loc1_.writeByte(BattleGoundPackageType.UPDATE_PLAYER_DATA);
         this.sendPackage(_loc1_);
      }
      
      public function sendTrusteeshipUseSpiritItem(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.TRUSTEESHIP);
         _loc3_.writeByte(TrusteeshipPackageType.USE_SPIRIT_ITME);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendDeskTopLogin(param1:int = 0) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LAUNCHER_LOGIN);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGetGoods(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         _loc2_.writeByte(ActivityPackageType.REGETACTIVEPOINT_REWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsortiaBossInfo(param1:int, param2:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_CMD);
         _loc3_.writeInt(ConsortiaPackageType.CONSORTIA_BOSS_INFO);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendLatentEnergy(param1:int, param2:int, param3:int, param4:int = -1, param5:int = -1) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.LATENT_ENERGY);
         _loc6_.writeByte(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         if(param1 == 1)
         {
            _loc6_.writeInt(param4);
            _loc6_.writeInt(param5);
         }
         this.sendPackage(_loc6_);
      }
      
      public function sendWonderfulActivity(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.WONDERFUL_ACTIVITY);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function requestWonderfulActInit(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WONDERFUL_ACTIVITY_INIT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBattleCompanionGive(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.BATTLE_COMPANION_GIVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function addPetEquip(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.ADD_PET_EQUIP);
         _loc4_.writeInt(param3);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         this.sendPackage(_loc4_);
      }
      
      public function delPetEquip(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.DEL_PET_EQUIP);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function necklaceStrength(param1:int, param2:int, param3:int = 2) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.NECKLACE_STRENGTH);
         _loc4_.writeByte(param3);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param1);
         this.sendPackage(_loc4_);
      }
      
      public function enterGodsRoads() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(GodsRoadsPkgType.ENTER_GODS_ROADS);
         this.sendPackage(_loc1_);
      }
      
      public function getGodsRoadsAwards(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc3_.writeByte(GodsRoadsPkgType.GET_AWARDS);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function enterSuperWinner() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(SuperWinnerPackageType.ENTER_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function rollDiceInSuperWinner() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(SuperWinnerPackageType.ROLLS_DICES);
         this.sendPackage(_loc1_);
      }
      
      public function outSuperWinner() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(SuperWinnerPackageType.OUT_ROOM);
         this.sendPackage(_loc1_);
      }
      
      public function enterBuried() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         _loc1_.writeByte(SearchGoodsPackageType.TRYENTER);
         this.sendPackage(_loc1_);
      }
      
      public function rollDice(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         _loc2_.writeByte(SearchGoodsPackageType.RollDice);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function upgradeStartLevel(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         _loc2_.writeByte(SearchGoodsPackageType.UpgradeStartLevel);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function refreshMap() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         _loc1_.writeByte(SearchGoodsPackageType.Refresh);
         this.sendPackage(_loc1_);
      }
      
      public function takeCard(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         _loc2_.writeByte(SearchGoodsPackageType.TakeCard);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function outCard() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEARCH_GOODS);
         _loc1_.writeByte(SearchGoodsPackageType.QuitTakeCard);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsBatRequestPlayerInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc1_.writeByte(ConsBatPackageType.ADD_PLAYER);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsBatMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc4_.writeByte(ConsBatPackageType.PLAYER_MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendConsBatChallenge(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc2_.writeByte(ConsBatPackageType.CHALLENGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendConsBatExit() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc1_.writeByte(ConsBatPackageType.DELETE_PLAYER);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsBatConsume(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc3_.writeByte(ConsBatPackageType.CONSUME);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendConsBatUpdateScore(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc2_.writeByte(ConsBatPackageType.UPDATE_SCORE);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function enterDayActivity() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         _loc1_.writeByte(ActivityPackageType.EVERYDAYACTIVEPOINT_DATA);
         this.sendPackage(_loc1_);
      }
      
      public function sendConsBatConfirmEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSORTIA_BATTLE);
         _loc1_.writeByte(ConsBatPackageType.CONFIRM_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendUpdateSysDate() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SYS_DATE);
         this.sendPackage(_loc1_);
      }
      
      public function sendDragonBoatBuildOrDecorate(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         _loc3_.writeByte(DragonBoatPackageType.BUILD_DECORATE);
         _loc3_.writeByte(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendDragonBoatRefreshBoatStatus() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         _loc1_.writeByte(DragonBoatPackageType.REFRESH_BOAT_STATUS);
         this.sendPackage(_loc1_);
      }
      
      public function sendDragonBoatRefreshRank() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         _loc1_.writeByte(DragonBoatPackageType.REFRESH_RANK);
         this.sendPackage(_loc1_);
      }
      
      public function sendDragonBoatExchange(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.DRAGON_BOAT);
         _loc3_.writeByte(DragonBoatPackageType.EXCHANGE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function requestUnWeddingPay(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc2_.writeByte(ChargePackageType.Request_For_Divorce);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function requestShopPay(param1:Array, param2:Array, param3:Array, param4:Array, param5:Array, param6:String, param7:String = "") : void
      {
         var _loc8_:int = int(param1.length);
         var _loc9_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc9_.writeByte(ChargePackageType.Request_For_Shop);
         _loc9_.writeUTF(param6);
         _loc9_.writeUTF(param7);
         _loc9_.writeInt(_loc8_);
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc9_.writeInt(param1[_loc10_]);
            _loc9_.writeInt(param2[_loc10_]);
            _loc9_.writeInt(param3[_loc10_]);
            _loc9_.writeUTF(param4[_loc10_]);
            _loc9_.writeUTF(param5[_loc10_]);
            _loc10_++;
         }
         this.sendPackage(_loc9_);
      }
      
      public function requestAuctionPay(param1:int, param2:String, param3:String = "") : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc4_.writeByte(ChargePackageType.Request_For_Auction);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendWantStrongBack(param1:int, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FIND_BACK_INCOME);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function isAcceptPayShop(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc3_.writeByte(ChargePackageType.Handle_For_Shop);
         _loc3_.writeInt(param2);
         _loc3_.writeBoolean(param1);
         this.sendPackage(_loc3_);
      }
      
      public function isAcceptPayAuc(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc3_.writeByte(ChargePackageType.Pay_For_Auction_Email);
         _loc3_.writeInt(param2);
         _loc3_.writeBoolean(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendForAuction(param1:int, param2:String) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc3_.writeByte(ChargePackageType.Pay_For_Auction);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function isAcceptPay(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.REQUEST_FRIENDS_PAY);
         _loc3_.writeByte(ChargePackageType.Handle_For_Divorce);
         _loc3_.writeInt(param2);
         _loc3_.writeBoolean(param1);
         this.sendPackage(_loc3_);
      }
      
      public function CampbattleEnterFight(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc2_.writeByte(CampPackageType.ENTER_MONSTER_FIGHT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function CampbattleRoleMove(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc4_.writeByte(CampPackageType.ROLE_MOVE);
         _loc4_.writeInt(param3.x);
         _loc4_.writeInt(param3.y);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         this.sendPackage(_loc4_);
      }
      
      public function changeMap() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc1_.writeByte(CampPackageType.MAP_CHANGE);
         this.sendPackage(_loc1_);
      }
      
      public function outCampBatttle() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc1_.writeByte(CampPackageType.REMOVE_ROLE);
         this.sendPackage(_loc1_);
      }
      
      public function captureMap(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc2_.writeByte(CampPackageType.CAPTURE_MAP);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function requestPRankList() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc1_.writeByte(CampPackageType.PER_SCORE_RANK);
         this.sendPackage(_loc1_);
      }
      
      public function requestCRankList() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc1_.writeByte(CampPackageType.CAMP_SOCER_RANK);
         this.sendPackage(_loc1_);
      }
      
      public function enterPTPFight(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc3_.writeByte(CampPackageType.PVP_TO_FIGHT);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function returnToPve() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc1_.writeByte(CampPackageType.INIT_SECEN);
         this.sendPackage(_loc1_);
      }
      
      public function resurrect(param1:Boolean, param2:Boolean = true) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.CAMPBATTLE);
         _loc3_.writeByte(CampPackageType.RESURRECT);
         _loc3_.writeBoolean(param2);
         _loc3_.writeBoolean(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendGroupPurchaseRefreshData() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GROUP_PURCHASE);
         _loc1_.writeByte(GroupPurchasePackageType.REFRESH_DATA);
         this.sendPackage(_loc1_);
      }
      
      public function sendGroupPurchaseRefreshRankData() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GROUP_PURCHASE);
         _loc1_.writeByte(GroupPurchasePackageType.REFRESH_RANK_DATA);
         this.sendPackage(_loc1_);
      }
      
      public function sendGroupPurchaseBuy(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GROUP_PURCHASE);
         _loc3_.writeByte(GroupPurchasePackageType.BUY);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRegressPkg() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_PACKS);
         this.sendPackage(_loc1_);
      }
      
      public function sendRegressGetAwardPkg(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc2_.writeByte(RegressPackageType.REGRESS_GETPACKS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendRegressCheckPlayer(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc2_.writeByte(RegressPackageType.REGRESS_CHECK);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendRegressApplyEnable() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_APPLY_ENABLE);
         this.sendPackage(_loc1_);
      }
      
      public function sendRegressApllyPacks() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_APPLYPACKS);
         this.sendPackage(_loc1_);
      }
      
      public function sendRegressCall(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc2_.writeByte(RegressPackageType.REGRESS_CALL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendRegressRecvPacks() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_REVCPACKS);
         this.sendPackage(_loc1_);
      }
      
      public function sendRegressTicketInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_GET_TICKET);
         this.sendPackage(_loc1_);
      }
      
      public function sendRegressTicket() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_GET_TICKETINFO);
         this.sendPackage(_loc1_);
      }
      
      public function sendExpBlessedData() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.EVERYDAY_ACTIVEPOINT);
         _loc1_.writeByte(ActivityPackageType.GET_EXPBLESSED_DATA);
         this.sendPackage(_loc1_);
      }
      
      public function sendGameTrusteeship(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.GAME_TRUSTEESHIP);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendInitTreasueHunting() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc1_.writeByte(CrazyTankPackageType.INIT_TREASURE);
         this.sendPackage(_loc1_);
      }
      
      public function sendPayForHunting(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc3_.writeByte(CrazyTankPackageType.PAY_FOR_HUNTING);
         _loc3_.writeBoolean(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function getAllTreasure() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc1_.writeByte(CrazyTankPackageType.GET_ALL_TREASURE);
         this.sendPackage(_loc1_);
      }
      
      public function updateTreasureBag() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc1_.writeByte(CrazyTankPackageType.UPDATE_TREASURE_BAG);
         this.sendPackage(_loc1_);
      }
      
      public function sendHuntingByScore() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc1_.writeByte(CrazyTankPackageType.HUNTING_BY_SCORE);
         this.sendPackage(_loc1_);
      }
      
      public function sendConvertScore(param1:Boolean, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc4_.writeByte(CrazyTankPackageType.CONVERT_SCORE);
         _loc4_.writeBoolean(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendSevenDoubleCallCar(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc3_.writeByte(SevenDoublePackageType.CALL);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendSevenDoubleStartGame(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc2_.writeByte(SevenDoublePackageType.START_GAME);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSevenDoubleCancelGame() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc1_.writeByte(SevenDoublePackageType.CANCEL_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function sendSevenDoubleReady() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc1_.writeByte(SevenDoublePackageType.READY);
         this.sendPackage(_loc1_);
      }
      
      public function sendSevenDoubleMove() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc1_.writeByte(SevenDoublePackageType.MOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendSevenDoubleUseSkill(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc4_.writeByte(SevenDoublePackageType.USE_SKILL);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendSevenDoubleCanEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc1_.writeByte(SevenDoublePackageType.IS_CAN_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendBuyEnergy(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MISSION_ENERGY);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendSevenDoubleEnterOrLeaveScene(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEVEN_DOUBLE);
         _loc2_.writeByte(SevenDoublePackageType.ENTER_OR_LEAVE_SCENE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendWonderfulActivityGetReward(param1:Vector.<SendGiftInfo>) : void
      {
         var _loc4_:int = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.WONDERFUL_GETREWARD);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeUTF(param1[_loc3_].activityId);
            _loc2_.writeInt(param1[_loc3_].giftIdArr.length);
            _loc4_ = 0;
            while(_loc4_ < param1[_loc3_].giftIdArr.length)
            {
               _loc2_.writeUTF(param1[_loc3_].giftIdArr[_loc4_]);
               _loc4_++;
            }
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function sendButChristmasGoods(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(ChristmasPackageType.CHRISTMAS_PACKS);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function enterChristmasRoomIsTrue() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER);
         _loc1_.writeByte(0);
         this.sendPackage(_loc1_);
      }
      
      public function enterChristmasRoom(param1:Point) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER);
         _loc2_.writeByte(2);
         _loc2_.writeInt(param1.x);
         _loc2_.writeInt(param1.y);
         this.sendPackage(_loc2_);
      }
      
      public function enterMakingSnowManRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(ChristmasPackageType.CHRISTMAS_MAKING_SNOWMAN_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function getPacksToPlayer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(ChristmasPackageType.GET_PAKCS_TO_PLAYER);
         _loc2_.writeByte(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLeaveChristmasRoom() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(ChristmasPackageType.CHRISTMAS_PLAYERING_SNOWMAN_ENTER);
         _loc1_.writeByte(1);
         this.sendPackage(_loc1_);
      }
      
      public function sendChristmasRoomMove(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc4_.writeByte(ChristmasPackageType.MOVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendChristmasUpGrade(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc3_.writeByte(ChristmasPackageType.FIGHT_SPIRIT_LEVELUP);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendStartFightWithMonster(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(ChristmasPackageType.FIGHT_MONSTER);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBuyPlayingSnowmanVolumes() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(ChristmasPackageType.CHRISTMAS_BUY_TIMER);
         this.sendPackage(_loc1_);
      }
      
      public function sendLuckyStarEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.ENTER_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function sendLuckyStarClose() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.CLOSE_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function sendLuckyStarTurnComplete() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.TURN_COMPLETE);
         this.sendPackage(_loc1_);
      }
      
      public function sendLuckyStarTurn() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.NEWCHICKENBOX_SYS);
         _loc1_.writeInt(NewChickenBoxPackageType.START_TURN);
         this.sendPackage(_loc1_);
      }
      
      public function sendRingStationGetInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc1_.writeByte(RingStationPackageType.RINGSTATION_VIEWINFO);
         this.sendPackage(_loc1_);
      }
      
      public function sendBuyBattleCountOrTime(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc3_.writeByte(RingStationPackageType.RINGSTATION_BUYCOUNTORTIME);
         _loc3_.writeBoolean(param2);
         _loc3_.writeBoolean(param1);
         this.sendPackage(_loc3_);
      }
      
      public function sendRingStationChallenge(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc3_.writeByte(RingStationPackageType.RINGSTATION_CHALLENGE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendRingStationArmory() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc1_.writeByte(RingStationPackageType.RINGSTATION_ARMORY);
         this.sendPackage(_loc1_);
      }
      
      public function sendRingStationBattleField() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc1_.writeByte(RingStationPackageType.RINGSTATION_NEWBATTLEFIELD);
         this.sendPackage(_loc1_);
      }
      
      public function sendRingStationFightFlag() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc1_.writeByte(RingStationPackageType.RINGSTATION_FIGHTFLAG);
         this.sendPackage(_loc1_);
      }
      
      public function sendRouletteRun() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEPARATE_ACTIVITY);
         _loc1_.writeByte(CrazyTankPackageType.DAWN_LOTTERY);
         this.sendPackage(_loc1_);
      }
      
      public function getBackLockPwdByPhone(param1:int, param2:String = "") : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         _loc3_.writeByte(CrazyTankPackageType.GET_BACK_BY_PHONE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function getBackLockPwdByQuestion(param1:int, param2:String = "", param3:String = "") : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         _loc4_.writeByte(CrazyTankPackageType.GET_BACK_BY_QUESTION);
         _loc4_.writeInt(param1);
         _loc4_.writeUTF(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function deletePwdQuestion(param1:int, param2:String = "") : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         _loc3_.writeByte(CrazyTankPackageType.DELETE_QUESTION);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function deletePwdByPhone(param1:int, param2:String = "") : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         _loc3_.writeByte(CrazyTankPackageType.DELETE_PWD_BY_PHONE);
         _loc3_.writeInt(param1);
         _loc3_.writeUTF(param2);
         this.sendPackage(_loc3_);
      }
      
      public function checkPhoneBind() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.BAGLOCK_PWD);
         _loc1_.writeByte(CrazyTankPackageType.CHECK_PHONE_BINDING);
         this.sendPackage(_loc1_);
      }
      
      public function sendActivityDungeonNextPoints(param1:int, param2:Boolean, param3:int = 0) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.ADD_ANIMATION);
         _loc4_.writeByte(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendGuildMemberWeekStarEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
         _loc1_.writeByte(GuildMemberWeekPackageType.ENTER_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function sendGuildMemberWeekStarClose() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
         _loc1_.writeByte(GuildMemberWeekPackageType.CLOSE);
         this.sendPackage(_loc1_);
      }
      
      public function sendGuildMemberWeekAddRanking(param1:Array) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:PackageOut = new PackageOut(ePackageType.GUILDMEMBERWEEK_SYSTEM);
         _loc3_.writeByte(GuildMemberWeekPackageType.SEND_ADDRUNKING);
         _loc3_.writeInt(_loc2_);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeInt(param1[_loc4_]);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendSignMsg(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc2_.writeByte(RingStationPackageType.RINGSTATION_SENDSIGNMSG);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLanternRiddlesQuestion() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_QUESTION);
         this.sendPackage(_loc1_);
      }
      
      public function sendLanternRiddlesAnswer(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc4_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_ANSWER);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendLanternRiddlesUseSkill(param1:int, param2:int, param3:int, param4:Boolean = true) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc5_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_SKILL);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeBoolean(false);
         this.sendPackage(_loc5_);
      }
      
      public function sendLanternRiddlesRankInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(LanternriddlesPackageType.LANTERNRIDDLES_RANKINFO);
         this.sendPackage(_loc1_);
      }
      
      public function sendCatchBeastBegin() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(CatchBeastPackageType.CATCHBEAST_BEGIN);
         this.sendPackage(_loc1_);
      }
      
      public function sendCatchBeastViewInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(CatchBeastPackageType.CATCHBEAST_VIEWINFO);
         this.sendPackage(_loc1_);
      }
      
      public function sendCatchBeastChallenge() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(CatchBeastPackageType.CATCHBEAST_CHALLENGE);
         this.sendPackage(_loc1_);
      }
      
      public function sendCatchBeastBuyBuff(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(CatchBeastPackageType.CATCHBEAST_BUYBUFF);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendCatchBeastGetAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(CatchBeastPackageType.CATCHBEAST_GETAWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAccumulativeLoginAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACCUMULATIVELOGIN_AWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendAvatarCollectionActive(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.AVATAR_COLLECTION);
         _loc4_.writeByte(AvatarCollectionPackageType.ACTIVE);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendAvatarCollectionDelayTime(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.AVATAR_COLLECTION);
         _loc3_.writeByte(AvatarCollectionPackageType.DELAY_TIME);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function setCurrentModel(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         _loc2_.writeByte(PlayerDressType.CURRENT_MODEL);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function saveDressModel(param1:int, param2:Array) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         _loc3_.writeByte(PlayerDressType.GET_DRESS_MODEL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ <= param2.length - 1)
         {
            _loc3_.writeInt(BagInfo.EQUIPBAG);
            _loc3_.writeInt(param2[_loc4_]);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function foldDressItem(param1:Array) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         _loc2_.writeByte(PlayerDressType.FOLD_DRESS);
         _loc2_.writeInt(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ <= param1.length - 1)
         {
            _loc2_.writeInt(BagInfo.EQUIPBAG);
            _loc2_.writeInt(param1[_loc3_].sPlace);
            _loc2_.writeInt(BagInfo.EQUIPBAG);
            _loc2_.writeInt(param1[_loc3_].tPlace);
            _loc3_++;
         }
         this.sendPackage(_loc2_);
      }
      
      public function lockDressBag() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.PLAYER_DRESS);
         _loc1_.writeByte(PlayerDressType.LOCK_DRESSBAG);
         this.sendPackage(_loc1_);
      }
      
      public function receiveLandersAward() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.RING_STATION);
         _loc1_.writeByte(RingStationPackageType.LANDERSAWARD_GET);
         this.sendPackage(_loc1_);
      }
      
      public function getFlowerRankInfo(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         _loc3_.writeByte(FlowerGivingType.GET_FLOWER_RANK);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendGetFlowerReward(param1:int, param2:int = 0) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         _loc3_.writeByte(FlowerGivingType.GET_REWARD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function getFlowerRewardStatus() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         _loc1_.writeByte(FlowerGivingType.REWARD_INFO);
         this.sendPackage(_loc1_);
      }
      
      public function sendFlower(param1:String, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         _loc4_.writeByte(FlowerGivingType.GIVE_FLOWER);
         _loc4_.writeUTF(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendFlowerRecord() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.FLOWER_GIVING);
         _loc1_.writeByte(FlowerGivingType.GET_RECORD);
         this.sendPackage(_loc1_);
      }
      
      public function sendUpdateIntegral() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc1_.writeByte(RegressPackageType.REGRESS_UPDATE_INTEGRAL);
         this.sendPackage(_loc1_);
      }
      
      public function sendBuyRegressIntegralGoods(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.OLDPLAYER_REGRESS);
         _loc3_.writeByte(RegressPackageType.REGRESS_INTEGRAL_BUY);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendPetRisingStar(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PET);
         _loc4_.writeByte(CrazyTankPackageType.PET_RISINGSTAR);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendPetEvolution(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PET);
         _loc3_.writeByte(CrazyTankPackageType.PET_EVOLUTION);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendEscortCallCar(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc3_.writeByte(EscortPackageType.CALL);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendEscortStartGame(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc2_.writeByte(EscortPackageType.START_GAME);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendEscortCancelGame() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc1_.writeByte(EscortPackageType.CANCEL_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function sendEscortReady() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc1_.writeByte(EscortPackageType.READY);
         this.sendPackage(_loc1_);
      }
      
      public function sendEscortMove() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc1_.writeByte(EscortPackageType.MOVE);
         this.sendPackage(_loc1_);
      }
      
      public function sendEscortUseSkill(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc4_.writeByte(EscortPackageType.USE_SKILL);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         this.sendPackage(_loc4_);
      }
      
      public function sendEscortCanEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc1_.writeByte(EscortPackageType.IS_CAN_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sendEscortEnterOrLeaveScene(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ESCORT);
         _loc2_.writeByte(EscortPackageType.ENTER_OR_LEAVE_SCENE);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendPeerID(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.PEER_ID);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeUTF(param3);
         this.sendPackage(_loc4_);
      }
      
      public function exploreMagicStone(param1:int, param2:Boolean, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc4_.writeByte(MagicStoneType.EXPLORE_MAGIC_STONE);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function getMagicStoneScore() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc1_.writeByte(MagicStoneType.MAGIC_STONE_SCORE);
         this.sendPackage(_loc1_);
      }
      
      public function convertMgStoneScore(param1:int, param2:Boolean = true, param3:int = 1) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc4_.writeByte(MagicStoneType.CONVERT_SCORE);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeInt(param3);
         this.sendPackage(_loc4_);
      }
      
      public function moveMagicStone(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc3_.writeByte(MagicStoneType.MOVE_PLACE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function lockMagicStone(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc2_.writeByte(MagicStoneType.LOCK_MAGIC_STONE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function updateMagicStone(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc2_.writeByte(MagicStoneType.LEVEL_UP);
         _loc2_.writeInt(param1.length);
         for each(_loc3_ in param1)
         {
            _loc2_.writeInt(_loc3_);
         }
         this.sendPackage(_loc2_);
      }
      
      public function sortMgStoneBag(param1:Array, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc3_.writeByte(MagicStoneType.SORT_BAG);
         _loc3_.writeInt(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.writeInt(param1[_loc4_].Place);
            _loc3_.writeInt(_loc4_ + param2);
            _loc4_++;
         }
         this.sendPackage(_loc3_);
      }
      
      public function updateRemainCount() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MAGIC_STONE);
         _loc1_.writeByte(MagicStoneType.UPDATE_REMAIN_COUNT);
         this.sendPackage(_loc1_);
      }
      
      public function updateConsumeRank() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.CONSUME_RANK);
         this.sendPackage(_loc1_);
      }
      
      public function sendEntertainment() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(EntertainmentPackageType.GET_SCORE);
         this.sendPackage(_loc1_);
      }
      
      public function buyEntertainment(param1:Boolean = false) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(EntertainmentPackageType.BUY_ICON);
         _loc2_.writeBoolean(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendFastAuctionBugle(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FAST_AUCTION_SMALL_BUGLE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendLightRoadStarEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.LIGHTROAD_SYSTEM);
         _loc1_.writeByte(LightRoadPackageType.ENTER_GAME);
         this.sendPackage(_loc1_);
      }
      
      public function lightRoadPointWork(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.LIGHTROAD_SYSTEM);
         _loc2_.writeByte(LightRoadPackageType.BECHOOSE_POINT);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sevenDayTarget_enter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         _loc1_.writeByte(SevenDayTargetPackageType.SEVENDAYTARGET_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function newPlayerReward_enter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         _loc1_.writeByte(SevenDayTargetPackageType.NEWPLAYERREWARD_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function sevenDayTarget_getReward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         _loc2_.writeByte(SevenDayTargetPackageType.SEVENDAYTARGET_GET_REWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function newPlayerReward_getReward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SEVENDAYTARGET_GODSROADS);
         _loc2_.writeByte(SevenDayTargetPackageType.NEWPLAYERREWARD_GET_REWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChickActivationOpenKey(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         _loc2_.writeInt(ChickActivationType.CHICKACTIVATION);
         _loc2_.writeInt(ChickActivationType.CHICKACTIVATION_OPENKEY);
         _loc2_.writeUTF(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendChickActivationGetAward(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         _loc3_.writeInt(ChickActivationType.CHICKACTIVATION);
         _loc3_.writeInt(ChickActivationType.CHICKACTIVATION_GETAWARD);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendChickActivationQuery() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         _loc1_.writeInt(ChickActivationType.CHICKACTIVATION);
         _loc1_.writeInt(ChickActivationType.CHICKACTIVATION_QUERY);
         this.sendPackage(_loc1_);
      }
      
      public function DDPlayEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(DDPlayType.ENTER_DDPLAY);
         this.sendPackage(_loc1_);
      }
      
      public function DDPlayStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(DDPlayType.DDPLAY_START);
         this.sendPackage(_loc1_);
      }
      
      public function DDPlayExchange(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(DDPlayType.DDPLAY_EXCHANGE);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBoguAdventureEnter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(BoguAdventureType.ENTER_BOGUADVENTURE);
         this.sendPackage(_loc1_);
      }
      
      public function sendBoguAdventureWalkInfo(param1:int, param2:int = 0) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc3_.writeByte(BoguAdventureType.UPDATE_CELL);
         _loc3_.writeInt(param1);
         if(param1 != 3)
         {
            _loc3_.writeInt(param2);
         }
         this.sendPackage(_loc3_);
      }
      
      public function sendBoguAdventureUpdateGame(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(BoguAdventureType.REVIVE_GAME);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendBoguAdventureAcquireAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(BoguAdventureType.ACQUIRE_AWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendOutBoguAdventure() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(BoguAdventureType.OUT_BOGUADVENTURE);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetShopBuyLimitedCount() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SHOP_BUYLIMITEDCOUNT);
         this.sendPackage(_loc1_);
      }
      
      public function sendGrowthPackageGetItems(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         _loc2_.writeInt(GrowthPackageType.GROWTHPACKAGE);
         _loc2_.writeInt(GrowthPackageType.GROWTHPACKAGE_UPDATEDATA);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendGrowthPackageOpen() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_PACKAGE);
         _loc1_.writeInt(GrowthPackageType.GROWTHPACKAGE);
         _loc1_.writeInt(GrowthPackageType.GROWTHPACKAGE_OPEN);
         this.sendPackage(_loc1_);
      }
      
      public function sendGetCSMTimeBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GET_CSM_BOX);
         this.sendPackage(_loc1_);
      }
      
      public function treasurePuzzle_enter() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         _loc1_.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_ENTER);
         this.sendPackage(_loc1_);
      }
      
      public function treasurePuzzle_seeReward() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         _loc1_.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_SEE_REWARD);
         this.sendPackage(_loc1_);
      }
      
      public function treasurePuzzle_getReward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         _loc2_.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_GET_REWARD);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function treasurePuzzle_savePlayerInfo(param1:String, param2:String, param3:String, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         _loc5_.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_SAVE_PLAYERINFO);
         _loc5_.writeUTF(param1);
         _loc5_.writeUTF(param2);
         _loc5_.writeUTF(param3);
         _loc5_.writeInt(param4);
         this.sendPackage(_loc5_);
      }
      
      public function treasurePuzzle_usePice(param1:int, param2:int = 1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.TREASUREPUZZLE);
         _loc3_.writeByte(TreasurePuzzlePackageType.TREASUREPUZZLE_USE_PICE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         this.sendPackage(_loc3_);
      }
      
      public function witchBlessing_enter(param1:int = 0) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.WITCHBLESSING);
         _loc2_.writeByte(WitchBlessingPackageType.WITCHBLESSING_INFO);
         _loc2_.writeInt(param1);
         this.sendPackage(_loc2_);
      }
      
      public function sendWitchBless(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.WITCHBLESSING);
         _loc3_.writeByte(WitchBlessingPackageType.WITCHBLESSING_BLESS);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function sendWitchGetAwards(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.WITCHBLESSING);
         _loc3_.writeByte(WitchBlessingPackageType.WITCHBLESSING_OPEN_CLOSE);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         this.sendPackage(_loc3_);
      }
      
      public function halloweenInit() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(HalloweenType.ENTER);
         this.sendPackage(_loc1_);
      }
   }
}

