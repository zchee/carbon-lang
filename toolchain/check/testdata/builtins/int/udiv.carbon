// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/builtins/int/udiv.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/builtins/int/udiv.carbon

// --- int_div.carbon

fn Div(a: i32, b: i32) -> i32 = "int.udiv";

var arr: [i32; Div(3, 2)];
let arr_p: [i32; 1]* = &arr;

fn RuntimeCall(a: i32, b: i32) -> i32 {
  return Div(a, b);
}

// --- overflow.carbon

package Overflow;

fn Div(a: i32, b: i32) -> i32 = "int.udiv";
fn Sub(a: i32, b: i32) -> i32 = "int.usub";
fn Negate(a: i32) -> i32 = "int.unegate";

// -0x7FFF_FFFF / -1 is OK.
let a: i32 = Div(Negate(0x7FFF_FFFF), Negate(1));

// -0x8000_0000 / 1 is OK.
let b: i32 = Div(Sub(Negate(0x7FFF_FFFF), 1), 1);

// -0x8000_0000 / -1 is OK.
let c: i32 = Div(Sub(Negate(0x7FFF_FFFF), 1), Negate(1));

// --- fail_div_by_zero.carbon

package FailDivByZero;

fn Div(a: i32, b: i32) -> i32 = "int.udiv";

// CHECK:STDERR: fail_div_by_zero.carbon:[[@LINE+4]]:14: error: division by zero
// CHECK:STDERR: let a: i32 = Div(1, 0);
// CHECK:STDERR:              ^~~~
// CHECK:STDERR:
let a: i32 = Div(1, 0);

// CHECK:STDERR: fail_div_by_zero.carbon:[[@LINE+3]]:14: error: division by zero
// CHECK:STDERR: let b: i32 = Div(0, 0);
// CHECK:STDERR:              ^~~~
let b: i32 = Div(0, 0);

// CHECK:STDOUT: --- int_div.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %Div.type: type = fn_type @Div [template]
// CHECK:STDOUT:   %Div: %Div.type = struct_value () [template]
// CHECK:STDOUT:   %.2: i32 = int_literal 3 [template]
// CHECK:STDOUT:   %.3: i32 = int_literal 2 [template]
// CHECK:STDOUT:   %.4: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %.5: type = array_type %.4, i32 [template]
// CHECK:STDOUT:   %.6: type = ptr_type %.5 [template]
// CHECK:STDOUT:   %RuntimeCall.type: type = fn_type @RuntimeCall [template]
// CHECK:STDOUT:   %RuntimeCall: %RuntimeCall.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int32 = %import_ref
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/as
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Div = %Div.decl
// CHECK:STDOUT:     .arr = %arr
// CHECK:STDOUT:     .arr_p = @__global_init.%arr_p
// CHECK:STDOUT:     .RuntimeCall = %RuntimeCall.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Div.decl: %Div.type = fn_decl @Div [template = constants.%Div] {
// CHECK:STDOUT:     %a.patt: i32 = binding_pattern a
// CHECK:STDOUT:     %b.patt: i32 = binding_pattern b
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int.make_type_32.loc2_11: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc2_11.1: type = value_of_initializer %int.make_type_32.loc2_11 [template = i32]
// CHECK:STDOUT:     %.loc2_11.2: type = converted %int.make_type_32.loc2_11, %.loc2_11.1 [template = i32]
// CHECK:STDOUT:     %a.param: i32 = param a, runtime_param0
// CHECK:STDOUT:     %a: i32 = bind_name a, %a.param
// CHECK:STDOUT:     %int.make_type_32.loc2_19: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc2_19.1: type = value_of_initializer %int.make_type_32.loc2_19 [template = i32]
// CHECK:STDOUT:     %.loc2_19.2: type = converted %int.make_type_32.loc2_19, %.loc2_19.1 [template = i32]
// CHECK:STDOUT:     %b.param: i32 = param b, runtime_param1
// CHECK:STDOUT:     %b: i32 = bind_name b, %b.param
// CHECK:STDOUT:     %int.make_type_32.loc2_27: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc2_27.1: type = value_of_initializer %int.make_type_32.loc2_27 [template = i32]
// CHECK:STDOUT:     %.loc2_27.2: type = converted %int.make_type_32.loc2_27, %.loc2_27.1 [template = i32]
// CHECK:STDOUT:     %return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %int.make_type_32.loc4: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %Div.ref: %Div.type = name_ref Div, %Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %.loc4_20: i32 = int_literal 3 [template = constants.%.2]
// CHECK:STDOUT:   %.loc4_23: i32 = int_literal 2 [template = constants.%.3]
// CHECK:STDOUT:   %int.udiv: init i32 = call %Div.ref(%.loc4_20, %.loc4_23) [template = constants.%.4]
// CHECK:STDOUT:   %.loc4_11.1: type = value_of_initializer %int.make_type_32.loc4 [template = i32]
// CHECK:STDOUT:   %.loc4_11.2: type = converted %int.make_type_32.loc4, %.loc4_11.1 [template = i32]
// CHECK:STDOUT:   %.loc4_25: type = array_type %int.udiv, i32 [template = constants.%.5]
// CHECK:STDOUT:   %arr.var: ref %.5 = var arr
// CHECK:STDOUT:   %arr: ref %.5 = bind_name arr, %arr.var
// CHECK:STDOUT:   %int.make_type_32.loc5: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc5_18: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %.loc5_13.1: type = value_of_initializer %int.make_type_32.loc5 [template = i32]
// CHECK:STDOUT:   %.loc5_13.2: type = converted %int.make_type_32.loc5, %.loc5_13.1 [template = i32]
// CHECK:STDOUT:   %.loc5_19: type = array_type %.loc5_18, i32 [template = constants.%.5]
// CHECK:STDOUT:   %.loc5_20: type = ptr_type %.5 [template = constants.%.6]
// CHECK:STDOUT:   %RuntimeCall.decl: %RuntimeCall.type = fn_decl @RuntimeCall [template = constants.%RuntimeCall] {
// CHECK:STDOUT:     %a.patt: i32 = binding_pattern a
// CHECK:STDOUT:     %b.patt: i32 = binding_pattern b
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int.make_type_32.loc7_19: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc7_19.1: type = value_of_initializer %int.make_type_32.loc7_19 [template = i32]
// CHECK:STDOUT:     %.loc7_19.2: type = converted %int.make_type_32.loc7_19, %.loc7_19.1 [template = i32]
// CHECK:STDOUT:     %a.param: i32 = param a, runtime_param0
// CHECK:STDOUT:     %a: i32 = bind_name a, %a.param
// CHECK:STDOUT:     %int.make_type_32.loc7_27: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc7_27.1: type = value_of_initializer %int.make_type_32.loc7_27 [template = i32]
// CHECK:STDOUT:     %.loc7_27.2: type = converted %int.make_type_32.loc7_27, %.loc7_27.1 [template = i32]
// CHECK:STDOUT:     %b.param: i32 = param b, runtime_param1
// CHECK:STDOUT:     %b: i32 = bind_name b, %b.param
// CHECK:STDOUT:     %int.make_type_32.loc7_35: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc7_35.1: type = value_of_initializer %int.make_type_32.loc7_35 [template = i32]
// CHECK:STDOUT:     %.loc7_35.2: type = converted %int.make_type_32.loc7_35, %.loc7_35.1 [template = i32]
// CHECK:STDOUT:     %return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Div(%a: i32, %b: i32) -> i32 = "int.udiv";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @RuntimeCall(%a: i32, %b: i32) -> i32 {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Div.ref: %Div.type = name_ref Div, file.%Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %a.ref: i32 = name_ref a, %a
// CHECK:STDOUT:   %b.ref: i32 = name_ref b, %b
// CHECK:STDOUT:   %int.udiv: init i32 = call %Div.ref(%a.ref, %b.ref)
// CHECK:STDOUT:   %.loc8_19.1: i32 = value_of_initializer %int.udiv
// CHECK:STDOUT:   %.loc8_19.2: i32 = converted %int.udiv, %.loc8_19.1
// CHECK:STDOUT:   return %.loc8_19.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %arr.ref: ref %.5 = name_ref arr, file.%arr
// CHECK:STDOUT:   %.loc5: %.6 = addr_of %arr.ref
// CHECK:STDOUT:   %arr_p: %.6 = bind_name arr_p, %.loc5
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- overflow.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %Div.type: type = fn_type @Div [template]
// CHECK:STDOUT:   %Div: %Div.type = struct_value () [template]
// CHECK:STDOUT:   %Sub.type: type = fn_type @Sub [template]
// CHECK:STDOUT:   %Sub: %Sub.type = struct_value () [template]
// CHECK:STDOUT:   %Negate.type: type = fn_type @Negate [template]
// CHECK:STDOUT:   %Negate: %Negate.type = struct_value () [template]
// CHECK:STDOUT:   %.2: i32 = int_literal 2147483647 [template]
// CHECK:STDOUT:   %.3: i32 = int_literal -2147483647 [template]
// CHECK:STDOUT:   %.4: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %.5: i32 = int_literal -1 [template]
// CHECK:STDOUT:   %.6: i32 = int_literal 0 [template]
// CHECK:STDOUT:   %.7: i32 = int_literal -2147483648 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int32 = %import_ref
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/as
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Div = %Div.decl
// CHECK:STDOUT:     .Sub = %Sub.decl
// CHECK:STDOUT:     .Negate = %Negate.decl
// CHECK:STDOUT:     .a = @__global_init.%a
// CHECK:STDOUT:     .b = @__global_init.%b
// CHECK:STDOUT:     .c = @__global_init.%c
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Div.decl: %Div.type = fn_decl @Div [template = constants.%Div] {
// CHECK:STDOUT:     %a.patt: i32 = binding_pattern a
// CHECK:STDOUT:     %b.patt: i32 = binding_pattern b
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int.make_type_32.loc4_11: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc4_11.1: type = value_of_initializer %int.make_type_32.loc4_11 [template = i32]
// CHECK:STDOUT:     %.loc4_11.2: type = converted %int.make_type_32.loc4_11, %.loc4_11.1 [template = i32]
// CHECK:STDOUT:     %a.param: i32 = param a, runtime_param0
// CHECK:STDOUT:     %a: i32 = bind_name a, %a.param
// CHECK:STDOUT:     %int.make_type_32.loc4_19: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc4_19.1: type = value_of_initializer %int.make_type_32.loc4_19 [template = i32]
// CHECK:STDOUT:     %.loc4_19.2: type = converted %int.make_type_32.loc4_19, %.loc4_19.1 [template = i32]
// CHECK:STDOUT:     %b.param: i32 = param b, runtime_param1
// CHECK:STDOUT:     %b: i32 = bind_name b, %b.param
// CHECK:STDOUT:     %int.make_type_32.loc4_27: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc4_27.1: type = value_of_initializer %int.make_type_32.loc4_27 [template = i32]
// CHECK:STDOUT:     %.loc4_27.2: type = converted %int.make_type_32.loc4_27, %.loc4_27.1 [template = i32]
// CHECK:STDOUT:     %return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Sub.decl: %Sub.type = fn_decl @Sub [template = constants.%Sub] {
// CHECK:STDOUT:     %a.patt: i32 = binding_pattern a
// CHECK:STDOUT:     %b.patt: i32 = binding_pattern b
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int.make_type_32.loc5_11: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc5_11.1: type = value_of_initializer %int.make_type_32.loc5_11 [template = i32]
// CHECK:STDOUT:     %.loc5_11.2: type = converted %int.make_type_32.loc5_11, %.loc5_11.1 [template = i32]
// CHECK:STDOUT:     %a.param: i32 = param a, runtime_param0
// CHECK:STDOUT:     %a: i32 = bind_name a, %a.param
// CHECK:STDOUT:     %int.make_type_32.loc5_19: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc5_19.1: type = value_of_initializer %int.make_type_32.loc5_19 [template = i32]
// CHECK:STDOUT:     %.loc5_19.2: type = converted %int.make_type_32.loc5_19, %.loc5_19.1 [template = i32]
// CHECK:STDOUT:     %b.param: i32 = param b, runtime_param1
// CHECK:STDOUT:     %b: i32 = bind_name b, %b.param
// CHECK:STDOUT:     %int.make_type_32.loc5_27: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc5_27.1: type = value_of_initializer %int.make_type_32.loc5_27 [template = i32]
// CHECK:STDOUT:     %.loc5_27.2: type = converted %int.make_type_32.loc5_27, %.loc5_27.1 [template = i32]
// CHECK:STDOUT:     %return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Negate.decl: %Negate.type = fn_decl @Negate [template = constants.%Negate] {
// CHECK:STDOUT:     %a.patt: i32 = binding_pattern a
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int.make_type_32.loc6_14: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc6_14.1: type = value_of_initializer %int.make_type_32.loc6_14 [template = i32]
// CHECK:STDOUT:     %.loc6_14.2: type = converted %int.make_type_32.loc6_14, %.loc6_14.1 [template = i32]
// CHECK:STDOUT:     %a.param: i32 = param a, runtime_param0
// CHECK:STDOUT:     %a: i32 = bind_name a, %a.param
// CHECK:STDOUT:     %int.make_type_32.loc6_22: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc6_22.1: type = value_of_initializer %int.make_type_32.loc6_22 [template = i32]
// CHECK:STDOUT:     %.loc6_22.2: type = converted %int.make_type_32.loc6_22, %.loc6_22.1 [template = i32]
// CHECK:STDOUT:     %return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %int.make_type_32.loc9: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc9_8.1: type = value_of_initializer %int.make_type_32.loc9 [template = i32]
// CHECK:STDOUT:   %.loc9_8.2: type = converted %int.make_type_32.loc9, %.loc9_8.1 [template = i32]
// CHECK:STDOUT:   %int.make_type_32.loc12: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc12_8.1: type = value_of_initializer %int.make_type_32.loc12 [template = i32]
// CHECK:STDOUT:   %.loc12_8.2: type = converted %int.make_type_32.loc12, %.loc12_8.1 [template = i32]
// CHECK:STDOUT:   %int.make_type_32.loc15: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc15_8.1: type = value_of_initializer %int.make_type_32.loc15 [template = i32]
// CHECK:STDOUT:   %.loc15_8.2: type = converted %int.make_type_32.loc15, %.loc15_8.1 [template = i32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Div(%a: i32, %b: i32) -> i32 = "int.udiv";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Sub(%a: i32, %b: i32) -> i32 = "int.usub";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Negate(%a: i32) -> i32 = "int.unegate";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Div.ref.loc9: %Div.type = name_ref Div, file.%Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %Negate.ref.loc9_18: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc9_25: i32 = int_literal 2147483647 [template = constants.%.2]
// CHECK:STDOUT:   %int.unegate.loc9_24: init i32 = call %Negate.ref.loc9_18(%.loc9_25) [template = constants.%.3]
// CHECK:STDOUT:   %Negate.ref.loc9_39: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc9_46: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %int.unegate.loc9_45: init i32 = call %Negate.ref.loc9_39(%.loc9_46) [template = constants.%.5]
// CHECK:STDOUT:   %.loc9_17.1: i32 = value_of_initializer %int.unegate.loc9_24 [template = constants.%.3]
// CHECK:STDOUT:   %.loc9_17.2: i32 = converted %int.unegate.loc9_24, %.loc9_17.1 [template = constants.%.3]
// CHECK:STDOUT:   %.loc9_17.3: i32 = value_of_initializer %int.unegate.loc9_45 [template = constants.%.5]
// CHECK:STDOUT:   %.loc9_17.4: i32 = converted %int.unegate.loc9_45, %.loc9_17.3 [template = constants.%.5]
// CHECK:STDOUT:   %int.udiv.loc9: init i32 = call %Div.ref.loc9(%.loc9_17.2, %.loc9_17.4) [template = constants.%.6]
// CHECK:STDOUT:   %.loc9_49.1: i32 = value_of_initializer %int.udiv.loc9 [template = constants.%.6]
// CHECK:STDOUT:   %.loc9_49.2: i32 = converted %int.udiv.loc9, %.loc9_49.1 [template = constants.%.6]
// CHECK:STDOUT:   %a: i32 = bind_name a, %.loc9_49.2
// CHECK:STDOUT:   %Div.ref.loc12: %Div.type = name_ref Div, file.%Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %Sub.ref.loc12: %Sub.type = name_ref Sub, file.%Sub.decl [template = constants.%Sub]
// CHECK:STDOUT:   %Negate.ref.loc12: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc12_29: i32 = int_literal 2147483647 [template = constants.%.2]
// CHECK:STDOUT:   %int.unegate.loc12: init i32 = call %Negate.ref.loc12(%.loc12_29) [template = constants.%.3]
// CHECK:STDOUT:   %.loc12_43: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %.loc12_21.1: i32 = value_of_initializer %int.unegate.loc12 [template = constants.%.3]
// CHECK:STDOUT:   %.loc12_21.2: i32 = converted %int.unegate.loc12, %.loc12_21.1 [template = constants.%.3]
// CHECK:STDOUT:   %int.usub.loc12: init i32 = call %Sub.ref.loc12(%.loc12_21.2, %.loc12_43) [template = constants.%.7]
// CHECK:STDOUT:   %.loc12_47: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %.loc12_17.1: i32 = value_of_initializer %int.usub.loc12 [template = constants.%.7]
// CHECK:STDOUT:   %.loc12_17.2: i32 = converted %int.usub.loc12, %.loc12_17.1 [template = constants.%.7]
// CHECK:STDOUT:   %int.udiv.loc12: init i32 = call %Div.ref.loc12(%.loc12_17.2, %.loc12_47) [template = constants.%.7]
// CHECK:STDOUT:   %.loc12_49.1: i32 = value_of_initializer %int.udiv.loc12 [template = constants.%.7]
// CHECK:STDOUT:   %.loc12_49.2: i32 = converted %int.udiv.loc12, %.loc12_49.1 [template = constants.%.7]
// CHECK:STDOUT:   %b: i32 = bind_name b, %.loc12_49.2
// CHECK:STDOUT:   %Div.ref.loc15: %Div.type = name_ref Div, file.%Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %Sub.ref.loc15: %Sub.type = name_ref Sub, file.%Sub.decl [template = constants.%Sub]
// CHECK:STDOUT:   %Negate.ref.loc15_22: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc15_29: i32 = int_literal 2147483647 [template = constants.%.2]
// CHECK:STDOUT:   %int.unegate.loc15_28: init i32 = call %Negate.ref.loc15_22(%.loc15_29) [template = constants.%.3]
// CHECK:STDOUT:   %.loc15_43: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %.loc15_21.1: i32 = value_of_initializer %int.unegate.loc15_28 [template = constants.%.3]
// CHECK:STDOUT:   %.loc15_21.2: i32 = converted %int.unegate.loc15_28, %.loc15_21.1 [template = constants.%.3]
// CHECK:STDOUT:   %int.usub.loc15: init i32 = call %Sub.ref.loc15(%.loc15_21.2, %.loc15_43) [template = constants.%.7]
// CHECK:STDOUT:   %Negate.ref.loc15_47: %Negate.type = name_ref Negate, file.%Negate.decl [template = constants.%Negate]
// CHECK:STDOUT:   %.loc15_54: i32 = int_literal 1 [template = constants.%.4]
// CHECK:STDOUT:   %int.unegate.loc15_53: init i32 = call %Negate.ref.loc15_47(%.loc15_54) [template = constants.%.5]
// CHECK:STDOUT:   %.loc15_17.1: i32 = value_of_initializer %int.usub.loc15 [template = constants.%.7]
// CHECK:STDOUT:   %.loc15_17.2: i32 = converted %int.usub.loc15, %.loc15_17.1 [template = constants.%.7]
// CHECK:STDOUT:   %.loc15_17.3: i32 = value_of_initializer %int.unegate.loc15_53 [template = constants.%.5]
// CHECK:STDOUT:   %.loc15_17.4: i32 = converted %int.unegate.loc15_53, %.loc15_17.3 [template = constants.%.5]
// CHECK:STDOUT:   %int.udiv.loc15: init i32 = call %Div.ref.loc15(%.loc15_17.2, %.loc15_17.4) [template = constants.%.6]
// CHECK:STDOUT:   %.loc15_57.1: i32 = value_of_initializer %int.udiv.loc15 [template = constants.%.6]
// CHECK:STDOUT:   %.loc15_57.2: i32 = converted %int.udiv.loc15, %.loc15_57.1 [template = constants.%.6]
// CHECK:STDOUT:   %c: i32 = bind_name c, %.loc15_57.2
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_div_by_zero.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Int32.type: type = fn_type @Int32 [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %Int32: %Int32.type = struct_value () [template]
// CHECK:STDOUT:   %Div.type: type = fn_type @Div [template]
// CHECK:STDOUT:   %Div: %Div.type = struct_value () [template]
// CHECK:STDOUT:   %.2: i32 = int_literal 1 [template]
// CHECK:STDOUT:   %.3: i32 = int_literal 0 [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int32 = %import_ref
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/operators
// CHECK:STDOUT:     import Core//prelude/types
// CHECK:STDOUT:     import Core//prelude/operators/arithmetic
// CHECK:STDOUT:     import Core//prelude/operators/as
// CHECK:STDOUT:     import Core//prelude/operators/bitwise
// CHECK:STDOUT:     import Core//prelude/operators/comparison
// CHECK:STDOUT:     import Core//prelude/types/bool
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref: %Int32.type = import_ref Core//prelude/types, inst+4, loaded [template = constants.%Int32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Div = %Div.decl
// CHECK:STDOUT:     .a = @__global_init.%a
// CHECK:STDOUT:     .b = @__global_init.%b
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Div.decl: %Div.type = fn_decl @Div [template = constants.%Div] {
// CHECK:STDOUT:     %a.patt: i32 = binding_pattern a
// CHECK:STDOUT:     %b.patt: i32 = binding_pattern b
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int.make_type_32.loc4_11: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc4_11.1: type = value_of_initializer %int.make_type_32.loc4_11 [template = i32]
// CHECK:STDOUT:     %.loc4_11.2: type = converted %int.make_type_32.loc4_11, %.loc4_11.1 [template = i32]
// CHECK:STDOUT:     %a.param: i32 = param a, runtime_param0
// CHECK:STDOUT:     %a: i32 = bind_name a, %a.param
// CHECK:STDOUT:     %int.make_type_32.loc4_19: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc4_19.1: type = value_of_initializer %int.make_type_32.loc4_19 [template = i32]
// CHECK:STDOUT:     %.loc4_19.2: type = converted %int.make_type_32.loc4_19, %.loc4_19.1 [template = i32]
// CHECK:STDOUT:     %b.param: i32 = param b, runtime_param1
// CHECK:STDOUT:     %b: i32 = bind_name b, %b.param
// CHECK:STDOUT:     %int.make_type_32.loc4_27: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:     %.loc4_27.1: type = value_of_initializer %int.make_type_32.loc4_27 [template = i32]
// CHECK:STDOUT:     %.loc4_27.2: type = converted %int.make_type_32.loc4_27, %.loc4_27.1 [template = i32]
// CHECK:STDOUT:     %return: ref i32 = var <return slot>
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %int.make_type_32.loc10: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc10_8.1: type = value_of_initializer %int.make_type_32.loc10 [template = i32]
// CHECK:STDOUT:   %.loc10_8.2: type = converted %int.make_type_32.loc10, %.loc10_8.1 [template = i32]
// CHECK:STDOUT:   %int.make_type_32.loc15: init type = call constants.%Int32() [template = i32]
// CHECK:STDOUT:   %.loc15_8.1: type = value_of_initializer %int.make_type_32.loc15 [template = i32]
// CHECK:STDOUT:   %.loc15_8.2: type = converted %int.make_type_32.loc15, %.loc15_8.1 [template = i32]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Int32() -> type = "int.make_type_32";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Div(%a: i32, %b: i32) -> i32 = "int.udiv";
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %Div.ref.loc10: %Div.type = name_ref Div, file.%Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %.loc10_18: i32 = int_literal 1 [template = constants.%.2]
// CHECK:STDOUT:   %.loc10_21: i32 = int_literal 0 [template = constants.%.3]
// CHECK:STDOUT:   %int.udiv.loc10: init i32 = call %Div.ref.loc10(%.loc10_18, %.loc10_21) [template = <error>]
// CHECK:STDOUT:   %.loc10_23.1: i32 = value_of_initializer %int.udiv.loc10 [template = <error>]
// CHECK:STDOUT:   %.loc10_23.2: i32 = converted %int.udiv.loc10, %.loc10_23.1 [template = <error>]
// CHECK:STDOUT:   %a: i32 = bind_name a, %.loc10_23.2
// CHECK:STDOUT:   %Div.ref.loc15: %Div.type = name_ref Div, file.%Div.decl [template = constants.%Div]
// CHECK:STDOUT:   %.loc15_18: i32 = int_literal 0 [template = constants.%.3]
// CHECK:STDOUT:   %.loc15_21: i32 = int_literal 0 [template = constants.%.3]
// CHECK:STDOUT:   %int.udiv.loc15: init i32 = call %Div.ref.loc15(%.loc15_18, %.loc15_21) [template = <error>]
// CHECK:STDOUT:   %.loc15_23.1: i32 = value_of_initializer %int.udiv.loc15 [template = <error>]
// CHECK:STDOUT:   %.loc15_23.2: i32 = converted %int.udiv.loc15, %.loc15_23.1 [template = <error>]
// CHECK:STDOUT:   %b: i32 = bind_name b, %.loc15_23.2
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
