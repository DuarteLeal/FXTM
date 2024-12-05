//
//  Generated code. Do not modify.
//  source: lib/protos/ctrader.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use protoOADealListReqDescriptor instead')
const ProtoOADealListReq$json = {
  '1': 'ProtoOADealListReq',
  '2': [
    {'1': 'ctidTraderAccountId', '3': 1, '4': 2, '5': 3, '10': 'ctidTraderAccountId'},
    {'1': 'fromTimestamp', '3': 2, '4': 1, '5': 3, '10': 'fromTimestamp'},
    {'1': 'toTimestamp', '3': 3, '4': 1, '5': 3, '10': 'toTimestamp'},
    {'1': 'maxRows', '3': 4, '4': 1, '5': 5, '10': 'maxRows'},
  ],
};

/// Descriptor for `ProtoOADealListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List protoOADealListReqDescriptor = $convert.base64Decode(
    'ChJQcm90b09BRGVhbExpc3RSZXESMAoTY3RpZFRyYWRlckFjY291bnRJZBgBIAIoA1ITY3RpZF'
    'RyYWRlckFjY291bnRJZBIkCg1mcm9tVGltZXN0YW1wGAIgASgDUg1mcm9tVGltZXN0YW1wEiAK'
    'C3RvVGltZXN0YW1wGAMgASgDUgt0b1RpbWVzdGFtcBIYCgdtYXhSb3dzGAQgASgFUgdtYXhSb3'
    'dz');

@$core.Deprecated('Use protoOADealListResDescriptor instead')
const ProtoOADealListRes$json = {
  '1': 'ProtoOADealListRes',
  '2': [
    {'1': 'deal', '3': 1, '4': 3, '5': 11, '6': '.ProtoOADeal', '10': 'deal'},
    {'1': 'hasMore', '3': 2, '4': 2, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `ProtoOADealListRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List protoOADealListResDescriptor = $convert.base64Decode(
    'ChJQcm90b09BRGVhbExpc3RSZXMSIAoEZGVhbBgBIAMoCzIMLlByb3RvT0FEZWFsUgRkZWFsEh'
    'gKB2hhc01vcmUYAiACKAhSB2hhc01vcmU=');

@$core.Deprecated('Use protoOADealDescriptor instead')
const ProtoOADeal$json = {
  '1': 'ProtoOADeal',
  '2': [
    {'1': 'dealId', '3': 1, '4': 2, '5': 3, '10': 'dealId'},
    {'1': 'volume', '3': 2, '4': 2, '5': 3, '10': 'volume'},
    {'1': 'price', '3': 3, '4': 2, '5': 1, '10': 'price'},
    {'1': 'timestamp', '3': 4, '4': 2, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `ProtoOADeal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List protoOADealDescriptor = $convert.base64Decode(
    'CgtQcm90b09BRGVhbBIWCgZkZWFsSWQYASACKANSBmRlYWxJZBIWCgZ2b2x1bWUYAiACKANSBn'
    'ZvbHVtZRIUCgVwcmljZRgDIAIoAVIFcHJpY2USHAoJdGltZXN0YW1wGAQgAigDUgl0aW1lc3Rh'
    'bXA=');

