package com.lnyynet.dysdkrn

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule

abstract class RCTDouYinOpenSDKSpec internal constructor(context: ReactApplicationContext) :
  ReactContextBaseJavaModule(context) {

  abstract fun initSDK(clientKey: String)

  abstract fun authorize(promise: Promise)
}
