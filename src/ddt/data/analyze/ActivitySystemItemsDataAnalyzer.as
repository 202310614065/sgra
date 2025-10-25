package ddt.data.analyze
{
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import growthPackage.data.GrowthPackageInfo;
   import guildMemberWeek.data.GuildMemberWeekItemsInfo;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import kingDivision.data.KingDivisionGoodsInfo;
   import pyramid.data.PyramidSystemItemsInfo;
   import witchBlessing.data.WitchBlessingPackageInfo;
   
   public class ActivitySystemItemsDataAnalyzer extends DataAnalyzer
   {
      
      public var pyramidSystemDataList:Array;
      
      public var guildMemberWeekDataList:Array;
      
      public var growthPackageDataList:Array;
      
      public var kingDivisionDataList:Array;
      
      public var chickActivationDataList:Array;
      
      public var witchBlessingDataList:Array;
      
      public function ActivitySystemItemsDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:PyramidSystemItemsInfo = null;
         var _loc6_:Array = null;
         var _loc7_:GuildMemberWeekItemsInfo = null;
         var _loc8_:Array = null;
         var _loc9_:GrowthPackageInfo = null;
         var _loc10_:Vector.<GrowthPackageInfo> = null;
         var _loc11_:KingDivisionGoodsInfo = null;
         var _loc12_:Array = null;
         var _loc13_:ChickActivationInfo = null;
         var _loc14_:Array = null;
         var _loc15_:WitchBlessingPackageInfo = null;
         var _loc16_:Array = null;
         this.pyramidSystemDataList = [];
         this.guildMemberWeekDataList = [];
         this.growthPackageDataList = [];
         this.kingDivisionDataList = [];
         this.chickActivationDataList = [];
         this.witchBlessingDataList = [];
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               if(_loc3_[_loc4_].@ActivityType == "8")
               {
                  _loc5_ = new PyramidSystemItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
                  _loc6_ = this.pyramidSystemDataList[_loc5_.Quality - 1];
                  if(!_loc6_)
                  {
                     _loc6_ = [];
                  }
                  _loc6_.push(_loc5_);
                  this.pyramidSystemDataList[_loc5_.Quality - 1] = _loc6_;
               }
               else if(_loc3_[_loc4_].@ActivityType == String(GuildMemberWeekManager.instance.getGiftType))
               {
                  _loc7_ = new GuildMemberWeekItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc7_,_loc3_[_loc4_]);
                  _loc8_ = this.guildMemberWeekDataList[_loc7_.Quality - 1];
                  if(!_loc8_)
                  {
                     _loc8_ = [];
                  }
                  _loc8_.push(_loc7_);
                  this.guildMemberWeekDataList[_loc7_.Quality - 1] = _loc8_;
               }
               else if(_loc3_[_loc4_].@ActivityType == "20")
               {
                  _loc9_ = new GrowthPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc9_,_loc3_[_loc4_]);
                  _loc10_ = this.growthPackageDataList[_loc9_.Quality];
                  if(!_loc10_)
                  {
                     _loc10_ = new Vector.<GrowthPackageInfo>();
                  }
                  _loc10_.push(_loc9_);
                  this.growthPackageDataList[_loc9_.Quality] = _loc10_;
               }
               else if(_loc3_[_loc4_].@ActivityType == "30")
               {
                  _loc11_ = new KingDivisionGoodsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc11_,_loc3_[_loc4_]);
                  _loc12_ = this.kingDivisionDataList[_loc11_.Quality - 1];
                  if(!_loc12_)
                  {
                     _loc12_ = [];
                  }
                  _loc12_.push(_loc11_);
                  this.kingDivisionDataList[_loc11_.Quality - 1] = _loc12_;
               }
               else if(_loc3_[_loc4_].@ActivityType == "40")
               {
                  _loc13_ = new ChickActivationInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc13_,_loc3_[_loc4_]);
                  if(_loc13_.Quality >= 10001 && _loc13_.Quality <= 10010)
                  {
                     _loc14_ = this.chickActivationDataList[12];
                     if(!_loc14_)
                     {
                        _loc14_ = new Array();
                     }
                     _loc14_.push(_loc13_);
                     _loc14_.sortOn("Quality",Array.NUMERIC);
                     this.chickActivationDataList[12] = _loc14_;
                  }
                  else
                  {
                     _loc14_ = this.chickActivationDataList[_loc13_.Quality];
                     if(!_loc14_)
                     {
                        _loc14_ = new Array();
                     }
                     _loc14_.push(_loc13_);
                     this.chickActivationDataList[_loc13_.Quality] = _loc14_;
                  }
               }
               else if(_loc3_[_loc4_].@ActivityType == "49")
               {
                  _loc15_ = new WitchBlessingPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc15_,_loc3_[_loc4_]);
                  if(!_loc16_)
                  {
                     _loc16_ = new Array();
                  }
                  _loc16_.push(_loc15_);
                  this.witchBlessingDataList = _loc16_;
               }
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
   }
}

