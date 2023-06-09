//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 25/03/23.
//


import UIKit
import SceneKit
import ARKit
import Toast
import Alamofire

class SolarSystemViewController: UIViewController, ARSCNViewDelegate {
    
    // display the 3D AR scene
    private lazy var sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.translatesAutoresizingMaskIntoConstraints = false
        return scene
    }()
    
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
    
    private lazy var nextFactButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Siguiente", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.clipsToBounds = true
        
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.isHidden = true
        button.addTarget(self, action: #selector(nextFactButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.cornerRadius = 10.0
        label.layer.borderColor = UIColor.blue.cgColor
        label.layer.borderWidth = 2.0
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFile))
        return button
    }()
    
    private lazy var toastStyleMissElements: ToastStyle = {
        var style = ToastStyle()
        style.backgroundColor = .red
        style.titleColor = .white
        style.imageSize = CGSize(width: 50, height: 50)
        return style
    }()
    
    private lazy var toastStyleComplete: ToastStyle = {
        var style = ToastStyle()
        style.backgroundColor = .green
        style.titleColor = .white
        style.imageSize = CGSize(width: 50, height: 50)
        return style
    }()
    
    // parent node for all the planets and other objects in the scene
    private let baseNode = SCNNode()
    
    // keep track of the current planet where the user clicked
    private var currentPlanet = SCNNode()
    private var currentPlanetTitle = SCNNode()
    
    // Declare the tap gesture recognizer as a property
    var tapGesture: UITapGestureRecognizer!
    
    var currentFactIndex = 0
    
    var presenter: SolarSystemPresenterProtocol?
    
    var planetTapped: PlanetResponse?
    
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
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoLabel.heightAnchor.constraint(equalToConstant: 100),
            nextFactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextFactButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 5),
            nextFactButton.widthAnchor.constraint(equalToConstant: 90),
            nextFactButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(view: self)
        view.addSubview(sceneView)
        view.addSubview(backRoundBtn)
        view.addSubview(infoLabel)
        view.addSubview(nextFactButton)
        navigationItem.rightBarButtonItem = addButton
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
        
        // adding the gesture recognizer to detect which planet the user is clicking
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.addGestureRecognizer(tapGesture)
        sceneView.scene.rootNode.addChildNode(baseNode)
    }
    
    @objc func handleTap(rec: UITapGestureRecognizer) {
        let location = rec.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(location, options: [.rootNode: baseNode])
        guard let tappedNode = hitTestResults.first?.node else { return }
        if tappedNode.name != "saturn_loop" && tappedNode.name != "ringNode" {
            // Remove the gesture recognizer to prevent further taps
            sceneView.removeGestureRecognizer(tapGesture)
            // copy the node
            let tappedNodeCopy = tappedNode.clone()
            baseNode.addChildNode(tappedNodeCopy)
            // hide all nodes except the tappedNodeCopy
            baseNode.childNodes.forEach {
                if $0 != tappedNodeCopy {
                    $0.isHidden = true
                }
            }
            if tappedNode.name != "sun" {
                if tappedNode.name != "jupiter" && tappedNode.name != "saturn" && tappedNode.name != "uranus" && tappedNode.name != "neptune" {
                    // scale the small planets
                    tappedNodeCopy.scale = SCNVector3(x: 8, y: 8, z: 8)
                }
                // Move the tapped planet to the center of the screen
                let action = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.5)
                tappedNodeCopy.runAction(action)
            }
            // planet title
            checkTappedNodeInfo(tappedNode: tappedNodeCopy)
            baseNode.addChildNode(createText(planetName: tappedNodeCopy.name ?? "", planetNode: tappedNodeCopy))
            backRoundBtn.isHidden = false
            presenter?.getPlanetInfo(planetName: tappedNodeCopy.name!)
        }
    }
    
    @objc private func goBack() {
        baseNode.childNodes.forEach { node in
            // delete the tappedNodeCopy and title
            if node == currentPlanet || node == currentPlanetTitle {
                node.removeFromParentNode()
            }
            // show the rest of the solar system
            node.isHidden = false
        }
        // restore the current selected node
        currentPlanet = SCNNode()
        backRoundBtn.isHidden = true
        infoLabel.isHidden = true
        infoLabel.text = ""
        nextFactButton.isHidden = true
        // Add the gesture recognizer back to enable taps again
        sceneView.addGestureRecognizer(tapGesture)
        planetTapped = nil
    }
    
    @objc private func nextFactButtonTapped() {
        guard let _ = currentPlanet.name,
              let facts = planetTapped?.facts,
              currentFactIndex < facts.count else {
            return
        }
        
        let fact = facts[currentFactIndex]
        currentFactIndex += 1
        
        if currentFactIndex >= facts.count {
            currentFactIndex = 0
        }
        
        infoLabel.text = fact
    }
    
    private func checkTappedNodeInfo(tappedNode: SCNNode) {
        infoLabel.isHidden = false
        nextFactButton.isHidden = false
        currentPlanet = tappedNode
        currentFactIndex = 0
        infoLabel.text = "Learn more about \(tappedNode.name?.capitalized ?? "it here")"
    }

    private func createText(planetName: String, planetNode: SCNNode) -> SCNNode {
        let text = SCNText(string: planetName.capitalized, extrusionDepth: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        text.materials = [material]
        // calculate the size of the planet node
        let (min, max) = planetNode.boundingBox
        let planetNodeSize = SCNVector3Make(max.x - min.x, max.y - min.y, max.z - min.z)
        let node = SCNNode()
        node.name = planetName
        // adjust the position of the text node based on the size of the planet node
        let action = SCNAction.move(to: SCNVector3(0, planetNodeSize.y * planetNode.scale.y / 2.0 + 0.02, 0), duration: 0.5)
        node.runAction(action)
        //node.position = SCNVector3(x: planetNode.position.x, y: planetNodeSize.y * planetNode.scale.y / 2.0 + 0.02, z: 0)
        node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
        node.geometry = text
        currentPlanetTitle = node
        return node
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
    
    @objc private func addFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
}

extension SolarSystemViewController: SolarSystemViewProtocol {
    
    func showPlaneInfo(planetInfo: PlanetResponse) {
        planetTapped = planetInfo
    }
    
    func showLoader() {
        view.makeToastActivity(.center)
    }
    
    func hideLoader() {
        view.hideToastActivity()
    }
    
    func showError(message: String) {
        if let image = UIImage(systemName: "exclamationmark.square.fill") {
            let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.makeToast(message, duration: 2.0, position: .center, title: "Ups!", image: tintedImage, style: toastStyleMissElements)
        }
    }
}

extension SolarSystemViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        uploadCSVFile(fileURL: fileURL)
    }
    
    func uploadCSVFile(fileURL: URL) {
        guard let csvData = try? Data(contentsOf: fileURL) else { return }
        
        let url = "http://localhost:3000/planet/file"
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(csvData, withName: "planetFile", fileName: "data.csv", mimeType: "text/csv")
        }, to: url).response { response in
            debugPrint(response)
        }
    }
}
