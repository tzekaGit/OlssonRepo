<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:asp="remove"
    xmlns:hypercontrols="remove"
    xmlns:hyper="remove"
    xmlns:ajaxToolkit="remove"
    xmlns:ajaxcontrols="remove"
    xmlns:StringFormat="urn:StringFormat"
>
  
  <xsl:output method="xml" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />
  <xsl:output cdata-section-elements="STRING"/>
  <xsl:output cdata-section-elements="SCRIPT"/>
  <xsl:output cdata-section-elements="CODE"/>
	
  <xsl:variable name="requiredImg" select="'/_2011/app_themes'" />
  <xsl:variable name="li" select="'&lt;li&gt;'" />
  <xsl:variable name="emailexpval" select="'\w+([-+.$apos]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*'" />
  <xsl:variable name="phoneexpval" select="'\(?\s*\d{3}\s*[\)\.\-]?\s*\d{3}\s*[\-\.]?\s*\d{4}'" />
  <xsl:variable name="zipexpval" select="'^\d{5}$|^\d{5}-\d{4}$'" />
  <xsl:variable name="currencyexpval" select="'^\d+(?:\.\d{0,2})?$'" />
  <xsl:variable name="datetimeexpval" select="'^(([0]?[1-9]|1[0-2])/([0-2]?[0-9]|3[0-1])/[1-2]\d{3})? ?((([0-1]?\d)|(2[0-3])):[0-5]\d)?(:[0-5]\d)? ?(AM|am|PM|pm)?$'" />
  <xsl:variable name="integerexpval" select="'^[1-9]+[0-9]*$'" />
  <xsl:variable name="numericexpval" select="'^[-+]?[0-9]\d{0,2}(\.\d{1,2})?%?$'" />
  
  <xsl:template match="/">
    <!--register controls/assembly-->

    <xsl:text disable-output-escaping="yes">
      &lt;%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %&gt;
  </xsl:text>

    <!--register start rendering form-->
		<xsl:for-each select="form">
      <br />
      
      <div class="container" Id = "FormTbl" cellpadding="1" cellspacing="1" border="1" width="100%" style="border:1px solid #eee;"  data-table="">
				  <!--Table properties -->
				  <xsl:for-each select="./properties">
					  <xsl:attribute name="style">
						  <xsl:value-of select="concat(./property[@name='style'], 'border-collapse:separate;')" />
					  </xsl:attribute>
					  <xsl:attribute name="class">
						  <xsl:value-of select="./property[@name='class']" />
					  </xsl:attribute>
            <xsl:attribute name="border">
              <xsl:value-of select="./property[@name='border']" />
            </xsl:attribute>
            <xsl:attribute name="cellpadding">
              <xsl:value-of select="./property[@name='cellpadding']" />
            </xsl:attribute>
            <xsl:attribute name="cellspacing">
              <xsl:value-of select="./property[@name='cellspacing']" />
            </xsl:attribute>
				  </xsl:for-each>
				  <!--End Table properties -->

				  <!--Start Table Rows -->
				  <xsl:for-each select="caption">
			<caption>
					  <xsl:for-each select="./properties">
							<xsl:if test="./property[@name='style']">
								<xsl:value-of select="./property[@name='style']" />
							</xsl:if>
						</xsl:for-each>
						
						<xsl:if test="./properties/property[@name='text']">
							<xsl:value-of select="./properties/property[@name='text']" />
						</xsl:if>
				</caption>
		</xsl:for-each>	
				
				<xsl:for-each select="row">
          <div class="row" data-row="">
            <!--  row properties-->
            <xsl:for-each select="./properties">
              <xsl:attribute name="style">
                <xsl:value-of select="./property[@name='style']" />
              </xsl:attribute>
              <xsl:attribute name="class">
                <xsl:value-of select="./property[@name='class']" />
              </xsl:attribute>
            </xsl:for-each>

            <xsl:for-each select="cr">
              <xsl:if test="@control='_td'">
                <div class="{@class}" style="{@style}"  data-cell="">
                  <!--Form Elements-->
                  <xsl:for-each select="element">
                    <xsl:if test="@control='text' and  @id='requiredcell'">
                      <!--<xsl:attribute name="class">required</xsl:attribute>-->
                    </xsl:if>

                    <xsl:if test="@control='span' and  @id='requiredspan'">
                      <span class="required" style="{@style}">
                        &#160;<!--add empty space-->
                      </span>
                    </xsl:if>


                    <xsl:if test="@control='image'">
                      <asp:image id="{@id}" ImageUrl="~/img/spacer.gif" Width="150" Height="1" borderwidth="0" runat="server" visible="{@visible}" AlternateText="spacer" />
                    </xsl:if>

                    <xsl:if test="@control='textbox'">
                      <asp:TextBox id="{@id}" runat="server" >
                        <xsl:for-each select="./properties">
                          <xsl:if test="./property[@name='style']">
                            <xsl:attribute name="style">
                              <!--align left if there is not any style applied-->
                              <xsl:value-of select="./property[@name='style']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='textmode']">
                            <xsl:attribute name="textmode">
                              <xsl:value-of select="./property[@name='textmode']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='text']">
                            <xsl:attribute name="text">
                              <xsl:value-of select="./property[@name='text']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='maxlength']">
                            <xsl:attribute name="maxlength">
                              <xsl:value-of select="./property[@name='maxlength']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='rows']">
                            <xsl:attribute name="rows">
                              <xsl:value-of select="./property[@name='rows']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='columns']">
                            <xsl:attribute name="columns">
                              <xsl:value-of select="./property[@name='columns']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='formatnumber']">
                            <xsl:attribute name="formatnumber">
                              <xsl:value-of select="format-number(../@text, ./property[@name='formatnumber'])" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='formatdate']">
                            <xsl:attribute name="text">
                              <xsl:value-of select="StringFormat:ToDateTimeFormat(../@text, ./property[@name='formatdate'])" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='visible']">
                            <xsl:attribute name="visible">
                              <xsl:value-of select="./property[@name='visible']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='forecolor']">
                            <xsl:attribute name="forecolor">
                              <xsl:value-of select="./property[@name='forecolor']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='onchange']">
                            <xsl:attribute name="onchange">
                              <xsl:value-of select="./property[@name='onchange']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='autocomplete']">
                            <xsl:attribute name="autocomplete">
                              <xsl:value-of select="./property[@name='autocomplete']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='readonly']">
                            <xsl:attribute name="readonly">
                              <xsl:value-of select="./property[@name='readonly']" />
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>


                        <xsl:if test="@text!=''">
                          <xsl:attribute name="text">
                            <xsl:value-of select="@text" />
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@style!=''">
                          <xsl:attribute name="style">
                            <xsl:value-of select="@style" />
                          </xsl:attribute>
                        </xsl:if>

                        <xsl:if test="@maxlength!=''">
                          <xsl:attribute name="maxlength">
                            <xsl:value-of select="@maxlength" />
                          </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="@columns!=''">
                          <xsl:attribute name="Columns">
                            <xsl:value-of select="@columns" />
                          </xsl:attribute>
                        </xsl:if>
                      </asp:TextBox>
                    </xsl:if>

                    <xsl:if test="@control='label'">
                      <asp:label id="{@id}" text="{@text}" runat="server">

                        <xsl:for-each select="./properties">
                          <xsl:if test="./property[@name='style']">
                            <xsl:attribute name="style">
                              <xsl:value-of select="./property[@name='style']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='text']">
                            <xsl:attribute name="text">
                              <xsl:value-of select="./property[@name='text']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='cssclass']">
                            <xsl:attribute name="cssClass">
                              <xsl:value-of select="./property[@name='cssclass']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='forecolor']">
                            <xsl:attribute name="forecolor">
                              <xsl:value-of select="./property[@name='forecolor']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='findreplace']">
                            <xsl:attribute name="text">
                              <xsl:call-template name="FindAndReplace">
                                <xsl:with-param name="text" select="./property[@name='text']" />
                                <xsl:with-param name="oldValue" select="','" />
                                <xsl:with-param name="newValue" select="$li" />
                              </xsl:call-template>
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>

                        <xsl:if test="@style!=''">
                          <xsl:attribute name="Style">
                            <xsl:value-of select="@style" />
                          </xsl:attribute>
                        </xsl:if>

                      </asp:label>
                    </xsl:if>

                    <xsl:if test="@control='datarowrepeater'">
                      <xsl:for-each select="listitems/listitem">

                        <xsl:call-template name="RowRepeater">
                          <xsl:with-param name="id" select="@id" />
                          <xsl:with-param name="labeltext" select="@text" />
                          <xsl:with-param name="listcontrol" select="@listcontrol" />

                        </xsl:call-template>
                      </xsl:for-each>

                      <xsl:for-each select="listitems/hyperlink">
                        <xsl:call-template name="RowRepeaterHyperlink">
                          <xsl:with-param name="id" select="@id" />
                          <xsl:with-param name="label" select="@label" />
                        </xsl:call-template>
                      </xsl:for-each>
                    </xsl:if>


                    <xsl:if test="@control='literal'">
                      <asp:literal id="{@id}" runat="server">
                        <xsl:for-each select="./properties">
                          <xsl:if test="./property[@name='text']">
                            <xsl:attribute name="text">
                              <xsl:value-of select="./property[@name='text']" />
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>

                        <xsl:if test="@text!=''">
                          <xsl:attribute name="Text">
                            <xsl:value-of select="@text" />
                          </xsl:attribute>
                        </xsl:if>
                      </asp:literal>
                    </xsl:if>

                    <xsl:if test="@control='formlabel'" >
                      <asp:label associatedcontrolid="{@associatedcontrolid}" runat="Server">
                        <xsl:for-each select="./properties">

                          <xsl:if test="./property[@name='text']">
                            <xsl:attribute name="Text">
                              <xsl:value-of select="concat(./property[@name='text'] , ': ')" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='style']">
                            <xsl:attribute name="style">
                              <xsl:value-of select="./property[@name='style']" />
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>

                        <xsl:if test="@style!=''">
                          <xsl:attribute name="style">
                            <xsl:value-of select="@style" />
                          </xsl:attribute>
                        </xsl:if>

                        <xsl:if test="@class!=''">
                          <xsl:attribute name="class">
                            <xsl:value-of select="@class" />
                          </xsl:attribute>
                        </xsl:if>

                        <xsl:if test="@text!=''">
                          <xsl:attribute name="Text">
                            <xsl:value-of select="concat(@text, ': ')" />
                          </xsl:attribute>
                        </xsl:if>
                      </asp:label>
                    </xsl:if>

                    <xsl:if test="@control='hyperlink'">
                      <asp:HyperLink id="{@id}" runat="server" Text ="{@text}">

                        <xsl:for-each select="./properties">
                          <xsl:if test="./property[@name='style']">
                            <xsl:attribute name="style">
                              <xsl:value-of select="./property[@name='style']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='text']">
                            <xsl:attribute name="Text">
                              <xsl:value-of select="./property[@name='text']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='cssclass']">
                            <xsl:attribute name="cssclass">
                              <xsl:value-of select="./property[@name='cssClass']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='imageurl']">
                            <xsl:attribute name="imageurl">
                              <xsl:value-of select="./property[@name='imageurl']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='navigateurl']">
                            <xsl:attribute name="NavigateUrl">
                              <xsl:value-of select="StringFormat:FormatHyperlink(./property[@name='navigateurl'])" />
                            </xsl:attribute>
                          </xsl:if>


                          <xsl:if test="./property[@name='target']">
                            <xsl:attribute name="Target">
                              <xsl:value-of select="./property[@name='target']" />
                            </xsl:attribute>
                          </xsl:if>



                          <xsl:if test="./property[@name='title']">
                            <xsl:attribute name="Title">
                              <xsl:value-of select="./property[@name='title']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='onclick']">
                            <xsl:attribute name="onclick">
                              <xsl:value-of select="./property[@name='onclick']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test=" ./property[@name='enabled']">
                            <xsl:attribute name="enabled">
                              <xsl:value-of select="./property[@name='enabled']" />
                            </xsl:attribute>
                          </xsl:if>
                        </xsl:for-each>

                        <xsl:if test="@text!=''">
                          <xsl:attribute name="Text">
                            <xsl:value-of select="@text" />
                          </xsl:attribute>
                        </xsl:if>
                      </asp:HyperLink>
                    </xsl:if>


                    <xsl:if test="@control='button'" >
                      <asp:Button id="{@id}" CommandName="Save"  CommandArgument="{@Id}" OnCommand = "Submit_Click"  onClick = "Submit_Click" runat="server" >

                        <xsl:for-each select="./properties">

                          <xsl:if test="./property[@name='text']">
                            <xsl:attribute name="text">
                              <xsl:value-of select="./property[@name='text']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='style']">
                            <xsl:attribute name="style">
                              <xsl:value-of select="./property[@name='style']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='cssClass']">
                            <xsl:attribute name="cssclass">
                              <xsl:value-of select="./property[@name='cssClass']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='onclientclick']">
                            <xsl:attribute name="onclientclick">
                              <xsl:value-of select="./property[@name='onclientclick']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='enabled']">
                            <xsl:attribute name="enabled">
                              <xsl:value-of select="./property[@name='enabled']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='usesubmitbehavior']">
                            <xsl:attribute name="UseSubmitBehavior">
                              <xsl:value-of select="./property[@name='usesubmitbehavior']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='causesvalidation']">
                            <xsl:attribute name="CausesValidation">
                              <xsl:value-of select="./property[@name='causesvalidation']" />
                            </xsl:attribute>
                          </xsl:if>


                        </xsl:for-each>
                        <xsl:if test="@text != ''">
                          <xsl:attribute name="text">
                            <xsl:value-of select="@text" />
                          </xsl:attribute>
                        </xsl:if>

                      </asp:Button>
                    </xsl:if>

                    <xsl:if test="@control='checkbox'">
                      <asp:Checkbox id="{@id}" runat="server">

                        <xsl:for-each select="./properties">
                          <xsl:attribute name="style">
                            <xsl:value-of select="./property[@name='style']" />
                          </xsl:attribute>

                          <xsl:attribute name="text">
                            <xsl:value-of select="./property[@name='text']" />
                          </xsl:attribute>

                          <xsl:attribute name="cssclass">
                            <xsl:value-of select="./property[@name='cssClass']" />
                          </xsl:attribute>

                          <xsl:if test="./property[@name='onclientclick']">
                            <xsl:attribute name="onclientclick">
                              <xsl:value-of select="./property[@name='onclientclick']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="enabled">
                            <xsl:value-of select="./property[@name='enabled']" />
                          </xsl:attribute>

                          <xsl:attribute name="checked">
                            <xsl:value-of select="./property[@name='checked']" />
                          </xsl:attribute>
                          <xsl:attribute name="visible">
                            <xsl:value-of select="./property[@name='visible']" />
                          </xsl:attribute>
                        </xsl:for-each>

                      </asp:Checkbox>
                    </xsl:if>

                    <xsl:if test="@control='customusstate'">
                      <hyper:US_DropDownListCtrl id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>

                        </xsl:for-each>
                      </hyper:US_DropDownListCtrl>
                    </xsl:if>

                    <xsl:if test="@control='usstate'">
                      <hyper:US_DropDownListCtrl id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>

                        </xsl:for-each>
                      </hyper:US_DropDownListCtrl>
                    </xsl:if>

                    <xsl:if test="@control='input'">
                      <input id="{@id}" type="{@type}" style="{@style}" tooltip="{@tooltip}"  runat="Server" >
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="value">
                            <xsl:value-of select="./property[@name='value']" />
                          </xsl:attribute>

                          <xsl:attribute name="src">
                            <xsl:value-of select="./property[@name='src']" />
                          </xsl:attribute>

                          <xsl:attribute name="onclick">
                            <xsl:value-of select="./property[@name='onclick']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </input>
                    </xsl:if>

                    <xsl:if test="@control='lookup'">
                      <div style="{@style}">
                        <hyper:lookup id="{@id}"  runat="Server">
                          <xsl:for-each select="./properties">

                            <xsl:attribute name="SelectedValues">
                              <xsl:value-of select="./property[@name='selectedvalues']" />
                            </xsl:attribute>

                            <xsl:if test="./property[@name='lookupfilter']">
                              <xsl:attribute name="LookupFilter">
                                <xsl:value-of select="./property[@name='lookupfilter']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:attribute name="LookUpControl">
                              <xsl:value-of select="./property[@name='lookupcontrol']" />
                            </xsl:attribute>

                            <xsl:attribute name="LookUpTextField">
                              <xsl:value-of select="./property[@name='lookuptextfield']" />
                            </xsl:attribute>

                            <xsl:attribute name="LookUpValueField">
                              <xsl:value-of select="./property[@name='lookupvaluefield']" />
                            </xsl:attribute>

                            <xsl:attribute name="TableName">
                              <xsl:value-of select="./property[@name='tablename']" />
                            </xsl:attribute>

                            <xsl:if test="./property[@name='orderby']">
                              <xsl:attribute name="OrderBy">
                                <xsl:value-of select="./property[@name='orderby']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='customconnection']">
                              <xsl:attribute name="CustomConnection">
                                <xsl:value-of select="./property[@name='customconnection']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:attribute name="ControlID">
                              <xsl:value-of select="../@id" />
                            </xsl:attribute>

                            <xsl:attribute name="FriendlyName">
                              <xsl:value-of select="../@fieldlabel" />
                            </xsl:attribute>

                            <xsl:if test="./property[@name='required']">
                              <xsl:attribute name="Required">
                                <xsl:value-of select="./property[@name='required']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='style']">
                              <xsl:attribute name="Style">
                                <xsl:value-of select="./property[@name='style']" />
                              </xsl:attribute>
                            </xsl:if>

                            <!-- Built-in properties-->
                            <xsl:if test="./property[@name='repeatcolumns']">
                              <xsl:attribute name="RepeatColumns">
                                <xsl:value-of select="./property[@name='repeatcolumns']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='repeatdirection']">
                              <xsl:attribute name="RepeatDirection">
                                <xsl:value-of select="./property[@name='repeatdirection']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='visible']">
                              <xsl:attribute name="Visible">
                                <xsl:value-of select="./property[@name='visible']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='rows']">
                              <xsl:attribute name="Rows">
                                <xsl:value-of select="./property[@name='rows']" />
                              </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="./property[@name='selectionmode']">
                              <xsl:attribute name="SelectionMode">
                                <xsl:value-of select="./property[@name='selectionmode']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='onchange']">
                              <xsl:attribute name="onChange">
                                <xsl:value-of select="./property[@name='onchange']" />
                              </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="./property[@name='cssClass']">
                              <xsl:attribute name="cssClass">
                                <xsl:value-of select="./property[@name='cssClass']" />
                              </xsl:attribute>
                            </xsl:if>

                            <!-- End Built-in properties-->

                          </xsl:for-each>
                        </hyper:lookup>
                      </div>
                    </xsl:if>

                    <xsl:if test="@control='enumerateddropdown'">
                      <hyper:eNumeratedList id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>

                          <xsl:attribute name="componentid">
                            <xsl:value-of select="./property[@name='componentid']" />
                          </xsl:attribute>

                          <xsl:attribute name="alloptiontext">
                            <xsl:value-of select="./property[@name='alloptiontext']" />
                          </xsl:attribute>

                          <xsl:attribute name="multiselect">
                            <xsl:value-of select="./property[@name='multiselect']" />
                          </xsl:attribute>

                        </xsl:for-each>
                      </hyper:eNumeratedList>
                    </xsl:if>

                    <xsl:if test="@control='employersdropdown'">
                      <hyper:EmployerList id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </hyper:EmployerList>
                    </xsl:if>

                    <xsl:if test="@control='enumeratedlistbox'">
                      <hyper:eNumeratedListBox id="{@id}" runat="Server" SelectionMode="{@selectionmode}">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>

                          <xsl:attribute name="componentid">
                            <xsl:value-of select="./property[@name='componentid']" />
                          </xsl:attribute>

                          <xsl:attribute name="alloptiontext">
                            <xsl:value-of select="./property[@name='alloptiontext']" />
                          </xsl:attribute>


                          <xsl:attribute name="selectmode">
                            <xsl:value-of select="./property[@name='selectionmode']" />
                          </xsl:attribute>
                          <xsl:attribute name="rows">
                            <xsl:value-of select="./property[@name='rows']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </hyper:eNumeratedListBox>
                    </xsl:if>

                    <xsl:if test="@control='enumeratedcheckboxlist'">
                      <hyper:eNumeratedCheckBoxList id="{@id}" runat="Server" SelectionMode="{@selectionmode}">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>

                          <xsl:attribute name="componentid">
                            <xsl:value-of select="./property[@name='componentid']" />
                          </xsl:attribute>

                          <xsl:attribute name="alloptiontext">
                            <xsl:value-of select="./property[@name='alloptiontext']" />
                          </xsl:attribute>


                          <xsl:attribute name="selectmode">
                            <xsl:value-of select="./property[@name='selectionmode']" />
                          </xsl:attribute>

                          <xsl:attribute name="rows">
                            <xsl:value-of select="./property[@name='rows']" />
                          </xsl:attribute>

                          <xsl:attribute name="repeatlayout">
                            <xsl:value-of select="./property[@name='repeatlayout']" />
                          </xsl:attribute>

                        </xsl:for-each>
                      </hyper:eNumeratedCheckBoxList>
                    </xsl:if>

                    <xsl:if test="@control='enumeratedradiobuttonlist'">
                      <hyper:eNumeratedRadioButtonList id="{@id}" runat="Server" SelectionMode="{@selectionmode}">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>

                          <xsl:attribute name="componentid">
                            <xsl:value-of select="./property[@name='componentid']" />
                          </xsl:attribute>

                          <xsl:attribute name="rows">
                            <xsl:value-of select="./property[@name='rows']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </hyper:eNumeratedRadioButtonList>
                    </xsl:if>

                    <xsl:if test="@control='customcontrol'">
                      <hyper:CustomControl id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="controlpath">
                            <xsl:value-of select="./property[@name='controlpath']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </hyper:CustomControl>
                    </xsl:if>

                    <xsl:if test="@control='encryptedemail'">
                      <hyper:EncryptedEmail id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="email">
                            <xsl:value-of select="./property[@name='email']" />
                          </xsl:attribute>
                        </xsl:for-each>
                        <xsl:if test="./property[@name='email']">
                          <xsl:attribute name="Email">
                            <xsl:value-of select="./property[@name='email']" />
                          </xsl:attribute>
                        </xsl:if>
                      </hyper:EncryptedEmail>
                    </xsl:if>

                    <xsl:if test="@control='usdropdownlist'">
                      <hyper:USDropdownList id="{@id}" runat="Server">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="selecteditemvalue">
                            <xsl:value-of select="./property[@name='selecteditemvalue']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </hyper:USDropdownList>
                    </xsl:if>

                    <xsl:if test="@control='radio'">
                      <asp:RadioButtonList id="{@id}" runat="server">

                        <xsl:for-each select="choice">
                          <asp:ListItem Value="{@value}" onclick="{@onclick}">
                            <xsl:value-of select="@text"/>
                          </asp:ListItem>
                        </xsl:for-each>
                      </asp:RadioButtonList>
                    </xsl:if>

                    <!-- End Add a checkboxlist-->
                    <xsl:if test="@control='checkboxlist'">
                      <asp:CheckBoxList  id="{@id}" runat="server" >
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="backcolor">
                            <xsl:value-of select="./property[@name='backcolor']" />
                          </xsl:attribute>
                          <xsl:attribute name="repeatcolumns">
                            <xsl:value-of select="./property[@name='repeatcolumns']" />
                          </xsl:attribute>
                          <xsl:attribute name="repeatdirection">
                            <xsl:value-of select="./property[@name='repeatdirection']" />
                          </xsl:attribute>
                          <xsl:attribute name="repeatlayout">
                            <xsl:value-of select="./property[@name='repeatlayout']" />
                          </xsl:attribute>
                          <xsl:attribute name="style">
                            <xsl:value-of select="./property[@name='style']" />
                          </xsl:attribute>
                        </xsl:for-each>

                        <xsl:call-template name="ListItemProperties">
                          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
                          <xsl:with-param name="text" select="@text" />
                          <xsl:with-param name="value" select="@value" />
                          <xsl:with-param name="itemtext" select="../@text" />
                          <xsl:with-param name="itemvalue" select="../@value" />
                        </xsl:call-template>

                      </asp:CheckBoxList>
                    </xsl:if>

                    <!-- End Add a dropdownlist-->
                    <xsl:if test="@control='dropdownlist'">
                      <asp:DropdownList  id="{@id}" runat="server" >
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="backcolor">
                            <xsl:value-of select="./property[@name='backcolor']" />
                          </xsl:attribute>
                          <xsl:attribute name="style">
                            <xsl:value-of select="./property[@name='style']" />
                          </xsl:attribute>

                        </xsl:for-each>

                        <xsl:call-template name="ListItemProperties">
                          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
                          <xsl:with-param name="text" select="@text" />
                          <xsl:with-param name="value" select="@value" />
                          <xsl:with-param name="itemtext" select="../@text" />
                          <xsl:with-param name="itemvalue" select="../@value" />
                        </xsl:call-template>

                        <!--<xsl:for-each select="listitems/listitem">
                          <asp:ListItem Value="{@value}" Text ="{@text}">
                            <xsl:for-each select="./properties">

                              <xsl:if test="./property[@name='selected']">
                                <xsl:attribute name="Selected"><xsl:value-of select="./property[@name='selected']" /></xsl:attribute>
                              </xsl:if>

                              <xsl:if test="./property[@name='onclick']">
                                <xsl:attribute name="onclick"><xsl:value-of select="./property[@name='onclick']" /></xsl:attribute>
                              </xsl:if>

                              <xsl:if test="./property[@name='style']">
                                  <xsl:attribute name="style"><xsl:value-of select="./property[@name='style']" /></xsl:attribute>
                              </xsl:if>
                              
                            </xsl:for-each>

                            <xsl:value-of select="@text"/>
                          </asp:ListItem>
                        </xsl:for-each>-->
                      </asp:DropdownList>
                    </xsl:if>

                    <!-- End Add a dropdownlist-->
                    <xsl:if test="@control='radiobuttonlist'">
                      <asp:RadioButtonList  id="{@id}" runat="server" >
                        <xsl:for-each select="./properties">
                          <xsl:if test="./property[@name='backcolor']">
                            <xsl:attribute name="backcolor">
                              <xsl:value-of select="./property[@name='backcolor']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='backcolor']">
                            <xsl:attribute name="Backcolor">
                              <xsl:value-of select="./property[@name='backcolor']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='style']">
                            <xsl:attribute name="Style">
                              <xsl:value-of select="./property[@name='style']" />
                            </xsl:attribute>
                          </xsl:if>

                          <xsl:if test="./property[@name='cssclass']">
                            <xsl:attribute name="CssClass">
                              <xsl:value-of select="./property[@name='cssclass']" />
                            </xsl:attribute>
                          </xsl:if>

                        </xsl:for-each>

                        <xsl:call-template name="ListItemProperties">
                          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
                          <xsl:with-param name="text" select="@text" />
                          <xsl:with-param name="value" select="@value" />

                        </xsl:call-template>


                        <!--<xsl:for-each select="listitems/listitem">
                          <asp:ListItem Value="{@value}" Text ="{@text}">
                            <xsl:for-each select="./properties">
                              <xsl:if test="./property[@name='selected']">
                                <xsl:attribute name="selected">
                                  <xsl:value-of select="./property[@name='selected']" />
                                </xsl:attribute>
                              </xsl:if>

                              <xsl:attribute name="onclick">
                                <xsl:value-of select="./property[@name='onclick']" />
                              </xsl:attribute>

                              <xsl:attribute name="style">
                                <xsl:value-of select="./property[@name='style']" />
                              </xsl:attribute>

                              <xsl:if test="./property[@name='text']">
                                <xsl:attribute name="Text">
                                  <xsl:value-of select="./property[@name='text']" />
                                </xsl:attribute>
                              </xsl:if>

                              <xsl:if test="./property[@name='value']">
                                <xsl:attribute name="Value">
                                  <xsl:value-of select="./property[@name='value']" />
                                </xsl:attribute>
                              </xsl:if>
                            </xsl:for-each>

                            <xsl:value-of select="@text"/>
                          </asp:ListItem>
                        </xsl:for-each>-->

                      </asp:RadioButtonList>
                    </xsl:if>

                    <xsl:if test="@control='ajaxtoolkit'">
                      <ajaxToolkit:AutoCompleteExtender
                         ID="{@id}"
                         TargetControlID = "{@targetcontrolid}"
                         ServiceMethod  = "{@servicemethod}"
                         ServicePath = "{@servicepath}"
                         MinimumPrefixLength = "{@minimumprefixlength}"
                         CompletionInterval = "{@completioninterval}"
                         EnableCaching  = "{@enablecaching}"
                         CompletionSetCount = "{@completionsetcount}"
                         runat="server"
                      />
                    </xsl:if>

                    <xsl:if test="@rangevalidator = 'true'">
                      <span style="color:brown; border: 1px solid #eee;display:inline-block; width:15px;height:15px;">
                        <asp:RangeValidator id="{@id}_rangeVal" Text="[*]"  ControlToValidate="{@id}"  runat="server">
                          <xsl:for-each select="./properties">

                            <xsl:if test="./property[@name='type']">
                              <xsl:attribute name="Type">
                                <xsl:value-of select="./property[@name='type']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='minimumvalue']">
                              <xsl:attribute name="MinimumValue">
                                <xsl:value-of select="./property[@name='minimumvalue']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='maximumvalue']">
                              <xsl:attribute name="MaximumValue">
                                <xsl:value-of select="./property[@name='maximumvalue']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='errormessage']">
                              <xsl:attribute name="ErrorMessage">
                                <xsl:value-of  select="concat(../@fieldlabel, ': ', ./property[@name='errormessage'])" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>
                          </xsl:for-each>
                        </asp:RangeValidator>
                      </span>
                    </xsl:if>

                    <xsl:if test="@control='ajaxcalendarextension'">
                      <ajaxToolkit:CalendarExtender  runat="server" ID="{@id}" TargetControlID="{@targetcontrolid}" Format="{@format}" PopupButtonID="{@popupbuttonid}">
                        <xsl:for-each select="./properties">
                          <xsl:attribute name="cssclass">
                            <xsl:value-of select="./property[@name='cssclass']" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </ajaxToolkit:CalendarExtender>
                    </xsl:if>

                    <xsl:if test="@control='ajaxwebeditor'" >
                      <ajaxcontrols:AjaxWebEditor  id="{@id}"  runat="server">
                        <xsl:for-each select="./properties">

                          <xsl:if test="./property[@name='editorwidth']">
                            <xsl:attribute name="Width">
                              <xsl:value-of select="./property[@name='editorwidth']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='editorheight']">
                            <xsl:attribute name="Height">
                              <xsl:value-of select="./property[@name='editorheight']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='editortype']">
                            <xsl:attribute name="EditorType">
                              <xsl:value-of select="./property[@name='editortype']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:if test="./property[@name='noscript']">
                            <xsl:attribute name="AllowScript">
                              <xsl:value-of select="./property[@name='noscript']" />
                            </xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="tooltip">
                            <xsl:value-of  select="concat(../@fieldlabel , ': ', ./property[@name='errormessage'])" />
                          </xsl:attribute>

                          <xsl:attribute name="style">
                            <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                          </xsl:attribute>
                        </xsl:for-each>
                      </ajaxcontrols:AjaxWebEditor>
                    </xsl:if>

                    <!-- Add Required Field Validator-->
                    <xsl:if test="@control='requiredfieldvalidator'">
                      <span style="display:block; color:brown; float:left;">
                        <asp:RequiredFieldValidator id="{@id}_2_reqVal" runat="server" cssClass="erroStyle" EnableClientScript="True" visible="{@visible}" >
                          <xsl:for-each select="./properties">
                            <xsl:attribute name="controltovalidate">
                              <xsl:value-of select="./property[@name='controltovalidate']" />
                            </xsl:attribute>
                            <xsl:attribute name="display">
                              <xsl:value-of select="./property[@name='display']" />
                            </xsl:attribute>

                            <xsl:attribute name="errormessage">
                              <xsl:value-of  select="concat(../@fieldlabel, ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="text">
                              <xsl:value-of select="'[*]'" />
                            </xsl:attribute>

                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>

                          </xsl:for-each>
                        </asp:RequiredFieldValidator>
                      </span>
                    </xsl:if>

                    <!-- Add RegularExpressionValidator Field Validator-->
                    <xsl:if test="@control='regularexpressionvalidator'">
                      <span style="color:brown; border: 1px solid #eee;display:inline-block; width:15px;height:15px;">
                        <asp:RegularExpressionValidator id="{@id}" runat="server" cssClass="erroStyle" EnableClientScript="True"  controltovalidate="{@controltovalidate}" >
                          <xsl:for-each select="./properties">
                            <xsl:if test="./property[@name='type']">

                            </xsl:if>
                            <xsl:attribute name="errormessage">
                              <xsl:value-of  select="concat(../@fieldlabel, ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="text">
                              <xsl:value-of select="./property[@name='text']" />
                            </xsl:attribute>

                            <xsl:if test="./property[@name='validationexpression']">
                              <xsl:attribute name="validationexpression">
                                <xsl:value-of select="./property[@name='validationexpression']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='emailvalidationexpression']">
                              <xsl:attribute name="ValidationExpression">
                                <xsl:value-of select="$emailexpval" />
                              </xsl:attribute>
                            </xsl:if>

                            <!--<xsl:if test="./property[@name='style']=''">
                              <xsl:attribute name="style">
                                <xsl:value-of select="'style=&quot;float:left&quot;'" />
                              </xsl:attribute>
                            </xsl:if>-->
                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>
                          </xsl:for-each>
                        </asp:RegularExpressionValidator>
                      </span>
                    </xsl:if>

                    <xsl:if test="@datatype = 'datepicker'">
                      <div style="float:left; color:brown;">
                        <ajaxToolkit:CalendarExtender  id="{@id}_DateCal"  TargetControlID="{@id}" Format="MM/dd/yyyy" PopupButtonID="{@id}_DateCalBtn"  runat="server">
                        </ajaxToolkit:CalendarExtender>
                        <asp:image id="{@id}_DateCalBtn" tooptip="Click to show calendar" style="float:left margin:5px 5px" ImageUrl="~/app_themes/img/icons/Calendar_scheduleHS.png" runat="Server" />
                      </div>
                    </xsl:if>

                    <!-- End Add Required Field Validator-->
                    <!--Validation-->
                    <!-- Add a Standard Required Field Validator-->

                    <xsl:if test="@required = 'yes'">
                      <span style="color:brown; border: 1px solid #eee;display:inline-block; width:15px;height:15px;">
                        <asp:RequiredFieldValidator id="{@id}_3_ReqVal" SetFocusOnError="true" cssClass="erroStyle" ErrorMessage="{@fieldlabel}: this field is required." display="dynamic" visible="{@visible}" text="[*]" runat="server" ControlToValidate="{@id}">
                          <xsl:for-each select="./properties">
                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ', this field is required')" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>
                          </xsl:for-each>
                        </asp:RequiredFieldValidator>
                      </span>
                    </xsl:if>

                    <xsl:if test="@required = 'true'">
                      <span style="color:brown; border: 1px solid #eee; display:inline-block; width:15px;height:15px;">
                        <asp:RequiredFieldValidator id="{@id}_1_ReqVal" SetFocusOnError="true" cssClass="erroStyle" ErrorMessage="{@fieldlabel}: this field is required."  tooltip="{@fieldlabel}" display="dynamic" visible="{@visible}" text="[*]" runat="server" ControlToValidate="{@id}">
                          <xsl:for-each select="./properties">
                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ', this field is required')" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>
                          </xsl:for-each>
                        </asp:RequiredFieldValidator>
                      </span>
                    </xsl:if>

                    <xsl:if test="@requiredlistvalidator = 'true'">
                      <span style="color:brown; border: 1px solid #eee; display:inline-block; width:15px;height:15px;">
                        <hypercontrols:ListControlValidator id="{concat(@id, 'ReqListVal')}" SetFocusOnError="true" cssClass="erroStyle" ErrorMessage="{@fieldlabel}: this field is required." display="dynamic" visible="{@visible}" text="[*]" runat="server" ControlToValidate="{@id}">
                          <xsl:for-each select="./properties">
                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ', this field is required')" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>
                          </xsl:for-each>
                        </hypercontrols:ListControlValidator>
                      </span>
                    </xsl:if>
                    <xsl:if test="@control='placeholder'">
                      <asp:PlaceHolder id="{@id}_Phl" runat="server" />
                    </xsl:if>

                    <xsl:if test="@control='customvalidatorcontrol'">

                      <span style="color:brown; border: 1px solid #eee;display:inline-block; width:15px;height:15px;">

                        <asp:CustomValidator CssClass="errorMessage" Text="[*]" id="{@id}_CustCtrlVal" ControlToValidate = "{@id}" ValidateEmptyText = "True"  ErrorMessage="{@errormessage}"  Display="Dynamic"  EnableClientScript="true" runat="server" >
                          <xsl:for-each select="./properties">
                            <xsl:if test="./property[@name='onservervalidate']">
                              <xsl:attribute name="OnServerValidate">
                                <xsl:value-of select="./property[@name='onservervalidate']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ', this field is required')" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>

                            <xsl:if test="./property[@name='errormessage']">
                              <xsl:attribute name="ErrorMssage">
                                <xsl:value-of select="./property[@name='errormessage']" />
                              </xsl:attribute>
                            </xsl:if>

                          </xsl:for-each>
                        </asp:CustomValidator>
                      </span>
                    </xsl:if>

                    <!-- Add CompareValidator Field Validator-->
                    <xsl:if test="@comparevalidator='true'">
                      <span style="color:brown; border: 1px solid #eee;display:inline-block; width:15px;height:15px;">
                        <asp:CompareValidator id="{@id}_CompVal" ControlToValidate ="{@id}" text="[*]" cssClass="erroStyle" EnableClientScript="True"  runat="server" >
                          <xsl:for-each select="./properties">

                            <xsl:if test="./property[@name='controltocompare']">
                              <xsl:attribute name="ControlToCompare">
                                <xsl:value-of select="./property[@name='controltocompare']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:attribute name="Operator">
                              <xsl:value-of select="./property[@name='operator']" />
                            </xsl:attribute>

                            <xsl:if test="./property[@name='valuetocompare']">
                              <xsl:attribute name="ValueToCompare">
                                <xsl:value-of select="./property[@name='valuetocompare']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='display']">
                              <xsl:attribute name="display">
                                <xsl:value-of select="./property[@name='display']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:if test="./property[@name='visible']">
                              <xsl:attribute name="Visible">
                                <xsl:value-of select="./property[@name='visible']" />
                              </xsl:attribute>
                            </xsl:if>

                            <xsl:attribute name="ErrorMessage">
                              <xsl:value-of  select="concat(../@fieldlabel , ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="tooltip">
                              <xsl:value-of  select="concat(../@fieldlabel , ': ', ./property[@name='errormessage'])" />
                            </xsl:attribute>

                            <xsl:attribute name="style">
                              <xsl:value-of  select="concat('cursor:help' , '; ', ./property[@name='style'])" />
                            </xsl:attribute>

                            <xsl:attribute name="Type">
                              <xsl:value-of select="./property[@name= 'type']" />
                            </xsl:attribute>

                          </xsl:for-each>
                        </asp:CompareValidator>

                      </span>
                    </xsl:if>

                    <!-- End Add a Standard Required Field Validator -->
                  </xsl:for-each>
                  <end-cell />
                </div>
              </xsl:if>
            </xsl:for-each>
            <end-row />
          </div>
        </xsl:for-each>

        <end-table />
			</div>

		</xsl:for-each>
</xsl:template>
  
  <!-- creates a repeater bullet list  -->
  <xsl:template name="RowRepeater">
      <xsl:param name="id" />
      <xsl:param name="labeltext" />
      <xsl:param name="listcontrol" />
    
      <b><asp:label  text="{$labeltext}" runat="server" /></b>
    
     
        <xsl:if test="$listcontrol='text' or $listcontrol='bulletlist'">
          <blockquote style="padding-bottom:15px; margin:0px 0px 0px 20px;">
            <hyper:FindReplace id="{$id}"  oldValue="," NewValue="{$li}" ListControl="{$listcontrol}" runat="server" />
          </blockquote>
        </xsl:if>
    
 
        <xsl:if test="$listcontrol='programlist'">
          <blockquote style="padding-bottom:15px; margin:0px 0px 0px 20px;">
            <hyper:ProgramList id="{$id}" runat="server" />
          </blockquote>
        </xsl:if>

     
  </xsl:template>

  <xsl:template name="RowRepeaterHyperlink">
    <xsl:param name="id" />
    <xsl:param name="label" />
    <b>
      <asp:label  text="{$label}" runat="server" />
    </b>

    <blockquote style="padding-bottom:15px; margin:0px 0px 0px 20px;;">
      <asp:hyperlink navigateurl ="~/jobPortal/servicesprograms/ServiceProviderDetails.aspx?PageID=796&amp;spid={$id}" id="{$id}" runat="server" />
      <br />
    </blockquote>
   
  </xsl:template>
  
  
  <xsl:template name="ShortDateFormat">
    <xsl:param name="id" />
    <xsl:param name="fieldname" />
    date picker
    <ajaxToolkit:CalendarExtender  id="{$id}_DateCal"  TargetControlID="{$id}" Format="MM/dd/yyyy" PopupButtonID="{$id}_DateCalBtn"  runat="server">
    </ajaxToolkit:CalendarExtender>
    
    <element control="ajaxcalendarextension" id="{$id}_DateCal" targetcontrolid="{$id}"  format="MM/dd/yyyy" popupbuttonid="{$id}_DateCalBtn" />
    <element control="input" type="image" id="{$id}_DateCalBtn" tooptip="Click to show calendar" style="float:left margin:5px 5px" >
      <properties>
        <property name="src">~/app_themes/img/icons/Calendar_scheduleHS.png</property>
        <property name="onclick">return false</property>
      </properties>
    </element>
    <element control="regularexpressionvalidator" id="{$id}_DateExpVal" fieldname = "{$fieldname}" controltovalidate = "{$id}">
      <properties>
        <property name="validationexpression">^\d{1,2}\/\d{1,2}\/\d{4}$</property>
        <property name="errormessage">Invalid date format (mm/dd/yyyy)</property>
        <property name="text">[*]</property>
      </properties>
    </element>
  </xsl:template>

  
  <xsl:template name="ListItemProperties">
    <xsl:param name="listitemcollection" />
    <xsl:param name="text" />
    <xsl:param name="value" />
  
    <xsl:for-each select="$listitemcollection">
      <asp:ListItem Value="{@value}" Text ="{@text}">
        <xsl:for-each select="./properties">

          <xsl:if test="./property[@name='selected']">
            <xsl:attribute name="selected">
              <xsl:value-of select="./property[@name='selected']" />
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="./property[@name='text']">
            <xsl:attribute name="Text">
              <xsl:value-of select="./property[@name='text']" />
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="./property[@name='value']">
            <xsl:attribute name="Value">
              <xsl:value-of select="./property[@name='value']" />
            </xsl:attribute>
          </xsl:if>
          
          <xsl:if test="./property[@name='enabled']">
            <xsl:attribute name="Enabled">
              <xsl:value-of select="./property[@name='enabled']" />
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
        
        <xsl:if test="@selected != ''">
            <xsl:attribute name="selected">
              <xsl:value-of select="@selected" />
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="@onclick != ''">
            <xsl:attribute name="onclick">
               <xsl:value-of select="@onclick" />
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="@style != ''">
            <xsl:attribute name="style">
              <xsl:value-of select="@style" />
            </xsl:attribute>
          </xsl:if>
          
           <xsl:if test="@text != ''">
            <xsl:attribute name="style">
              <xsl:value-of select="@style" />
            </xsl:attribute>
          </xsl:if>
          
     </asp:ListItem>
      
    </xsl:for-each>
  
    
  </xsl:template>
  
  
  <xsl:template name="javascript">
    <xsl:value-of select="'javascript:aaaa'" />
 </xsl:template>


  <xsl:template name="FindAndReplace">
    <xsl:param name="text" />
    <xsl:param name="oldValue" />
    <xsl:param name="newValue" />
    
    <xsl:choose>
      <xsl:when test="contains($text, $oldValue)">
        <xsl:value-of select="substring-before($text,$oldValue)" />
        <xsl:value-of select="$newValue" />
        
        <xsl:call-template name="FindAndReplace">
          <xsl:with-param name="text" select="substring-after($text,$oldValue)" />
          <xsl:with-param name="oldValue" select="$oldValue" />
          <xsl:with-param name="newValue" select="$newValue" />
        </xsl:call-template>
        
      </xsl:when>
      
      <xsl:otherwise>
       
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
</xsl:stylesheet>

