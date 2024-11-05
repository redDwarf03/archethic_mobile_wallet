import 'package:aewallet/domain/models/token_parser.dart';
import 'package:aewallet/infrastructure/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTokensRepositoryImpl extends Mock implements TokensRepositoryImpl {}

class MockDefTokensRepositoryImpl extends Mock
    implements aedappfm.DefTokensRepositoryImpl {}

class MockApiService extends Mock implements archethic.ApiService {}

class _TokenParserImpl with TokenParser {}

void main() {
  group('TokenParser - tokenModelToAETokenModel', () {
    late TokenParser tokenParser;
    late MockTokensRepositoryImpl mockTokensRepository;
    late MockDefTokensRepositoryImpl mockDefTokensRepository;
    late MockApiService mockApiService;
    late aedappfm.Environment environment;

    setUp(() {
      mockTokensRepository = MockTokensRepositoryImpl();
      mockDefTokensRepository = MockDefTokensRepositoryImpl();
      mockApiService = MockApiService();
      environment = aedappfm.Environment.testnet;
      tokenParser = _TokenParserImpl();
    });

    test('Convert UCO to AEToken', () async {
      final token = archethic.Token(
        address: 'UCO',
        symbol: 'UCO',
        supply: archethic.toBigInt(1000000),
      );
      final verifiedTokens = [
        '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
        '0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
      ];
      final poolsListRaw = <GetPoolListResponse>[
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

      when(mockDefTokensRepository.getDefToken(environment, 'UCO'))
          .thenAnswer((_) async {
        return const aedappfm.AEToken(
          address: 'UCO',
          name: 'Universal Coin',
          symbol: 'UCO',
          ucid: 6887,
          icon: 'Archethic.svg',
        );
      });

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

      final result = await tokenParser.tokenModelToAETokenModel(
        token,
        verifiedTokens,
        poolsListRaw,
        environment,
        mockApiService,
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
      final verifiedTokens = [
        '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
        '0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
      ];
      final poolsListRaw = <GetPoolListResponse>[
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

      final result = await tokenParser.tokenModelToAETokenModel(
        token,
        verifiedTokens,
        poolsListRaw,
        environment,
        mockApiService,
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
      final verifiedTokens = [
        '00003DF600E329199BF3EE8FBE2B8223413D70BCDD97E15089E6A74D94DE3F1173B4',
        '0000288BF6F0E12457B125DC54D2DFA4EB010BE3073CF02E10FB79B696180F55B827',
      ];
      final poolsListRaw = <GetPoolListResponse>[
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

      final addresses = [
        'UCO',
        '00006394EF24DFDC6FDFC3642FDC83827591A485704BB997221C0B9F313A468BDEAF'
      ];

      when(
        mockTokensRepository.getTokensFromAddresses(addresses, mockApiService),
      ).thenAnswer(
        (_) async => {
          'UCO': const archethic.Token(symbol: 'UCO'),
          '00006394EF24DFDC6FDFC3642FDC83827591A485704BB997221C0B9F313A468BDEAF':
              const archethic.Token(symbol: 'aeETH'),
        },
      );
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

      final result = await tokenParser.tokenModelToAETokenModel(
        token,
        verifiedTokens,
        poolsListRaw,
        environment,
        mockApiService,
      );

      expect(result.symbol, 'aeETH');
      expect(result.isLpToken, true);
      expect(result.isVerified, false);
      expect(result.isUCO, false);
      expect(result.ucid, isNull);
      expect(result.lpTokenPair, isNotNull);
    });
  });
}
