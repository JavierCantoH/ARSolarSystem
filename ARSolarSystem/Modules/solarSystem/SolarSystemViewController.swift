//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 25/03/23.
//

import UIKit
import SceneKit
import ARKit

class SolarSystemViewController: UIViewController, ARSCNViewDelegate {
    
    private lazy var sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.translatesAutoresizingMaskIntoConstraints = false
        return scene
    }()
    
    private let baseNode = SCNNode()
    
    private func constrainstSetup() {
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        constrainstSetup()
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        
        let sun = createPlanet(radius: 0.25, image: "sun")
        sun.position = SCNVector3(x: 0, y: 0, z: 0)
        rotateObject(rotation: -0.3, planet: sun, duration: 1)
        
        let moon = createPlanet(radius: 0.01, image: "moon")
        let moonRing = SCNTorus(ringRadius: 0.08, pipeRadius: 0.000001)
        let moonRingNode = SCNNode(geometry: moonRing)
        moon.position = SCNVector3(x: 0.08, y: 0, z: 0)
        moonRingNode.position = SCNVector3(x: 0, y: 0.02, z: 0)
        moonRingNode.addChildNode(moon)
        
        let saturnLoop = SCNBox(width: 0.4, height: 0, length: 0.5, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "saturn_loop.png")
        saturnLoop.materials = [material]
        let loopNode = SCNNode(geometry: saturnLoop)
        loopNode.rotation = SCNVector4(x: -0.5, y: -0.5, z: 0, w: 8)
        loopNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        let mercury = createPlanet(radius: 0.03, image: "mercury")
        let venus = createPlanet(radius: 0.04, image: "venus")
        let earth = createPlanet(radius: 0.05, image: "earth")
        let mars = createPlanet(radius: 0.03, image: "mars")
        let jupiter = createPlanet(radius: 0.12, image: "jupiter")
        let saturn = createPlanet(radius: 0.09, image: "saturn")
        let uranus = createPlanet(radius: 0.07, image: "uranus")
        let neptune = createPlanet(radius: 0.08, image: "neptune")
        
        let mercuryRing = createRings(ringSize: 0.3)
        let venusRing = createRings(ringSize: 0.5)
        let earthRing = createRings(ringSize: 0.7)
        let marsRing = createRings(ringSize: 0.8)
        let jupiterRing = createRings(ringSize: 1)
        let saturnRing = createRings(ringSize: 1.25)
        let uranusRing = createRings(ringSize: 1.5)
        let neptuneRing = createRings(ringSize: 1.7)
        
        mercury.position = SCNVector3(x: 0.3, y: 0, z: 0)
        venus.position = SCNVector3(x: 0.5, y: 0, z: 0)
        earth.position = SCNVector3(x: 0.7, y: 0, z: 0)
        mars.position = SCNVector3(x: 0.8, y: 0, z: 0)
        jupiter.position = SCNVector3(x: 1, y: 0, z: 0)
        saturn.position = SCNVector3(x: 1.25, y: 0, z: 0)
        uranus.position = SCNVector3(x: 1.5, y: 0, z: 0)
        neptune.position = SCNVector3(x: 1.7, y: 0, z: 0)
        
        rotateObject(rotation: 0.6, planet: mercury, duration: 0.4)
        rotateObject(rotation: 0.4, planet: venus, duration: 0.4)
        rotateObject(rotation: 0.25, planet: earth, duration: 0.4)
        rotateObject(rotation: 0.2, planet: mars, duration: 0.4)
        rotateObject(rotation: 0.45, planet: jupiter, duration: 0.4)
        rotateObject(rotation: 0.34, planet: saturn, duration: 0.4)
        rotateObject(rotation: 0.25, planet: uranus, duration: 0.4)
        rotateObject(rotation: 0.2, planet: neptune, duration: 0.4)
        
        rotateObject(rotation: 0.6, planet: mercuryRing, duration: 1)
        rotateObject(rotation: 0.4, planet: venusRing, duration: 1)
        rotateObject(rotation: 0.25, planet: earthRing, duration: 1)
        rotateObject(rotation: 0.2, planet: marsRing, duration: 1)
        rotateObject(rotation: 0.45, planet: jupiterRing, duration: 1)
        rotateObject(rotation: 0.34, planet: saturnRing, duration: 1)
        rotateObject(rotation: 0.25, planet: uranusRing, duration: 1)
        rotateObject(rotation: 0.2, planet: neptuneRing, duration: 1)
        
        mercuryRing.addChildNode(mercury)
        venusRing.addChildNode(venus)
        earthRing.addChildNode(earth)
        earth.addChildNode(moonRingNode)
        marsRing.addChildNode(mars)
        jupiterRing.addChildNode(jupiter)
        saturnRing.addChildNode(saturn)
        saturn.addChildNode(loopNode)
        uranusRing.addChildNode(uranus)
        neptuneRing.addChildNode(neptune)
        
        baseNode.addChildNode(sun)
        baseNode.addChildNode(mercuryRing)
        baseNode.addChildNode(venusRing)
        baseNode.addChildNode(earthRing)
        baseNode.addChildNode(marsRing)
        baseNode.addChildNode(jupiterRing)
        baseNode.addChildNode(saturnRing)
        baseNode.addChildNode(uranusRing)
        baseNode.addChildNode(neptuneRing)
        baseNode.addChildNode(moonRingNode)
        baseNode.addChildNode(mercury)
        baseNode.addChildNode(venus)
        baseNode.addChildNode(earth)
        baseNode.addChildNode(mars)
        baseNode.addChildNode(jupiter)
        baseNode.addChildNode(saturn)
        baseNode.addChildNode(uranus)
        baseNode.addChildNode(neptune)

        baseNode.position = SCNVector3(x: 0, y: -0.5, z: -1)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.addGestureRecognizer(tap)
        sceneView.scene.rootNode.addChildNode(baseNode)
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer){
        let location = rec.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(location, options: [.rootNode: baseNode])

        guard let node = hitTestResults.first?.node else { return }
       if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                tappedNode?.scale  = SCNVector3(x: 2.5, y: 2.5, z: 2.5)
                checkTappedNde(tappedNode: tappedNode!)
            }
           
       }
        // Hide all the planets except the tapped planet
        baseNode.childNodes.forEach {
            if $0 != node {
                $0.isHidden = true
            }
        }
        
        // Move the tapped planet to the center of the screen
        let action = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.5)
        node.runAction(action)
    }
    
    
    private func checkTappedNde(tappedNode: SCNNode) {
        print("tappedNode: \(String(describing: tappedNode.name))")
    }
    
    private func createPlanet(radius: Float, image: String) -> SCNNode {
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents  = UIImage(named: "\(image).jpg")
        planet.materials = [material]
        let planetNode = SCNNode(geometry: planet)
        planetNode.name = image
        return planetNode
    }
    
    private func rotateObject(rotation: Float, planet: SCNNode, duration: Float) {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(rotation), z: 0, duration: TimeInterval(duration))
        planet.runAction(SCNAction.repeatForever(rotation))
    }
    
    private func createRings(ringSize: Float) -> SCNNode {
        let ring = SCNTorus(ringRadius: CGFloat(ringSize), pipeRadius: 0.002)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.darkGray
        ring.materials = [material]
        let ringNode = SCNNode(geometry: ring)
        return ringNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}
