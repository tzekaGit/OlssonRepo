<%@ Page Title="Manage Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="Olsson.WebApp.Account.Manage" %>
<%@ Register Src="~/Admin/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>
<%@ Register assembly="Olsson.WebLibrary" namespace="Olsson.DataAccess" tagprefix="sikich" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>

    <div>
        <asp:PlaceHolder runat="server" ID="successMessage" Visible="false" ViewStateMode="Disabled">
            <p class="text-success"><%: SuccessMessage %></p>
        </asp:PlaceHolder>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="form-horizontal">
                <h4>Change your account settings</h4>
                <hr />
                <dl class="dl-horizontal">
                    <dt>Password:</dt>
                    <dd>
                        <asp:HyperLink  Text="[Change]" Visible="false" ID="ChangePassword" runat="server" />
                        <asp:HyperLink  Text="[Create]" Visible="false" ID="CreatePassword" runat="server" />
                    </dd>
                    <dt>External Logins:</dt>
                    <dd><%: LoginsCount %>
                       

                    <dt>Two-Factor Authentication:</dt>
                    <dd>
                     
                    </dd>
                </dl>
            </div>
        </div>
    </div>

</asp:Content>
