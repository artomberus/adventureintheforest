--
-- The source code of the game (including images) is distributed under the MIT license. For the full text of the license, see the file LICENCE.txt, which is located in the game directory. Sounds, music - distributed under their own licenses, see snd/source.txt and mus/Copyright.txt Some images are distributed under their own licenses, see gfx/Sources.txt
--
-- Исходный код игры (включая изображения) распространяется на условиях лицензии MIT. Полный текст лицензии см. в файле LICENCE.txt, который находится в каталоге с игрой. Звуки, музыка - распространяются под своими лицензиями, см. snd/source.txt и mus/Copyright.txt Некоторые изображения распространяются под собственными лицензиями, см. gfx/Sources.txt
--
-- $Name(ru): Лесное приключение $
-- $Name(en): Adventure in the forest $
-- $Name(uk): Лісова пригода $
-- $Version: 0.01$
-- $Author: Дмитрий Петрук$
-- $Info: Ники в сети - Amberit(92), Artorius, Artomberus \n Код игры - под MIT  \n Музыка: Jason Shaw, лицензия CC BY 3.0 \n Звуки - см. каталог игры $
include "longway"
require "snd"
require "fmt"
require "noinv"
require "click"
require "theme"
require "timer"
require "keys"
require "dbg"
require "sprite"
require "snapshots"
loadmod "decor"
loadmod "link"
game.act = 'Не работает.';
game.use = function ()
	p( phrases[language][rnd( table.maxn(phrases[language]) )]); 
	end;

game.inv = 'Зачем мне это?';
xact.walk = walk
xact.walkout = walkout

function init ()
	take 'статус'
	take 'fonarik'
	take 'maintain'
	lifeon 'maintain'
	createbutton();
	if LANG == 'ru' then setru(); end; 
	if LANG == 'en' then seten(); end; 
	if LANG == 'uk' then setua(); end; 
	end

function sndplaylong()
	if not snd.playing(7) then snd.play('snd/clicklong.wav', 7) end;
end;

function game:ondecor(name, x, y)
	clickmute = true;
	if name == 'ruslang' then setru(); rulangimage = "gfx/russian_selected.png"; enlangimage = "gfx/english.png"; ualangimage = "gfx/ukrainian.png"; snd.play('snd/click.wav', 7); walk('main') return  end;
	if name == 'englang' then seten(); enlangimage = "gfx/english_selected.png"; rulangimage = "gfx/russian.png"; ualangimage = "gfx/ukrainian.png"; snd.play('snd/click.wav', 7); walk('main') return  end;
	if name == 'ukrlang' then setua(); ualangimage = "gfx/ukrainian_selected.png"; enlangimage = "gfx/english.png"; rulangimage = "gfx/russian.png"; snd.play('snd/click.wav', 7); walk('main') return  end;
	if name == 'statsclick' and infobarshow then deleteinfobar(); theme.gfx.bg (bg_name) return std.nop() end; 
	if name == 'statsclick' and ru and not infobarshow then p[[Да, это твой {@ walk stats|прогресс}.]]; if not snd.playing(7) then snd.play('snd/clicklong.wav', 7) end clickmute = false; return end;
	if name == 'statsclick' and en and not infobarshow then p[[Yes, this is your progress.]]; if not snd.playing(7) then snd.play('snd/clicklong.wav', 7) end return end;
	if name == 'statsclick' and ua and not infobarshow then p[[Так, це твій прогрес.]]; if not snd.playing(7) then snd.play('snd/clicklong.wav', 7) end return end;
	if name == 'traces' then x = rnd(600); y = rnd(500); snd.play('snd/click.wav', 7); walkin('control_room') return  end;
	if name == 'control_panel' and passedintro then walkin('control_room'); return end;
	if name == 'info_panel' and passedintro then walkin('info_room');  return end;
		if name == 'cursor_usual' then theme.gfx.cursor ('gfx/inv/cursor.png', 'gfx/inv/cursoruse.png', 0 , 0); cursorstate = 0;
			if ru then p ( fmt.c('^Как пожелаете. Задан размер курсора: обычный.') ); end;
			if en then p ( fmt.c('^As you wish. Specified cursor size: normal.') ); end;
			if ua then p ( fmt.c('^Як побажаєте. Заданий розмір курсору: звичайний.') ); end;
	 	return end;
		if name == 'cursor_big' then theme.gfx.cursor ('gfx/inv/cursorbig.png', 'gfx/inv/cursorbiguse.png', 0 , 0); cursorstate = 1;
			if ru then p ( fmt.c('^Как пожелаете. Задан размер курсора: большой.') ); end;
			if en then p ( fmt.c('^As you wish. Specified cursor size: big.') ); end;
			if ua then p ( fmt.c('^Як побажаєте. Заданий розмір курсору: великий.') ); end;
		return end;
		if name == 'cursor_verybig' then theme.gfx.cursor ('gfx/inv/cursorverybig.png', 'gfx/inv/cursorverybiguse.png', 0 , 0); cursorstate = 2;
			if ru then p ( fmt.c('^Как пожелаете. Задан размер курсора: огромный.') ); end;
			if en then p ( fmt.c('^As you wish. Specified cursor size: very big.') ); end;
			if ua then p ( fmt.c('^Як побажаєте. Заданий розмір курсору: дуже великий.') ); end;
		return end;
	if name == 'keys_infobar' and infobarshow then drawtext = false; deleteinfobar(); theme.gfx.bg (bg_name) fadingcanbe = true; repeatplease = true; createclickonscene(); return okay(); end; 
	if name == 'clickonscene' and clickonsceneenabled and drawtext then
	 	if ru then p'Ты нажал на область сцены. Здесь просто картинка.' end
		if en then p'You clicked on the scene area. Here is just a picture.' end
		if ua then p'Ти натиснув на область сцени. Тут просто зображення.' end
	 sndplaylong() clickmute = false; else drawtext = true; return std.nop() 
	end;

	end;

exit = function()
	pleasedrink = false;
	pleaseeat = false;
	end;

managesound = function()
	if not clickmute and not infobarshow and not weareincontrol then snd.play('snd/click.wav', 1) end;
	clickmute = false;
	if fadingcanbe then repeatplease = false; end;
 	end;

setru = function() ru = true; en = false; ua = false; end;
seten = function() ru = false; en = true; ua = false; end;
setua = function() ru = false; en = false; ua = true; end;

test = function() -- включаю её, когда надо отследить, где добавился опыт
--	p'+EXP';
	end;

 game.afteract = managesound;
 game.afterinv = managesound;
 game.oninv = managesound;
 game.onuse = managesound;
 game.onwalk = managesound;
 game.ontak = managesound;

global 'bg_name' ('gfx/bg.png')

function set_bg(name)
    bg_name = name
    theme.gfx.bg (name)
end

function start(load) -- удобное изменение фона под игровую ситуацию
     theme.gfx.bg (bg_name)
	if cursorstate == 0 then theme.gfx.cursor ('gfx/inv/cursor.png', 'gfx/inv/cursoruse.png', 0 , 0) end;
	if cursorstate == 1 then theme.gfx.cursor ('gfx/inv/cursorbig.png', 'gfx/inv/cursorbiguse.png', 0 , 0) end;
	if cursorstate == 2 then theme.gfx.cursor ('gfx/inv/cursorverybig.png', 'gfx/inv/cursorverybiguse.png', 0 , 0) end;
	
end

std.strip_call = false -- для переноса строк, где хочу и когда хочу :)
snd.music_fading(2500) -- плавный переход музыки
instead.fading = false; -- убрать фэйдинг для первой сцены, потом мы его включим.
fmt.para = true; -- включить отступы


global 'language' ('ru')

declare { 

phrases = {
		ru = {
		[[Это не поможет.]],
		[[Это ни к чему.]],
		[[Это ни к чему не приведет.]],
	 --	[[Нет.]],
		[[Не то.]],
		[[Непонятно...]],
		[[Ничего не произошло.]],
		[[Бесполезно.]],
		[[В этом нет никакого смысла.]],
		[[Попробуй что-то другое.]],
		[[И что ты хочешь получить в итоге?]],
		[[Ну ты, конечно, и экспериментатор.]],
	 --	[[Если бы все предметы всегда сочетались - какой бы стала игра?]],
		[[Больше так не делай.]],
		[[Давай ты не будешь так больше делать, окей?]],
		[[Методом проб и ошибок... Но не абсурда же?]],
		[[Что ты делаешь?]], 
		[[Не получится.]]
			} ;
		en = {
		[[This will not help.]],
		[[This is useless.]],
		[[This will not lead to anything.]],
		[[Not that.]],
		[[Unclear...]],
		[[Nothing has happened.]],
		[[Useless.]],
		[[This makes no sense.]],
		[[Try something else.]],
		[[And what do you want to get as a result?]],
		[[Well, you are an experimenter.]],
		[[Don't do this anymore.]],
		[[Come on, you won’t do that anymore, okay?]],
		[[By trial and error... But not absurdity?]],
		[[What are you doing?]], 
		[[This will not work.]]
		};
		ua = {
		[[Це не допоможе.]],
		[[Це ні до чого.]],
		[[Це ні до чого не приведе.]],
		[[Не те.]],
		[[Незрозуміло...]],
		[[Нічого не сталося.]],
		[[Марно.]],
		[[В цьому немає ніякого сенсу.]],
		[[Спробуй щось інше.]],
		[[І що ж ти хочеш отримати в результаті?]],
		[[Ну ти й експериментатор.]],
		[[Більше так не роби.]],
		[[Давай ти так не будеш робити більше, окей?]],
		[[Методом проб і помилок... Але не абсурду ж?]],
		[[Що ти робиш?]], 
		[[Не вийде.]]
			}
	}
}

global { -- Много разных переменных. В основном логические. На них построена вся игра.
	wr = 0; -- Переменная, в которой считаем прогресс.
	max = 22; -- Когда wr достигнет значения max, игрок дойдет до развилки
	choose = 0; -- переменная, которой присвоим значение в зависимости от выбора
	maxchoose = 3; -- количество инкрементов прогресса в зависимости от выбора
	rightchoose = 0; -- здесь считаем прогресс правого пути
--	rightmaxchoose = 1; -- максимум инкрементов для правого пути
	leftchoose = 0; -- здесь считаем прогресс левого пути
--	leftmaxchoose = 1; -- максимум инкрементов для левого пути
	straightchoose = 0; -- здесь считаем прогресс прямого пути
--	straightmaxchoose = 1; -- максимум инкрементов для прямого пути
	rightwaychoosen = false;
	leftwaychoosen = false; -- выбор одного из путей
	straightwaychoosen = false;
	ru = false;
	en = true; -- маркеры языка... Если локаль инстеда одна из этих трех - они будут выбраны соответственно. Если локаль не одна из этих трех - то предлагаться будет англоязычная версия игры, как, вероятно, более понятная
	ua = false;
	weareincontrol = false; -- находимся ли мы в контрольной панели
	afterriver = false; -- прошел ли реку, нужно для прогресса
	clickmute = false; -- переключатель звука клика
	stonebreak = false; -- Укатил ли камень.
	havelopata = false; -- Взял ли лопату.
	havevedro = false; -- Взял ли ведро.
	haveudochka = false; -- Взял ли удочку.
	firsttime = true; -- Первый раз удочка на озеро.
	secondtime = true; -- Второй раз удочка на озеро.
	thirdtime = true; -- Третий раз удочка на озеро.
	firststart = true; -- Первый ли раз на перекрестке.
	otherstarts = false; -- Остальные разы.
	vedrostand = false; -- Поставил ли ведро на берег.
	vedrowithwater = false; -- Набрал ли в ведро воды.
	holeway = false; -- переменная для перехода к следующему этапу игры.
	frsttime = true; -- первый раз закинул удочку
	scndtime = true; -- второй раз закинул удочку
	thrdtime = true; -- третий раз - переход
	good = 0; -- подсчет поступков
	maxgood = 1; -- максимум хороших поступков
	evil = 0; -- подсчет поступков
	maxevil = 1; -- максимум плохих поступков
	goodorevil = 0; -- секретная переменная игры
	touchedtopor = false; -- не брали ли топор.
	touchedkey = false; -- не брали ли ключ.
	brokenwithtopor = false; -- ломал ли дверь топором
	openedwithkey = false; -- открывал ли дверь ключом
	firsttopor = true; -- первый раз заточил топор
	secondtopor = true; -- второй раз заточил топор
	thirdtopor = true; -- третий раз заточил топор
	propustili = false; -- справился ли с деревьями
	voronainriver = false; -- выбросил ли ворону в реку
	voronawasininv = false; -- трогал ли ворону
	voronaonmost = false; -- где ворона?
	youcansobr = false; -- возможность оборвать деревья, после разговора
	sobralapples = false; -- оборвал ли деревья от плодов
	izrubitapple = true; -- предупреждение, когда игрок пытается изрубить деревья
	izrubilappletrees = false; -- изрубил ли деревья
	aftertalkwithtrees = false; -- говорил ли с деревьями
	soglasen = false; -- если согласился помочь
	firstintrees = true; -- первый заход к деревьям
	aftertrees = false; -- определяем переход сразу после деревьев
	pleasedrink = false; -- для сообщения про козленочка, чтобы не фиксировать его
	isusercozel = false; -- стал ли игрок козленочком =)
	showtheway = false; -- после скольки кликов показывать решение выхода из состояния козленочка
	waycounter = 0; -- счетчик для показа решения выхода из состояния козленочка
	onepress = false; -- нажал Один
	twopress = false; -- нажал Два
	threepress = false; -- нажал Три
	twocheck = false; -- нажимаем 2 кнопку лишь 1 раз.
	pleaseeat = false; -- для сообщения про съесть яблоки, чтобы не фиксировать его
	pleaseeatpoison = false; -- то же для ядовитого яблока
	countedvorona = false; -- считали ли заход к вороне в прогрессе, после подсчета делается тру
	firstfill = true; -- считать в прогрессе только первый набор воды в ведро
	lestnicastand = false; -- поставил ли лестницу у дерева
	cantdothat = false; -- попробовал ли собрать яблоки
	belkaishere = false; -- явилась ли белка, хе-хе
	belkaseen = false; -- видел ли белку
	waytohouseback = false; -- путь к обратной стороне хижины закрыт
	onceopened = false; -- метка открытия обратного пути к хижине. когда тру - больше не вызываем диалог с белкой.
	wow = false; -- сказал ли вау, когда увидел лестницу
	lestntaken = false; -- взял ли лестницу
	topornavolka = false; -- пытался ли атаковать волка топором
	afterwolf = false; -- поговорил ли с волком
	horseleaved = false; -- слез ли с коня на правом пути
	stoneseen = false; -- видел ли камень с надписью
	talkedwithhorse = false; -- говорил ли с конем
	drinkedwaterinkolodets = false; -- напился ли воды из колодца
	eatedkolobok = false; -- съел ли колобка
	talkedwithkolobok = false; -- говорил ли с колобком
	kolobokandkuvshin = false; -- залил ли колобка водой
	vedrowithkolodecisfull = false; -- набрал ли воды в ведро из колодца 
	firsttalkwithstarik = true; -- делаем false если поговорили первый раз со стариком
	haveskatert = false; -- получил ли самобранку
	dalapples = false; -- дал ли яблоки старику
	dalwater = false; -- дал ли живую воду старику
	bread1 = false; -- что мы съели со скатерти, а что нет
	bread2 = false;
	cake3 = false;
	baton4 = false;
	banan5 = false;
	soup6 = false;
	bottle7 = false;
	arbuz8 = false;
	blackikra9 = false;
	formilk10 = false;
	fish11 = false;
	candles12 = false;
	redikra13 = false;
	meat14 = false;
	kolbasa15 = false;
	vinograd16 = false;
	grusha17 = false;
	apple18 = false; -- последний пункт в списке предметов скатерти
	nableguest = false; -- стал ли гостем у конюха
	zanaveskaopen = false; -- переключатель занавески в доме конюха
	takedpoison = false; -- взял ли ядовитое яблоко
	fallen = false; -- упал ли на камни
	attention = false; -- использовано ли предупреждение перед падением на камни
	alreadytalkedwolfinvillage = false; -- говорил ли с волком по прибытии в деревню
	oboroten = false; -- стал ли конюх оборотнем
	belkaincremented = false; -- если не касался дупла и не видел белку - при заходе к деревьям выравниваем прогресс. Да, костыльно. Но как умею(
	waterpoisoned = false; -- отравил ли колодец
	triedtoeat = false; -- если съел отравленное яблоко и умер, то выставляем тру, и игра не позволит повторить это
	specialcase = false; -- особый случай, когда набрал воды, а затем отравил колодец
	seaseen = false; -- видел ли море
	evening = 0; -- счетчик стадий вечера
	nobackway = false; -- прошел ли точку невозврата после старика перед деревней
	talkedwithoutskatert = false; -- если поговорил со стариком без шанса на скатерть, то тру
	removetopor = false; -- если тру, надо оставить топор
	havetaburet = false; -- есть ли у нас табурет
	braltaburet = false; -- брал ли табурет хоть раз
	takkuvshin2 = false; -- взял ли кувшин в дупле дерева
	kuvshintakedfromstarik = false; -- взял ли кувшин у старика
	uvideltopor = false; -- увидел ли топор. переменная нужна, чтобы перенести топор в другое место, если игрок не видел топор
	treecounter = 0; -- счетчик посещений дерева, если равно 3 и больше - можно показывать жар-птицу
	needpero = false; -- узнал ли от хозяина трактира, что нужно перо, чтобы получить пиво. переменная нужна как одно из условий появления жар-птицы
	birdontree = false; -- жар-птица прилетела или нет
	pticauletela = false; -- улетела ли птица после попытки схватить её
	havepero = false; -- есть ли перо жар-птицы у нас
	pivotaked = false; -- обменял ли перо на пиво
	postavpivoje = false; -- находимся ли мы за столиком
	kuvshinontable = false; -- поставлен ли кувшин на столик
	zabralkuvshinpivo = false; -- забрал ли кувшин с пивом со столика
	notfull = true; -- кувшин обычно не полон
	perelilpivo = false; -- решил ли квест с пивом и кружкой
	triedtoescape = false; -- пытался ли украсть кружку
	krotdal = false; -- отдал ли кружку
	mukaest = false; -- брал ли муку у мельника
	seegulls = true; -- видим ли чаек
	gullscounter = 0; -- счетчик состояния чаек (от 1 до 4)
	gullscheck = 0; -- переменная, чтобы рандом не повторялся
	nopivoontable = false; -- оставил ли пустую кружку на столе
	zabral = false; -- забрал ли хозяин кружку со стола
	vipusti = false; -- переменная нужна для того, чтобы не вызывать диалог про кружку, если уже погоговорил об этом
	combo = false; -- ловим сочетание условий, когда не надо вызывать диалог про то, что оставил кружку
	youcanplace = false; -- когда можно поставить пустую кружку
	wasintalkaboutkruzhka2 = false; -- один хак исправляет другой. для правильного выбора диалога, даже если вышел, оставив кружку на столе
	tyvor = false; -- вор ли ты
	needpivo = false; -- узнали ли от мельника, что нужно пиво
	askwhere = false; -- можно спрашивать ли про то, где искать перо
	dalvodu = false; -- особый случай, когда частично помог старику
	napugal = false; -- напугал ли белку
	wasinvillage = false; -- был ли в деревне
	countflush = 0; -- счетчик сброса голода
	eveningenabled = false; -- это для меня, включать и выключать вечер
	eatenapples = false; -- съел ли яблоки
	nashel2 = false; -- дупло дерева, особый случай
	fixed = false; -- исправил ли прогресс...
	cursorstate = 1; -- состояние размера курсора. 0 - минимум, 1 - обычный, 2 - максимум
	fromwhere = '';
	clickonsceneenabled = false; -- включены ли клики на сцене
	rulangimage = "gfx/russian.png";
	enlangimage = "gfx/english.png";
	ualangimage = "gfx/ukrainian.png";
	passedintro = false; -- прошли ли интро
	infobarshow = false; -- показан ли инфобар о клавишах
	fontsize = theme.get'win.fnt.size'; -- размер шрифта, соответствует дефолтному. при его увеличении увеличиваем шрифт в игре, и поправляем зоны видимости, раз уж взялись свою тему делать
	fadingcanbe = false; -- разрешен ли фейдинг
	repeatplease = false; -- надо ли повторить сообщение на перекрестке при заходе. нужно чтобы визуально ничего не менялось, когда кликаем мышей по инфобару
	langchanged = false; -- если язык не изменился, незачем перерисовывать сцену
	redbarshow = false; -- показан ли красный экран
	death_time = 1000; -- время показа красного экрана для таймера
	drawtext = true; -- показан ли текст при клике на сцену
	clickonscene_x = 50; -- координаты области клика по картинке
	clickonscene_y = 35;
}

stat {
	nam = 'статус';
--	pri = -1; -- в инстед версии 3.3.0 и выше эта строчка не требуется. Но в финале её оставлю, для совместимости. Обходит баг с сортировкой предметов в инвентаре.
	disp = function (s)
		if rightwaychoosen then choose = rightchoose; end; -- maxchoose = rightmaxchoose; end;
		if leftwaychoosen then choose = leftchoose; end; -- maxchoose = leftmaxchoose; end;
		if straightwaychoosen then choose = straightchoose; end; -- maxchoose = straightmaxchoose; end;
		pn (fmt.c(' '))
		if ru then pn (fmt.c('Прогресс: '), string.sub((((wr+choose)/(max+maxchoose))*100),1,4), (' %')) end;
		if en then pn (fmt.c('Progress: '), string.sub((((wr+choose)/(max+maxchoose))*100),1,4), (' %')) end;
		if ua then pn (fmt.c('Прогрес: '), string.sub((((wr+choose)/(max+maxchoose))*100),1,4), (' %')) end; -- Считаем и выводим прогресс игры в процентах.
		pn (fmt.c(' '))
	end
};

global { -- Сообщения на перекрестке.
	counter = 0;
	inplaceofrespawnRU = {
	[[Ты вернулся на место... чего?]],
	[[Здесь, конечно, интересно стоять и рассматривать лес. Но, может, лучше куда-нибудь пойти и выяснить, где же ты находишься?]],
	[[Интересно здесь, не так ли?]],
	[[Отряд не заметил потери бойца... Тебя хоть хватятся?]],
	[[Сколько ты проживешь в лесу, без еды и воды?]],
	[[Здесь есть кто живой?]],
	[[Иди-иди, не задерживайся.]],
	[[Сказка ложь, а в ней намек... Нет, в твоем случае сказка - чистая правда.]],
	[[Лес - источник жизни, силы и здоровья. Но не для всех и не всегда. Для тебя он сейчас - угроза.]],
	[[Не пей, братец, воду из озера местного - козленочком станешь.]],
	[[Ходит дурачок по лесу, ищет дурачок глупее себя...]],
	[[Из места, где пишут "прохода нет" - логичнее идти в место, где он таки есть. А ты сейчас на полпути.]],
	[[Что останется после тебя?]],
	[[Если надо выбрать между добром и злом - что бы ты выбрал?]],
	[[Эта история проверит, чем ты дышишь...]],
	[[Если в твоем сердце добрые намерения - ты останешься жив.]],
	[[Почему все так коряво нарисовано?]],
	[[Стоит ли запретить человеку лгать? Если бы это было возможно.]],
	[[Нужна ли свободная воля, которая приводит к страданию и несправедливости?]],
	[[Ты голоден, знаешь это?]],
	[[Ты не боишься, что сейчас из-за поворота выбежит волк и съест тебя?]],
	[[Ты вспоминаешь, как уютно и безопасно сейчас дома...]],
	[[И все же странно все это...]],
	[[Ты веришь в сказки?]],
	[[Вселенская большая любовь. Моя бездонная копилка в пустоте...]],
	[[Вселенская большая любовь. Моя секретная калитка в пустоте...]],
	[[Кто ты? Как понять тебя? О чем ты думаешь, блуждая по этим лесным зарослям?]],
	[[Движение - жизнь. Нельзя стоять на месте - врастешь в землю.]],
	[[Я искренне восхищаюсь тем, что ты читаешь все эти фразы. Продолжай.]],
	[[Какая ты, дорога жизни?]],
	[[Однако. Ходют тут всякие. Вместо того, чтобы делом заняться и спасти себя.]],
	[[Поздравляю. Ты так часто возвращаешься в это место, что истратил все фразы, которые автор для тебя заготовил. Может, он сделал что-то не так? Или ты оказался любопытным.]],
	[[ ]] 
	},
	inplaceofrespawnEN = {
	[[You returned to the place... of what?]],
	[[Here, of course, it is interesting to stand and look at the forest. But maybe it’s better to go somewhere and find out where you are?]],
	[[Interesting here, right?]],
	[[Are there any people who will look for you?]],
	[[How long will you live in the forest without food and water?]],
	[[Is there anyone alive here?]],
	[[Go, go, do not hold back.]],
	[[Tale of sense, if not of truth! Food for thought to honest youth. In your case, a fairy tale is pure truth.]],
	[[Forest is the source of life, strength and health. But not for everyone and not always. It is a threat to you now.]],
	[[Don’t drink, brother, water from the local lake - you’ll become a goat.]],
--	[[A fool walks through the forest, looking for a fool stupider than himself...]], bad translation, this is not an insult, but a quote
	[[From the place where it says "there is no passage" - it’s more logical to go to the place where it is. You're halfway now.]],
	[[What remains after you?]],
	[[If you need to choose between good and evil - what would you choose?]],
	[[This story will test what you are worth...]],
	[[If you have good intentions in your heart, you will remain alive.]],
	[[Why is everything so clumsy painted?]],
	[[Is it worth it to forbid a person to lie? If it were possible.]],
	[[Do we need free will that leads to suffering and injustice?]],
	[[Do you know that you are hungry?]],
	[[Are you not afraid that now the wolf will run out from behind the bend and eat you?]],
	[[You remember how comfortable and safe at home right now...]],
	[[And yet all this is strange...]],
	[[Do you believe in fairy tales?]],
--	[[The universal great love. My bottomless piggy bank in the void...]],
--	[[The universal great love. My secret gate in the void...]],
	[[Who are you? How to understand you? What are you thinking, wandering around these forest thickets?]],
	[[Movement is life. You can’t stand still - you grow into the ground.]],
	[[I sincerely admire you reading all these phrases. Continue.]],
	[[What are you, the way of life?]],
	[[However. Everyones go here. Instead of doing business and saving yourself.]],
	[[Congratulations. You return to this place so often that you spent all the phrases that the author has prepared for you. Maybe he did something wrong? Or you were curious.]],
	[[ ]] 
	},
	inplaceofrespawnUA = {
	[[Ти повернувся на місце ... чого?]],
	[[Тут, звичайно, цікаво стояти і розглядати ліс. Але, може, краще кудись піти і з'ясувати, де ж ти знаходишся?]],
	[[Цікаво тут, чи не так?]],
	[[Загін не помітив втрати бійця ... Тебе хоч почнуть шукати?]],
	[[Скільки ти проживеш в лісі, без їжі і води?]],
	[[Тут є хто живий?]],
	[[Іди-іди, не затримуйся.]],
	[[Казка брехня, але в ній натяк... Ні, в твоєму випадку казка - чиста правда.]],
	[[Ліс - джерело життя, сили і здоров'я. Але не для всіх і не завжди. Для тебе він зараз - загроза.]],
	[[Не пий, братику, воду з озера місцевого - козликом станеш.]],
--	[[Ходить дурачок лісом, шукає дурник дурніші себе ...]],
	[[З місця, де пишуть "проходу немає" - логічніше йти в місце, де він таки є. А ти зараз на півдорозі.]],
	[[Що залишиться після тебе?]],
	[[Якщо треба вибрати між добром і злом - що б ти вибрав?]],
	[[Ця історія перевірить, чого ти вартий...]],
	[[Якщо в твоєму серці добрі наміри - ти залишишся живий.]],
	[[Чому все так криво написано?]],
	[[Чи варто заборонити людині брехати? Якби це було можливо.]],
	[[Чи потрібна вільна воля, що призводить до страждання і несправедливості?]],
	[[Ти голодний, знаєш це?]],
	[[Ти не боїшся, що зараз із-за повороту вибіжить вовк і з'їсть тебе?]],
	[[Ти згадуєш, як затишно і безпечно зараз вдома...]],
	[[І все ж дивно все це...]],
	[[Ти віриш у казки?]],
--	[[Вселенська велика любов. Моя бездонна скарбничка в порожнечі ...]],
--	[[Вселенська велика любов. Моя секретна хвіртка в порожнечі ...]],
	[[Хто ти? Як зрозуміти тебе? Про що ти думаєш, блукаючи по цим лісових чагарниках?]],
	[[Рух - це життя. Не можна стояти на місці - вростеш в землю.]],
	[[Я щиро захоплююся тим, що ти читаєш всі ці фрази. Продовжуй.]],
	[[Яка ти, дорога життя?]],
	[[Однак. Ходять тут всякі. Замість того, щоб справою зайнятися і врятувати себе.]],
	[[Вітаю. Ти так часто повертаєшся в це місце, що витратив усі фрази, які автор для тебе заготовив. Може, він зробив щось не так? Або ти виявився допитливим.]],
	[[ ]] 
	}  
 }

function inc(a) return a + 1 end; -- на всякий случай, может пригодятся
function dec(a) return a - 1 end;


obj {
	nam = 'maintain'; -- делаем игрока голодным, если долго ходил, и управление вечером
	disp = false;
	on = false;
	life = function(s)
		if player_moved() then
		s.on = false;
		countflush = countflush+1;
		if countflush > 150 then countflush = 0 end;
--		if mukaest then eveningenabled = true; end; -- проверял, работает ли. теперь по определенному триггеру можно включить вечер
		if wasinvillage and countflush >= 15 then hungry = 0 countflush = 0 end;
		if fadingcanbe then instead.fading = true; end; -- включаем фейдинг после показа инфобара. по правде, я смутно понимаю, как всё работает, но вроде глюков нет. этот код нужен, чтобы при показе и убирании инфобара фейдинга не было, потому, что такое поведение у главного меню, а мы косим под встроенные менюшки.
		if clickonsceneenabled == false and not firststart and not weareincontrol then createclickonscene(); theme.gfx.bg (bg_name) end;
		return
		end;
	end;
}


room { -- Здесь начинается наше путешествие, небольшая предыстория
	forcedsc = true;
	nam = 'main';
	noinv = true;
	title = function()
 		if ru then return 'Вступление'; end;
		if en then return 'Intro'; end;
		if ua then return 'Вступ'; end;
		end;
	pic = 'gfx/0.png';
	enter = function()
		snd.music 'mus/Beginning.ogg' bg_name = 'gfx/bg_intro.png' theme.gfx.bg (bg_name) 
		deletebutton();
		createruslang();
		createenglang();
		createukrlang();
		end;
	exit = function()
		instead.fading = true; 
		createbutton();
		createclickonscene();
		deleteruslang();
		deleteenglang();
		deleteukrlang();
		end;
	dsc = function()
		if ru then p [[ Ты уснул, как обычно, к полуночи. Сон был беспокойный, грезились инопланетяне, склонившиеся над головой, но как только просыпался в ужасе - видел всё ту же привычную комнату. Успокоившись, что мир за время твоего сна никуда не делся, ты снова засыпал. Так несколько раз... Но в конце-концов - страхи имеют свойство материализоваться. Уже сквозь сон ты услышал, что воздух стал чище, холоднее. Что-то не так. Ты резко открыл глаза...  
{@ walk start|Дальше...}]] end;
		if en then p [[ You fell asleep, as usual, by midnight. The dream was restless, aliens were dreaming, bending over your head, but as soon as you woke up in horror, you saw the same familiar room. Having calmed down that the world during your sleep has not gone away, you fell asleep again. So several times... But in the end - fears tend to materialize. Already through a dream, you heard that the air has become cleaner, colder. Something is wrong. You abruptly opened your eyes...  
{@ walk start|Next...}]] end;
		if ua then p [[ Ти заснув, як зазвичай, до півночі. Сон був неспокійний, марилися інопланетяни, які схилилися над головою, але як тільки ти прокидався в жаху - ти бачив все ту ж звичну кімнату. Заспокоївшись, що світ за час твого сну нікуди не подівся, ти знову засинав. Так кілька разів... Але в кінці-кінців - страхи мають властивість матеріалізуватися. Вже крізь сон ти почув, що повітря стало чистішим, холоднішим. Щось не так. Ти різко відкрив очі...
{@ walk start|Далі...}]] end;
		end;
}

room { 
	nam = "start";
	title = function()
 		if ru then return 'Развилка'; end;
		if en then return 'Crossroads'; end;
		if ua then return 'Перехрестя'; end;
		end;
	pic = 'gfx/1.png';
	enter = function()
		snd.music 'mus/Atlantis.ogg' if firststart then snd.play('snd/breath.ogg', 1) end   bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		passedintro = true;
		end;
	dsc = function (i)
		if firststart then
			if ru then p [[А комнаты-то нет!!!]] end
			if en then p [[But there is no any room!!!!]] end
			if ua then p [[А кімнати-то немає!!!]] end
			firststart = false otherstarts = true
			return
			end
		if otherstarts then
			if ru then if not repeatplease then counter = (counter +1)%#inplaceofrespawnRU repeatplease = false; end end
			if en then if not repeatplease then counter = (counter +1)%#inplaceofrespawnEN repeatplease = false; end end
			if ua then if not repeatplease then counter = (counter +1)%#inplaceofrespawnUA repeatplease = false; end end
			if ru then return p(inplaceofrespawnRU[counter]) end -- пишем всякие сообщения при заходе на развилку
			if en then return p(inplaceofrespawnEN[counter]) end
			if ua then return p(inplaceofrespawnUA[counter]) end
			end

		end;
	decor = function()
		if ru then return "Ты в лесу! Деревья закрывают все пути отступления, есть лишь расхоженная тропа, на которой ты стоишь. Ты можешь пойти налево, направо, а можешь пойти прямо - в центре развилки растет огромный {dub|дуб}. Еще можно развернуться и пойти назад. "; end;	
		if en then return "You are in the forest! Trees block all escape routes, there is only a well-groomed path on which you stand. You can go left, right, or you can go straight ahead - a huge {dub|oak} grows in the center of the crossway. You can still turn around and go back. "; end;	
		if ua then return "Ти в лісі! Дерева закривають всі шляхи до відступу, є лише росходжена стежка, на якій ти знаходишся. Ти можеш піти наліво, направо, а можеш піти прямо - в центрі перехрестя росте величезний {dub|дуб}. Ще можна розвернутися й піти назад. "; end;	
		end;
	obj = {'dub'};
	way = {path {function()
			if ru then return 'Налево' end
			if en then return 'Left' end
			if ua then return 'Наліво' end
			 	end,
			after = function()
			if ru then return 'К хижине' end
			if en then return 'To house' end
			if ua then return 'До хатини' end
				end,
			'leftway'},
		 path {function()
			if ru then return 'Прямо' end
			if en then return 'Straight' end
			if ua then return 'Прямо' end
				end,
			after = function()
			if ru then return 'К дубу' end
			if en then return 'To oak' end
			if ua then return 'До дуба' end
				end,
			'centerway'},
		 path {function()
			if ru then return 'Направо' end
			if en then return 'Right' end
			if ua then return 'Направо' end
				end,
			after = function()
			if ru then return 'К озеру' end
			if en then return 'To lake' end
			if ua then return 'До озера' end
				end,
			'rightway'},
		 path {function()
			if ru then return 'Назад' end
			if en then return 'Back' end
			if ua then return 'Назад' end
				end,
			after = function()
			if ru then return 'К обрыву' end
			if en then return 'To fall' end
			if ua then return 'До пропасті' end
				end,
			'back'} };
}
room {
	nam = 'leftway';	
	title = function()
		if ru then return 'Хижина'; end;
		if en then return 'Humpy'; end;
		if ua then return 'Хатина'; end;
		end;
	pic = function(s)
		if holeway and brokenwithtopor and haveudochka then return 'gfx/3_2brokenwithout.png'
		elseif holeway and brokenwithtopor and not haveudochka then return 'gfx/3_2broken.png'
		elseif holeway and not brokenwithtopor  then return 'gfx/3_2.png'
		elseif not holeway and brokenwithtopor and haveudochka then return 'gfx/3brokenwithout.png'
		elseif not holeway and brokenwithtopor and not haveudochka then return 'gfx/3broken.png'
		elseif not holeway and not brokenwithtopor  then return 'gfx/3.png' end
		end;
	enter = function()
		snd.music 'mus/Atlantis.ogg' if holeway then enable '#hole' end;
		end;
	decor = function(l) 
		if ru then p [[Ты видишь старую хижину, которую построили, наверное, еще до революции. Она перекосилась, и только густой лес своими могучими ветвями не позволяет ей развалиться.]]; end;
		if en then p [[You see the old hut, which was probably built a very long time ago. It warped, and only a dense forest with it's mighty branches does not allow hut to fall apart.]]; end;
		if ua then p [[Ти бачиш стару хатину, яку побудували, мабуть, ще до революції. Вона перекосилась, і тільки густий ліс своїми могутніми гілками не дозволяє їй розвалитися.]]; end;
		if ru then if not brokenwithtopor then p [[Но {door|дверь} цела и петли на месте. Кузнец знал своё дело.]] end; end;
		if en then if not brokenwithtopor then p [[But the {door|door} is not broken and it's hinges are in place. The blacksmith knew his job.]] end; end;
		if ua then if not brokenwithtopor then p [[Але {door|двері} цілі й петлі на місці. Коваль знав свою справу.]] end; end;
		if ru then if brokenwithtopor then p [[На месте двери зияет проход внутрь.]] end; end;
		if en then if brokenwithtopor then p [[In place of the door there is a gap inward.]] end; end;
		if ua then if brokenwithtopor then p [[На місці двері зяє прохід всередину.]] end; end;
		if ru then if seen('holeopened','leftway') then p [[^Слева от хижины, между деревьев, ты видишь проход! Деревья словно расступились и теперь между ними есть проём, в который ты можешь пройти.]] end end;
		if en then if seen('holeopened','leftway') then p [[^To the left of the hut, between the trees, you see the passage! The trees seemed to have parted and now there is an opening between them that you can pass into.]] end end;
		if ua then if seen('holeopened','leftway') then p [[^Зліва від хатини, між дерев, ти бачиш прохід! Дерева ніби розступилися і тепер між ними є простір, в який ти можеш пройти.]] end end;
		end;
	way = {path {'Развилка', 'start'}, path {'#hole','В проем','trees'}:disable() , path {'#door','В дом','inhouse'}:disable() };
}:with {

	obj {
		nam = 'hole';
	     };

obj {
	nam = 'door';
	act = function(k)
		if not disabled '#door' then
			p [[Дверь открыта, замок снят.]]
			return
			end
	 	p [[На двери висит старый ржавый замок. Несмотря на это, механизм цел.]] 
		end;  
	used = function (s, w)
		if w^'fonarik' then
			p [[Ты зачем-то посветил на дверь при свете дня, и лишний раз убедился, что без ключа замок не открыть.]]
			return
		elseif w^'topor' and not openedwithkey then
			p [[Ты изрубил дверь топором, сделать это было легко. Старые трухлявые доски разлетелись в стороны. Путь открыт. Ну ты и варвар! Сюда же теперь будет попадать дождь, снег...]] evil = evil+1; snd.play('snd/axe.ogg', 1) enable '#door' brokenwithtopor = true wr = wr+1; test(); return
		elseif w^'topor' and openedwithkey then
			p [[Ты зачем-то сломал дверь, хотя она была открыта, и не было необходимости делать это. Ну ты и варвар! Сюда же теперь будет попадать дождь, снег...]] evil = evil+1; snd.play('snd/axe.ogg', 1) brokenwithtopor = true return
		elseif w^'key' and not brokenwithtopor then
			p [[Замок скрипнул, захрустел, но поддался. Ты открыл дверь.]] good = good+1; snd.play('snd/key_door.ogg', 1) openedwithkey = true; wr = wr+1; test();
			enable '#door'
			remove ('key')
			return
		end
	return false;
	end
    };
};
room {
	nam = 'inhouse';
	title = 'В хижине';
	pic = function(s) -- показываем нужное состояние в комнате, в зависимости от того, какие предметы взял игрок
		if havelopata and havevedro and haveudochka then return 'gfx/inhouse/7.png'
		elseif havelopata and havevedro and not haveudochka then return 'gfx/inhouse/11.png'
		elseif havelopata and not havevedro and not haveudochka then return 'gfx/inhouse/8.png'
		elseif havevedro and haveudochka and not havelopata then return 'gfx/inhouse/10.png'
		elseif havevedro and not haveudochka and not havelopata then return 'gfx/inhouse/9.png'
		elseif haveudochka and havelopata  and not havevedro then return 'gfx/inhouse/14.png'
		elseif haveudochka and not havevedro and not havelopata then return 'gfx/inhouse/13.png' else return 'gfx/inhouse/6.png'; end
		end;
	enter = function()
		snd.music 'mus/HouseOfEvil.ogg' if not brokenwithtopor then snd.play('snd/dooropen.ogg', 1) end
		end;
	onexit = function(a) snd.stop_music(); if not brokenwithtopor then snd.play('snd/dooropen.ogg', 1) end end;
	decor = [[Несмотря на запущенность строения, внутри эта хижина выглядит лучше, чем снаружи. Сквозь окно проникает достаточно света, чтобы осветить единственную комнату.]];
	obj = {'lopata', 'komod', 'vedro', 'udochka'};
	way = {path {'Наружу', 'leftway'} };
}
room {
	nam = 'centerway';
	title = 'Дуб';
	pic = 'gfx/2.png';
	decor = [[Ты видишь огромный дуб. В центре дуба зияет черное {light|дупло}, здесь, наверное, кто-то живет.]];
	way = {path {'Развилка', 'start'} };
}:with {
obj {  -- Дупло.
	nam = 'light';
	act = function (k)
		if not have 'fonarik' then
			p [[В дупле больше ничего нет.]]
			return
			end
		p [[Ты осмотрел дупло, но там темно, и ничего не видно.]]
		end;
	used = function (s, w)
		if w^'topor' then
			p [[Что, как, и зачем?..]] return end
		if w^'key' then
			p [[Зачем возвращать ключ в дупло?]] return
		elseif w^'fonarik' then
			p [[Ты посветил фонариком. Оттуда внезапно выскочила белка и убежала. Ты пожалел, что испугал бедное животное. Но что теперь поделать. В дупле лежал... ключ.]] -- snd.play('snd/SQ2.ogg', 1)
			snd.play('snd/flashlight.ogg', 1)
			take('key') touchedkey = true; if not touchedtopor then wr = wr+1; test(); end;
			remove('fonarik')
			return
			end
		return false;
		end
    };
}

room {
	nam = 'rightway';
	title = "Озеро";
	pic = function(s)
		if vedrostand then return 'gfx/4_2.png'
		else return 'gfx/4.png'; end
		end;
	obj = {'lake', 'bereg'};  -- 'walkfish'
	way = {path {'Развилка', 'start'} };
}
room {
	nam = 'back';
	title = 'На краю...';
	pic = function(s)
		if stonebreak then 
		return 'gfx/5_2.png'; else return 'gfx/5.png';
		end
	end;
	decor = 'Ты у пропасти. Впереди - большие и маленькие камни, подъемы и спуски, но все это опасно. Идти туда - риск, да и на горизонте не видно каких-либо построек... Вдали, на самом дне {dolina|долины} - огромными буквами выбито - прохода нет. Ты поневоле задумываешься, как же попал сюда?';
	obj = {'valun', 'топор', 'dolina'};
	way = {path {'Развилка', 'start'} };
}

obj {
	nam = 'dolina';
	act = function() 
			if ru then p[[Тот глупец, кто осмелится {down|спуститься} туда, погибнет...]]; end;
			if en then p[[That fool who dares {down|go down} there, will perish...]]; end;
			if ua then p[[Той дурень, що наважиться {down|спуститися} туди, загине...]]; end;
		end;
}:with {'down'}
obj {
	nam = 'down';
	act = function()
			if not fallen and attention then walkin ('indown')
			elseif not fallen and not attention and ru then p 'Уверен? Повтори, если да.' attention = true 
			elseif not fallen and not attention and en then p 'Are you sure? Repeat if yes.' attention = true
			elseif not fallen and not attention and ua then p 'Упевнений? Повтори, якщо так.' attention = true
			elseif ru then p 'Ты хочешь снова умереть? Бедняга.' 
			elseif en then p 'Do you want to die again? Poor fellow.' 
			elseif ua then p 'Ти хочеш знову померти? Бідолашний.' 
			 end;
		end;
}

room {
	nam = 'indown'; 
	noinv = true;
	enter = function(s)
		bg_name = 'gfx/bg_death.png' theme.gfx.bg (bg_name) fallen = true;
		deletebutton();
			timer:set(death_time);
			createredbar();
		end;
	timer = function(s)
		timer:stop();
		deleteredbar();
		theme.gfx.bg (bg_name)
		end;

	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	title ='Всё...';
	pic = 'gfx/44.png';
	decor = 'Ты погиб!';
}:with {'replay'}

obj {
	nam = 'replay';
	dsc = function()
		p ( fmt.c('{@ walkout|Переиграть?}') );
		end;
	act = function()
		walk ()
		end;
}

obj {
	nam = 'fonarik';
	disp = function()
	if ru then return fmt.img('gfx/inv/fonarik.png')..'Фонарик'; end;
	if en then return fmt.img('gfx/inv/fonarik.png')..'Flashlight'; end;
	if ua then return fmt.img('gfx/inv/fonarik.png')..'Ліхтарик'; end;
		end;
	inv = function()
		clickmute = true;
			if isusercozel then 
				waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1)
				if ru then return p'Ты попробовал взять фонарик в зубы, но это не очень хорошо получилось) Увы и ах.' end;
				if en then return p'You tried to take a flashlight in your teeth, but it didn’t work out very well) Alas.' end;
				if ua then return p'Ти спробував взяти ліхтарик в зуби, але це не дуже добре вийшло) На жаль.' end;
		else
			if ru then return p 'Привычка держать в кармане маленький китайский динамо-фонарь на этот раз оказалась очень даже кстати.' end;
			if en then return p 'The habit of holding a small Chinese dynamo flashlight in my pocket this time turned out to be very helpful.' end;
			if ua then return p 'Звичка тримати в кишені маленький китайський динамо-ліхтар на цей раз виявилася дуже навіть до речі.' end;
			end
		end;
}
obj {
	nam = 'key';
	disp = fmt.img('gfx/inv/key.png')..'Ключ';
	inv = function()
		clickmute = true;
		if isusercozel then p 'И зачем он теперь тебе?' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) elseif brokenwithtopor then p 'Теперь он тебе не нужен. Ты же поспешил, начал все крушить, ломать!' else p 'Старый, большой ключ.' end
	end;
}
obj {
	nam = 'lopata';
	disp = fmt.img('gfx/inv/lopata.png')..'Лопата';
	dsc = 'Возле окна стоит {lopata|лопата}.';
	inv = function()
		clickmute = true;
		if isusercozel then p 'Ты даже копать теперь не можешь! Какое горе...' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) else p 'Обычная, хотя и ржавая уже, лопата. Но копать еще можно.' end
		end;
	tak = function (k)
		p [[Ты взял лопату.]]; wr = wr+1; test(); havelopata = true;
		return
		end;
}

obj {
  nam = 'рыболовные снасти';
  dsc = [[В комоде есть {рыболовные снасти}.]];
  disp = fmt.img('gfx/inv/leska.png')..'Снасти';
   inv = function()
	clickmute = true;
	if isusercozel then p 'Смотри, не изрань мордочку!' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) else p 'Рыболовные снасти. Леска для удочки, крючки, поплавок.' end
	end;
   tak = function (k)
	p [[Ты взял рыболовные снасти.]]; wr = wr+1; test();
	return
	end;
   used = function (n, z)
	if z^'chervi' then p [[Нет смысла надевать червя на крючок, который не на удочке...]] return end;
	if z^'udochka' then
	p [[Ты собрал удочку.]]; wr = wr+1; test(); snd.play('snd/leskaiudochka.ogg', 1)
	take ('udsobr')
	remove ('рыболовные снасти') remove ('udochka')
	return
	end
	return false;
	end  
}
obj {
  nam = 'komod'; -- комод в хижине
  dsc = [[Старый {komod|комод} ютится в углу.]];
  used = function (n, z)
		if z^'рыболовные снасти' then
		p [[Они еще пригодятся.]];
		return
		end
	return false;
	end;
  act = function(s)
      if ( have('рыболовные снасти') or have('udochka_with_chervi') or have('udsobr') ) then p [[Комод пуст.]]
	elseif closed(s) then
          open(s) clickmute = true snd.play('snd/drawer.ogg') 
      else
         close(s) clickmute = true snd.play('snd/drawer.ogg') 
	close(s)
     end
 end;
 obj = { 'рыболовные снасти'}
}
close ('komod')

obj {
	nam = 'vedro';
	dsc = 'За кроватью стоит маленькое {vedro|ведерко}.';
	disp = fmt.img('gfx/inv/vedro.png')..'Ведро';
	inv = function()
		clickmute = true;
		if isusercozel then p 'Ты утолил жажду. Но какой ценой?!' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) else p 'Ведро из нержавеющей стали. Пустое.' end
	end;	
	tak = function (k)
		p [[Ты взял ведро.]]; wr = wr+1; test(); havevedro = true;
		return
	end;
}
obj {
	nam = 'udochka'; -- первая итерация удочки
	dsc = 'Над кроватью висит... {udochka|удочка}!';
	disp = fmt.img('gfx/inv/udochka.png')..'Удочка';
	inv = function()
		clickmute = true;
		if isusercozel then p 'Тебе она без надобности.' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) else p 'Бамбуковая удочка. Давно таких не видел. Нужны снасти.' end
		end;
	tak = function (k)
		p [[Ты аккуратно снял удочку.]]; wr = wr+1; test(); haveudochka = true;
		return
	end;
	 used = function (n, z)
		if z^'topor' then
			p [[Сломать единственную удочку, когда тебе угрожает смерть от голода? Оригинально!]] return end
		if z^'chervi' then
			p [[Сначала надо собрать удочку.]] return
		elseif z^'рыболовные снасти' then
			p [[Ты собрал удочку.]]; wr = wr+1; test(); snd.play('snd/leskaiudochka.ogg', 1)
			take ('udsobr')
			remove ('рыболовные снасти') remove ('udochka')
			return
			end
		return false;
		end  
}
obj {
	nam = 'ground';
	disp = 'земля';
	dsc = 'Под валуном сырая {ground|земля}.';
	act = function(b)
		if not have 'chervi' then
			p [[Земля под валуном - самое удобное место, чтобы накопать червей.]]
			return
		end
end; 
	used = function (n, z)
	if z^'lopata' then
		p [[Ты приложил все свои усилия и с трудом, но сумел сдвинуть валун с места. Тяжелый камень с затихающим звуком покатился вниз.  Ты принялся копать землю и вскоре собрал несколько червей.]] snd.play('snd/kamen.ogg', 1) wr = wr+1; test(); stonebreak = true;
		disable 'valun' 
		take 'chervi'
		remove ('lopata')
		return
		end
	return false;
	end
}

obj {
	nam = 'valun';
	dsc = 'Большой {valun|валун} расположен прямо на краю пропасти.';
	used = function (n, z)
			if z^'topor' and firsttopor then
				p [[Ты наточил топор.]] firsttopor = false snd.play('snd/zatochil.ogg', 1) return
			elseif z^'topor' and secondtopor then
				p [[Ты снова наточил топор.]] secondtopor = false snd.play('snd/zatochil.ogg', 1) return
			elseif z^'topor' and thirdtopor then
				p [[Достаточно.]] return
			elseif z^'lopata' then
				p [[Лопатой об камень? Придумай что-нибудь умнее.]];
			return
			end
		return false;
		end;
	act = function(t)
      		if closed(t) then open(t) else close(t) end
		end;
	obj = { 'ground'};
}

close ('valun');

obj {
	nam = 'chervi';
	disp = fmt.img('gfx/inv/chervi.png')..'Черви';
	inv = function()
		clickmute = true;
		if isusercozel then p 'Ты теперь травоядное ;)' snd.play('snd/sheep.ogg', 1) else p 'Эти черви, наверное, никогда не видели солнца, пока ты их не достал.' end
		end;
	used = function (n, z)
		if z^'udsobr' or z^'udochka' then
			p [[Логичнее воздействовать малым предметом на больший, не находишь? :)]]
		return
		end
	return false;
	end  
}
obj {  --собранная удочка, вторая итерация удочки
	nam = 'udsobr'; 
	disp = fmt.img('gfx/inv/sobr_udochka.png')..'Удочка';
	inv = function()
		clickmute = true;
		if isusercozel then p 'Тебе она без надобности. Смотри, не поранься о снасти!' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) else p 'Пора на рыбалку? Нужна наживка.' end
		end;
	used = function (n, z)
		if z^'topor' then
			p [[Сломать единственную удочку, когда тебе угрожает смерть от голода? Оригинально! А ведь ты уже собрал ее, остался всего шаг...]] return end
		if z^'chervi' then
			p [[Ты аккуратно нанизал червя на крючок.]]; wr = wr+1; test();
			take ('udochka_with_chervi')
			remove ('udsobr') remove ('chervi')
			return
			end
		return false;
		end  
}

obj { -- озеро
	nam = 'lake'; 
	dsc = function (r)
		p [[Ты видишь {lake|озеро}, которое обросло камышом. Его {bereg|берег} как будто создан для рыбалки. ]] if seen('vedrofull','rightway') then p [[На берегу озера стоит {vedrofull|ведро с водой}.]] end
		end;
	act = function(s)
        if not holeway then p "От озера веет чем-то таинственным. Водная гладь манит тебя... А что, если разгадка твоего появления здесь - как-то связана с ним?" else p [[А ведь как все хорошо начиналось... Некоторые тайны лучше и не знать. Но теперь - только в путь...]] end
        	end;	
	used = function (s, w)
		if (w^'udochka' or w^'udsobr') and firsttime then
			p [[Ты помыл в озере удочку от пыли. Держать ее в руках стало приятнее.]] firsttime = false snd.play('snd/water_lake_udochka.ogg', 1) return 
		elseif (w^'udochka' or w^'udsobr') and secondtime then
			p [[Ты второй раз окунул удочку в озеро. Она чиста до блеска.]] secondtime = false snd.play('snd/water_lake_udochka.ogg', 1) return
		elseif (w^'udochka' or w^'udsobr') and thirdtime then
 			p [[Ты третий раз намочил удочку. Тебе что, заняться нечем?!]] thirdtime = false snd.play('snd/water_lake_udochka.ogg', 1) return 
		elseif w^'udochka' or w^'udsobr' then
			p [[Ты уже помыл удочку много раз. Сделай что-нибудь другое.]] return
		elseif (w^'udochka_with_chervi' and not vedrostand and not vedrowithwater ) then
			p [[А куда ты собрался девать рыбу, когда словишь ее?]] return
		elseif (w^'udochka_with_chervi' and not vedrostand ) then
			p [[И удобно так рыбачить, держа в одной руке ведро, полное воды, а в другой удочку?]] return
		elseif (w^'udochka_with_chervi' and vedrostand and frsttime ) then p[[Наконец-то! Ты закинул удочку в озеро. Через некоторое время тебе показалось, что поплавок задергался. Ты потянул за удочку, но выловил только листик какого-то ненужного тебе растения. Может, стоит попытаться снова? ]] frsttime = false snd.play('snd/zakinul.ogg', 1) wr=wr+1; test(); return
		elseif (w^'udochka_with_chervi' and vedrostand and scndtime ) then p[[Ты второй раз закинул удочку. Долго сидел, выжидал. Наконец, увидел - клюет! Ты аккуратно, правильным движением подкосил удочку, и... снова неудача. Да что же такое? ]] scndtime = false snd.play('snd/zakinul.ogg', 1) wr=wr+1; test(); return
		elseif (w^'udochka_with_chervi' and vedrostand and thrdtime ) then clickmute = true snd.play('snd/zakinul.ogg', 1) walk 'goldfishdlg' wr=wr+1; test(); return
		elseif w^'key' and not brokenwithtopor then
			p [[Глупо выбрасывать ключ, он еще пригодится.]] return
		elseif w^'key' and brokenwithtopor then
			p [[Ты выбросил ненужный теперь ключ в озеро...]] remove('key') snd.play('snd/zakinul.ogg', 1) return
		elseif w^'vedrofull' then
			p [[В ведре уже есть вода.]] return
		elseif w^'vedro' then
			p [[Аккуратно нагнувшись, чтобы не упасть, ты набрал в ведро воды из озера.]] vedrowithwater = true snd.play('snd/awaterlap.ogg', 1) if firstfill then wr = wr+1; test(); firstfill = false end
			take ('vedrofull')
			remove ('vedro')
			return
			end
		return false;
		end
}
obj { -- ведро с водой.
	nam = 'vedrofull';
	act = function (k)
	if not holeway then p [[Ух, порыбачим!]] else p [[Вот тебе и рыбалка...]] end
	return
	end;
	used = function (n, z)
		if z^'udochka' then
			p [[Нельзя словить рыбку в ведре. Особенно, если на удочке нет снастей.]] return
		elseif z^'udsobr' then
			p [[Нельзя словить рыбку в ведре. Особенно, если ловить без наживки.]] return
		elseif z^'udochka_with_chervi' then
			p [[Нельзя словить рыбку в ведре. Особенно, если ее там нет.]];
			return
			end
		return false;
		end;
	disp = fmt.img('gfx/inv/vedrofull.png')..'Ведро';
	inv = function()
		place('drinkplease'); 
		pleasedrink = true;   
		end 
}

obj {
	nam = 'drinkplease';
	dsc = function()
		if pleasedrink and seen('lake') then p [[^^Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		if pleasedrink and seen('komod') then p [[^^Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		if pleasedrink and seen('dolina') and not stonebreak and not have('topor') then p [[^^Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		if pleasedrink and seen('dolina') and not stonebreak and have('topor') then p [[^^Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		if pleasedrink and seen('dolina') and stonebreak and not have('topor') then p [[^^Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		if pleasedrink and seen('dolina') and stonebreak and have('topor') then p [[Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		if pleasedrink then p [[Не пей, братец, козленочком станешь :) Но {возможность} у тебя никто не отбирает.]] pleasedrink = false end
		end;
	act = function(s)
		walk('kozel')
		end
}

obj { -- дуб
	nam = 'dub';
	used = function (n, z)
		if z^'topor' then
			if ru then p [[И зачем?!]] end
			if en then p [[And why?!]] end
			if ua then p [[І навіщо?!]] end
			return
		elseif z^'fonarik' then
			if ru then p [[Надо подойти поближе.]] end
			if en then p [[It is necessary to come closer.]] end
			if ua then p [[Треба підійти ближче.]] end
			return
			end
		return false;
		end;
	act = function (k)
		if ru then p [[Огромное такое дерево, на пол дороги. Наверное, оно очень старое...]]; end;
		if en then p [[A huge tree on the half of the road. It’s probably very old...]]; end;
		if ua then p [[Величезне таке дерево, на пів дороги. Напевно, воно дуже старе...]]; end;
		return
		end;
}
obj { -- удочка с нанизанным червем - третья итерация удочки
	nam = 'udochka_with_chervi';
	disp = fmt.img('gfx/inv/udochkawithchervi.png')..'Удочка';
	inv = function()
		clickmute = true;
		if isusercozel then p 'Тебе она без надобности. Смотри, не поранься о снасти! И оставь червя в покое! Брр...' waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1) else p 'Ловись, рыбка, большая и маленькая!' end
		end;
	used = function (n, z)
		if z^'topor' then
			p [[Сломать единственную удочку, когда тебе угрожает смерть от голода? Оригинально! А ведь можно закинуть ее в озеро, и...]] return 
		end
		return false;
		end;
}

obj { -- берег озера
	nam = 'bereg';
	used = function (n, z)
		if z^'lopata' then
			p [[Ты попытался накопать здесь червей, но у тебя ничего не получилось. Земля слишком плотная, сбитая, как камень. Надо поискать другое место.]] return
		elseif z^'vedro' then
			p [[Если ты хочешь порыбачить, то сначала набери воды в ведро.]] return
		elseif (z^'udochka_with_chervi' or z^'udochka' or z^'udsobr') then
			p [[Бросить отличную удочку на берег? Зачем?]] return
		elseif z^'vedrofull' then
			p [[Ты поставил ведро на берегу озера.]] place('vedrofull', 'rightway') vedrostand = true wr = wr+1; test();
			return
			end
		return false;
		end;
	act = function (k)
		p [[На берегу лесного озера ты не нашел ничего интересного.]];
		return
		end;
}

obj {
	nam = 'walkfish';
	disp = 'Рыбка';
	act = function (k) walk 'goldfishdlg' return end;
}

dlg {
	nam = 'goldfishdlg'; -- Разговор с золотой рыбкой
	noinv = true;
	title = false; 
	pic = 'gfx/7.png';
	enter = function()
		deletebutton();
		p [[Ты в третий раз закинул удочку. Волны озера разошлись в стороны, пропуская рыбу, которую ты так бесцеремонно вытащил на берег. Только когда она попала тебе в руки, ты понял, что рыбка-то не обычная, а золотая! И говорящая! Ты аккуратно снял крюк... ^ -- Кто же так с рыбками-то обращается? - золотая рыбка нервно и обижено смотрела на тебя своими мудрыми глазами, из-за ран, которые ты ей нанес. -- Так-так, так. И где же твой невод?]] snd.music 'mus/TheAngelsWeep.ogg' bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name) 
		end;
	exit = function()
		snd.music 'mus/Atlantis.ogg' bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		clickmute = true;
		snd.play('snd/awaterplouffff.ogg');
		createbutton();
		end;
	phr = { -- открыл диалог
		{'Невод? Какой невод?', '-- Ты сказки в детстве читал? Старик был один, добрый, но старуху слушался... Пошел он однажды в море, закинул невод... один раз закинул, второй... А на третий словил меня. А я чудеса творить умею. Силы морские, да и всей Земли, подвластны мне. Не потому, что я царица морская, а потому, что у природы всё едино... Та история закончилась не очень хорошо. Хотя старик и не виноват ни в чем. Но вот сейчас я снова на берегу -- поэтому и спрашиваю -- где твой невод? Что за варварские методы нынче пошли? Рыба тоже чело... рыба. Рыба тоже живое существо.',
			{'Ну... я... ээ... Заблудился я, в общем. Уснул дома, правда, спал плохо... Но когда открыл глаза - оказался здесь, в лесу. Не знаю, почему и каким образом перенесся сюда. Но выживать-то как-то надо. Нашел удочку и вот...', '-- Эх, парень. Не с того ты начал свое путешествие...',
--			 Кстати, что с глазами, болезный?	{'Не выспался...','Ну, это бывает.'}, -- sublevel 2
--				{'Да все в порядке с глазами...','Да? Значит, это художнику надо руки оторвать.', 
--					only = true; -- sublevel 3
--					{'Не надо, он хороший и старался!','Ладно!'},
--					{'Да, так ему и надо! Чтобы неповадно было халтурить.','Эх.'}
--				}, 
				{'Какое путешествие?', '-- Земля умирает. Вы, люди, уничтожаете ее.',
					{'Но...','-- Не спорь, когда с тобой говорит рыба, которой несколько сотен лет! ^ Планета гибнет, потому, что люди используют свой дар во вред себе же. Вы умеете делать удивительные вещи! А вместо этого воюете, загрязняете воздух, воду, да саму землю...',
						{'И какое я имею к этому отношение?','-- Ты избран! Человечество загнало себя в тупик... Силы природы долго молчали, но сейчас они готовы сказать свое слово. Принять решение.',
							{'О чем ты говоришь? Какое решение?','-- О том, необходим ли ваш вид. Природа погибнет, все живое может пропасть навсегда, если мы не начнем защищать себя. Мы будем вынуждены это сделать.... Но. Мы решили дать еще один, последний шанс человеку. Докажи, что люди разумны. Что они высокоморальны. Пройди этот путь! Тебе придется нелегко, но знай - на кону судьба человечества.',
								{'Какой путь? Где я?', '-- Ты в лесу. Но он не простой. Волшебство создано людьми. Не мы установили правила, но мы им подчиняемся. Многие из нас страдают.',
									{'От чего?','-- Баланс сил нарушен. Зло есть лишь в мире людей... Но вы привнесли зло в мир природы. Ваши мифы начали менять нас, наши жизни. Вы очень нелепо воспринимаете это, как байки, как что-то абсурдное. А мы существуем, причем столько же, сколько и вы сами. Меняются поколение за поколением, а ваши представления о мире духов, мире природы, мире животных -- остаются первобытными. Да, вы пытаетесь показывать этими историями мораль, но кто-то при этом все равно страдает. Так не должно быть. Впрочем... Об этом не рассказать. Ты все увидишь сам!',
										{'Куда ты?','Мне пора. Мы еще встретимся. Помни -- ты должен творить добро. Только тогда обретешь успех. Когда море высохло, я вынуждена была жить в этом маленьком озере. Иначе же от вас, людей, просто не скрыться. Ты думаешь, тебе повезло, что поймал меня? Нет... Силы природы решили мою роль в этой истории. Как и твою. Путь -- неизбежен. Но его финал зависит только от тебя. Удачи тебе, добрый молодец. Ты лучший из своего народа, уж нам-то -- в лице птиц, животных и растений -- это известно: мы повсюду. Не подведи человечество. Помни - все твои поступки оцениваются и взвешиваются. До встречи.',
											{'А как же я... Я голоден! Спаси! Накорми хоть! Я умру!!!','-- Ты можешь найти все необходимое по пути. Поверь, никто не собирается тебя убивать. Слушай то, что подсказывает тебе сердце -- и найдешь выход. Я сделала кое-что для тебя. Теперь ты можешь продолжать идти вперед. Все поймешь на месте. Удачи.', {'Рыбка!!!', function() holeway = true; remove('udochka_with_chervi') place('holeopened', 'leftway') p[[Ты не успел моргнуть и глазом, как рыбка плюхнулась в воду и умчалась прочь. "Я сделала кое-что для тебя" - сказала рыбка. Что она имела в виду?]] end };
											}, -- закрыл десятую фразу
										}, -- закрыл девятую фразу
									}, -- закрыл восьмую фразу
								}, -- закрыл седьмую фразу
							}, -- закрыл шестую фразу
						}, -- закрыл пятую фразу
					}, -- закрыл четвертую фразу
				}, -- закрыл третью фразу
			}, -- закрыл вторую фразу
		}, -- закрыл первую фразу
	    } -- закрыл диалог
} -- закрыл объект диалог

room {
	nam = 'bridge'; -- локация с мостом
	title = 'Мост';
	enter = function(s, t)
		snd.music 'mus/MiddleEarth.ogg'
		if have('lestninv') then p [[Ты решил оставить лестницу. Она тяжелая, да и незачем таскать ее с собой.]] remove('lestninv') end
		if wr == 20 and not fixed then wr = 19; end; -- опять подгонка прогресса под нужные цифры. ладно уж...
		end;
	exit = function()
		afterriver = true;
		fixed = true;
		end;
	pic = function(s)
		if not have 'vorona' and voronaonmost and not voronainriver and not sobralapples then return 'gfx/11voronanamost.png' end;
		if not have 'vorona' and voronaonmost and not voronainriver and sobralapples then return 'gfx/11voronanamostwithoutapples.png' end;
		if not have 'vorona' and not voronaonmost and not voronainriver and not sobralapples then return 'gfx/11voronapodmost.png'; end;
		if not have 'vorona' and not voronaonmost and not voronainriver and sobralapples then return 'gfx/11voronapodmostwithoutapples.png'; end;
		if have 'vorona' and not voronainriver and not sobralapples then return 'gfx/11.png' end;
		if have 'vorona' and not voronainriver and sobralapples then return 'gfx/11withoutapples.png' end;
		if voronainriver and not sobralapples then return 'gfx/11.png' end;
		if voronainriver and sobralapples then return 'gfx/11withoutapples.png' end;
		end;
	decor = function()
		p [[Ты видишь {river|реку}, видишь {kto|мост}.  ]];
		if not voronainriver and have('vorona') and voronaonmost then p [[{podmost|Под мост?}]] end;
		if not voronainriver and have('vorona') and not voronaonmost then p [[{onmost|На мост?}]] end;
		if not voronainriver and not have('vorona') and voronaonmost then p [[{kto|На мосту} {vorona|ворона} сохнет.]] end;
		if not voronainriver and not have('vorona') and not voronaonmost then p [[{takreka|Под мостом} {vorona|ворона} мокнет.]] end;
		if voronainriver then p [[Здесь больше ничего нет. Ты сделал хорошее дело. Можно идти {@ walk threeways|дальше}.]] end;
		if voronawasininv and not countedvorona then wr = wr+1; test(); countedvorona = true end;
		if voronawasininv and not have('vorona') and not voronainriver then p [[Ты можешь идти {@ walk threeways|дальше} или подумать еще.]] end;
		end;
	obj = {'river', 'takreka', 'kto', 'onmost', 'podmost', 'vorona'};
}

room {
	nam = 'trees';
	title = 'Говорящие деревья';
	enter = function() if waytohouseback then enable '#waytooutside' end;
		if firstintrees then wr = wr+1; test(); soglasen = true end snd.music 'mus/LegendsOfTheRiver.ogg' if have 'key' then p [[Ты потерял ключ в траве... Он выпал, а ты и не заметил.]]; remove('key'); end
		if not touchedkey and not belkaincremented then wr = wr+1; test(); belkaincremented = true end; -- если не касался дупла и не видел белку - при заходе к деревьям выравниваем прогресс. Да, костыльно. Но как умею(
		end;
	onexit = function(s, t)
		if izrubilappletrees and not belkaseen and not t^'houseoutside' then wr = wr+4 test() end; -- компенсация прогресса, если изрубил деревья
		if izrubilappletrees and belkaseen and not lestntaken and not t^'houseoutside' then wr = wr+3 test() end;
		if izrubilappletrees and belkaseen and lestntaken and not t^'houseoutside' then wr = wr+2 test() end;
		end;
	pic = function()
		if izrubilappletrees and not sobralapples then return 'gfx/12afteraxe.png' end;
		if izrubilappletrees and sobralapples then return 'gfx/12afteraxewithoutapples.png' end;
		if sobralapples then return 'gfx/12withlestn_withoutappl.png' end;
		if not sobralapples and lestnicastand then return 'gfx/12withlestn_withappl.png' end;
		if not sobralapples and not izrubilappletrees and soglasen and firstintrees then return 'gfx/12withapples.png' end;
		if not sobralapples and not izrubilappletrees and not soglasen and firstintrees then return 'gfx/12withapples.png' end;
		if not sobralapples and not izrubilappletrees and soglasen then return 'gfx/12withapples.png' end;
		if not sobralapples and not izrubilappletrees and not soglasen then return 'gfx/12withapples_sad.png' end;
		end;
	decor = function()
		p [[Ты видишь два {treesobj|дерева}.]]; if not izrubilappletrees then p [[Они живые!]] else p [[Они живые! И раненые...]] end; p [[Ты можешь пройти {walktobridge|дальше} или {youcantalk|поговорить} с ними.]]; if aftertalkwithtrees and not sobralapples then p [[Или {sobratapples|собрать} яблоки с деревьев.]]; if belkaishere then p [[Рядом с тобой стоит {belka|белка}!]] end; end;
		if izrubilappletrees and not takedpoison then p [[Одно {takepoison|яблоко} упало, когда ты рубил деревья...]] end;
		end;
	way = { path {'#waytooutside','Идти за хижину','houseoutside'}:disable() };

}:with {'treesobj', 'walktobridge', 'youcantalk', 'sobratapples', 'belka', 'takepoison', 'waytooutside'}

obj {
	nam = 'waytooutside';
};

obj {
	nam = 'takepoison';
	act = function()
		take('poison_apple');
		p [[Ты поднял яблоко...]];
		takedpoison = true;
		end;
}

obj {
	nam = 'holeopened'; -- метка открытого прохода к мосту
}

obj {
	nam = 'belka';
	act = function()
		if izrubilappletrees then p [[Белка увидела твои разъяренные глаза, топор в руках и побежала прочь.]] belkaishere = false end
		if not izrubilappletrees and not touchedkey and not napugal then walk 'talkwithbelka2' end
		if not izrubilappletrees and touchedkey and not napugal then walk 'talkwithbelka' end
		if not izrubilappletrees and not touchedkey and napugal then walk 'talkwithbelka3' end
		if not izrubilappletrees and  touchedkey and napugal then walk 'talkwithbelka4' end
		end;
	used = function(n, z)
		if z^'topor' then p [[Стоило тебе взмахнуть топором, как белка в ужасе убежала...]] belkaishere = false napugal = true end
		end;
}

dlg {
	nam = 'talkwithbelka';
	pic = 'gfx/19.png';
	noinv = true;
	title = 'Белка';
	enter = function()
		p 'Что-то знакомое тебе показалось при виде этой белки. Где-то ты ее видел?^^ -- О, какие люди! И без фонарика?';
	 	bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function() 
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- Начало фразы
			{'Т..ты? Это была ты?','-- А кто же еще? Я как раз дремала себе тихо, а тут в глаза луч! Я уж думала, всё, не жить мне больше, и не видеть белый свет.',
				only = true;
				{'Да ладно? Я сам испугался, когда ты выскочила!','-- Чего уж там. Так какими судьбами я понадобилась такому отважному рыцарю, как ты? *хихикает*',
					{'Слушай, помоги, а? Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Ой. Так уж и быть, помогу тебе. Тем более, все наслышаны о миссии. Спасти человечество! Это не мелочь какая-нибудь...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Ладно, не нагнетай! Сам боюсь. Итак, что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function()p 'Белка убежала, словно её никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true wr = wr+1; test(); walk 'trees' end }
							},
						},
					},
				}, -- конец первого разветвления
				{'Извини меня! Я не со зла. Я же не знал, что там можешь оказаться ты! Я бы не делал так!','-- Ой, оправдывается он. Говори уже, чего хотел? Помогу, если в моих силах.',
					{'Помоги, белочка, хорошая. Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Ой. Так уж и быть, помогу тебе. Тем более, все наслышаны о миссии. Спасти человечество! Это не мелочь какая-нибудь...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Знаю. Самому страшно. Но что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function() p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true wr = wr+1; test(); walk 'trees' end }
							},
						},
					},
				}, -- конец второго разветвления
			}
	    } -- Конец фразы
}
					
dlg {
	nam = 'talkwithbelka2'; -- Диалог, если не заглядывал в дупло и не встречался с белкой в первый раз
	pic = 'gfx/19.png';
	noinv = true;
	title = 'Белка';
	enter = function()
		p 'Ты подумал, что вот, теперь и к тебе пришла белочка...^ -- Ну привет, привет. Отважный герой идет спасать мир. Старая история. Только на этот раз все взаправду.';
	 	bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function() 
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- Начало фразы
			{'Ты - говорящая белка?','-- Вот почему это тебя так удивляет? Можно подумать, вы, люди, между собой не общаетесь... Этот лес - волшебный. Здесь работают совсем иные законы. Скоро ты начнешь это понимать. Как и свою миссию. Смотри, чтобы не было поздно!',
				only = true;
				{'Да-да, меня золотая рыбка уже просветила... Почему я? Почему один человек решает всё?','-- Ты спрашиваешь это у белки? Таков закон, смирись. Так зачем я понадобилась тебе? Деревья не свистят по пустякам.',
					{'Слушай, помоги, а? Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Ой. Так уж и быть, помогу тебе. Тем более... спасти человечество! Это не мелочь какая-нибудь... Да и деревья заслуживают лучшей участи. Вы, люди, для того и созданы, чтобы помогать природе. А не разрушать ее...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Ладно, не нагнетай! Сам боюсь. Итак, что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function()p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true walk 'trees' end }
							},
						},
					},
				}, -- конец первого разветвления
				{'Поверь, я все понимаю. Я хочу справиться, сделать все хорошо. Но почему всё зависит от меня одного?','-- Друг, ты спрашиваешь это у белки. Таков закон - это все, что я знаю. Скажи, в чем нуждаешься - и если смогу - помогу.',
					{'Да, помоги, белочка, хорошая! Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Так уж и быть, помогу тебе. Тем более, все наслышаны о миссии. Спасти человечество! Это не мелочь какая-нибудь...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Знаю. Самому страшно. Но что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function() p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true walk 'trees' end }
							},
						},
					},
				}, -- конец второго разветвления
			}
	    } -- Конец фразы
}

dlg {
	nam = 'talkwithbelka3'; -- Диалог, если замахнулся топором на белку, но не заглядывал перед этим в дупло
	pic = 'gfx/19.png';
	noinv = true;
	title = 'Белка';
	enter = function()
		p 'Белка осторожно приблизилась к тебе...^ -- Ты знаешь, что нехорошо махать топором перед беззащитной белкой? Вот же ж народ-то пошел, а? Чего тебе?';
	 	bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function() 
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- Начало фразы
			{'Ты - говорящая белка?','-- Вот почему это тебя так удивляет? Можно подумать, вы, люди, между собой не общаетесь... Этот лес - волшебный. Здесь работают совсем иные законы. Скоро ты начнешь это понимать. Как и свою миссию. Смотри, чтобы не было поздно!',
				only = true;
				{'Да-да, меня золотая рыбка уже просветила... Почему я? Почему один человек решает всё?','-- Ты спрашиваешь это у белки? Таков закон, смирись. Так зачем я понадобилась тебе? Деревья не свистят по пустякам.',
					{'Слушай, помоги, а? Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Ой. Так уж и быть, помогу тебе. Тем более... спасти человечество! Это не мелочь какая-нибудь... Да и деревья заслуживают лучшей участи. Вы, люди, для того и созданы, чтобы помогать природе. А не разрушать ее...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Ладно, не нагнетай! Сам боюсь. Итак, что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function()p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true walk 'trees' end }
							},
						},
					},
				}, -- конец первого разветвления
				{'Поверь, я все понимаю. Я хочу справиться, сделать все хорошо. Но почему всё зависит от меня одного?','-- Друг, ты спрашиваешь это у белки. Таков закон - это все, что я знаю. Скажи, в чем нуждаешься - и если смогу - помогу.',
					{'Да, помоги, белочка, хорошая! Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Так уж и быть, помогу тебе. Тем более, все наслышаны о миссии. Спасти человечество! Это не мелочь какая-нибудь...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Знаю. Самому страшно. Но что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function() p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true walk 'trees' end }
							},
						},
					},
				}, -- конец второго разветвления
			}
	    } -- Конец фразы
}

dlg {
	nam = 'talkwithbelka4'; -- Диалог, если замахнулся топором на белку, и заглядывал перед этим в дупло
	pic = 'gfx/19.png';
	noinv = true;
	title = 'Белка';
	enter = function()
		p 'Белка осторожно приблизилась к тебе...^^ -- О, какие люди! И без фонарика? Ты знаешь, что нехорошо махать топором перед беззащитной белкой? Вот же ж народ-то пошел, а? Чего тебе?';
	 	bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function() 
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- Начало фразы
			{'Т..ты? Это была ты?','-- А кто же еще? Я как раз дремала себе тихо, а тут в глаза луч! Я уж думала, всё, не жить мне больше, и не видеть белый свет.',
				only = true;
				{'Да ладно? Я сам испугался, когда ты выскочила!','-- Чего уж там. Так какими судьбами я понадобилась такому отважному рыцарю, как ты? *хихикает*',
					{'Слушай, помоги, а? Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Ой. Так уж и быть, помогу тебе. Тем более, все наслышаны о миссии. Спасти человечество! Это не мелочь какая-нибудь...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Ладно, не нагнетай! Сам боюсь. Итак, что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function()p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true wr = wr+1; test(); walk 'trees' end }
							},
						},
					},
				}, -- конец первого разветвления
				{'Извини меня! Я не со зла. Я же не знал, что там можешь оказаться ты! Я бы не делал так!','-- Ой, оправдывается он. Говори уже, чего хотел? Помогу, если в моих силах.',
					{'Помоги, белочка, хорошая. Мне надо продолжать путь, но деревья отказываются пропускать, если не соберу их яблоки. Другого прохода нет, а яблоки я не достаю... Мне нужно на что-то стать, чтобы подняться повыше. Но что я могу найти здесь, в лесу...','-- Ой. Так уж и быть, помогу тебе. Тем более, все наслышаны о миссии. Спасти человечество! Это не мелочь какая-нибудь...',
						{'Почему все знают больше, чем я?','-- А как ты хотел? Только трудный путь покажет, на что ты способен. А ведь на тебя смотрит весь мир природы!',
							{'Знаю. Самому страшно. Но что ты говорила о помощи?','-- Посмотри за хижиной. Там есть то, что ты ищешь.',
								{'Спасибо, но...', function() p 'Белка убежала, словно ее никогда и не было.' waytohouseback = true belkaishere = false onceopened = true belkaseen = true wr = wr+1; test(); walk 'trees' end }
							},
						},
					},
				}, -- конец второго разветвления
			}
	    } -- Конец фразы
}

obj {
	nam = 'топор'; -- топор на сцене
	seen = false;
	dsc = function(s)
		if not s.seen then
			uvideltopor = true;
			if ru then return p'В траве {что-то} лежит.'; end;
			if en then return p'There is {something} in the grass.' end;
			if ua then return p'У траві {щось} лежить.'; end;
		else
			if ru then return p 'В траве ты увидел {топор|топор}!'; end;
			if en then return p 'You saw an {топор|axe} in the grass!' end;
			if ua then return p 'У траві ти помітив {топор|сокиру}!' end;
		end
		end;
	act = function(s)
		if s.seen then
			remove ('топор');
			touchedtopor = true;
			take 'topor'; if not touchedkey then wr = wr+1; test();
				if ru then return p'Ты взял топор.'; end;
				if en then return p'You took an axe.'; end;
				if ua then return p'Ты взяв сокиру.'; end;
			  end;
			else
			s.seen = true;
			if ru then return p'Гм... Это же топор!'; end;
			if en then return p'Um. This is an axe!'; end;
			if ua then return p'Ой, так це ж сокира!'; end;
			end
		end;
};

obj {
	nam = 'topor'; -- топор в инвентаре
	disp = function()
	if ru then return fmt.img('gfx/inv/topor.png')..'Топор'; end;
	if en then return fmt.img('gfx/inv/topor.png')..'Axe'; end;
	if ua then return fmt.img('gfx/inv/topor.png')..'Сокира'; end;
		end;
	inv = function()
		clickmute = true;
		if isusercozel and not removetopor then 
			 waycounter = waycounter+1 snd.play('snd/sheep.ogg', 1)
			if ru then p 'Орудие казни... Гены предыдущих поколений козликов отозвались в тебе глубинным, животным ужасом, при виде этого предмета.' end
			if en then p 'The instrument of execution... The genes of previous generations of goats echoed in you with deep, animal horror at the sight of this object.' end
			if ua then p 'Знаряддя страти... Гени попередніх поколінь козликів відгукнулися в тобі глибинним, тваринам жахом, при погляді на цей предмет.' end
			elseif not removetopor then
			if ru then p 'Неплохой топор, старинного образца. Откуда он здесь?' end
			if en then p 'Nice axe, old-fashioned. Where is it from?' end
			if ua then p 'Непогана сокира, стародавнього зразка. Звідки вона тут?' end
		 	end
		if removetopor then
			if ru then p'Ты выбросил топор. Хорошая вещь, но добраться до деревни важнее...' end
			if en then p'You threw the ax away. Good thing, but getting to the village is more important...' end
			if ua then p'Ти викинув сокиру. Хороша річ, але дістатися до селища важливіше...' end
			 remove('topor') walk('longroad22') end;
		end;
}

obj {
	nam = 'treesobj';
	act = function()
		if not sobralapples and not izrubilappletrees then p [[Ты внимательно посмотрел на деревья. Они во всём похожи на обычные, только с носами, глазами и ртами. Деревья  смотрят на тебя в ответ дружелюбно, но, кажется, что-то их гнетет. ]] elseif sobralapples and not izrubilappletrees then p [[Ты внимательно посмотрел на деревья. Они во всём похожи на обычные, только с носами, глазами и ртами. Деревья  смотрят на тебя в ответ дружелюбно и с благодарностью. ]] end
		if izrubilappletrees then p [[Деревья смотрят на тебя со злобой, обидой и отчаянием. Они не ожидали такого обращения! За что?!]] end
		end;
	used = function (n, z)
		if z^'fonarik' then p [[Зачем светить посреди белого дня на деревья?]] end;
		if z^'lestninv' and not izrubilappletrees then p [[Ты поставил лестницу к одному из деревьев. Теперь можно собирать яблоки.]] lestnicastand = true remove('lestninv') wr = wr+1; test(); end;
		if z^'lestninv' and izrubilappletrees then  p [[Ты попробовал поставить лестницу к одному из деревьев. Изрубленные ветви с треском обломались и ты полетел вниз... Потирая ушибы и ссадины, ты начал медленно понимать, что насильно мил не будешь... Лучше оставить это и идти дальше...]] end;
		if z^'topor' and sobralapples then p [[Ты можешь просто пройти. Не надо поступать по-свински. Деревья надо беречь, они дарят тебе воздух. Почему приходится объяснять элементарное?]] end;
		if z^'topor' and lestnicastand and not sobralapples then p [[До сих пор не можешь определиться, помочь ли деревьям, или изрубить их? Будь последовательнее... Начал одно - так сделай до конца.]] end;
		if z^'topor' and izrubitapple and not lestnicastand then p [[Надо ли творить подобный ужас? Повтори, если уверен в своих действиях...]] izrubitapple = false return end;
		if z^'topor' and not izrubitapple and not lestnicastand and izrubilappletrees then p [[Остановись!]]  end
		if z^'topor' and not izrubitapple and not lestnicastand and not izrubilappletrees then p [[Ты безжалостно изрубил деревья. Они плачут горькими слезами и смотрят на тебя с укором. Что же ты наделал!]] izrubilappletrees = true end
		end;
}

obj {
	nam = 'poison_apple';
	disp = fmt.img('gfx/inv/one_apple_poison.png')..'Яблоко';
	inv = function()
		place 'eatpleasepoison';
		pleaseeatpoison = true;
		end;
}

obj {
	nam = 'eatpleasepoison';
	dsc = function()
		if pleaseeatpoison and not triedtoeat then p 'Странное яблоко. Добытое зверским способом... Ты можешь его {съесть}, если не боишься и совесть не мучает.' pleaseeatpoison = false
		elseif pleaseeatpoison and triedtoeat then p 'Странное яблоко. Добытое зверским способом...' pleaseeatpoison = false end
		end;
	act = function(s)
		p [[Ты съел яблоко...]]
		remove(s);
		triedtoeat = true;
		walk ('youdead')
		end
	    
}

room {
	nam = 'youdead';
	noinv = true;
	title = 'Кирдык!';
	pic = 'gfx/42.png';
	enter = function(s)
		bg_name = 'gfx/bg_death.png' theme.gfx.bg (bg_name)
		deletebutton();
			timer:set(death_time);
			createredbar();
		end;
	timer = function(s)
		timer:stop();
		deleteredbar();
		theme.gfx.bg (bg_name)
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	decor = [[Ты умер!]];
}: with {
	obj {
	dsc = function()
	p ( fmt.c('{@ walkout|Переиграть?}') );
-- [[{Переиграть?}]];
	end;
	act = function()
--	snapshots:restore()
	walk ()
	end;
	}
}

obj {
	nam = 'walktobridge';
	act = function()
		if cantdothat and onceopened and not izrubilappletrees then p [[Ты не можешь пройти, пока не поможешь деревьям.]] end
		if cantdothat and not onceopened and not belkaishere then walk 'talkwithtrees2' end 
		if cantdothat and not onceopened and belkaishere and not izrubilappletrees then p[[Ты не можешь пройти, пока не поможешь деревьям. Может, лучше поговорить с белкой?]] end
		if propustili and not izrubilappletrees and not cantdothat then walk 'bridge' elseif not propustili and not izrubilappletrees and not cantdothat then walk 'talkwithtrees' end
		if izrubilappletrees then walk 'bridge' end
		end;
}

obj {
	nam = 'youcantalk';
	act = function()
		if cantdothat and onceopened and not izrubilappletrees then p [[Ты уже знаешь, что делать.]] end
		if cantdothat and not onceopened and not belkaishere and not izrubilappletrees then walk 'talkwithtrees2' end 
		if cantdothat and not onceopened and belkaishere then p[[Может, лучше поговорить с белкой?]] end
		if sobralapples and not izrubilappletrees and not cantdothat then p[[Деревья довольны и счастливы, созрецательно смотрят в небо, их головы кружатся от легкости. Им не до тебя.]] elseif not sobralapples and not izrubilappletrees and not cantdothat then walk 'talkwithtrees' end
		if izrubilappletrees then p [[Деревья не желают говорить с тобой. Ты им отвратителен.]] end
		end;
}

obj {
	nam = 'sobratapples';
	act = function()
		if izrubilappletrees then p [[Поздно. Не видать теперь тебе яблочек. И чем ты думал?!]] end;
		if not lestnicastand and not izrubilappletrees then p [[Ты попытался достать до деревьев, но они слишком высокие. Надо придумать способ добраться до ветвей.]] cantdothat = true end;
		if lestnicastand and not izrubilappletrees then 
		sobralapples = true cantdothat = false p [[Тебе пришлось хорошенько потрудиться, чтобы достать до каждого яблока. Спустя час все было готово.]] wr = wr+1; test(); end;
		end;
}

dlg {
	nam = 'talkwithtrees2'; -- после того, как попробовал достать яблоки, переходим на этот диалог
	pic = 'gfx/12withapples.png';
	noinv = true;
	title = 'Говорящие деревья';
	enter = function()
		if not izrubilappletrees then p [[-- Ты уже собрал яблоки? Помоги нам!]] end
	 	bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function(s, t)
		createbutton();
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name)
		clickmute = true;
		if aftertalkwithtrees and belkaishere then snd.play ('snd/whistle.ogg', 1); end;
		if aftertalkwithtrees and belkaishere then snd.play('snd/SQ2.ogg', 2) end;
		end;
	phr = { -- Начало фразы
			{'Я бы и рад, но не могу! Не достаю до ваших ветвей! Подскажите же, что мне делать?', '-- Эм... Хм... Уу... Так! У нас есть подруга, которая может помочь.',
				{ function() if touchedkey then p 'Подруга?' else p 'Подруга? Разве у деревьев бывают друзья?' end end , function() if touchedkey then p '-- Да. Вы уже виделись. Хе-хе.' else p 'Даже больше. У нас есть душа.' end end,
					{ function() if touchedkey then p 'Кто? Когда?' else p 'Не знал...' end end, function() p[[Деревья издали свист, от которого у тебя почти начали лопать перепонки... И на этот свист явилась.... белка!]] belkaishere = true soglasen = true end }
				}			
			}
	      } -- Конец фразы
}

dlg {
	nam = 'talkwithtrees';
	pic = function()
		if not sobralapples then return 'gfx/12withapples.png' else return 'gfx/12withlestn_withoutappl.png' end 			end;
	noinv = true;
	title = 'Говорящие деревья';
	enter = function()
		deletebutton();
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name) firstintrees = false
		if not sobralapples then p[[Ты собрался было ступить вперед, как деревья своими ветвями перегородили дорогу. ^^-- Куда путь держишь, странник?]] end;
		if sobralapples then p [[-- Проходи. За то, что ты сделал, мы дарим тебе все свои плоды. Бери столько, сколько сможешь унести. Между прочим, яблочки наши не простые, а с секретом. Но тебе его знать рано ;)]] take 'apples' end;
		end;
	exit = function(s, t)
		createbutton();
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		clickmute = true;
		if not soglasen and t^'trees' then snd.play ('snd/trees_sigh.ogg', 1); end;
		if soglasen and t^'trees' then snd.play ('snd/trees_sigh_happy.ogg', 1) end;
--	p (here()); 
--	p (t);
		end;
        phr = { -- начало фразы
		{function() if not sobralapples then p [[Пропустите меня, славные сказочные деревья! У меня важная миссия. Я мир спасаю. Да и просто надо выбраться отсюда!]] else p [[{@ walk bridge|Спасибо!}]] end  end ,'-- Извини, но мы не можем тебя пропустить. Хочешь пройти -- помоги нам!',
			{'Чем же я могу помочь-то?','-- Оборви нас! Мы стоим здесь, на пути, очень давно, и никто не приходил, не срывал с нас яблоки. Очень трудно стоять, когда твои ветви ломятся от плодов, и ты ничего не можешь сделать... Яблочки наши сочные, вкусные, а ты, наверное, голоден.',
				{'Да, просто умираю от истощения!','-- Поможешь нам?',
					only = true;
				{'Как-нибудь в другой раз.', function() p '-- *синхронно* Эх.' aftertalkwithtrees = true soglasen = false end }, 
				{'Да, конечно!', function() p '-- Сделай это, пожалуйста! И проход твой.' aftertalkwithtrees=true soglasen = true end }
					},
					},
				} -- закрывает оч прошу
	      } -- конец фразы
}

room {
	nam = 'houseoutside';
	title = 'За хижиной';
	pic = function()
		if lestntaken then return 'gfx/21.png' else return 'gfx/20.png' end;
		end;
	decor = function()
		p [[Светло-снежная, задняя стена дома резко контрастирует с буйной растительностью этого места. Ты начинаешь ощущать, что ты и правда в сказке. Правда сказка эта с горчинкой...]] if not lestntaken then p 'К стене хижины прислонена {lestn|лестница}.' end
		end;
	way = { path{'К деревьям', 'trees'} };
	enter = function()
		if not wow then p 'Ух ты! Это же лестница!' wow = true end;
		if not uvideltopor then place('топор', 'houseoutside') end;
		end;
	obj = {'lestn'};
}

obj {
	nam = 'lestn';
	act = function()
	lestntaken = true;
	take 'lestninv';
	p [[Ты схватил лестницу двумя руками. Тяжелая!]]; wr = wr+1; test();
	end;
}

obj {
	nam = 'lestninv';
	disp = fmt.img('gfx/inv/lestnica.png')..'Лестница';
	inv = [[Лестница.]];

}

obj {
	nam = 'vorona';
	disp = fmt.img('gfx/inv/vorona.png')..'Ворона';
	act = function()
		p [[Взял ворону ты за хвост...]] take 'vorona' voronawasininv = true
		end;
	inv = [[Что делать с вороной? - вот в чем вопрос. Она уже не жилец...]];
}

obj {
	nam = 'river';
	act = [[Обычная река. Но тебя она наталкивает на философские мысли о бренности бытия и быстротечности времени.]];
	used = function (n, z)
		if z^'vorona' then
		p [[Ты выбросил мёртвую ворону в реку.]] remove ('vorona') voronainriver = true  snd.play('snd/awaterplouffff.ogg', 1) return end
		return false;
		end;
}

obj {
	nam = 'onmost'; 
	act = [[Возьми ворону.]];
	used = function (n, z)
		if z^'vorona' then
			p [[Положил на мост, пусть ворона сохнет.]] voronaonmost = true drop('vorona', 'bridge') return
			end
		return false;
		end;
}
obj {
	nam = 'podmost';
	act = [[Возьми ворону.]];
used = function (n, z)
		if z^'vorona' then
			p [[Положил под мост, пусть ворона мокнет.]] voronaonmost = false drop('vorona', 'bridge') return
			end
		return false;
		end;
}

obj { 
	nam = 'kto'; 
	act = [[Интересно, кто его построил?]];
	used = function (n, z)
		if z^'vorona' then
			p [[Положил на мост, пусть ворона сохнет.]] voronaonmost = true drop('vorona', 'bridge') return
			end
		return false;
		end; 
}

obj { nam = 'takreka'; act = [[Под мостом также река.]]; }

obj {
	nam = 'apples';
	disp = fmt.img('gfx/inv/apples.png')..'Яблоки';
	inv = function()
		place 'eatplease';
		pleaseeat = true;
		end;
}

obj {
	nam = 'eatplease';
	dsc = function()
		if pleaseeat and not updatescene then p 'Вкусные, сочные яблоки. Может, {съесть} их? Или, может, лучше подождать?  Ты вспомнил слова деревьев, о том, что яблоки с секретом... Что они сделают с тобой на этот раз?' pleaseeat = false end
		if pleaseeat and updatescene then p 'Вкусные, сочные яблоки. Тебе не терпится {съесть} их.' pleaseeat = false end
		end;
	act = function(s)
		p [[Ты с аппетитом съел яблоки, пока, наконец, чувство голода не прошло. У тебя осталось только одно яблоко.]]
		remove(s);
		remove('apples');
		take('one_apple');
		eatenapples = true;
		if updatescene then walk('longroad6') end; -- это надо для того, чтобы включить переход дальше после того, как съел яблоки
--			replace ('apples', 'one_apple');
		end
	    }

obj {
	nam = 'one_apple';
	disp = fmt.img('gfx/inv/one_apple.png')..'Яблоко';
	inv = function()
		if not updatescene2 then p [[Оставил на будущее.]] end;
		if updatescene2 then p[[Ты съел последнее своё яблоко... Это почти никак тебя не насытило.]] remove('one_apple') walk('longroad13') end; -- это надо для того, чтобы включить переход дальше после того, как съел яблоко
		end;
}

room {
	nam = 'threeways';
	disp = 'Три дороги';
	pic = 'gfx/13.png';
	decor = [[Три пути. И {tostone|камень} перед ними. Рядом с тобой стоит {horse|конь}! ]];
	obj = {'tostone', 'horse', 'enableleft', 'enablecenter', 'enableright'};
	way = { path {'#enableleft', 'Налево', 'leftroom'}:disable(), path {'#enablecenter', 'Прямо', 'centerroom'}:disable(), path {'#enableright', 'Направо', 'rightroom'}:disable(), path{'#openbridge', 'К вороне', 'bridge'}:enable() };
	enter = function()
		snd.music 'mus/TheVoyage.ogg'
		if stoneseen and talkedwithhorse then enable('#enableleft') end
		if stoneseen and talkedwithhorse then enable('#enablecenter') end
		if stoneseen and talkedwithhorse then enable('#enableright') end
		if voronainriver then disable('#openbridge') end
		if have 'fonarik' then p [[Проходя через мост, ты уронил фонарик... Он выпал из кармана прямо в реку. Какая досада!]]; remove('fonarik'); snd.play('snd/awaterplouffff.ogg', 1) end
		end
}

obj { nam = 'enableleft' };
obj { nam = 'enablecenter' };
obj { nam = 'enableright' };

obj {
	nam = 'tostone';
	act = function()
		walkin ('instone')
		end;
}
obj {
	nam = 'openbridge';
    };

obj {
	nam = 'horse';
	act = function()
		clickmute = true;
		snd.play('snd/horse.ogg', 1)
		p [[Конь появился здесь, как только ты переступил через мост. Он молча смотрит на тебя, иногда пощипывая травку.]]; 		if not talkedwithhorse then p [[{tohorse|Подойти} к нему?]] else p [[Конь ждёт твоего решения. Видно, что он взволнован.]] end;	
		end;
}:with {'tohorse'}
obj {
	nam = 'tohorse';
	act = function()
		walkin ('talkwithhorse') 
		end;
}

dlg {
	nam = 'talkwithhorse';
	pic = 'gfx/17.png';
	noinv = true;
	title = false; 
	enter = function()
		talkedwithhorse = true;
		wr = wr + 1;
		p [[Конь посмотрел на тебя, и... заговорил:^ -- Вот мы и встретились.]] 
	 	bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
			{'Ты умеешь говорить?', '-- Да, как и все сказочные животные.',
				{'И ты пришел сюда...', '-- Потому, что мне велели. Это закон, и я должен подчиниться. Обычно путники сюда являются на своих конях, но ты же у нас избранный... Дрянная эпоха!',
						only = true;
						{'Извини... Мне правда жаль. Меня тоже перенесли из уютной постели в это место... Думаешь, мне сладко? Давай уж как-то выбираться вместе.', function() p'-- Ладно. Так уж и быть. Буду твоим конем, вольно или невольно, какая теперь разница... Но побереги меня. Пригожусь еще тебе, будь уверен!' walk('threeways') end }, 
						{'Мне все равно. Я должен продолжать путь. Тебе придется, в таком случае, подчиниться. Не дави на жалость.', function() p'-- Зря ты так. Потом же зачтется всё... Подумай хорошо, прежде чем что-то предпринимать. Да и меня побереги - пригожусь...' walk('threeways') end }					
				}
			}
	      } -- конец фразы
}

room {
	nam = 'instone';
	noinv = true;
	disp = 'Возле камня';
	pic = 'gfx/13_2.png';
	enter = function()
		bg_name = 'gfx/bg_good.png' theme.gfx.bg (bg_name) 
		if not stoneseen then wr = wr+1; end;
		stoneseen = true;
		end;
	decor = fmt.c('^На древнем камне выбито: ^^ Налево пойдёшь – себя потеряешь, коня спасёшь.^ Направо пойдёшь – коня потеряешь, себя спасёшь.^ Прямо пойдёшь – и себя, и коня потеряешь.');	
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		end;
	way = { path{'Отойти от камня', 'threeways'} };
}

room {
	nam = 'kozel';
	pic = 'gfx/14.png';
	disp = 'А тебя предупреждали!';
	decor = function()
		p [[Теперь ты козленочек! =) Мааалеенький. ]]
		if waycounter > 3 then p [[Таак. И что же теперь делать?]] end
		if waycounter > 5 then p [[Это сказочный мир, верно?]] end
		if waycounter > 7 then p [[Как у нас дела в сказках решаются?]] end
		if waycounter > 9 then p [[Сказочными же методами.]] end
		if waycounter > 11 then p [["А козленочек три раза..."]] end
		if waycounter > 13 then p [["Перекинулся через голову..."]] end
		if waycounter > 15 then p [["И обернулся назад человеком!"]] end
		if waycounter > 17 then p [[Вот, в чем секрет!]] end
		if waycounter > 19 then p [[Итак. {onering|Один}.]] end
		if twopress then p [[{tworing|Два}.]] end  
		if threepress then p [[{threering|Три}!]] end 
		end;
	enter = function()
		snd.music 'mus/ChasinIt.ogg'
		isusercozel = true;
		waycounter = 0;
		onepress = false;
		twopress = false;
		threepress = false;
		twocheck = false;
		remove('vedrofull');
		take('vedro');
		if from() ~= 'info_room' and from() ~= 'control_room' then fromwhere = from(); end; -- чтобы не вовзращаться в технические комнаты
		end;
	exit = function()
		if inroom ( me() ) == 'inhouse' then snd.music 'mus/HouseOfEvil.ogg' else snd.music 'mus/Atlantis.ogg' end
		isusercozel = false;
		if twopress and threepress then clickmute = true; snd.play('snd/roundkozel.ogg', 1) end;
		end;
	obj = {'onering', 'tworing', 'threering'};
}
obj {
	nam = 'onering';
	act = function()
		twopress = true
		if not onepress then p [[Ты перевернулся через голову. Это непривычно. Зато подумай - никто из людей не переживал подобное. Хотя козлов много)]] clickmute = true; snd.play('snd/roundkozel.ogg', 1) onepress = true end
		end;
}
obj {
	nam = 'tworing';
	act = function()
		if twopress then threepress = true end
		if not twocheck and twopress then  p [[Ты второй раз сделал кувырок и опустился на свои четыре. Ухх!]] clickmute = true; snd.play('snd/roundkozel.ogg', 1) twocheck = true end
		end;
}
obj {
	nam = 'threering';
	act = function()
		if twopress and threepress then p [[Ура! Ты снова человек. Что это вообще было? Странная водичка. Лучше не пить больше из водоемов, от греха подальше.]] vedrowithwater = false walk ( fromwhere ) end
		end;
}

room {
	nam = 'leftroom';
	title = 'Левый поворот';
	way = { path{'К перекрестку','threeways'} };
}
room {
	nam = 'centerroom';
	title = 'Центр';
	way = { path{'К перекрестку','threeways'} };
}
room {
	nam = 'rightroom';
	title = 'Правый поворот';
	onenter = function (s, f)
		if f^'threeways' then 
		p 'Конь: ^ -- Ты все-таки решил пойти направо?! Но ведь я тогда погибну! Давай вместе будем сражаться со злом этих мест, я не подведу тебя! Еще не поздно остановиться! Ты можешь выбрать другой путь.'; end
		end;
	pic = 'gfx/16.png';
	way = { path{'Дальше','rightroom1'}, path{'К перекрестку','threeways'} };
	enter = function()
		snd.play('snd/gallop.ogg',1);
		end;
}

room {
	nam = 'rightroom1';
	title = 'Правый поворот';
	onenter = function (s, f)
		if f^'rightroom' then 
		p 'Конь: ^ -- Там кто-то есть! Мне страшно... Прошу тебя, путник, поверни назад!'; end
		end;
	pic = 'gfx/16_0.png';
	way = { path{'Дальше','rightroom2'}, path{'Назад','rightroom'} };
	enter = function()
		snd.play('snd/gallop.ogg',1);
		end;
}

room {
	nam = 'rightroom2';
	title = 'Правый поворот';
	onenter = function (s, f)
			if f^'rightroom1' then 
			p 'Конь: ^ -- Это, кажется, волк! Он раздерет меня на части! За что мне такая судьба... Если мы приблизимся ещё - убежать уже не получится. Прошу тебя. Пожалуйста, вернись!';
			snd.play('snd/horse.ogg', 2)
			end
		end;
	pic = 'gfx/16_1.png';
	way = { path{'Дальше','rightroom3'}, path{'Назад','rightroom1'} };
	enter = function()
		snd.play('snd/gallop.ogg',1);
		end;
}
room {
	nam = 'rightroom3';
	title = 'Правый поворот';
	onenter = function (s, f)
			if f^'rightroom2' then 
			p 'Конь: ^ -- Это точно волк! Ну всё, мне конец...';
			rightwaychoosen = true;
			rightchoose = rightchoose + 1;
--			inc(rightchoose);
			end
		end;
	pic = 'gfx/16_2.png';
	way = { path{'Дальше','rightroom4'} };
	enter = function()
		snd.play('snd/gallop.ogg',1);
		snd.music 'mus/Pentagram.ogg'
		end;
}
room {
	nam = 'rightroom4';
	title = 'Правый поворот';
	onenter = function (s, f)
			if f^'rightroom3' then 
			p 'Конь: ^ -- Он всё ближе...';
			end
		end;
	pic = 'gfx/16_3.png';
	way = { path{'Дальше','rightroom5'} };
	enter = function()
		snd.play('snd/gallop.ogg',1);
		end;
}

room {
	nam = 'rightroom5';
	title = 'Правый поворот';
	onenter = function (s, f)
			if f^'rightroom4' then 
			p 'Конь: ^ -- Как ты мог?..';
			end
		end;
	pic = 'gfx/16_4.png';
	way = { path{'Дальше','rightroom6'} };
	enter = function()
	snd.play('snd/gallop.ogg',1);
	end;
}
room {
	nam = 'rightroom6';
	title = 'Правый поворот';
	onenter = function (s, f)
			if f^'rightroom5' then 
			p 'Конь трясется от страха.';
			end
		end;
	pic = 'gfx/16_5.png';
	enter = function()
		if not horseleaved then snd.play('snd/gallop.ogg',1) end
		if horseleaved then enable '#nextstage' end
		end;
	decor = function()
		p[[{towolf|Волк} смотрит прямо на тебя!]];
		if afterwolf and not horseleaved then p 'Тебе остается только {leave|слезть} с коня.' end
		if afterwolf and horseleaved then p 'Конь еле стоит на ногах. Бедняжка...' end
		end;
	way = { path {'#nextstage','Дальше...','rightroom7'}:disable() }
}:with {'towolf', 'leave', 'nextstage'}

obj {
	nam = 'nextstage';
}

obj {
	nam = 'leave';
	act = function()
		p 'Ты спрыгнул с коня. Тот с укором посмотрел тебе вслед. Этот взгляд ты не забудешь никогда...';
		horseleaved = true;
		rightchoose = rightchoose + 1;
		walk 'rightroom6'
		end
}
obj {
	nam = 'towolf';
	used = function (n, z)
		if z^'topor' then
			p [[Ты замахнулся топором на волка, но тот оказался проворнее. Он сбил тебя с ног, и топор вылетел у тебя из руки в неизвестном направлении. Скорее всего, он где-то лежит посреди леса. К сожалению, ты не в той ситуации, чтобы искать его.]] remove('topor') topornavolka = true  return
			end
		return false;
		end;
	act = function()
		if not afterwolf then walk ('talkwithwolf') else p [[Вам больше нечего сказать друг другу.]] end
		end;
}
dlg {
	nam = 'talkwithwolf';
	pic = 'gfx/18.png';
	noinv = true;
	title = false; 
	enter = function()
		p [[Волк посмотрел на тебя сочувственно, и... заговорил:^ -- Ну что, путник. Слезай с коня.]] 
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
			{'Почему это?', '-- Ты надпись на камне читал? Читал. Какие могут быть еще вопросы? Конь - мой. А ты ступай себе с миром.',
				{'Может, как-то договоримся?', '-- Нет. С этим шутки плохи. С моим чувством голода - тоже. Так что отдавай коня. Назад у тебя все равно пути нет.',
						only = true;
						{'Души у тебя нет...', function() p'-- Нет. Не так. Души нет у тебя. Иначе зачем бы шел по этой дороге, если знал, что конь твой погибнет? Себя спасал? То-то же.' afterwolf = true end }, 
						{'Ну и ладно. Как пришло - так и ушло. Главное, что жив остался.', function() p'-- С таким подходом далеко пойдешь...' afterwolf = true end }			
				}
			}
	      } -- конец фразы
}

room {
	nam = 'rightroom7';
	title = 'Правый поворот';
	onenter = function (s, f)
			if f^'rightroom6' then 
			snd.music('mus/BeforeDawn.ogg')
			snd.play('snd/goodbyehorse.ogg',1);
			p 'Волк съел коня... Но это был твой выбор. Пора двигаться дальше.';
			end
		end;
	onexit = function()
		rightchoose = rightchoose + 1;
		end;
	pic = 'gfx/16.png';
	way = { path{'Дальше','kolodets'} };
}

room {
	nam = 'kolodets';
	title = 'Поле';
	pic = 'gfx/22.png';
	onenter = function (s, f)
			if f^'polewithkolobok' then 
			snd.music('mus/BeforeDawn.ogg');
			end
		end;
	obj = {'tokolodets'};
	decor = [[Деревья закончились. Вокруг - огромное поле... Ты видишь {tokolodets|колодец}.]];
	way = { path{'Дальше', 'polewithkolobok'} };
}

obj {
	nam = 'tokolodets';
	act = function()
		walk ('inkolodets')
		end;
}

obj {
	nam = 'drinkwater';
	act = function()
		if drinkedwaterinkolodets and not waterpoisoned  then p [[Ты же лопнешь, деточка!]] end
		if drinkedwaterinkolodets and waterpoisoned and not specialcase then p [[Ещё глоток этой дряни - и ты не жилец. Не стоит оно того.]] end
		if drinkedwaterinkolodets and waterpoisoned and specialcase then p [[Ты же лопнешь, деточка!]] end
		if not drinkedwaterinkolodets and not waterpoisoned then p [[Наконец-то! Ты жадно выпил пол ведра воды. Ну, может меньше. Но показалось, что пол ведра.]] clickmute = true snd.play('snd/drinkwater.ogg', 1) drinkedwaterinkolodets = true end
		if not drinkedwaterinkolodets and waterpoisoned and not specialcase then p [[Ты закрыл нос рукой. Попытался выпить эту жуткую воду. Тебя чуть не стошнило. Но жажда оказалась сильнее чувства отвращения. И всё же не стоит больше делать подобное. Лекарств у тебя нет...]] clickmute = true snd.play('snd/drinkwater.ogg', 1) drinkedwaterinkolodets = true end
		if not drinkedwaterinkolodets and waterpoisoned and specialcase then p [[Наконец-то! Ты жадно выпил пол ведра воды. Ну, может меньше. Но показалось, что пол ведра.]] clickmute = true snd.play('snd/drinkwater.ogg', 1) drinkedwaterinkolodets = true end
		end;
	used = function(n,z)
		if z^'topor' then p[[Ударим топором по глаголу?]] end
		if z^'kuvshin' then p[[Кувшин пуст. Ты должен помочь старику...]] end
		if z^'kuvshinwithwater' then p[[Ты набрал воды в кувшин, чтобы помочь старику...]] end
		end;
}

room { 
	nam = 'inkolodets';
	disp = 'Возле колодца';
	pic = 'gfx/23.png';
	decor = function()
		p [[Ты видишь {kolodetsitself|колодец}, видишь {vedrowithkolodec|ведро}, которое к нему привязано. ]];
		if vedrowithkolodecisfull then p [[Ты можешь {drinkwater|попить} воды из него.]] end
		end;
	obj = {'drinkwater', 'vedrowithkolodec', 'kolodetsitself'};
	way = { path{'Отойти от колодца', 'kolodets'} };
}

obj {
	nam = 'kolodetsitself';
	act = function()
		if not waterpoisoned then p [[Обычный колодец. Но в твоём случае он - спасение.]] end;
		if waterpoisoned then p [[Обычный колодец. Только отравленный...]] end;
		end;
  	used = function (n, z)
		if z^'kuvshin' then p[[Ты не можешь достать воду кувшином, она слишком низко, хотя и в зоне видимости. Нужно использовать ведро.]] end
		if z^'kuvshinwithwater' then p[[Ты вылил воду из кувшина в колодец.]] replace('kuvshinwithwater','kuvshin') end
		if z^'apples' then p [[Они тебе ещё пригодятся.]]
		elseif z^'poison_apple' then
		p [[Ты бросил подозрительное яблоко в колодец. Из глубины ты учуял тухлый, неприятный запах... Ты отравил колодец. Но как? С содорганием ты подумал, что бы случилось, если бы ты это яблоко съел...]] remove('poison_apple'); waterpoisoned = true; end
		end;
}

room {
	nam = 'polewithkolobok';
	disp = function() 
		if not eatedkolobok and not kolobokandkuvshin then p 'Колобок' else p 'Дорога' end
		end;
	pic = function()
		if not eatedkolobok and not kolobokandkuvshin then return 'gfx/25.png' else return 'gfx/24.png' end
		end;
	decor = function()
		if not eatedkolobok and not kolobokandkuvshin then p [[Тебе навстречу катится {tokolobok|колобок}! Самый настоящий!]] end
		end;
	obj = {'tokolobok', 'stageafter'};
	enter = function()
		if talkedwithkolobok then enable('#stageafter') end
		if not eatedkolobok and not kolobokandkuvshin then snd.music('mus/TubaWaddle.ogg') end;
		end;
	way = { path{'К колодцу', 'kolodets'}, path{'#stageafter', 'Дальше', 'afterkolobok'}:disable() };
}

obj {
nam = 'stageafter';
}

obj {
	nam = 'tokolobok';
	act = function()
		walk ('inkolobok')
		end;
	used = function()
		p [[Надо подойти поближе.]];
		end;
}

room {
	nam = 'inkolobok';
	disp = 'Возле колобка';
	pic = 'gfx/26.png';
	decor = [[{gotalk|Колобок} улыбается и приветливо смотрит на тебя!]];
	obj = {'gotalk'};
	way = { path{'Отойти от колобка', 'polewithkolobok'} };
}

dlg {
	nam = 'talkwithkolobok';
	disp = 'Разговор с колобком';
	noinv = true;
	pic = 'gfx/26.png';
	enter = function(s)
		deletebutton();
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		p (fmt.c ('-- Я Колобок, Колобок, я по коробу скребён, ^По сусеку метён, на сметане мешон ^Да в масле пряжон, на окошке стужон. ^Я от дедушки ушёл, я от бабушки ушёл, ^Я от зайца ушёл, я от волка ушёл, ^От медведя ушёл, от тебя, лисы, ^нехитро уйти!') )
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- Начало фразы
			{'Колобок?', '-- Лиса?',
				{'Нет, я человек!','-- Нет, ты лиса, я же вижу. И ты должна меня съесть.',
					{' *хм, странно* А если я этого не сделаю?', '-- Тогда я обречен вечно катиться по дорогам и петь песни разным животным, пока или меня не съест кто-нибудь, или пока я не испорчусь. Но так, как я сказочный, а мой образ - вечен - этого никогда не прозойдет... Ты представляешь себе такую жизнь? Без смысла, без цели... Нет, определенно - ешь меня.',
						only = true;
						{'Извини, но я не настолько голоден, чтобы подбирать и есть всякое с земли.', function() p '-- А зря...' talkedwithkolobok = true end },
						{'Ладно. Тогда прощай. А что мне надо делать? Взять тебя в руки и откусить? Тебе не будет больно?', '-- Смешная ты, лиса. Открой просто рот!',
							{'Хорошо.', function() p'-- Юхуу!^^ Колобок с разбегу запрыгнул к тебе в рот, он оказался вкусный, и никакого песка или пыли. Ты же в волшебном мире, забыл?) Кто бы ел несъедобное. Но тебе всё равно стало как-то грустно...' talkedwithkolobok = true eatedkolobok = true walk ('polewithkolobok') end },
						},
					}
				}
			}
	      } -- Конец фразы
}

obj {
	nam = 'gotalk';
	act = function()
		walkin('talkwithkolobok');
		end;
	used = function(n,z)
		if z^'topor' then p [[Ты без топора жить не можешь? Ну колобок-то что тебе сделал? Да и не попасть в него топором...]] end;
		if z^'kuvshin' then p [[И что ты сделаешь колобку пустым кувшином?]] end
		if z^'kuvshinwithwater' then p [[Ты залил колобка водой из кувшина... Он размяк и растворился.]] kolobokandkuvshin = true replace('kuvshinwithwater', 'kuvshin') walk('polewithkolobok') end
		end;
}

room {
	nam = 'afterkolobok';
	disp = 'Дорога';
	pic = 'gfx/27.png';
	way = { path{'Назад', 'polewithkolobok'}, path{'Дальше', 'starik'} };
}

room {
	nam = 'starik';
	disp = 'Старик на пути';
	pic = 'gfx/28.png';
	enter = function()
		snd.music('mus/Renaissance.ogg')
		if not firsttalkwithstarik then enable('#unlockvillage') end
		if izrubilappletrees then enable('#unlockvillage') end
		if have('one_apple') then enable('#unlockvillage') end
		end;
	decor = [[Перед тобой стоит {tostarik|старик}.]];
	obj = {'tostarik', 'unlockvillage'};
	way = { path{'Назад', 'afterkolobok'}, path{'#unlockvillage','Дальше','waytovillage'}:disable() };
}

obj {
	nam = 'unlockvillage';
}

obj {
	nam = 'tostarik';
	act = function()
		walk ('instarik')
		end;
	used = function()
		p [[Надо подойти поближе.]];
		return
		end;
}

room { 
	nam = 'instarik';
	disp = 'Возле старика';
	pic = 'gfx/29.png';
	obj = {'talkwithstarik'};
	decor = [[Ты видишь {talkwithstarik|старика}. ]];
	way = { path{'Отойти от старика', 'starik'} };
}

obj {
	nam = 'talkwithstarik';
	act = function()
		if firsttalkwithstarik and not haveskatert and not izrubilappletrees and not talkedwithoutskatert and not have('one_apple') then walkin ('starikkonversation') elseif not firsttalkwithstarik and not haveskatert and not izrubilappletrees and not talkedwithoutskatert and not have('one_apple') then walk ('starikkonversation2') elseif izrubilappletrees and not talkedwithoutskatert and not have('one_apple') then walk('starikkonversation3') elseif not talkedwithoutskatert and have('one_apple') then walk('starikkonversation3') end;
		if haveskatert then p [[Теперь он будет жить долго и счастливо!]] end;
		if talkedwithoutskatert then p [[Лучше старика не трогать...]] end;
		end;
	used = function(n, z)
		if z^'samobranka' then p [[-- Она твоя. Используй скатерть мудро.]]
		elseif z^'one_apple' then p [[-- Увы. Одного яблока мало... Молодым я стану, если съем три яблока подряд. Иначе бесполезно.]]
		elseif z^'kuvshin' then p [[Это пустой кувшин, который я дал тебе. Набери в него живой воды, пожалуйста!]] -- end;
		elseif z^'apples' and dalwater and not firsttalkwithstarik then p [[-- Спасибо тебе, добрый человек! Взамен я дарю тебе скатерть-самобранку! Пусть она выручает тебя в пути. Только помни - никому не рассказывай о ней! Если проболтаешься - беда будет.]] take ('samobranka') remove('apples') haveskatert = true 
		elseif z^'apples' and not dalwater and not firsttalkwithstarik then  p [[-- Спасибо тебе, добрый человек! Теперь я молод. Но глаза мои по-прежнему больны... Только живая вода может излечить их и вернуть мне возможность видеть этот мир!]] dalapples = true remove('apples') -- end
		elseif z^'apples' and firsttalkwithstarik then p [[Ты бы поговорил сначала с человеком...]]
		elseif z^'kuvshinwithwater' and dalapples then p [[-- Спасибо тебе, добрый человек! Взамен я дарю тебе скатерть-самобранку! Пусть она выручает тебя в пути. Только помни - никому не рассказывай о ней! Если проболтаешься - беда будет.]] take ('samobranka') remove('kuvshinwithwater') haveskatert = true elseif z^'kuvshinwithwater' and not dalapples then p [[Старик умыл глаза водой из кувшина. ^^-- Спасибо тебе, добрый человек! Теперь я могу хорошо видеть. Но я ведь по-прежнему стар! Найди молодильные яблоки.]] dalwater = true dalvodu = true remove('kuvshinwithwater') end
		if z^'topor' then p [[Откуда в тебе эта тяга всё крушить, ломать и убивать? Оставь старика в покое.]] end
		end;
};

dlg {
	nam = 'starikkonversation';
	disp = 'Разговор со стариком';
	noinv = true;
	pic = 'gfx/29.png';
	enter = function(s)
		p [[Приветствую тебя, странник!]];
		firsttalkwithstarik = false;
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- Начало фразы 
				only = true;
			{'Привет. Тебя, случаем, не Ричардом зовут?', '-- Нет, а что?',
									{ function() p 'Да так, просто...' firsttalkwithstarik = true; end , '-- ???'}
				},
			{'Привет.', '-- Куда путь держишь?',
				only = true;
				{'А ты, значит, не знаешь?! Сейчас все знают, кто я и куда иду...','-- *эх* Нет. Злая колдунья отняла у меня годы жизни... Я стар. И почти слеп. И иду в далекую землю, где, говорят, есть такая вода, которой если умоешься - вмиг прозреешь. И есть такие яблоки, которые растут на особенных деревьях - когда их съешь - враз молодым становишься. Дивно ли, чудно ли, но я ищу все это. Не для себя. Не только. Для старухи моей. Она побивается от горя, места себе не находит... Помоги мне - я тебе кое-что дам взамен. Это скатерть... ',
					{'Ээ... Я все понимаю. Но зачем мне какая-то скатерть?','-- Это не простая скатерть. Это скатерть-самобранка. Когда захочешь поесть - просто раскрой ее - и все яства появятся на ней.',
						{'И ты мне отдашь ее просто так, за какие-то яблоки и воду?','-- Вот кувшин. Набери в него живой воды и принеси мне. Найди молодильные яблоки. И скатерть твоя.',
							{'Хорошо, конечно, но... А как ты будешь без скатерти?','-- *старик усмехнулся* А зачем она мне, когда я смогу нормально ходить, нормально видеть, и обрету силу в руках?',
								{'Ладно, я поищу тебе эти вещи.', function()p '-- Спасибо, добрый человек.' take('kuvshin') kuvshintakedfromstarik = true; end }
							},
						},
					},
				}, -- конец первого разветвления
				{'О, а вы не знаете? Меня сейчас все встречные удивляют тем, что все про меня знают...','-- *эх* Нет. Злая колдунья отняла у меня годы жизни... Я стар. И почти слеп. И иду в далекую землю, где, говорят, есть такая вода, которой если умоешься - вмиг прозреешь. И есть такие яблоки, которые растут на особенных деревьях - когда их съешь - враз молодым становишься. Дивно ли, чудно ли, но я ищу все это. Не для себя. Не только. Для старухи моей. Она побивается от горя, места себе не находит... Помоги мне - я тебе кое-что дам взамен. Это скатерть...',
					{'Скатерть? Зачем она мне?','-- Это не простая скатерть. Это скатерть-самобранка. Когда захочешь поесть - просто раскрой ее - и все яства появятся на ней.',
						{'И вы хотите обменять ее на молодильные яблоки и живую воду?','-- Да, странник. Вот тебе кувшин. Набери в него живой воды и принеси мне. Найди молодильные яблоки. И скатерть твоя.',
							{'Хорошо, конечно, но... А как же вы сами-то будете без скатерти?','-- *старик усмехнулся* А зачем она мне, когда я смогу нормально ходить, нормально видеть, и обрету силу в руках?',
								{'Конечно, я поищу эти вещи для вас.', function() p 'Спасибо, добрый человек.' take('kuvshin') kuvshintakedfromstarik = true; end }
							},
						},
					},
				}, -- конец второго разветвления
			}
	    } -- Конец фразы
}

dlg {
	nam = 'starikkonversation2';
	disp = 'Разговор со стариком';
	noinv = true;
	pic = 'gfx/29.png';
	enter = function(s)
		p [[Приветствую тебя, странник!]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		{'Привет!', function() if not dalwater then p'Набрал ли ты живой воды в кувшин, что я дал тебе?' end if not dalapples then p'Нашел ли ты молодильные яблоки?' end end ,
			only = true;
			{'Да, принёс.', function() if not dalwater and dalapples then p'-- Хорошо, тогда где же она?' end if not dalapples and dalwater then p'-- Хорошо, тогда где же они?' end if not dalwater and not dalapples then p'-- Хорошо, тогда где же они?' end end },
			{'Нет, увы.','-- Очень жаль...'},
		}
	      } -- конец фразы
}

dlg {
	nam = 'starikkonversation3';
	disp = 'Разговор со стариком';
	noinv = true;
	pic = 'gfx/29.png';
	enter = function(s)
		p [[Приветствую тебя, странник!]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		{'Привет!', 'Помоги мне, добрый человек. Злая колдунья отняла у меня годы жизни... Я стар. И почти слеп. И иду в далекую землю, где, говорят, есть такая вода, которой если умоешься - вмиг прозреешь. И есть такие яблоки, которые растут на особенных деревьях - когда их съешь - враз молодым становишься. Дивно ли, чудно ли, но я ищу все это. Не для себя. Не только. Для старухи моей. Она побивается от горя, места себе не находит... Помоги мне - а я помогу тебе. Вижу, что голоден ты...',
			only = true;
			{'Я бы с радостью. Но нет у меня того, что вы просите. Простите.', function() p'Лицо старика искривилось от горечи, но он тут же взял себя в руки. ^^-- Так уж и быть. Возможно, я ещё встречу того, кто знает, где они.' talkedwithoutskatert = true end },
			{'Нет, старик, нет у меня того, что ты хочешь, а даже если бы и было - с чего бы мне делиться?', function() p'Лицо старика исказилось от гнева. ^^-- Не будет тебе покоя, злой человек. Ты пожалеешь, что встретил меня...' talkedwithoutskatert = true end },
		}
	      } -- конец фразы
}

room {
	nam = 'waytovillage';
	pic = 'gfx/30.png';
	disp = 'Вид с горы';
	decor = function()
		p [[Если идем дальше - назад пути не будет.]];
		if have('kuvshin') and not have('one_apple') then p [[А ведь надо помочь старику!]] end;
		if have('kuvshinwithwater') and not have('one_apple') then p [[А ведь надо помочь старику! Ты набрал живой воды...]] end;
		end;
	way = { path{'Назад','starik'}, path {'Дальше','longroad1'} };
}

obj {
	nam = 'kuvshin';
	disp = fmt.img('gfx/inv/kuvshin.png')..'Кувшин';
	inv = function()
		if not nobackway then p[[Кувшин. Сюда я могу набрать живой воды и помочь старику.]] end;
		if nobackway then p[[Кувшин, который дал мне старик...]] end;
		end;
	used = function (n, z)
		if z^'pivo' and postavpivoje then
		p [[Может, поставить сначала кувшин на столик?]];
		elseif z^'pivo' and not postavpivoje then
			p [[Ты бы с радостью перелил пиво прямо на весу, но чувствуешь, что так только расплескаешь его по всему трактиру...]];
			return
			end
		if not z^'pivo' then return false end;
		end  
}

obj {
	nam = 'kuvshin2';
	disp = fmt.img('gfx/inv/kuvshin2.png')..'Кувшин';
	inv = function()
		p[[Кувшин, который я нашел в дупле дерева.]];
		end;
	used = function (n, z)
		if z^'pivo' and postavpivoje then
		p [[Может, поставить сначала кувшин на столик?]];
		elseif z^'pivo' and not postavpivoje then
			p [[Ты бы с радостью перелил пиво прямо на весу, но чувствуешь, что так только расплескаешь его по всему трактиру...]];
			return
			end
		if not z^'pivo' then return false end;
		end  
}

obj {
	nam = 'kuvshinwithwater';
	disp = fmt.img('gfx/inv/kuvshinwithwater.png')..'Кувшин';
	inv = function()
	if not nobackway then p[[Кувшин с живой водой.]] end;
	if nobackway then p[[Живая вода. Надо было принести её старику...]] end;
	end;
}

obj {
	nam = 'vedrowithkolodec';
	act = function()
		if not vedrowithkolodecisfull and not waterpoisoned then p [[Ты медленно и аккуратно спустил ведро в колодец, потом точно так же аккуратно достал его. Вода в ведре сверкает под солнечными лучами и манит тебя.]] specialcase = true 
		elseif not vedrowithkolodecisfull and waterpoisoned then p [[Ты, морщась от запаха, спустил ведро в колодец. Спустя какое-то время достал ведро мутной зеленой воды, которая вызывает отвращение.]] 
		elseif vedrowithkolodecisfull and not drinkedwaterinkolodets and not waterpoisoned then p [[Вода в ведре сверкает под солнечными лучами и манит тебя.]] 
		elseif vedrowithkolodecisfull and not drinkedwaterinkolodets and waterpoisoned and not specialcase then p [[Вода в ведре кажется непригодной к употреблению человеком.]]
		elseif vedrowithkolodecisfull and not drinkedwaterinkolodets and waterpoisoned and specialcase then p [[Вода в ведре сверкает под солнечными лучами и манит тебя. Хорошо, что ты успел набрать чистой воды до своей выходки...]]
		elseif vedrowithkolodecisfull and drinkedwaterinkolodets and not waterpoisoned then p [[Вода в ведре сверкает под солнечными лучами.]] 
		elseif vedrowithkolodecisfull and drinkedwaterinkolodets and waterpoisoned and not specialcase then p [[Страшный ты человек. Выпить такое...]] 
		elseif vedrowithkolodecisfull and drinkedwaterinkolodets and waterpoisoned and specialcase then p [[Вода в ведре сверкает под солнечными лучами.]] end
		if not vedrowithkolodecisfull then snd.play('snd/vedroinkolodec.ogg', 1) end
		vedrowithkolodecisfull = true;
		end;
	used = function(n, z)
		if z^'kuvshinwithwater' then p [[Кувшин полон.]] end;
		if z^'topor' then p [[Топором по ведру? А ты интересный...]] end;
		if z^'kuvshin' and not vedrowithkolodecisfull then p [[Нельзя набрать воды из пустого ведра!]] end;
		if z^'kuvshin' and vedrowithkolodecisfull and not waterpoisoned then p [[Ты набрал живой воды в кувшин старика.]] replace('kuvshin', 'kuvshinwithwater') end;
		if z^'kuvshin' and vedrowithkolodecisfull and waterpoisoned and not specialcase then p [[Вода отравлена. В этой игре возможно всё, но отравить старика? Нет уж.]] end;
		if z^'kuvshin' and vedrowithkolodecisfull and waterpoisoned and specialcase then p [[Ты набрал живой воды в кувшин старика.]] replace('kuvshin', 'kuvshinwithwater') end;
		if z^'apples' then p [[Это сказочный мир. Не надо их мыть.]] end;
		end;
}

obj {
	nam = 'samobranka';
	disp = fmt.img('gfx/inv/skatert.png')..'Скатерть';
	inv = function()
		walk('insamobranka');
		end;
}

room {
	nam = 'insamobranka';
	title = 'Вкуснейшие яства из волшебной скатерти!';
	noinv = true;
	enter = function()
		bread1 = false;
		bread2 = false;
		cake3 = false;
		baton4 = false;
		banan5 = false;
		soup6 = false;
		bottle7 = false;
		arbuz8 = false;
		blackikra9 = false;
		formilk10 = false;
		fish11  = false;
		candles12 = false;
		redikra13  = false;
		meat14  = false;
		kolbasa15 = false;
		vinograd16 = false;
		grusha17 = false;
		apple18 = false;
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end;
		if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end;
		if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end;
		if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end;
		theme.gfx.bg (bg_name)
		deletebutton();
		end;
	pic = function()
		if not bread1 then pr 'gfx/inskatert/15.png;gfx/inskatert/1bread.png@120,95' end
		if not bread2 then pr 'gfx/inskatert/15.png;gfx/inskatert/2bread.png@160,125' end
		if not cake3 then pr 'gfx/inskatert/15.png;gfx/inskatert/3cake.png@205,127' end
		if not baton4 then pr 'gfx/inskatert/15.png;gfx/inskatert/4baton.png@170,95' end
		if not banan5 then pr 'gfx/inskatert/15.png;gfx/inskatert/5banan.png@232,107' end
		if not soup6 then pr 'gfx/inskatert/15.png;gfx/inskatert/6soup.png@275,110' end
		if not bottle7 then pr 'gfx/inskatert/15.png;gfx/inskatert/7bottle.png@312,93' end
		if not arbuz8 then pr 'gfx/inskatert/15.png;gfx/inskatert/8arbuz.png@222,156' end
		if not blackikra9 then pr 'gfx/inskatert/15.png;gfx/inskatert/9blackikra.png@130,160' end
		if not formilk10 then pr 'gfx/inskatert/15.png;gfx/inskatert/10formilk.png@162,153' end
		if not fish11 then pr 'gfx/inskatert/15.png;gfx/inskatert/11fish.png@104,203' end
		if not candles12 then pr 'gfx/inskatert/15.png;gfx/inskatert/12candles.png@312,163' end
		if not redikra13 then pr 'gfx/inskatert/15.png;gfx/inskatert/13redikra.png@314,183' end
		if not meat14 then pr 'gfx/inskatert/15.png;gfx/inskatert/14meat.png@204,192' end
		if not kolbasa15 then pr 'gfx/inskatert/15.png;gfx/inskatert/15-2kolbasa.png@178,228' end
		if not vinograd16 then pr 'gfx/inskatert/15.png;gfx/inskatert/16vinograd.png@296,228' end
		if not grusha17 then pr 'gfx/inskatert/15.png;gfx/inskatert/17grusha.png@323,233' end
		if not apple18 then pr 'gfx/inskatert/15.png;gfx/inskatert/18apple.png@345,245' end
		if bread1 and bread2 and cake3 and baton4 and banan5 and soup6 and bottle7 and arbuz8 and blackikra9 and formilk10 and fish11 and candles12 and redikra13 and meat14 and kolbasa15 and vinograd16 and grusha17 and apple18 then pr 'gfx/inskatert/15.png' end
		end;
	obj = {'eatbread1', 'eatcake3', 'eatbaton4', 'eatbanan5', 'eatsoup6', 'drinkbottle7', 'eatarbuz8', 'eatblackikra9', 'drinkmilk10', 'eatfish11', 'eatcandles12', 'eatredikra13', 'eatmeat14', 'eatkolbasa15', 'eatvinograd16', 'eatgrusha17', 'eatapple18'};
	decor = function()
		p 'Здесь рай для гурмана!'
		if not bread1 and not bread2 then p 'Ты видишь вкусный, свежайший {eatbread1|хлеб}, который как будто только из печи! Его аромат сводит тебя с ума.' end
		if not cake3 then p '{eatcake3|Пирожное} завораживает твой взгляд.' end
		if not baton4 then p 'Свежий, мягкий {eatbaton4|батон}, который тает во рту лежит на скатерти.' end
		if not banan5 then p 'Охапка {eatbanan5|бананов} тоже здесь.' end
		if not soup6 then p 'В тарелке остывает вкусный, куриный {eatsoup6|бульон}.' end
		if not bottle7 then p 'Что же в бутылке? Наверняка, {drinkbottle7|спиртное}.' end
		if not arbuz8 then p 'Ломтик {eatarbuz8|арбуза} ярко красный и сочный.' end
		if not blackikra9 then p 'И даже {eatblackikra9|черная икра}! Деликатес...' end
		if not formilk10 then p 'Свежее {drinkmilk10|молоко} тоже есть на скатерти.' end
		if not fish11 then p '{eatfish11|Рыба}! Морская. Каждый раз разная, но всегда вкусная.' end
		if not candles12 then p '{eatcandles12|Конфеты}! Подобных ты еще никогда не ел.' end
		if not redikra13 then p 'Здесь даже есть {eatredikra13|красная икра}!' end
		if not meat14 then p '{eatmeat14|Мясо}! Сочная и свежая грудинка.' end
		if not kolbasa15 then p '{eatkolbasa15|Колбаса}! И она из мяса! Так не бывает, конечно, но ты же в сказке, да?' end
		if not vinograd16 then p 'Тяжелая гроздь {eatvinograd16|винограда}, налитая соком ждет тебя.' end
		if not grusha17 then p 'Спелая, сочная {eatgrusha17|груша}. Как будто говорит тебе: скушай!' end
		if not apple18 then p 'Алое {eatapple18|яблоко} на вкус приятно сочетает сладость и кислинку.' end
		if bread1 and bread2 and cake3 and baton4 and banan5 and soup6 and bottle7 and arbuz8 and blackikra9 and formilk10 and fish11 and candles12 and redikra13 and meat14 and kolbasa15 and vinograd16 and grusha17 and apple18 then p 'Ты съел всё!' end
		p '^^';
		p ( fmt.c('{@ walkout|Свернуть скатерть-самобранку}') );
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name)
		if hungry >= hungrymax then prival1enabled = true prival2enabled = true prival3enabled = true prival4enabled = true prival5enabled = true prival6enabled = true end;
		if youeatenfish and youeatenmilk then p [[Сочетать рыбу с молоком? А ты бесстрашный...]] end;
		youeatenfish = false; youeatenmilk = false;
		createbutton();
		end;
}

obj {
	nam = 'eatbread1';
	act = function()
		bread1 = true; bread2 = true; hungry = hungry+1 p 'Ты приятно захрустел корочкой.'; 
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'eatcake3';
	act = function()
		cake3 = true; hungry = hungry+1 p 'Ты попробовал мягкое, нежное пирожное, откусил кусочек, затем еще один. Глядь - а уже и съел.  Куда только пирожное подевалось?';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'eatbaton4';
	act = function()
		baton4 = true; hungry = hungry+1 p 'Съешь еще этого мягкого хрустящего батона да выпей молока ;)';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'eatbanan5';
	act = function()
		banan5 = true; hungry = hungry+1 p 'Ты вмиг слопал связку бананов. Куда спешишь-то?)';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'eatsoup6';
	act = function()
		soup6 = true; hungry = hungry+1 p 'Ты смакуя, съел куриный бульон, на душе потеплело, и прибавилось сил :)';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'drinkbottle7';
	act = function()
		bottle7 = true; hungry = hungry+1 p 'Ты попробовал прекрасное домашнее вино и жизнь заиграла красками.';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'eatarbuz8';
	act = function()
		arbuz8 = true; hungry = hungry+1 p 'Ты съел арбуз!';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}
obj {
	nam = 'eatblackikra9';
	act = function()
		blackikra9 = true; hungry = hungry+1 p 'Ты не спеша, смакуя, съел банку черной икры. А не зажирно будет?';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'drinkmilk10';
	act = function()
		formilk10 = true; youeatenmilk = true; hungry = hungry+1 p 'Ты выпил свежее коровье молоко, приятное и полезное.';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatfish11';
	act = function()
		fish11 = true; youeatenfish = true; hungry = hungry+1 p 'Ты аккуратно, не спеша, скушал рыбку. А ведь надеялся, что сделаешь это еще у озера...';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatcandles12';
	act = function()
		candles12 = true; hungry = hungry+1 p 'Ты съел конфеты, одну за другой, мм...';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatredikra13';
	act = function()
		redikra13 = true; hungry = hungry+1 p 'Что может быть вкуснее красной икры? Ты съел всю...';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatmeat14';
	act = function()
		meat14 = true; hungry = hungry+1 p 'Мясо! Мм... Нет ничего лучше мяса. И это не обсуждается.';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatkolbasa15';
	act = function()
		kolbasa15 = true; hungry = hungry+1 p 'Копченая, с приправами, душистая такая! Ты не смог остановиться, пока не съел всю...';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatvinograd16';
	act = function()
		vinograd16 = true; hungry = hungry+1 p 'Сладкий виноград с райским вкусом. Конечно же, без косточек.';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatgrusha17';
	act = function()
		grusha17 = true; hungry = hungry+1 p 'Ты съел грушку.';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

obj {
	nam = 'eatapple18';
	act = function()
		apple18 = true; hungry = hungry+1 p 'Поистине, райское яблочко. Ты съел аж до косточек.';
		if hungry == 0 then bg_name = 'gfx/bg_eat.png' end; if hungry == 1 then bg_name = 'gfx/bg_eat20.png' end;
		if hungry == 2 then bg_name = 'gfx/bg_eat40.png' end; if hungry == 3 then bg_name = 'gfx/bg_eat60.png' end;
		if hungry == 4 then bg_name = 'gfx/bg_eat80.png' end; if hungry == 5 then bg_name = 'gfx/bg_eat100.png' end;
		if hungry > 5 then bg_name = 'gfx/bg_eat120.png' end; theme.gfx.bg (bg_name)
		end;
}

room {
	nam = 'village';
	title = 'Деревня';
	pic = function()
		if not nableguest and evening == 0 then return 'gfx/31.png;gfx/daynight2/daynight0.png@0,0' end;
		if not nableguest and evening == 1 then return 'gfx/31.png;gfx/daynight2/daynight1.png@0,0' end;
		if not nableguest and evening == 2 then return 'gfx/31.png;gfx/daynight2/daynight2.png@0,0' end;
		if not nableguest and evening == 3 then return 'gfx/31.png;gfx/daynight2/daynight3.png@0,0' end;
		if not nableguest and evening == 4 then return 'gfx/31.png;gfx/daynight2/daynight4.png@0,0' end;
		if not nableguest and evening == 5 then return 'gfx/31.png;gfx/daynight2/daynight5.png@0,0' end;
		if not nableguest and evening == 6 then return 'gfx/31.png;gfx/daynight2/daynight6.png@0,0' end;
		if not nableguest and evening == 7 then return 'gfx/31.png;gfx/daynight2/daynight7.png@0,0' end;
		if not nableguest and evening == 8 then return 'gfx/31.png;gfx/daynight2/daynight8.png@0,0' end;
		if not nableguest and evening == 9 then return 'gfx/31.png;gfx/daynight2/daynight9.png@0,0' end;
		if not nableguest and evening == 10 then return 'gfx/31.png;gfx/daynight2/daynight10.png@0,0' end;
		if not nableguest and evening == 11 then return 'gfx/31.png;gfx/daynight2/daynight11.png@0,0' end;
		if not nableguest and evening == 12 then return 'gfx/31.png;gfx/daynight2/daynight12.png@0,0' end;
		if not nableguest and evening == 13 then return 'gfx/31.png;gfx/daynight2/daynight13.png@0,0' end;
		if not nableguest and evening == 14 then return 'gfx/31.png;gfx/daynight2/daynight14.png@0,0' end;
		if not nableguest and evening == 15 then return 'gfx/31.png;gfx/daynight2/daynight15.png@0,0' end;
		if not nableguest and evening == 16 then return 'gfx/31.png;gfx/daynight2/daynight16.png@0,0' end;
		if not nableguest and evening == 17 then return 'gfx/31.png;gfx/daynight2/daynight17.png@0,0' end;
		if not nableguest and evening == 18 then return 'gfx/31.png;gfx/daynight2/daynight18.png@0,0' end;
		if not nableguest and evening == 19 then return 'gfx/31.png;gfx/daynight2/daynight19.png@0,0' end;
		if not nableguest and evening == 20 then return 'gfx/31.png;gfx/daynight2/daynight20.png@0,0' end;
		if not nableguest and evening == 21 then return 'gfx/31.png;gfx/daynight2/daynight21.png@0,0' end;
		if not nableguest and evening == 22 then return 'gfx/31.png;gfx/daynight2/daynight22.png@0,0' end;
		if not nableguest and evening == 23 then return 'gfx/31.png;gfx/daynight2/daynight23.png@0,0' end;
		if not nableguest and evening == 24 then return 'gfx/31.png;gfx/daynight2/daynight24.png@0,0' end;
		if not nableguest and evening == 25 then return 'gfx/31.png;gfx/daynight2/daynight25.png@0,0' end;
		if not nableguest and evening == 26 then return 'gfx/31.png;gfx/daynight2/daynight26.png@0,0' end;
		if not nableguest and evening == 27 then return 'gfx/31.png;gfx/daynight2/daynight27.png@0,0' end;
		if not nableguest and evening == 28 then return 'gfx/31.png;gfx/daynight2/daynight28.png@0,0' end;
		if not nableguest and evening == 29 then return 'gfx/31.png;gfx/daynight2/daynight29.png@0,0' end;
		if not nableguest and evening == 30 then return 'gfx/31.png;gfx/daynight2/daynight30.png@0,0' end;
		if not nableguest and evening > 30 then return 'gfx/31.png;gfx/daynight2/daynight30.png@0,0' end;
		if nableguest and evening == 0 then return 'gfx/31_2.png;gfx/daynight2/daynight0.png@0,0' end;
		if nableguest and evening == 1 then return 'gfx/31_2.png;gfx/daynight2/daynight1.png@0,0' end;
		if nableguest and evening == 2 then return 'gfx/31_2.png;gfx/daynight2/daynight2.png@0,0' end;
		if nableguest and evening == 3 then return 'gfx/31_2.png;gfx/daynight2/daynight3.png@0,0' end;
		if nableguest and evening == 4 then return 'gfx/31_2.png;gfx/daynight2/daynight4.png@0,0' end;
		if nableguest and evening == 5 then return 'gfx/31_2.png;gfx/daynight2/daynight5.png@0,0' end;
		if nableguest and evening == 6 then return 'gfx/31_2.png;gfx/daynight2/daynight6.png@0,0' end;
		if nableguest and evening == 7 then return 'gfx/31_2.png;gfx/daynight2/daynight7.png@0,0' end;
		if nableguest and evening == 8 then return 'gfx/31_2.png;gfx/daynight2/daynight8.png@0,0' end;
		if nableguest and evening == 9 then return 'gfx/31_2.png;gfx/daynight2/daynight9.png@0,0' end;
		if nableguest and evening == 10 then return 'gfx/31_2.png;gfx/daynight2/daynight10.png@0,0' end;
		if nableguest and evening == 11 then return 'gfx/31_2.png;gfx/daynight2/daynight11.png@0,0' end;
		if nableguest and evening == 12 then return 'gfx/31_2.png;gfx/daynight2/daynight12.png@0,0' end;
		if nableguest and evening == 13 then return 'gfx/31_2.png;gfx/daynight2/daynight13.png@0,0' end;
		if nableguest and evening == 14 then return 'gfx/31_2.png;gfx/daynight2/daynight14.png@0,0' end;
		if nableguest and evening == 15 then return 'gfx/31_2.png;gfx/daynight2/daynight15.png@0,0' end;
		if nableguest and evening == 16 then return 'gfx/31_2.png;gfx/daynight2/daynight16.png@0,0' end;
		if nableguest and evening == 17 then return 'gfx/31_2.png;gfx/daynight2/daynight17.png@0,0' end;
		if nableguest and evening == 18 then return 'gfx/31_2.png;gfx/daynight2/daynight18.png@0,0' end;
		if nableguest and evening == 19 then return 'gfx/31_2.png;gfx/daynight2/daynight19.png@0,0' end;
		if nableguest and evening == 20 then return 'gfx/31_2.png;gfx/daynight2/daynight20.png@0,0' end;
		if nableguest and evening == 21 then return 'gfx/31_2.png;gfx/daynight2/daynight21.png@0,0' end;
		if nableguest and evening == 22 then return 'gfx/31_2.png;gfx/daynight2/daynight22.png@0,0' end;
		if nableguest and evening == 23 then return 'gfx/31_2.png;gfx/daynight2/daynight23.png@0,0' end;
		if nableguest and evening == 24 then return 'gfx/31_2.png;gfx/daynight2/daynight24.png@0,0' end;
		if nableguest and evening == 25 then return 'gfx/31_2.png;gfx/daynight2/daynight25.png@0,0' end;
		if nableguest and evening == 26 then return 'gfx/31_2.png;gfx/daynight2/daynight26.png@0,0' end;
		if nableguest and evening == 27 then return 'gfx/31_2.png;gfx/daynight2/daynight27.png@0,0' end;
		if nableguest and evening == 28 then return 'gfx/31_2.png;gfx/daynight2/daynight28.png@0,0' end;
		if nableguest and evening == 29 then return 'gfx/31_2.png;gfx/daynight2/daynight29.png@0,0' end;
		if nableguest and evening == 30 then return 'gfx/31_2.png;gfx/daynight2/daynight30.png@0,0' end;
		if nableguest and evening > 30 then return 'gfx/31_2.png;gfx/daynight2/daynight30.png@0,0' end;
		end;
	onenter = function()
		if not have('samobranka') and not alreadytalkedwolfinvillage and not nableguest then walk('talkwithwolfinvillage') end
		end;
	enter = function()
		wasinvillage = true;
		if nableguest then enable('#enableguest') end
		snd.music('mus/AMomentsReflection.ogg');
		if vipusti then zabral = true end; -- плохое, неочевидное решение (но хз)
		if eveningenabled then evening = evening+1; end;
		end;
	decor = function()
		p [[Ты в деревне! Слева ты видишь какое-то сооружение, очень напоминающее домик {totravnik|травника}. Возможно, здесь есть что-то полезное.]];
		p [[Внимание привлекает большая {tomelnica|мельница}. Наверное, большая гордость местных жителей.]];
		p [[За мельницей - огромный, столетний {todub|дуб}.]];
		p [[В центре - {tosalun|трактир}, или подобного рода заведение... Думаю, здесь любит собираться народ после тяжелого труда.]];
		p [[Справа от трактира ты видишь {toguesthouse|дом}.]];
		if not nableguest and have('samobranka') then p [[{tokonuh|Конюх} смотрит на тебя подозрительно.]]
		elseif not nableguest and not have('samobranka') then p[[{tokonuh|Конюх} смотрит на тебя с любопытством.]] else p [[{tokonuh|Конюх} возится с конем.]] end;
		p [[Ты видишь еще строения позади.]]; 
		end;
	obj = {'todub', 'tokonuh', 'tosalun', 'totravnik', 'tomelnica', 'toguesthouse', 'enableguest'};
	way = { path{'К травнику','travnik'}, path{'В мельницу','melnica'}, path{'К дубу','indub'}, path{'В трактир','insalun'}, path{'#enableguest', 'В дом','guesthouse'}:disable() };
}

obj {
	nam = 'enableguest';
}

obj {
	nam = 'tokonuh';
	act = function()
		walkin('inkonuh');
		end;
}

obj {
	nam = 'todub';
	act = function()
		p [[Его почти не видно... Но можно пройти.]];
		end;
}

obj {
	nam = 'tomelnica';
	act = function()
		p [[Мельница. Гордость деревни. Хлеб нужен всем.]];
		end;
}

obj {
	nam = 'toguesthouse';
	act = function()
		if nableguest and not oboroten then p [[Дом конюха открыт для тебя. Ценой скатерти-самобранки...]] elseif nableguest and oboroten then p [[Дом конюха открыт для тебя. Как-то всё было слишком просто...]] else p [[Дом конюха. Закрыт.]] end;
		end;
}

obj {
	nam = 'totravnik';
	act = function()
		p [[Наверное, у него я могу приобрести полезные лекарства... Приобрести? Я без денег...]];
		end;
}

room {
	nam = 'inkonuh';
	disp = 'Возле конюха';
	enter = function()
		if eveningenabled then evening = evening+1; end;
		end;
	pic = function()
		if evening == 0 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and not nableguest then return 'gfx/32.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening == 0 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and nableguest then return 'gfx/32_2.png;gfx/daynight2/daynight30.png@0,0' end;
		end;
	obj = {'talkwithkonuh'};
	decor = [[Ты видишь {talkwithkonuh|конюха}. ]];
	way = { path{'Отойти от конюха', 'village'} };
}

obj {
	nam = 'talkwithkonuh';
	act = function()
		if not nableguest and not have('samobranka') then walkin('dlgkonuhwhenoboroten')
		elseif not nableguest and have('samobranka') then walkin('dlgkonuh') else p 'Конюх занят.' end
		end;
	used = function(n,z)
		if z^'samobranka' then walkin('dlgkonuh2') end
		end;
}

dlgkonuhpic = function()
		if evening == 0 then return 'gfx/32.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 then return 'gfx/32.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 then return 'gfx/32.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 then return 'gfx/32.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 then return 'gfx/32.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 then return 'gfx/32.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 then return 'gfx/32.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 then return 'gfx/32.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 then return 'gfx/32.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 then return 'gfx/32.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 then return 'gfx/32.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 then return 'gfx/32.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 then return 'gfx/32.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 then return 'gfx/32.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 then return 'gfx/32.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 then return 'gfx/32.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 then return 'gfx/32.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 then return 'gfx/32.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 then return 'gfx/32.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 then return 'gfx/32.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 then return 'gfx/32.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 then return 'gfx/32.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 then return 'gfx/32.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 then return 'gfx/32.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 then return 'gfx/32.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 then return 'gfx/32.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 then return 'gfx/32.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 then return 'gfx/32.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 then return 'gfx/32.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 then return 'gfx/32.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 then return 'gfx/32.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 then return 'gfx/32.png;gfx/daynight2/daynight30.png@0,0' end;
		end;
dlg {
	nam = 'dlgkonuh';
	disp = 'Разговор с конюхом';
	noinv = true;
	pic = dlgkonuhpic; -- начинаю потихоньку сокращать код. одна функция для обработки всех одинаковых мест
	enter = function(s)
		p [[-- Чего тебе?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
			{'Конь у тебя какой-то бледный...', '-- Ха-ха-ха! У тебя и такого-то нет!',
									{ function() p 'И правда...' end , '-- То-то же.'}
				},

		{'Привет! Я не местный и...', '-- Мне все равно.',
			
			{ only = true; 'Я прошел долгий путь! Я чуть не погиб!', '-- Если ты болен - иди к травнику. Он поможет.',
				{ 'Но... мне даже переночевать негде!','-- Твои проблемы.' },
			{ 'У меня кое-что есть для тебя!', '-- Хм. И что же ты можешь предложить?',
				{ 'Скатерть. Но не простую, а скатерть-самобранку. Развернешь ее - а там еда на любой вкус.','-- Покажи мне ее!' },
			}

			}
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgkonuhwhenoboroten';
	disp = 'Разговор с конюхом';
	noinv = true;
	pic = dlgkonuhpic;
	enter = function(s)
		p [[-- Приветствую тебя, друг! Ты, наверное, из далеких краёв пришел к нам?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
			{'Может да, а может нет. Конь у тебя какой-то бледный...', '-- Окстись, друг! У тебя и такого-то нет. Тебе нужен ночлег? Если желаешь - можешь остаться у меня. Вечером я собираюсь испечь свой любимый пивной пирог. Присоединишься ко мне?',
									{ function() p 'Нет. Не внушаешь ты доверия. Небось, обезглавишь, пока спать буду.'  end , '-- Обижаешь. Мы мирный и гостеприимный народ...'}
				},
		{'Да, я хотел бы найти ночлег... Чего это будет мне стоить?', '-- Ты что! Мы очень доброжелательные люди, к тому же путники из далеких стран нечасто захаживают сюда. Можешь оставаться у меня дома сколько потребуется. Вечером я собираюсь испечь свой любимый пивной пирог... Присоединишься ко мне?',
			only = true;
			{'Конечно. Спасибо огромное! Приятно встретить хорошего человека после такого долгого пути, который я прошел... Вы - мой спаситель.', '-- Отлично. Мой дом открыт для тебя. Приходи туда в любое время. Я приду ближе к ночи. Впусти меня, когда постучу в окно. Ты не будешь спать?',
				{ 'Нет, я сплю днем. Вечером буду ждать вас, и уже заинтригован насчет пирога!', function() p'-- Поверь, я не разочарую тебя, друг!' nableguest = true oboroten = true end; },
			},
			 {'Пожалуй, мне надо здесь осмотреться. Спасибо, конечно, за гостеприимство, я ценю это. Но я не привык оставаться на ночь у незнакомых людей... Даже столь приятных, как вы.', '-- Да брось! Что может произойти? Мы мирный народ. Я живу здесь многие годы, знаю деревню, как свои пять пальцев... Ты можешь много интересного узнать о этих местах!',
				{ 'Я вам верю. Очень заманчивое предложение. Я подумаю. Но пока - откажусь.','-- Как знаешь, друг. Я всегда рад гостям, если что - я здесь.' },
			},
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgkonuh2';
	disp = 'Разговор с конюхом';
	noinv = true;
	pic = dlgkonuhpic;
	enter = function(s)
		p [[-- Ух ты! Отдашь ее? Тогда сможешь погостить у меня.]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{'Нет. Это слишком ценная вещь.','-- Ну, как знаешь... Ты, конечно, будешь сыт, но ночевать на улице...',
			{ 'Как-нибудь справлюсь.','-- Удачи.'
			}
		},
		{'Да, бери. Она выручила в пути, но сейчас меня больше заботит сон... Всё отдал бы, чтобы лечь в мягкую постель.','-- В таком случае, по рукам?',
			{ 'По рукам.', function() p'-- Мой дом открыт для тебя, можешь оставаться на ночь, пока не покинешь деревню.' nableguest = true; remove('samobranka') end
			},
		}
	      } -- конец фразы
}

obj {
	nam = 'tosalun';
	act = function()
		p [[На вид - приличное заведение... Впрочем, другого-то нет.]];
		end;
}

room {
	nam = 'insalun';
	disp = 'В трактире';
	enter = function()
		snd.music('mus/Plantation.ogg');
		if have('pivo') or have('nopivo') and not nopivoontable then disable('#enableexit1') enable ('#enableattention1') end;
		if not have('pivo') and not have('nopivo') and not nopivoontable then enable('#enableexit1') disable('#enableattention1') end;
		if nopivoontable and not zabral then enable('#enableexit2') disable('#enableattention1') end;
		if nopivoontable and zabral then enable('#enableexit1') disable('#enableattention1') disable('#enableexit2') end;
		if vipusti then enable('#enableexit1') disable('#enableattention1') disable('#enableexit2') end;
		end;
	pic = function()
--		if not have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33.png'; end;
--		if have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33_1.png'; end;
--		if nopivoontable and not have('nopivo') and not zabral then return 'gfx/33_2.png'; end;
--		if zabral  and not have('nopivo') then return 'gfx/33.png'; end;
--		if have('nopivo') then return 'gfx/33_1.png'; end;

		if not eveningenabled and not have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33.png'; end;
		if not eveningenabled and have('pivo')  and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33_1.png'; end;
		if not eveningenabled and nopivoontable  and not have('nopivo') and not zabral then return 'gfx/33_2.png'; end;
		if not eveningenabled and zabral and not have('nopivo') then return 'gfx/33.png'; end;
		if not eveningenabled and have('nopivo') then return 'gfx/33_1.png'; end;
		if eveningenabled and (evening > 5) and not have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33.png;gfx/daynight2/daynight_evening.png@0,0'; end;
		if eveningenabled and (evening > 5) and have('pivo')  and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33_1.png;gfx/daynight2/daynight_evening.png@0,0'; end;
		if eveningenabled and (evening > 5) and nopivoontable  and not have('nopivo') and not zabral then return 'gfx/33_2.png;gfx/daynight2/daynight_evening.png@0,0'; end;
		if eveningenabled and (evening > 5) and zabral and not have('nopivo') then return 'gfx/33.png;gfx/daynight2/daynight_evening.png@0,0'; end;
		if eveningenabled and (evening > 5) and have('nopivo') then return 'gfx/33_1.png;gfx/daynight2/daynight_evening.png@0,0'; end;
		
		if eveningenabled and not (evening > 5) and not have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33.png'; end;
		if eveningenabled and not (evening > 5) and have('pivo')  and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/33_1.png'; end;
		if eveningenabled and not (evening > 5) and nopivoontable  and not have('nopivo') and not zabral then return 'gfx/33_2.png'; end;
		if eveningenabled and not (evening > 5) and zabral and not have('nopivo') then return 'gfx/33.png'; end;
		if eveningenabled and not (evening > 5) and have('nopivo') then return 'gfx/33_1.png'; end;

		end;
	obj = {'tobarmen', 'tositdown', 'tokartina'};
	decor = function()
	p [[Ты видишь {tobarmen|человека}. Ты можешь присесть за ближайший свободный {tositdown|столик}. Ты можешь рассмотреть {tokartina|картину}, что висит на стене.]];
	end;
	way = { path{'#enableexit1', 'Выйти', 'village'}:disable() , path{'#enableexit2', 'Выйти', 'talkaboutkruzhka2'}:disable() , path{'#enableattention1', 'Выйти', 'talkaboutkruzhka'}:disable() };
}:with {
	obj {
		nam = 'enableexit1';
	    };
	obj {
		nam = 'enableexit2';
	    };
	obj {
		nam = 'enableattention1';
	    };
	};

dlg {
	nam = 'talkaboutkruzhka';
	disp = 'Стоять!';
	noinv = true;
	pic = function()
		if not have('pivo') and not have('nopivo') then return 'gfx/33.png' else return 'gfx/33_1.png' end;
		if have('nopivo') then return 'gfx/33_1.png'; end;
		end;
	enter = function(s)
		triedtoescape = true;
		tyvor = true;
		p [[-- Далеко собрался? Кружку отдай!]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		{'Ээ... Я... Это...','-- Вор ты, вот ты кто! ',
			{ 'Простите!','-- Верни кружку и можешь проваливать. Пиво твоё, кружка принадлежит заведению.'
			}
		},
	      } -- конец фразы
}

dlg {
	nam = 'talkaboutkruzhka2';
	disp = 'В трактире';
	noinv = true;
	pic = function()
		if not have('pivo') and not nopivoontable then return 'gfx/33.png'; end;
		if have('pivo') and not nopivoontable then return 'gfx/33_1.png'; end;
		if nopivoontable then return 'gfx/33_2.png'; end;
		end;
	enter = function(s)
		if combo then walkin('village') end;
		triedtoescape = true;
		wasintalkaboutkruzhka2 = true;
		p [[-- А отдать кружку?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		{'Я оставил её на столике.','-- А, хорошо, я потом заберу.',
			{ 'До свидания!', function() p'-- Пока.' zabral = true; walk('village') end;
			}
		},
	      } -- конец фразы
}

room {
	nam = 'indub';
	disp = 'Возле столетнего дуба';
	enter = function()
		treecounter = treecounter+1;
		if eveningenabled then evening = evening+1; end;
		snd.music('mus/InTheField.ogg');
		snd.play('snd/birds.ogg', 2, 0);
		end;
	exit = function()
		snd.stop(2);
		end;
	pic = function()
		if evening == 0 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and not birdontree then return 'gfx/39.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening == 0 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and birdontree then return 'gfx/39_2.png;gfx/daynight2/daynight30.png@0,0' end;
		end;
	obj = {'dub2', 'duplo2', 'tojarptica'};
	decor = function()
		p [[Ты видишь {dub2|дуб}. В центре дуба {duplo2|дупло}...]];
		p [[По всему видно - птицам нравится это дерево... Их заливистое пение можно слушать бесконечно.]];
		if not seaseen then p [[За старым деревом ты видишь огромное пустое поле, которое простирается до горизонта.]] end;
		if seaseen then p [[За старым деревом ты видишь огромное пустое поле, за которым - море.]] end;
		p [[Ты можешь пойти туда.]];
		if have('kuvshin') and not have('kuvshin2') and treecounter >=3 and 3 == rnd(3) and seaseen and needpero and not pticauletela and not havepero then p [[^Ты видишь {tojarptica|жар-птицу} на дереве!]] birdontree = true 
		elseif not have('kuvshin') and have('kuvshin2') and treecounter >=3 and 3 == rnd(3) and seaseen and needpero and not pticauletela and not havepero then p [[^Ты видишь {tojarptica|жар-птицу} на дереве!]] birdontree = true else birdontree = false; end;
		end;
	way = { path{'Выйти', 'village'}, path{'За горизонт', after = 'К морю', 'roomlodka'} };
}

obj {
	nam = 'dub2';
	act = function()
		p [[Обычный дуб. Очень старый.]];
		end;
}

obj {
	nam = 'tojarptica';
		act = function()
		walkin('injarptica');
		end;
}

room {
	nam = 'injarptica';
	disp = 'Возле жар-птицы';
	pic = 'gfx/43.png';
	way = { path{'Назад', 'indub'} };
	obj = {'uhvatiljarptica', 'talktojarptica'};
	decor = function()
		p[[Ты незаметно подкрался к птице. Теперь можешь разглядеть её поближе. Редкая удача! Ты можешь либо попробовать {uhvatiljarptica|ухватить} птицу за хвост, либо {talktojarptica|заговорить} с ней.]];
		end;
}

obj {
	nam = 'uhvatiljarptica';
	act = function()
		pticauletela = true;
		walk('indub');
		p[[Ты попытался ухватить жар-птицу за хвост, но её воля к свободе оказалась сильнее твоих меркантильных стремлений. Она улетела. Тем не менее, в твоей руке осталось одно сияющее перо...]];
		take('pero');
		end;
}

obj {
	nam = 'pero';
	disp = fmt.img('gfx/inv/pero.png')..'Перо';
	inv = [[Перо жар-птицы.]];
}

obj {
	nam = 'talktojarptica';
	act = function()
		walkin('dlgjarptica');
		end;
}

obj {
	nam = 'duplo2';
	act = function()
		if haveskatert then kuvshintakedfromstarik = false; end;
		if takkuvshin2 and not kuvshintakedfromstarik  then p [[Дупло старого, могучего дерева. Пустое.]] end;
		if not takkuvshin2 and not kuvshintakedfromstarik then p [[В дупле ты нашел пустой, но целый кувшин!]] take('kuvshin2') takkuvshin2 = true; end;
		if kuvshintakedfromstarik and not dalvodu then p [[Увы... На этот раз пусто.]] end;
		if kuvshintakedfromstarik and dalvodu and takkuvshin2 and eatenapples and  nashel2 then p [[Дупло старого, могучего дерева. Пустое.3]] end;
		if kuvshintakedfromstarik and dalvodu and not takkuvshin2 and not nashel2 then p [[В дупле ты нашел пустой, но целый кувшин! 2]] take('kuvshin2') takkuvshin2 = true; nashel2 = true; end;
--		if kuvshintakedfromstarik and dalvodu and takkuvshin2 and not eatenapples then p [[Дупло старого, могучего дерева. Пустое.2]] end;
		end;
}

obj {
	nam = 'tobarmen';
	act = function()
		walkin('inbarmen');
		end;
	used = function (n, z)
		if z^'pivo' or z^'pero' or z^'nopivo' or z^'kuvshinzpivom' then
			p [[Надо подойти поближе.]];
			return
			end
		if not z^'pivo' or z^'pero' or z^'nopivo' or z^'kuvshinzpivom' then return false; end
		end;
}

obj {
	nam = 'pivo';
	disp = fmt.img('gfx/inv/pivo.png')..'Пиво';
	inv = [[Пиво в кружке.]];
}

obj {
	nam = 'nopivo';
	disp = fmt.img('gfx/inv/pivo_no.png')..'Кружка';
	inv = [[Пустая кружка.]];
}

obj {
	nam = 'kuvshinzpivom';
	disp = fmt.img('gfx/inv/kuvshinwithwater.png')..'Пиво';
	inv = [[Кувшин с пивом. Да, это странно, но у тебя нет другого выхода.]];
}

room {
	nam = 'inbarmen';
	disp = 'Возле хозяина заведения';
	pic = function()
		if not have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/34.png'; end;
		if have('pivo') and not have('nopivo') and not nopivoontable and not zabral then return 'gfx/34_1.png'; end;
		if nopivoontable and not have('nopivo') and not zabral then return 'gfx/34_1.png'; end;
		if zabral and not have('nopivo') then return 'gfx/34.png'; end;
		if have('nopivo') then return 'gfx/34_1.png'; end;
		end;
	decor = [[Ты видишь {talkwithbarmen|человека}, который стоит за столиком. Он пристально смотрит на тебя. Почему-то ты уверен, что это не просто бармен, а хозяин этого места. ]];
	obj = {'talkwithbarmen'};
	way = { path{'Отойти', 'insalun'} };
}

obj {
	nam = 'tositdown';
	act = function()
		walkin('insitdown');
		end;
	used = function (n, z)
		if z^'pivo' or z^'nopivo' then
			p [[Надо подойти поближе.]];
			return
			end
		if not z^'pivo' then return false; end
		end;
}

obj {
	nam = 'talkwithbarmen';
	act = function()
		if vipusti and zabral then combo = true; end; -- когда не вызываем диалог, что оставил кружку уже на столе	
		if not pivotaked and not needpivo then walkin('dlgbarmennopivo') end;
		if not pivotaked and not combo and needpivo then walkin('dlgbarmen') end;
		if pivotaked and not krotdal and triedtoescape and not combo and not wasintalkaboutkruzhka2 and not tyvor then walkin('dlgbarmen3') end;
		if pivotaked and not krotdal and not triedtoescape and not combo and not wasintalkaboutkruzhka2 and not tyvor then walkin('dlgbarmen2') end;
		if pivotaked and krotdal and triedtoescape and not combo and not wasintalkaboutkruzhka2 and not tyvor then walkin('dlgbarmen3') end;
		if pivotaked and krotdal and not triedtoescape and not combo and not wasintalkaboutkruzhka2 and not tyvor then walkin('dlgbarmen4') end;	
		if combo and triedtoescape and not wasintalkaboutkruzhka2 and not tyvor then walkin('dlgbarmen3') end;
		if combo and not triedtoescape and not tyvor then walkin('dlgbarmen4') end;
		if wasintalkaboutkruzhka2 and not tyvor then walkin('dlgbarmen4') end;
		if tyvor then walkin('dlgbarmen3') end;
		end;
	used = function (n, z)
		if z^'kuvshin' or z^'kuvshin2' then p [[Вряд ли ему нужен пустой кувшин.]] return end;
		if z^'kuvshinzpivom' then p [[-- Я не пью пиво из кувшинов...]]; return end;
		if z^'nopivo' then p [[-- Наконец-то! Теперь ступай себе с миром.]]; remove('nopivo') krotdal = true; return end;
		if z^'pivo' then p [[-- Спасибо, конечно, но я не позволяю себе выпивать, пока работаю. Вот в конце дня - это да...]];
		elseif z^'pero' then
			if not pivotaked then p [[-- Спасибо. Держи своё пиво. Кружку принесешь обратно!]] take('pivo') pivotaked = true remove('pero')  end return
			end
		if not z^'pivo' or z^'nopivo' then return false; end
		end;
}

dlg {
	nam = 'dlgjarptica';
	disp = 'Разговор с жар-птицей';
	noinv = true;
	pic = 'gfx/43.png';
	enter = function(s)
		p [[-- Я видела, как ты крадешься! Чего тебе?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{'Здравствуй, жар-птица! Прости, что потревожил тебя. Но чтобы выжить и продолжить путь, мне нужно одно твоё перо. Поделись, пожалуйста?','-- Эх. Ладно. Так уж и быть. Все вы так говорите...',
			{ 'Все? Кто ещё?', function() p'-- Неважно. Держи перо и удачи тебе.' havepero = true take('pero'); walk('indub') end
			}
		},
		{'Мне перо надо. Чтобы пройти дальше.','-- А где волшебное слово? А где хорошие манеры? Эх... Ладно. Что поделать с тобой. Держи своё перо.',
			{ 'Спасибо!', function() p'-- Не за что.' havepero = true take('pero'); walk('indub') end
			},
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgbarmen';
	disp = 'Разговор с хозяином трактира';
	noinv = true;
	pic = 'gfx/34_2.png';
	enter = function(s)
		p [[-- Приветствую. Что будем пить? Или, может быть, вы голодны?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{ cond = function() return askwhere == false end, 'Пива бы.','-- С вас 13 золотых.',
			{ 'У меня нет с собой денег. Тем более, золотых монет...', function() p'-- Понимаю. В таком случае, принеси перо жар-птицы и пиво твоё.' needpero = true askwhere = true end
			}
		},

		{ cond = function() return askwhere == true and not have('pero') end, 'А где его искать-то, перо жар-птицы?','-- Она часто появляется возле дуба, что за мельницей. К сожалению, у меня нет времени подсиживать её. Может, тебе удастся поймать момент...',
			{'А зачем оно вам?', function() p'-- Знаю одного доброго молодца, который ищет его. Обменяю перо на кое-что ценное.' end
			}
		},

		{'А что у вас есть?','-- Лосось. Свежайший. Сам словил. 26 золотых.',
			{ 'Вы рыбак?', function() p'-- Да. И моряк.'  end
			},
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgbarmennopivo';
	disp = 'Разговор с хозяином трактира';
	noinv = true;
	pic = 'gfx/34_2.png';
	enter = function(s)
		p [[-- Приветствую. Чего желаете?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name)
		createbutton(); 
		end;
	phr = { -- начало фразы
		only = true;
--		{'Пива бы.','-- С вас 13 золотых.',
--			{ 'У меня нет с собой денег. Тем более, золотых монет...', function() p'-- Понимаю. В таком случае, принеси перо жар-птицы и пиво твоё.' needpero = true end
--			}
--		},
		{'А что у вас есть?','-- Лосось. Свежайший. Сам словил. 26 золотых.',
			{ 'У меня нет денег... Я вообще попал сюда случайно.', function() p'-- А я не занимаюсь благотворительностью.'  end
			},
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgbarmen2'; -- диалог после того, как взял пиво
	disp = 'Разговор с хозяином трактира';
	noinv = true;
	pic = 'gfx/34_2.png';
	enter = function(s)
		p [[-- Приветствую. Чего желаете?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name)
		createbutton(); 
		end;
	phr = { -- начало фразы
		only = true;
		{ function() if not nopivoontable then p'Можно забрать кружку с собой?' else p 'Я оставил кружку на столике.' vipusti = true; end end , function() if not nopivoontable then p'-- Нет. У меня их и так мало осталось.' else p 'А, хорошо, я потом заберу.' end end ,
			{ function() if not nopivoontable then p'Но я хочу занести пиво для мельника. И отдам кружку назад!' else p 'До свидания!' end end , function() if not nopivoontable then p'-- Нет.' else p'Пока.' end end
			}
		},
		{'А что у вас есть?','-- Лосось. Свежайший. Сам словил. 26 золотых.',
			{ 'Вы рыбак?', function() p'-- Да. И моряк.'  end
			},
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgbarmen3'; -- диалог после того, как отдал кружку (и пытался выйти с кружкой)
	disp = 'Разговор с хозяином трактира';
	noinv = true;
	pic = 'gfx/34_2.png';
	enter = function(s)
		p [[-- Приветствую. Чего желаете?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{'Вы всегда так строги с посетителями?','-- Нет. Только если они пытаются что-то украсть.',
			{ 'Понимаю. Извините...', function() p'-- Будь осмотрительнее в этих краях...'  end
			}
		},
		{'А что у вас есть?','-- Лосось. Свежайший. Сам словил. 26 золотых.',
			{ 'Вы рыбак?', function() p'-- Да. И моряк.'  end
			},
		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgbarmen4'; -- диалог после того, как отдал кружку (и НЕ пытался выйти с кружкой)
	disp = 'Разговор с хозяином трактира';
	noinv = true;
	pic = 'gfx/34_2.png';
	enter = function(s)
		p [[-- Приветствую. Чего желаете?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{'Я ищу способ путешествовать дальше... Может, вы поможете мне?','-- Не уверен. Я веду оседлый образ жизни и мало путешествую.',
			{ 'Эх. Ладно.', function() p'-- Советую быть осторожным в этих краях. *шепчет* Здесь упыри водятся! '  end
			}
		},
		{'А что у вас есть?','-- Лосось. Свежайший. Сам словил. 26 золотых.',
			{ 'Вы рыбак?', function() p'-- Да. И моряк.'  end
			},
		}
	      } -- конец фразы
}

room {
	nam = 'insitdown';
	disp = 'За столиком';
	pic = function()
		if not kuvshinontable and nopivoontable and not zabral then return 'gfx/35_3.png' end;
		if not kuvshinontable and not nopivoontable and not zabral then return 'gfx/35.png' end;
		if zabral then return 'gfx/35.png' end;
		if kuvshinontable and notfull then return 'gfx/35_1.png' elseif kuvshinontable and not notfull then return 'gfx/35_2.png' end;
		end;
	decor = function()
		p [[{stolik|Столик} прекрасно вписывается в интерьер своим необычным дизайном. Ты присел за него. Можешь, наконец, расслабить ноги после столь долгого пути. Что может быть приятнее, чем просто сидеть в уютном месте и наслаждаться атмосферой?]];
		if kuvshinontable and notfull then p [[^^На столике стоит пустой {kuvshonstol|кувшин}.]] end; if kuvshinontable and not notfull then p [[^^На столике стоит {kuvshonstolwithpivo|кувшин}, наполненный пивом.]] end; 
		if nopivoontable and not zabral then p [[^На столике стоит пустая кружка.]]; end; 
		end;
	onenter = function()
		postavpivoje = true;
		end;
	onexit = function()
		postavpivoje = false;
		end;
	obj = {'stolik', 'kuvshonstol', 'kuvshonstolwithpivo'};
	way = { path{'Отойти', 'insalun'} };
}

obj {
	nam = 'kuvshonstol';
	act = function()
		p [[Отлично. Теперь можно освободить кружку и выйти отсюда.]];
		end;
	used = function (n, z)
		if z^'pivo'  then
			p [[Ты аккуратно перелил пиво из кружки в кувшин. Готово!]]; notfull = false; replace('pivo', 'nopivo');
			return
			end
		if not z^'pivo' then return false; end
		end;
}

obj {
	nam = 'kuvshonstolwithpivo';
	act = function()
		p [[Ты взял кувшин с пивом.]];
		take('kuvshinzpivom');
		kuvshinontable = false;
		perelilpivo = true;
		youcanplace = true;
		zabralkuvshinpivo = true;
		end;
}

obj {
	nam = 'stolik';
	act = function()
		p [[Забавный, круглый, сказочный столик. Сделан с любовью.]]; 
		end;
	used = function (n, z)
			if z^'pero' then p [[Хочешь вытереть пыль? Её нет - стол затёрт до блеска.]] return end;
			if z^'nopivo' and not youcanplace then p [[Забери сначала пиво, что ли? Мне влом было делать ещё одно состояние сцены.]] return end;
			if z^'nopivo' and youcanplace then
			p [[Ты оставил пустую кружку на столе.]]; nopivoontable = true;
			remove('nopivo'); return end;
			if z^'pivo' then
			p [[Не время расслабляться, товарищ.]]; return -- куда спешишь товарищ, не время для потехи
			elseif z^'kuvshinzpivom' then
			p [[Не время расслабляться!]]; return end;
			if z^'kuvshin' and have('pivo') and not have('nopivo') then
			p [[Ты поставил кувшин на столик. Теперь можно легко перелить в него пиво.]]; kuvshinontable = true; 
			if have('kuvshin') then remove('kuvshin') end; if have('kuvshin2') then remove('kuvshin2') end;
			return end;
			if z^'kuvshin'and not have('pivo') and not have('nopivo') then
			p [[Пустой кувшин даже на столе останется пустым кувшином...]]; return
			end
			if z^'kuvshin2' and have('pivo') and not have('nopivo') then
			p [[Ты поставил кувшин на столик. Теперь можно легко перелить в него пиво.]]; kuvshinontable = true; 
			if have('kuvshin') then remove('kuvshin') end; if have('kuvshin2') then remove('kuvshin2') end;
			return end;
			if z^'kuvshin2'and not have('pivo') and not have('nopivo') then
			p [[Пустой кувшин даже на столе останется пустым кувшином...]]; return
			end
		if not z^'kuvshin' or not z^'kuvshin2' then return false; end
		end;
}

obj {
	nam = 'tokartina';
	act = function()
		walkin('inkartina');
		end;
}

room {
	nam = 'inkartina';
	disp = 'Возле картины';
	pic = 'gfx/36.png';
	way = { path{'Отойти', 'insalun'} };
}

room {
	nam = 'travnik';
	disp = 'У травника';
--	pic = function()
--		if havetaburet then return 'gfx/37_1.png' else return 'gfx/37.png' end;
--		end;
	pic = function()
	if eveningenabled and havetaburet and not (evening > 5) then return 'gfx/37_1.png' end;
	if eveningenabled and not havetaburet and not (evening > 5) then return 'gfx/37.png' end;
	if eveningenabled and havetaburet and (evening > 5) then return 'gfx/37_1.png;gfx/daynight2/daynight_evening.png@0,0' end;
	if eveningenabled and not havetaburet and (evening > 5) then return 'gfx/37.png;gfx/daynight2/daynight_evening.png@0,0' end;
	if not eveningenabled and havetaburet then return 'gfx/37_1.png' end;
	if not eveningenabled and not havetaburet then return 'gfx/37.png' end;
	end;
	enter = function()
		snd.music('mus/DarkRedWine.ogg');
		if not havetaburet then enable('#enableexit') disable('#enableattention') end;
		if havetaburet then disable('#enableexit') enable ('#enableattention') end;
		end;
	obj = {'neartravnik', 'taburet'};
	decor = function()
		p [[Перед тобой за полками стоит {neartravnik|травник}.]];
		if not havetaburet then p [[Твоё внимание привлёк старый {taburet|табурет}.]] end;
		end;
	way = { path{'#enableexit', 'Выйти', 'village'}:disable() , path{'#enableattention', 'Выйти', 'talkabouttaburet'}:disable() };
}:with {
	obj {
		nam = 'enableexit';
	    };
	obj {
		nam = 'enableattention';
	    };
	};

obj {
	nam = 'notaburet';
}

dlg {
	nam = 'talkabouttaburet';
	disp = 'Стоять!';
	noinv = true;
	pic = 'gfx/37_2.png';
	enter = function(s)
		p [[-- Далеко собрался? Верни табурет на место!]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		{'Ээ... Я... Это...','-- Вор ты, вот ты кто! ',
			{ 'Простите!','-- Верни где взял.'
			}
		},
	      } -- конец фразы
}

obj {
	nam = 'taburet';
	disp = fmt.img('gfx/inv/taburet.png')..'Табурет';
	act = function()
		p [[Ты взял табурет прямо перед носом у травника.]]
		havetaburet = true;
		braltaburet = true;
		take('taburet')
		place('notaburet', 'travnik')
		walk('travnik')
		end;
	inv = function()
		if not seen('taburet', 'travnik') and seen('notaburet', here()) then p[[Ты вернул табурет на место.]] havetaburet = false; place('taburet', 'travnik') remove('notaburet', 'travnik') walk('travnik') end;
		if not seen('neartravnik', here()) then p [[Старый, но всё ещё прочный табурет.]] end;
		end;
}

obj {
	nam = 'neartravnik';
	act = function()
		walkin('intravnik');
		end;
	used = function (n, z)
		if z^'taburet' then
			p [[Ты вернул табурет на место.]];
			havetaburet = false; place('taburet', 'travnik') remove('notaburet', 'travnik') walk('travnik')
			return
			end
		return false;
		end;
	
}

room {
	nam = 'intravnik';
	disp = 'Возле травника';
--	pic = 'gfx/37_2.png';
	pic = function()
	if eveningenabled and (evening > 5) then return 'gfx/37_2.png;gfx/daynight2/daynight_evening.png@0,0' else return 'gfx/37_2.png' end;
	end;
	way = { path{'Отойти от травника', 'travnik'} };

}

room {
	nam = 'melnica';
	disp = 'Внутри мельницы';
--	pic = 'gfx/41.png';
	pic = function()
	if eveningenabled and (evening > 5) then return 'gfx/41.png;gfx/daynight2/daynight_evening.png@0,0' else return 'gfx/41.png' end;
	end;
	enter = function()
		snd.music('mus/Rhastafarian.ogg');
		end;
	obj = {'nearmelnic'};
	decor = function()
		p [[Перед тобой вольготно сидит суровый {nearmelnic|мельник}. Рядом с ним - большой сосуд, в который постоянно сыплется мука. Рядом - лестница, ведущая к жерновам. Тебе туда не надо, да и не пустят.]];
		end;
	way = { path{'Выйти', 'village'} };

}
obj {
	nam = 'nearmelnic';
	act = function()
		walkin('inmelnic');
		end;
	used = function(n,z)
		if z^'kuvshinzpivom' then walkin('dlgmelnicwithpivo') end;
		if z^'muka' then p[[Отдать назад?]] end;
		end;
}

room {
	nam = 'inmelnic';
	disp = 'Возле мельника';
--	pic = 'gfx/41_2.png';
	pic = function()
	if eveningenabled and (evening > 5) then return 'gfx/41_2.png;gfx/daynight2/daynight_evening.png@0,0' else return 'gfx/41_2.png' end;
	end;
	decor = function()
		p [[Мельник напоминает тебе то ли представителя неформальной субкультуры в годах, то ли твоего преподавателя из универа... Странный и эксцентричный тип, похоже. Но всё же он может быть полезен. {talkwithmelnic|Поговорить} с ним?]];
		end;
	obj = {'talkwithmelnic'};
	way = { path{'Отойти от мельника', 'melnica'} };
}

obj {
	nam = 'muka';
	disp = fmt.img('gfx/inv/muka.png')..'Мука';
	inv = 'Мука. Отличная мука!';
}

obj {
	nam = 'taranka'; -- таранька
	disp = fmt.img('gfx/inv/taranka.png')..'Таранька';
	inv = 'Сушеная рыба застыла с недоуменным выражением "лица". Да. Кажется, ты начинаешь понимать защитников животных...';
}

obj {
	nam = 'talkwithmelnic';
	act = function()
		if not mukaest then walkin('dlgmelnic') else walkin('dlgmelnicaftermuka') end;
		end;
}

dlg {
	nam = 'dlgmelnic';
	disp = 'Разговор с мельником';
	noinv = true;
	pic = 'gfx/41_2.png';
	enter = function(s)
		p [[-- Ну привет, привет. Чего тебе, путник?]];
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{'Мне бы муки. Хотя бы немного.','-- Всё имеет свою цену. Мука вся расписана по жителям деревни, кому не досталась - тот сидит голодный.',
			{ 'И нельзя выделить хотя бы килограмм?', function() p[[-- Можно. Принеси мне пива из трактира и будет тебе килограмм муки.]]; needpivo = true; end;
			}
		},
--		{'Спасибо. Я больше никогда не голоден, благодаря одной вещице...','-- Интересно, что же это?',
--			{ 'Скатерть-самобранка.', function() p'-- А можете показать мне её?'  end
--			},
--		}
	      } -- конец фразы
}

dlg {
	nam = 'dlgmelnicwithpivo';
	disp = 'Разговор с мельником';
	noinv = true;
	pic = 'gfx/41_2.png';
	enter = function(s)
		p [[-- О, пиво! Спасибо! А почему оно в кувшине? Мог бы и кружку найти. Но ладно. Договор есть договор. Держи свою муку.]];
		take('muka'); remove('kuvshinzpivom'); mukaest = true;
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name)
		createbutton(); 
		end;
	phr = { -- начало фразы
		only = true;
		{'Спасибо большое.','-- Да не за что. Кстати. А не мог бы ты мне принести тараньки? Не с мукой же мне пиво пить, в самом деле...',
		only = true;
			{ 'Конечно, я поищу для тебя.','-- Вовек не забуду!'
			},
			{ 'Вряд ли. Я получил, что хотел.','-- Зря ты так. Ведь ещё не раз ко мне зайдешь потом.'
			},
		},
}
}

dlg {
	nam = 'dlgmelnicaftermuka';
	disp = 'Разговор с мельником';
	noinv = true;
	pic = 'gfx/41_2.png';
	enter = function(s)
		p [[-- А, это ты. Принес тараньку?]];
		take('muka'); remove('kuvshinzpivom');
		bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
		deletebutton();
		end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton();
		end;
	phr = { -- начало фразы
		only = true;
		{'Принес.','-- Тогда где же она?', 
		only = true;
			{ 'А что мне за это будет?','-- Ишь какой! А что, нельзя просто доброе дело сделать?'
			},
			{ 'Вот, держи.','-- Спасибо, странник. Дарю тебе взамен...'
			}, 
		},
		{'Не принес.','-- Жаль.'},
}
}

room {
	nam = 'roomlodka';
	disp = 'Возле моря';
	enter = function()
		if eveningenabled then evening = evening+1; end;
		gullscheck = gullscounter;
		if gullscheck == gullscounter then gullscounter = rnd(4) end;
		if gullscounter == 4 then seegulls = false else seegulls = true end;
--	pn ('counter:', string.sub(((gullscounter)),1,4)) -- временная строчка для показа переменной
--	pn ('check:', string.sub(((gullscheck)),1,4))
		if seegulls then snd.play('snd/gulls.ogg', 2, 0); end;
		snd.play('snd/sea_waves.ogg', 3, 0);
		end;
	exit = function()
		snd.stop(2);
		snd.stop(3);
		end;
	pic = function()
		if evening == 0 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and gullscounter == 1 then return 'gfx/38.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening == 0 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and gullscounter == 2 then return 'gfx/38_2.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening == 0 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and gullscounter == 3 then return 'gfx/38_3.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening == 0 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight0.png@0,0' end;
		if evening == 1 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight1.png@0,0' end;
		if evening == 2 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight2.png@0,0' end;
		if evening == 3 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight3.png@0,0' end;
		if evening == 4 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight4.png@0,0' end;
		if evening == 5 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight5.png@0,0' end;
		if evening == 6 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight6.png@0,0' end;
		if evening == 7 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight7.png@0,0' end;
		if evening == 8 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight8.png@0,0' end;
		if evening == 9 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight9.png@0,0' end;
		if evening == 10 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight10.png@0,0' end;
		if evening == 11 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight11.png@0,0' end;
		if evening == 12 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight12.png@0,0' end;
		if evening == 13 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight13.png@0,0' end;
		if evening == 14 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight14.png@0,0' end;
		if evening == 15 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight15.png@0,0' end;
		if evening == 16 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight16.png@0,0' end;
		if evening == 17 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight17.png@0,0' end;
		if evening == 18 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight18.png@0,0' end;
		if evening == 19 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight19.png@0,0' end;
		if evening == 20 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight20.png@0,0' end;
		if evening == 21 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight21.png@0,0' end;
		if evening == 22 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight22.png@0,0' end;
		if evening == 23 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight23.png@0,0' end;
		if evening == 24 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight24.png@0,0' end;
		if evening == 25 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight25.png@0,0' end;
		if evening == 26 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight26.png@0,0' end;
		if evening == 27 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight27.png@0,0' end;
		if evening == 28 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight28.png@0,0' end;
		if evening == 29 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight29.png@0,0' end;
		if evening == 30 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight30.png@0,0' end;
		if evening > 30 and gullscounter == 4 then return 'gfx/38_4.png;gfx/daynight2/daynight30.png@0,0' end;
		end;
	onenter = function()
		seaseen = true;
		end;
	decor = function()
		p[[Синее море простирается до горизонта.]];
		if seegulls then p[[Вдали видны чайки, занятые поиском пищи.]] end;
		p[[Водная стихия завораживает. Все герои человеческого эпоса, вероятно, сейчас плавают там, мужественно сражаясь за жизнь... Моряки, пираты, капитаны и матросы... 
К берегу пришвартована {lodka|лодка}.]];
		end;
	obj = {'lodka'};
	way = { path{'К дубу', 'indub'} };
}

obj {
	nam = 'lodka';
	act = function()
		p[[Старая, но всё ещё надежная лодка. Интересно, кому она принадлежит?]];
		end;
}

room {
	nam = 'guesthouse';
	disp = 'Дома у хозяев';
	enter = function()
		snd.music('mus/TheGreatUnknown.ogg');
		end;
	pic = function()
--		if zanaveskaopen and not (evening > 30) then return 'gfx/40_2.png' end;
--		if zanaveskaopen and evening > 30 and oboroten then return 'gfx/40_3.png' end;
--		if zanaveskaopen and evening > 30 and not oboroten then return 'gfx/40_2.png' end;
--		if not zanaveskaopen then return 'gfx/40.png' end;
		if not eveningenabled and zanaveskaopen and not (evening > 30) then return 'gfx/40_2.png' end;
		if not eveningenabled and zanaveskaopen and evening > 30 and oboroten then return 'gfx/40_3.png' end;
		if not eveningenabled and zanaveskaopen and evening > 30 and not oboroten then return 'gfx/40_2.png' end;
		if not eveningenabled and not zanaveskaopen then return 'gfx/40.png' end;
		if eveningenabled and zanaveskaopen and not (evening > 30) then return 'gfx/40_2.png;gfx/daynight2/daynight_evening.png@0,0' end;
		if eveningenabled and zanaveskaopen and evening > 30 and oboroten then return 'gfx/40_3.png;gfx/daynight2/daynight_evening.png@0,0' end;
		if eveningenabled and zanaveskaopen and evening > 30 and not oboroten then return 'gfx/40_2.png;gfx/daynight2/daynight_evening.png@0,0' end;
		if eveningenabled and not zanaveskaopen then return 'gfx/40.png;gfx/daynight2/daynight_evening.png@0,0' end;
		end;
	obj = {'podvinut'};
	decor = function()
		p [[Уютный дом у конюха! Справа ты видишь печку. Слева - кровать от местных мастеров. Наверное, столяр был пьян, когда ее делал... Но это настоящая кровать! С мягкой подушкой и теплым одеялом. Под ногами - красивый коврик. Над головой - визитная карточка этих мест. Здесь нет и не было электричества, поэтому всё на свечах. Наверное, дорого обходится... Ты можешь {podvinut|подвинуть} занавеску.]];
		end;
	way = { path{'Выйти', 'village'} };

}

obj {
	nam = 'podvinut';
	act = function()
		clickmute = true;
		snd.play ('snd/zanaveska.ogg', 1);
		zanaveskaopen = not zanaveskaopen;
--	if not zanaveskaopen then zanaveskaopen = true else zanaveskaopen = false end
		end;
}

createbutton = function()
	D {"control_panel", "img", "gfx/options_menu.png", x = 695, y = 569, click = true, z = -1}
	D {"info_panel", "img", "gfx/info_menu.png", x = 635, y = 567, click = true, z = -1}
	D {"statsclick", "img", "gfx/statsclick.png", x = 635, y = 32, click = true, z = -1}
	createclickonscene();
	end;
deletebutton = function()
	D { "control_panel" }
	D { "info_panel" }
	D { "statsclick" }
	deleteclickonscene();
	end;

createcursors = function()
	D {"cursor_usual", "img", "gfx/inv/cursor.png", x = 739, y = 48, click = true, z = -1}
	D {"cursor_big", "img", "gfx/inv/cursorbig.png", x = 739, y = 98, click = true, z = -1}
	D {"cursor_verybig", "img", "gfx/inv/cursorverybig.png", x = 739, y = 148, click = true, z = -1}
	end;
deletecursors = function()
	D { "cursor_usual" }
	D { "cursor_big" }
	D { "cursor_verybig" }
	end;

createclickonscene = function()
	D {"clickonscene", "img", "gfx/clickonscene.png", x = clickonscene_x, y = clickonscene_y, click = true, z = -1}
	clickonsceneenabled = true;
	end;
deleteclickonscene = function()
	D { "clickonscene" }
	clickonsceneenabled = false;
	end;

createtraces = function()
	D {"traces", "img", "gfx/traces.png", x = rnd(600), y = rnd(500), click = true, z = -1}
	end;
deletetraces = function()
	D { "traces" }
	end;

createruslang = function()
	D {"ruslang", "img", rulangimage, x = 615, y = 33, click = true, z = -1}
	end;
deleteruslang = function()
	D { "ruslang" }
	end;
createenglang = function()
	D {"englang", "img", enlangimage, x = 615, y = 74, click = true, z = -1}
	end;
deleteenglang = function()
	D { "englang" }
	end;
createukrlang = function()
	D {"ukrlang", "img", ualangimage, x = 615, y = 115, click = true, z = -1}
	end;
deleteukrlang = function()
	D { "ukrlang" }
	end;

createinfobar = function()
	if ru then D {"keys_infobar", "img", "gfx/keys_infobar.png", x = 0, y = 0, click = true, z = -1} end;
	if en then D {"keys_infobar", "img", "gfx/keys_infobar_en.png", x = 0, y = 0, click = true, z = -1} end;
	if ua then D {"keys_infobar", "img", "gfx/keys_infobar_ua.png", x = 0, y = 0, click = true, z = -1} end;
	infobarshow = true;
	end;
deleteinfobar = function()
	D { "keys_infobar" }
	infobarshow = false;
	end;

createredbar = function()
	D {"redbar", "img", "gfx/red.png", x = 0, y = 0, click = true, z = -1} 
	redbarshow = true;
	end;
deleteredbar = function()
	D { "redbar" }
	redbarshow = false;
	end;

room {
	nam = 'control_room';
	pic = 'gfx/options.png';
	disp = false;
	noinv = true;
	enter = function()
		weareincontrol = true;
		bg_name = 'gfx/bg_options.png' theme.gfx.bg (bg_name) 
		deletebutton();
		deleteclickonscene();
		createcursors();
		createtraces();
		theme.win.geom (0, 10, 664, 600);
		if ru then p ( fmt.c('Добро пожаловать в меню опций!^Вы можете сменить язык игры, а также размер курсора.') ); end;
		if en then p ( fmt.c('Welcome to the options menu!^You can change the language of the game, as well as the size of the cursor.') ); end;
		if ua then p ( fmt.c('Ласкаво просимо в меню опцій!^Ви можете змінити мову гри, а також розмір курсора.') ); end;
		end;
	decor = function()
	if ru then p ( fmt.c('Выберите язык игры:^') ); end;
	if en then p ( fmt.c('Choose game language:^') ); end;
	if ua then p ( fmt.c('Виберіть мову гри:^') ); end;
	p ( fmt.c(' {russian|Русский}, {english|English}, {ukrainian|Українська}') );
	if ru then p ( fmt.c('^^{enableeveningmode|Включить вечер}.') ); end;
	if en then p ( fmt.c('^^{enableeveningmode|Enable evening}.') ); end;
	if ua then p ( fmt.c('^^{enableeveningmode|Увімкнути вечір}.') ); end;
	if ru then if theme.get'win.fnt.size' ~= '25' then p ( fmt.c('^^{fontsizeplus|Увеличить размер шрифта}.') ); end; end;
	if en then if theme.get'win.fnt.size' ~= '25' then p ( fmt.c('^^{fontsizeplus|Increase font size}.') ); end; end;
	if ua then if theme.get'win.fnt.size' ~= '25' then p ( fmt.c('^^{fontsizeplus|Збільшити розмір шрифту}.') ); end; end;
	if ru then if theme.get'win.fnt.size' ~= '10' then p ( fmt.c('{fontsizeminus|Уменьшить размер шрифта}.') ); end; end;
	if en then if theme.get'win.fnt.size' ~= '10' then p ( fmt.c('{fontsizeminus|Reduce font size}.') ); end; end;
	if ua then if theme.get'win.fnt.size' ~= '10' then p ( fmt.c('{fontsizeminus|Зменшити розмір шрифту}.') ); end; end;
	if ru then p ( fmt.c('^^Текущий размер шрифта: '..fontsize) ); end;
	if en then p ( fmt.c('^^Current font size: '..fontsize) ); end;
	if ua then p ( fmt.c('^^Поточний розмір шрифта: '..fontsize) ); end;
	if ru then p ( fmt.c('^^{@ walkout|К ИГРЕ!}') ); end;
	if en then p ( fmt.c('^^{@ walkout|TO GAME!}') ); end;
	if ua then p ( fmt.c('^^{@ walkout|ДО ГРИ!}') ); end;
	end;
	exit = function()
		weareincontrol = false;
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton(); 
		createclickonscene();
		deletecursors();
		deletetraces();
		theme.reset 'win.x';
		theme.reset 'win.y';
		theme.reset 'win.w';
		theme.reset 'win.h';
		end;
	obj = {'russian', 'english', 'ukrainian', 'enableeveningmode', 'fontsizeplus', 'fontsizeminus'};
}

obj {
	nam = 'russian';
	act = function() setru(); language = 'ru'; p ( fmt.c('^Язык успешно изменен!') ); end;
}

obj {
	nam = 'english';
	act = function() seten(); language = 'en'; p ( fmt.c('^Language successfully changed!') ); end;
}

obj {
	nam = 'ukrainian';
	act = function() setua(); language = 'ua'; p ( fmt.c('^Мову успішно змінено!') ); end;
}

obj {
	nam = 'enableeveningmode';
	act = function()
	eveningenabled = true;
	p ( fmt.c('^Теперь наступит вечер. Но если только вы в деревне.') );
	end;
}

obj {
	nam = 'fontsizeplus';
	act = function()
	fontsizeinc();
	end;
}

obj {
	nam = 'fontsizeminus';
	act = function()
	fontsizedec();
	end;
}

function fontsizeinc()
	if theme.get'win.fnt.size' < '25' then fontsize = theme.get'win.fnt.size'+1; end;
	theme.win.font ("fnt/{sans,sans-b,sans-i,sans-bi}.ttf", fontsize, 1);
	if ru then if theme.get'win.fnt.size' <= '24' then p ( fmt.c('^Размер шрифта увеличен.') ); end; end;
	if en then if theme.get'win.fnt.size' <= '24' then p ( fmt.c('^Font size increased.') ); end; end;
	if ua then if theme.get'win.fnt.size' <= '24' then p ( fmt.c('^Розмір шрифту збільшений.') ); end; end;
	if ru then if theme.get'win.fnt.size' == '25' then p ( fmt.c('^Куда уж больше?..') ); end; end;
	if en then if theme.get'win.fnt.size' == '25' then p ( fmt.c('^Much more?..') ); end; end;
	if ua then if theme.get'win.fnt.size' == '25' then p ( fmt.c('^Куди вже більше?..') ); end; end;
	fontsize = theme.get'win.fnt.size';
end;

function fontsizedec()
	if theme.get'win.fnt.size' > '10' then fontsize = theme.get'win.fnt.size'-1; end;
	theme.win.font ("fnt/{sans,sans-b,sans-i,sans-bi}.ttf", fontsize, 1);
	if ru then if theme.get'win.fnt.size' >= '11' then p ( fmt.c('^Размер шрифта уменьшен.') ); end; end;
	if en then if theme.get'win.fnt.size' >= '11' then p ( fmt.c('^Font size reduced.') ); end; end;
	if ua then if theme.get'win.fnt.size' >= '11' then p ( fmt.c('^Розмір шрифту зменшений.') ); end; end;
	if ru then if theme.get'win.fnt.size' == '10' then p ( fmt.c('^Куда уж меньше?..') ); end; end;
	if en then if theme.get'win.fnt.size' == '10' then p ( fmt.c('^Far less?..') ); end; end;
	if ua then if theme.get'win.fnt.size' == '10' then p ( fmt.c('^Куди вже менше?..') ); end; end;
	fontsize = theme.get'win.fnt.size';
end;

room {
	nam = 'info_room';
	disp = false;
	noinv = true;
	enter = function()
		weareincontrol = true;
		bg_name = 'gfx/bg_info.png' theme.gfx.bg (bg_name) 
		deletebutton();
		theme.win.geom (0, 10, 644, 580);
		end;
	decor = function()
	p ( fmt.c('^'..fmt.img('gfx/icon.png')..'^') );
	if ru then p ( fmt.c('Лесное приключение^^ Текстографическая игра на движке INSTEAD, квест. ^^Автор - Дмитрий Петрук. В сети я представлен под никами:^ Amberit(92), Artorius, Artomberus.') ); end;
	if en then p ( fmt.c('Adventure in the forest^^ Textographic game on the INSTEAD engine, quest. ^^The author - Dmitry Petruk. In the network, I am represented under the nicknames:^ Amberit(92), Artorius, Artomberus.') ); end;
	if ua then p ( fmt.c('Лісова пригода^^ Текстографічна гра на рушії INSTEAD, квест. ^^Автор - Дмитро Петрук. В мережі я представлений під ніками:^ Amberit(92), Artorius, Artomberus.') ); end;
	if ru then p ( fmt.c('^ Найти меня можно в Telegram: @amberit92') ); end;
	if en then p ( fmt.c('^ You can find me on Telegram: @amberit92') ); end;
	if ua then p ( fmt.c('^ Знайти мене можна в Telegram: @amberit92') ); end;
	if ru then p ( fmt.c('^^ На форуме INSTEAD: ^ {$link|http://instead-games.ru/forum/index.php?p=/profile/artomberus}') ); end;
	if en then p ( fmt.c('^^ On INSTEAD forum (russian language): ^ {$link|http://instead-games.ru/forum/index.php?p=/profile/artomberus}') ); end;
	if ua then p ( fmt.c('^^ На форумі INSTEAD (російською): ^ {$link|http://instead-games.ru/forum/index.php?p=/profile/artomberus}') ); end;
	if ru then p ( fmt.c('^^ Адрес игры на GitHub: ^ {$link|https://github.com/artomberus/adventureintheforest}') ); end;
	if en then p ( fmt.c('^^ Game adress on GitHub: ^ {$link|https://github.com/artomberus/adventureintheforest}') ); end;
	if ua then p ( fmt.c('^^ Адреса гри на GitHub: ^ {$link|https://github.com/artomberus/adventureintheforest}') ); end;
	if ru then p ( fmt.c('^^ Также посмотрите мою галерею фотографий природы: ^ {$link|https://www.deviantart.com/artomberus/gallery/}') ); end;
	if en then p ( fmt.c('^^ Also see my gallery of nature photos: ^ {$link|https://www.deviantart.com/artomberus/gallery/}') ); end;
	if ua then p ( fmt.c('^^ Також подивіться мою галерею фотографій природи: ^ {$link|https://www.deviantart.com/artomberus/gallery/}') ); end;
	if ru then p ( fmt.c('^^ Ещё один мой проект на движке INSTEAD: ^ {$link|http://instead-games.ru/game.php?ID=329}') ); end;
	if en then p ( fmt.c('^^ Another project of mine on the INSTEAD engine: ^ {$link|http://instead-games.ru/game.php?ID=329}') ); end;
	if ua then p ( fmt.c('^^ Ще один мій проект на рушії INSTEAD: ^ {$link|http://instead-games.ru/game.php?ID=329}') ); end;
	if ru then p ( fmt.c('^^Спасибо всем, кто помогал и помогает мне с инстедом и разработкой.^ Позднее я напишу здесь подробно. А теперь...') ); end;
	if en then p ( fmt.c('^^Thanks to everyone who helped and helps me with INSTEAD and development. ^ Later I will write here in detail. And now...') ); end;
	if ua then p ( fmt.c('^^Дякую всім, хто допомагав і допомагає мені з інстедом і розробкою. ^ Пізніше я напишу тут докладно. А зараз...') ); end;
	if ru then p ( fmt.c('^^{@ walkout|К ИГРЕ!}') ); end;
	if en then p ( fmt.c('^^{@ walkout|TO GAME!}') ); end;
	if ua then p ( fmt.c('^^{@ walkout|ДО ГРИ!}') ); end;
	end;
	exit = function()
		weareincontrol = false;
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton(); 
		theme.reset 'win.x';
		theme.reset 'win.y';
		theme.reset 'win.w';
		theme.reset 'win.h';
		end;
}

room {
	nam = 'stats';
	disp = false;
	noinv = true;
	enter = function()
		weareincontrol = true;
		bg_name = 'gfx/bg_info.png' theme.gfx.bg (bg_name) 
		deletebutton();
		theme.win.geom (0, 10, 664, 600);
		end;
	decor = function()
	p ( fmt.c('^'..fmt.img('gfx/icon.png')..'^') );
	if ru then p ( fmt.c('^Итак. Что же ты успел сделать уже?^^') ); end;
	if ru and touchedkey then p ( fmt.c('Посветил фонариком и нашел ключ.') ); end;
	if ru and touchedtopor then p ( fmt.c('Нашел топор.') ); end;
	if ru and openedwithkey then p ( fmt.c('Открыл дверь ключом.') ); end;
	if ru and brokenwithtopor then p ( fmt.c('Сломал дверь топором.') ); end;
	if ru and havelopata then p ( fmt.c('^Взял лопату в хижине.') ); end;
	if ru and haveudochka then p ( fmt.c('Взял удочку в хижине.') ); end;
	if ru and havevedro then p ( fmt.c('Взял ведро в хижине.') ); end;
	if ru then p ( fmt.c('^^{@ walkout|К ИГРЕ!}') ); end;
	if en then p ( fmt.c('^^{@ walkout|TO GAME!}') ); end;
	if ua then p ( fmt.c('^^{@ walkout|ДО ГРИ!}') ); end;
	end;
	exit = function()
		weareincontrol = false;
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
		createbutton(); 
		theme.reset 'win.x';
		theme.reset 'win.y';
		theme.reset 'win.w';
		theme.reset 'win.h';
		end;
}

function keys:filter(press, key) -- код для того, чтобы узнавать коды клавиш
	return press
--	if key == 'up' or key == 'down' or key == 'left' or key == 'right' or key == 'return' or key == 'space' or key == 'o' or --key == 'k' or key == 'i' then return press
--	end
end;
game.onkey = function(s, press, key)
	if not passedintro and key == 'up' and ualangimage ~= "gfx/ukrainian_selected.png" and rulangimage ~= "gfx/russian_selected.png" and enlangimage ~= "gfx/english_selected.png" then ualangimage = "gfx/ukrainian_selected.png"; setua(); clickmute = true; walk('main') return end; -- если не выбрали, и жмем вверх
	if not passedintro and key == 'down' and rulangimage ~= "gfx/russian_selected.png" and enlangimage ~= "gfx/english_selected.png" and ualangimage ~= "gfx/ukrainian_selected.png" then rulangimage = "gfx/russian_selected.png"; setru(); clickmute = true; walk('main') return end; -- если не выбрали, и жмем вниз
	if not passedintro and key == 'up' and rulangimage == "gfx/russian_selected.png" then rulangimage = "gfx/russian.png"; ualangimage = "gfx/ukrainian_selected.png"; setua(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'up' and enlangimage == "gfx/english_selected.png" then enlangimage = "gfx/english.png"; rulangimage = "gfx/russian_selected.png"; setru(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'up' and ualangimage == "gfx/ukrainian_selected.png" then ualangimage = "gfx/ukrainian.png"; enlangimage = "gfx/english_selected.png"; seten(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'down' and ualangimage == "gfx/ukrainian_selected.png" then ualangimage = "gfx/ukrainian.png"; rulangimage = "gfx/russian_selected.png"; setru(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'down' and enlangimage == "gfx/english_selected.png" then enlangimage = "gfx/english.png"; ualangimage = "gfx/ukrainian_selected.png"; setua(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'down' and rulangimage == "gfx/russian_selected.png" then rulangimage = "gfx/russian.png"; enlangimage = "gfx/english_selected.png"; seten(); clickmute = true; walk('main') return end;

	if not passedintro and key == 'left' and ualangimage ~= "gfx/ukrainian_selected.png" and rulangimage ~= "gfx/russian_selected.png" and enlangimage ~= "gfx/english_selected.png" then ualangimage = "gfx/ukrainian_selected.png"; setua(); clickmute = true; walk('main') return end; -- если не выбрали, и жмем влево
	if not passedintro and key == 'right' and rulangimage ~= "gfx/russian_selected.png" and enlangimage ~= "gfx/english_selected.png" and ualangimage ~= "gfx/ukrainian_selected.png" then rulangimage = "gfx/russian_selected.png"; setru(); clickmute = true; walk('main') return end; -- если не выбрали, и жмем вправо
	if not passedintro and key == 'left' and rulangimage == "gfx/russian_selected.png" then rulangimage = "gfx/russian.png"; ualangimage = "gfx/ukrainian_selected.png"; setua(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'left' and ualangimage == "gfx/ukrainian_selected.png" then ualangimage = "gfx/ukrainian.png"; enlangimage = "gfx/english_selected.png"; seten(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'left' and enlangimage == "gfx/english_selected.png" then enlangimage = "gfx/english.png"; rulangimage = "gfx/russian_selected.png"; setru(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'right' and rulangimage == "gfx/russian_selected.png" then rulangimage = "gfx/russian.png"; enlangimage = "gfx/english_selected.png"; seten(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'right' and ualangimage == "gfx/ukrainian_selected.png" then ualangimage = "gfx/ukrainian.png"; rulangimage = "gfx/russian_selected.png"; setru(); clickmute = true; walk('main') return end;
	if not passedintro and key == 'right' and enlangimage == "gfx/english_selected.png" then enlangimage = "gfx/english.png"; ualangimage = "gfx/ukrainian_selected.png"; setua(); clickmute = true; walk('main') return end;
	
	if not passedintro and key == 'return' then walk('start') return end;
	if not passedintro and key == 'space' then walk('start') return end;
--	p("Нажата: ", key);
	if passedintro and key == 'i' and not infobarshow and not weareincontrol then walkin('info_room'); return end;
	if passedintro and key == 'o' and not infobarshow and not weareincontrol then walkin('control_room'); return end;
	if passedintro and key == 'k' and not infobarshow then instead.fading = false; deleteclickonscene(); fadingcanbe = false; createinfobar(); theme.gfx.bg (bg_name) return okay(); end;  
	if passedintro and key == 'k' and infobarshow then deleteinfobar(); theme.gfx.bg (bg_name) createclickonscene(); fadingcanbe = true; repeatplease = true; return std.nop() end; 

	if passedintro and press and infobarshow then deleteinfobar(); theme.gfx.bg (bg_name) createclickonscene(); fadingcanbe = true; repeatplease = true; return std.nop() end;

	if weareincontrol and key == 'escape' then walk( from() ) return end;
	
	if key == 'r' then
		if ru == false then langchanged = true else langchanged = false end;
		setru();
		rulangimage = "gfx/russian_selected.png";
		enlangimage = "gfx/english.png";
		ualangimage = "gfx/ukrainian.png";
		if here() ~= 'main' then
					if langchanged then walk( here() ) else
						if seen('dub', here() ) then std.nop() walk( here() )
--									if ru then return p(inplaceofrespawnRU[counter]) end 
--									if en then return p(inplaceofrespawnEN[counter]) end
--									if ua then return p(inplaceofrespawnUA[counter]) end 
						 end;
					end;
		end;
		if firststart then walk(here()) end;
		return end;
	if key == 'e' then
		if en == false then langchanged = true else langchanged = false end;
		seten();
		enlangimage = "gfx/english_selected.png";
		rulangimage = "gfx/russian.png";
		ualangimage = "gfx/ukrainian.png";
		if here() ~= 'main' then if langchanged then walk( here() ) else
						if seen('dub', here() ) then  std.nop() walk( here() )
--									if ru then return p(inplaceofrespawnRU[counter]) end 
--									if en then return p(inplaceofrespawnEN[counter]) end
--									if ua then return p(inplaceofrespawnUA[counter]) end 
						 end;
		 			end;
		end;
		if firststart then walk(here()) end;
		return end;
	if key == 'u' then 
		if ua == false then langchanged = true else langchanged = false end;
		setua();
		ualangimage = "gfx/ukrainian_selected.png";
		rulangimage = "gfx/russian.png";
		enlangimage = "gfx/english.png";
		if here() ~= 'main' then if langchanged then walk( here() ) else
						if seen('dub', here() ) then std.nop() walk( here() )
--									if ru then return p(inplaceofrespawnRU[counter]) end 
--									if en then return p(inplaceofrespawnEN[counter]) end
--									if ua then return p(inplaceofrespawnUA[counter]) end 
						 end;
					end;
		end;
		if firststart then walk(here()) end;
		return end;
--	p("Нажата: ", key);
	if passedintro and key == '-' then 
	if clickonscene_y >= 26 then fontsizedec() clickonscene_y = clickonscene_y-1.5 deleteclickonscene() createclickonscene() theme.gfx.bg (bg_name) end;
				 return end;
	if passedintro and key == '=' then
	if clickonscene_y <= 45.5 then fontsizeinc() clickonscene_y = clickonscene_y+1.5 deleteclickonscene() createclickonscene() theme.gfx.bg (bg_name) end;
				 return end;
	if not passedintro and not key == 'o' and not key == 'k' and not key == 'i' and not key == 'r' and not key == 'e' and not key == 'u' and not key == 'escape' and not key == '-' and not key == '=' then return true else return false end;
end;

okay = function() -- заморозить сцену и перейти ещё раз
	std.nop();
	walk ( here() );
	end;
