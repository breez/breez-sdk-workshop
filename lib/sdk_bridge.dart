import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';

import 'conf.dart';

extension InitSDK on BreezBridge {

  Future _initNewNode() async {
    const secureStorage = FlutterSecureStorage();    
    final mnemonics = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonics);
    final sdkConfig = await getConfig();
    
    final sdk.GreenlightCredentials creds = await registerNode(
      config: sdkConfig,
      network: sdk.Network.Bitcoin,
      seed: seed,
    );
    await secureStorage.write(key: "gl-cert", value: HEX.encode(creds.deviceCert));
    await secureStorage.write(key: "gl-key", value: HEX.encode(creds.deviceKey));
    await secureStorage.write(key: "mnemonics", value: mnemonics);
  }

  Future<Config> getConfig() async {
    return (await defaultConfig(sdk.EnvironmentType.Production)).copyWith(
        workingDir: (await getApplicationDocumentsDirectory()).path,
        apiKey: apiKey);
  }
}
