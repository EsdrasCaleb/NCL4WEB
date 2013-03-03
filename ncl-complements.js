//array com codigo e nome da tecla
var objectCodeNames =  {112:'F1' , 113:'F2' ,114:'F3' ,115:'F4' ,116:'F5' ,117:'F6' ,118:'F7' ,119:'F8' ,120:'F9' ,121:'F10' ,122:'F11' ,123:'F12' ,8:'BACK_SPACE' ,32:'SPACE' , 9:'TAB' ,16:'SHIFT' ,17:'CONTROL' ,18:'ALT' ,20:'CAPS_LOCK' ,33:'PAGE_UP' ,34:'PAGE_DOWN' ,35:'END' , 36:'HOME' ,19:'PAUSE_BREAK' ,42:'PRINTSCREEN' ,45:'INSERT' , 46:'DELETE' ,96:'NUMPAD0' ,97:'NUMPAD1' ,98:'NUMPAD2' ,99:'NUMPAD3' ,100:'NUMPAD4' ,101:'NUMPAD5' ,102:'NUMPAD6' ,103:'NUMPAD7' ,104:'NUMPAD8' ,105:'NUMPAD9' ,106:'NUMPAD*' ,107:'NUMPAD+' ,108:'NUMPAD,' ,109:'NUMPAD-' ,110:'NUMPAD.' ,144:'NUM_LOCK'}
//array de uso de teclas
var nclKeys = {};
var hasNclKeys = false;
var agenda = false;
var agendados = {};
var zIndex = 0;
var currentContext = 'body';
var winW, winH;


function keyPressedNCL(e){
	for(var k in nclKeys){
		if(k.indexOf('Name')<0){
			if(nclKeys[k]==e.keyCode){
				$('.started').trigger(k);
				return;
			}
		}
	}
	key = parseInt(e.keyCode);
	var focus = -1;
	nomeContext = 'body'
	var ativeFocus = $(".active .started").parent('div[focusIndex]');
	if(ativeFocus.size() <1){
		$('.active').removeClass('.active');
		$('div[focusIndex] .started').parent('div[focusIndex]:first').addClass("active");
		if($('.active').length>0){
			return;
		}
	}			
	else if(ativeFocus.size() >1 ){
		ativeFocus.slice(1).removeClass("active");
	}
	switch(key){ 
		case 37:{
			focus = ativeFocus.first().attr("moveLeft");
			break;
		}
		case 38:{
			focus = ativeFocus.first().attr("moveUp");
			break;
		}
		case 39:{
			focus = ativeFocus.first().attr("moveRight");
			break;
		}
		case 40:{
			focus = ativeFocus.first().attr("moveDown");
			break;
		}
		case 13:{
			select(ativeFocus.first().children('.started').attr('id'));
			$('*').trigger('ENTER');
			break;
		}
	}
	/*
		console.log('entrou '+focus);
		focus = parseInt(focus);
		menor =focus;
		imediatamenteMaior = focus;
		$('div[focusIndex] .started[context="'+nomeContext+'"]').parent('div[focusIndex]').each(function(){
			emteste = parseInt($(this).attr('focusIndex'));
			if(emteste<menor)
				menor = emteste
			else if(imediatamenteMaior>=emteste>focus)
				imediatamenteMaior = emteste;
		})
		if(imediatamenteMaior == focus){
			focus = menor
		}
	*/
	if($('[focusIndex='+focus+'] .started').size()>0){
		atributos = $('span.settings input.property[name="service.currentFocus"]');
		if(atributos.length>0){
			atributos.each(function(){
				set($(this).parent('span').attr('id'),focus,"service.currentFocus");
			})
		}
		else{
			if(ativeFocus)
				ativeFocus.removeClass("active");
			selecionado = $('div[focusIndex='+focus+']:first .started').parent('div[focusIndex='+focus+']');
			selecionado.addClass('active');
		}
	}		
}


function interpretaPropriedades(no){
	if(no.hasClass('settings'))
		return;
	descriptor = no.parent('.descriptor').first();
	if(descriptor){
		descriptor.children('input.descriptorParam').each(function(){
			interpretaPropriedade(no,$(this));
		});
	}
	
	no.children('input.property').each(function(){
		interpretaPropriedade(no,$(this));
	});
	if(no.children('input.property').length == 0){
		$('input.property[parent="'+no.attr('id')+'"]').each(function(){
			interpretaPropriedade(no,$(this));
		});
	}
}

function interpretaPropriedade(no,Inter){ 
	if(Inter.attr('value')){
		if(Inter.attr('name')=='bounds'){
			bounds = Inter.attr('value').split(',');//left top width height
			leftV = $.trim(bounds[0]);
			topV = $.trim(bounds[1]);
			widthV = $.trim(bounds[2]);
			heightV = $.trim(bounds[3]);
			aux = topV.indexOf("%");
			if(aux>0)
				topV = (winH*parseFloat(topV.substring(0,aux)))/100.0;
			aux = leftV.indexOf("%");
			if(aux>0)
				leftV = (winW*parseFloat(leftV.substring(0,aux)))/100.0;
			aux = widthV.indexOf("%");
			if(widthV.indexOf("%")>0)
				widthV = (winW*parseFloat(widthV.substring(0,aux)))/100.0;
			aux = heightV.indexOf("%")
			if(aux>0)
				heightV = (winH*parseFloat(heightV.substring(0,aux)))/100.0;
			no.get(0).style.left = leftV+"px";
			no.get(0).style.top = topV+"px";
			no.get(0).style.width =widthV+"px";
			no.get(0).style.height = heightV+"px";
			if(!no.attr('resize')){
				$(window).resize(function() {
		  			interpretaPropriedade(no,Inter)
				});
				no.attr('resize','true');
			}
		}
		else if(Inter.attr('name')=='size'){
			bounds = Inter.attr('value').split(',');//left top width height
			widthV = $.trim(bounds[0]);
			heightV = $.trim(bounds[1]);
			aux = widthV.indexOf("%");
			if(aux.indexOf("%")>0)
				widthV = winW*(parseFloat(widthV.substring(0,aux))/100.0);
			aux = heightV.indexOf("%")
			if(aux>0)
				heightV = winH*(parseFloat(heightV.substring(0,aux))/100.0);
			no.get(0).style.width = widthV+"px";
			no.get(0).style.height = heightV+"px";
			if(!no.attr('resize')){
				$(window).resize(function() {
		  			interpretaPropriedade(no,Inter)
				});
				no.attr('resize','true');
			}
		}
		else if(Inter.attr('name')=='location'){
			bounds = Inter.attr('value').split(',');//left top width height
			leftV = $.trim(bounds[0]);
			topV = $.trim(bounds[1]);
			aux = topV.indexOf("%");
			if(aux>0)
				topV = winH*(parseFloat(topV.substring(0,aux))/100.0);
			aux = leftV.indexOf("%");
			if(aux>0)
				leftV = winW*(parseFloat(leftV.substring(0,aux))/100.0);
			no.get(0).style.left = leftV+"px";
			no.get(0).style.top = topV+"px";
			if(!no.attr('resize')){
				$(window).resize(function() {
		  			interpretaPropriedade(no,Inter)
				});
				no.attr('resize','true');
			}
		}
		else if(Inter.attr('name')=='soundLevel'){
			no.get(0).volume = parseFloat(Inter.attr('value'));
		}
		else if(Inter.attr('name')=='transparency'){
			valor = Inter.attr('value');
			aux = valor.indexOf("%");
			if(aux>0)
				no.get(0).style.opacity = 1.0- (parseFloat(valor.substring(0,aux))/100.0);
			else
				no.get(0).style.opacity = 1.0- parseFloat(valor);
		}
		else if(Inter.attr('name')=='visible'){
			if(Inter.attr('value')=='false'){	
				no.get(0).style.visibility = 'hidden';
				no.get(0).style.display = "none";
			}
			else{
				no.get(0).style.visibility = 'visible';
				no.get(0).style.display = 'inline';
			}
		}
		else if(Inter.attr('name')=='scroll'){
			if(Inter.attr('value')=='false')			
				no.get(0).style.overflow = 'hidden';
			 if(Inter.attr('value')=='automatic')
				no.get(0).style.overflow = 'auto';
			else
				no.get(0).style.overflow = 'scroll';
		}
		else if(Inter.attr('name')=='style'){
			no.addClass(Inter.attr('value'))
		}
		else if(Inter.attr('name')=='fontColor'){
			no.get(0).style.color = Inter.attr('value');
		}
		else{
			no.get(0).style[Inter.attr('name')] = Inter.attr('value');
		}
	}
}

function tratataDescriptorInLink(id,descriptor,role,Inter){
	if($('#'+descriptor+'>#'+id).length>0)
		return;
	if(role == 'stop'){
		$('#'+id+'_'+descriptor).remove();
	}
	else if(role == 'start'){
		if($('#'+id+"_"+descriptor).length==0){		
			$('#'+id).clone().attr('id',id+"_"+descriptor).attr('mirror',id).appendTo('#'+descriptor);
			$('#'+id).bind('onEnd',function(){
				$('#'+id+'_'+descriptor).remove();
			});
			$('#'+id).bind('onAbort',function(){
				$('#'+id+'_'+descriptor).remove();
			});
			$('#'+id+"_"+descriptor).attr('state',null);
			start(id+"_"+descriptor);
		}
	}
}

function getSwitchNode(id,inter){
	if($('#'+id).attr('refer'))
		return getSwitchNode($('#'+id).attr('refer'),Inter);
	var retorno = null;
	if(inter){
		components = $('#'+inter+' >li[rule]');	
		components.each(function(index){
			if($(this).attr("rule")){
				if(window[$(this).attr("rule")]()){
					retorno = [$(this).attr("constituent"),$(this).attr("interface")];
				}
			}
				
		})
	}
	else{
		components = $('#'+id+'>li[rule]');
		components.each(function(index){
			if($(this).attr("rule")){
				if(window[$(this).attr("rule")]()){
					retorno = [$(this).attr("constituent")];
				}
			}
		})
	}
	if(retorno)
		return retorno
	else if($('#'+id+' li[default]').length>0)
		return [$('#'+id).children('li[default]').attr("default")];
	else
		null;
}

function trocaDescritor(idNo,idDescritor){
	no = $("#"+idNo)
	if(no.parent('#'+idDescritor).length>0)
		return;
	tempo =  0;
	if(no.get(0).currentTime){
		tempo = no.get(0).currentTime
		no.appendTo('#'+idDescritor);
		no.get(0).play();
		no.bind('loadedmetadata',function(){
			this.currentTime = tempo;
			no.unbind('loadedmetadata')
		});
	}
	else{
		no.appendTo('#'+idDescritor);
	}
	regiaoPai = no.parents('.region');
	if(regiaoPai.first().attr('zIndex')){
		no.css('z-index',parseInt(regiaoPai.first().attr('zIndex')) + regiaoPai.first().children('.started').length);
	}
	else{
		no.css('z-index','auto');
	}
		
}

function triggerEvento(id,Inter,evento,fromContext){
	//console.log(evento+":"+id+"."+Inter+"|"+fromContext);
	if(Inter){
		$('#'+Inter).trigger(evento,Inter);
		if(!fromContext){
			$('.port[value="'+id+'"][interface="'+Inter+'"]').each(function(){
				$(this).trigger(evento,$(this).attr('id'));
			});
			$('ul>li[component="'+id+'"][interface="'+Inter+'"]').each(function(){
				if(window[$(this).attr("rule")]()){
					otal = $(this).parent('ul');
					otal.trigger(evento,otal.attr('id'));
				}
			});
		}
	}
	else{
		$('#'+id).trigger(evento,id);
		trataInstSame(id,evento);
		if(!fromContext){
			$('.port[value="'+id+'"]').each(function(){
				$(this).trigger(evento,$(this).attr('id'));
			});
			$('ul>li[constituent="'+id+'"]').each(function(){
				otal = $(this).parent('ul');
				otal.trigger(evento,otal.attr('id'));
		
			});
		}
		$('ul>li[component="'+id+'"]').each(function(){
			if(!$(this).attr('interface')){
				otal = $(this).parent('ul');
				otal.trigger(evento,otal.attr('id'));
			}
		});
	}
}

//A ideia desta função é permitir ao nó vasio que é inst same receber todos os eventos da instancia principal
function trataInstSame(idOriginal,evento){
	estado = $('#'+idOriginal).attr('state');
	$('*[refer="'+idOriginal+'"][instance="instSame"],*[refer="'+idOriginal+'"][instance="gardSame"]').each(function(){
		if(estado)
			$(this).attr('state',estado);
		triggerEvento($(this).attr('id'),null,evento);
	});
}



function resume(id,inter,fromContext){
	if(('#'+id+'[state="paused"]').length == 0)
		return
	target = $('#'+id);
	if(target.attr('refer')&&target.attr('instance')=='instSame'){
		target.attr('state','paused');
		resume(target.attr('refer'));
		return;
	}
	target = null;
	media = document.querySelector('#'+id);
	if(media.play){
		media.play();
	}
	else if($("div#"+id).length==1){
		if(inter){	
			porta = $('#'+inter);
			resume(porta.attr('value'),porta.attr('interface'),true);
		}
		else{
			$('#'+id+'>input.port').each(function(){
				resume($(this).attr('value'),$(this).attr('interface'),true);
			});
		}
	}
	else if($('ul#'+id).length==1){
		swit = id
		if($('#'+id).attr('refer'))
			swit = $('#'+id).attr('refer');
		$("ul#"+swit+'>li').each(function(){
			pause($(this).attr('constituent'),$(this).attr('interface'),true);
		})
	}
	media = $('#'+id);
	media.attr('state','occurring');
	triggerEvento(id,inter,'onResume',fromContext);
	$('*[mirror="'+id+'"][state="occurring"]').each(function(){//start mirrors
		if(this.play){
			this.play();
		}
	});
}

function pause(id,inter,fromContext){
	if(('#'+id+'[state="occurring"]').length == 0)
		return
	target = $('#'+id);
	if(target.attr('refer')&&target.attr('instance')=='instSame'){
		target.attr('state','occurring');
		pause(target.attr('refer'));
		return;
	}
	target = null;
	media = document.querySelector('#'+id);
	if(media.pause){
		media.pause();
	}
	else if($("div#"+id).length==1){
		if(inter){	
			porta = $('#'+inter);
			pause(porta.attr('value'),porta.attr('interface'),true);
		}
		else{
			$('#'+id+'>input.port').each(function(){
				pause($(this).attr('value'),$(this).attr('interface'),true);
			});
		}
	}
	else if($('ul#'+id).length==1){
		swit = id
		if($('#'+id).attr('refer'))
			swit = $('#'+id).attr('refer');
		$("ul#"+swit+'>li').each(function(){
			pause($(this).attr('constituent'),$(this).attr('interface'),true);
		})
	}
	media = $('#'+id);
	media.attr('state','paused');
	triggerEvento(id,inter,'onPause',fromContext);
	$('*[mirror="'+id+'"][state="occurring"]').each(function(){//start mirrors
		if(this.pause){
			this.pause();
		}
	});
}

function set(id,value,Inter,fromContext){
	target = $('#'+id);
	if(target.attr('refer')&&target.attr('instance')=='instSame'){
		id = target.attr('refer');
		target = $('#'+id);
	}
	if(Inter){
		triggerEvento(id,null,'onBeginAttribution',fromContext);
		triggerEvento(id,Inter,'onBeginAttribution',fromContext);
		porepertyMedia = target.children('input.property[name="'+Inter+'"]');
		if(porepertyMedia.length ==1){// é uma midia
			porepertyMedia.attr('value',value);
			if(!target.hasClass('settings'))
				interpretaPropriedade(target,porepertyMedia);
			else{
				if(Inter == "service.currentFocus"){
					$('.active').removeClass("active");
					$('.descriptor[focusIndex="'+value+'"]').addClass('active');
				}
			}
		}
		else if($('input#'+Inter+'.port').length ==1){//é um contexto com uma porta
			porta = $('input#'+Inter+'.port');
			set(porta.attr('value'),porta.attr('interface'),true);
		}
		else if($('ul#'+id).length == 1){//trata switch
			noDeExec = getSwitchNode(id,Inter);
			if(noDeExec)		
				set(noDeExec[0],value,noDeExec[1],true);
		}
		triggerEvento(id,Inter,'onEndAttribution',fromContext);
		triggerEvento(id,null,'onEndAttribution',fromContext);
	}
	else{//é uma propriedade
		if(target.hasClass('property')){
			triggerEvento(id,null,'onBeginAttribution',fromContext);
			target.attr('value',value);
			triggerEvento(id,null,'onEndAttribution',fromContext);
		}
	}
	/*
	//trata gradSame
	$('*[refer="'+id+'"][instance="gardSame"]').each(function(){
		set(this.attr('id'),value,Inter);
	})*/
}

function select(id,Inter,fromContext){
	selecionado = $('#'+id);
	if(selecionado.attr('refer')&&selecionado.attr('instance')=='instSame'){
		selecionado = $('#'+target.attr('refer'));
		id = target.attr('refer');
	}
	if(selecionado.hasClass('started')){
		if(selecionado.parent('[focusIndex]').length >0){
			$('.active').removeClass('active');
			selecionado.parent('[focusIndex]').addClass('active');
			focus = selecionado.parent('[focusIndex]').attr('focusIndex');
			atributos = $('span.settings input.property[name="service.currentFocus"]');
			if(atributos.length>0)
			atributos.each(function(){
				set($(this).parent('span').attr('id'),focus,"service.currentFocus");
			})
			if($("div#"+id).length==1){
				if(Inter){
					triggerEvento(id,Inter,"onSelection",fromContext);
					porta = $('#'+Inter);
					select(porta.attr('value'),porta.attr('interface'),true);			
				}
				else{
					$(currentContext+'> .port').each(function(index){
						select(this.value,$(this).attr('interface'),true);
					})
				}	
			}
			if($('ul#'+id).length == 1){//trata switch
				noDeExec = getSwitchNode(id,Inter);
				if(noDeExec)		
					select(noDeExec[0],noDeExec[1],true);
			}
		}
		triggerEvento(id,null,"onSelection",fromContext);
			
	}
}

function abort(id,Inter,fromContext){
	if($('#'+id+'[state="sleeping"]').length == 1)
		return
	target = $('#'+id);
	if(target.attr('refer')&&target.attr('instance')=='instSame'){
		target.attr('state','sleeping');
		abort(target.attr('refer'));
		return;
	}
	target = null;
	var media = document.querySelector('#'+id);
	if(media.pause){
		media.pause();	
		if(media.currentTime)
			media.currentTime = 0;
		media.preload ="none";	
	}
	if($("div#"+id).length==1){
		if(Inter){
			porta = $('#'+Inter);
			abort(porta.attr('value'),porta.attr('interface'),true);			
		}
		else{
			$('.started[context="'+id+'"]').each(function(){
				abort($(this).attr('id'),null,true);
			});
			currentContext = $("div#"+id).attr('context');
			if(currentContext != 'body')
				currentContext = '#'+currentContext;
			
		}	
	}
	else if($("ul#"+id).length ==1){
		swit = id
		if($('#'+id).attr('refer'))
			swit = $('#'+id).attr('refer');
		$("ul#"+swit+'>li').each(function(){
			abort($(this).attr('constituent'),$(this).attr('interface'),true);
		})
	}
	media =  $('#'+id);
	if(media.parent('.active').length >0 && media.parent('.active').children('*[state="occurring"]').length ==0){//remove seleção
		media.parent('.active').removeClass('active');
	}
	stopImage(media,id,Inter,fromContext,"onAbort");

}

function stop(id,Inter,fromContext){
	if($('#'+id+'[state="sleeping"]').length == 1)
		return;
	target = $('#'+id);
	if(target.attr('refer')&&target.attr('instance')=='instSame'){
		target.attr('state','sleeping');
		stop(target.attr('refer'));
		return;
	}
	target = null;
	var media = document.querySelector('#'+id);
	if(media.pause){
		media.pause();	
		if(media.currentTime)
			media.currentTime = 0;
		media.preload ="none";	
	}
	if($("div#"+id).length==1){
		if(Inter){
			porta = $('#'+Inter);
			stop(porta.attr('value'),porta.attr('interface'),true);			
		}
		else{
			$('.started[context="'+id+'"]').each(function(){
				stop($(this).attr('id'),null,true);
			});
			currentContext = $("div#"+id).attr('context');
			if(currentContext != 'body')
				currentContext = '#'+currentContext;
			
		}	
	}
	else if($("ul#"+id).length ==1){
		swit = id
		if($('#'+id).attr('refer'))
			swit = $('#'+id).attr('refer');
		$("ul#"+swit+'>li[constituent]').each(function(){
			stop($(this).attr('constituent'),$(this).attr('interface'),true);
		})
	}
	media =  $('#'+id);
	if(media.parent('.active').length >0 && media.parent('.active').children('*[state="occurring"]').length ==0){//remove 
		media.parent('.active').removeClass('active');
	}
	if(media.parent('.descriptor[transOut]:first').length>0){//a implementar outras transições
		t = media.parent('.descriptor[transOut]:first').attr('transOut');
		//if(transicoes[t].type=='fade'){
			media.fadeOut(parseFloat(transicoes[t].dur.substring(0,transicoes[t].dur.length-1)*1000),function(){
				media.removeAttr('style');
				stopImage(media,id,Inter,fromContext,"onEnd");
			})
		//}
	}
	else{
		stopImage(media,id,Inter,fromContext,"onEnd");
	}
}
function stopImage(media,id,Inter,fromContext,event){
	media.removeClass("started");
	media.addClass("stoped");
	media.attr('state','sleeping');
	triggerEvento(id,Inter,event,fromContext);
	$('*[mirror="'+id+'"]').each(function(){
		stop($(this).attr('id'),null,true);
	});
	apagaAncoras(id,media.get(0).ended);
	if($('*[state="occurring"][context="'+media.attr('context')+'"]').length ==0&&!fromContext){
		//console.log('stop context'+media.attr('context'))
		if(media.attr('context') && media.attr('context') != 'body'){
			$('#'+media.attr('context')).attr('state','sleeping');
			triggerEvento(media.attr('context'),Inter,event,fromContext);
		}
		else{
			if($('.started').length==0)
				$('body').trigger(event,id);
		}
	}
	if(!fromContext){
		$('li[constituent="'+id+'"]').parent('ul[state="occurring"]').attr('state','sleeping');
	}
}

function start(id,Inter,fromContext){
	console.log('start '+id+":"+Inter)
	if($('#'+id+'[state="occurring"]').length == 1){
		return
	}
	target = $('#'+id);
	if(target.attr('refer')&&target.attr('instance')=='instSame'){
		target.attr('state','occurring');
		start(target.attr('refer'));
		return;
	}
	targer = null;
	var media = document.getElementById(id);
	if(media.play){
		media.preload ="auto";
		if(media.currentTime)
			media.currentTime = 0;
		media.play();
		if(Inter){
			inicio =  $('area#'+Inter).attr('begin');
			$('#'+id).bind('playing',function(){
				media = document.getElementById(id);
				if(media.seekable.end(0)>= parseFloat(inicio.replace('s',''))){
					media.currentTime = inicio.replace('s','');
					$('area#'+Inter).attr('started','started');
					$('#'+id).unbind('playing');
					triggerEvento(id,Inter,"onBegin",fromContext);
				}
			});
		}
	}
	media = $('#'+id);
	if($('ul#'+id).length == 1){//trata switch
		noDeExec = getSwitchNode(id,Inter);
		if(Inter)
			triggerEvento(id,Inter,"onBegin",fromContext);
		if(noDeExec)		
			start(noDeExec[0],noDeExec[1],true);
		else
			return;
	}
	if($("div#"+id).length==1){//trata contexto
		if($('#'+id).attr('refer')){
			start($('#'+id).attr('refer'),Inter,true);
		}
		else
			startContext('#'+id,Inter);
	}
	else if(media.parents('.region').length>0){
		regiaoPai = media.parents('.region');
		if(!regiaoPai.first().attr('zIndex')|| regiaoPai.length ==0){
			media.css('z-index',zIndex);
			zIndex++;
		}
		else{
			media.css('z-index',parseInt(regiaoPai.first().attr('zIndex')) + regiaoPai.first().children('.started').length);
		}
	}
	if($('.active').length ==0 &&media.parent().attr('focusIndex')!=null){//da seleção se tem focusIndex e não há selecionado
		atributos = $('span.settings input.property[name="service.currentFocus"]');
		if(atributos.length>0){
			atributos.each(function(){
				set($(this).parent('span').attr('id'),media.parent().attr('focusIndex'),"service.currentFocus");
			})
		}
		/*else{
			media.parent().addClass('active')
		}*/
	}
	if(media.parent('.descriptor[transIn]:first').length>0){
		t = media.parent('.descriptor[transIn]:first').attr('transIn');
		//if(transicoes[t].type=='fade'){
			media.fadeOut(0,function(){
				media.fadeIn(parseFloat(transicoes[t].dur.substring(0,transicoes[t].dur.length-1))*1000,function(){
					//if(media.parent('.descriptor').length>0){
						media.removeClass("stoped");
						media.addClass("started");
					//}
					interpretaPropriedades(media);
					media.attr('state','occurring');
					triggerEvento(id,null,"onBegin",fromContext);
				});
			});
		//}
	}
	else{
//		if(media.parent('.descriptor').length>0){
			media.removeClass("stoped");
			media.addClass("started");
//		}
		media.attr('state','occurring');
		triggerEvento(id,null,"onBegin",fromContext);
		interpretaPropriedades(media);
	}
	$('*[mirror="'+id+'"][state="occurring"]').each(function(){//start mirrors
		start($(this).attr('id'),null,true);
	});
	var needCheck = false;
	if(media.parent('div[explicitDur]').length>0){//Mudar
		media.attr('dur',media.parent('div').attr('explicitDur').replace('s',''));
		agendados[id] = media;
		needCheck = true;
	}
	if(media.children('input.property[explicitDur]').length>0){//Mudar?
		media.attr('dur',media.children('input.property[explicitDur]').attr('explicitDur').replace('s',''));
		agendados[id] = media;
		needCheck = true;
	}
	if(media.children('area').length >0){
		agendados[id] = media;
		needCheck = true;
		media.children('area').each(function() {
			media.attr($(this).attr('id'),'0');
		});
	}
	else{
		agendados[id] = media;
		needCheck = true;
		$('area[parent="'+id+'"]').each(function() {
			media.attr($(this).attr('id'),'0');
		});
	}
	if(needCheck&&!agenda){
		setTimeout("checkInterAnchors()",500);
		agenda = true;
	}
}

function apagaAncoras(id,ended){//ativado quando um nó é parado
	for(var k in agendados){
		if(agendados[k].attr('id') == id){
			if(ended){
				agendados[k].children('area[begin]:not([end])').each(function(){
					triggerEvento(agendados[k].attr('id'),$(this).attr('id'),"onEnd");
				});
			}
			delete agendados[k];
		}
	}
}

//função que é executada de meio em meio segundo em caso de ancoras
function checkInterAnchors(){
	var entra = false;
	for(var k in agendados){
		entra =true
		if(agendados[k].attr('state') == 'occurring'){
			if(agendados[k].attr('dur')){
				dur = parseFloat(agendados[k].attr('dur'));
				dur = dur -0.5;
				if(dur <=0)
					stop(k);
				else
					agendados[k].attr('dur',dur);
			}
			if(agendados[k]){
				time = 0
				if(agendados[k].get(0).currentTime){
					time = parseFloat(agendados[k].get(0).currentTime);
				}
				else
					time = parseFloat(agendados[k].attr(k))+0.5;
				$('area[parent="'+k+'"]').each(function() {
					id = $(this).attr('id');
					if(agendados[k].attr(id)){
						if(time>=parseFloat($(this).attr('begin')) && !$(this).attr('started')){
							$(this).attr('started','started');
							triggerEvento(k,id,"onBegin");
						}
						if($(this).attr('end')){
							if(time>=parseFloat($(this).attr('end')) && $(this).attr('started')){
								triggerEvento(k,id,"onEnd");
								$(this).removeAttr('started');
								agendados[k].removeAttr(id);
							}
							else
								agendados[k].attr(id,time);
						}
						else if($(this).attr('started')){
							agendados[k].removeAttr(id);
						}
						else{
							agendados[k].attr(id,time);
						}
					}
				});
			}
		}
	}
	if(entra)
		setTimeout("checkInterAnchors()",500);
	else{
		agenda = false;
	}
}

function startContext(id,Inter){
	currentContext = id;
	if(Inter){
		porta = $('#'+Inter);
		start(porta.attr('value'),porta.attr('interface'),true);
	}
	else{
		$(currentContext+' > .port').each(function(index){
			start(this.value,$(this).attr('interface'),true);
		})
	}
}

function iniciaDocumentoNCL(){
	$(document).keydown(keyPressedNCL);
	//linha de codigo para pegar o tamanho da janela
	$(window).resize(function() {
		  carregaTela();
	});
	carregaTela();
	//fim da linha de codigo
	$('img,vide,iframe').each(function(){$(this).addClass("stoped")});
	$('video,audio').each(function(index){
			$(this).addClass("stoped");
			var id = $(this).attr('id');
			$(this).bind('ended',{id:$(this).attr('id')},function(evt){
				//afazertestar se o descritor tem frezze
				stop($(this).attr('id'));
			});
			$(this).bind('abort',{id:$(this).attr('id')},function(evt){
				abort($(this).attr('id'));
			});
	});
	//$(document).trigger('inicio');
	startContext('body');
}
/*$(document).ready(function(){
	iniciaDocumentoNCL();
});*/

$(document).ready(function(){
	for(var k in nclKeys)
	{
		key = readCookie(k);
		if(key){
			nclKeys[k] = parseInt(key);
			if(isNaN(nclKeys[k]))
				nclKeys[k] = key;
		}
	} 
	if(!hasNclKeys||readCookie('pula') == 'true'){
		iniciaDocumentoNCL();
	}
	else{
		inciaPaginaConfig();
	}
});



//Janela inicial
function keyPressedPre(e){
	if($('.selecionadoPre').length ==1){
		$('#'+id).fadeOut(0);
		id = $('.selecionadoPre').attr('id');
		nome = objectCodeNames[e.keyCode];
		if(!nome)
		{	
			nome = e.originalEvent.keyIdentifier;
		}
		if(!nome||nome==''){
			nome = String.fromCharCode((96 <= key && key <= 105)? key-48 : key)
		}

		$('#'+id).removeClass("selecionadoPre");
		nclKeys[id] = parseInt(e.keyCode);
		nclKeys[id+'Name'] = nome; 
		$('#'+id).html(nome);
		createCookie(id,e.keyCode,7);
		createCookie(id+'Name',nome,7);

		$('#'+id).fadeIn('slow');
	}
	else{
		$('.selecionadoPre').slice(1).html("clique aqui para escolher");
		$('.selecionadoPre').slice(1).removeClass("selecionadoPre");
	}
}

function inciaPaginaConfig(){
	estilo = "width:30em;    height:85%;   position:absolute;    left:10%;    top:5%;    background:#FFF;    z-index:9900;    padding:10px;    border-radius:10px;";
	janela = '<div style="'+estilo+'" id="janela1">';
	janela += '<span style="text-align:left;">Trazido a você por Esdras Caleb (caleb@midiacom.uff.br)</span><a href="#" id="fechar" style=" padding-left:2em; text-align:right;">X Fechar</a>';
	janela += '<h4>Escolha as teclas que irão ativar os seguintes botões do controle remoto (para selecionar clique na tecla, nem todas as teclas são customizáveis):</h4>';
	estilo = 'margin-top: 1em;font-size:0.8em; border-collapse: collapse; margin-left:7%;';
	janela += '<table style="'+estilo+'" >';
	estilo = "padding: .3em; border: 1px #ccc solid; background:C3C3C3; ";
	janela += '<thead style="background: #E9E9E9;" >';
	janela += '<tr><td style="'+estilo+'">Tecla no Controle Remoto</td><td style="'+estilo+'">Tecla Mapeada</td></tr>';
	janela += '</thead>';
	janela += '<tbody>';
	janela += '<tr><td style="'+estilo+'">&larr;</td><b><td style="'+estilo+'">&#9668;</td></b></tr>';
	janela += '<tr><td style="'+estilo+'">&rarr;</td><td style="'+estilo+'">&#9658;</td></tr>';
	janela += '<tr><td style="'+estilo+'">&darr;</td><td style="'+estilo+'">&#9660;</td></tr>';
	janela += '<tr><td style="'+estilo+'">&uarr;</td><td style="'+estilo+'">&#9650;</td></tr>';
	janela += '<tr><td style="'+estilo+'">ENTER</td><td style="'+estilo+'">ENTER</td></tr>';
	estilo = "padding: .3em; border: 1px #ccc solid; ";
	for(var k in nclKeys)
	if(k.indexOf("Name")<0){
		janela += '<tr><td style="'+estilo+'">'+k+'</td><td style="'+estilo+'"><a id="'+k+'" href="#">'+nclKeys[k+'Name']+'</a></td></tr>';
	}
	janela += '</tbody>';
	janela += '</table>';
	janela += '<p>O sistema salva automaticamente suas escolhas. <br/><input type="checkbox" name="chNoMore" id="chNomore" value="noMore"> Marque aqui para não exibir mais este aviso</p>';
	janela += '</div>';
	estilo = "width:100%;    height:100%; position:absolute;    left:0;    top:0;    z-index:9000;    background-color:gray;";
	janela +='<div style="'+estilo+'" id="mascara"></div>';
	$('body').append(janela);
	$('td a').click(function (e){
		if($('.selecionadoPre').length ==0){
			id = $(this).attr('id');
			$('#'+id).fadeOut(0);
			$(this).html('Digite a tecla');
			$('#'+id).addClass('selecionadoPre');
			$('#'+id).fadeIn('slow');
		}
	})
	$('#chNomore').change(function(){
		if($(this).attr('checked'))
			createCookie('pula','true',7);
		else
			createCookie('pula','false',7);
	})
	$(document).keydown(keyPressedPre); 
	$("#fechar").click( function(){
		$(document).unbind('keydown',keyPressedPre);
		$('#janela1').remove();
		$('#mascara').remove();
		iniciaDocumentoNCL();
	});
}

//funções auxiliares
function carregaTela(){
	if (document.body && document.body.offsetWidth) {
	 winW = document.body.offsetWidth;
	 winH = document.body.offsetHeight;
	}
	if (document.compatMode=='CSS1Compat' &&
	    document.documentElement &&
	    document.documentElement.offsetWidth ) {
	 winW = document.documentElement.offsetWidth;
	 winH = document.documentElement.offsetHeight;
	}
	if (window.innerWidth && window.innerHeight) {
	 winW = window.innerWidth;
	 winH = window.innerHeight;
	}
}
function createCookie(name,value,days){
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+encodeURIComponent(value)+expires;
}

function readCookie(name){
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return decodeURIComponent(c.substring(nameEQ.length,c.length));
	}
	return null;
}
