
var target = UIATarget.localTarget();
var app = target.frontMostApp();

var cells = app.mainWindow().tableViews()[0].cells();
cells[1].tap();

target.delay(1);

app.mainWindow().tableViews()[0].flickInsideWithOptions({startOffset:{x:0.5, y:0.53}, endOffset:{x:0.5, y:0.5}});

target.delay(3);

app.mainWindow().navigationBar().buttons()[0].tap();