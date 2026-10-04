<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Olsson.WebApp._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">



    <div class="row">
        <div class="col-md-4">
            <h2>Transactions</h2>
            <p>
             Text 
            </p>
            <p>
                <a class="btn btn-default" href="#">Continue &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Import from Excel</h2>
            <p>
               Press the "Contrinue" button below to import from excel
            </p>
            <p>
                <a class="btn btn-default" href="~/cc/ImportfromExcel" runat="server">Contrinue &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Item 3</h2>
            <p>
               Text 
            </p>
            <p>
          <a class="btn btn-default" href="#">Continue &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
