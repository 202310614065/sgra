package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortiaBattleEntryBtn extends Sprite implements Disposeable
   {
      
      private var _btn:MovieClip;
      
      private var _isOpen:Boolean;
      
      public function ConsortiaBattleEntryBtn()
      {
         super();
         this.x = 12;
         this.y = 9;
         if(ConsortiaBattleManager.instance.isLoadIconMapComplete)
         {
            this.initThis();
         }
         else
         {
            ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         }
      }
      
      public function setEnble(param1:Boolean) : void
      {
         this._isOpen = param1;
         mouseChildren = param1;
         mouseEnabled = param1;
         if(param1)
         {
            BuriedManager.Instance.reGray(this);
            this.playAllMc(this._btn);
         }
         else
         {
            BuriedManager.Instance.applyGray(this);
         }
      }
      
      private function initThis() : void
      {
         this._btn = ComponentFactory.Instance.creat("assets.hallIcon.consortiaBattleEntryIcon");
         this._btn.gotoAndStop(1);
         this._btn.buttonMode = true;
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickhandler,false,0,true);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(!this._isOpen)
         {
            this.stopAllMc(this._btn);
         }
      }
      
      private function playAllMc(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 0;
         if(Boolean(param1))
         {
            while(Boolean(param1.numChildren - _loc2_))
            {
               if(param1.getChildAt(_loc2_) is MovieClip)
               {
                  _loc3_ = param1.getChildAt(_loc2_) as MovieClip;
                  _loc3_.play();
                  this.playAllMc(_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      private function stopAllMc(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = 0;
         if(Boolean(param1))
         {
            while(Boolean(param1.numChildren - _loc2_))
            {
               if(param1.getChildAt(_loc2_) is MovieClip)
               {
                  _loc3_ = param1.getChildAt(_loc2_) as MovieClip;
                  _loc3_.stop();
                  this.stopAllMc(_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      private function clickhandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ConsortiaBattleManager.instance.isCanEnter)
         {
            GameInSocketOut.sendSingleRoomBegin(4);
         }
         else if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.cannotEnterTxt2"));
         }
      }
      
      private function resLoadComplete(param1:Event) : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         this.initThis();
      }
      
      private function closeHandler(param1:Event) : void
      {
         this.closeDispose();
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
      }
      
      private function closeDispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickhandler);
            this._btn.gotoAndStop(2);
         }
         ObjectUtils.disposeAllChildren(this);
         this._btn = null;
      }
      
      public function dispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.ICON_AND_MAP_LOAD_COMPLETE,this.resLoadComplete);
         this.closeDispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

