
var annotPins = [];
var noteCount = 0;
var mapSize;

var docid = getParameterByName("docid");
var fieldname = getParameterByName("fieldname");
var realMapWidth, realMapHeight;
var mapWidth, mapHeight;
var resizeBgRatio;
var mapZoom = 100;
var resizeBgRatio = mapZoom / 100;
var pinW = 27;
var pinH = 40;
var corrX = 8;
var corrY = 40;
var isDirty = false;
var token = sessionStorage.getItem(tokenKey);


$(document).ready(function () {
    AjaxLoader("a", "Please Wait", false);
  
    getImage(docid, fieldname, function (data) {
        console.log("map", getLoginToken())
        if (getLoginToken("imgdiv") == false) {
            return;
        }
       
        $("#map")
            .attr("src", "data:image/png;base64," + data.imageSource)
            .on("load", function(){
            
                imageID = data.rowID;


                $("#map").css("width", mapZoom + "%");
                imgSize("#map");
                resizeBgRatio = ($(this).width() / realMapWidth);

                setTimeout(function () {
                    getAnnotations(imageID, function (data) {
                        annotPins = data;
                        dropPins(annotPins, resizeBgRatio);
                    })
                    $.mobile.loading("hide");
                }, 1000);
            })
      
    })


    $('#map').dblclick(function (e) {
        console.log("click");
        noteCount++;
        var pinid = noteCount;
        dropAPin(e, true, pinid);
        e.stopPropagation();
        isDirty = true;
    });

    var touchtime = 0;
    $('#map').on("tap", function (e) {



        if (touchtime == 0) {
            //set first click
            touchtime = new Date().getTime();
        } else {
            //compare first click to this click and see if they occurred within double click threshold
            if (((new Date().getTime()) - touchtime) > 500 && ((new Date().getTime()) - touchtime) < 1200) {
                //double click occurred
                touchtime = 0;


                noteCount++;
                var pinid = noteCount;
                dropAPin(e, true, pinid);
                e.stopPropagation();
                isDirty = true;

            } else {
                //not a double click so set as a new first click
                touchtime = new Date().getTime();
            }
        }
        return false;
    });


    $("#zoomIn").click(function () {
        if (mapZoom == 175) {
            return;
        }
        mapZoom += 25;
        //console.log(resizeBgRatio);
        $("#map").css("width", mapZoom + "%");
        imgSize("#map");
        resizeBgRatio = (mapWidth / realMapWidth);
        console.log(mapZoom, resizeBgRatio)
        updatePins(resizeBgRatio);
    });

    $("#zoomOut").click(function () {
        if (mapZoom == 25) {
            return;
        }
        mapZoom -= 25;
        // console.log(mapZoom);

        $("#map").css("width", mapZoom + "%");
        imgSize("#map");
        resizeBgRatio = (mapWidth / realMapWidth);
        console.log(realMapWidth, mapZoom, resizeBgRatio)
        updatePins(resizeBgRatio);
    });

    $("#zoomReset").click(function () {
        mapZoom = 100;
        // console.log(mapZoom);

        $("#map").css("width", 100 + "%");
        imgSize("#map");
        resizeBgRatio = (mapWidth / realMapWidth);
        console.log(realMapWidth, mapZoom, resizeBgRatio)
        updatePins(resizeBgRatio);
    });


    $(document).on('mouseup', '.annotPin', function (e) {
        var pin = [];
        var keyID = $(this).data("id");
        var idx;
        isDirty = true;

        console.log(keyID);
        //find the ID. ID will be a guid for existing annotations, ID will be an integer sequenceID for newly added annotations
        for (var i = 0, len = annotPins.length; i < len; i++) {
            if (keyID == annotPins[i].id || keyID == annotPins[i].sequenceID) {
                pin = annotPins[i];
                idx = i;
            }
        }
        console.log(pin);

        var offset = $("#map").offset();

        var posX = (e.pageX - offset.left);
        var posY = (e.pageY - offset.top);

        var corrX = $(this).width() / 2;
        var corrY = $(this).height();

        // console.log("aaaa", posX, posY, offset.left, offset.top);

        posX = (posX - corrX) / (realMapWidth * resizeBgRatio);
        posY = (posY + corrY) / (realMapHeight * resizeBgRatio);
        //console.log("realMapHeight", realMapWidth, realMapHeight);

        //pin.title = 'aaa';
        //pin.description = 'bbb'
        //pin.shape = 'cccc';
        //pin.color = 'red';
        pin.xPos = posX //+ corrX;
        pin.yPos = posY //+ corrY;

        console.log(pin)
        annotPins[idx] = pin;
        console.log("success")
        // console.log("bbb", annotPins);
    });

});

function getParameterByName(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [, ""])[1].replace(/\+/g, '%20')) || null;
}


function getImage(docid, fieldname, callBack) {
    if (getLoginToken("imgdiv") == false) {
        return;
    }

    var url = baseApiUrl + "/api/Annotations/" + docid + "?fieldname=" + fieldname;

    var formLink = ""
    $.ajax({
        url: url,
        cache: false,
        type: "GET",
        dataType: 'json',
        headers: { "Authorization": "Bearer " + token }
    })
   .done(function (data, status, jqXHR) {
       //$.mobile.loading("hide");
   })
   .success(function (data, status, jqXHR) {
       //console.log("successs");
       if (callBack) {
           callBack(data)
       }

       //console.log(formLink);
       return formLink;
   }).fail(function (data, status, jqXHR) {
       console.log("error");
       // callBack(formLnk);
   })
}

function getAnnotations(rowID, callBack) {
    console.log("getAnnots");
    var url = baseApiUrl + "/api/Annotations/" + rowID;
    var token = sessionStorage.getItem(tokenKey);
    if (getLoginToken("imgdiv") == false) {
        return;
    }
    var formLink = ""
    $.ajax({
        url: url,
        cache: false,
        type: "GET",
        dataType: 'json',
        headers: { "Authorization": "Bearer " + token }
    })
   .done(function (data, status, jqXHR) {
       //$.mobile.loading("hide");
   })
   .success(function (data, status, jqXHR) {
       //console.log("successs");
       if (callBack) {
           callBack(data)
       }

       //console.log(formLink);
       return formLink;
   }).fail(function (data, status, jqXHR) {
       console.log("error");
       // callBack(formLnk);
   })

};


function dropAPin(e, isNew, pinId) {

    var offset = $("#map").offset();
    var posX = e.pageX;
    var posY = e.pageY;

    if (isNew) {

        //console.log(posX, posY);
        var elem = $(document.createElement('div'))
            .css({ position: 'absolute', left: (posX - corrX) + 'px', top: (posY - corrY) + 'px' })
            .attr("class", "annotPin pin" + pinId + " red")
            //.append($('<p>' + (pinId) + '</p>').css({ color: '#fff', 'z-index': 1, position: 'relative', top: '-8px', left: '8px' }))
            //.prepend($('<img>', { src: '../images/marker_black.png', width: pinW + 'px', height: pinH + 'px' }).css({ position: 'absolute', top: '0px', left: '0px' }))
            .append($('<span>' + (pinId) + '</span>').css({ 'z-index': 1, position: 'relative' }))
            .attr("id", "circle")
            .attr("data-id", pinId)
            .draggable();

        $('body').append(elem);
    }

    posX = (e.pageX - offset.left);
    posY = (e.pageY - offset.top);
    posX = posX / (realMapWidth * resizeBgRatio);
    posY = posY / (realMapHeight * resizeBgRatio);

    var pin = { id: '', rowID: imageID, sequenceID: noteCount, title: 'new item', description: '', shape: 'circle', color: 'red', xPos: posX, yPos: posY, size: '', imageName: '', source: '' }

    //console.log(pin);

    elem = pinAttributes(pin, posX, posY)
    annotPins.push(pin);

}

function imgSize(thisImg) {
    var myImg = document.querySelector(thisImg);
    realMapWidth = myImg.naturalWidth;
    realMapHeight = myImg.naturalHeight;

    mapWidth = myImg.clientWidth;
    mapHeight = myImg.clientHeight;
    console.log("Original width=" + realMapWidth + ", " + "Original height=" + realMapHeight);

}

function dropPins(annotPins, resizeBgRatio) {

    var offset = $("#map").offset();
    //console.log("browserZoom=",  browserZoom, realMapWidth, resizeBgRatio);
    annotPins.forEach(function (pin) {
        noteCount++;
        //  resizeBgRatio = $(this).width() / realMapWidth;

        xPos = pin.xPos * (realMapWidth * resizeBgRatio);
        yPos = pin.yPos * (realMapHeight * resizeBgRatio);

        xPos = offset.left + xPos - corrX;
        yPos = offset.top + yPos - corrY;
        elem = pinAttributes(pin, xPos, yPos)
        elem.draggable();

        $('body').append(elem);
    })



}
function pinAttributes(pin, xPos, yPos) {
    var elem = $(document.createElement('div'))
                .attr("id", pin.shape)
                .css({ position: 'absolute', zIndex: '1', left: xPos + 'px', top: yPos + 'px' })

    if (pin.shape == "circle") {
        elem.attr("class", "annotPin pin" + pin.id + " " + pin.color)

    } else {
        elem.attr("class", "annotPin pin" + pin.id + " " + pin.color)

    }

    if (pin.shape == "triangle-down") {
        elem.css({ borderTopColor: pin.color })
    } else if (pin.shape == "triangle-up") {
        elem.css({ borderBottomColor: pin.color })
    }

    if (pin.shape.indexOf("triangle-up") >= 0) {
        elem.attr("data-id", pin.id).append($('<span>' + (pin.sequenceID) + '</span>').css({ 'z-index': 1, position: 'relative', left: '-5px', top: '3px' }))
    } else if (pin.shape.indexOf("triangle-down") > 0) {
        elem.attr("data-id", pin.id).append($('<span>' + (pin.sequenceID) + '</span>').css({ 'z-index': 1, position: 'relative', left: '-5px', top: '-32px' }))
    } else {
        elem.attr("data-id", pin.id).append($('<span>' + (pin.sequenceID) + '</span>').css({ 'z-index': 1, position: 'relative' }))
    }
    return elem;

}
function updatePins(resizeBgRatio) {
    var offset = $("#map").offset();
    //  console.log("resizeBgRatio=" + resizeBgRatio);

    annotPins.forEach(function (pin) {
        xPos = pin.xPos * (realMapWidth * resizeBgRatio);
        yPos = pin.yPos * (realMapHeight * resizeBgRatio);

        xPos = offset.left + xPos - corrX;
        yPos = offset.top + yPos - corrY;

        $(".annotPin.pin" + pin.id).css({ left: xPos + "px", top: yPos + "px" });
        // console.log("xPos", xPos, yPos);

    })
}



$(document).on('click', '#btn-list .btn12', function () {
    // Your Code
});
//prevent mouse whele scrolling & zooming
$(window).keydown(function (event) {
    if ((event.keyCode == 107 && event.ctrlKey == true) || (event.keyCode == 109 && event.ctrlKey == true)) {
        event.preventDefault();
    }

    $(window).bind('mousewheel DOMMouseScroll', function (event) {
        if (event.ctrlKey == true) {
            event.preventDefault();
        }
    });
});


var browserZoom = window.devicePixelRatio;
function hasPageBeenResized() {
    //console.log("hasPageBeenResized")
    imgSize("#map");
    resizeBgRatio = ($(document).width() / realMapWidth)

    if (browserZoom != window.devicePixelRatio) {
        console.log("from the browser")
        resizeBgRatio = resizeBgRatio / window.devicePixelRatio;
        browserZoom = window.devicePixelRatio;
    }


    updatePins(resizeBgRatio)

};

//run when page is resized
onresize = hasPageBeenResized;


function saveAnnotations(annotPins, callBack) {
    if (getLoginToken("imgdiv") == false) {
        callBack(false);
    }
    AjaxLoader("a", "Please Wait", false);
  
    if (!isDirty) {
        $.mobile.loading("hide");
        callBack(false);
        return true;
    }

    var url = baseApiUrl + "/api/annotations/" + imageID;

    var annotData = JSON.stringify(annotPins);
    annotData = eval(annotData)
    // console.log(annotData);


    $.ajax({
        url: url,
        cache: false,
        type: "POST",
        dataType: 'json', 
        headers: { "Authorization": "Bearer " + token },
        data: { '': annotData },
    })
   .done(function (data, status, jqXHR) {
       $.mobile.loading("hide");
   })
   .success(function (data, status, jqXHR) {
       if (callBack) {
           callBack(true)
       }


   }).fail(function (data, status, jqXHR) {

   })

};

function publishAnnotations(imageID, callBack) {

    saveAnnotations(annotPins, function () {

        if (!callBack) {
            goToForm();
            return;
        }

        var url = baseApiUrl + "/api/annotations/" + imageID + "?fieldname=" + fieldname;
     

        $.ajax({
            url: url,
            cache: false,
            type: "POST",
            dataType: 'json',
            headers: { "Authorization": "Bearer " + token },
            data: { publish: [] },
        })
       .done(function (data, status, jqXHR) {
           $.mobile.loading("hide");
       })
       .success(function (data, status, jqXHR) {

           if (data != null && data != false) {
               goToForm()
           }

       }).fail(function (data, status, jqXHR) {
           console.log("error");

       })
    })
};

function goToForm() {
    var pgUrl = "formDetails.aspx?id=" + $.url('?id') + "&row=" + $.url('?row')
    window.location.href = pgUrl;
};

$(function () {

    $('#trash').droppable({
        drop: function (event, ui) {
            var key = "id"
            var value = ui.draggable.data("id");
            findAndRemove(annotPins, key, value);

            ui.draggable.remove();
            event.stopPropagation();
        }
    });
});

function findAndRemove(array, property, value) {
    array.forEach(function (result, index) {
        if (result[property] === value) {
            //Remove from array
            array.splice(index, 1);
        }
    });
}



