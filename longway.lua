--
-- The source code of the game (including images) is distributed under the MIT license. For the full text of the license, see the file LICENCE.txt, which is located in the game directory. Sounds, music - distributed under their own licenses, see snd/source.txt and mus/Copyright.txt
--
-- Исходный код игры (включая изображения) распространяется на условиях лицензии MIT. Полный текст лицензии см. в файле LICENCE.txt, который находится в каталоге с игрой. Звуки, музыка - распространяются под своими лицензиями, см. snd/source.txt и mus/Copyright.txt
--

global {
	hungry = 0;
	hungrymax = 5; -- после какого количества перекусов - наелся
	prival1enabled = false;
	prival2enabled = false;
	prival3enabled = false;
	prival4enabled = false;
	prival5enabled = false;
	prival6enabled = false;
	gowithwolf = false; -- прошел ли путь с волком
	gowithoutwolf = false; -- прошел ли путь без волка
	talkedwithwolfonmountains = false;
	youeatenfish = false; -- ел ли рыбу
	youeatenmilk = false; -- ел ли молоко. если сочетание условий - пишем ещё сообщение.
	updatescene = false; -- обновить сцену, когда ешь яблоки на пути
	updatescene2 = false; -- обновить сцену, когда ешь оставшееся яблоко на пути
	specialcase2 = false; -- особый случай с яблоками
}

room {
	nam = 'longroad1';
	pic = 'gfx/daynight/30_1.png';
	disp = 'Долгая дорога через горы (14:30) День 0';
	dsc = [[Нелегко придется...]];
	enter = function()
	hungry = 0;
	nobackway = true;
	snd.music('mus/Clouds.ogg');
	end;
	way = { path {'Дальше','longroad2'} };
}

room {
	nam = 'longroad2';
	pic = 'gfx/daynight/30_2.png';
	disp = 'Долгая дорога через горы (16:00) День 0';
	dsc = [[Как здесь быстро темнеет...]];
	way = { path {'Дальше','longroad3'} };
}

room {
	nam = 'longroad3';
	pic = 'gfx/daynight/30_3.png';
	disp = 'Долгая дорога через горы (17:30) День 0';
	dsc = [[Вот уже вечер наступает...]];
	way = { path {'Дальше','longroad4'} };
}

room {
	nam = 'longroad4';
	pic = 'gfx/daynight/30_4.png';
	disp = 'Долгая дорога через горы (19:00) День 0';
	dsc = [[Дело близится к ночи...]];
	way = { path {'Дальше','longroad5'} };
}

room {
	nam = 'longroad5';
	pic = 'gfx/daynight/30_5.png';
	disp = 'Долгая дорога через горы (20:30) День 0';
	enter = function()
	hungry = 0;
	end;
	dsc = [[Ты устал...]];
	way = { path {'Дальше','longroad6'} };
}

room {
	nam = 'longroad6';
	pic = 'gfx/daynight/30_6.png';
	disp = 'Долгая дорога через горы (22:00) День 0';
	enter = function()
	if not have('samobranka') and not have('apples') then enable('#enable1prival') end;
	end;
	dsc = function()
	if not have('samobranka') and not have('apples') and have('one_apple') and not specialcase2 then p [[Привал?.. У тебя осталось одно яблоко, но, пожалуй, лучше потерпеть...]] end;
	if not have('samobranka') and not have('apples') and not have('one_apple') then p [[Привал?.. А кушать-то нечего... Хоть поспи немного.]] end;
	if not have('samobranka') and have('apples') then p [[Надо бы съесть яблоки... А иначе вообще нет сил.]] specialcase2 = true; updatescene = true; end;
	if have('samobranka') and hungry < 5 then p [[Привал?.. Надо бы поесть, чтобы идти дальше...]] end;
	if have('samobranka') and hungry >= 5 then p [[А теперь пора в путь!]] end;
	if have('samobranka') and hungry >= 6 then p [[Кажется, ты переел... Всё хорошо, что в меру, не надо так делать :)]] end;
	if prival1enabled then enable('#enable1prival') end;
	end;
	way = { path {'#enable1prival', 'Дальше','longroad7'}:disable() };
}:with {
	obj {
		nam = 'enable1prival';
	    };
	};

room {
	nam = 'longroad7';
	pic = 'gfx/daynight/30_7.png';
	disp = 'Долгая дорога через горы (00:30) Ночь 1';
	enter = function()
	hungry = 0;
	prival2enabled = false;
	end;
	dsc = [[Глубокая ночь...]];
	way = { path {'Дальше','longroad8'} };
}

room {
	nam = 'longroad8';
	pic = 'gfx/daynight/30_8.png';
	disp = 'Долгая дорога через горы (02:00) Ночь 1';
	dsc = [[Но она длится недолго...]];
	way = { path {'Дальше','longroad9'} };
}

room {
	nam = 'longroad9';
	pic = 'gfx/daynight/30_9.png';
	disp = 'Долгая дорога через горы (03:30) Ночь 1';
	dsc = [[Скоро утро...]];
	way = { path {'Дальше','longroad10'} };
}

room {
	nam = 'longroad10';
	pic = 'gfx/daynight/30_10.png';
	disp = 'Долгая дорога через горы (05:00) Ночь 1';
	dsc = [[Почти светло...]];
	way = { path {'Дальше','longroad11'} };
}

room {
	nam = 'longroad11';
	pic = 'gfx/daynight/30_11.png';
	disp = 'Долгая дорога через горы (06:30) Ночь 1';
	dsc = [[Пора вставать...]];
	way = { path {'Дальше','longroad12'} };
}

room {
	nam = 'longroad12';
	pic = 'gfx/daynight/30_12.png';
	disp = 'Долгая дорога через горы (08:00) День 1';
	enter = function()
	hungry = 0;
	end;
	dsc = function()
	if not have('samobranka') then p [[Примерно в это время ты проснулся вчера...]] end;
	if have('samobranka') then p [[Примерно в это время я проснулся вчера...]] end;
	end;
	way = { path {'Дальше','longroad13'} };
}

room {
	nam = 'longroad13';
	pic = 'gfx/daynight/30_13.png';
	disp = 'Долгая дорога через горы (09:30) День 1';
	enter = function()
	if not have('samobranka') and not have('one_apple') then enable('#enable2prival') end;
	end;
	dsc = function()
	if not have('samobranka') and not have('one_apple') and not updatescene2 then p [[Уже сутки без еды... Ещё немного - и ты окочуришься...]] end;
	if not have('samobranka') and have('one_apple') then p [[Пора съесть последнее яблоко...]] updatescene2 = true; end;
	if have('samobranka') and hungry < 5 then p [[Что же. Подкрепимся - и в путь!]] end;
	if have('samobranka') and hungry >= 5 then p [[Вперед с новыми силами!]] end;
	if have('samobranka') and hungry >= 6 then p [[Кажется, ты переел... И чувствуешь тяжесть в желудке.]] end;
	if prival2enabled then enable('#enable2prival') end;
	end;
	way = { path {'#enable2prival', 'Дальше','longroad14'}:disable() };
}:with {
	obj {
		nam = 'enable2prival';
	    };
	};

room {
	nam = 'longroad14';
	pic = 'gfx/daynight/30_14.png';
	disp = 'Долгая дорога через горы (11:00) День 1';
	enter = function()
	hungry = 0;
	prival3enabled = false;
	end;
	dsc = function()
	if not have('samobranka') then p [[Ты почти умер. Тяжело шевелиться. Ползешь. Смотришь потускневшим взглядом на горизонт, а он кажется бесконечным...]] end;
	if have('samobranka') then p [[Что нам день готовит?..]] end;
	end;
	way = { path {'Дальше','longroad15'} };
}

room {
	nam = 'longroad15';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_15WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_15.png' end;
	end;
	disp = 'Долгая дорога через горы (12:30) День 1';
	dsc = function()
	if not have('samobranka') then p [[Вдали что-то или кто-то есть!]] end;
	if have('samobranka') then p [[Люблю, когда светит солнце...]] end;
	end;
	way = { path {'Дальше','longroad16'} };
}

room {
	nam = 'longroad16';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_16WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_16.png' end;
	end;
	disp = 'Долгая дорога через горы (14:00) День 1';
	dsc = function()
	if not have('samobranka') then p [[Эх! Слишком далеко. -- Эй, вы! Я здесь! Спасите! - твой призыв о помощи разнесся ветром, как будто его и не было...]] end;
	if have('samobranka') then p [[Ненавижу палящее солнце!..]] end;
	end;
	way = { path {'Дальше','longroad17'} };
}

room {
	nam = 'longroad17';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_17WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_17.png' end;
	end;
	disp = 'Долгая дорога через горы (15:30) День 1';
	dsc = function()
	if not have('samobranka') then p [[Тёмное пятно вдали приблизилось. Всё еще непонятно, кто это, но это явно живое существо. Может, человек?]] end;
	if have('samobranka') then p [[О, так-то лучше...]] end;
	end;
	way = { path {'Дальше','longroad18'} };
}

room {
	nam = 'longroad18';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_18WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_18.png' end;
	end;
	disp = 'Долгая дорога через горы (17:00) День 1';
	dsc = function()
	if not have('samobranka') then p [[Темнеет. День скоро подходит к концу. Таинственный путник приближается. Ещё немного - и можно будет разглядеть, кто это. В тебе начала теплиться надежда.]] end;
	if have('samobranka') then p [[И снова день проходит...]] end;
	end;
	way = { path {'Дальше','longroad19'} };
}

room {
	nam = 'longroad19';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_19WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_19.png' end;
	end;
	disp = 'Долгая дорога через горы (18:30) День 1';
	dsc = function()
	if not have('samobranka') then p [[Сквозь сумерки ты смог разглядеть приближавшегося. Ты думал, что это всадник на коне. Но нет. Это не так. Это волк! Твоя душа ушла в пятки...]] end;
	if have('samobranka') then p [[Темнеет...]] end;
	end;
	way = { path {'Дальше','longroad20'} };
}

room {
	nam = 'longroad20';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_20WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_20.png' end;
	end;
	disp = 'Долгая дорога через горы (20:00) День 1';
	dsc = function()
	if not have('samobranka') then p [[Волк приблизился достаточно, чтобы его можно было рассмотреть даже сквозь темноту. Это тот самый волк, который съел твоего коня! Неужели он пришел за тобой? Мало ему мяса... Ты весь дрожишь. Усталость и голод, плюс приближение волка. Да, тебе не позавидуешь... ]] end;
-- тут добавить фразы - и зачем я съел яблоко или - и зачем я изрубил деревья?
	if have('samobranka') then p [[Вечереет...]] end;
	end;
	way = { path {'Дальше','longroad21'} };
}

room {
	nam = 'longroad21';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_21WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_21.png' end;
	end;
	disp = 'Долгая дорога через горы (21:30) День 1';
	enter = function()
	hungry = 0;
	end;
	dsc = function()
	if not have('samobranka') then p [[Волк приблизился к тебе почти вплотную. Ты видишь его, мчащегося изо всех сил к тебе, он высунул язык и явно спешит к своей добыче, хотя и подустал. Твоё сердце колотится в бешенном ритме. Он здесь! Возле тебя! Нет! От страха ты потерял сознание и свалился на камни мертвым грузом...]] end;
	if have('samobranka') then p [[Скоро ночь...]] end;
	end;
	way = { path {'Дальше','longroad22'} };
}

room {
	nam = 'longroad22';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_22WOLF.png' end;
	if have('samobranka') then return 'gfx/daynight/30_22.png' end;
	end;
	disp = 'Долгая дорога через горы (23:00) День 1';
	enter = function()
	if not have('samobranka') and not have('topor') and talkedwithwolfonmountains then enable('#enable3prival') end;
	end;
	dsc = function()
	if not have('samobranka') and not talkedwithwolfonmountains then p [[Ты очнулся от того, что тебя тащили по траве. Ты беспорядочно замахал руками. Волк аккуратно опустил тебя на землю, но от страха ты снова вырубился. Эй, дружище, так нельзя! Волк облизал твоё лицо своим языком. Уж это-то заставило тебя очнуться и резво прийти в себя. Ты видишь {towolfmountains|волка} перед собой.]] end;
	if have('samobranka') and hungry < 5 then p [[Пора отдохнуть? И перекусить :)]] end;
	if have('samobranka') and hungry >= 5 then p [[Можно идти вперед :)]] end;
	if have('samobranka') and hungry >= 6 then p [[Кажется, ты переел...]] end;	
	if prival3enabled then enable('#enable3prival') end;
	end;
	obj = {'towolfmountains'};
	way = { path {'#enable3prival', 'Дальше','longroad23'}:disable() };
}:with {
	obj {
		nam = 'enable3prival';
	    };
	};

obj {
	nam = 'towolfmountains';
	act = function()
	if not talkedwithwolfonmountains then walkin ('talkwithwolfmountains') else p [[Волк молча ждет тебя.]] end;
	end;
}

dlg {
	nam = 'talkwithwolfmountains'; -- диалог с волком в горах
	pic = 'gfx/18MIRROR.png';
	noinv = true;
	title = false; 
	enter = function()
	talkedwithwolfonmountains = true;
	p [[Волк посмотрел на тебя, и... заговорил:^ -- Наконец-то! Я уж думал, ты так и будешь терять сознание.]] 
	 bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
	end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
	end;
	phr = { -- начало фразы
			{'Ты вернулся? Зачем? Я боялся, что теперь ты и меня съешь!', '-- Неет! Мне стало жаль тебя, ведь это я съел твоего коня. Я всё равно вольно бегаю по земле, так чего бы мне не помочь тебе, особенно в такой щекотливой ситуации. Особенно, если ты проворонил свой шанс на чудо-скатерть...',
				{'Не буду спрашивать, откуда ты это знаешь.', '-- И не надо. Весь лес знает о тебе, только ты, наивный, блуждаешь и делаешь ошибки. Но мы не можем тебе подсказывать. Выбирать ты должен сам.',
						only = true;
						{'Выбирать? Что выбирать?', function() p'-- Ни слова не скажу. Ты уже очень слаб - не будем терять времени. Садись на мою спину - отнесу тебя к деревне. А там уж и попрощаемся.' if have('topor') then p'Только топор оставь. Тяжелый он...' removetopor = true; end walk('longroad22') end }, 
						{'Да, зря я тогда так поступил. Но что поделать, надо продолжать путешествие.', function() p'-- Согласен. А теперь не будем терять времени. Ты уже очень слаб. Садись на мою спину - отнесу тебя к деревне. А там уж и попрощаемся.' if have('topor') then p'Только топор оставь. Тяжелый он...' removetopor = true; end walk('longroad22')  end }

					
				}
			}

	      } -- конец фразы

}

dlg { -- диалог с волком, после того, как он отвозит героя в деревню
	nam = 'talkwithwolfinvillage';
	pic = 'gfx/18.png';
	noinv = true;
	title = false; 
	enter = function()
	talkedwithwolfonmountains = true;
	p [[Волк посмотрел на тебя, и... заговорил:^ -- Ну всё, на этом месте наши пути расходятся. Удачного путешествия тебе. И не делай больше ошибок.]] 
	 bg_name = 'gfx/bg_talk.png' theme.gfx.bg (bg_name)
	end;
	exit = function()
		bg_name = 'gfx/bg.png' theme.gfx.bg (bg_name) 
	end;
	phr = { -- начало фразы
			{'Спасибо тебе за помощь. Это очень благородно с твоей стороны.', function() p'-- Да не за что. Почему бы не помочь хорошему человеку, к тому же я сам лишил тебя коня. Виноват, но иначе нельзя. Правила... И я хотел есть, чего уж там скрывать.' if topornavolka then p'Вот только не надо было на меня с топором бросаться. Глупо это, не находишь?' end end,
			{ function() p'Да, я понимаю.' if topornavolka then p'Был напуган, да и жаль было коня... Прости.' end p'Всего хорошего, дружище.' end , function() p'-- И тебе не хворать. Прощай. ^^Волк ускакал вдаль, только дорожная пыль тучами встала в воздухе, потом и она затихла. Итак, ты на месте.' alreadytalkedwolfinvillage =true; walk('village') end }

			}

	      } -- конец фразы

}

room {
	nam = 'longroad23';
	pic = 'gfx/daynight/30_23.png';
	disp = 'Долгая дорога через горы (01:30) Ночь 2';
	enter = function()
	hungry = 0;
	prival4enabled = false;
	end;
	dsc = function()
	if not have('samobranka') then p [[Ты привязал себя к волку одеждой, обнял его могучее туловище и так повис. Он мягко, но шустро поскакал по горам и тропинкам. Ты не успел осознать, как уснул.]] end;
	if have('samobranka') then p [[Глубокая ночь...]] end;
	end;
	way = { path {'Дальше','longroad24'} };
}

room {
	nam = 'longroad24';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_31.png' end;
	if have('samobranka') then return 'gfx/daynight/30_24.png' end;
	end;
	disp = function()
	if not have('samobranka') then return 'Долгая дорога через горы (09:00) День 2' end;
	if have('samobranka') then return 'Долгая дорога через горы (03:00) Ночь 2' end;
	end;
	dsc = function()
	if not have('samobranka') then p [[Ты проснулся от солнечного света. Уже утро. Ты сел на волка, как на коня, ухватившись руками за шею. Ты немного пришел в себя, хотя по-прежнему слаб. Ещё немного, и вы доберетесь до города.]] end;
	if not have('samobranka') and have('kuvshinwithwater') then p[[^Ты с сожалением отметил, что во время пути вода из кувшина расплескалась, и теперь он пуст...]] replace('kuvshinwithwater', 'kuvshin') end;
	if have('samobranka') then p [[До этого момента...]] end;
	end;
	way = { path {'Дальше','longroad25'} };
}

room {
	nam = 'longroad25';
	pic = function()
	if not have('samobranka') then return 'gfx/daynight/30_32.png' end;
	if have('samobranka') then return 'gfx/daynight/30_25.png' end;
	end;
	disp = function()
	if not have('samobranka') then return 'Долгая дорога через горы (10:30) День 2' end;
	if have('samobranka') then return 'Долгая дорога через горы (04:30) Ночь 2' end;
	end;
	enter = function()
	if not have('samobranka') then enable('#gowithwolf') end;
	if have('samobranka') then enable('#gowithoutwolf') end;
	end;
	dsc = function()
	if not have('samobranka') then p [[Вы на месте.]] end;
	if have('samobranka') then p [[Скоро вставать...]] end;
	end;
	way = { path {'#gowithwolf', 'Дальше','village'}:disable(), path {'#gowithoutwolf', 'Дальше','longroad26'}:disable() };
}:with {
	obj {
		nam = 'gowithwolf';
	    };
	obj {
		nam = 'gowithoutwolf';
	    };
	};
	
-- }

room {
	nam = 'longroad26';
	pic = 'gfx/daynight/30_26.png';
	disp = 'Долгая дорога через горы (06:00) Ночь 2';
	dsc = [[Вот и утро...]];
	way = { path {'Дальше','longroad27'} };
}

room {
	nam = 'longroad27';
	pic = 'gfx/daynight/30_27.png';
	disp = 'Долгая дорога через горы (07:30) День 2';
	enter = function()
	hungry = 0;
	end;
	dsc = [[Что день грядущий нам готовит?..]];
	way = { path {'Дальше','longroad28'} };
}

room {
	nam = 'longroad28';
	pic = 'gfx/daynight/30_28.png';
	disp = 'Долгая дорога через горы (09:00) День 2';
	enter = function()
	if not have('samobranka') then enable('#enable4prival') end;
	end;
	dsc = function()
	if not have('samobranka') then p [[Вторые сутки без еды...]] end;
	if have('samobranka') and hungry < 5 then p [[Пора доставать скатерть?]] end;
	if have('samobranka') and hungry >= 5 then p [[Ух, как наелся. Надо идти.]] end;
	if have('samobranka') and hungry >= 6 then p [[Похоже, ты съел слишком много.]] end;
	if prival4enabled then enable('#enable4prival') end;
	end;
	way = { path {'#enable4prival', 'Дальше','longroad29'}:disable() };
}:with {
	obj {
		nam = 'enable4prival';
	    };
	};

room {
	nam = 'longroad29';
	pic = 'gfx/daynight/30_29.png';
	disp = 'Долгая дорога через горы (10:30) День 2';
	enter = function()
	hungry = 0;
	prival5enabled = false;
	end;
	dsc = [[Умираю...]];
	way = { path {'Дальше','longroad30'} };
}

room {
	nam = 'longroad30';
	pic = 'gfx/daynight/30_30.png';
	disp = 'Долгая дорога через горы (12:00) День 2';
	dsc = [[Вот теперь! Умираю...]];
	way = { path {'Дальше','longroad31'} };
}

room {
	nam = 'longroad31';
	pic = 'gfx/daynight/30_31.png';
	disp = 'Долгая дорога через горы (13:30) День 2';
	dsc = [[Эта жара!..]];
	way = { path {'Дальше','longroad32'} };
}

room {
	nam = 'longroad32';
	pic = 'gfx/daynight/30_32.png';
	disp = 'Долгая дорога через горы (15:00) День 2';
	dsc = [[Ровный день...]];
	way = { path {'Дальше','longroad33'} };
}

room {
	nam = 'longroad33';
	pic = 'gfx/daynight/30_33.png';
	disp = 'Долгая дорога через горы (16:30) День 2';
	dsc = [[О, похолодало...]];
	way = { path {'Дальше','longroad34'} };
}

room {
	nam = 'longroad34';
	pic = 'gfx/daynight/30_34.png';
	disp = 'Долгая дорога через горы (18:00) День 2';
	dsc = [[Темнеет, да...]];
	way = { path {'Дальше','longroad35'} };
}

room {
	nam = 'longroad35';
	pic = 'gfx/daynight/30_35.png';
	disp = 'Долгая дорога через горы (19:30) День 2';
	dsc = [[Скоро вечер...]];
	way = { path {'Дальше','longroad36'} };
}

room {
	nam = 'longroad36';
	pic = 'gfx/daynight/30_36.png';
	disp = 'Долгая дорога через горы (21:00) День 2';
	enter = function()
	hungry = 0;
	end;
	dsc = [[Скоро спать...]];
	way = { path {'Дальше','longroad37'} };
}

room {
	nam = 'longroad37';
	pic = 'gfx/daynight/30_37.png';
	disp = 'Долгая дорога через горы (22:30) День 2';
	enter = function()
	if not have('samobranka') then enable('#enable5prival') end;
	end;
	dsc = function()
	if not have('samobranka') then p [[Отдыхаем...]] end;
	if have('samobranka') and hungry < 5 then p [[Надо бы покушать?]] end;
	if have('samobranka') and hungry >= 5 then p [[Кажется, даже еда из скатерти-самобранки начинает приедаться. Удивительное создание, человек! Но пора идти...]] end;
	if have('samobranka') and hungry >= 6 then p [[И, кажется, ты переел...]] end;
	if prival5enabled then enable('#enable5prival') end;
	end;
	way = { path {'#enable5prival', 'Дальше','longroad38'}:disable() };
}:with {
	obj {
		nam = 'enable5prival';
	    };
	};

room {
	nam = 'longroad38';
	pic = 'gfx/daynight/30_38.png';
	disp = 'Долгая дорога через горы (00:00) Ночь 3';
	enter = function()
	hungry = 0;
	prival6enabled = false;
	end;
	dsc = [[Полуночь...]];
	way = { path {'Дальше','longroad39'} };
}

room {
	nam = 'longroad39';
	pic = 'gfx/daynight/30_39.png';
	disp = 'Долгая дорога через горы (01:30) Ночь 3';
	dsc = [[Тьма - хоть глаз выколи...]];
	way = { path {'Дальше','longroad40'} };
}

room {
	nam = 'longroad40';
	pic = 'gfx/daynight/30_40.png';
	disp = 'Долгая дорога через горы (03:00) Ночь 3';
	dsc = [[Но ничто не вечно под луной...]];
	way = { path {'Дальше','longroad41'} };
}

room {
	nam = 'longroad41';
	pic = 'gfx/daynight/30_41.png';
	disp = 'Долгая дорога через горы (04:30) Ночь 3';
	dsc = [[Ночь проходит...]];
	way = { path {'Дальше','longroad42'} };
}

room {
	nam = 'longroad42';
	pic = 'gfx/daynight/30_42.png';
	disp = 'Долгая дорога через горы (06:00) Ночь 3';
	dsc = [[Вот и утро...]];
	way = { path {'Дальше','longroad43'} };
}

room {
	nam = 'longroad43';
	pic = 'gfx/daynight/30_43.png';
	disp = 'Долгая дорога через горы (07:30) День 3';
	enter = function()
	hungry = 0;
	end;
	dsc = [[Вставать пора...]];
	way = { path {'Дальше','longroad44'} };
}

room {
	nam = 'longroad44';
	pic = 'gfx/daynight/30_44.png';
	disp = 'Долгая дорога через горы (09:00) День 3';
	enter = function()
	if not have('samobranka') then enable('#enable6prival') end;
	end;
	dsc = function()
	if not have('samobranka') then p [[Третьи сутки без еды...]] end;
	if have('samobranka') and hungry < 5 then p [[Время завтракать! Снова эта скатерть...]] end;
	if have('samobranka') and hungry >= 6 then p [[Ты перебрал с едой. Не надо так делать.]] end;
	if have('samobranka') and hungry >= 5 then p [[По крайней мере, ты сыт и имеешь силы продолжать. Ещё немного...]] end;
	if prival6enabled then enable('#enable6prival') end;
	end;
	way = { path {'#enable6prival', 'Дальше','longroad45'}:disable() };
}:with {
	obj {
		nam = 'enable6prival';
	    };
	};

room {
	nam = 'longroad45';
	pic = 'gfx/daynight/30_45.png';
	disp = 'Долгая дорога через горы (10:30) День 3';
	enter = function()
	hungry = 0;
	end;
	dsc = [[Почти у цели...]];
	way = { path {'Дальше','longroad46'} };
}

room {
	nam = 'longroad46';
	pic = 'gfx/daynight/30_46.png';
	disp = 'Долгая дорога через горы (12:00) День 3';
	dsc = [[Солнце печет, но еще немного...]];
	way = { path {'Дальше','longroad47'} };
}

room {
	nam = 'longroad47';
	pic = 'gfx/daynight/30_47.png';
	disp = 'Долгая дорога через горы (13:30) День 3';
	dsc = [[Почти дошел...]];
	way = { path {'Дальше','longroad48'} };
}

room {
	nam = 'longroad48';
	pic = 'gfx/daynight/30_48.png';
	disp = 'Долгая дорога через горы (15:00) День 3';
	dsc = [[Ура!..]];
	way = { path {'Дальше','village'} };
	decor = [[Приехали!]];
}