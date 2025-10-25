package campbattle.view.roleView
{
   import campbattle.data.RoleData;
   import ddt.manager.ItemManager;
   import ddt.view.character.ILayer;
   import ddt.view.sceneCharacter.SceneCharacterLayer;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class LoaderHeadOrBody
   {
      
      private var _loaders:Array;
      
      private var _content:BitmapData;
      
      private var _completeCount:int;
      
      private var _isAllLoadSucceed:Boolean = true;
      
      private var _callBack:Function;
      
      private var _consBatPlayerData:RoleData;
      
      private var _equipType:int;
      
      private var _bool:Boolean;
      
      private var _recordStyle:Array;
      
      private var _recordColor:Array;
      
      public function LoaderHeadOrBody(param1:RoleData, param2:int, param3:Boolean = false)
      {
         super();
         this._consBatPlayerData = param1;
         this._equipType = param2;
         this._bool = param3;
      }
      
      public function load(param1:Function = null) : void
      {
         this._callBack = param1;
         this.initLoaders();
         var _loc2_:int = int(this._loaders.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._loaders[_loc3_].load(this.layerComplete);
            _loc3_++;
         }
      }
      
      private function initLoaders() : void
      {
         this._loaders = new Array();
         var _loc1_:int = 5361;
         if(this._bool)
         {
            if(this._equipType == 1)
            {
               this._recordStyle = this._consBatPlayerData.Style.split(",");
               this._recordColor = this._consBatPlayerData.Colors.split(",");
               this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[5].split("|")[0])),this._recordColor[5]));
               this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[2].split("|")[0])),this._recordColor[2]));
               this._loaders.push(new SceneCharacterLayer(ItemManager.Instance.getTemplateById(int(this._recordStyle[3].split("|")[0])),this._recordColor[3]));
            }
            return;
         }
         if(this._equipType == 1)
         {
            this._loaders.push(new CharacterLayer(ItemManager.Instance.getTemplateById(_loc1_),1,this._consBatPlayerData.sex,this._consBatPlayerData.team,1,this._consBatPlayerData.baseURl,this._consBatPlayerData.sceneID));
            this._loaders.push(new CharacterLayer(ItemManager.Instance.getTemplateById(_loc1_),3,this._consBatPlayerData.sex,this._consBatPlayerData.team,1,this._consBatPlayerData.baseURl,this._consBatPlayerData.sceneID));
         }
         else if(this._equipType == 2)
         {
            this._loaders.push(new CharacterLayer(ItemManager.Instance.getTemplateById(_loc1_),2,this._consBatPlayerData.sex,this._consBatPlayerData.team,1,this._consBatPlayerData.baseURl,this._consBatPlayerData.sceneID));
            this._loaders.push(new CharacterLayer(ItemManager.Instance.getTemplateById(_loc1_),2,this._consBatPlayerData.sex,this._consBatPlayerData.team,2,this._consBatPlayerData.baseURl,this._consBatPlayerData.sceneID));
         }
      }
      
      private function drawCharacter() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:Number = Number(this._loaders[0].width);
         var _loc2_:Number = Number(this._loaders[0].height);
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         this._content = new BitmapData(_loc1_,_loc2_,true,0);
         var _loc3_:uint = 0;
         while(_loc3_ < this._loaders.length)
         {
            _loc4_ = this._loaders[_loc3_];
            if(!_loc4_.isAllLoadSucceed)
            {
               this._isAllLoadSucceed = false;
            }
            this._content.draw(_loc4_.getContent(),null,null,BlendMode.NORMAL);
            _loc3_++;
         }
      }
      
      private function layerComplete(param1:ILayer) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._loaders.length)
         {
            if(!this._loaders[_loc3_].isComplete)
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this.drawCharacter();
            this.loadComplete();
         }
      }
      
      private function loadComplete() : void
      {
         if(this._callBack != null)
         {
            this._callBack(this,this._isAllLoadSucceed);
         }
      }
      
      public function getContent() : Array
      {
         return [this._content];
      }
      
      public function dispose() : void
      {
         if(this._loaders == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._loaders.length)
         {
            this._loaders[_loc1_].dispose();
            _loc1_++;
         }
         this._loaders = null;
         this._consBatPlayerData = null;
         this._callBack = null;
      }
   }
}

