package com.lnyynet.dysdkrn.douyinapi

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.bytedance.sdk.open.aweme.CommonConstants
import com.bytedance.sdk.open.aweme.authorize.model.Authorization
import com.bytedance.sdk.open.aweme.common.handler.IApiEventHandler
import com.bytedance.sdk.open.aweme.common.model.BaseReq
import com.bytedance.sdk.open.aweme.common.model.BaseResp
import com.bytedance.sdk.open.douyin.DouYinOpenApiFactory
import com.bytedance.sdk.open.douyin.api.DouYinOpenApi
import com.lnyynet.dysdkrn.RCTDouYinOpenSDKModule.Companion.onAuthResult
import com.lnyynet.dysdkrn.common.AuthResult
import com.lnyynet.dysdkrn.common.AuthType


class DouYinEntryActivity : Activity(), IApiEventHandler {

  private lateinit var douYinOpenApi: DouYinOpenApi

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    douYinOpenApi = DouYinOpenApiFactory.create(this)
    douYinOpenApi.handleIntent(intent, this)
  }

  /**
   * 什么也不做，只是为了实现接口
   */
  override fun onReq(req: BaseReq?) {  }

  override fun onResp(resp: BaseResp?) {
    Log.d("DouYinEntryActivity", "onResp: $resp")
    // 授权成功可以获得authCode
    if (resp != null) {
      if (resp.type == CommonConstants.ModeType.SEND_AUTH_RESPONSE) {
        val response = resp as Authorization.Response
        when {
          response.isSuccess -> {
            onAuthResult(
              AuthResult(
                AuthType.SUCCESS,
                response.authCode,
                response.grantedPermissions,
                response.errorCode,
                null
              )
            )
          }
          response.isCancel -> {
            // 授权取消
            onAuthResult(
              AuthResult(
                AuthType.USER_CANCELED,
                null,
                null,
                response.errorCode,
                null
              )
            )
          }
          else -> {
            // 授权失败
            onAuthResult(
              AuthResult(
                AuthType.FAILED,
                null,
                null,
                response.errorCode,
                response.errorMsg
              )
            )
          }
        }
        finish()
      }
    }
  }

  override fun onErrorIntent(p0: Intent?) {
    // 错误数据
    Toast.makeText(this, "操作异常，请重试", Toast.LENGTH_LONG).show()
    finish()
  }

}
