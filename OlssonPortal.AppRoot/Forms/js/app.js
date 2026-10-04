//var baseApiUrl = "https://10.1.1.53/OlssonWs";

var baseApiUrl = "https://localhost:44301";
var tokenKey = 'accessToken';

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
    var url = baseApiUrl + "/api/SEM_tbForm";
    var formLink=""
        $.ajax({
            url: url,
            async: true,
            cache: false,
            type: "Get",
        })
       .done(function (data, status, jqXHR) {
           $.mobile.loading("hide");
       })
       .success(function (data, status, jqXHR) {
           formLink = buildLinkMenu(data);
           //console.log(formLink);
           return formLink;
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
