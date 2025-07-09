cmake_minimum_required(VERSION 3.30.1)

project(
  Videoedit
  VERSION 0.1
  LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup(REQUIRES 6.9)

qt_add_executable(appVideoedit)

qt_add_qml_module(
  appVideoedit
  URI
  Videoedit
  VERSION
  1.0
  SOURCES
  main.cpp
  videoshot.h
  videoshot.cpp
  worker.h
  worker.cpp
  QML_FILES
  Main.qml
  QML_FILES
  Content.qml
  QML_FILES
  Actions.qml
  QML_FILES
  Dialogs.qml
  QML_FILES
  Player.qml
  QML_FILES
  PreviewBarRow.qml
  QML_FILES
  PlayerSlider.qml
  QML_FILES
  PreviewBarControlRow.qml
  QML_FILES
  VideoList.qml
  QML_FILES
  VideoParams.qml
  QML_FILES
  VideoPlayer.qml
  QML_FILES
  Menus.qml
  QML_FILES
  CutView.qml
  QML_FILES
  cutViewControl.js
  QML_FILES
  previewbarrow.js
  SOURCES sourcemanager.h sourcemanager.cpp)

target_compile_features(appVideoedit PRIVATE cxx_std_23)

target_link_libraries(appVideoedit PRIVATE Qt6::Quick Qt6::Multimedia avutil
                                           avformat avcodec swscale)

set_target_properties(
  appVideoedit
  PROPERTIES # MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appVideoedit
             MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
             MACOSX_BUNDLE_SHORT_VERSION_STRING
             ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
             MACOSX_BUNDLE TRUE
             WIN32_EXECUTABLE TRUE)

include(GNUInstallDirs)
install(
  TARGETS appVideoedit
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback
# behaviour of C++ standard qt_add_executable(Videoedit)  //Creates and
# finalizes an application target of a platform-specific type. This command
# performs the following tasks: 1. Create a CMake target of the appropriate type
# for the target platform. 2. Link the target to the Qt::Core library. 3. Handle
# finalization of the CMake target.

# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback
# behaviour of C++ standard

# qt_standard_project_setup()  #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)

# cmake_minimum_required(VERSION 3.16)
#
# project(Videoedit VERSION 0.1 LANGUAGES CXX)
#
# @if !true set(CMAKE_AUTOMOC ON) @endif set(CMAKE_CXX_STANDARD_REQUIRED ON)
#
# find_package(Qt6 REQUIRED COMPONENTS Quick)
#
# @if true @if true qt_standard_project_setup(REQUIRES 6.9) @else
# qt_standard_project_setup() @endif @endif
#
# qt_add_executable(appVideoedit main.cpp )
#
# qt_add_qml_module(appVideoedit URI Videoedit VERSION 1.0 QML_FILES Main.qml )
#
# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1. #
# If you are developing for iOS or macOS you should consider setting an #
# explicit, fixed bundle identifier manually though.
# set_target_properties(appVideoedit PROPERTIES # MACOSX_BUNDLE_GUI_IDENTIFIER
# com.example.appVideoedit MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
# MACOSX_BUNDLE_SHORT_VERSION_STRING
# ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR} MACOSX_BUNDLE TRUE
# WIN32_EXECUTABLE TRUE )
#
# target_link_libraries(appVideoedit PRIVATE Qt6::Quick )
#
# include(GNUInstallDirs) install(TARGETS appVideoedit BUNDLE DESTINATION .
# LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} RUNTIME DESTINATION
# ${CMAKE_INSTALL_BINDIR} )
