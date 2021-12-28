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

public protocol BuilderType {
    associatedtype Base
    /// This property is the base set by the Builder.
    /// Use it only to set the value and Use the build() function to return it back.
    var base: Base { get set }
}

@dynamicMemberLookup
public protocol AnyBuilderType: BuilderType where Base: Any {
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> Self { get }
}

@dynamicMemberLookup
public protocol AnyObjectBuilderType: BuilderType where Base: AnyObject {
    subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>) -> (Value) -> Self { get }
}

public extension BuilderType {
    /// Returns the value set by the Builder.
    ///
    ///     let array = [""]
    ///         .builder
    ///         .build()
    func build() -> Base {
        return base
    }
}

public extension AnyBuilderType {
    /// Setter function used internally.
    /// Set after copying.
    ///
    ///     extension AnyBuilderType where Base == User {
    ///         func name(_ value: String) -> Self {
    ///             return set(\.name, value: "NAME : \(value)")
    ///         }
    ///     }
    func set<Value>(_ keyPath: WritableKeyPath<Base, Value>, value: Value) -> Self {
        var copy = self
        copy.base[keyPath: keyPath] = value
        return copy
    }
    
    /// By using this function, you can freely set properties with closures after copying.
    ///
    /// It is good to use when the value cannot be set with the setter of the property.
    ///
    ///     let array = [""]
    ///         .builder
    ///         .do {
    ///             $0.append("Hello")
    ///         }
    ///         .build()
    func `do`(_ block: (inout Base) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy.base)
        return copy
    }
}

public extension AnyObjectBuilderType {
    /// Setter function used internally.
    ///
    ///     extension AnyObjectBuilderType where Base: UILabel {
    ///         func font(_ value: UIFont) -> Self {
    ///             return set(\.font, value: value.withSize(15))
    ///         }
    ///     }
    func set<Value>(_ keyPath: ReferenceWritableKeyPath<Base, Value>, value: Value) -> Self {
        base[keyPath: keyPath] = value
        return self
    }
    
    /// By using this function, you can freely set properties with closures.
    ///
    /// It is good to use when the value cannot be set with the setter of the property.
    ///
    ///     let button = UIButton()
    ///         .builder
    ///         .apply {
    ///             $0.setTitle("Hello, World", for: .normal)
    ///             $0.backgroundImage(for: .normal)
    ///         }
    ///         .build()
    func apply(_ block: (Base) throws -> Void) rethrows -> Self {
        try block(base)
        return self
    }
}
