import XCTest
@testable import MorphAnimator
    
class MockViewSource: UIViewController, MorphAnimatorViewSource {
    var baseView: UIView
    var assetViews = [UIView]()
    var portalView: UIView?
    
    init(transit: Morph.Transit, numberOfAssetViews: Int, usePortal: Bool) {
        let frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.baseView = UIView(frame: frame)
        super.init(nibName: nil, bundle: nil)
        for _ in 0...numberOfAssetViews {
            let assetView = UIView(frame: frame)
            baseView.addSubview(assetView)
            self.assetViews.append(assetView)
        }
        
        if usePortal {
            self.portalView = UIView(frame: frame)
            self.baseView.addSubview(portalView!)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MorphTransitionGuidanceTests: XCTestCase {
   //TODO: Add after guidance is added
}

class MorphFactoryTests: XCTestCase {
    func testMakeNavigationDelegate() {
        //TODO: Test via UITest?
    }
    
    func testMakeTransitionDelegate() {
        //let result =
        
//        let fromViewSource = MockViewSource(transit: .exiting, numberOfAssetViews: 3, usePortal: false)
//        let toViewSource = MockViewSource(transit: .entering, numberOfAssetViews: 3, usePortal: false)
//
//        let navigationController = UINavigationController(rootViewController: fromViewSource)
//        navigationController.pushViewController(toViewSource, animated: .morph)
//        navigationController.view.layoutIfNeeded()
//
//        XCTAssertEqual(navigationController.topViewController, toViewSource)
    }
}

class MorphPrimitivesTests: XCTestCase {
    func testValidPairInitialization() {
        let sut = Morph.Pair<Int>(from: 0, to: 1)
        XCTAssertEqual(sut.from, 0)
        XCTAssertEqual(sut.to, 1)
    }
    
    func testValidPairInitializationFromArray() {
        let sut = Morph.Pair<Int>([0, 1])
        XCTAssertEqual(sut.from, 0)
        XCTAssertEqual(sut.to, 1)
    }
    
    func testPairIteration() {
        let sut = Morph.Pair<Int>([0, 1])
        var counter = 0
        for _ in sut.enumerated() {
            counter += 1
        }
        XCTAssertEqual(counter, 2)
    }
    
    func testTransformInitialization() {
        let sut = Morph.Transform<Int>(start: 0, end: 1)
        XCTAssertEqual(sut.start, 0)
        XCTAssertEqual(sut.end, 1)
    }
    
    func testValidTransformInitializationFromArray() {
        let sut = Morph.Transform<Int>([0, 1])
        XCTAssertEqual(sut!.start, 0)
        XCTAssertEqual(sut!.end, 1)
    }
    
    func testTransformIteration() {
        let sut = Morph.Pair<Int>([0, 1])
        var counter = 0
        for _ in sut.enumerated() {
            counter += 1
        }
        XCTAssertEqual(counter, 2)
    }
    
    func testPlacementLiteralInit() {
        let sut = Morph.Placement(x: 2, y: 4, width: 6, height: 8)
        XCTAssertEqual(sut.x, 2)
        XCTAssertEqual(sut.y, 4)
        XCTAssertEqual(sut.width, 6)
        XCTAssertEqual(sut.height, 8)
    }
    
    func testPlacementPositionSizeInit() {
        let sut = Morph.Placement(at: CGPoint(x: 2, y: 4), size: CGSize(width: 6, height: 8))
        XCTAssertEqual(sut.x, 2)
        XCTAssertEqual(sut.y, 4)
        XCTAssertEqual(sut.width, 6)
        XCTAssertEqual(sut.height, 8)
    }
    
    func testConstraintSetInitWithSingleView() {
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let asset = UIView(frame: .zero)
        let position = CGPoint(x: 25, y: 25)
        let size = CGSize(width: 50, height: 50)
        let sut = Morph.ConstraintSet(constrain: asset, at: position, to: size, inView: superView)
        XCTAssertFalse(sut.isActive)
        
        XCTAssertEqual(sut.placement.x, position.x)
        XCTAssertEqual(sut.placement.y, position.y)
        XCTAssertEqual(sut.placement.width, size.width)
        XCTAssertEqual(sut.placement.height, size.height)
    }
    
    func testConstraintSetInitWithViewPair() {
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let asset = UIView(frame: .zero)
        let sut = Morph.ConstraintSet(constrain: asset, to: superView, enable: false)
        XCTAssertFalse(sut.isActive)
        
        XCTAssertEqual(sut.placement.x, 0)
        XCTAssertEqual(sut.placement.y, 0)
    }
    
    func testFlow() {
        //TODO:
    }
}

class MorphGeometryHelpers: XCTestCase {
    func testViewAnchorPointAdjustment() {
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(testView.layer.anchorPoint, CGPoint(x: 0.5, y: 0.5))
        
        testView.setAnchorPoint(toViewAnchor: CGPoint(x: 20, y: 20), movingView: false)
        XCTAssertEqual(testView.viewAnchorPoint, CGPoint(x: 20, y: 20))
        XCTAssertEqual(testView.layer.anchorPoint, CGPoint(x: 0.2, y: 0.2))
    }
    
    func testViewAnchorPointAdjustmentMovingView() {
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let viewAnchor = CGPoint(x: 100, y: 100)
        
        XCTAssertEqual(testView.layer.anchorPoint, CGPoint(x: 0.5, y: 0.5))
        superView.addSubview(testView)
        
        XCTAssertEqual(testView.frame, CGRect(x: 0, y: 0, width: 100, height: 100))
        testView.setAnchorPoint(toViewAnchor: viewAnchor, movingView: true)
        XCTAssertEqual(testView.frame, CGRect(x: -50, y: -50, width: 100, height: 100))
        XCTAssertEqual(testView.viewAnchorPoint, viewAnchor)
    }
    
    func testLayerAnchorPointAdjustment() {
        let layerAnchor = CGPoint(x: 0.75, y: 0.75)
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(testView.layer.anchorPoint, CGPoint(x: 0.5, y: 0.5))
        
        testView.setAnchorPoint(toLayerAnchor: layerAnchor, movingView: false)
        XCTAssertEqual(testView.viewAnchorPoint, CGPoint(x: 75, y: 75))
        XCTAssertEqual(testView.layer.anchorPoint, layerAnchor)
    }
    
    func testLayerAnchorPointAdjustmentMovingView() {
        let superView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        let layerAnchor = CGPoint(x: 0.75, y: 0.75)
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertEqual(testView.layer.anchorPoint, CGPoint(x: 0.5, y: 0.5))
        superView.addSubview(testView)
        
        XCTAssertEqual(testView.frame, CGRect(x: 0, y: 0, width: 100, height: 100))
        testView.setAnchorPoint(toLayerAnchor: layerAnchor, movingView: true)
        XCTAssertEqual(testView.frame, CGRect(x: -25, y: -25, width: 100, height: 100))
        XCTAssertEqual(testView.layer.anchorPoint, layerAnchor)
    }
    
    func testConvertLayerAnchorToViewAnchor() {
        let layerAnchorPoint = CGPoint(x: 0.25, y: 0.25)
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        let viewAnchor = testView.convertToViewAnchor(layerAnchorPoint)
        XCTAssertEqual(viewAnchor, CGPoint(x: 25, y: 25))
    }
    
    func testConvertViewAnchorToLayerAnchor() {
        let viewAnchorPoint = CGPoint(x: 70, y: 70)
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        let layerAnchor = testView.convertToLayerAnchor(viewAnchorPoint)
        XCTAssertEqual(layerAnchor, CGPoint(x: 0.7, y: 0.7))
    }
    
    func testCGPointArithmeticAddition() {
        let first = CGPoint(x: 10, y: 30)
        let second = CGPoint(x: 5, y: 15)
        let expectedResult = CGPoint(x: 15, y: 45)
        let result = first + second
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCGPointArithmeticSubtraction() {
        let first = CGPoint(x: 10, y: 30)
        let second = CGPoint(x: 5, y: 15)
        let expectedResult = CGPoint(x: 5, y: 15)
        let result = first - second
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCGPointTranslateForward() {
        let point = CGPoint(x: 10, y: 30)
        let translation = CGVector(dx: 5, dy: 6)
        let expectedResult = CGPoint(x: 15, y: 36)
        let result = point.translate(translation, reverse: false)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCGPointTranslateReverse() {
        let point = CGPoint(x: 10, y: 30)
        let translation = CGVector(dx: 5, dy: 6)
        let expectedResult = CGPoint(x: 5, y: 24)
        let result = point.translate(translation, reverse: true)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCGRectMajorMinorAxis() {
        var sut = CGRect(x: 0, y: 0, width: 200, height: 100)
        XCTAssertEqual(sut.majorAxis, .horizontal)
        XCTAssertEqual(sut.minorAxis, .vertical)
        
        sut = CGRect(x: 0, y: 0, width: 300, height: 600)
        XCTAssertEqual(sut.majorAxis, .vertical)
        XCTAssertEqual(sut.minorAxis, .horizontal)
    }
    
    func testCGRectOffset() {
        let sut = CGRect(x: 0, y: 0, width: 200, height: 100)
        let offset = CGPoint(x: 10, y: 10)
        let expectedResult = CGRect(x: 10, y: 10, width: 200, height: 100)
        let result = sut.offset(by: offset)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testCGRectCenterProperties() {
        let sut = CGRect(x: 0, y: 0, width: 200, height: 100)
        XCTAssertEqual(sut.center, CGPoint(x: 100, y: 50))
    }
    
    func testCGVectorComparable() {
        let w = CGVector(dx: 1, dy: 1)
        let x = CGVector(dx: 1, dy: 1)
        
        let y = CGVector(dx: 0, dy: 1)
        let z = CGVector(dx: 1, dy: 0)
        
        XCTAssertEqual(w, x)
        XCTAssertNotEqual(w, z)
        XCTAssertNotEqual(x, z)
        XCTAssertNotEqual(y, z)
    }
}

class MorphLayersTests: XCTestCase {
    func testBaseViewSnapshot() {
        
    }
    
    func testBaseViewAdd() {
        
    }
    
    func testPositioningOfPair() {
        
    }
    
    func testPositioningOfSingleView() {
        
    }
}

class MorphAccessoryLayerTests {
    func testInit() {
        
    }
    
    func testMakeShadowLayer() {
        
    }
}

class MorphAnimatableLayerTests {
    func testInit() {
        
    }
    
    func testMakeBaseLayer() {
        
    }
    
    func testMakeExitingLayer() {
        
    }
    
    func testMakeEnteringLayer() {
        
    }
    
    func testMakeMorphingLayer() {
        
    }
    
    func testReplicateView() {
        
    }
    
    func testReplicateViewPair() {
        
    }
}

class MorphEffectLayerTests {
    func testInit() {
        
    }
    
    func testMakeBlurLayer() {
        
    }
}

class MorphAcetateLayerTests {
    func testInit() {
        
    }
    
    func testMakeEnteringLayerAcetate() {
        
    }
    
    func testMakeExitingLayerAcetate() {
        
    }
}

class MorphPortalLayerTests {
    func testInit() {
        
    }
    
    func testMakePortal() {
        
    }
}

class MorphTimingProviderTests {
    func testCurveType() {
        
    }
    
    func testSpringTiming() {
        
    }
    
    func testCubicTiming() {
        
    }
}

class MorphViewReplicationTests: XCTestCase {
    func testSnapshot() {
        
    }
    
    func testCoreAnimationDefaultSnapshot() {
        
    }
    
    func testCoreAnimationModelLayerSnapshot() {
        
    }
    
    func testCoreAnimationPresentationLayerSnapshot() {
        
    }
}

class MorphTransitioningDelegateTests {
    func testNavigationInit() {
        
    }
    
    func testNavigationAnimatedTransitioningVending() {
        
    }
    
    func testViewControllerInit() {
        
    }
    
    func testPresentAnimatedTransitioningVending() {
        
    }
    
    func testDismissAnimatedTransitioningVending() {
        
    }
}

class MorphSceneTests: XCTestCase {
    func testSceneInit() {
        
    }
    
    func testUnhappyPaths() {
        
    }
}

class MorphAssetTests: XCTestCase {
    func testInitFromSide() {
        
    }
    
    func testInitFromPair() {
        
    }
}

class MorphAnimatorTests: XCTestCase {
    func testInit() {
        // Test that the contents, constraints etc are added to the stage.
    }
    
    func testAnimate() {
        
    }
}

class MorphTransitioningTests: XCTestCase {
    func testInit() {
        
    }
    
    func testAnimateTransition() {
        
    }
}

