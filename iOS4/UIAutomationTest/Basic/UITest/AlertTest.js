
var target = UIATarget.localTarget();
var app = target.frontMostApp();

UIATarget.onAlert = function onAlert(alert) {
	alert.buttons()['Cancel'].tap();
    return true;
}

var cells = app.mainWindow().tableViews()[0].cells();
cells[0].tap();
