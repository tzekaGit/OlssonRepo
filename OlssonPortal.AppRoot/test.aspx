<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="Content/bootstrap.css" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <style>
        .autocompleteList{border:1px solid #eee; margin:0px; padding:0px; width:300px; }
        .autocompleteList li{float:none; width:100%; clear:both; border-bottom:1px solid #eee;  list-style:none; }
        .autocompleteHighlightedItem{background:#efefef; cursor:pointer;}
        .autocompleteList li div{padding:0 5px; float:left; }
        .dd-col-1{width:20%; }
        .dd-col-2{width:40%; }
        .col1,.col2,.col3 {border:1px solid #ddd;}
        #searchDdLst{box-shadow: 10px 5px 5px #eee;}
        .ddHeader{background:#777; color:#fff;}
    </style>
    
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
             <Services>
              <asp:ServiceReference Path="~/api/portalws.asmx" />
           </Services>
         </asp:ScriptManager>

      
        <input type="text" onclick="OnTxtChange(this)"  onkeyup = "OnTxtChange(this)"  id="searchTxtBox"/>
        <div id="searchDdLst" class="container" style="visibility: visible; position: absolute; width: 400px;  z-index: 1000; border:1px solid #ddd;background:#fff;"></div>



        <hr />
     
                    <asp:TextBox ID="tbSearch" runat="server" Width="300"></asp:TextBox>
                     <cc1:AutoCompleteExtender
                            runat="server" 
                            BehaviorID="AutoCompleteEx"
                            ID="autoComplete1" 
                            TargetControlID="tbSearch"
                            ServicePath="~/api/portalws.asmx" 
                            ServiceMethod="Get_TRX_TYPES"
                            ContextKey="ID"
                            MinimumPrefixLength="0" 
                            CompletionInterval="1000"
                            EnableCaching="true"
                            CompletionSetCount="20"
                            CompletionListCssClass="autocompleteList" 
                            CompletionListHighlightedItemCssClass="autocompleteHighlightedItem"
                            DelimiterCharacters=","
                            OnClientItemSelected ="SelectMe"
                            OnClientPopulated = "DdPopulated"
                            OnClientPopulating ="DdPopulating"

                    >
   
                         <Animations>
                        <OnShow>
                            <Sequence>

                                <OpacityAction Opacity="0" />
                                <HideAction Visible="true" />


                                <ScriptAction Script="
                                    // Cache the size and setup the initial size
                                    var behavior = $find('AutoCompleteEx');
                                    if (!behavior._height) {
                                        var target = behavior.get_completionList();
                                        behavior._height = target.offsetHeight - 2;
                                        target.style.height = '0px';
                                    }" />


                                <Parallel Duration=".4">
                                    <FadeIn />
                                    <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                                </Parallel>
                            </Sequence>
                        </OnShow>
                        <OnHide>

                            <Parallel Duration=".4">
                                <FadeOut />
                                <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                            </Parallel>
                        </OnHide>
                    </Animations>
                    </cc1:AutoCompleteExtender>
 

              <asp:textbox ID="dataKeyId" runat="server" />
    </form>
    <script type="application/javascript">
        var AppPath = "/scientel"
        function SelectMe(source, e) {
            console.log(e);
            $get("<%=dataKeyId.ClientID %>").value = e.get_value();
      
            var index = $find("AutoCompleteEx")._selectIndex;
         
            if (index != -1)
                $find("AutoCompleteEx").get_element().value = $find("AutoCompleteEx").get_completionList().childNodes[index]._value;

        }


        function DdPopulating() {
   
        }
        function DdPopulated()
        {
            $(".autocompleteList li").each(function () {
                var itemText = $(this).text();
               
                $(this).html("<div class=\"dd-col-1\">" + itemText.replace(/###/g, "</div><div class=\"dd-col-2\">") + "</div>");
                // console.log($(this).html());
            });
         }

        function OnTxtChange(txtBox) {

            $("#searchDdLst").show();
            $("#searchDdLst").html("");
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=uft-8",
                url: AppPath + "/api/portalws.asmx/Get_TRX_TYPES",
                data: '{"prefixText":"' + txtBox.value + '", "count":20}',
                datatype: "json",
                success: function (dataArray) {
                    //$('#loaderDiv').hide();
                    var data = dataArray.d;

                    var str = '';
                    str += '<div class="row ddHeader">';
                    str += '<div class="col-md-2 col1">Tran Code</div>';
                    str += '<div class="col-md-6 col2">Description</div>';
                    str += '<div class="col-md-4 col3">Expense Type</div>';
                    str += "</div>";

                    $.each(data, function (index, item) {
                        str += '<div class="row">';
                        str += '<div class="col-md-2 col1" data-id="' + item.Id + '" data-trancode="' + item.TranCode + '">' + item.TranCode + '</div>';
                        str += '<div class="col-md-6 col2" data-id="' + item.Id + '" data-trancode="' + item.TranCode + '">' + item.Description + '</div>';
                        str += '<div class="col-md-4 col3" data-id="' + item.Id + '" data-trancode="' + item.TranCode + '">' + item.ExpenseType + '</div>';
                        str += "</div>";
                    });
                   
                    $("#searchDdLst").html(str);
                }
            });
        }
        $(document).on("click", "#searchDdLst", function (event) {
            divObj = $(event.target);
            $("#searchTxtBox").val(divObj.data("trancode").toString());
            $("#searchDdLst").hide();
        });
    </script>
</body>
</html>
