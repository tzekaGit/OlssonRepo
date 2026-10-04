
var indexChar = "-";
var iCnt = 1
var DocumentID = "#DocumentID";
//default thumbnail dimentions
var w = 320;
var h = 240;
var containers = new Array();
var token = sessionStorage.getItem(tokenKey);
var formIsPosted = false;


AjaxLoader("a", "Please Wait", false);

$(document).ready(function () {
    if (getLoginToken("validationMsg") == false) {
        $("#dynamicForm").hide();
        return;
    }
    $("#btn-header-prev").attr("href", "forms.html?id=" + $.url('?id'));

    $("#formId").val($.url('?id'))
    $("#rowID").val($.url('?row'));
    $("#formLnk").attr("href", "forms.html?id=" + $.url('?id'))
    var $result = $('#Result');
    $("#form-cancel").attr("href", "forms.html?id=" + $.url('?id'));

    //check the device compability
    if (isMobile() == true) {

        $(".captureImgMobile").each(function () {
            $(this).show();
        })
        $(".captureImg").each(function () {
            $(this).hide();
        })


    } else {
        $(".captureImgMobile").each(function () {
            $(this).show();
        })
        $(".captureImg").each(function () {
            $(this).show();
        })
    }


    loadForm()

    getFormLinks();
    documentReady();


    $('#dynamicForm').validate({ // initialize the plugin
        rules:
            {
                CompanyName: { required: true }
            },
        messages: {
            CompanyName: { required: "CompanyName is required" }
        },


        errorPlacement: function (error, element) {
            error.insertAfter(element.parent());
        },
        submitHandler: function (form) { // for demo
            //console.log("form is valid");
            return false; // for demo
        },
        invalidHandler: function (event, validator) {
            // console.log("form is invalid");
            if (formIsPosted = false) {
                submitForm();
                formIsPosted = true;
            }

            return false;
        }

    });



})

function cloneMe(inrtBtn, id, objToClone, fromWeb) {

    var oldListName = $("#" + objToClone + "   input[type='radio']").attr("name");

    if (containers[id] && fromWeb == true) {
        iCnt = containers[id] + 1;
        containers[id] = iCnt;
    }

    var $clone = $("#" + objToClone)
        .clone(true, true)
        .attr('id', objToClone + indexChar + iCnt);


    $clone.find('input:radio').unbind();
    $clone.find('input:radio').trigger("create");
    $clone.find('input:radio :checked').removeAttr('checked');
    $clone.find('input:radio').each(function () {

        $(this).attr("checked", false).checkboxradio("refresh");
        $(this).unbind();
        $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
        $(this).attr("name", $(this).attr("name") + indexChar + iCnt).checkboxradio("refresh");
    });

    $clone.find('input:checkbox').unbind();
    $clone.find('input:checkbox').trigger("create");
    $clone.find('input:checkbox :checked').removeAttr('checked');
    $clone.find('input:checkbox').each(function () {
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

    $clone.find('input:file').each(function () {
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

    //change label :for
    $clone.find("canvas").each(function () {
        $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
    });

    $clone.find("textarea").each(function () {
        $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
        $(this).attr("name", $(this).attr("name") + indexChar + iCnt);
    });

    $clone.find("div").each(function () {
        if ($(this).prop("id") == true) {
            $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
            $(this).attr("name", $(this).attr("name") + indexChar + iCnt);
        }
    });

    //$clone.find('select').unbind();

    $clone.find('select').each(function () {

        var elId = $(this).attr("id");
        $(this).unbind();
        $(this).attr("id", $(this).attr("id") + indexChar + iCnt);
        $(this).attr("name", $(this).attr("name") + indexChar + iCnt);
        $(this).val("");

        if ($(this).prop('multiple') == true) {
            $(this).parent().parent().find("a").remove()
            $(this).parent().parent().find("div#" + elId + "-listbox-placeholder").remove()

        } else if ($(this).data("role") == "flipswitch") {
            element = $(this).parent();
            element.find("a").remove();
            element.find("span").remove();

            element.removeAttr("id");
            element.removeClass();


            //$(this).remove();
        } else {
            var element = $(this).parent().parent();
            element.find("span").remove();
            $clone.find("div#" + elId + "-button").removeClass();
            $clone.find("div#" + elId + "-button").removeAttr("id");


        }

    });


    $clone.find("listview").unbind();
    $clone.find("listview").trigger("create");

    var $parent = $(inrtBtn).parent();


    //console.log("iCnt=" + iCnt);

    var cloneHtml = '<fieldset id="' + id + '-placeholder-' + iCnt + '" class="bg-cust-fieldset"  data-mini="true">' + $clone.html() + '</fieldset>'

    //insert clone before the add button
    $(cloneHtml).insertBefore($parent).trigger("create");

    //add index on dublicated sections
    $('#' + id + '-placeholder-' + iCnt + ' h3').append('<span style="border:1px solid #000; padding: 0 5px; margin-left:5px;">' + $('fieldset[id^="' + id + '-placeholder"]').length + '</span>').show();
    iCnt += 1;
}

function loadFormSections(rowId, callBack) {
    console.log("ImageUpload:", rowId);
    var uri = baseApiUrl + "/api/ImageUpload/" + rowId;
    // console.log(uri);
    $.ajax({
        url: uri,
        async: true,
        cache: false,
        headers: { 'Authorization': 'Bearer ' + token },
        type: "GET",
    })
    .done(function (data, status, jqXHR) {
        msg = "Done";

    })
    .success(function (data, status, jqXHR) {
        //console.log("loadFormSections:", data);
        $.each(data, function (index, data) {
            var sectionId = data.sectionID;
            var containerId = data.containerID;
            var containerFiledset = data.containerName + "-fieldset";
            var inrtBtn = $("#btn-add-" + data.containerName);

            iCnt = containerId;
            //console.log("containerid=", containerId, data.containerName, containerFiledset)
            containers[data.containerName] = containerId;
            // console.log("containerName:", data.containerName]);
            cloneMe(inrtBtn, data.containerName, containerFiledset);
        });
        callBack(true);

        iCnt = 1;
    })
    .fail(function (jqXHR, textStatus, err) {
        callBack(false);
    })
}

//load  saved data on the form
function loadForm(rowId) {
    if ($.url('?row') == null && rowId == null) {
        return;
    } else if ($.url('?row') != null) {
        rowId = $.url('?row');


        loadFormSections(rowId, function (formIsLoaded) {
            if (formIsLoaded == true) {
                loadFormData(rowId, function (completed) {
                    console.log("hide the spiner, completed: " + completed);
                    $.mobile.loading("hide");
                });
                //console.log("form starts Loading ");
            }
        });
    }
};

function loadFormData(rowId, callBack) {
    //display the ajax loader
    AjaxLoader("a", "Please Wait", false);

    var uri = baseApiUrl + '/api/tbFormDataElements/' + rowId;

    $.ajax({
        url: uri,
        async: true,
        cache: false,
        headers: { 'Authorization': 'Bearer ' + token },
        type: "GET",
    })
    .done(function (data, status, jqXHR) {

    })
    .success(function (allData, status, jqXHR) {
        data = allData.formDataElement;
        adminMsg = allData.adminMessage;
        images = allData.tbFormDataElementImage;

        $("#adminMsg").html(adminMsg);
        //console.log("length", data.length);

        $.each(data, function (index, rowData) {
            //console.log(index, ")", rowData.fieldName, rowData.fieldValue, $("#" + rowData.fieldName).prop('nodeName'));
            if ($("#" + rowData.fieldName)) {

                if ($("#" + rowData.fieldName).prop('nodeName') == "SELECT") {
                    // console.log("attr:", rowData.fieldName,  $("#" + rowData.fieldName).attr('multiple'), $("#" + rowData.fieldName).prop('multiple'));

                    if ($("#" + rowData.fieldName).prop('multiple') == true) {
                        //console.log("multiple:" , rowData.fieldName, rowData.fieldValue);
                        var selValues = rowData.fieldValue.split(",");
                        $("select#" + rowData.fieldName).val(selValues);

                    } else {
                        //console.log("single" , rowData.fieldName, rowData.fieldValue);
                        $("#" + rowData.fieldName + " option[value='" + rowData.fieldValue + "']").prop('selected', true).trigger('change')
                    }


                    // lists
                } else if ($("#" + rowData.fieldName).prop('nodeName') == "LISTVIEW") {

                    $('input:radio[name="' + rowData.fieldName + '"]').filter('[value="' + rowData.fieldValue + '"]').prop('checked', true).checkboxradio('refresh');

                    var selValues = rowData.fieldValue.split(",");
                    $("#" + rowData.fieldName + " input:checkbox").each(function () {
                        $(this).prop("checked", ($.inArray($(this).val(), selValues) != -1)).checkboxradio('refresh');
                    });


                    //Canvas
                } else if ($("#" + rowData.fieldName).prop('nodeName') == "CANVAS") {
                    // console.log("loading..")
                    loadImage(rowData.fieldName, rowData.fieldValue, images, function (imageIsLoaded) {

                    });


                    // cloned list
                } else if ($("#" + rowData.fieldName).prop("type") == null) {
                    //checkbox list
                    var selectedValues = rowData.fieldValue.split(",");
                    $('form').find(':checkbox[name^="' + rowData.fieldName + '"]').each(function () {
                        $(this).prop("checked", ($.inArray($(this).val(), selectedValues) != -1)).checkboxradio('refresh');
                    });

                    //cloned radiobutton list
                    $('input:radio[name="' + rowData.fieldName + '"]').filter('[value="' + rowData.fieldValue + '"]').prop('checked', true).checkboxradio('refresh');

                } else {
                    $("#" + rowData.fieldName).val(rowData.fieldValue);

                }

            }


        });

        $("h2:first").html($("#DocumentTitle:first").val());
        $("select").selectmenu().selectmenu("refresh");
        //need to refresh the selection of dynamic controlls

        if (callBack) {
            callBack(true);
        }

    })
    .fail(function (jqXHR, textStatus, err) {
        var error = $.parseJSON(jqXHR.responseText);
        msg = "Error: The server responded with the following error (" + err + ") " + error.message;
        //console.log(msg);
        if (callBack) {
            callback(false);
        }
    })

}

//post data to the API
function saveForm(event, saveCallBack) {

    submitFormData(false, function (callBack) {
        setTimeout(function () {
            $("#formSubmitDialog").popup("close");
            $.mobile.loading("hide");

            if (saveCallBack) {
                saveCallBack();
            }
        }, 1000);

    });

    // event.preventDefault();
}

//post data to the API
function saveFormAndReturn(event) {

    submitFormData(false, function (callBack) {
        //wait a sec to close the popup
        console.log(callBack);
        setTimeout(function () {
            $("#formSubmitDialog").popup("close");
            $.mobile.loading("hide");
        }, 1000);

        //redirect to the form page
        //console.log(callBack);
        if (callBack) {
            document.location = "forms.html?id=" + $.url('?id');
        }
    });
    // event.preventDefault();
}

function submitForm(event) {
    if (confirm("Are you sure that you want to submit the form? Once the form is submitted, you will not be able to make further changes.")) {


        submitFormData(true, function (callBack) {
            //wait a sec to close the popup
            console.log(callBack);
            setTimeout(function () {
                $("#formSubmitDialog").popup("close");
                $.mobile.loading("hide");
            }, 1000);

            //redirect to the form page                    
            if (callBack == true) {
                document.location = "forms.html?id=" + $.url('?id');
            }
        });

    }
    // event.preventDefault();
}
function submitFormData(submitData, callBack) {
    $("#formSubmitDialog").data("transition", "flip")
    $("#formSubmitDialog ul").html("");
    $("#formSubmitDialog ul").append("<li>Start Form Processing....</li>")
    $("#formSubmitDialog").popup("open");
    //display the ajax loader
    AjaxLoader("a", "Please Wait", false);

    var uri = baseApiUrl + '/api/tbFormDataElements';
    var rowId = $("#rowID").val();
    if (rowId != "") {
        uri = baseApiUrl + '/api/tbFormDataElements/' + rowId;
    };

    if (submitData == true) {
        uri += "?sbmt=2";
        console.log(uri)
    } else {
        uri += "?sbmt=1";
        console.log(uri)
    }

    var data = JSON.stringify($("form").serializeArray());
    data = eval(data);
    //console.log(data);
    var values = "";


    //checkbox list
    var names = [];
    // Find out the checkbox group names
    $(":checkbox").each(function () {
        names.push(this.name);
    });
    var names = $.unique(names);
    var values = "";

    $.each(names, function (index) {
        name = names[index];

        $('form').find(':checkbox[name="' + name + '"]:checked').each(function () {
            values += $(this).attr("value") + ",";
        });
        //remove the checkbox values from the data
        data = data.filter(function (item) {
            //console.log("checkbox name: ", name);
            return item.name != name;
        });
        //console.log("removed: ",name,  data);
        //add checkbox value as array
        var newItm = { "name": name, "value": values }


        data.push(newItm);
        values = "";
    });



    var itms = $('select').each(function () {

        var id = $(this).attr('id');
        values += $(this).val();
        data = data.filter(function (item) {
            return item.name != id;
        });
        // console.log("newItm: " + id, values);
        var newItm = { "name": id, "value": values }
        data.push(newItm);
        values = "";
    });
    //add image name
    var itms = $('canvas').not(document.getElementById("blank")).each(function () {

        var imgName = "";

        if ($(DocumentID).val() != "") {
            imgName = $(DocumentID).val() + "_" + $(this).attr('id');
        }
        // console.log($(DocumentID).val(), $(this).attr('id'), imgName);

        var id = $(this).attr('id');
        var newItm = { "name": id, "value": imgName }
        data.push(newItm);
        values = "";
    });

    $.ajax({
        url: uri,
        async: true,
        cache: false,
        data: { '': data },
        headers: { 'Authorization': 'Bearer ' + token },
        type: "Post",
    })
    .done(function (data, status, jqXHR) {
        msg = "Done";

    })
    .success(function (data, status, jqXHR) {

        if (!data) {
            //console.log("No data");
            if (callBack) {
                callBack("No data");
            }
        }
        formValidation = data.formValidation;

        data = data.tbFormElListUpdated;
        $("#formSubmitDialog ul").append("<li>Save data entries.</li>")
        $.each(data, function (index, data) {
            if ($("#" + data.fieldName)) {
                $("#" + data.fieldName).val(data.fieldValue);
            }
        });



        if (data.length > 0) {
            $("#rowID").val(data[0].parentRowID);
        }
        var x = 0;
        var canvasList = $(".canvas").toArray();

        var canvasImages = function (canvasArray) {
            //upload image
            uploadCanvasImages(canvasArray[x], function (postImg) {
                // set x to next item
                x++;

                // check the canvas array length
                if (x < canvasArray.length) {
                   // console.log("go to next item", x);
                    canvasImages(canvasArray);

                } else {
                    //end of image upload
                    $("#formSubmitDialog ul").append("<li><b>Done</b></li>");

                    //hide Ajax loader
                    $.mobile.loading("hide");

                    //return the from status
                    if (callBack) {
                        var isvalid;
                        isvalid = validateForm(formValidation);
                        if (isvalid == true) {
                            $("#formSubmitDialog ul").append("<li><b>Success</b></li>");
                        }
                        else {
                            $("#formSubmitDialog ul").append("<li><b>Submit failed. Check for errors.</b></li>");
                        }
                        //return 
                        callBack(isvalid);
                    }
                    else {
                        validateForm(formValidation);
                    }
                }
            });
        }
        //if the documentid field is not populated, do't try to upload images

        if ($(DocumentID) == null || $(DocumentID).val().length == 0) {
            if (callBack) {
                callBack("No canvas change");
            }
            return false;
        }
        //processs images
        canvasImages(canvasList);
    })


};
function uploadCanvasImages(canvas, callBack) {
    //upload canvas images

    var fieldName = $(canvas).attr("id");
    //console.log("fieldName:", fieldName);
    //check if there is a new captured image to upload
    if (document.getElementById("FileUpload" + fieldName) != null && document.getElementById("FileUpload" + fieldName).files.length > 0) {

        //console.log("checkcanvas for file to upload:", "FileUpload" + fieldName )
        var imageSize = "small"
        ImageSource(fieldName, function (dataURL) {
            if (dataURL == null) {
                $("#formSubmitDialog ul").append("<li>" + fieldName + "  is blank</li>")
            } else {
                //upload small image
                imageSize = "small";
                $("#formSubmitDialog ul").append("<li>Uploading image: " + fieldName + " " + imageSize + "</li>")
                postImageData(fieldName, imageSize, dataURL, function (posted) {

                    if (posted != true) {
                        $("#formSubmitDialog ul").append('<li style="color:red;">Uploading failed</li>')
                    }
                    //upload medium image
                    var files = document.getElementById("FileUpload" + fieldName).files;
                    resizeImage(files, 2 * w, function (dataUrl) {
                        imageSize = "medium";
                        $("#formSubmitDialog ul").append("<li>Uploading image: " + fieldName + " " + imageSize + "</li>")

                        postImageData(fieldName, imageSize, dataUrl, function (posted) {
                            if (posted != true) {
                                $("#formSubmitDialog ul").append('<li style="color:red;">Uploading failed</li>')
                            }
                            //upload medium image
                            resizeImage(files, 4 * w, function (dataUrl) {
                                imageSize = "large";
                                $("#formSubmitDialog ul").append("<li>Uploading image: " + fieldName + " " + imageSize + "</li>")

                                postImageData(fieldName, imageSize, dataUrl, function (posted) {

                                    if (posted != true) {
                                        $("#formSubmitDialog ul").append('<li style="color:red;">Uploading failed</li>')
                                    }
                                    if (callBack) {
                                        callBack(posted);
                                    }
                                })
                            })

                        })

                    })


                });
            }
        });
    } else {
        if (callBack) {
            callBack(true);
        }
    }

}
function deleteFieldset(btn) {
    if (confirm("Are you sure that you want to delete this section?")) {
        $(btn).closest("fieldset").remove();
    }
}

function isMobile() {
    var agents = ['android', 'webos', 'iphone', 'ipad', 'blackberry'];

    for (i in agents) {
        if (navigator.userAgent.toLowerCase().match(agents[i])) {

            return true;
        }
    }

    return false;
}



function validateForm(formValidation) {

    $("#validationMsg ul").html("")
    $("#validationMsgBottom ul").html("")
    for (var i = 0, l = formValidation.length; i < l; i++) {
        err = formValidation[i];

        $("#validationMsg ul").append("<li>" + err.errorMsg + "</li>")
        $("#validationMsgBottom ul").append("<li>" + err.errorMsg + "</li>")
        //console.log(formValidation[i]);
        if (formValidation[i].validationType == "Required") {
            $("#" + err.fieldName).rules('add', {
                required: true,
                messages: { required: err.errorMsg }
            });
        }
        else if (formValidation[i].validationType == "InvalidLength") {
            $("#" + err.fieldName).rules('add', {
                rangelength: [err.minLength, err.maxLength],
                messages: { rangelength: err.errorMsg }
            });
        }
        else if (formValidation[i].validationType == "IntegerDataType") {
            $("#" + err.fieldName).rules('add', {
                digits: true,
                messages: { digits: err.errorMsg }
            });
        }
        else if (formValidation[i].validationType == "ShortDateFormat") {
            $("#" + err.fieldName).rules('add', {
                date: true,
                messages: { date: err.errorMsg }
            });
        }
        else if (formValidation[i].validationType == "NumericDataType") {
            $("#" + err.fieldName).rules('add', {
                number: true,
                messages: { number: err.errorMsg }
            });
        }
        $('input[type="file"]').each(function () {
            $(this).rules('add', {
                accept: "image/*"
            })
        })

        var form = $("#dynamicForm");
        form.validate();
        form.valid();
    }

    if (formValidation.length > 0) {
        return false
    }
    else {
        return true
    }
}

// Full tutorial on
var vidObj = null;
var context;
var canvas = null;
var navigator;

errCallBack = function (error) {	// Video Error Handler
    console.log("Video  error: ", error.code);
};
//PC version
//Attach Click event with camOnButton
function captureImg(thisCanvas) {

    var fieldSet = $(thisCanvas).parents("fieldset").eq(0);
    var canvasId = fieldSet.find(".canvas").attr("id")

    vidObj = document.getElementById("videoEle");
    canvas = document.getElementById(canvasId);
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
function snap(width, height) {
    context.drawImage(vidObj, 0, 0, width, height);
    vidObj.pause();
    vidObj = null;
}

function loadImage(canvasId, imageName, images, callBack) {
    //select the image from image data
    //console.log(canvasId, imageName)
    var img = images.filter(function (image) {
        return image.imageName == imageName;
    });
    if (!img.length > 0) {
        return;
    }

    var $img = $('<img>', { src: "data:image/png;base64," + img[0].imageSource });
    //console.log("=======================");
    ///console.log(canvasId);
    //console.log("=======================");
    var canvas = $('#' + canvasId)[0];
    var context = canvas.getContext('2d');


    //console.log(context);
    $img.load(function () {
        //console.log("width: ", this.width, canvasId, imageName, img[0].imageFileName)
        try {
            context.drawImage(this, 0, 0).trigger("refresh");

        } catch (e) {
            console.log("error");
        }
        callBack(true);
        //console.log("loading image: " + canvasId);
    });

}

//mobile version
function fileSelected(fileToUpload, containerId) {
    var oFReader = new FileReader();
    //console.log("fileToUpload=", fileToUpload);
    oFReader.readAsDataURL(document.getElementById(fileToUpload).files[0]);
    //console.log(document.getElementById(fileToUpload).files.length);

    oFReader.onload = function (e) {
        var canvas = $('#' + containerId)[0];
        var context = canvas.getContext('2d');

        var img = new Image();
        img.id = "temp" + containerId;

        img.onload = function () {
            //get captured image size
            var srcWidth = this.width;
            var srcHeight = this.height;

            //get scale
            var ratio = srcWidth / w; //ScaleImage(srcWidth, srcHeight, w, h, true)
            h = Math.floor(srcHeight / ratio);

            //set canvase size so the scaled image can fit in it,
            canvas.width = w;
            canvas.height = h;

            //scale the image to fit in the canvas
            context.drawImage(this, 0, 0, srcWidth, srcHeight, 0, 0, w, h);
        };

        img.src = e.target.result;
        
        console.log( "temp" + containerId)
    };
};
//
var angleInDegrees = 0;
function drawRotated(rotateBtn, degrees) {
    var fieldSet = $(rotateBtn).closest("fieldset");
    var canvasId = fieldSet.find('canvas').attr("id");
    //console.log(canvasId);
    angleInDegrees += 90
    //console.log(canvasId);
    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext('2d');

    var img = new Image();
    img.src = document.getElementById(canvasId).toDataURL("image/png");
    img.onload = function () {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        ctx.canvas.width = img.height;
        ctx.canvas.height = img.width;
        ctx.save();
        ctx.translate(canvas.width / 2, canvas.height / 2);
        ctx.rotate(degrees * Math.PI / 180);

        ctx.drawImage(img, -img.width / 2, -img.height / 2);

        ctx.restore();

    }
}



function deleteImage(delBtn) {
    if (confirm("Are you sure that you want to delete this image?")) {
        var fieldSet = $(delBtn).closest("fieldset");
        var canvasId = fieldSet.find('canvas').attr("id");

        var canvas = document.getElementById(canvasId);
        var ctx = canvas.getContext('2d');

        // console.log("ok", w, h);
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.canvas.width = 320;
        ctx.canvas.height = 240;

        $.ajax({
            type: "DELETE",
            url: baseApiUrl + "/api/ImageUpload/" + $(DocumentID).val() + "?imageId=" + canvasId,
            contentType: false,
            processData: false,
            headers: { 'Authorization': 'Bearer ' + token },
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                // alert("Done!");

            },
            error: function (msg) {
                alert("Unexpceted error");
            }
        });
    }

}

function AnnotationImg(e, fieldname) {

    saveForm(e, function () {

        var pgUrl = "imgAnnotation.color.html?docid=" + $(DocumentID).val() + "&fieldname=" + fieldname + "&id=" + $.url('?id') + "&row=" + $.url('?row')
        console.log(url);
        window.location.href = pgUrl;
    });
}

function ImageSource(canvasId, callBack) {
    //check for blank canvas
    var dataURL = null;
    var image;

    //check if canvas is blank
    // if (document.getElementById(canvasId).toDataURL() == document.getElementById('blank').toDataURL())
    if (document.getElementById(canvasId).toDataURL() == document.getElementById('blank').toDataURL())
        return callBack(null);

    image = document.getElementById(canvasId).toDataURL("image/png");
    dataURL = image.replace('data:image/jpeg;base64,', '');
    dataURL = dataURL.replace('data:image/png;base64,', '');
    //console.log(canvasId);
    //console.log(dataURL);
    return callBack(dataURL);
}

function resizeImage(files, MAX_WIDTH, callBack) {

    // from an input element

    var file = files[0];

    var oFReader = new FileReader();
    // console.log("fileToUpload=", fileToUpload);
    oFReader.readAsDataURL(file);
    var img = new Image();
    // console.log(document.getElementById(fileToUpload).files.length);
    oFReader.onload = function (e) {
        var canvas = document.createElement("canvas");
        var context = canvas.getContext('2d');
        //console.log("resizeImage oFReader.onload");

        img.onload = function () {
            // console.log("img.onload")
            //get captured image size
            var srcWidth = this.width;
            var srcHeight = this.height;
            var ratio;
            if (srcWidth > MAX_WIDTH){
                //get scale
                ratio = srcWidth / MAX_WIDTH; //ScaleImage(srcWidth, srcHeight, w, h, true)
            } else {
                ratio = MAX_WIDTH / srcWidth;
            }
            h = Math.floor(srcHeight / ratio);

            //set canvase size so the scaled image can fit in it,
            canvas.width = MAX_WIDTH;
            canvas.height = h;

            //scale the image to fit in the canvas
            context.drawImage(this, 0, 0, srcWidth, srcHeight, 0, 0, MAX_WIDTH, h);
            dataURL = canvas.toDataURL("image/png");
            dataURL = dataURL.replace('data:image/jpeg;base64,', '');
            dataURL = dataURL.replace('data:image/png;base64,', '');

            return callBack(dataURL);
        };
        img.src = e.target.result;
    }
    oFReader.onerror = function (event) {
        console.error("File could not be read! Code " + event.target.error.code);
    };

}

function postImageData(fieldName, imgSize, dataURL, callBack) {
   // console.log(" uploaded: ", fieldName, imgSize);
    var data = JSON.stringify(
          {
              value: dataURL
          });

    $.ajax({
        type: "POST",
        url: baseApiUrl + "/api/ImageUpload?FieldName=" + fieldName + "&imgSize=" + imgSize + "&docId=" + $(DocumentID).val(),
        contentType: false,
        processData: false,
        data: data,
        headers: { 'Authorization': 'Bearer ' + token },
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            // alert("Done!");
            if (callBack) {
                callBack(true);
            }
        },
        error: function (msg) {
            if (callBack) {

                callBack(false);
            }
        }
    });

}

function zoomImage(imageId) {
  
      var maxHeight, imageId

            maxHeight = $(window).height() + "px";
            if (imageId == "undefined" || imageId == null) {
                return;
            }
            if (document.getElementById("FileUpload" + imageId) != null && document.getElementById("FileUpload" + imageId).files.length > 0 && $("#temp" + imageId) != null) {
                //there is a new image tht is not saved 
                console.log("from db");
                var files = document.getElementById("FileUpload" + imageId).files;

                resizeImage(files, 640, function (dataUrl) {

                    $("#zoomImg")
                     .attr("src", "data:image/png;base64," + dataUrl)
                     .on("load", function () {
                         //console.log(maxHeight);
                         $(".photopopup img").css("max-height", maxHeight);

                     });

                });
                $("#popupPhotoPortrait").popup("open");
                return;

            }

            $.ajax({
                type: "GET",
                url: baseApiUrl + "/api/tbFormDataElements/" + $(DocumentID).val() + "?imageId=" + imageId,

                contentType: false,
                processData: false,
                headers: { 'Authorization': 'Bearer ' + token },
                contentType: "application/json; charset=utf-8",
                success: function (data, msg) {

                    $("#zoomImg")
                        .attr("src", "data:image/png;base64," + data)
                        .on("load", function () {
                            console.log(maxHeight);
                            $(".photopopup img").css("max-height", maxHeight);

                        });

                    $("#popupPhotoPortrait").popup("open");

                },
                error: function (msg) {
                    $(".photopopup").dialog("close");
                    // alert("Unexpceted error");
                }
            });

       
           
};


$(document).on('popupafterclose', '#popupPhotoPortrait', function () {
    console.log("close popup")
    $("#zoomImg")
        .attr("src", "../images/spacer.gif")
        
   // alert('closed');
});


function onWebServiceFailed(result, status, error) {
    var errormsg = eval("(" + result.responseText + ")");
    alert(errormsg.Message);
}
