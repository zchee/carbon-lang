// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

__mixin M1 {
  fn Scale10[self: Self](x:i32) -> i32{
     return x * 10;
  }
}

__mixin M2 {
  __mix M1;
  fn Square[self: Self](x:i32) -> i32{
    return x * x;
  }
}

class C {
  __mix M2;
}

fn Main() -> i32 {
  var c: C = {};
  return c.Square(11) - c.Scale10(10) - 21;
}

// CHECK:STDOUT: result: 0
