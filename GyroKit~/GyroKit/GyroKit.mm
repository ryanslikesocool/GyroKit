// Developed with love by Ryan Boyer http://ryanjboyer.com <3

#import "GyroKit-Swift.h"

extern "C" {
double getUpdateInterval() {
	return GyroController.updateInterval;
}

void setUpdateInterval(double value) {
	GyroController.updateInterval = value;
}

bool isDeviceMotionUpdating() {
	return GyroController.isDeviceMotionUpdating;
}

double getRotationRateX() {
	return GyroController.rotationRateX;
}

double getRotationRateY() {
	return GyroController.rotationRateY;
}

double getRotationRateZ() {
	return GyroController.rotationRateZ;
}

void startDeviceMotionUpdates() {
	[GyroController startDeviceMotionUpdates];
}

void stopDeviceMotionUpdates() {
	[GyroController stopDeviceMotionUpdates];
}
}
