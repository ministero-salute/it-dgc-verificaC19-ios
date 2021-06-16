//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
import SwiftDGC
@testable import VerificaC19

class VerificationViewControllerTests: XCTestCase {
    var controller: VerificationViewController!
    let window = UIWindow(frame: UIScreen.main.bounds)

    override func setUpWithError() throws {
        let payload = "HC1:6BFOXN%TS3DHPVO13J /G-/2YRVA.Q/R82JD2FCJG96V75DOW%IY17EIHY P8L6IWM$S4U45P84HW6U/4:84LC6 YM::QQHIZC4.OI1RM8ZA.A5:S9MKN4NN3F85QNCY0O%0VZ001HOC9JU0D0HT0HB2PL/IB*09B9LW4T*8+DCMH0LDK2%KI*V AQ2%KYZPQV6YP8722XOE7:8IPC2L4U/6H1D31BLOETI0K/4VMA/.6LOE:/8IL882B+SGK*R3T3+7A.N88J4R$F/MAITHW$P7S3-G9++9-G9+E93ZM$96TV6QRR 1JI7JSTNCA7G6MXYQYYQQKRM64YVQB95326FW4AJOMKMV35U:7-Z7QT499RLHPQ15O+4/Z6E 6U963X7$8Q$HMCP63HU$*GT*Q3-Q4+O7F6E%CN4D74DWZJ$7K+ CZEDB2M$9C1QD7+2K3475J%6VAYCSP0VSUY8WU9SG43A-RALVMO8+-VD2PRPTB7S015SSFW/BE1S1EV*2Q396Q*4TVNAZHJ7N471FPL-CA+2KG-6YPPB7C%40F18N4"
        
        let coordinator: VerificationCoordinator = MainCoordinator(navigationController: UINavigationController())
        let viewModel = VerificationViewModel(hCert: HCert(from: payload))
        controller = VerificationViewController(coordinator: coordinator, viewModel: viewModel)
        window.rootViewController = controller
    }
    
    override func tearDownWithError() throws {
        window.rootViewController = nil
        window.isHidden = true
        try super.tearDownWithError()
    }
    
    func testInitWithCoder() {
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        let viewController = VerificationViewController(coder: archiver)
        XCTAssertNil(viewController)
    }
    
    func testVerificationViewControllerIsLoaded() throws {
        window.makeKeyAndVisible()
        
        waitForCondition { self.controller.isViewLoaded }
    }
}