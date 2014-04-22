Рыболовный бот для Minecraft 1.7.2, версия 1.0

Запускать в AutoHotKey: http://www.autohotkey.com/

Используемые клавиши:
	'k' - в первый раз вызывает окно настроек. В остальных случаях выключает скрипт.
	'PageDown' - запускает рыбалку.
	'PageUp' - приостанавливает рыбалку.

Инструкция:

	0. Выставьте в майнкрафте настройки: яркость "100%", размер интерфейса "Large". Разверните окно на весь экран. Положите все удочки в их слоты в нижней панели (или хотя бы одну удочку в самый левый из тех слотов, что будут использованы для удочек). Освоо

	1. Поставьте текстурпак с непрозраной нижней панелью.
	1а.	Если нужно, замените изображения слота с удочкой и пустого слота, чтобы они подходили к текстурпаку.

	2. Запустите скрипт, должно появиться сообщение в трее.
		Оно гласит: "Откройте окно майнкрафта, выйдите из всех меню и инвентарей и нажмите K на клавиатуре."

	3. Нажмите клавишу 'k'. Появится окно настроек скрипта. В нем можно отредактировать числовые параметры.

	4. Нажмите кнопку "Try detect", откроется окно майнкрафта и найдется самая левая удочка.
		Перейдите снова в окно настроек, и нажмите "Try pixel", убрав руку с мышки. Курсор переместится. Если он окажется наведен на крайний левый пиксель полоски состояния удочки, то все в порядке. Если он промажет, подкорректируйте координаты в полях "Rod pixel" вручную, и снова нажмите "Try pixel". Вам нужно добиться точного попадания в область 3х3 пикселя. После этого переходите к следующему пункту.

	5. Если вы хотите выйти из майнкрафта после окончания рыбалки, отметьте галочку "Close after finish", после чего, наконец, закончите настройку нажатием "Submit".
		
	6. Нажмите клавишу 'PageDown' и откиньтесь в кресле. Свернуть окно, к сожалению, нельзя.

	7. Если хотите приостановить работу скрипта, нажмите 'PageUp', продолжить можно клавишей 'PageDown'.
		Выключить скрипт можно клавишей 'k', при этом выскочит подтверждающее окно.



Подробно об окне настроек скрипта:

	- Кнопка "Try detect" пытается обнаружить пиксель критического состояния удочки. Перед нажатием нужно положить все имеющиеся удочки в их слоты (или хотя бы одну удочку в самый левый из тех слотов, что будут использованы для удочек).
	Эта кнопка переходит в окно майнкрафта, нажимает Esc (чтобы выйти из меню игры) и ищет картинку удочки. К полученным координатам она применяет смещение и записывает полученные координаты в память.
	Этот процесс может сработать неверно. Результаты можно проверить и откорректировать вручную, об этом позднее.

	- Поля "Offset (h)" и ".. (v)" задают размеры поля, где будет искаться поплавок, а именно отступы от краев окна по горизонтали и по вертикали соответственно. Не рекомендуется менять. Это нужно, если окно майнкрафта маленькое.

	- Поля "Rod pixel (h)" и  ".. (v)" задают координаты пикселя критического состояния. Это самый левый пиксель в полоске состония предмета. Например, когда удочка близка к поломке, он становится красным, а когда удочка почти сломана, он становится черным. На самом деле эта область имеет размер примерно 3х3 пикселя, и нам подходит любой из них.
	В этих полях можно вручную подредактировать координаты этой точки, если другие способы не помогли.

	- Кнопка "Try pixel" наводит мышку туда, где по мнению бота, находится пиксель критического состояния. Она нужна, когда вы хотите проверить, правильно ли бот нашел этот пиксель. Нажав ее, проверьте, куда попала мышка. Если она навелась в левый конец полоски состояния - значит, все в порядке. Если промазала - подредактируйте поля "Rod pixel" самостоятельно. Это важно, потому что иначе бот будет работать неправильно.

	- Галочка "Close after finish" задает поведение бота при окончании рыбалки. Если галочка выставлена, то в конце рыбалки он грубо закроет окно игры.

	- Кнопка "Submit" записывает в память значения полей и закрывает окно настроек. Закрытие окна крестиком приведет к тому же. После этого бот готов к работе.

Используемые внешние файлы: 
	- rod_sample.png - вид удочки в нижней панели с отсечкой на уровне полоски состояния. Черные пиксели прозрачны для алгоритмов скрипта. Черными пикселями закрыт силуэт самой удочки, чтобы не влияла анимация энчанта.
	- clean_sample.png - вид пустого слота в нижней панели.


(c) Remote (aka Efrim), /mc/, April 2014