package bagAndInfo.cell
{
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import bagAndInfo.tips.CharacterPropTxtTipInfo;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.Directions;
   import ddt.manager.PlayerManager;
   
   public class CallTextButtonListCell extends TextButton implements IListCell, ITipedDisplay
   {
      
      protected var _tipDirection:String = Directions.DIRECTION_R + "," + Directions.DIRECTION_TR + "," + Directions.DIRECTION_BR;
      
      public function CallTextButtonListCell()
      {
         super();
         mouseChildren = false;
      }
      
      public function getCellValue() : *
      {
         return _text;
      }
      
      public function setCellValue(param1:*) : void
      {
         text = param1;
         ShowTipManager.Instance.addTip(this);
         _tipStyle = "core.CallPropTxtTips";
         _tipGapH = 80;
         if(Boolean(PlayerManager.Instance.callPropData) && Boolean(PlayerManager.Instance.callPropData[param1]))
         {
            _tipData = PlayerManager.Instance.callPropData[param1] as CallPropTxtTipInfo;
         }
         else
         {
            _tipData = new CallPropTxtTipInfo();
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         _tipData = param1 as CharacterPropTxtTipInfo;
      }
      
      override public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      override public function set tipDirctions(param1:String) : void
      {
         this._tipDirection = param1;
      }
      
      override public function get tipGapH() : int
      {
         return _tipGapH;
      }
      
      override public function set tipGapH(param1:int) : void
      {
         _tipGapH = param1;
      }
      
      override public function get tipGapV() : int
      {
         return _tipGapV;
      }
      
      override public function set tipGapV(param1:int) : void
      {
         _tipGapV = param1;
      }
      
      override public function get tipStyle() : String
      {
         return _tipStyle;
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         super.dispose();
      }
   }
}

