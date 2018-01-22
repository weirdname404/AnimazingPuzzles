QT += quick
CONFIG += c++11

SOURCES += main.cpp

include(external/qt-google-analytics/qt-google-analytics.pri)

RESOURCES += qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

my_files.path = /assets
my_files.files = res/*
INSTALLS += my_files
!android {
    DESTDIR = $$OUT_PWD
}

android {
  QT += androidextras
}

#    folder_qml.source = res
#    folder_qml.target = /assets
#    DEPLOYMENTFOLDERS += folder_qml
