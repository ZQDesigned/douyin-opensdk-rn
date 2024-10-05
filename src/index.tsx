import { NativeModules, Platform } from 'react-native';
import type { AuthResult } from './common';

const LINKING_ERROR =
  `The package 'douyin-opensdk-rn' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const RCTDouYinOpenSDKModule = isTurboModuleEnabled
  ? require('./NativeRCTDouYinOpenSDK').default
  : NativeModules.RCTDouYinOpenSDK;

const RCTDouYinOpenSDK = RCTDouYinOpenSDKModule
  ? RCTDouYinOpenSDKModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function initSDK(clientKey: string): void {
  RCTDouYinOpenSDK.initSDK(clientKey);
}

export function authorize(): Promise<AuthResult> {
  return RCTDouYinOpenSDK.authorize();
}
