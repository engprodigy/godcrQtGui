package main

import (
	"fmt"
	"os"

	"github.com/KitlerUA/xlsxparser/parser"
	"github.com/raedahgroup/godcr/app/config"
	"github.com/therecipe/qt/core"
	"github.com/therecipe/qt/gui"
	"github.com/therecipe/qt/qml"
	"github.com/therecipe/qt/quickcontrols2"
)

type QmlBridge struct {
	core.QObject

	_ func(detText string)       `signal:sendToQml`
	_ func(fileName, dir string) `slot:sendToGo` //only slots can return something
}

// triggered after program execution is complete or if interrupt signal is received
var beginShutdown = make(chan bool)

// shutdownOps holds cleanup/shutdown functions that should be executed when shutdown signal is triggered
var shutdownOps []func()

// opError stores any error that occurs while performing an operation
var opError error

func main() {

	//var a = "initial"

	appConfig, args, parseroption, err := config.LoadConfig(true)
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}

	if appConfig == nil {
		fmt.Fprintf(os.Stderr, "unexpected command or flag in %s mode: %s\n")
		os.Exit(1)
	}

	if args.ConfFileOptions.AppDataDir == " " {
		//fmt.Fprintf(os.Stderr, "unexpected command or flag in %s mode: %s\n")
		//os.Exit(1)
	}
	if parseroption == nil {
		fmt.Fprintf(os.Stderr, "unexpected command or flag in %s mode: %s\n")
		os.Exit(1)
	}

	var qmlBridge *QmlBridge
	qmlBridge = NewQmlBridge(nil)

	// Create application
	app := gui.NewQGuiApplication(len(os.Args), os.Args)

	// Enable high DPI scaling
	app.SetAttribute(core.Qt__AA_EnableHighDpiScaling, true)

	// Use the material style for qml
	quickcontrols2.QQuickStyle_SetStyle("material")

	// Create a QML application engine
	engine := qml.NewQQmlApplicationEngine(nil)
	engine.RootContext().SetContextProperty("qmlBridge", qmlBridge)
	qmlBridge.ConnectSendToQml(func(detText string) {

	})
	qmlBridge.ConnectSendToGo(func(fileName, dir string) {
		var err error
		var warnings string
		if warnings, err = parser.Parse(fileName, dir); err != nil {
			qmlBridge.SendToQml(fmt.Sprintf("%s<br>", err))
		} else if warnings == "" {
			qmlBridge.SendToQml("Successfully parsed and safe<br>")
		} else {
			qmlBridge.SendToQml(fmt.Sprintf("<b><i>Parsed with warnings:</i></b><br><br>%s", warnings))
		}
	})
	// Load the main qml file
	engine.Load(core.NewQUrl3("qrc:/qml/main.qml", 0))
	// Execute app
	gui.QGuiApplication_Exec()
}
