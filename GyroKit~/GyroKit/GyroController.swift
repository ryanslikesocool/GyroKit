// Developed with love by Ryan Boyer http://ryanjboyer.com <3

import CoreMotion
import Foundation

@objc final class GyroController: NSObject {
    private static var manager: CMMotionManager = CMMotionManager()

    @objc public static var updateInterval: Double {
        get { manager.deviceMotionUpdateInterval }
        set { manager.deviceMotionUpdateInterval = newValue }
    }

    public static var rotationRate: CMRotationRate? { manager.deviceMotion?.rotationRate }

    @objc public static var rotationRateX: Double {
        manager.deviceMotion?.rotationRate.x ?? 0
    }

    @objc public static var rotationRateY: Double {
        manager.deviceMotion?.rotationRate.y ?? 0
    }

    @objc public static var rotationRateZ: Double {
        manager.deviceMotion?.rotationRate.z ?? 0
    }

    @objc public static var isDeviceMotionUpdating: Bool = false

    @objc public class func startDeviceMotionUpdates() {
        if manager.isDeviceMotionAvailable {
            manager.startDeviceMotionUpdates()
            isDeviceMotionUpdating = true
        }
    }

    @objc public class func stopDeviceMotionUpdates() {
        if manager.isDeviceMotionAvailable {
            manager.stopDeviceMotionUpdates()
            isDeviceMotionUpdating = false
        }
    }
}
