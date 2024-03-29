//
//  ViewController.swift
//  ARBasketball8282019
//
//  Created by JOY BEST on 8/28/19.
//  Copyright © 2019 JOY BEST. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical]
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
  
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation,types:
        [.existingPlaneUsingExtent])
        if let result = hitTestResult.first {
            addHoop(result: result)
        }
        
    }
    
    
    
    func createFloor() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNPlane(width: 1.0, height: 1.0)
        node.geometry = geometry
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 0.25
        return node
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node:
        SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        print("A new plane has been discovered.")
    }
    
    func addHoop(result: ARHitTestResult) {
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")
        guard let hoopNode = hoopScene?.rootNode.childNode(withName: "Hoop", recursively: false) else {
            return
        }
        let planePosition = result.worldTransform.columns.3
        hoopNode.position = SCNVector3(planePosition.x, planePosition.y, planePosition.z)
        
        
        sceneView.scene.rootNode.addChildNode(hoopNode)
    }
    func createBasketball() {
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        sceneView.scene.rootNode.addChildNode(ball)
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
