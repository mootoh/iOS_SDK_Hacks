
// テストスタート
UIALogger.logStart('addTest.js');

// アニメーションを待つ時間
DELAY_FOR_ANIMATION = 2;

var target = UIATarget.localTarget();
var app = target.frontMostApp();

function addTest() {
	// 入力する名前
	var name = 'hoho';

	// 追加ボタンを押す
	app.mainWindow().navigationBar().buttons()[0].tap();

	target.delay(DELAY_FOR_ANIMATION);

	// テキストフィールドにフォーカスを合わせる
	app.mainWindow().textFields()[0].tap();

	target.delay(DELAY_FOR_ANIMATION);

	// テキストフィールドに文字列を入力
	app.mainWindow().textFields()[0].setValue(name);

	target.delay(DELAY_FOR_ANIMATION);

	// 保存ボタンを押す
	app.mainWindow().navigationBar().buttons()[1].tap();

	// 入力したデータが保存され，表示されているかを確認
	var cell = app.mainWindow().tableViews()[0].cells()[name];

	// 確認して，結果をログに出力
	if (cell.checkIsValid()) {
		UIALogger.logPass('Added');
	}
	else {
		UIALogger.logFail('Not added');
	}
}

function main() {
	try{
		addTest();
	}
	catch(e){
		UIALogger.logFail('Exception '+ e);
	}
}

main();