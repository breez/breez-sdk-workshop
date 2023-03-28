import 'dart:typed_data';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';

import 'conf.dart';

extension InitSDK on BreezBridge {
  
  Future start() async {
    const secureStorage = FlutterSecureStorage();
    var glCert = await secureStorage.read(key: "gl-cert");
    var glKey = await secureStorage.read(key: "gl-key");
    var mnemonics = await secureStorage.read(key: "mnemonics");
    if (glCert != null && glKey != null && mnemonics != null) {
      await _initExistingdNode(mnemonics, glCert, glKey);
    } else {
      await _initNewNode();
    }
    await startNode();
  }

  Future _initExistingdNode(String mnemonic, String glCert, String glKey) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final sdkConfig = await getConfig();
    await initServices(
      config: sdkConfig,
      seed: seed,
      creds: sdk.GreenlightCredentials(
        deviceCert: Uint8List.fromList(HEX.decode(glCert)),
        deviceKey: Uint8List.fromList(HEX.decode(glKey)),
      ),
    );
  }

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
    return (await defaultConfig(sdk.EnvironmentType.Production))
        .copyWith(workingDir: (await getApplicationDocumentsDirectory()).path, apiKey: apiKey);
  }
}
