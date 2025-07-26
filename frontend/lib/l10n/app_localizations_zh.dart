// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get enterValue => '请输入一个值';

  @override
  String get enterValidURL => '请输入一个有效的地址';

  @override
  String get go => '继续';

  @override
  String get noBackend => '无法连接到服务器';

  @override
  String get ok => '确定';

  @override
  String get serverURL => '服务器地址';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get login => '登录';

  @override
  String get badCredentials => '错误的凭证';

  @override
  String get loginMessage => '欢迎回来';

  @override
  String get signupMessage => '欢迎加入';

  @override
  String get appName => 'Plant-it 种植物';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get areYouNew => '你是新用户吗';

  @override
  String get createAccount => '创建账户';

  @override
  String get email => '邮箱';

  @override
  String get usernameSize => '用户名长度必须在3到20个字符之间';

  @override
  String get passwordSize => '密码长度必须在6到20个字符之间';

  @override
  String get enterValidEmail => '请输入有效的邮箱';

  @override
  String get alreadyRegistered => '已经注册？';

  @override
  String get signup => '注册';

  @override
  String get generalError => '执行操作时出错';

  @override
  String get error => '错误';

  @override
  String get details => '详情';

  @override
  String get insertBackendURL => '朋友你好！让我们开始实现奇迹吧，请先设置您的服务器地址。';

  @override
  String get loginTagline => '探索、学习和培育！';

  @override
  String get singupTagline => '一起成长吧！';

  @override
  String get sentOTPCode => '请输入通过邮箱发送的验证码：';

  @override
  String get verify => '验证';

  @override
  String get resendCode => '重新发送验证码';

  @override
  String get otpCode => '单次验证码';

  @override
  String get splashLoading => '哔哔哔……正在从服务器加载数据！';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String hello(String userName) {
    return '你好，$userName';
  }

  @override
  String get search => '搜索';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '$countString $_temp0 前';
  }

  @override
  String nDaysInFuture(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '在未来的 $countString $_temp0 (什么?)';
  }

  @override
  String nMonthsAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '月',
      one: '月',
    );
    return '$countString $_temp0 前';
  }

  @override
  String nYearsAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '年',
      one: '年',
    );
    return '$countString $_temp0 前';
  }

  @override
  String get events => '事件';

  @override
  String get plants => '植物';

  @override
  String get or => '或者';

  @override
  String get filter => '筛选';

  @override
  String get seeding => '播种';

  @override
  String get watering => '浇水';

  @override
  String get fertilizing => '施肥';

  @override
  String get biostimulating => '生物刺激';

  @override
  String get misting => '喷雾';

  @override
  String get transplanting => '移栽';

  @override
  String get water_changing => '换水';

  @override
  String get observation => '观察';

  @override
  String get treatment => '治疗';

  @override
  String get propagating => '繁殖';

  @override
  String get pruning => '修剪';

  @override
  String get repotting => '换盆';

  @override
  String get recents => '最近的';

  @override
  String get addNewEvent => '添加新事件';

  @override
  String get selectDate => '选择日期';

  @override
  String get selectEvents => '选择事件';

  @override
  String get selectPlants => '选择植物';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '事件',
      one: '事件',
    );
    return '已创建 $countString 个新 $_temp0';
  }

  @override
  String get addNote => '添加笔记';

  @override
  String get enterNote => '输入笔记';

  @override
  String get selectAtLeastOnePlant => '最少选择一棵植物';

  @override
  String get selectAtLeastOneEvent => '最少选择一个事件';

  @override
  String get eventSuccessfullyUpdated => '事件更新成功';

  @override
  String get editEvent => '编辑事件';

  @override
  String get eventSuccessfullyDeleted => '事件删除成功';

  @override
  String get noInfoAvailable => '无可用信息';

  @override
  String get species => '物种';

  @override
  String get plant => '植物';

  @override
  String get scientificClassification => '科学分类';

  @override
  String get family => '科';

  @override
  String get genus => '属';

  @override
  String get synonyms => '同义词';

  @override
  String get care => '护理';

  @override
  String get light => '光照';

  @override
  String get humidity => '湿度';

  @override
  String get maxTemp => '最大温度';

  @override
  String get minTemp => '最小温度';

  @override
  String get minPh => '最小酸碱度';

  @override
  String get maxPh => '最大酸碱度';

  @override
  String get info => '信息';

  @override
  String get addPhotos => '添加照片';

  @override
  String get addEvents => '添加活动';

  @override
  String get modifyPlant => '修改植物';

  @override
  String get removePlant => '删除植物';

  @override
  String get useBirthday => '使用生日';

  @override
  String get birthday => '生日';

  @override
  String get avatar => '头像';

  @override
  String get note => '笔记';

  @override
  String get stats => '统计数据';

  @override
  String get eventStats => '事件数据';

  @override
  String get age => '年龄';

  @override
  String get newBorn => '新生';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '$countString $_temp0';
  }

  @override
  String nMonths(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '月',
      one: '月',
    );
    return '$countString $_temp0';
  }

  @override
  String nYears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '年',
      one: '年',
    );
    return '$countString $_temp0';
  }

  @override
  String nMonthsAndDays(num months, num days) {
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '月',
      one: '月',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '$monthsString $_temp0, $daysString $_temp1';
  }

  @override
  String nYearsAndDays(num years, num days) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '年',
      one: '年',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '$yearsString $_temp0, $daysString $_temp1';
  }

  @override
  String nYearsAndMonths(num years, num months) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '年',
      one: '年',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '月',
      one: '月',
    );
    return '$yearsString $_temp0, $monthsString $_temp1';
  }

  @override
  String nYearsAndMonthsAndDays(num years, num months, num days) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '年',
      one: '年',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '月',
      one: '月',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '日',
      one: '日',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => '名称';

  @override
  String nOutOf(num value, num max) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String valueString = valueNumberFormat.format(value);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return '$valueString 个中的 $maxString 个';
  }

  @override
  String temp(num value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString °C';
  }

  @override
  String get numberOfPhotos => '照片数量';

  @override
  String get numberOfEvents => '事件数量';

  @override
  String get searchInYourPlants => '搜索您的植物';

  @override
  String get searchNewGreenFriends => '搜索新的绿色朋友';

  @override
  String get custom => '自定义';

  @override
  String get addPlant => '添加植物';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get pleaseConfirm => '请确认';

  @override
  String get areYouSureToRemoveEvent => '确定要删除此事件吗？';

  @override
  String get areYouSureToRemoveReminder => '确定要移除提醒吗？';

  @override
  String get areYouSureToRemoveSpecies => '确定要移除物种吗？';

  @override
  String get areYouSureToRemovePlant => '确定要移除植物吗？';

  @override
  String get purchasedPrice => '购买价格';

  @override
  String get seller => '卖家';

  @override
  String get location => '位置';

  @override
  String get currency => '货币';

  @override
  String get plantUpdatedSuccessfully => '植物更新成功';

  @override
  String get plantCreatedSuccessfully => '植物创建成功';

  @override
  String get insertPrice => '输入价格';

  @override
  String get noBirthday => '无生日';

  @override
  String get appVersion => '应用版本';

  @override
  String get serverVersion => '服务器版本';

  @override
  String get documentation => '文档';

  @override
  String get openSource => '开源';

  @override
  String get reportIssue => '报告问题';

  @override
  String get logout => '退出登录';

  @override
  String get eventCount => '事件数量';

  @override
  String get plantCount => '植物数量';

  @override
  String get speciesCount => '物种数量';

  @override
  String get imageCount => '图片数量';

  @override
  String get unknown => '未知';

  @override
  String get account => '账户';

  @override
  String get changePassword => '更改密码';

  @override
  String get more => '更多';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get currentPassword => '当前密码';

  @override
  String get updatePassword => '更新密码';

  @override
  String get updateProfile => '更新个人资料';

  @override
  String get newPassword => '新密码';

  @override
  String get removeEvent => '移除事件';

  @override
  String get appLog => '应用日志';

  @override
  String get passwordUpdated => '密码更新成功';

  @override
  String get userUpdated => '用户更新成功';

  @override
  String get noChangesDetected => '未检测到更新';

  @override
  String get plantDeletedSuccessfully => '成功删除植物';

  @override
  String get server => '服务器';

  @override
  String get notifications => '提醒';

  @override
  String get changeServer => '更改服务器';

  @override
  String get serverUpdated => '服务器成功更新';

  @override
  String get changeNotifications => '更改提醒';

  @override
  String get updateNotifications => '更新提醒';

  @override
  String get notificationUpdated => '提醒成功更新';

  @override
  String get supportTheProject => '捐赠支持该项目';

  @override
  String get buyMeACoffee => '请我喝杯奶茶!';

  @override
  String get gallery => '图库';

  @override
  String photosOf(String name) {
    return '照片 $name';
  }

  @override
  String nPhoto(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '照片',
      one: '照片',
    );
    return '已上传 $countString 张新$_temp0';
  }

  @override
  String get errorCreatingPlant => '创建植物时出错';

  @override
  String get noImages => '没有图片';

  @override
  String get errorCreatingSpecies => '创建物种时出错';

  @override
  String get errorUpdatingSpecies => '更新物种时出错';

  @override
  String get speciesUpdatedSuccessfully => '物种更新成功';

  @override
  String get addCustom => '添加自定义';

  @override
  String get speciesCreatedSuccessfully => '物种创建成功';

  @override
  String get uploadPhoto => '上传照片';

  @override
  String get linkURL => '链接地址';

  @override
  String get url => '地址';

  @override
  String get submit => '确认';

  @override
  String get cancel => '取消';

  @override
  String get actions => '操作';

  @override
  String get areYouSureToRemovePhoto => '确定要删除照片吗？';

  @override
  String get photoSuccessfullyDeleted => '照片删除成功';

  @override
  String get errorUpdatingPlant => '更新植物时出错';

  @override
  String get reminders => '提醒';

  @override
  String get selectStartDate => '选择开始日期';

  @override
  String get selectEndDate => '选择结束日期';

  @override
  String get addNewReminder => '添加新提醒';

  @override
  String get noEndDate => '没有结束日期';

  @override
  String get frequency => '频率';

  @override
  String get repeatAfter => '重复间隔';

  @override
  String get addNew => '添加新项';

  @override
  String get reminderCreatedSuccessfully => '提醒创建成功';

  @override
  String get startAndEndDateOrderError => '开始日期必须在结束日期之前';

  @override
  String get reminderUpdatedSuccessfully => '提醒更新成功';

  @override
  String get reminderDeletedSuccessfully => '提醒删除成功';

  @override
  String get errorResettingPassword => '重置密码时出错';

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetPasswordHeader => '在下方输入用户名以发送重置密码请求';

  @override
  String get editReminder => '编辑提醒';

  @override
  String get ntfyServerUrl => 'Ntfy服务器地址';

  @override
  String get ntfyServerTopic => 'Ntfy服务器主题';

  @override
  String get ntfyServerUsername => 'Ntfy服务器用户名';

  @override
  String get ntfyServerPassword => 'Ntfy服务器密码';

  @override
  String get ntfyServerToken => 'Ntfy服务器令牌';

  @override
  String get enterValidTopic => '请输入有效的主题';

  @override
  String get ntfySettings => 'Ntfy设置';

  @override
  String get ntfySettingsUpdated => 'Ntfy设置已成功更新';

  @override
  String get modifySpecies => '修改物种';

  @override
  String get removeSpecies => '删除物种';

  @override
  String get speciesDeletedSuccessfully => '物种删除成功';

  @override
  String get success => '成功';

  @override
  String get warning => '警告';

  @override
  String get ops => '哎呀!';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get gotifyServerUrl => 'Gotify服务器地址';

  @override
  String get gotifyServerToken => 'Gotify服务器令牌';

  @override
  String get gotifySettings => 'Gotify设置';

  @override
  String get gotifySettingsUpdated => 'Gotify设置已成功更新';

  @override
  String get activity => '动态';

  @override
  String get fromDate => '从';

  @override
  String frequencyEvery(num amount, String unit) {
    return '每 $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '周',
      one: '周',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '月',
      one: '月',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '年',
      one: '年',
    );
    return '$_temp0';
  }
}
