package ddt.data
{
   import baglocked.BagLockedController;
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StatisticManager;
   import flash.display.LoaderInfo;
   import flash.system.Security;
   import game.GameManager;
   
   public class ConfigParaser
   {
      
      public function ConfigParaser()
      {
         super();
      }
      
      public static function paras(param1:XML, param2:LoaderInfo, param3:String) : void
      {
         var _loc8_:XML = null;
         var _loc9_:XMLList = null;
         var _loc10_:XML = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc4_:PathInfo = new PathInfo();
         _loc4_.SITEII = String(param2.parameters["site"]);
         if(_loc4_.SITEII == "undefined")
         {
            _loc4_.SITEII = "";
         }
         _loc4_.SITE = param1.SITE.@value;
         _loc4_.WEEKLY_SITE = param1.WEEKLYSITE.@value;
         _loc4_.BACKUP_FLASHSITE = param1.BACKUP_FLASHSITE.@value;
         _loc4_.FLASHSITE = param1.FLASHSITE.@value;
         _loc4_.COMMUNITY_FRIEND_PATH = param1.COMMUNITY_FRIEND_PATH.@value;
         if(Boolean(param1.COMMUNITY_MICROBLOG.hasOwnProperty("@value")))
         {
            _loc4_.COMMUNITY_MICROBLOG = StringUtils.converBoolean(param1.COMMUNITY_MICROBLOG.@value);
         }
         if(Boolean(param1.LIKEPERSON_SELECTED.hasOwnProperty("@value")))
         {
            _loc4_.LIKEPERSON_SELECTED = StringUtils.converBoolean(param1.LIKEPERSON_SELECTED.@value);
         }
         if(Boolean(param1.COMMUNITY_SINA_SECOND_MICROBLOG.hasOwnProperty("@value")))
         {
            _loc4_.COMMUNITY_SINA_SECOND_MICROBLOG = StringUtils.converBoolean(param1.COMMUNITY_SINA_SECOND_MICROBLOG.@value);
         }
         if(Boolean(param1.COMMUNITY_FRIEND_PATH.hasOwnProperty("@isUser")))
         {
            PathInfo.isUserAddFriend = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_PATH.@isUser);
         }
         _loc4_.STYLE_PATH = param1.STYLE_PATH.@value;
         _loc4_.FIRSTPAGE = param1.FIRSTPAGE.@value;
         _loc4_.REGISTER = param1.REGISTER.@value;
         _loc4_.REQUEST_PATH = param1.REQUEST_PATH.@value;
         _loc4_.FILL_PATH = String(param1.FILL_PATH.@value).replace("{user}",param3);
         _loc4_.FILL_PATH = _loc4_.FILL_PATH.replace("{site}",_loc4_.SITEII);
         _loc4_.FILL_PATH_FBAPP = param1.FILL_PATH_FBAPP.@value;
         _loc4_.LOGIN_PATH = String(param1.LOGIN_PATH.@value).replace("{user}",param3);
         _loc4_.LOGIN_PATH = _loc4_.LOGIN_PATH.replace("{site}",_loc4_.SITEII);
         _loc4_.OFFICIAL_SITE = param1.OFFICIAL_SITE.@value;
         _loc4_.GAME_FORUM = param1.GAME_FORUM.@value;
         _loc4_.DISABLE_TASK_ID = param1.DISABLE_TASK_ID.@value;
         _loc4_.LITTLEGAMEMINLV = param1.LITTLEGAMEMINLV.@value;
         if(Boolean(param1.LOGIN_PATH.hasOwnProperty("@siteName")))
         {
            StatisticManager.siteName = param1.LOGIN_PATH.@siteName;
         }
         _loc4_.TRAINER_STANDALONE = String(param1.TRAINER_STANDALONE.@value) == "false" ? false : true;
         _loc4_.TRAINER_PATH = param1.TRAINER_PATH.@value;
         _loc4_.COUNT_PATH = param1.COUNT_PATH.@value;
         _loc4_.PARTER_ID = param1.PARTER_ID.@value;
         _loc4_.CLIENT_DOWNLOAD = param1.CLIENT_DOWNLOAD.@value;
         if(Boolean(param1.STATISTIC.hasOwnProperty("@value")))
         {
         }
         var _loc5_:int = int(param1.SUCIDE_TIME.@value);
         if(_loc5_ > 0)
         {
            PathInfo.SUCIDE_TIME = _loc5_ * 1000;
         }
         var _loc6_:int = int(param1.BOX_STYLE.@value);
         if(_loc6_ != 0)
         {
         }
         _loc4_.PHP_PATH = param1.PHP.@site;
         if(Boolean(param1.PHP.hasOwnProperty("@link")))
         {
            _loc4_.PHP_IMAGE_LINK = StringUtils.converBoolean(param1.PHP.@link);
         }
         _loc4_.WEB_PLAYER_INFO_PATH = param1.PHP.@infoPath;
         if(Boolean(param1.PHP.hasOwnProperty("@isShow")))
         {
            PlayerManager.isShowPHP = StringUtils.converBoolean(param1.PHP.@isShow);
         }
         if(Boolean(param1.PHP.hasOwnProperty("@link")))
         {
            _loc4_.PHP_IMAGE_LINK = StringUtils.converBoolean(param1.PHP.@link);
         }
         PathInfo.MUSIC_LIST = String(param1.MUSIC_LIST.@value).split(",");
         PathInfo.LANGUAGE = String(param1.LANGUAGE.@value);
         var _loc7_:XMLList = param1.POLICY_FILES.file;
         for each(_loc8_ in _loc7_)
         {
            Security.loadPolicyFile(_loc8_.@value);
         }
         if(Boolean(param1.GAME_BOXPIC.hasOwnProperty("@value")))
         {
            PathInfo.GAME_BOXPIC = param1.GAME_BOXPIC.@value;
         }
         if(Boolean(param1.ISTOPDERIICT.hasOwnProperty("@value")))
         {
            PathInfo.ISTOPDERIICT = StringUtils.converBoolean(param1.ISTOPDERIICT.@value);
         }
         _loc4_.COMMUNITY_INVITE_PATH = param1.COMMUNITY_INVITE_PATH.@value;
         _loc4_.COMMUNITY_FRIEND_LIST_PATH = param1.COMMUNITY_FRIEND_LIST_PATH.@value;
         _loc4_.SNS_PATH = param1.COMMUNITY_FRIEND_LIST_PATH.@snsPath;
         _loc4_.MICROCOBOL_PATH = param1.COMMUNITY_FRIEND_LIST_PATH.@microcobolPath;
         if(Boolean(param1.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexist")))
         {
            _loc4_.COMMUNITY_EXIST = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_LIST_PATH.@isexist);
         }
         if(Boolean(param1.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@value")))
         {
            _loc4_.COMMUNITY_FRIEND_INVITED_SWITCH = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_INVITED_SWITCH.@value);
         }
         if(Boolean(param1.COMMUNITY_FRIEND_INVITED_SWITCH.hasOwnProperty("@invitedOnline")))
         {
            _loc4_.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_INVITED_SWITCH.@invitedOnline);
         }
         if(Boolean(param1.COMMUNITY_FRIEND_LIST_PATH.hasOwnProperty("@isexistBtnVisble")))
         {
            _loc4_.IS_VISIBLE_EXISTBTN = StringUtils.converBoolean(param1.COMMUNITY_FRIEND_LIST_PATH.@isexistBtnVisble);
         }
         _loc4_.ALLOW_POPUP_FAVORITE = String(param1.ALLOW_POPUP_FAVORITE.@value) == "true" ? true : false;
         if(Boolean(param1.FILL_JS_COMMAND.hasOwnProperty("@enable")))
         {
            _loc4_.FILL_JS_COMMAND_ENABLE = StringUtils.converBoolean(param1.FILL_JS_COMMAND.@enable);
         }
         if(Boolean(param1.FILL_JS_COMMAND.hasOwnProperty("@value")))
         {
            _loc4_.FILL_JS_COMMAND_VALUE = param1.FILL_JS_COMMAND.@value;
         }
         if(Boolean(param1.MINLEVELDUPLICATE.hasOwnProperty("@value")))
         {
            GameManager.MinLevelDuplicate = param1.MINLEVELDUPLICATE.@value;
         }
         _loc4_.FIGHTLIB_ENABLE = StringUtils.converBoolean(param1.FIGHTLIB.@value);
         if(Boolean(param1.FEEDBACK))
         {
            if(Boolean(param1.FEEDBACK.hasOwnProperty("@enable")))
            {
               _loc4_.FEEDBACK_ENABLE = String(param1.FEEDBACK.@enable) == "true" ? true : false;
               _loc4_.FEEDBACK_TEL_NUMBER = param1.FEEDBACK.@telNumber;
            }
         }
         if(param1.MODULE != null && param1.MODULE.SPA != null && Boolean(param1.MODULE.SPA.hasOwnProperty("@enable")))
         {
            _loc4_.SPA_ENABLE = param1.MODULE.SPA.@enable != "false";
         }
         if(param1.MODULE != null && param1.MODULE.CIVIL != null && Boolean(param1.MODULE.CIVIL.hasOwnProperty("@enable")))
         {
            _loc4_.CIVIL_ENABLE = param1.MODULE.CIVIL.@enable != "false";
         }
         if(param1.MODULE != null && param1.MODULE.CHURCH != null && Boolean(param1.MODULE.CHURCH.hasOwnProperty("@enable")))
         {
            _loc4_.CHURCH_ENABLE = param1.MODULE.CHURCH.@enable != "false";
         }
         if(param1.MODULE != null && param1.MODULE.WEEKLY != null && Boolean(param1.MODULE.WEEKLY.hasOwnProperty("@enable")))
         {
            _loc4_.WEEKLY_ENABLE = param1.MODULE.WEEKLY.@enable != "false";
         }
         if(Boolean(param1.FORTH_ENABLE.hasOwnProperty("@value")))
         {
            _loc4_.FORTH_ENABLE = param1.FORTH_ENABLE.@value != "false";
         }
         if(Boolean(param1.QUEST_TRUSTEESHIP.hasOwnProperty("@enable")))
         {
            _loc4_.QUEST_TRUSTEESHIP_ENABLE = param1.QUEST_TRUSTEESHIP.@enable != "false";
         }
         if(Boolean(param1.TRUSTEESHIP.hasOwnProperty("@enable")))
         {
            _loc4_.Trusteeship_ENABLE = param1.TRUSTEESHIP.@enable != "false";
         }
         if(Boolean(param1.STHRENTH_MAX.hasOwnProperty("@value")))
         {
            _loc4_.STHRENTH_MAX = int(param1.STHRENTH_MAX.@value);
         }
         if(Boolean(param1.USER_GUILD_ENABLE.hasOwnProperty("@value")))
         {
            _loc4_.USER_GUILD_ENABLE = StringUtils.converBoolean(param1.USER_GUILD_ENABLE.@value);
         }
         if(Boolean(param1.ACHIEVE_ENABLE.hasOwnProperty("@value")))
         {
            _loc4_.ACHIEVE_ENABLE = param1.ACHIEVE_ENABLE.@value != "false";
         }
         if(param1.CHAT_FACE != null && param1.CHAT_FACE.DISABLED_LIST != null && Boolean(param1.CHAT_FACE.DISABLED_LIST.hasOwnProperty("@list")))
         {
            _loc4_.CHAT_FACE_DISABLED_LIST = String(param1.CHAT_FACE.DISABLED_LIST.@list).split(",");
         }
         if(Boolean(param1.STATISTICS.hasOwnProperty("@enable")))
         {
            _loc4_.STATISTICS = param1.STATISTICS.@enable != "false";
         }
         if(Boolean(param1.USER_GUIDE.hasOwnProperty("@value")) || true)
         {
         }
         if(param1.GAME_FRAME_CONFIG != null && param1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG != null && Boolean(param1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.hasOwnProperty("@value")))
         {
            _loc4_.FRAME_TIME_OVER_TAG = int(param1.GAME_FRAME_CONFIG.FRAME_TIME_OVER_TAG.@value);
         }
         if(param1.GAME_FRAME_CONFIG != null && param1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG != null && Boolean(param1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.hasOwnProperty("@value")))
         {
            _loc4_.FRAME_OVER_COUNT_TAG = int(param1.GAME_FRAME_CONFIG.FRAME_OVER_COUNT_TAG.@value);
         }
         if(param1.EXTERNAL_INTERFACE_360 != null && Boolean(param1.EXTERNAL_INTERFACE_360.hasOwnProperty("@value")))
         {
            _loc4_.EXTERNAL_INTERFACE_PATH_360 = String(param1.EXTERNAL_INTERFACE_360.@value);
         }
         if(param1.EXTERNAL_INTERFACE_360 != null && Boolean(param1.EXTERNAL_INTERFACE_360.hasOwnProperty("@enable")))
         {
            _loc4_.EXTERNAL_INTERFACE_ENABLE_360 = param1.EXTERNAL_INTERFACE_360.@enable != "false";
         }
         if(param1.GRADE_NOTIFICATION != null && param1.GRADE_NOTIFICATION.NOTIFICATION != null)
         {
            _loc9_ = param1.GRADE_NOTIFICATION.NOTIFICATION;
            for each(_loc10_ in _loc9_)
            {
               if(!(!_loc10_.hasOwnProperty("@grade") || !_loc10_.hasOwnProperty("@site")))
               {
                  _loc11_ = _loc10_.@grade;
                  _loc12_ = _loc10_.@site;
                  if(!(_loc11_ == "" || _loc12_ == ""))
                  {
                     _loc4_.GRADE_NOTIFICATION[_loc11_] = _loc12_;
                  }
               }
            }
         }
         if(param1.CALL_PATH != null && Boolean(param1.CALL_PATH.hasOwnProperty("@value")))
         {
            _loc4_.CALL_LOGIN_INTERFAECE = param1.CALL_PATH.@value;
         }
         if(param1.USER_ACTION_NOTICE != null && Boolean(param1.USER_ACTION_NOTICE.hasOwnProperty("@value")))
         {
            _loc4_.USER_ACTION_NOTICE = param1.USER_ACTION_NOTICE.@value;
         }
         if(Boolean(param1.RANDOM_CHANNEL) && Boolean(param1.RANDOM_CHANNEL.hasOwnProperty("@value")))
         {
            _loc4_.RANDOM_CHANNEL = param1.RANDOM_CHANNEL.@value != "false";
         }
         if(Boolean(param1.CROSSBUGGLE.hasOwnProperty("@enable")))
         {
            _loc4_.CROSSBUGGLE = param1.CROSSBUGGLE.@enable != "false";
         }
         if(Boolean(param1.LOTTERY.hasOwnProperty("@enable")))
         {
            _loc4_.LOTTERY_ENABLE = param1.LOTTERY.@enable != "false";
         }
         if(Boolean(param1.OVERSEAS))
         {
            _loc4_.OVERSEAS_COMMUNITY_TYPE = int(param1.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@value);
            _loc4_.OVERSEAS_COMMUNITY_PATH = param1.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@callPath;
            _loc4_.OVERSEAS_COMMUNITY_CALLJS = param1.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@callJS;
            _loc4_.COMMUNITY_EXIST = Boolean(_loc4_.OVERSEAS_COMMUNITY_TYPE);
            _loc4_.IS_VISIBLE_SHAREBTN = StringUtils.converBoolean(param1.OVERSEAS.OVERSEAS_COMMUNITY_TYPE.@shareBtnVisble);
         }
         if(Boolean(param1.HOTSPRING_CONTINUE.hasOwnProperty("@value")))
         {
            _loc4_.HOTSPRING_CONTINUE = param1.HOTSPRING_CONTINUE.@value != "false";
         }
         if(StringUtils.trim(param1.DUNGEON_OPENLIST.@value) != "")
         {
            _loc4_.DUNGEON_OPENLIST = StringUtils.trim(param1.DUNGEON_OPENLIST.@value).split(",");
         }
         if(Boolean(param1.SUIT.hasOwnProperty("@enable")))
         {
            _loc4_.SUIT_ENABLE = param1.SUIT.@enable != "false";
         }
         if(StringUtils.trim(param1.DUNGEON_OPENLIST.@advancedEnable) != "")
         {
            _loc4_.ADVANCED_ENABLE = param1.DUNGEON_OPENLIST.@advancedEnable != "false";
         }
         if(StringUtils.trim(param1.DUNGEON_OPENLIST.@epicLevelEnable) != "")
         {
            _loc4_.EPICLEVEL_ENABLE = param1.DUNGEON_OPENLIST.@epicLevelEnable != "false";
         }
         if(param1.LOCK_SETTING != null && Boolean(param1.LOCK_SETTING.hasOwnProperty("@value")))
         {
            BagLockedController.LOCK_SETTING = param1.LOCK_SETTING.@value;
         }
         if(param1.GAME_CAN_NOT_EXIT_SEND_LOG != null && Boolean(param1.GAME_CAN_NOT_EXIT_SEND_LOG.hasOwnProperty("@value")))
         {
            GameManager.GAME_CAN_NOT_EXIT_SEND_LOG = param1.GAME_CAN_NOT_EXIT_SEND_LOG.@value;
         }
         if(Boolean(param1.EXALTBTN.hasOwnProperty("@enable")))
         {
            _loc4_.EXALT_ENABLE = param1.EXALTBTN.@enable != "false";
         }
         if(Boolean(param1.PK_BTN.hasOwnProperty("@enable")))
         {
            _loc4_.PK_BTN = param1.PK_BTN.@enable == "true";
         }
         if(Boolean(param1.SUIT.hasOwnProperty("@enable")))
         {
            _loc4_.SUIT_ENABLE = param1.SUIT.@enable != "false";
         }
         if(Boolean(param1.KINGBLESS.hasOwnProperty("@enable")))
         {
            _loc4_.KINGBLESS_ENABLE = param1.KINGBLESS.@enable != "false";
         }
         if(Boolean(param1.WARRIORS_FAM.hasOwnProperty("@enable")))
         {
            _loc4_.WARRIORS_FAM_ENABLE = param1.WARRIORS_FAM.@enable != "false";
         }
         if(Boolean(param1.GEMSTONE.hasOwnProperty("@enable")))
         {
            _loc4_.GEMSTONE_ENABLE = param1.GEMSTONE.@enable != "false";
         }
         if(Boolean(param1.ONEKEYDONE.hasOwnProperty("@enable")))
         {
            _loc4_.ONEKEY_DONE = param1.ONEKEYDONE.@enable != "false";
         }
         if(Boolean(param1.CROSS_CHAT_SERVER.hasOwnProperty("@enable")))
         {
            _loc4_.CROSS_CHAT_SERVER = param1.CROSS_CHAT_SERVER.@enable != "false";
         }
         if(Boolean(param1.TREASURE.hasOwnProperty("@enable")))
         {
            _loc4_.TREASURE = param1.TREASURE.@enable != "false";
            _loc4_.TREASUREHELPTIMES = int(param1.TREASURE.@times);
         }
         else
         {
            _loc4_.TREASURE = true;
            _loc4_.TREASUREHELPTIMES = 5;
         }
         if(Boolean(param1.CROSS_CHAT_SERVER.hasOwnProperty("@enable")))
         {
            _loc4_.CROSS_CHAT_SERVER = param1.CROSS_CHAT_SERVER.@enable != "false";
         }
         if(Boolean(param1.CHECKDESK_KILL.hasOwnProperty("@enable")))
         {
            _loc4_.CHECKDESK_KILL = param1.CHECKDESK_KILL.@enable != "false";
         }
         if(Boolean(param1.HIT_SHELL.hasOwnProperty("@pointEnable")))
         {
            _loc4_.POINT_ENABLE = param1.HIT_SHELL.@pointEnable != "false";
         }
         if(Boolean(param1.HIT_SHELL.hasOwnProperty("@progressEnable")))
         {
            _loc4_.PROGRESS_ENABLE = param1.HIT_SHELL.@progressEnable != "false";
         }
         if(Boolean(param1.HIT_SHELL.hasOwnProperty("@dotteLineEnable")))
         {
            _loc4_.DOTTELINE_ENABLE = param1.HIT_SHELL.@dotteLineEnable != "false";
         }
         if(Boolean(param1.SMALLMAP.hasOwnProperty("@enable")))
         {
            _loc4_.SMALLMAP_ENABLE = param1.SMALLMAP.@enable != "false";
         }
         if(Boolean(param1.SMALLMAP.hasOwnProperty("@meterEnable")))
         {
            _loc4_.SMALLMAP_METERENABLE = param1.SMALLMAP.@meterEnable != "false";
         }
         if(Boolean(param1.SMALLMAP.hasOwnProperty("@borderEnable")))
         {
            _loc4_.SMALLMAP_BORDERENABLE = param1.SMALLMAP.@borderEnable != "false";
         }
         if(Boolean(param1.SMALLMAP.hasOwnProperty("@alphaEnable")))
         {
            _loc4_.SMALLMAP_BORDERALPHA = param1.SMALLMAP.@alphaEnable != "false";
         }
         if(Boolean(param1.DAILY.hasOwnProperty("@enable")))
         {
            _loc4_.DAILY_ENABLE = param1.DAILY.@enable != "false";
         }
         if(param1.CALLBACK_INTERFACE != null && Boolean(param1.CALLBACK_INTERFACE.hasOwnProperty("@path")))
         {
            _loc4_.CALLBACK_INTERFACE_PATH = param1.CALLBACK_INTERFACE.@path;
         }
         if(param1.CALLBACK_INTERFACE != null && Boolean(param1.CALLBACK_INTERFACE.hasOwnProperty("@enable")))
         {
            _loc4_.CALLBACK_INTERFACE_ENABLE = param1.CALLBACK_INTERFACE.@enable;
         }
         if(Boolean(param1.GODSYAH.hasOwnProperty("@enable")))
         {
            _loc4_.GODSYAH_ENABLE = param1.GODSYAH.@enable == "true";
         }
         if(Boolean(param1.BUYPETEXP.hasOwnProperty("@enable")))
         {
            _loc4_.BUYPETEXP_ENABLE = param1.BUYPETEXP.@enable != "false";
         }
         if(Boolean(param1.FBSavePage.hasOwnProperty("@enable")))
         {
            _loc4_.SAVE_PAGE_ENABLE = param1.FBSavePage.@enable != "false";
         }
         if(Boolean(param1.FBSavePage.hasOwnProperty("@path")))
         {
            _loc4_.SAVE_PAGE_LINK = param1.FBSavePage.@path;
         }
         if(Boolean(param1.FACEBOOK.hasOwnProperty("@enable")))
         {
            _loc4_.FACEBOOK_ENABLE = param1.FACEBOOK.@enable != "false";
            _loc4_.FACEBOOK_FEEDJS_FUNCTION = param1.FACEBOOK.@feedJS;
            _loc4_.FACEBOOK_INVITE_FRIENDS = param1.FACEBOOK.@showFriendsJS;
            _loc4_.FACEBOOK_FEED_TITLE_LINK = param1.FACEBOOK.@feed_title_link;
         }
         if(Boolean(param1.TURKEY_337_VIPPAGE.hasOwnProperty("@enable")))
         {
            _loc4_.TURKEY_337_VIPPAGE_ENABLE = param1.TURKEY_337_VIPPAGE.@enable != "false";
            _loc4_.TURKEY_337_VIPPAGE_LINK = param1.TURKEY_337_VIPPAGE.@value;
            _loc4_.TURKEY_337_VIPPAGE_JS = param1.TURKEY_337_VIPPAGE.@call_gdp_JSfunction;
         }
         if(StringUtils.trim(param1.DUNGEON_OPENLIST.@footballEnable) != "")
         {
            _loc4_.FOOTBALL_ENABLE = param1.DUNGEON_OPENLIST.@footballEnable != "false";
         }
         if(param1.IS_SEND_RECORDUSERVERSION != null && Boolean(param1.IS_SEND_RECORDUSERVERSION.hasOwnProperty("@value")))
         {
            _loc4_.IS_SEND_RECORDUSERVERSION = param1.IS_SEND_RECORDUSERVERSION.@value == "true";
         }
         if(param1.IS_SEND_FLASHINFO != null && Boolean(param1.IS_SEND_FLASHINFO.hasOwnProperty("@value")))
         {
            _loc4_.IS_SEND_FLASHINFO = param1.IS_SEND_FLASHINFO.@value == "true";
         }
         if(param1.FLASH_P2P != null)
         {
            if(Boolean(param1.FLASH_P2P.hasOwnProperty("@ebable")))
            {
               _loc4_.FLASH_P2P_EBABLE = param1.FLASH_P2P.@ebable == "true";
            }
            if(Boolean(param1.FLASH_P2P.hasOwnProperty("@key")))
            {
               _loc4_.FLASH_P2P_KEY = param1.FLASH_P2P.@key;
            }
            if(Boolean(param1.FLASH_P2P.hasOwnProperty("@url")))
            {
               _loc4_.FLASH_P2P_CIRRUS_URL = param1.FLASH_P2P.@url;
            }
         }
         if(Boolean(param1.SMALLMAP.hasOwnProperty("@borderEnable")))
         {
            _loc4_.SMALLMAP_BORDERENABLE = param1.SMALLMAP.@borderEnable != "false";
         }
         if(param1.GAME_STATS != null && Boolean(param1.GAME_STATS.hasOwnProperty("@enable")))
         {
            _loc4_.GAME_STATS_ENABLE = param1.GAME_STATS.@enable == "true";
         }
         PathManager.setup(_loc4_);
      }
   }
}

