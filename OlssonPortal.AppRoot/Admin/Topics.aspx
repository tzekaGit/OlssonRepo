<%@ Page Title ="Topics" Language="C#" AutoEventWireup="true" CodeBehind="Topics.aspx.cs" MasterPageFile="~/Site.Master" Inherits="Olsson.WebApp.Account.Topics" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit.HtmlEditor" tagprefix="cc1" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="row">
        <div class="col-md-3  left" style="overflow:scroll;">
            <ul style="padding:0; margin:0">
                <asp:PlaceHolder ID="TopicPh" runat="server" />
            </ul>
        </div>
          <div class="col-md-9 middle" style="border-left:15px solid #e8eaed; padding-top:15px; ">
                  <div class="row">
                     <div class="col-md-2">Topic ID</div>
                     <div class="col-md-6"><asp:Label ID="TopicIDLbl" runat="server" visible = "true"/></div>
                     <div class="col-md-4"></div>
                 </div>
               <div class="row">
                     
                     <div class="col-md-2">Topi Name</div>
                     <div class="col-md-6"><asp:textbox ID="TopicNameTxtBox" runat="server" width="300px"/> </div>
                     <div class="col-md-4">* <asp:RequiredFieldValidator ID="TopicNameReqVal" ControlToValidate ="TopicNameTxtBox"  Text="This field is required" ErrorMessage="*" forecolor="red" runat="server" /></div>
                 </div>
                <div class="row">
                     <div class="col-md-2">Topic Title</div>
                     <div class="col-md-6"><asp:textbox ID="TopicTitleTxtBox" runat="server"  width="300px"   color="red"/></div>
                     <div class="col-md-4">* <asp:RequiredFieldValidator ID="TopicTitleReqVal" ControlToValidate ="TopicTitleTxtBox"  Text="This field is required" ErrorMessage="*" forecolor="red" runat="server" /></div>
                 </div>

                <div class="row">
                     <div class="col-md-12">
                        <cc1:Editor 
                            ID="Editor1" 
                   
                            Height="300px"
                            runat="server"
                            style=" min-Width:400px;padding-top:15px;"  
                            ClientIDMode ="AutoID"
                            />
                        <br />
                        <asp:Button   id="btnSubmit" Text="Submit"  Runat="server" CssClass="btn btn-defaul" onclick="btnSubmit_Click" />
                        <asp:Button   id="btnNew" Text="New Topic"  Runat="server" CssClass="btn btn-defaul" UseSubmitBehavior ="false" OnClientClick ="document.location='topics?t=0';return;" />
                        <hr />
                    </div>
                </div>
      </div>
</div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="SideContent" Runat="Server">
    <h2>Instruction</h2>
    <p>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
    </p>
</asp:Content>