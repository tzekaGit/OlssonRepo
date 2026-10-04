//var baseApiUrl = "https://10.1.1.53/OlssonWs";

//var baseApiUrl = "/OlssonWs";
var baseApiUrl = "";
var tokenKey = 'accessToken';
var isMobile = false;

function AjaxLoader(theme, msgtext, textvisible)
{

    var $this = $(this),
    theme = theme
    msgText = msgtext,
    textVisible = textvisible,
    textonly = false;
    html = "";
    $.mobile.loading('show', {
        text: msgText,
        textVisible: textVisible,
        theme: theme,
        textonly: textonly,
        html: html
    });
}


function getFormLinks() {
    var url = baseApiUrl + "/api/tbForm";
    var token = sessionStorage.getItem(tokenKey);

    if (!token) {
        var formLnk = '<li style="color:red; text-align:center;">Login has been expired.</li>';
        $(formLnk).insertAfter("#userFormLinks li:eq(0)");
        $.mobile.loading("hide");
        return;
    }
    var formLink=""
        $.ajax({
            url: url,
            cache: false,
            type: "GET",
            dataType: 'json',
            headers: {"Authorization":"Bearer " + token}
        })
       .done(function (data, status, jqXHR) {
           $.mobile.loading("hide");
       })
       .success(function (data, status, jqXHR) {
           buildLinkMenu(data);
           //console.log(formLink);
           return formLink;
       }).fail(function (data, status, jqXHR) {
           var formLnk = '<li style="color:red; text-align:center;">' + data.responseJSON.message + '</li>';
           $(formLnk).insertAfter("#userFormLinks li:eq(0)");
           $.mobile.loading("hide");
          // callBack(formLnk);
       })
   
}

function buildLinkMenu(data) {
        var formLnk = "";
        $.each(data, function (index, d) {
            formLnk += '<li><a href="forms.html?id=' + d.formID + '"  rel="external" data-ajax="false" class="ui-btn ui-btn-icon-right ui-icon-carat-r" >' + d.formName + '</a></li>';
        });
 
        $(formLnk).insertAfter("#userForms li:eq(1)");
        if($("#userFormLinks")){
            $(formLnk).insertAfter("#userFormLinks li:eq(0)");
        }
      
        //console.log(formLnk);
        return formLnk;
}

function signOut() {
    sessionStorage.clear();
    document.location = "login.html";
}

function documentReady() {
    $('#username').html(sessionStorage.getItem("username"));
    $('#spanYear').html(new Date().getFullYear());
}

function getLoginToken(errorTag) {

    if (!token) {
        var formLnk = '<p style="color:red; text-align:center;">Login has been expired.</p>';
        $(formLnk).insertBefore("#" + errorTag);
        $.mobile.loading("hide");

        return false;

    } else {

        return true;
    }
}

(function(b){b.support.touch="ontouchend" in document;if(!b.support.touch){return;}var c=b.ui.mouse.prototype,e=c._mouseInit,a;function d(g,h){if(g.originalEvent.touches.length>1){return;}g.preventDefault();var i=g.originalEvent.changedTouches[0],f=document.createEvent("MouseEvents");f.initMouseEvent(h,true,true,window,1,i.screenX,i.screenY,i.clientX,i.clientY,false,false,false,false,0,null);g.target.dispatchEvent(f);}c._touchStart=function(g){var f=this;if(a||!f._mouseCapture(g.originalEvent.changedTouches[0])){return;}a=true;f._touchMoved=false;d(g,"mouseover");d(g,"mousemove");d(g,"mousedown");};c._touchMove=function(f){if(!a){return;}this._touchMoved=true;d(f,"mousemove");};c._touchEnd=function(f){if(!a){return;}d(f,"mouseup");d(f,"mouseout");if(!this._touchMoved){d(f,"click");}a=false;};c._mouseInit=function(){var f=this;f.element.bind("touchstart",b.proxy(f,"_touchStart")).bind("touchmove",b.proxy(f,"_touchMove")).bind("touchend",b.proxy(f,"_touchEnd"));e.call(f);};})(jQuery);   
