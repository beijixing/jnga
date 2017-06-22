//
//  Constant.h
//  PoliceService
//
//  Created by horse on 2017/3/3.
//  Copyright © 2017年 zgl. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark - Host
//http://124.133.15.93/jngateam/jnga_ios.git gitlab
static NSString * const Host_IP = @"http://124.133.15.90:8780/";
static NSString * const AppURL = @"http://119.188.169.79:8081/jnga/appService/";

//static NSString * const AppURL = @"http://124.133.15.90:8780/jnga/appService/";
static NSString * const AppJNGAURL = @"http://60.211.249.228/api/";
//static NSString * const AppURL = @"http://192.168.106.128:8080/appService/";//老钱


static NSString * const LoginSucessNotificationKey = @"LoginSuccess";

static const NSString *businessId = @"38ed36f8307443fa9765e35f6db0c032";


#pragma mark -接口
/*
 版本检测
 ?appname=&appversion=1.0.0&appostype=android
 */
#define Interface_CheckVersion @"app/sysupdateconfig/appsysupdateConfig/getSysupdateConfig"
/*
    请求参数说明: latitude Long 经度 longitude Long 纬度 pageNo Integer 页号 pageSize Integer每页大小
 */

#define Interface_PoliceMapList @"convenience/policemap/policeMap/wrapList"//警务地图列表


/*
 参数名，类型，说明
 sign
 */
#define Interface_BusicClass @"arch/busiclass"//户政业务大类
/*
 参数名，类型，说明
 id
 sign
 */
#define Interface_SubBusicClass @"arch/business"//户政业务子类

/*
 参数名，类型，说明
 sign
 */
#define Interface_ArchPeriod @"arch/period"//户政时间段

/*
 参数名，类型，说明
 sign
 */
#define Interface_ArchPolice @"arch/police"//户政公安局

/*
 参数名，类型，说明
 id
 sign
 */
#define Interface_ArchStation @"convenience/station"//户政派出所


/*
 参数名，类型，说明
 id String 待查姓名
 */
#define Interface_NameNum @"convenience/namenum"//重名查询

/*
 参数名，类型，说明
 id String 待查汉字
 */
#define Interface_StrangeWord @"convenience/uncommon"//生僻字查询

/*
 参数名，类型，说明pageNo Integer 页号
 pageSize Integer 页大小
 strayMan String 走失人
 sex String 性别
 height int 身高
 characteristic String 特征
 dress String 衣着
 personalEffects String 随身物品
 lostPlace String 走失地点
 */
#define Interface_StrayManList @"convenience/strayman/strayMan/wrapList"//走失人物列表

/*
 参数名，类型，说明
 pageNo Integer 页号
 pageSize Integer 页大小
 loser String 丢失人
 lostItemName String 遗失物品名称
 lostItemAdress String 物品遗失地点
 lostItemDetails String 遗失物品详情
 */
#define Interface_LostItemList @"convenience/lostitem/lostItem/wrapList"//失物查询列表

/*
 参数名，类型，说明
 drivinglicenseNumber 驾驶证号
 drivinglinceseFilenumber 驾驶证档案编号
 imei 国际移动设备识别码（15位数字
 */
#define Interface_CheckDriverLicense @"convenience/drivinglicense/drivinglicenseScore/query"//驾驶证违法查询



#define Interface_QueryAward @"convenience/awardreport/awardReport/query"//有奖举报查询

#define Interface_CashAward @"convenience/awardreport/awardReport/fillAwardInfo"//有奖举报兑奖

/*
 参数名，类型，说明
 fcard 身份证号码
 id 派出所编码
 ftitle 主题
 fdetail 内容
 */
#define Interface_ConsultOnline @"convenience/consult"//在线咨询

#define Interface_ReportCrime @"convenience/awardreport/awardReport/save"//违法犯罪线索有奖举报

#define Interface_QueryBusinessPlace @"convenience/officeaddrestelinquiries/officeaddresTelinquiries/querySubdivisionProject"//办事场所地址电话快捷查询
#define Interface_QueryCityDetail @"convenience/officeaddrestelinquiries/officeaddresTelinquiries/queryCounties"//根据细分项查询县市区列表
#define Interface_HighWayStatus @"convenience/highwaytrafficinfo/highwayTrafficInfo/queryHighwayTrafficInfo"//高速路况查询
#define Interface_NotifiList @"notice/appNotice/noticeList"//通知公告
#define Interface_NotifiDetail @"notice/appNotice/getNotice"//通知公告详情
#define Interface_MyConsult2 @"convenience/myconsult"//我的咨询2-户政业务AppJNGAURL
#define Interface_MyAppointment2 @"appoint/list"//我的预约2-户政业务AppJNGAURL



/*
 参数名，类型，说明
 businessId String 业务id
 */
#define Interface_WrapBookingPageData @"onlinebooking/bookingmanage/onlineBookingRecord/wrapBookingPageData"//预约页面的数据

/*
 depart_id String 部门id
 user_id String 用户id
 business_id String 业务id
 book_depart_time_id String 预约部门时间段id
 book_date String 预约日期
 max_days_advance int
 */
#define Interface_WrapsaveBookingInfo @"onlinebooking/bookingmanage/onlineBookingRecord/wrapsave"//预约申请

/*
 参数名，类型，说明
 id String 预约记录id
 */
#define Interface_CancelBooking @"onlinebooking/bookingmanage/onlineBookingRecord/cancelBooking"//取消预约

/*
 参数名，类型，说明
 pageNo String 页号
 pageSize String 页大小
 userId String 预约记录id
 */
#define Interface_WrapMyBookingList  @"onlinebooking/bookingmanage/onlineBookingRecord/wrapMyBookingList"//我的预约

/*
    无参数
 */
#define Interface_WrapBusinessList @"convenience/association/associationTJn/wrapBusinessList" //我的

/*
    请求参数: phone(手机号)
 */
#define Interface_ValidateCode  @"validate/registe/validateCode/getYzm" //发送手机验证码
/*
    请求参数：phone 作为登录帐号，password 密码，device_id 手机唯一标识，
    ternimal_type 终端类型 Android/ios
 */
#define Interface_PhoneReg  @"jnga/jnuser/jnUser/phoneReg"//手机注册

/*
    请求参数:token
 */
#define Interface_IsPhoneLogin  @"jnga/jnuser/jnUser/IsPhoneLogin"//判断可否自动登录

/*
    请求参数：phone，password
 */
#define Interface_PhoneLogin  @"jnga/jnuser/jnUser/phoneLogin"//登录

/*
    请求参数：newPhone  oldPhone   verify_code验证码
 */
#define Interface_ChangePhone  @"jnga/jnuser/jnUser/ChangePhone"//更改绑定手机号

/*
    请求参数：①未登录修改:phone手机号，verify_code验证码，newPwd新密码
 ②登录后修改:phone手机号，origPwd旧密码， newPwd 新密码
 */
#define Interface_ChangePassword  @"jnga/jnuser/jnUser/ChangePassword"//修改密码


/*-----------------------------------首页接口------*/
/*
    parentid
 */
#define Interface_MenuList  @"convenience/menu/menuTJn/menuList"//菜单管理
/*
    parentid
 */
#define Interface_GuideList  @"convenience/guide/guideTJn/guideList"//业务办理
/*
 name
 */
#define Interface_Search   @"convenience/menu/menuTJn/search"

/*
 参数名，类型，说明
 pageNo Integer 页号
 pageSize Integer 页大小
 */

#define Interface_NoticeList  @"notice/appNotice/noticeList"


#define Interface_GetNotice  @"notice/appNotice/getNotice"


/*-----------------------------------警务资讯---------------------*/

/*
 type(警务资讯分类：1新闻中心，2警情通报，3安全防范)；pageNo(页号)；pageSize（每页显示数）
 */
#define Interface_NewsList  @"police/message/policeMessage/listByType"

#define Interface_GetTopList @"police/message/policeMessage/getTopList"

#define Interface_NewsDetail @"jnga/static/pm_html5/pm_html5.html"

/*-----------------------------------民生诉求--------------------------*/
/*
 民生诉求分类：1-5分别为  我要举报、 建议 、投诉、咨询、 信访
 */
#define Interface_PeopleappealMost  @"peopleappeal/most/peopleappealMost/appSave"
/*
    评警
 */
#define Interface_PeopleappealOne  @"peopleappeal/one/peopleappealOne/appSave"

/*
    type
 */
#define Interface_AppGetDataDict @"app/dict/getDict"

#define Interface_appListByPhoneZt @"peopleappeal/most/peopleappealMost/appListByPhoneZt"
/*-----------------------业务须知----------------------------------*/
#define Interface_BusinessNotesTJn @"convenience/businessnotes/businessNotesTJn/businessList"


/*---------------------------移车服务----------------------------------*/
#define Interface_MoveCar @"move/car/moveCar/getByApi"


#endif /* Constant_h */
