package ddt.view.chat
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.AreaInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ChatPrivateFrame extends BaseAlerFrame
   {
      
      private var _friendList:Array;
      
      private var _comBox:ComboBox;
      
      private var _textField:FilterFrameText;
      
      private var _comBoxII:ComboBox;
      
      private var _descriptionTxtII:FilterFrameText;
      
      private var _selectedCheckButtonContainer:HBox;
      
      private var _selfAreaCheckButton:SelectedCheckButton;
      
      private var _spanAreaCheckButton:SelectedCheckButton;
      
      protected var _AreaCheckButtonGroup:SelectedButtonGroup;
      
      protected var _state:int;
      
      private var _currentAreaInfo:AreaInfo;
      
      public function ChatPrivateFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc4_:FriendListPlayer = null;
         super.init();
         this._comBox = ComponentFactory.Instance.creat("chat.FriendListCombo");
         this._comBox.addEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         this._textField = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameComboText");
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameText");
         _loc1_.text = LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.nick");
         var _loc2_:VectorListModel = this._comBox.listPanel.vectorListModel;
         this._friendList = PlayerManager.Instance.onlineFriendList;
         this._comBox.snapItemHeight = this._friendList.length < 4;
         this._comBox.selctedPropName = "text";
         this._comBox.beginChanges();
         var _loc3_:uint = 0;
         while(_loc3_ < this._friendList.length)
         {
            _loc4_ = this._friendList[_loc3_] as FriendListPlayer;
            _loc2_.append(_loc4_.NickName);
            _loc3_++;
         }
         this._comBox.listPanel.list.updateListView();
         this._comBox.commitChanges();
         this._comBox.textField = this._textField;
         this._textField.maxChars = 15;
         this._textField.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._comBox.button.addEventListener(MouseEvent.CLICK,this.__playSound);
         this._comBox.addEventListener(InteractiveEvent.STATE_CHANGED,this.__comChange);
         addToContent(_loc1_);
         addToContent(this._comBox);
         addToContent(this._comBox.textField);
         this.createAreaComboBox();
         this._state = 0;
      }
      
      private function createAreaComboBox() : void
      {
         var _loc1_:AreaInfo = null;
         this._AreaCheckButtonGroup = new SelectedButtonGroup();
         this._selectedCheckButtonContainer = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrame.SelectedCheckButtonContainer");
         this._AreaCheckButtonGroup.addEventListener(Event.CHANGE,this.__ItemGroupChange);
         this._descriptionTxtII = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrameTextII");
         this._descriptionTxtII.text = LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.area");
         this._comBoxII = ComponentFactory.Instance.creat("chat.FriendListComboII");
         this._selfAreaCheckButton = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrame.selfArea");
         this._selfAreaCheckButton.text = LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.selfArea");
         this._spanAreaCheckButton = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrame.spanArea");
         this._spanAreaCheckButton.text = LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.spanArea");
         this._selectedCheckButtonContainer.addChild(this._selfAreaCheckButton);
         this._selectedCheckButtonContainer.addChild(this._spanAreaCheckButton);
         this._AreaCheckButtonGroup.addSelectItem(this._selfAreaCheckButton);
         this._AreaCheckButtonGroup.addSelectItem(this._spanAreaCheckButton);
         this._AreaCheckButtonGroup.selectIndex = 0;
         for each(_loc1_ in PlayerManager.Instance.areaList)
         {
            this._comBoxII.listPanel.vectorListModel.append(_loc1_.areaName);
         }
         this._comBoxII.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onSelectArea);
         this._comBoxII.button.addEventListener(MouseEvent.CLICK,this.__playSound);
         if(PathManager.crossServerChatSwitch)
         {
            addToContent(this._comBoxII);
            addToContent(this._descriptionTxtII);
            addToContent(this._selectedCheckButtonContainer);
         }
         this._comBoxII.textField.text = PlayerManager.Instance.getSelfAreaNameByAreaID();
      }
      
      protected function __onSelectArea(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(PlayerManager.Instance.areaList[param1.cellValue]) && PlayerManager.Instance.areaList[param1.cellValue].areaID != PlayerManager.Instance.Self.ZoneID)
         {
            this._AreaCheckButtonGroup.selectIndex = 1;
            this._currentAreaInfo = PlayerManager.Instance.areaList[param1.cellValue];
            this._state = 1;
         }
         else
         {
            this._AreaCheckButtonGroup.selectIndex = 0;
            this._state = 0;
            this._comBoxII.textField.text = PlayerManager.Instance.getSelfAreaNameByAreaID();
         }
      }
      
      protected function __ItemGroupChange(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         this._state = this._AreaCheckButtonGroup.selectIndex;
         if(this._state == 0)
         {
            this._comBoxII.textField.text = PlayerManager.Instance.getSelfAreaNameByAreaID();
         }
      }
      
      private function __setFocus(param1:Event) : void
      {
         this._comBox.removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         StageReferance.stage.focus = this._comBox.textField;
      }
      
      private function __comChange(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
         }
      }
      
      private function __playSound(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         setChildIndex(_container,numChildren - 1);
      }
      
      public function get currentFriend() : String
      {
         return this._textField.text;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function get currentAreaInfo() : AreaInfo
      {
         return this._currentAreaInfo;
      }
      
      override public function dispose() : void
      {
         this._comBox.removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         if(ChatManager.Instance.input.inputField.privateChatName == "")
         {
            ChatManager.Instance.inputChannel = ChatInputView.CURRENT;
         }
         this._friendList = null;
         this._AreaCheckButtonGroup.removeEventListener(Event.CHANGE,this.__ItemGroupChange);
         this._textField.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._comBox.button.removeEventListener(MouseEvent.CLICK,this.__playSound);
         this._comBox.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__comChange);
         this._comBox.dispose();
         this._comBox = null;
         this._textField = null;
         this._comBoxII.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onSelectArea);
         this._comBoxII.button.removeEventListener(MouseEvent.CLICK,this.__playSound);
         ObjectUtils.disposeObject(this._comBoxII);
         this._comBoxII = null;
         ObjectUtils.disposeObject(this._selfAreaCheckButton);
         this._selfAreaCheckButton = null;
         ObjectUtils.disposeObject(this._spanAreaCheckButton);
         this._spanAreaCheckButton = null;
         ObjectUtils.disposeObject(this._selectedCheckButtonContainer);
         this._selectedCheckButtonContainer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

