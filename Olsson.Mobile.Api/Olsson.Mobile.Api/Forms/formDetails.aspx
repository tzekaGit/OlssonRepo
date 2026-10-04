<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="formDetails.aspx.cs" Inherits="Olsson.WebApp.Forms.formDetails" %>

<%@ Register Src="~/controls/XMLDbForm.ascx" TagPrefix="uc1" TagName="XMLDbForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContentPlaceHolder" runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="-1">
    <link href="../Content/formDetails/styles.css" rel="stylesheet" />

     <link rel="stylesheet" href="js/jquery/jquery.mobile.structure-1.4.5.min.css" />
    <link href="themes/jquery.mobile.icons.min.css" rel="stylesheet" />
    <link href="themes/olssonThemes.css" rel="stylesheet" />
    <link href="themes/olssonThemes.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="js/jquery/jquery.mobile.structure-1.4.5.min.css" />
    <script src="js/jquery/jquery-1.11.1.min.js"></script>
    <script src="js/jquery/jquery-u-1.11.4.js"></script>
    <script src="js/jquery/jquery.validate.min.1.7.js"></script>

    <script src="js/jquery/jquery.mobile-1.4.5.min.js"></script>
    <script src="libs/jqm/url.min.js"></script>
    <script src="js/app.js"></script>
    <script src="js/scripts/formDetails.js"></script>
    <script src="libs/jqm/datePickUp.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <uc1:XMLDbForm runat="server" ID="XMLDbForm" />

    <div style="width: 600px; float: none; display: block; text-align: center;">
        <input type="hidden" id="formId" name="formId" value="1" />
        <input type="hidden" id="rowID" name="rowID" value="" />
    </div>

    <div data-role="popup" id="popupDialog" data-overlay-theme="b" data-theme="b" data-dismissible="false" style="max-width: 660px;">
        <a href="#" data-rel="back" data-role="button" data-theme="d" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
        <div data-role="header" data-theme="a">
            <h1>Image Preview</h1>
        </div>
        <div role="main" class="ui-content">
            <video id="videoEle" width="640" height="480" autoplay></video>
            <a href="#" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-b" data-rel="back" data-transition="flow" onclick="snap(w, h)">Capture</a>
        </div>
    </div>

    <div data-role="popup" id="formSubmitDialog" data-overlay-theme="b" data-theme="b" data-dismissible="false" style="max-width: 660px;">
        <a href="#" data-rel="back" data-role="button" data-theme="d" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
        <div data-role="header" data-theme="a">
            <h1>Form Processing</h1>
        </div>
        <div role="main" class="ui-content">
            <ul>
            </ul>
        </div>
    </div>
    <div data-role="popup" id="popupPhotoPortrait" class="photopopup" data-overlay-theme="a" data-corners="false" data-tolerance="30,15">
        <a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>
        <img src="#" id="zoomImg" style="width:1000px"/>
    </div>


    <script>


        function ConfirmOnDelete() {
            if (confirm("Are you sure that you want to delete")) {
                return true
            } else {
                return false
            }
        }



    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="SideContent" runat="server">
</asp:Content>
