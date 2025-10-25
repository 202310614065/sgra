package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.sceneCharacter.SceneCharacterActionItem;
   import ddt.view.sceneCharacter.SceneCharacterActionSet;
   import ddt.view.sceneCharacter.SceneCharacterItem;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.sceneCharacter.SceneCharacterSet;
   import ddt.view.sceneCharacter.SceneCharacterStateItem;
   import ddt.view.sceneCharacter.SceneCharacterStateSet;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CampBaseRole extends SceneCharacterPlayerBase
   {
      
      public var scene:SceneScene;
      
      public var clickFun:Function;
      
      public var playerWitdh:Number = 120;
      
      public var playerHeight:Number = 175;
      
      protected var _playerInfo:RoleData;
      
      private var _defaultSceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _defaultSceneCharacterSetNatural:SceneCharacterSet;
      
      private var _defaultSceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _sceneCharacterStateSet:SceneCharacterStateSet;
      
      private var _sceneCharacterSetNatural:SceneCharacterSet;
      
      private var _sceneCharacterActionSetNatural:SceneCharacterActionSet;
      
      private var _headBitmapData:BitmapData;
      
      private var _bodyBitmapData:BitmapData;
      
      private var _rectangle:Rectangle = new Rectangle();
      
      private var _callBack:Function;
      
      private var _sceneCharacterLoaderBody:LoaderHeadOrBody;
      
      private var _sceneCharacterLoaderHead:LoaderHeadOrBody;
      
      private var _loadComplete:Boolean;
      
      private var _hotArea:Sprite;
      
      public function CampBaseRole(param1:RoleData = null, param2:Function = null)
      {
         super(param2);
         this._playerInfo = param1;
         this._callBack = param2;
         this.initialize();
         x = this._playerInfo.posX;
         y = this._playerInfo.posY;
      }
      
      private function defaultSkin() : void
      {
         if(!this._loadComplete)
         {
            this._headBitmapData = ComponentFactory.Instance.creatBitmapData("game.player.defaultPlayerCharacter");
            this.showDefaultCharacter();
         }
      }
      
      private function showDefaultCharacter() : void
      {
         var _loc1_:BitmapData = null;
         this._defaultSceneCharacterSetNatural = new SceneCharacterSet();
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(25,20));
         this._defaultSceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,1));
         var _loc2_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc2_);
         var _loc3_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc3_);
         var _loc4_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc4_);
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[0],false);
         this._defaultSceneCharacterActionSetNatural.push(_loc5_);
         var _loc6_:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._defaultSceneCharacterSetNatural,this._defaultSceneCharacterActionSetNatural);
         this._defaultSceneCharacterStateSet.push(_loc6_);
         super.loadComplete = false;
         super.isDefaultCharacter = true;
         super.sceneCharacterStateSet = this._defaultSceneCharacterStateSet;
      }
      
      public function get playerInfo() : RoleData
      {
         return this._playerInfo;
      }
      
      public function walk(param1:Point, param2:Function = null, param3:int = 0, param4:int = 0) : void
      {
      }
      
      public function addClickEvent() : void
      {
         this._hotArea = new Sprite();
         this._hotArea.graphics.beginFill(0,0);
         this._hotArea.graphics.drawRect(-this.playerWitdh / 2,-this.playerHeight,this.playerWitdh,this.playerHeight);
         this._hotArea.graphics.endFill();
         addChild(this._hotArea);
         this._hotArea.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._hotArea.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHander);
         this._hotArea.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHander);
      }
      
      protected function mouseOutHander(param1:MouseEvent) : void
      {
      }
      
      protected function mouseOverHander(param1:MouseEvent) : void
      {
      }
      
      protected function mouseClickHander(param1:MouseEvent) : void
      {
      }
      
      private function initialize() : void
      {
         this._sceneCharacterStateSet = new SceneCharacterStateSet();
         this._sceneCharacterActionSetNatural = new SceneCharacterActionSet();
         this.sceneCharacterLoadHead();
      }
      
      private function sceneCharacterLoadHead() : void
      {
         this._sceneCharacterLoaderHead = new LoaderHeadOrBody(this._playerInfo,1,this._playerInfo.isDefault);
         this._sceneCharacterLoaderHead.load(this.sceneCharacterLoaderHeadCallBack);
      }
      
      private function sceneCharacterLoaderHeadCallBack(param1:LoaderHeadOrBody, param2:Boolean = true) : void
      {
         this._headBitmapData = param1.getContent()[0] as BitmapData;
         if(Boolean(param1))
         {
            param1.dispose();
         }
         if(!param2 || !this._headBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         this.sceneCharacterStateNatural();
      }
      
      private function sceneCharacterStateNatural() : void
      {
         var _loc1_:BitmapData = null;
         this._sceneCharacterSetNatural = new SceneCharacterSet();
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,-1));
         _loc2_.push(new Point(0,2));
         _loc2_.push(new Point(0,0));
         _loc2_.push(new Point(0,-1));
         _loc2_.push(new Point(0,2));
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontHead","NaturalFrontAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,1,_loc2_,true,7));
         this._rectangle.x = this.playerWitdh;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseHead","NaturalFrontEyesCloseAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,2));
         this._rectangle.x = this.playerWitdh * 2;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc1_ = new BitmapData(this.playerWitdh,this.playerHeight * 2,true,0);
         _loc1_.copyPixels(this._headBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackHead","NaturalBackAction",_loc1_,1,1,this.playerWitdh,this.playerHeight,6,_loc2_,true,7));
         this.sceneCharacterLoadBodyNatural();
      }
      
      private function sceneCharacterLoadBodyNatural() : void
      {
         this._sceneCharacterLoaderBody = new LoaderHeadOrBody(this._playerInfo,2);
         this._sceneCharacterLoaderBody.load(this.sceneCharacterLoaderBodyNaturalCallBack);
      }
      
      private function disposeDefaultSource() : void
      {
         if(Boolean(this._defaultSceneCharacterStateSet))
         {
            this._defaultSceneCharacterStateSet.dispose();
         }
         this._defaultSceneCharacterStateSet = null;
         if(Boolean(this._defaultSceneCharacterSetNatural))
         {
            this._defaultSceneCharacterSetNatural.dispose();
         }
         this._defaultSceneCharacterSetNatural = null;
         if(Boolean(this._defaultSceneCharacterActionSetNatural))
         {
            this._defaultSceneCharacterActionSetNatural.dispose();
         }
         this._defaultSceneCharacterActionSetNatural = null;
      }
      
      private function sceneCharacterLoaderBodyNaturalCallBack(param1:LoaderHeadOrBody, param2:Boolean) : void
      {
         var _loc3_:BitmapData = null;
         this._loadComplete = true;
         if(!this._sceneCharacterSetNatural)
         {
            return;
         }
         this._bodyBitmapData = param1.getContent()[0] as BitmapData;
         if(Boolean(param1))
         {
            param1.dispose();
         }
         if(!param2 || !this._bodyBitmapData)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         if(!this._rectangle)
         {
            this._rectangle = new Rectangle();
         }
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontBody","NaturalFrontAction",_loc3_,1,7,this.playerWitdh,this.playerHeight,3));
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.width = this.playerWitdh;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this.playerWitdh,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalFrontEyesCloseBody","NaturalFrontEyesCloseAction",_loc3_,1,1,this.playerWitdh,this.playerHeight,4));
         this._rectangle.x = 0;
         this._rectangle.y = this.playerHeight;
         this._rectangle.width = this._bodyBitmapData.width;
         this._rectangle.height = this.playerHeight;
         _loc3_ = new BitmapData(this._bodyBitmapData.width,this.playerHeight,true,0);
         _loc3_.copyPixels(this._bodyBitmapData,this._rectangle,new Point(0,0));
         this._sceneCharacterSetNatural.push(new SceneCharacterItem("NaturalBackBody","NaturalBackAction",_loc3_,1,7,this.playerWitdh,this.playerHeight,5));
         var _loc4_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandFront",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7],true);
         this._sceneCharacterActionSetNatural.push(_loc4_);
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalStandBack",[8],false);
         this._sceneCharacterActionSetNatural.push(_loc5_);
         var _loc6_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkFront",[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._sceneCharacterActionSetNatural.push(_loc6_);
         var _loc7_:SceneCharacterActionItem = new SceneCharacterActionItem("naturalWalkBack",[9,9,9,10,10,10,11,11,11,12,12,12,13,13,13,14,14,14],true);
         this._sceneCharacterActionSetNatural.push(_loc7_);
         var _loc8_:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._sceneCharacterSetNatural,this._sceneCharacterActionSetNatural);
         this._sceneCharacterStateSet.push(_loc8_);
         super.loadComplete = true;
         super.isDefaultCharacter = false;
         super.sceneCharacterStateSet = this._sceneCharacterStateSet;
         this.disposeDefaultSource();
      }
      
      override public function dispose() : void
      {
         this.disposeDefaultSource();
         this._playerInfo = null;
         this._callBack = null;
         if(Boolean(this._hotArea))
         {
            this._hotArea.graphics.clear();
            this._hotArea.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
            this._hotArea.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHander);
            this._hotArea.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHander);
            this._hotArea = null;
         }
         if(Boolean(this._sceneCharacterSetNatural))
         {
            this._sceneCharacterSetNatural.dispose();
         }
         this._sceneCharacterSetNatural = null;
         if(Boolean(this._sceneCharacterActionSetNatural))
         {
            this._sceneCharacterActionSetNatural.dispose();
         }
         this._sceneCharacterActionSetNatural = null;
         if(Boolean(this._sceneCharacterStateSet))
         {
            this._sceneCharacterStateSet.dispose();
         }
         this._sceneCharacterStateSet = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderBody);
         this._sceneCharacterLoaderBody = null;
         ObjectUtils.disposeObject(this._sceneCharacterLoaderHead);
         this._sceneCharacterLoaderHead = null;
         if(Boolean(this._headBitmapData))
         {
            this._headBitmapData.dispose();
         }
         this._headBitmapData = null;
         if(Boolean(this._bodyBitmapData))
         {
            this._bodyBitmapData.dispose();
         }
         this._bodyBitmapData = null;
         this._rectangle = null;
         super.dispose();
      }
   }
}

