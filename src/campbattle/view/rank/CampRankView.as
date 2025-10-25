package campbattle.view.rank
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.rank.RankData;
   import consortion.rank.RankFrame;
   import consortion.rank.RankItem;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   
   public class CampRankView extends RankFrame
   {
      
      private var _bg:Bitmap;
      
      public function CampRankView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         _type = PPAGE;
         this._bg = ComponentFactory.Instance.creat("asset.campbattle.rank.groud");
         addToContent(this._bg);
         super.initView();
         titleText = LanguageMgr.GetTranslation("ddt.campBattle.rankTitle");
         ObjectUtils.disposeObject(_back);
         ObjectUtils.disposeObject(_prankBit);
         ObjectUtils.disposeObject(_crankBit);
         ObjectUtils.disposeObject(_cRank);
         ObjectUtils.disposeObject(_pRank);
         ObjectUtils.disposeObject(_helpBtn);
         PositionUtils.setPos(_leftBtn,"ddtCampBattle.rankView.leftBtnPos");
         PositionUtils.setPos(_rightBtn,"ddtCampBattle.rankView.rightBtnPos");
         PositionUtils.setPos(_pageBack,"ddtCampBattle.rankView.pageBackPos");
         PositionUtils.setPos(_pageNum,"ddtCampBattle.rankView.pageNumPos");
         PositionUtils.setPos(_totalRank,"ddtCampBattle.rankView.totalRankPos");
         PositionUtils.setPos(_totalScroeTxt,"ddtCampBattle.rankView.totalScroeTxtPos");
      }
      
      public function setList(param1:Array) : void
      {
         _rankList = param1;
         setPageTxt(_rankList);
         setPageArr();
         this.setMyrank();
      }
      
      private function setMyrank() : void
      {
         var _loc3_:RankData = null;
         if(!_rankList)
         {
            return;
         }
         var _loc1_:int = int(_rankList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _rankList[_loc2_] as RankData;
            if(_loc3_.ZoneID == PlayerManager.Instance.Self.ZoneID && _loc3_.UserID == PlayerManager.Instance.Self.ID)
            {
               _totalRank.text = _loc3_.Rank.toString();
               _totalScroeTxt.text = _loc3_.Score.toString();
               break;
            }
            _loc2_++;
         }
      }
      
      override protected function initItemList(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:RankData = null;
         var _loc6_:RankItem = null;
         clearItemList();
         _itemContent.x = 34;
         _itemContent.y = 95;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = param1[_loc4_] as RankData;
            setRankTxt(_loc5_);
            if(_loc5_.Rank != -1)
            {
               _loc6_ = new RankItem(_loc5_);
               _loc6_.setView(_loc4_);
               _loc6_.setCampBattleStlye(false);
               _loc6_.y = (_loc6_.height + 4) * _loc3_;
               _itemContent.addChild(_loc6_);
               _loc3_++;
            }
            _loc4_++;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         super.dispose();
      }
   }
}

