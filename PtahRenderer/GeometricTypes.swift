//
//  GeometricTypes.swift
//  PtahRenderer
//
//  Created by Simon Rodriguez on 14/02/2016.
//  Copyright © 2016 Simon Rodriguez. All rights reserved.
//

import Foundation

typealias Point4 = (Scalar, Scalar, Scalar, Scalar)
typealias Point3 = (Scalar, Scalar, Scalar)
typealias Point2 = (Scalar, Scalar)
typealias Vertex = Point3
typealias Normal = Point3
typealias UV = Point2

import simd

/*--Point2--------*/

func +(lhs: Point2, rhs: Point2) -> Point2 {
	return (lhs.0 + rhs.0, lhs.1+rhs.1)
}

func +=(lhs: inout Point2, rhs: Point2) {
	lhs.0 += rhs.0
	lhs.1 += rhs.1
}

func -(lhs: Point2, rhs: Point2) -> Point2 {
	return (lhs.0 - rhs.0, lhs.1-rhs.1)
}

func -=(lhs: inout Point2, rhs: Point2) {
	lhs.0 -= rhs.0
	lhs.1 -= rhs.1
}

func *(lhs: Scalar, rhs: Point2) -> Point2 {
	return (lhs*rhs.0, lhs*rhs.1)
}

func *(rhs: Point2, lhs: Scalar) -> Point2 {
	return (lhs*rhs.0, lhs*rhs.1)
}

func *=(lhs: inout Point2, rhs: Scalar){
	lhs.0 = lhs.0*rhs
	lhs.1 = lhs.1*rhs
}

func /(rhs: Point2, lhs: Scalar) -> Point2 {
	return (rhs.0/lhs, rhs.1/lhs)
}

func /=(lhs: inout Point2, rhs: Scalar){
	lhs.0 = lhs.0/rhs
	lhs.1 = lhs.1/rhs
}

/*--Point3--------*/

func +(lhs: Point3, rhs: Point3) -> Point3 {
	return (lhs.0 + rhs.0, lhs.1+rhs.1, lhs.2+rhs.2)
}

func +=(lhs: inout Point3, rhs: Point3) {
	lhs.0 += rhs.0
	lhs.1 += rhs.1
	lhs.2 += rhs.2
}

func -(lhs: Point3, rhs: Point3) -> Point3 {
	return (lhs.0 - rhs.0, lhs.1-rhs.1, lhs.2-rhs.2)
}

func -=(lhs: inout Point3, rhs: Point3) {
	lhs.0 -= rhs.0
	lhs.1 -= rhs.1
	lhs.2 -= rhs.2
}

func *(lhs: Scalar, rhs: Point3) -> Point3 {
	return (lhs*rhs.0, lhs*rhs.1, lhs*rhs.2)
}

func *(rhs: Point3, lhs: Scalar) -> Point3 {
	return (lhs*rhs.0, lhs*rhs.1, lhs*rhs.2)
}

func *=(lhs: inout Point3, rhs: Scalar){
	lhs.0 = lhs.0*rhs
	lhs.1 = lhs.1*rhs
	lhs.2 = lhs.2*rhs
}

func /(rhs: Point3, lhs: Scalar) -> Point3 {
	return (rhs.0/lhs, rhs.1/lhs, rhs.2/lhs)
}

func /=(lhs: inout Point3, rhs: Scalar){
	lhs.0 = lhs.0/rhs
	lhs.1 = lhs.1/rhs
	lhs.2 = lhs.2/rhs
}


func cross(_ lhs: Point3, _ rhs: Point3) -> Point3 {
	return (lhs.1*rhs.2 - lhs.2*rhs.1, lhs.2*rhs.0 - lhs.0*rhs.2, lhs.0*rhs.1 - lhs.1*rhs.0)
}

func dot(_ lhs: Point3, _ rhs: Point3) -> Scalar {
	return lhs.0*rhs.0+lhs.1*rhs.1+lhs.2*rhs.2
}

func norm(_ lhs: Point3) -> Scalar {
	return sqrt(dot(lhs, lhs))
}

func norm2(_ lhs: Point3) -> Scalar {
	return dot(lhs, lhs)
}

func normalize(_ n: inout Point3){
	let norm = sqrt(dot(n, n))
	if(norm==0.0){ return }
	n /= norm
}

func normalized(_ n: Point3) -> Point3 {
	let norm = sqrt(dot(n, n))
	if(norm==0.0){ return n}
	return n/norm
}

/*--Point4--------*/

func +(lhs: Point4, rhs: Point4) -> Point4 {
	return (lhs.0 + rhs.0, lhs.1+rhs.1, lhs.2+rhs.2, lhs.3+rhs.3)
}

func +=(lhs: inout Point4, rhs: Point4) {
	lhs.0 += rhs.0
	lhs.1 += rhs.1
	lhs.2 += rhs.2
	lhs.3 += rhs.3
}

func -(lhs: Point4, rhs: Point4) -> Point4 {
	return (lhs.0 - rhs.0, lhs.1-rhs.1, lhs.2-rhs.2, lhs.3-rhs.3)
}

func -=(lhs: inout Point4, rhs: Point4) {
	lhs.0 -= rhs.0
	lhs.1 -= rhs.1
	lhs.2 -= rhs.2
	lhs.3 -= rhs.3
}

func *(lhs: Scalar, rhs: Point4) -> Point4 {
	return (lhs*rhs.0, lhs*rhs.1, lhs*rhs.2, lhs*rhs.3)
}

func *(rhs: Point4, lhs: Scalar) -> Point4 {
	return (lhs*rhs.0, lhs*rhs.1, lhs*rhs.2, lhs*rhs.3)
}

func *=(lhs: inout Point4, rhs: Scalar){
	lhs.0 = lhs.0*rhs
	lhs.1 = lhs.1*rhs
	lhs.2 = lhs.2*rhs
	lhs.3 = lhs.3*rhs
}

func /(rhs: Point4, lhs: Scalar) -> Point4 {
	return (rhs.0/lhs, rhs.1/lhs, rhs.2/lhs, rhs.3/lhs)
}

func /=(lhs: inout Point4, rhs: Scalar){
	lhs.0 = lhs.0/rhs
	lhs.1 = lhs.1/rhs
	lhs.2 = lhs.2/rhs
	lhs.2 = lhs.3/rhs
}

/*--Matrix4------------*/
/*
* Copyright (C) 2015 Josh A. Beam
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*   1. Redistributions of source code must retain the above copyright
*      notice, this list of conditions and the following disclaimer.
*   2. Redistributions in binary form must reproduce the above copyright
*      notice, this list of conditions and the following disclaimer in the
*      documentation and/or other materials provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
* IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
* IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
* OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, * WHETHER IN CONTACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
* OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


struct Matrix4 {
	/*var matrix: [Scalar] = [
		//0	  1	   2	3
		1.0, 0.0, 0.0, 0.0, 		
		//4	  5	   6	7
		0.0, 1.0, 0.0, 0.0, 		
		//8	  9	   10	11
		0.0, 0.0, 1.0, 0.0, 		
		//12  13   14	15
		0.0, 0.0, 0.0, 1.0
	]*/
	var matrix : float4x4 = float4x4(diagonal: float4(1.0,1.0,1.0,1.0))
	
	
	static func translationMatrix(_ t: Point3) -> Matrix4 {
		var matrix = Matrix4()
		matrix.matrix[0][3] = t.0
		matrix.matrix[1][3] = t.1
		matrix.matrix[2][3] = t.2
		return matrix
	}
	
	static func scaleMatrix(_ x: Scalar) -> Matrix4 {
		return Matrix4.scaleMatrix((x, x, x))
	}
	
	static func scaleMatrix(_ s: Point3) -> Matrix4 {
		var matrix = Matrix4()
		matrix.matrix[0][0] = s.0
		matrix.matrix[1][1] = s.1
		matrix.matrix[2][2] = s.2
		return matrix
	}
	
	static func rotationMatrix(angle: Scalar, axis: Point3) -> Matrix4 {
		var matrix = Matrix4()
		let u = normalized(axis)
		let c = cos(angle)
		let mc = 1.0 - c
		let s = sin(angle)
		
		let xy = u.0 * u.1 * mc
		let xz = u.0 * u.2 * mc
		let yz = u.1 * u.2 * mc
		let xs = u.0 * s
		let ys = u.1 * s
		let zs = u.2 * s
		matrix.matrix[0][0] = u.0 * u.0 * mc + c
		matrix.matrix[0][1] = xy - zs
		matrix.matrix[0][2] = xz + ys
		
		matrix.matrix[1][0] = xy + zs
		matrix.matrix[1][1] = u.1 * u.1 * mc + c
		matrix.matrix[1][2] = yz - xs
		
		matrix.matrix[2][0] = xz - ys
		matrix.matrix[2][1] = yz + xs
		matrix.matrix[2][2] = u.2 * u.2 * mc + c
		return matrix
	}

	
	static func lookAtMatrix(eye: Point3, target: Point3, up: Point3) -> Matrix4 {
		var matrix = Matrix4()
		let n = normalized(target - eye)
		var v = normalized(up)
		let u = normalized(cross(n, v))
		v = normalized(cross(u, n))
		matrix.matrix[0][0] = u.0
		matrix.matrix[0][1] = u.1
		matrix.matrix[0][2] = u.2
		
		matrix.matrix[1][0] = v.0
		matrix.matrix[1][1] = v.1
		matrix.matrix[1][2] = v.2
		
		matrix.matrix[2][0] = -n.0
		matrix.matrix[2][1] = -n.1
		matrix.matrix[2][2] = -n.2
		
		matrix.matrix[0][3] = -dot(u, eye)
		matrix.matrix[1][3] = -dot(v, eye)
		matrix.matrix[2][3] = dot(n, eye)
		return matrix
	}
	
	static func perspectiveMatrix(fov: Scalar, aspect: Scalar, near: Scalar, far: Scalar) -> Matrix4 {
		var matrix = Matrix4()
		let radfov = Scalar(M_PI) * fov / 180.0
		let f = 1.0 / tan(radfov / 2.0)
		matrix.matrix[0][0] = f / aspect
		matrix.matrix[1][1] = f
		matrix.matrix[2][2] = (far + near) / (near - far)
		matrix.matrix[3][2] = -1.0
		matrix.matrix[2][3] = (2.0 * far * near) / (near - far)
		matrix.matrix[3][3] = 0.0
		return matrix
	}
}

func * (left: Matrix4, right: Matrix4) -> Matrix4 {
	let m1 = left.matrix
	let m2 = right.matrix
	var m = float4x4()
	m[0][0] = m1[0][0]*m2[0][0] + m1[0][1]*m2[1][0] + m1[0][2]*m2[2][0] + m1[0][3]*m2[3][0]
	m[0][1] = m1[0][0]*m2[0][1] + m1[0][1]*m2[1][1] + m1[0][2]*m2[2][1] + m1[0][3]*m2[3][1]
	m[0][2] = m1[0][0]*m2[0][2] + m1[0][1]*m2[1][2] + m1[0][2]*m2[2][2] + m1[0][3]*m2[3][2]
	m[0][3] = m1[0][0]*m2[0][3] + m1[0][1]*m2[1][3] + m1[0][2]*m2[2][3] + m1[0][3]*m2[3][3]
	m[1][0] = m1[1][0]*m2[0][0] + m1[1][1]*m2[1][0] + m1[1][2]*m2[2][0] + m1[1][3]*m2[3][0]
	m[1][1] = m1[1][0]*m2[0][1] + m1[1][1]*m2[1][1] + m1[1][2]*m2[2][1] + m1[1][3]*m2[3][1]
	m[1][2] = m1[1][0]*m2[0][2] + m1[1][1]*m2[1][2] + m1[1][2]*m2[2][2] + m1[1][3]*m2[3][2]
	m[1][3] = m1[1][0]*m2[0][3] + m1[1][1]*m2[1][3] + m1[1][2]*m2[2][3] + m1[1][3]*m2[3][3]
	m[2][0] = m1[2][0]*m2[0][0] + m1[2][1]*m2[1][0] + m1[2][2]*m2[2][0] + m1[2][3]*m2[3][0]
	m[2][1] = m1[2][0]*m2[0][1] + m1[2][1]*m2[1][1] + m1[2][2]*m2[2][1] + m1[2][3]*m2[3][1]
	m[2][2] = m1[2][0]*m2[0][2] + m1[2][1]*m2[1][2] + m1[2][2]*m2[2][2] + m1[2][3]*m2[3][2]
	m[2][3] = m1[2][0]*m2[0][3] + m1[2][1]*m2[1][3] + m1[2][2]*m2[2][3] + m1[2][3]*m2[3][3]
	m[3][0] = m1[3][0]*m2[0][0] + m1[3][1]*m2[1][0] + m1[3][2]*m2[2][0] + m1[3][3]*m2[3][0]
	m[3][1] = m1[3][0]*m2[0][1] + m1[3][1]*m2[1][1] + m1[3][2]*m2[2][1] + m1[3][3]*m2[3][1]
	m[3][2] = m1[3][0]*m2[0][2] + m1[3][1]*m2[1][2] + m1[3][2]*m2[2][2] + m1[3][3]*m2[3][2]
	m[3][3] = m1[3][0]*m2[0][3] + m1[3][1]*m2[1][3] + m1[3][2]*m2[2][3] + m1[3][3]*m2[3][3]
	return Matrix4(matrix: m)
}

func * (left: Matrix4, rhs: Point4) -> Point4 {
	let m1 = left.matrix
	var m : Point4 = (0.0, 0.0, 0.0, 0.0)
	m.0 = m1[0][0]*rhs.0 + m1[0][1]*rhs.1 + m1[0][2]*rhs.2 + m1[0][3]*rhs.3
	m.1 = m1[1][0]*rhs.0 + m1[1][1]*rhs.1 + m1[1][2]*rhs.2 + m1[1][3]*rhs.3
	m.2 = m1[2][0]*rhs.0 + m1[2][1]*rhs.1 + m1[2][2]*rhs.2 + m1[2][3]*rhs.3
	m.3 = m1[3][0]*rhs.0 + m1[3][1]*rhs.1 + m1[3][2]*rhs.2 + m1[3][3]*rhs.3
	return m
}
