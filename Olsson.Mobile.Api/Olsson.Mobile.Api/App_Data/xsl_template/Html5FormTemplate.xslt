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
   
  </xsl:text>

    <!--register start rendering form-->
    <xsl:for-each select="form">

      <xsl:for-each select="row">

        <xsl:for-each select="row">

          <xsl:for-each select="element">
            <xsl:if test="@control='section'">
              <div data-expanded-icon="carat-u">
                <xsl:call-template name="ControlProperties">
                  <xsl:with-param name="element" select="../element" />
                </xsl:call-template>

                <xsl:if test="@text!=''">
                  <h1>
                    <xsl:value-of select="@text" />
                  </h1>
                </xsl:if>

                <xsl:for-each select="row">
                  <div id="{@id}" data-role="fieldcontain">
                    <xsl:for-each select="element">
                      <xsl:call-template name="Control">
                        <xsl:with-param name="Controls" select="../element" />
                      </xsl:call-template>
                    </xsl:for-each>
                  </div>

                </xsl:for-each>

                <xsl:for-each select="element">
                  <xsl:if test="@control='container'">
                    <fieldset id="{@id}-fieldset" class="bg-cust-fieldset" data-mini="true">
                      <div class="ui-grid-a ui-bar-f">
                        <xsl:call-template name="ControlProperties">
                          <xsl:with-param name="element" select="../element" />
                        </xsl:call-template>
                      </div>

                      <xsl:for-each select="row">
                        <div data-role="fieldcontain">
                          <xsl:for-each select="element">
                            <xsl:call-template name="Control">
                              <xsl:with-param name="Controls" select="../element" />
                            </xsl:call-template>
                          </xsl:for-each>
                        </div>
                      </xsl:for-each>
                    </fieldset>


                    <xsl:if test="properties/property[@name='hasclonebtn']/@value='true'">
                      <div data-mini="true">
                        <a id="btn-add-{@id}" data-form="ui-btn-up-a" data-swatch="c" data-theme="e" data-icon="plus" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-plus ui-btn-icon-left ui-btn-f" onClick="cloneMe(this,'{@id}', '{@id}-fieldset',true)">Add </a>
                      </div>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>

              </div>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>


      </xsl:for-each>



      <!-- Action Buttons -->
      <div class="ui-body">
        <div class="ui-grid-a">
          <div style="margin:0 auto; width:420px;">
            <div class="ui-block-c">
              <a href="#" rel="external" data-ajax="false" id="form-cancel" class="ui-btn ui-shadow   ui-corner-all ui-btn-inline  ui-icon-back ui-btn-icon-left  ui-btn-f ui-btn-icon-notext"  style="padding:0; margin:10px 5px;">Cancel</a>
            </div>
            <div class="ui-block-c">
              <button id="save" type="submit" data-theme="f" data-mini="true" data-inline="true"  data-icon="arrow-u" onclick="saveForm()">Save</button>
            </div>
            <div class="ui-block-c">
              <button id="saveandreturn" type="submit" data-theme="f" data-mini="true" data-inline="true"  data-icon="arrow-l" onclick="saveFormAndReturn()"><![CDATA[Save & Return]]></button>
            </div>
            <div class="ui-block-c">
              <button id="submit" type="button" data-theme="e" data-mini="true" data-inline="true" data-icon="check" onclick="submitForm()">Submit</button>
            </div>

          </div>
        </div>
      </div>

    </xsl:for-each>
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

  <xsl:template name="Control">
    <xsl:param name="Controls" />

    <xsl:if test="@control='label'">
      <p>
        <xsl:value-of select="@text" />
      </p>
    </xsl:if>

    <xsl:if test="@control='formlabel' and @text!='' and @for!='' ">
      <label  data-mini="true" for="{@for}">
        <xsl:value-of select="@text"/>
      </label>
    </xsl:if>


    <xsl:if test="@control='textbox'">
      <input type="text"  data-mini="true">
        <xsl:call-template name="ControlProperties" />
      </input>
    </xsl:if>
    <xsl:if test="@control='textarea'">
      <textarea data-mini="true">
        <xsl:call-template name="ControlProperties" />
        <xsl:value-of select="' '" />
      </textarea>
    </xsl:if>



    <xsl:if test="@control='imagecapture'">
      <fieldset id="{@id}-img-capture" class="bg-cust-fieldset" data-mini="true">
        <div data-role="fieldcontain">
          <div class="ui-block-a">
            <canvas id="{@id}" width="320" height="240" class="canvas" style="border:1px solid red;"></canvas>
          </div>
        </div>
        <div style="width:100%; clear:both; margin-top:-30px;">
          <button id="{@id}_clockwise" class="ui-btn ui-btn-c ui-btn-inline ui-icon-refresh ui-btn-icon-notext ui-corner-all" onclick="drawRotated(this, 90)" title="Rotate image">Rotate right</button>
          <button id="{@id}_delete" class="ui-btn ui-btn-c ui-btn-inline ui-icon-delete ui-btn-icon-notext ui-corner-all" onclick="deleteImage(this)" title="Delete image">Delete</button>
          <button id="{@id}_zoom"   class="ui-btn ui-btn-c ui-btn-inline ui-icon-navigation ui-btn-icon-notext ui-corner-all" onclick = "zoomImage('{@id}')" title="Zomm image">Zoom</button>
    <!-- display the annotation button when the -->
            <xsl:if test="features/property[@name='allowAnnotation' and @value='true']">
              <button id="{@id}_Annotation" class="ui-btn ui-btn-c ui-btn-inline ui-icon-edit ui-btn-icon-notext ui-corner-all annotationPopup" onclick="AnnotationImg(event,'{@id}')"  title="Annotation Image" >Annotation Popup</button>
            </xsl:if>
          
      
        </div>
        <div data-role="fieldcontain" class="imgCaptureBtnContainer">
          <a href="#popupDialog" data-rel="popup" data-position-to="window" data-transition="pop" onclick="captureImg(this)" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-camera ui-btn-icon-left ui-btn-e captureImg">Preview</a>
          <input type="file" name="FileUpload{@id}" id="FileUpload{@id}" onchange="fileSelected(this.id, this.id.replace('FileUpload',''));" accept="jpeg|gif|png" capture="camera"  class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-camera ui-btn-icon-left ui-btn-e captureImgMobile" />
        </div>
      </fieldset>
    
    

    
    </xsl:if>


    <xsl:if test="@control='flipswitch'">
      <select data-role="flipswitch"  data-mini="true">
        <xsl:call-template name="ControlProperties" />

        <xsl:call-template name="ListOptionProperties">
          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
          <xsl:with-param name="parentelementid" select="@id" />
          <xsl:with-param name="type" select="'radio'" />
        </xsl:call-template>
      </select>
    </xsl:if>


    <xsl:if test="@control='radiobuttonlist'">
      <listview data-role="controlgroup" data-mini="true" data-theme="d">
        <xsl:call-template name="ControlProperties" />

        <xsl:call-template name="ListItemProperties">
          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
          <xsl:with-param name="parentelementid" select="@id" />
          <xsl:with-param name="type" select="'radio'" />
        </xsl:call-template>
      </listview>
    </xsl:if>

    <xsl:if test="@control='dropdownlist'">
      <select name="select-native-1"   id="select-native-1" data-theme="d" data-mini="true" >
        <xsl:call-template name="ControlProperties" />

        <xsl:call-template name="ListOptionProperties">
          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
          <xsl:with-param name="parentelementid" select="@id" />

        </xsl:call-template>
      </select>
    </xsl:if>

    <xsl:if test="@control='checkboxlist'">
      <listview data-role="controlgroup" data-mini="true" data-theme="d">
        <xsl:call-template name="ControlProperties" />

        <xsl:call-template name="CheckboxItemProperties">
          <xsl:with-param name="listitemcollection" select="listitems/listitem" />
          <xsl:with-param name="parentelementid" select="@id" />
          <xsl:with-param name="type" select="'checkbox'" />
        </xsl:call-template>
      </listview>
    </xsl:if>

  </xsl:template>


  <xsl:template name="ControlProperties">
    <xsl:param name="element" />

    <xsl:if  test="@id!=''">
      <xsl:attribute name="id">
        <xsl:value-of select="@id" />
      </xsl:attribute>

      <xsl:attribute name="name">
        <xsl:value-of select="@id" />
      </xsl:attribute>
    </xsl:if>

    <xsl:if  test="@text!=''">
      <xsl:attribute name="text">
        <xsl:value-of select="@text" />
      </xsl:attribute>
    </xsl:if>


    <xsl:if  test="@for!=''">
      <xsl:attribute name="for">
        <xsl:value-of select="@for" />
      </xsl:attribute>
    </xsl:if>

    <xsl:for-each select="properties/property">
      <xsl:if test="@name='placeholder'">
        <xsl:attribute name="placeholder">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@name='readonly'">
        <xsl:attribute name="readonly">
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@name='style'">
        <xsl:attribute name="style">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@name='theme'">
        <xsl:attribute name="data-theme">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>

     <xsl:if test="@name='multiple'">
        <xsl:attribute name="multiple">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>
      
     <xsl:if test="@name='data-native-menu'">
        <xsl:attribute name="data-native-menu">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if> 
      
      <xsl:if test="@name='date'">
        <xsl:attribute name="data-role">
          <xsl:value-of select="'date'" />
        </xsl:attribute>
      </xsl:if>
      

      <xsl:if test="@name='role'">
        <xsl:attribute name="data-role">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@name='collapsed'">
        <xsl:attribute name="data-collapsed">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@name='icon'">
        <xsl:attribute name="data-collapsed-icon">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>
      
      <xsl:if test="@name='rows'">
        <xsl:attribute name="rows">
          <xsl:value-of select="@value" />
        </xsl:attribute>
      </xsl:if>
      
      <xsl:if  test="@name ='title'">
        <div class="ui-block-a">
          <h3>
            <xsl:value-of select="@value" />
          </h3>
        </div>
      </xsl:if>

      <xsl:if  test="@name = 'hasdeletebtn' and @value='true'">
        <div class="ui-block-b">
          <button id="{$element/@id}-delete" type="submit" data-theme="c" style="display: none;" data-mini="true" data-inline="true" data-icon="delete" class="dispaly-{@display} right" onclick="deleteFieldset(this)">Delete</button>
        </div>
      </xsl:if>

    </xsl:for-each>

  </xsl:template>

  <xsl:template name="ListItemProperties">
    <xsl:param name="type" />
    <xsl:param name="listitemcollection" />
    <xsl:param name="parentelementid" />



    <xsl:for-each select="$listitemcollection">
      <input type="{$type}" name="{$parentelementid}" id="{$parentelementid}-{@value}" value="{@value}" class="custom" data-mini="true">
        <xsl:for-each select="property">
          <xsl:if test="@name='selected'">
            <xsl:attribute name="selected">
              <xsl:value-of select="@value" />
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="@name='enabled'">
            <xsl:attribute name="Enabled">
              <xsl:value-of select="@value" />
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
        </xsl:for-each>
      </input>
      <label for="{$parentelementid}-{@value}">
        <xsl:value-of select="@text"/>
      </label>
    </xsl:for-each>


  </xsl:template>

  <xsl:template name="CheckboxItemProperties">
    <xsl:param name="type" />
    <xsl:param name="listitemcollection" />
    <xsl:param name="parentelementid" />



    <xsl:for-each select="$listitemcollection">
      <input type="{$type}" name="{$parentelementid}" id="{$parentelementid}-{@value}" value="{@value}" class="custom" data-mini="true">
        <xsl:for-each select="property">
          <xsl:if test="@name='selected'">
            <xsl:attribute name="selected">
              <xsl:value-of select="@value" />
            </xsl:attribute>
          </xsl:if>

          <xsl:if test="@name='enabled'">
            <xsl:attribute name="Enabled">
              <xsl:value-of select="@value" />
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
        </xsl:for-each>
      </input>
      <label for="{$parentelementid}-{@value}">
        <xsl:value-of select="@text"/>
      </label>
    </xsl:for-each>


  </xsl:template>


  <xsl:template name="ListOptionProperties">
    <xsl:param name="listitemcollection" />
    <xsl:param name="parentelementid" />

    <xsl:for-each select="$listitemcollection">
      <option value="{@value}"  >
        <xsl:if test="@selected != ''">
          <xsl:attribute name="selected">
            <xsl:value-of select="@selected" />
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@text" />
      </option>
  
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

