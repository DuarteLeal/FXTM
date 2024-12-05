//
//  Generated code. Do not modify.
//  source: lib/protos/ctrader.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class ProtoOADealListReq extends $pb.GeneratedMessage {
  factory ProtoOADealListReq({
    $fixnum.Int64? ctidTraderAccountId,
    $fixnum.Int64? fromTimestamp,
    $fixnum.Int64? toTimestamp,
    $core.int? maxRows,
  }) {
    final $result = create();
    if (ctidTraderAccountId != null) {
      $result.ctidTraderAccountId = ctidTraderAccountId;
    }
    if (fromTimestamp != null) {
      $result.fromTimestamp = fromTimestamp;
    }
    if (toTimestamp != null) {
      $result.toTimestamp = toTimestamp;
    }
    if (maxRows != null) {
      $result.maxRows = maxRows;
    }
    return $result;
  }
  ProtoOADealListReq._() : super();
  factory ProtoOADealListReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoOADealListReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProtoOADealListReq', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ctidTraderAccountId', $pb.PbFieldType.Q6, protoName: 'ctidTraderAccountId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(2, _omitFieldNames ? '' : 'fromTimestamp', protoName: 'fromTimestamp')
    ..aInt64(3, _omitFieldNames ? '' : 'toTimestamp', protoName: 'toTimestamp')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'maxRows', $pb.PbFieldType.O3, protoName: 'maxRows')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoOADealListReq clone() => ProtoOADealListReq()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoOADealListReq copyWith(void Function(ProtoOADealListReq) updates) => super.copyWith((message) => updates(message as ProtoOADealListReq)) as ProtoOADealListReq;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProtoOADealListReq create() => ProtoOADealListReq._();
  ProtoOADealListReq createEmptyInstance() => create();
  static $pb.PbList<ProtoOADealListReq> createRepeated() => $pb.PbList<ProtoOADealListReq>();
  @$core.pragma('dart2js:noInline')
  static ProtoOADealListReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoOADealListReq>(create);
  static ProtoOADealListReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ctidTraderAccountId => $_getI64(0);
  @$pb.TagNumber(1)
  set ctidTraderAccountId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCtidTraderAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCtidTraderAccountId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fromTimestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set fromTimestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFromTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get toTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set toTimestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasToTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearToTimestamp() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxRows => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxRows($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxRows() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxRows() => clearField(4);
}

class ProtoOADealListRes extends $pb.GeneratedMessage {
  factory ProtoOADealListRes({
    $core.Iterable<ProtoOADeal>? deal,
    $core.bool? hasMore,
  }) {
    final $result = create();
    if (deal != null) {
      $result.deal.addAll(deal);
    }
    if (hasMore != null) {
      $result.hasMore = hasMore;
    }
    return $result;
  }
  ProtoOADealListRes._() : super();
  factory ProtoOADealListRes.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoOADealListRes.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProtoOADealListRes', createEmptyInstance: create)
    ..pc<ProtoOADeal>(1, _omitFieldNames ? '' : 'deal', $pb.PbFieldType.PM, subBuilder: ProtoOADeal.create)
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'hasMore', $pb.PbFieldType.QB, protoName: 'hasMore')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoOADealListRes clone() => ProtoOADealListRes()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoOADealListRes copyWith(void Function(ProtoOADealListRes) updates) => super.copyWith((message) => updates(message as ProtoOADealListRes)) as ProtoOADealListRes;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProtoOADealListRes create() => ProtoOADealListRes._();
  ProtoOADealListRes createEmptyInstance() => create();
  static $pb.PbList<ProtoOADealListRes> createRepeated() => $pb.PbList<ProtoOADealListRes>();
  @$core.pragma('dart2js:noInline')
  static ProtoOADealListRes getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoOADealListRes>(create);
  static ProtoOADealListRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ProtoOADeal> get deal => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => clearField(2);
}

class ProtoOADeal extends $pb.GeneratedMessage {
  factory ProtoOADeal({
    $fixnum.Int64? dealId,
    $fixnum.Int64? volume,
    $core.double? price,
    $fixnum.Int64? timestamp,
  }) {
    final $result = create();
    if (dealId != null) {
      $result.dealId = dealId;
    }
    if (volume != null) {
      $result.volume = volume;
    }
    if (price != null) {
      $result.price = price;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  ProtoOADeal._() : super();
  factory ProtoOADeal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProtoOADeal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProtoOADeal', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'dealId', $pb.PbFieldType.Q6, protoName: 'dealId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'volume', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProtoOADeal clone() => ProtoOADeal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProtoOADeal copyWith(void Function(ProtoOADeal) updates) => super.copyWith((message) => updates(message as ProtoOADeal)) as ProtoOADeal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProtoOADeal create() => ProtoOADeal._();
  ProtoOADeal createEmptyInstance() => create();
  static $pb.PbList<ProtoOADeal> createRepeated() => $pb.PbList<ProtoOADeal>();
  @$core.pragma('dart2js:noInline')
  static ProtoOADeal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProtoOADeal>(create);
  static ProtoOADeal? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get dealId => $_getI64(0);
  @$pb.TagNumber(1)
  set dealId($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDealId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDealId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get volume => $_getI64(1);
  @$pb.TagNumber(2)
  set volume($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVolume() => $_has(1);
  @$pb.TagNumber(2)
  void clearVolume() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
