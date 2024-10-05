import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { AuthResult } from './common';

export interface Spec extends TurboModule {
  initSDK(clientKey: string): void;
  authorize(): Promise<AuthResult>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RCTDouYinOpenSDK');
