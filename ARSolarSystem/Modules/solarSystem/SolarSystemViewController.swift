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
    
    // display the 3D AR scene
    private lazy var sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.translatesAutoresizingMaskIntoConstraints = false
        return scene
    }()
    
    private var currentPlanet: String = ""
    
    private lazy var backRoundBtn: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Back", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        button.isHidden = true
        return button
    }()
    
    @objc func goBack() {
        baseNode.childNodes.forEach { node in
            // delete the node 
            if node.name == currentPlanet {
                node.removeFromParentNode()
            }
            if node.childNodes.isEmpty && node.name == "ringNode"  {
                // TODO: modify, right now the properties are for planet Earth only and add moon
                let planetRestore = createPlanet(radius: 0.05, image: "earth")
                planetRestore.position = SCNVector3(x: 0.7, y: 0, z: 0)
                rotateObject(rotation: 0.25, planet: planetRestore, duration: 0.4)
                //planetRestore.addChildNode(moonRingNode)
                node.addChildNode(planetRestore)
            }
            node.isHidden = false
        }
        backRoundBtn.isHidden = true
    }
    
    // parent node for all the planets and other objects in the scene
    private let baseNode = SCNNode()
    
    private func constrainstSetup() {
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backRoundBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backRoundBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backRoundBtn.widthAnchor.constraint(equalToConstant: 90),
            backRoundBtn.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sceneView)
        view.addSubview(backRoundBtn)
        constrainstSetup()
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        // creating son
        let sun = createPlanet(radius: 0.25, image: "sun")
        sun.position = SCNVector3(x: 0, y: 0, z: 0)
        rotateObject(rotation: -0.3, planet: sun, duration: 1)
        
        // creating moon
        let moon = createPlanet(radius: 0.01, image: "moon")
        let moonRing = SCNTorus(ringRadius: 0.08, pipeRadius: 0.000001)
        let moonRingNode = SCNNode(geometry: moonRing)
        moon.position = SCNVector3(x: 0.08, y: 0, z: 0)
        moonRingNode.position = SCNVector3(x: 0, y: 0.02, z: 0)
        
        // creating saturn rings
        let saturnLoop = SCNBox(width: 0.4, height: 0, length: 0.5, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "saturn_loop")
        saturnLoop.materials = [material]
        let loopNode = SCNNode(geometry: saturnLoop)
        loopNode.rotation = SCNVector4(x: -0.5, y: -0.5, z: 0, w: 8)
        loopNode.position = SCNVector3(x: 0, y: 0, z: 0)
        loopNode.name = "saturn_loop"
        
        // creating a SCNNode for each planet
        let mercury = createPlanet(radius: 0.03, image: "mercury")
        let venus = createPlanet(radius: 0.04, image: "venus")
        let earth = createPlanet(radius: 0.05, image: "earth")
        let mars = createPlanet(radius: 0.03, image: "mars")
        let jupiter = createPlanet(radius: 0.12, image: "jupiter")
        let saturn = createPlanet(radius: 0.09, image: "saturn")
        let uranus = createPlanet(radius: 0.07, image: "uranus")
        let neptune = createPlanet(radius: 0.08, image: "neptune")
        
        // creating the rings of each planet as SCNNode
        let mercuryRing = createRings(ringSize: 0.3)
        let venusRing = createRings(ringSize: 0.5)
        let earthRing = createRings(ringSize: 0.7)
        let marsRing = createRings(ringSize: 0.8)
        let jupiterRing = createRings(ringSize: 1)
        let saturnRing = createRings(ringSize: 1.25)
        let uranusRing = createRings(ringSize: 1.5)
        let neptuneRing = createRings(ringSize: 1.7)
        
        // setting up the position for each planet
        mercury.position = SCNVector3(x: 0.3, y: 0, z: 0)
        venus.position = SCNVector3(x: 0.5, y: 0, z: 0)
        earth.position = SCNVector3(x: 0.7, y: 0, z: 0)
        mars.position = SCNVector3(x: 0.8, y: 0, z: 0)
        jupiter.position = SCNVector3(x: 1, y: 0, z: 0)
        saturn.position = SCNVector3(x: 1.25, y: 0, z: 0)
        uranus.position = SCNVector3(x: 1.5, y: 0, z: 0)
        neptune.position = SCNVector3(x: 1.7, y: 0, z: 0)
        
        // rotate planet on its own axis
        rotateObject(rotation: 0.6, planet: mercury, duration: 0.4)
        rotateObject(rotation: 0.4, planet: venus, duration: 0.4)
        rotateObject(rotation: 0.25, planet: earth, duration: 0.4)
        rotateObject(rotation: 0.2, planet: mars, duration: 0.4)
        rotateObject(rotation: 0.45, planet: jupiter, duration: 0.4)
        rotateObject(rotation: 0.34, planet: saturn, duration: 0.4)
        rotateObject(rotation: 0.25, planet: uranus, duration: 0.4)
        rotateObject(rotation: 0.2, planet: neptune, duration: 0.4)
        
        // rotate the rings around the sun
        rotateObject(rotation: 0.6, planet: mercuryRing, duration: 1)
        rotateObject(rotation: 0.4, planet: venusRing, duration: 1)
        rotateObject(rotation: 0.25, planet: earthRing, duration: 1)
        rotateObject(rotation: 0.2, planet: marsRing, duration: 1)
        rotateObject(rotation: 0.45, planet: jupiterRing, duration: 1)
        rotateObject(rotation: 0.34, planet: saturnRing, duration: 1)
        rotateObject(rotation: 0.25, planet: uranusRing, duration: 1)
        rotateObject(rotation: 0.2, planet: neptuneRing, duration: 1)
        
        // adding the planets as childs of its correspoding ring
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
        moonRingNode.addChildNode(moon)
        
        // adding the sun and the rings as childs of the base node
        baseNode.addChildNode(sun)
        baseNode.addChildNode(mercuryRing)
        baseNode.addChildNode(venusRing)
        baseNode.addChildNode(earthRing)
        baseNode.addChildNode(marsRing)
        baseNode.addChildNode(jupiterRing)
        baseNode.addChildNode(saturnRing)
        baseNode.addChildNode(uranusRing)
        baseNode.addChildNode(neptuneRing)

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
                if tappedNode?.name != "saturn_loop" && tappedNode?.name != "ringNode" {
                    tappedNode?.scale  = SCNVector3(x: 8, y: 8, z: 8)
                    // adding tapped node as child to the base node
                    baseNode.addChildNode(node)
                    // Hide all the planets except the tapped planet
                    baseNode.childNodes.forEach {
                        if $0 != node {
                            $0.isHidden = true
                        }
                    }
                    // Move the tapped planet to the center of the screen
                    let action = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.5)
                    node.runAction(action)
                    // check which node is tapped
                    checkTappedNde(tappedNode: tappedNode!)
                }
            }
        }
    }
    
    private func checkTappedNde(tappedNode: SCNNode) {
        print("tappedNode: \(String(describing: tappedNode.name))")
        backRoundBtn.isHidden = false
        if tappedNode.name == "earth" {
            currentPlanet = "earth"
            // TODO: show some information about earth
        } else if tappedNode.name == "etc.." { // TODO: rest of the planets
            
        }
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
        ringNode.name = "ringNode"
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
