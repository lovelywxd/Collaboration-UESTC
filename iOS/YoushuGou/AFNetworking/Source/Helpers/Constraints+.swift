//
//  Constraints+.swift
//  FaveButton
//
// Copyright © 2016 Jansel Valentin.
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

import UIKit


struct Constraint{
    var identifier: String?
    
    var attribute: NSLayoutAttribute = .CenterX
    var secondAttribute: NSLayoutAttribute = .NotAnAttribute
    var constant: CGFloat = 0
    var multiplier: CGFloat = 1
    var relation: NSLayoutRelation = .Equal
}

func attributes(attrs:NSLayoutAttribute...) -> [NSLayoutAttribute]{
    return attrs
}

infix operator >>- { associativity left precedence 160 }


func >>- <T: UIView> (lhs: (T,T), @noescape apply: (inout Constraint) -> () ) -> NSLayoutConstraint {
    var const = Constraint()
    apply(&const)
    
    const.secondAttribute = .NotAnAttribute == const.secondAttribute ? const.attribute : const.secondAttribute
    
    let constraint = NSLayoutConstraint(item: lhs.0,
                                        attribute: const.attribute,
                                        relatedBy: const.relation,
                                        toItem: lhs.1,
                                        attribute: const.secondAttribute,
                                        multiplier: const.multiplier,
                                        constant: const.constant)
    
    constraint.identifier = const.identifier
    
    NSLayoutConstraint.activateConstraints([constraint])
    return constraint
}


func >>- <T: UIView> (lhs: T, @noescape apply: (inout Constraint) -> () ) -> NSLayoutConstraint {
    var const = Constraint()
    apply(&const)
    
    let constraint = NSLayoutConstraint(item: lhs,
                                        attribute: const.attribute,
                                        relatedBy: const.relation,
                                        toItem: nil,
                                        attribute: const.attribute,
                                        multiplier: const.multiplier,
                                        constant: const.constant)
    constraint.identifier = const.identifier
    
    NSLayoutConstraint.activateConstraints([constraint])
    return constraint
}



func >>- <T:UIView> (lhs: (T,T),attributes: [NSLayoutAttribute]){
    for attribute in attributes{
        lhs >>- {(inout s:Constraint)->() in s.attribute = attribute}

//        lhs >>- {
//            $0.attribute = attribute
//        }
    }
}


func >>- <T:UIView> (lhs: T, attributes: [NSLayoutAttribute]){
    for attribute in attributes{
//        lhs >>- {
////            $0.attribute = attribute
//        }
        lhs >>- {(inout s:Constraint)->() in s.attribute = attribute}
    }
}

