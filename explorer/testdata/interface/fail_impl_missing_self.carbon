// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

interface I {
  fn G[self: Self]();
}

class C {
  impl as I {
    // CHECK:STDERR: COMPILATION ERROR: fail_impl_missing_self.carbon:[[@LINE+3]]: type error in member of implementation
    // CHECK:STDERR: expected: fn [self: class C]() -> ()
    // CHECK:STDERR: actual: fn () -> ()
    fn G() { }
  }
}

fn Main() -> i32 {
  return 0;
}
