package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   
   public class RightChatFacePanel extends ChatFacePanel
   {
      
      public function RightChatFacePanel(param1:Boolean = false)
      {
         super(param1);
      }
      
      override protected function createBg() : void
      {
         _bg = ComponentFactory.Instance.creat("asset.chat.FacePanelBg2");
         addChild(_bg);
      }
   }
}

