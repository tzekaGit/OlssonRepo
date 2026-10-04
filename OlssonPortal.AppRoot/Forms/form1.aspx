<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="form1.aspx.cs" Inherits="Olsson.WebApp.Forms.form1" %>
<%@ Register Src="~/controls/XMLDbForm.ascx" TagPrefix="uc1" TagName="XMLDbForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <title>Olsson Roofing</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">

    <link href="themes/jquery.mobile.icons.min.css" rel="stylesheet" />
    <link href="themes/olssonThemes.css" rel="stylesheet" />
    <link href="themes/olssonThemes.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="//code.jquery.com/mobile/1.4.5/jquery.mobile.structure-1.4.5.min.css" />
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="//code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>

    <style>
        .dispaly-none {
            display: none;
        }

        .dispaly-block {
            display: block;
        }

        .bg-cust-fieldset {
            background: #efefef;
            padding: 15px !important;
            margin-bottom: 10px !important;
            border-radius: 10px;
        }

        .left {
            float: left !important;
        }

        .right {
            float: right;
        }

        .center {
            text-align: center;
        }

        .custom-btn-medium {
            width: 200px !important;
        }
    </style>
    <style>
        div.hasDatepicker {
            display: block;
            padding: 0;
            overflow: visible;
            margin: 8px 0;
            max-width: 340px;
        }

        .ui-datepicker {
            overflow: visible;
            margin: 0;
        }

            .ui-datepicker .ui-datepicker-header {
                position: relative;
                padding: .6em 0;
                border-bottom: 0;
                font-weight: bold;
            }

            .ui-datepicker .ui-datepicker-prev, .ui-datepicker .ui-datepicker-next {
                padding: 1px 0 1px 2px;
                position: absolute;
                top: .6em;
                margin-top: 0;
                text-indent: -9999px;
            }

            .ui-datepicker .ui-datepicker-prev {
                left: 9px;
            }

            .ui-datepicker .ui-datepicker-next {
                right: 2px;
            }

            .ui-datepicker .ui-datepicker-title {
                margin: 0 2.3em;
                line-height: 1.8em;
                text-align: center;
            }

                .ui-datepicker .ui-datepicker-title select {
                    font-size: 1em;
                    margin: 1px 0;
                }

            .ui-datepicker select.ui-datepicker-month-year {
                width: 100%;
            }

            .ui-datepicker select.ui-datepicker-month,
            .ui-datepicker select.ui-datepicker-year {
                width: 49%;
            }

            .ui-datepicker table {
                width: 100%;
                border-collapse: collapse;
                margin: 0;
            }

            .ui-datepicker td {
                border-width: 1px;
                padding: 0;
                text-align: center;
            }

                .ui-datepicker td span, .ui-datepicker td a {
                    display: block;
                    padding: .2em 0;
                    font-weight: bold;
                    margin: 0;
                    border-width: 0;
                    text-align: center;
                    text-decoration: none;
                }

        .ui-datepicker-calendar th {
            padding-top: .4em;
            padding-bottom: .4em;
        }

            .ui-datepicker-calendar th span, .ui-datepicker-calendar span.ui-state-default {
                opacity: .7;
            }

        .ui-datepicker-calendar td a {
            padding: .6em .5em;
        }
    </style>



   
    <script>
    var indexChar = "-";
    var iCnt = 1

    $(document).ready(function () {
        $("#btn-header-prev").attr("href", "forms.html?id=" + $.url('?id'));
     
        $("#formId").val($.url('?id'))
        $("#rowID").val($.url('?row'));

        var $result = $('#Result');

        //load form from API
        loadForm()
        getFormLinks();
    })


    function cloneMe(inrtBtn, id, objToClone) {

        var oldListName = $("#" + objToClone + "   input[type='radio']").attr("name");


        var $clone = $("#" + objToClone)
            .clone(true, true)
            .attr('id', objToClone + indexChar + iCnt);


        $clone.find('input:radio').unbind();

        $clone.find('input:radio').each(function () {
            $(this).attr("checked", false).checkboxradio("refresh");
            $(this).unbind();
            $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
            $(this).attr("name", $(this).attr("name") + indexChar + iCnt).checkboxradio("refresh");
        });

        $clone.find('input:checkbox').unbind();

        $clone.find('input:checkbox').each(function () {
            $(this).attr("checked", false).checkboxradio("refresh");
            $(this).unbind();
            $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
            $(this).attr("name", $(this).attr("name") + indexChar + iCnt).checkboxradio("refresh");
        });


       // $clone.find('h3').append("-" + $("#" + objToClone).length);

        $clone.find('input:text').each(function () {
            $(this).unbind();
            $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
            $(this).attr("name", $(this).attr("name") + indexChar + iCnt)
            $(this).val("");
        });

        //display the delete button if present
        if ($clone.find("#" + id + "-delete")) {
            $clone.find("#" + id + "-delete").css("display", "block");
        }
        //change label :for
        $clone.find("label").each(function () {
            var $rad = $(this);
            $rad.attr("for", $rad.attr("for") + indexChar + iCnt);
        });

        $clone.find("listview").unbind();
        $clone.find("listview").trigger("create");

        var $parent = $(inrtBtn).parent();
        var cloneHtml = '<fieldset id="' + id + '-placeholder-"' + iCnt + ' class="bg-cust-fieldset"  data-mini="true">' + $clone.html() + '</fieldset>'
        //insert clone before the add button
        $(cloneHtml).insertBefore($parent).trigger("create");
        iCnt += 1;
    }
       $("form").submit(function (event) {
                var postArray = JSON.stringify($(this).serializeArray());
                console.log(postArray);
                event.preventDefault();
       });

        //load  saved data on hte form
       function loadForm(rowId) {
           if ($.url('?row') == null && rowId==null) {
               return;
           } else if($.url('?row') != null) {
               rowId = $.url('?row')
           }
           //display the ajax loader
           AjaxLoader("a", "Please Wait", false);

           var uri = baseApiUrl + '/api/tbFormDataElements/' + rowId;
           //console.log(uri);
           // console.log(data);

           //var token = sessionStorage.getItem(tokenKey);
           //console.log(tokenKey, token);
           //var headers = {};
           //if (token) {
           //    headers.Authorization = 'Bearer ' + token;
           //}
           // console.log(data);
           $.ajax({
               url: uri,
               async: true,
               cache: false,
               type: "GET",
           })
           .done(function (data, status, jqXHR) {
               msg = "Done";

           })
           .success(function (data, status, jqXHR) {
               console.log("LOAD");
               $.each(data, function (index, data) {
                   if ($("#" + data.fieldName)) {
                       console.log(data.fieldName, data.fieldValue, $("#" + data.fieldName).prop('nodeName'));
                       if ($("#" + data.fieldName).prop('nodeName') == "SELECT")
                       {
                           $("#" + data.fieldName).val(data.fieldValue).change();
                       } else if ($("#" + data.fieldName).prop('nodeName') == "LISTVIEW") {
                           $('input:radio[name="' + data.fieldName + '"]').filter('[value="' + data.fieldValue + '"]').prop('checked', true).checkboxradio('refresh');;
                           $('input:checkbox[name="' + data.fieldName + '"]').filter('[value="' + data.fieldValue + '"]').prop('checked', true).checkboxradio('refresh');;
                       } else {
                           $("#" + data.fieldName).val(data.fieldValue);
                       }
                   
                   }

               });

               $.mobile.loading("hide");

           })
           .fail(function (jqXHR, textStatus, err) {
               var error = $.parseJSON(jqXHR.responseText);
               msg = "Error: The server responded with the following error (" + err + ") " + error.message;
               console.log(msg);
               $.mobile.loading("hide");
           })

           //hide Ajax loader


       };

        //post data to the API
       function submitForm(event) {

           //display the ajax loader
           AjaxLoader("a", "Please Wait", false);

           var uri = baseApiUrl + '/api/tbFormDataElements';
           var rowId = $("#rowID").val();
           if (rowId != "") {
               uri = baseApiUrl + '/api/tbFormDataElements?id=' + rowId;
           };
           console.log(uri);

           var data = JSON.stringify($("form").serializeArray());
           data = eval(data);
           console.log(data);

           //var token = sessionStorage.getItem(tokenKey);
           //console.log(tokenKey, token);
           //var headers = {};
           //if (token) {
           //    headers.Authorization = 'Bearer ' + token;
           //}
          // console.log(data);
            $.ajax({
                url: uri,
                async: true,
                cache: false,
                 data: {'': data },
                type: "Post",
            })
            .done(function (data, status, jqXHR) {
                msg = "Done";
         
            })
            .success(function (data, status, jqXHR) {
                console.log("SUBMIT");
                $.each(data, function (index, data) {
                   
                    if ($("#" + data.fieldName)) {
                        console.log(data.fieldName, data.fieldValue, $("#" + data.fieldName).prop('nodeName'));
                        $("#" + data.fieldName).val(data.fieldValue);
                    }

                });

                if (data.length >0) {
                    $("#rowID").val(data[0].parentRowID);
                }
                $.mobile.loading("hide");

            })
            .fail(function (jqXHR, textStatus, err) {
                var error = $.parseJSON(jqXHR.responseText);
                msg = "Error: The server responded with the following error (" + err + ") " + error.message;
                console.log(msg);
                $.mobile.loading("hide");
            })

           //hide Ajax loader


       };


       function deleteFieldset(btn) {
            if (confirm("Are you sure that you want to delete the selected phone?")) {
                $(btn).closest("fieldset").remove();
            }
        }
    </script>

    <script type="text/javascript">
        // Full tutorial on
        var vidObj = null;
        var context;
        var canvas = null;
        var navigator;

        errCallBack = function (error) {	// Video Error Handler
            console.log("Video  error: ", error.code);
        };

        //Attach Click event with camOnButton
        function captureImg(thisCanvas) {
            vidObj = document.getElementById("videoEle");
            canvas = document.getElementById(thisCanvas);
            context = canvas.getContext("2d");


            // check web camera support on clicking camOnButton
            if (navigator.getUserMedia) { // Standard
                navigator.getUserMedia({ "video": true }, function (stream) {
                    vidObj.src = stream;
                    vidObj.play();
                }, errCallBack);
            } else if (navigator.webkitGetUserMedia) { // For  WebKit
                navigator.webkitGetUserMedia({ "video": true }, function (stream) {
                    vidObj.src = window.webkitURL.createObjectURL(stream);
                    vidObj.play();
                }, errCallBack);
            }
            else if (navigator.mozGetUserMedia) { // For Firefox
                navigator.mozGetUserMedia({ "video": true }, function (stream) {
                    vidObj.src = window.URL.createObjectURL(stream);
                    vidObj.play();
                }, errCallBack);
            }
        }
        // Takes a snapshot of the video
        function snap() {
            context.drawImage(vidObj, 0, 0, 640, 480);
            //vidObj.pause();
            //vidObj = null;
        }

    </script>


    <script src="libs/jqm/datePickUp.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:XMLDbForm runat="server" ID="XMLDbForm" />

       <div style=" width:600px; float:none; display:block; text-align:center;">
            <input type="hidden" id="formId" name="formId" value="1" />
            <input type="hidden" id="rowID" name="rowID" value="" />
        </div>

      <div data-role="popup" id="popupDialog" data-overlay-theme="b" data-theme="b" data-dismissible="false" style="max-width:660px;">
            <div data-role="header" data-theme="a">
                <h1>Image Preview</h1>
            </div>
            <div role="main" class="ui-content">
                <video id="videoEle" width="640" height="480" autoplay></video>
                <a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back">Cancel</a>
                <a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back" data-transition="flow" onclick="snap()">Capture</a>
            </div>
        </div>

        <div class="row" style="background:#fff;">
            <div class="col-lg-12">
                <footer>
                    <p style="text-align:right;">&copy; 2016 - Scientel Wireless CC Poirtal</p>
                </footer>
            </div>
        </div>



        <script>

            function ConfirmOnDelete() {
                if (confirm("Are you sure that you want to delete"))
                {
                    return true
                } else {
                    return false
                }
            }
        </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SideContent" runat="server">
</asp:Content>
