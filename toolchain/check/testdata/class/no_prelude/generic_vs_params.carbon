// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/class/no_prelude/generic_vs_params.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/class/no_prelude/generic_vs_params.carbon

// --- params.carbon

library "[[@TEST_NAME]]";

class NotGenericNoParams {}
class NotGenericButParams() {}
class GenericAndParams(T:! type) {}

class C(T:! type) {
  class GenericNoParams {}
  class GenericAndParams(U:! type) {}
}

class X {}

var a: NotGenericNoParams = {};
var b: NotGenericButParams() = {};
var c: GenericAndParams(X) = {};
var d: C(X).GenericNoParams = {};
var e: C(X).GenericAndParams(X) = {};

// --- fail_non_generic_implicit_params.carbon

library "[[@TEST_NAME]]";

// CHECK:STDERR: fail_non_generic_implicit_params.carbon:[[@LINE+4]]:9: error: parameters of generic types must be constant
// CHECK:STDERR: class A[T: type]() {}
// CHECK:STDERR:         ^
// CHECK:STDERR:
class A[T: type]() {}

// --- fail_non_generic_params.carbon

library "[[@TEST_NAME]]";

// CHECK:STDERR: fail_non_generic_params.carbon:[[@LINE+3]]:9: error: parameters of generic types must be constant
// CHECK:STDERR: class A(T: type) {}
// CHECK:STDERR:         ^
class A(T: type) {}

// This is testing a use of the invalid type.
fn F(T:! type) {
  A(T);
}

// CHECK:STDOUT: --- params.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %NotGenericNoParams: type = class_type @NotGenericNoParams [template]
// CHECK:STDOUT:   %.1: type = struct_type {} [template]
// CHECK:STDOUT:   %.2: <witness> = complete_type_witness %.1 [template]
// CHECK:STDOUT:   %NotGenericButParams.type: type = generic_class_type @NotGenericButParams [template]
// CHECK:STDOUT:   %.3: type = tuple_type () [template]
// CHECK:STDOUT:   %NotGenericButParams.1: %NotGenericButParams.type = struct_value () [template]
// CHECK:STDOUT:   %NotGenericButParams.2: type = class_type @NotGenericButParams [template]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0 [symbolic]
// CHECK:STDOUT:   %GenericAndParams.type.1: type = generic_class_type @GenericAndParams.1 [template]
// CHECK:STDOUT:   %GenericAndParams.1: %GenericAndParams.type.1 = struct_value () [template]
// CHECK:STDOUT:   %GenericAndParams.2: type = class_type @GenericAndParams.1, @GenericAndParams.1(%T) [symbolic]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [template]
// CHECK:STDOUT:   %C.1: %C.type = struct_value () [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%T) [symbolic]
// CHECK:STDOUT:   %GenericNoParams.1: type = class_type @GenericNoParams [template]
// CHECK:STDOUT:   %GenericNoParams.2: type = class_type @GenericNoParams, @GenericNoParams(%T) [symbolic]
// CHECK:STDOUT:   %U: type = bind_symbolic_name U 1 [symbolic]
// CHECK:STDOUT:   %GenericAndParams.type.2: type = generic_class_type @GenericAndParams.2, @C(%T) [symbolic]
// CHECK:STDOUT:   %GenericAndParams.3: %GenericAndParams.type.2 = struct_value () [symbolic]
// CHECK:STDOUT:   %GenericAndParams.4: type = class_type @GenericAndParams.2, @GenericAndParams.2(%T, %U) [symbolic]
// CHECK:STDOUT:   %X: type = class_type @X [template]
// CHECK:STDOUT:   %.4: type = ptr_type %.1 [template]
// CHECK:STDOUT:   %struct.1: %NotGenericNoParams = struct_value () [template]
// CHECK:STDOUT:   %struct.2: %NotGenericButParams.2 = struct_value () [template]
// CHECK:STDOUT:   %GenericAndParams.5: type = class_type @GenericAndParams.1, @GenericAndParams.1(%X) [template]
// CHECK:STDOUT:   %struct.3: %GenericAndParams.5 = struct_value () [template]
// CHECK:STDOUT:   %C.3: type = class_type @C, @C(%X) [template]
// CHECK:STDOUT:   %GenericAndParams.type.3: type = generic_class_type @GenericAndParams.2, @C(%X) [template]
// CHECK:STDOUT:   %GenericAndParams.6: %GenericAndParams.type.3 = struct_value () [template]
// CHECK:STDOUT:   %struct.4: %GenericNoParams.1 = struct_value () [template]
// CHECK:STDOUT:   %GenericAndParams.7: type = class_type @GenericAndParams.2, @GenericAndParams.2(%X, %X) [template]
// CHECK:STDOUT:   %struct.5: %GenericAndParams.7 = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .NotGenericNoParams = %NotGenericNoParams.decl
// CHECK:STDOUT:     .NotGenericButParams = %NotGenericButParams.decl
// CHECK:STDOUT:     .GenericAndParams = %GenericAndParams.decl
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .X = %X.decl
// CHECK:STDOUT:     .a = %a
// CHECK:STDOUT:     .b = %b
// CHECK:STDOUT:     .c = %c
// CHECK:STDOUT:     .d = %d
// CHECK:STDOUT:     .e = %e
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %NotGenericNoParams.decl: type = class_decl @NotGenericNoParams [template = constants.%NotGenericNoParams] {} {}
// CHECK:STDOUT:   %NotGenericButParams.decl: %NotGenericButParams.type = class_decl @NotGenericButParams [template = constants.%NotGenericButParams.1] {} {}
// CHECK:STDOUT:   %GenericAndParams.decl: %GenericAndParams.type.1 = class_decl @GenericAndParams.1 [template = constants.%GenericAndParams.1] {
// CHECK:STDOUT:     %T.patt: type = symbolic_binding_pattern T 0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = param T, runtime_param<invalid>
// CHECK:STDOUT:     %T.loc6: type = bind_symbolic_name T 0, %T.param [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %C.decl: %C.type = class_decl @C [template = constants.%C.1] {
// CHECK:STDOUT:     %T.patt: type = symbolic_binding_pattern T 0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = param T, runtime_param<invalid>
// CHECK:STDOUT:     %T.loc8: type = bind_symbolic_name T 0, %T.param [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %X.decl: type = class_decl @X [template = constants.%X] {} {}
// CHECK:STDOUT:   %NotGenericNoParams.ref: type = name_ref NotGenericNoParams, %NotGenericNoParams.decl [template = constants.%NotGenericNoParams]
// CHECK:STDOUT:   %a.var: ref %NotGenericNoParams = var a
// CHECK:STDOUT:   %a: ref %NotGenericNoParams = bind_name a, %a.var
// CHECK:STDOUT:   %NotGenericButParams.ref: %NotGenericButParams.type = name_ref NotGenericButParams, %NotGenericButParams.decl [template = constants.%NotGenericButParams.1]
// CHECK:STDOUT:   %NotGenericButParams: type = class_type @NotGenericButParams [template = constants.%NotGenericButParams.2]
// CHECK:STDOUT:   %b.var: ref %NotGenericButParams.2 = var b
// CHECK:STDOUT:   %b: ref %NotGenericButParams.2 = bind_name b, %b.var
// CHECK:STDOUT:   %GenericAndParams.ref.loc17: %GenericAndParams.type.1 = name_ref GenericAndParams, %GenericAndParams.decl [template = constants.%GenericAndParams.1]
// CHECK:STDOUT:   %X.ref.loc17: type = name_ref X, %X.decl [template = constants.%X]
// CHECK:STDOUT:   %GenericAndParams.loc17: type = class_type @GenericAndParams.1, @GenericAndParams.1(constants.%X) [template = constants.%GenericAndParams.5]
// CHECK:STDOUT:   %c.var: ref %GenericAndParams.5 = var c
// CHECK:STDOUT:   %c: ref %GenericAndParams.5 = bind_name c, %c.var
// CHECK:STDOUT:   %C.ref.loc18: %C.type = name_ref C, %C.decl [template = constants.%C.1]
// CHECK:STDOUT:   %X.ref.loc18: type = name_ref X, %X.decl [template = constants.%X]
// CHECK:STDOUT:   %C.loc18: type = class_type @C, @C(constants.%X) [template = constants.%C.3]
// CHECK:STDOUT:   %GenericNoParams.ref: type = name_ref GenericNoParams, @C.%GenericNoParams.decl [template = constants.%GenericNoParams.1]
// CHECK:STDOUT:   %d.var: ref %GenericNoParams.1 = var d
// CHECK:STDOUT:   %d: ref %GenericNoParams.1 = bind_name d, %d.var
// CHECK:STDOUT:   %C.ref.loc19: %C.type = name_ref C, %C.decl [template = constants.%C.1]
// CHECK:STDOUT:   %X.ref.loc19_10: type = name_ref X, %X.decl [template = constants.%X]
// CHECK:STDOUT:   %C.loc19: type = class_type @C, @C(constants.%X) [template = constants.%C.3]
// CHECK:STDOUT:   %.loc19: %GenericAndParams.type.3 = specific_constant @C.%GenericAndParams.decl, @C(constants.%X) [template = constants.%GenericAndParams.6]
// CHECK:STDOUT:   %GenericAndParams.ref.loc19: %GenericAndParams.type.3 = name_ref GenericAndParams, %.loc19 [template = constants.%GenericAndParams.6]
// CHECK:STDOUT:   %X.ref.loc19_30: type = name_ref X, %X.decl [template = constants.%X]
// CHECK:STDOUT:   %GenericAndParams.loc19: type = class_type @GenericAndParams.2, @GenericAndParams.2(constants.%X, constants.%X) [template = constants.%GenericAndParams.7]
// CHECK:STDOUT:   %e.var: ref %GenericAndParams.7 = var e
// CHECK:STDOUT:   %e: ref %GenericAndParams.7 = bind_name e, %e.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @NotGenericNoParams {
// CHECK:STDOUT:   %.loc4: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%NotGenericNoParams
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @NotGenericButParams {
// CHECK:STDOUT:   %.loc5: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%NotGenericButParams.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @GenericAndParams.1(%T.loc6: type) {
// CHECK:STDOUT:   %T.1: type = bind_symbolic_name T 0 [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %.loc6: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%GenericAndParams.2
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(%T.loc8: type) {
// CHECK:STDOUT:   %T.1: type = bind_symbolic_name T 0 [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %GenericAndParams.type: type = generic_class_type @GenericAndParams.2, @C(%T.1) [symbolic = %GenericAndParams.type (constants.%GenericAndParams.type.2)]
// CHECK:STDOUT:   %GenericAndParams: @C.%GenericAndParams.type (%GenericAndParams.type.2) = struct_value () [symbolic = %GenericAndParams (constants.%GenericAndParams.3)]
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %GenericNoParams.decl: type = class_decl @GenericNoParams [template = constants.%GenericNoParams.1] {} {}
// CHECK:STDOUT:     %GenericAndParams.decl: @C.%GenericAndParams.type (%GenericAndParams.type.2) = class_decl @GenericAndParams.2 [symbolic = @C.%GenericAndParams (constants.%GenericAndParams.3)] {
// CHECK:STDOUT:       %U.patt: type = symbolic_binding_pattern U 1
// CHECK:STDOUT:     } {
// CHECK:STDOUT:       %U.param: type = param U, runtime_param<invalid>
// CHECK:STDOUT:       %U.loc10: type = bind_symbolic_name U 1, %U.param [symbolic = %U.1 (constants.%U)]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %.loc11: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%C.2
// CHECK:STDOUT:     .GenericNoParams = %GenericNoParams.decl
// CHECK:STDOUT:     .GenericAndParams = %GenericAndParams.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @GenericNoParams(@C.%T.loc8: type) {
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %.loc9: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%GenericNoParams.2
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @GenericAndParams.2(@C.%T.loc8: type, %U.loc10: type) {
// CHECK:STDOUT:   %U.1: type = bind_symbolic_name U 1 [symbolic = %U.1 (constants.%U)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %.loc10: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%GenericAndParams.4
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @X {
// CHECK:STDOUT:   %.loc13: <witness> = complete_type_witness %.1 [template = constants.%.2]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%X
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %.loc15_30.1: %.1 = struct_literal ()
// CHECK:STDOUT:   %.loc15_30.2: init %NotGenericNoParams = class_init (), file.%a.var [template = constants.%struct.1]
// CHECK:STDOUT:   %.loc15_31: init %NotGenericNoParams = converted %.loc15_30.1, %.loc15_30.2 [template = constants.%struct.1]
// CHECK:STDOUT:   assign file.%a.var, %.loc15_31
// CHECK:STDOUT:   %.loc16_33.1: %.1 = struct_literal ()
// CHECK:STDOUT:   %.loc16_33.2: init %NotGenericButParams.2 = class_init (), file.%b.var [template = constants.%struct.2]
// CHECK:STDOUT:   %.loc16_34: init %NotGenericButParams.2 = converted %.loc16_33.1, %.loc16_33.2 [template = constants.%struct.2]
// CHECK:STDOUT:   assign file.%b.var, %.loc16_34
// CHECK:STDOUT:   %.loc17_31.1: %.1 = struct_literal ()
// CHECK:STDOUT:   %.loc17_31.2: init %GenericAndParams.5 = class_init (), file.%c.var [template = constants.%struct.3]
// CHECK:STDOUT:   %.loc17_32: init %GenericAndParams.5 = converted %.loc17_31.1, %.loc17_31.2 [template = constants.%struct.3]
// CHECK:STDOUT:   assign file.%c.var, %.loc17_32
// CHECK:STDOUT:   %.loc18_32.1: %.1 = struct_literal ()
// CHECK:STDOUT:   %.loc18_32.2: init %GenericNoParams.1 = class_init (), file.%d.var [template = constants.%struct.4]
// CHECK:STDOUT:   %.loc18_33: init %GenericNoParams.1 = converted %.loc18_32.1, %.loc18_32.2 [template = constants.%struct.4]
// CHECK:STDOUT:   assign file.%d.var, %.loc18_33
// CHECK:STDOUT:   %.loc19_36.1: %.1 = struct_literal ()
// CHECK:STDOUT:   %.loc19_36.2: init %GenericAndParams.7 = class_init (), file.%e.var [template = constants.%struct.5]
// CHECK:STDOUT:   %.loc19_37: init %GenericAndParams.7 = converted %.loc19_36.1, %.loc19_36.2 [template = constants.%struct.5]
// CHECK:STDOUT:   assign file.%e.var, %.loc19_37
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @GenericAndParams.1(constants.%T) {
// CHECK:STDOUT:   %T.1 => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%T) {
// CHECK:STDOUT:   %T.1 => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @GenericNoParams(constants.%T) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @GenericAndParams.2(constants.%T, constants.%U) {
// CHECK:STDOUT:   %U.1 => constants.%U
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(@C.%T.1) {
// CHECK:STDOUT:   %T.1 => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @GenericAndParams.1(constants.%X) {
// CHECK:STDOUT:   %T.1 => constants.%X
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%X) {
// CHECK:STDOUT:   %T.1 => constants.%X
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %GenericAndParams.type => constants.%GenericAndParams.type.3
// CHECK:STDOUT:   %GenericAndParams => constants.%GenericAndParams.6
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @GenericAndParams.2(constants.%X, constants.%X) {
// CHECK:STDOUT:   %U.1 => constants.%X
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_non_generic_implicit_params.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %A.type: type = generic_class_type @A [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %A.1: %A.type = struct_value () [template]
// CHECK:STDOUT:   %A.2: type = class_type @A [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .A = %A.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %A.decl: %A.type = class_decl @A [template = constants.%A.1] {
// CHECK:STDOUT:     %T.patt: type = binding_pattern T
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = param T, runtime_param<invalid>
// CHECK:STDOUT:     %T: type = bind_name T, %T.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @A {
// CHECK:STDOUT:   %.loc8: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%A.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_non_generic_params.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %A.type: type = generic_class_type @A [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %A.1: %A.type = struct_value () [template]
// CHECK:STDOUT:   %A.2: type = class_type @A [template]
// CHECK:STDOUT:   %.2: type = struct_type {} [template]
// CHECK:STDOUT:   %.3: <witness> = complete_type_witness %.2 [template]
// CHECK:STDOUT:   %T: type = bind_symbolic_name T 0 [symbolic]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .A = %A.decl
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %A.decl: %A.type = class_decl @A [template = constants.%A.1] {
// CHECK:STDOUT:     %T.patt: type = binding_pattern T
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = param T, runtime_param<invalid>
// CHECK:STDOUT:     %T: type = bind_name T, %T.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %T.patt: type = symbolic_binding_pattern T 0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = param T, runtime_param<invalid>
// CHECK:STDOUT:     %T.loc10: type = bind_symbolic_name T 0, %T.param [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @A {
// CHECK:STDOUT:   %.loc7: <witness> = complete_type_witness %.2 [template = constants.%.3]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%A.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F(%T.loc10: type) {
// CHECK:STDOUT:   %T.1: type = bind_symbolic_name T 0 [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   fn(%T.loc10: type) {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %A.ref: %A.type = name_ref A, file.%A.decl [template = constants.%A.1]
// CHECK:STDOUT:     %T.ref: type = name_ref T, %T.loc10 [symbolic = %T.1 (constants.%T)]
// CHECK:STDOUT:     %A: type = class_type @A [template = constants.%A.2]
// CHECK:STDOUT:     return
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F(constants.%T) {
// CHECK:STDOUT:   %T.1 => constants.%T
// CHECK:STDOUT: }
// CHECK:STDOUT:
