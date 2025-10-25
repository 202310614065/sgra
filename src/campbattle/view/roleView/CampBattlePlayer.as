package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class CampBattlePlayer extends CampBaseRole
   {
      
      protected var tombstone:MovieClip;
      
      protected var fighting:MovieClip;
      
      protected var capture:Bitmap;
      
      private var _walkOverHander:Function;
      
      private var _targetID:int;
      
      private var _targetZoneID:int;
      
      private var _nameTxt:FilterFrameText;
      
      private var _resurrectCartoon:MovieClip;
      
      public function CampBattlePlayer(param1:RoleData = null, param2:Function = null)
      {
         super(param1,param2);
         if(!param1)
         {
            return;
         }
         this.setPlayerInfo(param1);
      }
      
      public function setPlayerInfo(param1:RoleData = null) : void
      {
         addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         x = param1.posX;
         y = param1.posY;
         this.character.x = -playerWitdh / 2;
         this.character.y = -playerHeight;
         this.initStatus();
         this.setStateType(param1.stateType);
         this.setCaptureVisible(param1.isCapture);
      }
      
      private function initStatus() : void
      {
         this._resurrectCartoon = ComponentFactory.Instance.creat("asset.consortiaBattle.resurrectCartoon");
         this._resurrectCartoon.addEventListener(Event.COMPLETE,this.cartoonCompleteHandler,false,0,true);
         this._resurrectCartoon.gotoAndStop(1);
         this._resurrectCartoon.visible = false;
         addChild(this._resurrectCartoon);
         this.tombstone = ComponentFactory.Instance.creat("campbattle.tombstone");
         this.tombstone.visible = false;
         addChild(this.tombstone);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.titleTxt1");
         this._nameTxt.text = _playerInfo.name;
         this._nameTxt.x = this.character.x + (playerWitdh / 2 - this._nameTxt.width / 2);
         this._nameTxt.y = -playerHeight + 10;
         addChild(this._nameTxt);
         this.fighting = ComponentFactory.Instance.creat("campbattle.fighting");
         this.fighting.x = -1;
         this.fighting.y = this._nameTxt.y - 20;
         this.fighting.visible = false;
         addChild(this.fighting);
         this.capture = ComponentFactory.Instance.creat("asset.campbattle.capture.Samll");
         this.capture.x = this._nameTxt.x - this.capture.width - 2;
         this.capture.y = this._nameTxt.y;
         this.capture.visible = false;
         addChild(this.capture);
      }
      
      public function setCaptureVisible(param1:Boolean) : void
      {
         this.capture.visible = param1;
         _playerInfo.isCapture = param1;
      }
      
      private function cartoonCompleteHandler(param1:Event) : void
      {
         this._resurrectCartoon.gotoAndStop(1);
         this._resurrectCartoon.visible = false;
      }
      
      public function setStateType(param1:int) : void
      {
         this.tombstone.visible = false;
         this.fighting.visible = false;
         this._resurrectCartoon.visible = false;
         switch(param1)
         {
            case 0:
               this.character.visible = true;
               this._nameTxt.y = -playerHeight + 10;
            case 1:
               this.character.visible = true;
               this._nameTxt.y = -playerHeight + 10;
               if(_playerInfo.isDead)
               {
                  _playerInfo.isDead = false;
                  this._resurrectCartoon.visible = true;
                  this._resurrectCartoon.gotoAndPlay(1);
               }
               break;
            case 2:
               this.fighting.visible = true;
               this.character.visible = true;
               this._nameTxt.y = -playerHeight + 10;
               break;
            case 3:
               break;
            case 4:
               this.character.visible = false;
               this.tombstone.visible = true;
               _playerInfo.isDead = true;
               this._nameTxt.y = this.tombstone.y - 80;
         }
         _playerInfo.stateType = param1;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.fighting))
         {
            while(Boolean(this.fighting.numChildren))
            {
               ObjectUtils.disposeObject(this.fighting.getChildAt(0));
            }
         }
         if(Boolean(this.tombstone))
         {
            while(Boolean(this.tombstone.numChildren))
            {
               ObjectUtils.disposeObject(this.tombstone.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this.fighting);
         ObjectUtils.disposeObject(this.capture);
         ObjectUtils.disposeObject(this.tombstone);
         ObjectUtils.disposeObject(this._nameTxt);
         removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         super.dispose();
      }
      
      protected function enterFrameHander(param1:Event) : void
      {
         update();
         this.playerWalkPath();
         this.characterMirror();
      }
      
      override public function walk(param1:Point, param2:Function = null, param3:int = 0, param4:int = 0) : void
      {
         if(!scene)
         {
            return;
         }
         walkPath = [];
         this._targetID = param3;
         this._targetZoneID = param4;
         walkPath = scene.searchPath(playerPoint,param1);
         walkPath.shift();
         isWalkPathChange = true;
         this._walkOverHander = param2;
      }
      
      protected function characterMirror() : void
      {
         if(!sceneCharacterDirection)
         {
            return;
         }
         var _loc1_:Sprite = character;
         _loc1_.scaleX = sceneCharacterDirection.isMirror ? -1 : 1;
         _loc1_.x = sceneCharacterDirection.isMirror ? playerWitdh / 2 : -playerWitdh / 2;
         _loc1_.y = -playerHeight + 12;
      }
      
      protected function playerWalkPath() : void
      {
         if((!walkPath || walkPath.length <= 0) && !_tween.isPlaying)
         {
            return;
         }
         playerWalk(walkPath);
      }
      
      private function characterDirectionChange(param1:SceneCharacterEvent) : void
      {
         if(Boolean(param1.data))
         {
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalWalkFront";
               }
            }
         }
         else
         {
            if(this._walkOverHander != null)
            {
               if(this._targetID != 0 && this._targetZoneID != 0)
               {
                  this._walkOverHander(this._targetZoneID,this._targetID);
               }
               else if(this._targetID != 0)
               {
                  this._walkOverHander(this._targetID);
               }
               else
               {
                  this._walkOverHander();
               }
            }
            _playerInfo.posX = x;
            _playerInfo.posY = y;
            if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalStandBack";
               }
            }
            else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
            {
               if(sceneCharacterStateType == "natural")
               {
                  sceneCharacterActionType = "naturalStandFront";
               }
            }
         }
      }
   }
}

