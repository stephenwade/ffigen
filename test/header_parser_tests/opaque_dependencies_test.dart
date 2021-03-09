// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:ffigen/src/code_generator.dart';
import 'package:ffigen/src/header_parser.dart' as parser;
import 'package:ffigen/src/config_provider.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'package:ffigen/src/strings.dart' as strings;

import '../test_utils.dart';

late Library actual;
void main() {
  group('opaque_dependencies_test', () {
    setUpAll(() {
      logWarnings(Level.SEVERE);
      actual = parser.parse(
        Config.fromYaml(yaml.loadYaml('''
${strings.name}: 'NativeLibrary'
${strings.description}: 'Opaque Dependencies Test'
${strings.output}: 'unused'
${strings.headers}:
  ${strings.entryPoints}:
    - 'test/header_parser_tests/opaque_dependencies.h'
${strings.structs}:
  ${strings.include}:
    - 'E'
  ${strings.structDependencies}: ${strings.opaqueStructDependencies}
        ''') as yaml.YamlMap),
      );
    });

    test('Expected bindings', () {
      matchLibraryWithExpected(actual, [
        'test',
        'debug_generated',
        'opaque_dependencies_test_output.dart'
      ], [
        'test',
        'header_parser_tests',
        'expected_bindings',
        '_expected_opaque_dependencies_bindings.dart'
      ]);
    });
  });
}