// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

interface A {
  // TODO: Use `let T:! type;` here once we support it.
  fn T();
}

impl i32 as A {
  // CHECK:STDERR: SYNTAX ERROR: fail_bad_member_kind.carbon:[[@LINE+1]]: syntax error, unexpected CLASS
  class T {}
}

fn Main() -> i32 { return 0; }
