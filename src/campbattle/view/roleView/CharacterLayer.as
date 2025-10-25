package campbattle.view.roleView
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   import flash.display.Bitmap;
   
   public class CharacterLayer extends BaseLayer
   {
      
      private var _equipType:int;
      
      private var _sex:Boolean;
      
      private var _index:int;
      
      private var _direction:int;
      
      private var _baseURL:String;
      
      private var _sceneID:int;
      
      public function CharacterLayer(param1:ItemTemplateInfo, param2:int, param3:Boolean, param4:int, param5:int, param6:String, param7:int)
      {
         this._equipType = param2;
         this._sex = param3;
         this._index = param4;
         this._direction = param5;
         this._baseURL = param6;
         this._sceneID = param7;
         super(param1);
      }
      
      override public function reSetBitmap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         this.clearBitmap();
         _loc1_ = 0;
         while(_loc1_ < _queueLoader.loaders.length)
         {
            if(_queueLoader.loaders[_loc1_].content)
            {
               _loc2_ = new Bitmap((_queueLoader.loaders[_loc1_].content as Bitmap).bitmapData);
            }
            _bitmaps.push(_loc2_);
            if(Boolean(_bitmaps[_loc1_]))
            {
               _bitmaps[_loc1_].smoothing = true;
               _bitmaps[_loc1_].visible = false;
               addChild(_bitmaps[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      override protected function clearBitmap() : void
      {
         while(Boolean(this) && this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         _bitmaps = new Vector.<Bitmap>();
      }
      
      override protected function getUrl(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = "";
         if(this._sceneID == 1)
         {
            _loc2_ = this._direction == 1 ? "clothF" : (this._direction == 2 ? "cloth" : "clothF");
            _loc6_ = this._baseURL + "/cloth/" + (this._sex ? "M" : "F") + "/" + _loc2_ + "/" + String(param1) + ".png";
         }
         else if(this._sceneID == 2)
         {
            _loc3_ = this._equipType == 1 ? "face" : (this._equipType == 2 ? "cloth" : "hair");
            _loc4_ = this._sex ? "M" : "F";
            _loc5_ = _loc3_ + (this._direction == 1 ? "" : "F");
            _loc6_ = this._baseURL + _loc3_ + "/" + _loc4_ + "/" + String(this._index) + "/" + _loc5_ + "/" + String(param1) + ".png";
         }
         else if(this._sceneID == 3)
         {
            _loc6_ = PathManager.solveSceneCharacterLoaderPath(_info.CategoryID,_info.Pic,this._sex,_info.NeedSex == 1,String(param1),this._direction);
         }
         else if(this._sceneID == 4)
         {
            _loc3_ = this._equipType == 1 ? "face" : (this._equipType == 2 ? "cloth" : "hair");
            _loc4_ = this._sex ? "M" : "F";
            _loc5_ = _loc3_ + (this._direction == 1 ? "" : "F");
            _loc6_ = this._baseURL + _loc3_ + "/" + _loc4_ + "/" + String(this._index) + "/" + _loc5_ + "/" + String(param1) + ".png";
         }
         return _loc6_;
      }
   }
}

