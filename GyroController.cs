// Developed with love by Ryan Boyer http://ryanjboyer.com <3

using System;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;

namespace GyroKit {
    public class GyroController {
        public delegate void RotationRateAction(double x, double y, double z);

        public static RotationRateAction OnDeviceRotationRaw;

        public static event Action<Vector3> OnDeviceRotation;

        public static void Init() {
#if UNITY_IOS && !UNITY_EDITOR
            setRotationDelegate(RotationUpdated);
#endif
        }

        public static void StartTracking() {
#if UNITY_IOS && !UNITY_EDITOR
            startTracking();
#endif
        }

        public static void StopTracking() {
#if UNITY_IOS && !UNITY_EDITOR
            stopTracking();
#endif
        }

        public static void SetUpdateInterval(float dt) {
#if UNITY_IOS && !UNITY_EDITOR
            setUpdateInterval((double)dt);
#endif
        }

        public static bool IsDeviceMotionAvailable() {
#if UNITY_IOS && !UNITY_EDITOR
            return isDeviceMotionAvailable();
#else
            return false;
#endif
        }

        [DllImport("__Internal")]
        private static extern bool isDeviceMotionAvailable();

        [DllImport("__Internal")]
        private static extern bool startTracking();

        [DllImport("__Internal")]
        private static extern bool stopTracking();

        [DllImport("__Internal")]
        private static extern void setRotationDelegate(RotationRateAction callback);

        [DllImport("__Internal")]
        private static extern void setUpdateInterval(double dt);

        [MonoPInvokeCallback(typeof(RotationRateAction))]
        private static void RotationUpdated(double x, double y, double z) {
            OnDeviceRotationRaw?.Invoke(x, y, z);
            OnDeviceRotation?.Invoke(new Vector3((float)x, (float)y, (float)z));
        }
    }
}