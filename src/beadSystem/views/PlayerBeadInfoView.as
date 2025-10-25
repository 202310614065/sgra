package beadSystem.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import store.view.embed.EmbedStoneCell;
   
   public class PlayerBeadInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _beadCells:DictionaryData;
      
      private var _HoleOpen:DictionaryData;
      
      private var _pointArray:Vector.<Point>;
      
      private var _playerInfo:PlayerInfo;
      
      public function PlayerBeadInfoView()
      {
         super();
         this._HoleOpen = new DictionaryData();
         this._beadCells = new DictionaryData();
         this.getCellsPoint();
         this.initView();
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
         this._bg = ComponentFactory.Instance.creatBitmap("beadSystem.playerBeadInfo.bg");
         addChild(this._bg);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[1,1]);
         _loc1_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint1")).x;
         _loc1_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint1")).y;
         _loc1_.StoneType = 1;
         addChild(_loc1_);
         this._beadCells.add(1,_loc1_);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[2,2]);
         _loc2_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint2")).x;
         _loc2_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint2")).y;
         _loc2_.StoneType = 2;
         addChild(_loc2_);
         this._beadCells.add(2,_loc2_);
         _loc3_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[3,2]);
         _loc3_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint3")).x;
         _loc3_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint3")).y;
         _loc3_.StoneType = 2;
         addChild(_loc3_);
         this._beadCells.add(3,_loc3_);
         _loc4_ = 4;
         while(_loc4_ <= 12)
         {
            _loc11_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[_loc4_,3]);
            _loc11_.StoneType = 3;
            _loc11_.x = this._pointArray[_loc4_ - 1].x;
            _loc11_.y = this._pointArray[_loc4_ - 1].y;
            addChild(_loc11_);
            this._beadCells.add(_loc4_,_loc11_);
            _loc4_++;
         }
         _loc5_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[13,3]);
         _loc5_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint13")).x;
         _loc5_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint13")).y;
         _loc5_.StoneType = 3;
         addChild(_loc5_);
         this._beadCells.add(13,_loc5_);
         this._HoleOpen.add(13,_loc5_);
         _loc6_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[14,3]);
         _loc6_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint14")).x;
         _loc6_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint14")).y;
         _loc6_.StoneType = 3;
         addChild(_loc6_);
         this._beadCells.add(14,_loc6_);
         this._HoleOpen.add(14,_loc6_);
         _loc7_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[15,3]);
         _loc7_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint15")).x;
         _loc7_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint15")).y;
         _loc7_.StoneType = 3;
         addChild(_loc7_);
         this._beadCells.add(15,_loc7_);
         this._HoleOpen.add(15,_loc7_);
         _loc8_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[16,3]);
         _loc8_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint16")).x;
         _loc8_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint16")).y;
         _loc8_.StoneType = 3;
         addChild(_loc8_);
         this._beadCells.add(16,_loc8_);
         this._HoleOpen.add(16,_loc8_);
         var _loc9_:EmbedStoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[17,3]);
         _loc9_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint17")).x;
         _loc9_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint17")).y;
         _loc9_.StoneType = 3;
         addChild(_loc9_);
         this._beadCells.add(17,_loc9_);
         this._HoleOpen.add(17,_loc9_);
         _loc10_ = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[18,3]);
         _loc10_.x = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint18")).x;
         _loc10_.y = Point(ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint18")).y;
         _loc10_.StoneType = 3;
         addChild(_loc10_);
         this._beadCells.add(18,_loc10_);
         this._HoleOpen.add(18,_loc10_);
      }
      
      private function getCellsPoint() : void
      {
         var _loc2_:Point = null;
         this._pointArray = new Vector.<Point>();
         var _loc1_:int = 1;
         while(_loc1_ <= 18)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("bead.PlayerEmbedpoint" + _loc1_);
            this._pointArray.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         var _loc2_:EmbedStoneCell = null;
         var _loc3_:EmbedStoneCell = null;
         this._playerInfo = param1;
         if(Boolean(param1))
         {
            for each(_loc2_ in this._beadCells)
            {
               _loc2_.info = null;
            }
            for each(_loc3_ in this._beadCells)
            {
               _loc3_.otherPlayer = param1;
               _loc3_.itemInfo = param1.BeadBag.getItemAt(_loc3_.ID);
               _loc3_.info = param1.BeadBag.getItemAt(_loc3_.ID);
               if(_loc3_.ID >= 13 && Boolean(param1.BeadBag.getItemAt(_loc3_.ID)))
               {
                  _loc3_.open();
               }
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         for each(_loc1_ in this._beadCells)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

