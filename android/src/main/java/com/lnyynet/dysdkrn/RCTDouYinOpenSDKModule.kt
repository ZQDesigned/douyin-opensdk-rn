package com.lnyynet.dysdkrn

import android.util.Log
import com.bytedance.sdk.open.aweme.authorize.model.Authorization
import com.bytedance.sdk.open.douyin.DouYinOpenApiFactory
import com.bytedance.sdk.open.douyin.DouYinOpenConfig
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.lnyynet.dysdkrn.common.AuthResult
import com.lnyynet.dysdkrn.common.toWritableMap


class RCTDouYinOpenSDKModule internal constructor(context: ReactApplicationContext) :
  RCTDouYinOpenSDKSpec(context) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  override fun initSDK(clientKey: String) {
    Log.d(NAME, "initSDK: $clientKey")
    DouYinOpenApiFactory.init(DouYinOpenConfig(clientKey))
  }

  @ReactMethod
  override fun authorize(promise: Promise) {
    Log.d(NAME, "start authorize")
    authorizePromise = promise
    // 调用 SDK 发起授权请求，这里会跳转到外部应用
    val douyinOpenApi = DouYinOpenApiFactory.create(reactApplicationContext.currentActivity)

    val request = Authorization.Request()
    request.scope = "user_info" // 用户授权时必选权限
    request.callerLocalEntry = "com.lnyynet.dysdkrn.douyinapi.DouYinEntryActivity" // 第三方指定自定义的回调类 Activity
    // 优先使用抖音app进行授权，如果抖音app因版本或者其他原因无法授权，则使用web页授权
    request.state = "ww" // 用于保持请求和回调的状态，授权请求后原样带回给第三方
    Log.d(NAME, "pending authorize: $request")
    douyinOpenApi.authorize(request)
  }



  companion object {

    const val NAME = "RCTDouYinOpenSDK"
    private var authorizePromise: Promise? = null // 用于保存 Promise 对象

    // 当授权结果返回时调用该方法
    fun onAuthResult(result: AuthResult) {
      Log.d(NAME, "onAuthResult: $result")
      if (authorizePromise != null) {
        authorizePromise!!.resolve(result.toWritableMap()) // 返回授权结果
        authorizePromise = null // 清空 Promise 防止内存泄漏
      } else {
        // 如果没有保存 Promise 对象，说明授权请求没有发起，这里可以忽略
        // 打印一个警告日志，提示回调被意外触发
        Log.w(NAME, "authorize promise is null, pls check if you have called authorize method")
      }
    }
  }
}
