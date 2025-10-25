package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.view.cardCollect.CardSelectItem;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatBasePanel;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class CardSelect extends ChatBasePanel implements Disposeable
   {
      
      private var _list:VBox;
      
      private var _bg:ScaleBitmapImage;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<CardSelectItem>;
      
      private var _cardinfo:Vector.<CardInfo>;
      
      private var _cardIdVec:Vector.<int>;
      
      private var _bagCard:Vector.<CardInfo>;
      
      private var _equipArr:Array;
      
      public function CardSelect()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemList = new Vector.<CardSelectItem>();
         this._cardinfo = new Vector.<CardInfo>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.CardListBg");
         this._list = new VBox();
         this._panel = ComponentFactory.Instance.creatComponentByStylename("CardBagView.cardselect");
         this._panel.setView(this._list);
         addChild(this._bg);
         addChild(this._panel);
         this.setList();
      }
      
      private function setList() : void
      {
         var _loc3_:CardSelectItem = null;
         var _loc1_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new CardSelectItem();
            _loc3_.info = _loc1_[_loc2_];
            _loc3_.addEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            this._itemList.push(_loc3_);
            this._list.addChild(_loc3_);
            _loc2_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClick(param1:CardEvent) : void
      {
         var _loc4_:SetsInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:int = int(param1.data.id);
         var _loc3_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for each(_loc4_ in _loc3_)
         {
            if(int(_loc4_.ID) == _loc2_)
            {
               this._cardIdVec = _loc4_.cardIdVec;
               break;
            }
         }
         if(this._cardIdVec != null)
         {
            this.moveAllCard();
         }
      }
      
      private function getbagCard() : Vector.<CardInfo>
      {
         var _loc3_:DictionaryData = null;
         var _loc4_:CardInfo = null;
         var _loc5_:CardInfo = null;
         var _loc1_:Vector.<CardInfo> = new Vector.<CardInfo>();
         var _loc2_:int = 0;
         while(_loc2_ < this._cardIdVec.length)
         {
            _loc3_ = PlayerManager.Instance.Self.cardBagDic;
            _loc4_ = null;
            for each(_loc5_ in _loc3_)
            {
               if(_loc5_.TemplateID == this._cardIdVec[_loc2_])
               {
                  _loc1_.push(_loc5_);
                  break;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function dealNeedEquip() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for(_loc1_ in PlayerManager.Instance.Self.cardEquipDic)
         {
            if(PlayerManager.Instance.Self.cardEquipDic == null)
            {
               break;
            }
            _loc2_ = 0;
            while(_loc2_ < this._bagCard.length)
            {
               if(PlayerManager.Instance.Self.cardEquipDic[_loc1_].TemplateID == this._bagCard[_loc2_].TemplateID)
               {
                  this._bagCard.splice(_loc2_,1);
                  _loc3_ = int(this._equipArr.indexOf(int(_loc1_)));
                  if(_loc3_ > -1)
                  {
                     this._equipArr.splice(_loc3_,1);
                  }
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      private function moveAllCard() : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:DictionaryData = new DictionaryData();
         this._bagCard = this.getbagCard();
         if(this._bagCard.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.noHaveCard"));
            return;
         }
         this._equipArr = [1,2,3,4];
         this.dealNeedEquip();
         var _loc2_:int = 0;
         while(_loc2_ < this._bagCard.length)
         {
            if(this._bagCard[_loc2_].templateInfo.Property8 == "1")
            {
               _loc1_.add(0,this._bagCard[_loc2_].Place);
            }
            else
            {
               _loc4_ = 1;
               while(_loc4_ < 5)
               {
                  if(PlayerManager.Instance.Self.cardEquipDic[_loc4_] == null)
                  {
                     if(_loc1_[_loc4_] == null)
                     {
                        _loc1_.add(_loc4_,this._bagCard[_loc2_].Place);
                        break;
                     }
                  }
                  if(_loc4_ == 4)
                  {
                     _loc5_ = 0;
                     while(_loc5_ < this._equipArr.length)
                     {
                        _loc6_ = int(this._equipArr[_loc5_]);
                        if(_loc1_[_loc6_] == null)
                        {
                           this._equipArr.splice(_loc5_,1);
                           _loc1_.add(_loc6_,this._bagCard[_loc2_].Place);
                           break;
                        }
                        _loc5_++;
                     }
                  }
                  _loc4_++;
               }
            }
            _loc2_++;
         }
         for(_loc3_ in _loc1_)
         {
            SocketManager.Instance.out.sendMoveCards(_loc1_[_loc3_],int(_loc3_));
         }
         if(_loc1_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.text"));
         }
         if(_loc1_.length > 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HaveCard"));
         }
      }
      
      override protected function __hideThis(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(DisplayUtils.isTargetOrContain(_loc2_,this._panel.vScrollbar))
         {
            return;
         }
         SoundManager.instance.play("008");
         setVisible = false;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         while(_loc1_ < this._itemList.length)
         {
            this._itemList[_loc1_].removeEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            ObjectUtils.disposeObject(this._itemList[_loc1_]);
            this._itemList[_loc1_] = null;
            _loc1_++;
         }
         this._itemList = null;
      }
   }
}

