
var target = UIATarget.localTarget();
var app = target.frontMostApp();

var window = app.mainWindow();
var nav = window.navigationBar();
var staticTexts = nav.staticTexts();

UIALogger.logMessage(staticTexts[0].name());