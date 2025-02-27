// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/tuple/access/fail_non_int_indexing.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/tuple/access/fail_non_int_indexing.carbon

var a: (i32, i32) = (12, 6);
// CHECK:STDERR: fail_non_int_indexing.carbon:[[@LINE+6]]:17: error: cannot implicitly convert from `f64` to `i32`
// CHECK:STDERR: var b: i32 = a.(2.6);
// CHECK:STDERR:                 ^~~
// CHECK:STDERR: fail_non_int_indexing.carbon:[[@LINE+3]]:17: note: type `f64` does not implement interface `ImplicitAs`
// CHECK:STDERR: var b: i32 = a.(2.6);
// CHECK:STDERR:                 ^~~
var b: i32 = a.(2.6);

// CHECK:STDOUT: --- fail_non_int_indexing.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %.2: type = tuple_type (type, type) [template]
// CHECK:STDOUT:   %.3: type = tuple_type (i32, i32) [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.3 [template]
// CHECK:STDOUT:   %.5: i32 = int_literal 12 [template]
// CHECK:STDOUT:   %.6: i32 = int_literal 6 [template]
// CHECK:STDOUT:   %tuple: %.3 = tuple_value (%.5, %.6) [template]
// CHECK:STDOUT:   %.7: f64 = float_literal 2.6000000000000001 [template]
// CHECK:STDOUT:   %ImplicitAs.type: type = generic_interface_type @ImplicitAs [template]
// CHECK:STDOUT:   %ImplicitAs: %ImplicitAs.type = struct_value () [template]
// CHECK:STDOUT:   %Dest: type = bind_symbolic_name Dest 0 [symbolic]
// CHECK:STDOUT:   %.8: type = interface_type @ImplicitAs, @ImplicitAs(%Dest) [symbolic]
// CHECK:STDOUT:   %Self.1: @ImplicitAs.%.1 (%.8) = bind_symbolic_name Self 1 [symbolic]
// CHECK:STDOUT:   %Self.2: %.8 = bind_symbolic_name Self 1 [symbolic]
// CHECK:STDOUT:   %Convert.type.1: type = fn_type @Convert, @ImplicitAs(%Dest) [symbolic]
// CHECK:STDOUT:   %Convert.1: %Convert.type.1 = struct_value () [symbolic]
// CHECK:STDOUT:   %.9: type = assoc_entity_type %.8, %Convert.type.1 [symbolic]
// CHECK:STDOUT:   %.10: %.9 = assoc_entity element0, imports.%import_ref.6 [symbolic]
// CHECK:STDOUT:   %.11: type = interface_type @ImplicitAs, @ImplicitAs(i32) [template]
// CHECK:STDOUT:   %Convert.type.2: type = fn_type @Convert, @ImplicitAs(i32) [template]
// CHECK:STDOUT:   %Convert.2: %Convert.type.2 = struct_value () [template]
// CHECK:STDOUT:   %.12: type = assoc_entity_type %.11, %Convert.type.2 [template]
// CHECK:STDOUT:   %.13: %.12 = assoc_entity element0, imports.%import_ref.6 [template]
// CHECK:STDOUT:   %.14: %.9 = assoc_entity element0, imports.%import_ref.7 [symbolic]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int32 = %import_ref.1
// CHECK:STDOUT:     .ImplicitAs = %import_ref.2
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/as
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.1: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT:   %import_ref.2: %ImplicitAs.type = import_ref Core//prelude/operators/as, inst+40, loaded [template = constants.%ImplicitAs]
// CHECK:STDOUT:   %import_ref.3 = import_ref Core//prelude/operators/as, inst+45, unloaded
// CHECK:STDOUT:   %import_ref.4: @ImplicitAs.%.2 (%.9) = import_ref Core//prelude/operators/as, inst+63, loaded [symbolic = @ImplicitAs.%.3 (constants.%.14)]
// CHECK:STDOUT:   %import_ref.5 = import_ref Core//prelude/operators/as, inst+56, unloaded
// CHECK:STDOUT:   %import_ref.6 = import_ref Core//prelude/operators/as, inst+56, unloaded
// CHECK:STDOUT:   %import_ref.7 = import_ref Core//prelude/operators/as, inst+56, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .a = %a
// CHECK:STDOUT:     .b = %b
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %int.make_type_32.loc11_9: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %int.make_type_32.loc11_14: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc11_17.1: %.2 = tuple_literal (%int.make_type_32.loc11_9, %int.make_type_32.loc11_14)
// CHECK:STDOUT:   %.loc11_17.2: type = value_of_initializer %int.make_type_32.loc11_9 [template = i32]
// CHECK:STDOUT:   %.loc11_17.3: type = converted %int.make_type_32.loc11_9, %.loc11_17.2 [template = i32]
// CHECK:STDOUT:   %.loc11_17.4: type = value_of_initializer %int.make_type_32.loc11_14 [template = i32]
// CHECK:STDOUT:   %.loc11_17.5: type = converted %int.make_type_32.loc11_14, %.loc11_17.4 [template = i32]
// CHECK:STDOUT:   %.loc11_17.6: type = converted %.loc11_17.1, constants.%.3 [template = constants.%.3]
// CHECK:STDOUT:   %a.var: ref %.3 = var a
// CHECK:STDOUT:   %a: ref %.3 = bind_name a, %a.var
// CHECK:STDOUT:   %int.make_type_32.loc18: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc18_8.1: type = value_of_initializer %int.make_type_32.loc18 [template = i32]
// CHECK:STDOUT:   %.loc18_8.2: type = converted %int.make_type_32.loc18, %.loc18_8.1 [template = i32]
// CHECK:STDOUT:   %b.var: ref i32 = var b
// CHECK:STDOUT:   %b: ref i32 = bind_name b, %b.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic interface @ImplicitAs(constants.%Dest: type) {
// CHECK:STDOUT:   %Dest: type = bind_symbolic_name Dest 0 [symbolic = %Dest (constants.%Dest)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %.1: type = interface_type @ImplicitAs, @ImplicitAs(%Dest) [symbolic = %.1 (constants.%.8)]
// CHECK:STDOUT:   %Self: %.8 = bind_symbolic_name Self 1 [symbolic = %Self (constants.%Self.2)]
// CHECK:STDOUT:   %Convert.type: type = fn_type @Convert, @ImplicitAs(%Dest) [symbolic = %Convert.type (constants.%Convert.type.1)]
// CHECK:STDOUT:   %Convert: @ImplicitAs.%Convert.type (%Convert.type.1) = struct_value () [symbolic = %Convert (constants.%Convert.1)]
// CHECK:STDOUT:   %.2: type = assoc_entity_type @ImplicitAs.%.1 (%.8), @ImplicitAs.%Convert.type (%Convert.type.1) [symbolic = %.2 (constants.%.9)]
// CHECK:STDOUT:   %.3: @ImplicitAs.%.2 (%.9) = assoc_entity element0, imports.%import_ref.6 [symbolic = %.3 (constants.%.10)]
// CHECK:STDOUT:
// CHECK:STDOUT:   interface {
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = imports.%import_ref.3
// CHECK:STDOUT:     .Convert = imports.%import_ref.4
// CHECK:STDOUT:     witness = (imports.%import_ref.5)
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @Convert(constants.%Dest: type, constants.%Self.1: @ImplicitAs.%.1 (%.8)) {
// CHECK:STDOUT:   %Dest: type = bind_symbolic_name Dest 0 [symbolic = %Dest (constants.%Dest)]
// CHECK:STDOUT:   %.1: type = interface_type @ImplicitAs, @ImplicitAs(%Dest) [symbolic = %.1 (constants.%.8)]
// CHECK:STDOUT:   %Self: %.8 = bind_symbolic_name Self 1 [symbolic = %Self (constants.%Self.2)]
// CHECK:STDOUT:
// CHECK:STDOUT:   fn[%self: @Convert.%Self (%Self.2)]() -> @Convert.%Dest (%Dest);
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc11_22: i32 = int_literal 12 [template = constants.%.5]
// CHECK:STDOUT:   %.loc11_26: i32 = int_literal 6 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_27.1: %.3 = tuple_literal (%.loc11_22, %.loc11_26)
// CHECK:STDOUT:   %.loc11_27.2: ref i32 = tuple_access file.%a.var, element0
// CHECK:STDOUT:   %.loc11_27.3: init i32 = initialize_from %.loc11_22 to %.loc11_27.2 [template = constants.%.5]
// CHECK:STDOUT:   %.loc11_27.4: ref i32 = tuple_access file.%a.var, element1
// CHECK:STDOUT:   %.loc11_27.5: init i32 = initialize_from %.loc11_26 to %.loc11_27.4 [template = constants.%.6]
// CHECK:STDOUT:   %.loc11_27.6: init %.3 = tuple_init (%.loc11_27.3, %.loc11_27.5) to file.%a.var [template = constants.%tuple]
// CHECK:STDOUT:   %.loc11_28: init %.3 = converted %.loc11_27.1, %.loc11_27.6 [template = constants.%tuple]
// CHECK:STDOUT:   assign file.%a.var, %.loc11_28
// CHECK:STDOUT:   %a.ref: ref %.3 = name_ref a, file.%a
// CHECK:STDOUT:   %.loc18_17.1: f64 = float_literal 2.6000000000000001 [template = constants.%.7]
// CHECK:STDOUT:   %.loc18_17.2: type = interface_type @ImplicitAs, @ImplicitAs(i32) [template = constants.%.11]
// CHECK:STDOUT:   %.loc18_17.3: %.12 = specific_constant imports.%import_ref.4, @ImplicitAs(i32) [template = constants.%.13]
// CHECK:STDOUT:   %Convert.ref: %.12 = name_ref Convert, %.loc18_17.3 [template = constants.%.13]
// CHECK:STDOUT:   %.loc18_17.4: i32 = converted %.loc18_17.1, <error> [template = <error>]
// CHECK:STDOUT:   assign file.%b.var, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @ImplicitAs(constants.%Dest) {
// CHECK:STDOUT:   %Dest => constants.%Dest
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @ImplicitAs(@ImplicitAs.%Dest) {
// CHECK:STDOUT:   %Dest => constants.%Dest
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @ImplicitAs(@Convert.%Dest) {
// CHECK:STDOUT:   %Dest => constants.%Dest
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Convert(constants.%Dest, constants.%Self.1) {
// CHECK:STDOUT:   %Dest => constants.%Dest
// CHECK:STDOUT:   %.1 => constants.%.8
// CHECK:STDOUT:   %Self => constants.%Self.1
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @ImplicitAs(i32) {
// CHECK:STDOUT:   %Dest => i32
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %.1 => constants.%.11
// CHECK:STDOUT:   %Self => constants.%Self.2
// CHECK:STDOUT:   %Convert.type => constants.%Convert.type.2
// CHECK:STDOUT:   %Convert => constants.%Convert.2
// CHECK:STDOUT:   %.2 => constants.%.12
// CHECK:STDOUT:   %.3 => constants.%.13
// CHECK:STDOUT: }
// CHECK:STDOUT:
