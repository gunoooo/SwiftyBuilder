// The MIT License (MIT)
//
// Copyright (c) 2021 rjsdnqkr1 <rjsdnqkr1@naver.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// How to swifty implement the Builder pattern.
///
/// # before
///     let view: UIView = {
///         var view = UIView()
///         view.backgroundColor = .black
///         return view
///     }()
///
/// # after
///     let view = UIView()
/// `       .builder
///         .backgroundColor(.black)
///         .build()
@dynamicMemberLookup
public struct Builder<Base>: BuilderType {
    public var base: Base
}

extension Builder: AnyBuilderType where Base: Any {
    /// It takes a reference key path as an argument and returns a closure.
    /// If Value is entered as the argument of the closure, the property is changed to the argument after copying.
    ///
    ///     let view = User()
    /// `       .builder
    ///         .name("user")
    ///         .build()
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> Self {
        { value in
            return set(keyPath, value: value)
        }
    }
}

extension Builder: AnyObjectBuilderType where Base: AnyObject {
    /// It takes a reference key path as an argument and returns a closure.
    /// If Value is entered as the argument of the closure, the property is changed to the argument.
    ///
    ///     let view = UIView()
    /// `       .builder
    ///         .alpha(.zero)
    ///         .backgroundColor(.black)
    ///         .build()
    public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>) -> (Value) -> Self {
        { value in
            return set(keyPath, value: value)
        }
    }
}

public extension Buildable {
    /// Wrap to Builder.
    var builder: Builder<Self> {
        Builder(base: self)
    }
}
