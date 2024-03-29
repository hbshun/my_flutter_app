import 'package:hgbh_app/common/dao/user_dao.dart';
import 'package:hgbh_app/common/model/User.dart';
import 'package:hgbh_app/common/redux/state.dart';
import 'package:hgbh_app/common/redux/middleware/epic.dart';
import 'package:hgbh_app/common/redux/middleware/epic_store.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';


/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final UserReducer = combineReducers<User>([
  TypedReducer<User, UpdateUserAction>(_updateLoaded),
]);

/// 如果有 UpdateUserAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的userInfo，并返回
User _updateLoaded(User user, action) {
  user = action.userInfo;
  return user;
}

///定一个 UpdateUserAction ，用于发起 userInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateUserAction {
  final User userInfo;

  UpdateUserAction(this.userInfo);
}

class FetchUserAction {
}


class UserInfoMiddleware implements MiddlewareClass<HGState> {

  @override
  void call(Store<HGState> store, dynamic action, NextDispatcher next) {
    if (action is UpdateUserAction) {
      print("*********** UserInfoMiddleware *********** ");
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

class UserInfoEpic implements EpicClass<HGState> {
  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<HGState> store) {
    return Observable(actions)
        // to UpdateUserAction actions
        .ofType(TypeToken<FetchUserAction>())
        // Don't start  until the 10ms
        .debounce(((_) => TimerStream(true, const Duration(milliseconds: 10))))
        .switchMap((action) => _loadUserInfo());
  }

  // Use the async* function to make easier
  Stream<dynamic> _loadUserInfo() async* {
    print("*********** userInfoEpic _loadUserInfo ***********");
    var res = await UserDao.getUserInfo(null);
    yield UpdateUserAction(res.data);
  }
}