
var target = UIATarget.localTarget();

UIALogger.logStart('Test1 has stared');
UIALogger.logMessage('do something');
UIALogger.logFail('error...');

UIALogger.logStart('Test2 has stared');
UIALogger.logMessage('do something');
UIALogger.logPass('OK');
