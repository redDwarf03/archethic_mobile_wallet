import 'dart:io';

import 'package:aewallet/domain/models/token_parser.dart';
import 'package:aewallet/domain/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(
  [
    MockSpec<aedappfm.DefTokensRepositoryInterface>(),
    MockSpec<archethic.ApiService>(),
    MockSpec<TokensRepository>(),
  ],
)
import 'token_parser_test.mocks.dart';

class _TokenParserImpl with TokenParser {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TokenParser - tokenModelToAETokenModel', () {
    late TokenParser tokenParser;
    late MockTokensRepository mockTokensRepository;
    late MockDefTokensRepositoryInterface mockDefTokensRepository;
    late MockApiService mockApiService;
    late aedappfm.Environment environment;
    late List<String> verifiedTokens;
    late List<GetPoolListResponse> poolsListRaw;

    setUp(() {
      Hive.init('${Directory.current.path}/test/tmp_data');
      mockTokensRepository = MockTokensRepository();
      mockDefTokensRepository = MockDefTokensRepositoryInterface();
      mockApiService = MockApiService();
      environment = aedappfm.Environment.testnet;
      tokenParser = _TokenParserImpl();

      verifiedTokens = [
        '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
        '0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
      ];
      poolsListRaw = <GetPoolListResponse>[
        const GetPoolListResponse(
          concatenatedTokensAddresses:
              '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4/UCO',
          address:
              '0000818EF23676779DAE1C97072BB99A3E0DD1C31BAD3787422798DBE3F777F74A43',
          lpTokenAddress:
              '00006394EF24DFDC6FDFC3642FDC83827591A485704BB997221C0B9F313A468BDEAF',
        ),
        const GetPoolListResponse(
          concatenatedTokensAddresses:
              'UCO/0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
          address:
              '0000DD19DD796959B72998536F67814DCCABE156FF647E0E63E43395203908963767',
          lpTokenAddress:
              '0000A4CAB2362A97002EE0A6DD2013BEC3AF02C4D8C392712CFBC38F3E4809B9314C',
        ),
      ];

      when(mockDefTokensRepository.getDefToken(environment, 'UCO')).thenAnswer(
        (_) async => const aedappfm.AEToken(
          address: 'UCO',
          name: 'Universal Coin',
          symbol: 'UCO',
          ucid: 6887,
          icon: 'Archethic.svg',
        ),
      );

      when(
        mockDefTokensRepository.getDefToken(
          environment,
          '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
        ),
      ).thenAnswer(
        (_) async => const aedappfm.AEToken(
          address:
              '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
          name: 'Wrapped Ether',
          symbol: 'aeETH',
          ucid: 1027,
          icon: 'Ethereum.svg',
        ),
      );

      when(
        mockDefTokensRepository.getDefToken(
          environment,
          '0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
        ),
      ).thenAnswer(
        (_) async => const aedappfm.AEToken(
          address:
              '0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
          name: 'Wrapped BNB',
          symbol: 'aeBNB',
          ucid: 1839,
          icon: 'BNB.svg',
        ),
      );
    });

    test('Convert UCO to AEToken', () async {
      final token = archethic.Token(
        address: 'UCO',
        symbol: 'UCO',
        supply: archethic.toBigInt(1000000),
      );

      final result = await tokenParser.tokenModelToAETokenModel(
        token,
        verifiedTokens,
        poolsListRaw,
        environment,
        mockApiService,
        mockDefTokensRepository,
        mockTokensRepository,
      );

      expect(result.name, 'Universal Coin');
      expect(result.address, 'UCO');
      expect(result.symbol, 'UCO');
      expect(result.isLpToken, false);
      expect(result.isVerified, false);
      expect(result.isUCO, true);
      expect(result.ucid, 6887);
      expect(result.lpTokenPair, isNull);
    });

    test('Convert token to AEToken', () async {
      final token = archethic.Token(
        address:
            '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
        symbol: 'aeETH',
        type: 'fungible',
        supply: archethic.toBigInt(1000000),
      );

      final result = await tokenParser.tokenModelToAETokenModel(
        token,
        verifiedTokens,
        poolsListRaw,
        environment,
        mockApiService,
        mockDefTokensRepository,
        mockTokensRepository,
      );

      expect(result.name, 'Wrapped Ether');
      expect(
        result.address,
        '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
      );
      expect(result.symbol, 'aeETH');
      expect(result.isLpToken, false);
      expect(result.isVerified, true);
      expect(result.isUCO, false);
      expect(result.ucid, 1027);
      expect(result.lpTokenPair, isNull);
    });

    test('Convert LP token to AEToken', () async {
      final token = archethic.Token(
        address:
            '00006394EF24DFDC6FDFC3642FDC83827591A485704BB997221C0B9F313A468BDEAF',
        supply: archethic.toBigInt(500000),
      );
      when(
        mockTokensRepository.getTokensFromAddresses(
          argThat(
            equals([
              '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
            ]),
          ),
        ),
      ).thenAnswer(
        (_) async => {
          '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4':
              const archethic.Token(symbol: 'aeETH'),
        },
      );
      final result = await tokenParser.tokenModelToAETokenModel(
        token,
        verifiedTokens,
        poolsListRaw,
        environment,
        mockApiService,
        mockDefTokensRepository,
        mockTokensRepository,
      );

      expect(result.symbol, 'LP Token');
      expect(
        result.address,
        '00006394EF24DFDC6FDFC3642FDC83827591A485704BB997221C0B9F313A468BDEAF',
      );
      expect(result.supply, 500000);
      expect(result.isLpToken, true);
      expect(result.isVerified, false);
      expect(result.isUCO, false);
      expect(result.ucid, isNull);
      expect(result.lpTokenPair, isNotNull);
      expect(
        result.lpTokenPair!.token1.address,
        '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
      );
      expect(result.lpTokenPair!.token2.address, 'UCO');
    });
  });
}
