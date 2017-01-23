//
//  Matrix.swift
//  PtahRenderer
//
//  Created by Simon Rodriguez on 23/01/2017.
//  Copyright © 2017 Simon Rodriguez. All rights reserved.
//

import Foundation

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
	var matrix: [Scalar] = [
		//0	  1	   2	3
		1.0, 0.0, 0.0, 0.0,
		//4	  5	   6	7
		0.0, 1.0, 0.0, 0.0,
		//8	  9	   10	11
		0.0, 0.0, 1.0, 0.0,
		//12  13   14	15
		0.0, 0.0, 0.0, 1.0
	]
	
	static func translationMatrix(_ t: Point3) -> Matrix4 {
		var matrix = Matrix4()
		matrix.matrix[3] = t.0
		matrix.matrix[7] = t.1
		matrix.matrix[11] = t.2
		return matrix
	}
	
	static func scaleMatrix(_ x: Scalar) -> Matrix4 {
		return Matrix4.scaleMatrix((x, x, x))
	}
	
	static func scaleMatrix(_ s: Point3) -> Matrix4 {
		var matrix = Matrix4()
		matrix.matrix[0] = s.0
		matrix.matrix[5] = s.1
		matrix.matrix[10] = s.2
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
		matrix.matrix[0] = u.0 * u.0 * mc + c
		matrix.matrix[1] = xy - zs
		matrix.matrix[2] = xz + ys
		
		matrix.matrix[4] = xy + zs
		matrix.matrix[5] = u.1 * u.1 * mc + c
		matrix.matrix[6] = yz - xs
		
		matrix.matrix[8] = xz - ys
		matrix.matrix[9] = yz + xs
		matrix.matrix[10] = u.2 * u.2 * mc + c
		return matrix
	}
	
	
	static func lookAtMatrix(eye: Point3, target: Point3, up: Point3) -> Matrix4 {
		var matrix = Matrix4()
		let n = normalized(target - eye)
		var v = normalized(up)
		let u = normalized(cross(n, v))
		v = normalized(cross(u, n))
		matrix.matrix[0] = u.0
		matrix.matrix[1] = u.1
		matrix.matrix[2] = u.2
		
		matrix.matrix[4] = v.0
		matrix.matrix[5] = v.1
		matrix.matrix[6] = v.2
		
		matrix.matrix[8] = -n.0
		matrix.matrix[9] = -n.1
		matrix.matrix[10] = -n.2
		
		matrix.matrix[3] = -dot(u, eye)
		matrix.matrix[7] = -dot(v, eye)
		matrix.matrix[11] = dot(n, eye)
		return matrix
	}
	
	static func perspectiveMatrix(fov: Scalar, aspect: Scalar, near: Scalar, far: Scalar) -> Matrix4 {
		var matrix = Matrix4()
		let radfov = Scalar(M_PI) * fov / 180.0
		let f = 1.0 / tan(radfov / 2.0)
		matrix.matrix[0] = f / aspect
		matrix.matrix[5] = f
		matrix.matrix[10] = (far + near) / (near - far)
		matrix.matrix[14] = -1.0
		matrix.matrix[11] = (2.0 * far * near) / (near - far)
		matrix.matrix[15] = 0.0
		return matrix
	}
	
	static func orthographicMatrix(right: Scalar, top: Scalar, near: Scalar, far: Scalar) -> Matrix4 {
		var matrix = Matrix4()
		matrix.matrix[0] = 1.0 / right
		matrix.matrix[5] = 1.0 / top
		matrix.matrix[10] = 2.0 / (near - far)
		matrix.matrix[11] = (2.0 * far * near) / (near - far)
		return matrix
	}
}

func * (left: Matrix4, right: Matrix4) -> Matrix4 {
	let m1 = left.matrix
	let m2 = right.matrix
	var m = [Scalar](repeating: 0.0, count: 16)
	m[ 0] = m1[ 0]*m2[ 0] + m1[ 1]*m2[ 4] + m1[ 2]*m2[ 8] + m1[ 3]*m2[12]
	m[ 1] = m1[ 0]*m2[ 1] + m1[ 1]*m2[ 5] + m1[ 2]*m2[ 9] + m1[ 3]*m2[13]
	m[ 2] = m1[ 0]*m2[ 2] + m1[ 1]*m2[ 6] + m1[ 2]*m2[10] + m1[ 3]*m2[14]
	m[ 3] = m1[ 0]*m2[ 3] + m1[ 1]*m2[ 7] + m1[ 2]*m2[11] + m1[ 3]*m2[15]
	m[ 4] = m1[ 4]*m2[ 0] + m1[ 5]*m2[ 4] + m1[ 6]*m2[ 8] + m1[ 7]*m2[12]
	m[ 5] = m1[ 4]*m2[ 1] + m1[ 5]*m2[ 5] + m1[ 6]*m2[ 9] + m1[ 7]*m2[13]
	m[ 6] = m1[ 4]*m2[ 2] + m1[ 5]*m2[ 6] + m1[ 6]*m2[10] + m1[ 7]*m2[14]
	m[ 7] = m1[ 4]*m2[ 3] + m1[ 5]*m2[ 7] + m1[ 6]*m2[11] + m1[ 7]*m2[15]
	m[ 8] = m1[ 8]*m2[ 0] + m1[ 9]*m2[ 4] + m1[10]*m2[ 8] + m1[11]*m2[12]
	m[ 9] = m1[ 8]*m2[ 1] + m1[ 9]*m2[ 5] + m1[10]*m2[ 9] + m1[11]*m2[13]
	m[10] = m1[ 8]*m2[ 2] + m1[ 9]*m2[ 6] + m1[10]*m2[10] + m1[11]*m2[14]
	m[11] = m1[ 8]*m2[ 3] + m1[ 9]*m2[ 7] + m1[10]*m2[11] + m1[11]*m2[15]
	m[12] = m1[12]*m2[ 0] + m1[13]*m2[ 4] + m1[14]*m2[ 8] + m1[15]*m2[12]
	m[13] = m1[12]*m2[ 1] + m1[13]*m2[ 5] + m1[14]*m2[ 9] + m1[15]*m2[13]
	m[14] = m1[12]*m2[ 2] + m1[13]*m2[ 6] + m1[14]*m2[10] + m1[15]*m2[14]
	m[15] = m1[12]*m2[ 3] + m1[13]*m2[ 7] + m1[14]*m2[11] + m1[15]*m2[15]
	return Matrix4(matrix: m)
}

func * (left: Matrix4, rhs: Point4) -> Point4 {
	let m1 = left.matrix
	var m : Point4 = (0.0, 0.0, 0.0, 0.0)
	m.0 = m1[ 0]*rhs.0 + m1[ 1]*rhs.1 + m1[ 2]*rhs.2 + m1[ 3]*rhs.3
	m.1 = m1[ 4]*rhs.0 + m1[ 5]*rhs.1 + m1[ 6]*rhs.2 + m1[ 7]*rhs.3
	m.2 = m1[ 8]*rhs.0 + m1[ 9]*rhs.1 + m1[10]*rhs.2 + m1[11]*rhs.3
	m.3 = m1[12]*rhs.0 + m1[13]*rhs.1 + m1[14]*rhs.2 + m1[15]*rhs.3
	return m
}

func transpose(_ m: Matrix4) -> Matrix4{
	let lm = [m.matrix[0], m.matrix[4], m.matrix[8], m.matrix[12],
	          m.matrix[1], m.matrix[5], m.matrix[9], m.matrix[13],
	          m.matrix[2], m.matrix[6], m.matrix[10], m.matrix[14],
	          m.matrix[3], m.matrix[7], m.matrix[11], m.matrix[15]]
	return Matrix4(matrix: lm)
}

func inverse(_ mat: Matrix4) -> Matrix4 {
	var inv = [Scalar](repeating: 0.0, count: 16)
	let m = mat.matrix
	
	inv[0] = m[5]  * m[10] * m[15] -
		m[5]  * m[11] * m[14] -
		m[9]  * m[6]  * m[15] +
		m[9]  * m[7]  * m[14] +
		m[13] * m[6]  * m[11] -
		m[13] * m[7]  * m[10]
	
	inv[4] = -m[4]  * m[10] * m[15] +
		m[4]  * m[11] * m[14] +
		m[8]  * m[6]  * m[15] -
		m[8]  * m[7]  * m[14] -
		m[12] * m[6]  * m[11] +
		m[12] * m[7]  * m[10]
	
	inv[8] = m[4]  * m[9] * m[15] -
		m[4]  * m[11] * m[13] -
		m[8]  * m[5] * m[15] +
		m[8]  * m[7] * m[13] +
		m[12] * m[5] * m[11] -
		m[12] * m[7] * m[9]
	
	inv[12] = -m[4]  * m[9] * m[14] +
		m[4]  * m[10] * m[13] +
		m[8]  * m[5] * m[14] -
		m[8]  * m[6] * m[13] -
		m[12] * m[5] * m[10] +
		m[12] * m[6] * m[9]
	
	inv[1] = -m[1]  * m[10] * m[15] +
		m[1]  * m[11] * m[14] +
		m[9]  * m[2] * m[15] -
		m[9]  * m[3] * m[14] -
		m[13] * m[2] * m[11] +
		m[13] * m[3] * m[10]
	
	inv[5] = m[0]  * m[10] * m[15] -
		m[0]  * m[11] * m[14] -
		m[8]  * m[2] * m[15] +
		m[8]  * m[3] * m[14] +
		m[12] * m[2] * m[11] -
		m[12] * m[3] * m[10]
	
	inv[9] = -m[0]  * m[9] * m[15] +
		m[0]  * m[11] * m[13] +
		m[8]  * m[1] * m[15] -
		m[8]  * m[3] * m[13] -
		m[12] * m[1] * m[11] +
		m[12] * m[3] * m[9]
	
	inv[13] = m[0]  * m[9] * m[14] -
		m[0]  * m[10] * m[13] -
		m[8]  * m[1] * m[14] +
		m[8]  * m[2] * m[13] +
		m[12] * m[1] * m[10] -
		m[12] * m[2] * m[9]
	
	inv[2] = m[1]  * m[6] * m[15] -
		m[1]  * m[7] * m[14] -
		m[5]  * m[2] * m[15] +
		m[5]  * m[3] * m[14] +
		m[13] * m[2] * m[7] -
		m[13] * m[3] * m[6]
	
	inv[6] = -m[0]  * m[6] * m[15] +
		m[0]  * m[7] * m[14] +
		m[4]  * m[2] * m[15] -
		m[4]  * m[3] * m[14] -
		m[12] * m[2] * m[7] +
		m[12] * m[3] * m[6]
	
	inv[10] = m[0]  * m[5] * m[15] -
		m[0]  * m[7] * m[13] -
		m[4]  * m[1] * m[15] +
		m[4]  * m[3] * m[13] +
		m[12] * m[1] * m[7] -
		m[12] * m[3] * m[5]
	
	inv[14] = -m[0]  * m[5] * m[14] +
		m[0]  * m[6] * m[13] +
		m[4]  * m[1] * m[14] -
		m[4]  * m[2] * m[13] -
		m[12] * m[1] * m[6] +
		m[12] * m[2] * m[5]
	
	inv[3] = -m[1] * m[6] * m[11] +
		m[1] * m[7] * m[10] +
		m[5] * m[2] * m[11] -
		m[5] * m[3] * m[10] -
		m[9] * m[2] * m[7] +
		m[9] * m[3] * m[6]
	
	inv[7] = m[0] * m[6] * m[11] -
		m[0] * m[7] * m[10] -
		m[4] * m[2] * m[11] +
		m[4] * m[3] * m[10] +
		m[8] * m[2] * m[7] -
		m[8] * m[3] * m[6]
	
	inv[11] = -m[0] * m[5] * m[11] +
		m[0] * m[7] * m[9] +
		m[4] * m[1] * m[11] -
		m[4] * m[3] * m[9] -
		m[8] * m[1] * m[7] +
		m[8] * m[3] * m[5]
	
	inv[15] = m[0] * m[5] * m[10] -
		m[0] * m[6] * m[9] -
		m[4] * m[1] * m[10] +
		m[4] * m[2] * m[9] +
		m[8] * m[1] * m[6] -
		m[8] * m[2] * m[5]
	
	var det = m[0] * inv[0] + m[1] * inv[4] + m[2] * inv[8] + m[3] * inv[12];
	
	if det == 0.0 {
		fatalError("Non invertible matrix")
	}
	
	det = 1.0 / det
	
	for i in 0..<16 {
		inv[i] *= det
	}
	
	return Matrix4(matrix: inv)
}
