// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/function/declaration/no_prelude/fail_redecl.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/function/declaration/no_prelude/fail_redecl.carbon

fn A();
// CHECK:STDERR: fail_redecl.carbon:[[@LINE+7]]:1: error: redeclaration of `fn A` is redundant
// CHECK:STDERR: fn A();
// CHECK:STDERR: ^~~~~~~
// CHECK:STDERR: fail_redecl.carbon:[[@LINE-4]]:1: note: previously declared here
// CHECK:STDERR: fn A();
// CHECK:STDERR: ^~~~~~~
// CHECK:STDERR:
fn A();

fn B(x: ());
// CHECK:STDERR: fail_redecl.carbon:[[@LINE+7]]:1: error: redeclaration of `fn B` is redundant
// CHECK:STDERR: fn B(x: ());
// CHECK:STDERR: ^~~~~~~~~~~~
// CHECK:STDERR: fail_redecl.carbon:[[@LINE-4]]:1: note: previously declared here
// CHECK:STDERR: fn B(x: ());
// CHECK:STDERR: ^~~~~~~~~~~~
// CHECK:STDERR:
fn B(x: ());

fn C();
// CHECK:STDERR: fail_redecl.carbon:[[@LINE+7]]:1: error: redeclaration differs because of parameter count of 1
// CHECK:STDERR: fn C(x: ());
// CHECK:STDERR: ^~~~~~~~~~~~
// CHECK:STDERR: fail_redecl.carbon:[[@LINE-4]]:1: note: previously declared with parameter count of 0
// CHECK:STDERR: fn C();
// CHECK:STDERR: ^~~~~~~
// CHECK:STDERR:
fn C(x: ());

fn D() {}
// CHECK:STDERR: fail_redecl.carbon:[[@LINE+7]]:1: error: redeclaration of `fn D` is redundant
// CHECK:STDERR: fn D();
// CHECK:STDERR: ^~~~~~~
// CHECK:STDERR: fail_redecl.carbon:[[@LINE-4]]:1: note: previously declared here
// CHECK:STDERR: fn D() {}
// CHECK:STDERR: ^~~~~~~~
// CHECK:STDERR:
fn D();

fn E() {}
// CHECK:STDERR: fail_redecl.carbon:[[@LINE+6]]:1: error: redefinition of `fn E`
// CHECK:STDERR: fn E() {}
// CHECK:STDERR: ^~~~~~~~
// CHECK:STDERR: fail_redecl.carbon:[[@LINE-4]]:1: note: previously defined here
// CHECK:STDERR: fn E() {}
// CHECK:STDERR: ^~~~~~~~
fn E() {}

// CHECK:STDOUT: --- fail_redecl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %A.type: type = fn_type @A [template]
// CHECK:STDOUT:   %.1: type = tuple_type () [template]
// CHECK:STDOUT:   %A: %A.type = struct_value () [template]
// CHECK:STDOUT:   %B.type: type = fn_type @B [template]
// CHECK:STDOUT:   %B: %B.type = struct_value () [template]
// CHECK:STDOUT:   %C.type: type = fn_type @C [template]
// CHECK:STDOUT:   %C: %C.type = struct_value () [template]
// CHECK:STDOUT:   %.type: type = fn_type @.1 [template]
// CHECK:STDOUT:   %.2: %.type = struct_value () [template]
// CHECK:STDOUT:   %D.type: type = fn_type @D [template]
// CHECK:STDOUT:   %D: %D.type = struct_value () [template]
// CHECK:STDOUT:   %E.type: type = fn_type @E [template]
// CHECK:STDOUT:   %E: %E.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .A = %A.decl.loc11
// CHECK:STDOUT:     .B = %B.decl.loc21
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .D = %D.decl.loc41
// CHECK:STDOUT:     .E = %E.decl.loc51
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %A.decl.loc11: %A.type = fn_decl @A [template = constants.%A] {} {}
// CHECK:STDOUT:   %A.decl.loc19: %A.type = fn_decl @A [template = constants.%A] {} {}
// CHECK:STDOUT:   %B.decl.loc21: %B.type = fn_decl @B [template = constants.%B] {
// CHECK:STDOUT:     %x.patt: %.1 = binding_pattern x
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %.loc21_10.1: %.1 = tuple_literal ()
// CHECK:STDOUT:     %.loc21_10.2: type = converted %.loc21_10.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:     %x.param.loc21: %.1 = param x, runtime_param0
// CHECK:STDOUT:     %x.loc21: %.1 = bind_name x, %x.param.loc21
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %B.decl.loc29: %B.type = fn_decl @B [template = constants.%B] {
// CHECK:STDOUT:     %x.patt: %.1 = binding_pattern x
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %.loc29_10.1: %.1 = tuple_literal ()
// CHECK:STDOUT:     %.loc29_10.2: type = converted %.loc29_10.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:     %x.param.loc29: %.1 = param x, runtime_param0
// CHECK:STDOUT:     %x.loc29: %.1 = bind_name x, %x.param.loc29
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %C.decl: %C.type = fn_decl @C [template = constants.%C] {} {}
// CHECK:STDOUT:   %.decl: %.type = fn_decl @.1 [template = constants.%.2] {
// CHECK:STDOUT:     %x.patt: %.1 = binding_pattern x
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %.loc39_10.1: %.1 = tuple_literal ()
// CHECK:STDOUT:     %.loc39_10.2: type = converted %.loc39_10.1, constants.%.1 [template = constants.%.1]
// CHECK:STDOUT:     %x.param: %.1 = param x, runtime_param0
// CHECK:STDOUT:     %x: %.1 = bind_name x, %x.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %D.decl.loc41: %D.type = fn_decl @D [template = constants.%D] {} {}
// CHECK:STDOUT:   %D.decl.loc49: %D.type = fn_decl @D [template = constants.%D] {} {}
// CHECK:STDOUT:   %E.decl.loc51: %E.type = fn_decl @E [template = constants.%E] {} {}
// CHECK:STDOUT:   %E.decl.loc58: %E.type = fn_decl @E [template = constants.%E] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @A();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @B(%x.loc21: %.1);
// CHECK:STDOUT:
// CHECK:STDOUT: fn @C();
// CHECK:STDOUT:
// CHECK:STDOUT: fn @.1(%x: %.1);
// CHECK:STDOUT:
// CHECK:STDOUT: fn @D() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @E() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT:
// CHECK:STDOUT: !.loc58:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
