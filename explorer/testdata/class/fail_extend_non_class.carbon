// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

class C {
  // CHECK:STDERR: COMPILATION ERROR: fail_extend_non_class.carbon:[[@LINE+1]]: type error in type expression: 'i32' is not implicitly convertible to 'type'
  extend base: 3;
  var x: i32;
  var y: i32;
}

fn Main() -> i32 {
  return 0;
}
