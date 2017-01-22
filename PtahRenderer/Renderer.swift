//
//  Renderer.swift
//  PtahRenderer
//
//  Created by Simon Rodriguez on 29/12/2016.
//  Copyright © 2016 Simon Rodriguez. All rights reserved.
//

import Foundation

#if os(OSX)
import Cocoa
#endif

#if os (Linux)
let rootDir = NSFileManager.defaultManager().currentDirectoryPath + "/data/"
#else
let rootDir = "/Developer/Graphics/PtahRenderer/data/"
#endif

struct Camera {
	var position: Vertex
	var center: Vertex
	var up: Vertex
	var view: Matrix4
	let projection: Matrix4
	
	init(position: Vertex, center: Vertex, up: Vertex, projection: Matrix4) {
		self.position = position
		self.center = center
		self.up = up
		self.view = Matrix4.lookAtMatrix(eye: position, target: center, up: up)
		self.projection = projection
	}
	
	mutating func update() {
		view = Matrix4.lookAtMatrix(eye: position, target: center, up: up)
	}
}

final class Renderer {
	
	private var width = 256
	private var height = 256
	
	private var internalRenderer: InternalRenderer
	
	private var time : Scalar = 0.0
	private var camera: Camera
	
	private let dragon: Object
	private let floor: Object
	private let monkey: Object
	private let cubemap: Object
	
	init(width _width: Int, height _height: Int){
		width = _width
		height = _height
		
		internalRenderer = InternalRenderer(width: width, height: height)
		//internalRenderer.mode = .wireframe
		
		var baseName = "dragon"
		dragon = Object(meshPath: rootDir + "models/" + baseName + ".obj", textureNames: ["texture"], texturePaths: [rootDir + "textures/" + baseName + ".png"])
		baseName = "floor"
		floor = Object(meshPath: rootDir + "models/" + baseName + ".obj"
			, textureNames: ["texture"], texturePaths: [rootDir + "textures/" + baseName + ".png"])
		baseName = "monkey"
		monkey = Object(meshPath: rootDir + "models/" + baseName + ".obj"
			, textureNames: ["texture"], texturePaths: [rootDir + "textures/" + baseName + ".png"])
		baseName = "cubemap"
		cubemap = Object(meshPath: rootDir + "models/" + baseName + ".obj", program: SkyboxProgram()
			, textureNames: ["texture"], texturePaths: [rootDir + "textures/" + baseName + ".png"])
		
		dragon.model =  Matrix4.translationMatrix((-0.25,0.1,-0.25)) * Matrix4.scaleMatrix(0.75)
		floor.model = Matrix4.translationMatrix((0.0,-0.5,0.0)) * Matrix4.scaleMatrix(2.0)
		monkey.model =  Matrix4.translationMatrix((0.5,0.0,0.5)) * Matrix4.scaleMatrix(0.5)
		cubemap.model = Matrix4.scaleMatrix(5.0)
		
		let proj = Matrix4.perspectiveMatrix(fov:70.0, aspect: Scalar(width)/Scalar(height), near: 0.1, far: 100.0)
		let initialPos = 2.0*normalized((0.0, 0.5, 1.0))
		camera = Camera(position: initialPos, center: (0.0, 0.0, 0.0), up: (0.0, 1.0, 0.0), projection: proj)
		
		
	}
	
	
	func update(elapsed: Scalar){
		let theta : Float = 3.14159*time*0.1
		camera.position =  2.0*normalized((cos(theta), 0.5, sin(theta)))
		camera.update()
		let mv = camera.projection*camera.view
		
		let mvpDragon = mv*dragon.model
		dragon.program.register(name: "mvp", value: mvpDragon)
		dragon.program.register(name: "mv", value: camera.view)
		let mvpFloor = mv*floor.model
		floor.program.register(name: "mvp", value: mvpFloor)
		floor.program.register(name: "mv", value: camera.view)
		monkey.model = Matrix4.translationMatrix((0.5,0.0,0.5)) * Matrix4.scaleMatrix(0.4) * Matrix4.rotationMatrix(angle: time, axis: (0.0,1.0,0.0))
		let mvpMonkey = mv*monkey.model
		monkey.program.register(name: "mvp", value: mvpMonkey)
		monkey.program.register(name: "mv", value: camera.view)
		//cubemap.model = Matrix4.scaleMatrix(5*abs(sin(0.3*time)))
		let mvpCubemap = mv*cubemap.model
		cubemap.program.register(name: "mvp", value: mvpCubemap)
		monkey.program.register(name: "mv", value: camera.view)
	}
	
	func render(elapsed: Scalar){
		time += elapsed
		update(elapsed:elapsed)
		
		internalRenderer.clear(color: true, depth: true)
		internalRenderer.drawMesh(mesh: monkey.mesh, program: monkey.program)
		internalRenderer.drawMesh(mesh: dragon.mesh, program: dragon.program)
		internalRenderer.drawMesh(mesh: floor.mesh, program: floor.program)
		
		internalRenderer.drawMesh(mesh: cubemap.mesh, program: cubemap.program)
		
	}
	
	func flush() -> NSImage {
		return internalRenderer.flushImage()
	}
	
}
