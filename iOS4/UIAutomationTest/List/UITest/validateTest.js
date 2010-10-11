
// テストスタート
UIALogger.logStart('validateTest.js');

// アニメーションを待つ時間
DELAY_FOR_ANIMATION = 2;

var target = UIATarget.localTarget();
var app = target.frontMostApp();

// アラートが表示されたときのコールバック関数をセット
UIATarget.onAlert = function onAlert(alert) {
	UIALogger.logPass('Alert OK');
	alert.buttons()['OK'].tap();
    return true;
}

function validateTest() {
	// 追加ボタンを押す
	app.mainWindow().navigationBar().buttons()[0].tap();

	target.delay(DELAY_FOR_ANIMATION);

	// テキストフィールドにフォーカスを合わせる
	app.mainWindow().textFields()[0].tap();

	target.delay(DELAY_FOR_ANIMATION);

	// テキストフィールドに，重複したデータを入力
	app.mainWindow().textFields()[0].setValue('');

	target.delay(DELAY_FOR_ANIMATION);

	// 保存ボタンを押す
	app.mainWindow().navigationBar().buttons()[1].tap();
}

function main() {
	try{
		validateTest();
	}
	catch(e){
		UIALogger.logFail('Exception '+ e);
	}
}

main();