// Developed with love by Ryan Boyer http://ryanjboyer.com <3

using System.Runtime.InteropServices;
using UnityEngine;

namespace GyroKit {
    public class GyroController {
#if UNITY_IOS && !UNITY_EDITOR
        [DllImport("__Internal")]
        private static extern double getUpdateInterval();

        [DllImport("__Internal")]
        private static extern void setUpdateInterval(double interval);

        [DllImport("__Internal")]
        private static extern bool isDeviceMotionUpdating();

        [DllImport("__Internal")]
        private static extern double getRotationRateX();

        [DllImport("__Internal")]
        private static extern double getRotationRateY();

        [DllImport("__Internal")]
        private static extern double getRotationRateZ();

        [DllImport("__Internal")]
        private static extern void startDeviceMotionUpdates();

        [DllImport("__Internal")]
        private static extern void stopDeviceMotionUpdates();
#endif

        public static float UpdateInterval {
#if UNITY_IOS && !UNITY_EDITOR
            get => (float)getUpdateInterval();
            set => setUpdateInterval((double)value);
#else
            get => 0;
            set { }
#endif
        }

        public static Vector3 RotationRate {
            get {
#if UNITY_IOS && !UNITY_EDITOR
                float x = (float)getRotationRateX();
                float y = (float)getRotationRateY();
                float z = (float)getRotationRateZ();
                return new Vector3(x, y, z);
#else
                return Vector3.zero;
#endif
            }
        }

        public static bool IsDeviceMotionUpdating {
            get {
#if UNITY_IOS && !UNITY_EDITOR
                return isDeviceMotionUpdating();
#else
                return false;
#endif
            }
        }

        public static void StartDeviceMotionUpdates() {
#if UNITY_IOS && !UNITY_EDITOR
            startDeviceMotionUpdates();
#endif
        }

        public static void StopDeviceMotionUpdates() {
#if UNITY_IOS && !UNITY_EDITOR
            stopDeviceMotionUpdates();
#endif
        }
    }
}