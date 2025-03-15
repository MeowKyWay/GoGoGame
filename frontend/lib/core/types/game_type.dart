import 'package:flutter/material.dart';
import 'package:gogogame_frontend/core/interfaces/jsonable.dart';

class GameFormatType implements Jsonable {
  final int initialTime;
  final int increment;

  GameFormatType({required this.initialTime, required this.increment});

  @override
  Map<String, dynamic> toJson() {
    return {'initialTime': initialTime, 'increment': increment};
  }

  factory GameFormatType.fromJson(Map<String, dynamic> json) {
    return GameFormatType(
      initialTime: json['initialTime'],
      increment: json['increment'],
    );
  }
}

enum DiskColor {
  black,
  white;

  static DiskColor fromString(String color) {
    if (color == 'black') {
      return DiskColor.black;
    } else if (color == 'white') {
      return DiskColor.white;
    }
    throw Exception('Invalid color: $color');
  }

  DiskColor opposite() {
    return this == DiskColor.black ? DiskColor.white : DiskColor.black;
  }

  bool matches(CellDisk disk) {
    return this == DiskColor.black
        ? disk == CellDisk.black
        : disk == CellDisk.white;
  }

  CellDisk toCellDisk() {
    return this == DiskColor.black ? CellDisk.black : CellDisk.white;
  }

  @override
  String toString() {
    return this == DiskColor.black ? 'black' : 'white';
  }
}

enum CellDisk {
  empty,
  black,
  white;

  static CellDisk fromString(String disk) {
    if (disk == 'black') {
      return CellDisk.black;
    } else if (disk == 'white') {
      return CellDisk.white;
    } else if (disk == 'empty' || disk == '') {
      return CellDisk.empty;
    } else {
      throw Exception('Invalid disk: $disk');
    }
  }

  bool matches(DiskColor color) {
    return color == DiskColor.black
        ? this == CellDisk.black
        : this == CellDisk.white;
  }

  Color toColor() {
    switch (this) {
      case CellDisk.black:
        return Colors.black;
      case CellDisk.white:
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }

  DiskColor toDiskColor() {
    switch (this) {
      case CellDisk.black:
        return DiskColor.black;
      case CellDisk.white:
        return DiskColor.white;
      default:
        throw Exception('Empty disk has no color');
    }
  }

  @override
  String toString() {
    return this == CellDisk.black
        ? 'black'
        : this == CellDisk.white
        ? 'white'
        : 'empty';
  }
}
