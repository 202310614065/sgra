package beadSystem.controls
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.TaskManager;
   import ddt.view.MainToolBar;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import store.view.embed.EmbedUpLevelCell;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BeadLeadManager extends EventDispatcher
   {
      
      private static var _instance:BeadLeadManager;
      
      public static const BEAD_ID:int = 311124;
      
      public var isFinishStep1:Boolean = false;
      
      public var isFinishStep2:Boolean = false;
      
      public var isFinishStep3:Boolean = false;
      
      public var isFinishStep4:Boolean = false;
      
      public var isFinishStep5:Boolean = false;
      
      public var isFinishStep6:Boolean = false;
      
      public var curretStep:int = 1;
      
      public var perTaskComplete:Boolean = false;
      
      public var taskComplete:Boolean = false;
      
      public var arrowPos:Point;
      
      public var txtPos:Point;
      
      public var upLevelEffec:IEffect;
      
      public var upLevelCellSpaling:Boolean = false;
      
      public function BeadLeadManager()
      {
         super();
      }
      
      public static function get Instance() : BeadLeadManager
      {
         if(!_instance)
         {
            _instance = new BeadLeadManager();
         }
         return _instance;
      }
      
      public function leadClickBag(param1:DisplayObjectContainer = null) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_BAG,0,"beadlead.posClickBag","asset.beadlead.txtClickBag","beadlead.posClickBagTxt",param1,0,true);
      }
      
      public function leadOpenBeadSurface(param1:DisplayObjectContainer = null) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_OPENBEADSURFACE,180,"beadlead.posClickOpenBeadSurface","asset.beadlead.openBeadSurface","beadlead.posopenBeadSurfaceTxt",param1,0,true);
      }
      
      public function leadPutBeadToUpdateslot(param1:DisplayObjectContainer = null, param2:Point = null, param3:Point = null) : void
      {
         if(param2 == null)
         {
            NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_BEADUPDATESLOT,90,"beadlead.posputBeadToUpdateslot","asset.beadlead.putBeadToUpdateslot","beadlead.posputBeadToUpdateslotTxt",param1,0,true);
         }
         else
         {
            NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_BEADUPDATESLOT,0,"beadlead.posputBeadToUpdateslot","asset.beadlead.putBeadToUpdateslot","beadlead.posputBeadToUpdateslotTxt",param1,0,true,param2,param3);
         }
      }
      
      public function leadClickCombinBnt(param1:DisplayObjectContainer = null) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_COMBINCLICK,0,"beadlead.posclickCombinBnt","asset.beadlead.clickCombinBnt","beadlead.posclickCombinBntTxt",param1,0,true);
      }
      
      public function leadEquipBead(param1:DisplayObjectContainer = null) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_EQUIPBEAD,45,"beadlead.posequipBead","asset.beadlead.equipBead","beadlead.posequipBeadTxt",param1,0,true);
      }
      
      public function leadCandleStick(param1:DisplayObjectContainer = null) : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.LEAD_BEAD_CANDLESTICK,0,"beadlead.poscandleStick","asset.beadlead.candleStick","beadlead.poscandleStickTxt",param1,0,true);
      }
      
      public function haveTaskComplete(param1:int) : Boolean
      {
         return TaskManager.instance.isCompleted(TaskManager.instance.getQuestByID(param1)) && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(param1));
      }
      
      public function spalingUpLevelCell(param1:EmbedUpLevelCell) : void
      {
         if(BeadLeadManager.Instance.upLevelEffec == null)
         {
            BeadLeadManager.Instance.upLevelEffec = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,param1);
         }
         if(BeadLeadManager.Instance.upLevelCellSpaling)
         {
            BeadLeadManager.Instance.upLevelEffec.play();
         }
         else
         {
            BeadLeadManager.Instance.upLevelEffec.stop();
         }
      }
      
      public function removeSpalingUpLevelCell() : void
      {
         if(Boolean(BeadLeadManager.Instance.upLevelEffec))
         {
            EffectManager.Instance.removeEffect(BeadLeadManager.Instance.upLevelEffec);
            BeadLeadManager.Instance.upLevelEffec = null;
            BeadLeadManager.Instance.upLevelCellSpaling = false;
         }
      }
      
      public function disposeBeadLeadArrows() : void
      {
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_OPENBEADSURFACE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_OPENBEADSURFACE);
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_BEADUPDATESLOT))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_BEADUPDATESLOT);
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_COMBINCLICK))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_COMBINCLICK);
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_EQUIPBEAD))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_EQUIPBEAD);
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_CANDLESTICK))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_CANDLESTICK);
         }
         if(Boolean(BeadLeadManager.Instance.arrowPos))
         {
            BeadLeadManager.Instance.arrowPos = null;
            BeadLeadManager.Instance.txtPos = null;
         }
         if(Boolean(BeadLeadManager.Instance.upLevelEffec))
         {
            BeadLeadManager.Instance.upLevelCellSpaling = false;
         }
      }
      
      public function beadLeadOne() : void
      {
         var _loc1_:QuestInfo = TaskManager.instance.getQuestByID(TaskManager.BEADLEAD_TASKTYPE2);
         if(!BeadLeadManager.Instance.taskComplete && SharedManager.Instance.beadLeadTaskStep == 1 && _loc1_ && _loc1_.data != null || SharedManager.Instance.beadLeadTaskStep == 0 && !BeadLeadManager.Instance.taskComplete && _loc1_ && _loc1_.data != null)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               if(BeadLeadManager.Instance.beadLeadTaskComplete)
               {
                  BeadLeadManager.Instance.taskComplete = true;
                  TaskManager.instance.checkQuest(TaskManager.BEADLEAD_TASKTYPE2,1,0);
               }
               else
               {
                  BeadLeadManager.Instance.leadClickBag(MainToolBar.Instance);
                  SharedManager.Instance.beadLeadTaskStep = 1;
                  SharedManager.Instance.save();
               }
            }
         }
      }
      
      public function beadLeadTwo() : void
      {
         if(SharedManager.Instance.beadLeadTaskStep == 3 && !BeadLeadManager.Instance.taskComplete)
         {
            if(PlayerManager.Instance.Self.Grade >= 10 && PlayerManager.Instance.Self.Grade <= 15)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_BEADUPDATESLOT);
               if(Boolean(BeadLeadManager.Instance.upLevelEffec))
               {
                  EffectManager.Instance.removeEffect(BeadLeadManager.Instance.upLevelEffec);
                  BeadLeadManager.Instance.upLevelEffec = null;
                  BeadLeadManager.Instance.upLevelCellSpaling = false;
               }
               BeadLeadManager.Instance.leadClickCombinBnt(LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               SharedManager.Instance.beadLeadTaskStep = 4;
               SharedManager.Instance.save();
            }
         }
      }
      
      public function get beadLeadTaskComplete() : Boolean
      {
         var _loc1_:InventoryItemInfo = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG).getItemByTemplateId(BEAD_ID);
         return Boolean(_loc1_) && _loc1_.Hole1 == 4;
      }
   }
}

