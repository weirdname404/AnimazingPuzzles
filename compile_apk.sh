#QT_ANDROID_PATH=/home/nm/Qt/5.9.2/android_armv7
#QT_ANDROID_PATH=/home/nm/03_qt_android
qmake ../ILH.pro -spec android-g++ CONFIG+=debug CONFIG+=qml_debug
make
make install INSTALL_ROOT=./android
androiddeployqt --output android --verbose --input android-libILH.so-deployment-settings.json --gradle
