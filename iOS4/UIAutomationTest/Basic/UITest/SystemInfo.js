
var target = UIATarget.localTarget();

UIALogger.logMessage(target.model());
//UIALogger.logMessage(target.name());
UIALogger.logMessage(target.systemName());
UIALogger.logMessage(target.systemVersion());

var target = UIATarget.localTarget();
var app = target.frontMostApp();

//UIALogger.logMessage(app.mainWindow().rect());

target.captureScreenWithName('sc01.png');
target.captureRectWithName({origin:{x:0.5, y:0.53}, size:{width:160, height:240}}, 'sc02.png');


