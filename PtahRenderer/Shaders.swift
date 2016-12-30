//
//  Shaders.swift
//  PtahRenderer
//
//  Created by Simon Rodriguez on 16/02/2016.
//  Copyright © 2016 Simon Rodriguez. All rights reserved.
//

import Foundation

protocol Shader {
	var uniforms: [Texture] { get set }
	static func vertexShader(_ v: Point3) -> Point3
	static func fragmentShader(_ p: Point2) -> Color
}


class TestShader: Shader {
	var uniforms: [Texture] = []
	static func vertexShader(_ v: Point3) -> Point3{
		return v
	}
	
	static func fragmentShader(_ p: Point2)-> Color{
		return (255, 255, 255)
	}
}
