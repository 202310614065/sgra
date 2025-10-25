package bagAndInfo.info
{
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.Directions;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.EffortEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PlayerInfoEffortHonorView extends Sprite implements Disposeable
   {
      
      private var _nameChoose:ComboBox;
      
      private var _honorArray:Array;
      
      public function PlayerInfoEffortHonorView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._nameChoose = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameChoose");
         addChild(this._nameChoose);
         EffortManager.Instance.addEventListener(EffortEvent.FINISH,this.__upadte);
         this._nameChoose.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._nameChoose.button.tipStyle = "core.CallPropTxtTips";
         this._nameChoose.button.tipDirctions = Directions.DIRECTION_R + "," + Directions.DIRECTION_TR + "," + Directions.DIRECTION_BR;
         this._nameChoose.button.tipGapH = 45;
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function __upadte(param1:EffortEvent) : void
      {
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["honor"] == true)
         {
            if(PlayerManager.Instance.Self.honor != "")
            {
               this._nameChoose.textField.text = this.setNameChooseText(PlayerManager.Instance.Self.honor);
            }
            else
            {
               this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            }
         }
      }
      
      private function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function update() : void
      {
         var _loc1_:VectorListModel = null;
         var _loc2_:int = 0;
         if(Boolean(this._nameChoose))
         {
            this._nameChoose.beginChanges();
            this._nameChoose.selctedPropName = "text";
            _loc1_ = this._nameChoose.listPanel.vectorListModel;
            _loc1_.clear();
            this._nameChoose.button.tipData = new CallPropTxtTipInfo();
            if(!this._honorArray)
            {
               return;
            }
            if(this._honorArray.length == 0)
            {
               _loc1_.append("无称号");
            }
            _loc2_ = 0;
            while(_loc2_ < this._honorArray.length)
            {
               _loc1_.append(this._honorArray[_loc2_]);
               _loc2_++;
            }
            this._nameChoose.listPanel.list.updateListView();
            this._nameChoose.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
            this._nameChoose.commitChanges();
            if(PlayerManager.Instance.Self.honor != "")
            {
               this._nameChoose.textField.text = this.setNameChooseText(PlayerManager.Instance.Self.honor);
               this.checkCllProp(PlayerManager.Instance.Self.honor);
            }
            else
            {
               this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            }
         }
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this._honorArray[param1.index];
         if(Boolean(_loc2_))
         {
            SocketManager.Instance.out.sendReworkRank(_loc2_);
            this.checkCllProp(_loc2_);
         }
         else
         {
            SocketManager.Instance.out.sendReworkRank("");
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            this._nameChoose.button.tipData = new CallPropTxtTipInfo();
         }
      }
      
      private function setNameChooseText(param1:String) : String
      {
         var _loc2_:String = param1;
         if(param1.length > 12)
         {
            _loc2_ = param1.slice(0,10) + "..";
         }
         return _loc2_;
      }
      
      private function checkCllProp(param1:String) : void
      {
         if(Boolean(PlayerManager.Instance.callPropData) && Boolean(PlayerManager.Instance.callPropData[param1]))
         {
            this._nameChoose.button.tipData = PlayerManager.Instance.callPropData[param1] as CallPropTxtTipInfo;
         }
         else
         {
            this._nameChoose.button.tipData = new CallPropTxtTipInfo();
         }
      }
      
      public function setlist(param1:Array) : void
      {
         this._honorArray = [];
         this._honorArray = param1;
         if(!this._honorArray)
         {
            return;
         }
      }
      
      public function dispose() : void
      {
         this._nameChoose.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(Boolean(this._nameChoose))
         {
            ObjectUtils.disposeObject(this._nameChoose);
         }
         this._nameChoose = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

