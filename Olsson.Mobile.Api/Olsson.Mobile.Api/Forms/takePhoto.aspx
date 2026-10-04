<!DOCTYPE html>
 
<html>
 
<head>
 
    <title>Take or select photo(s) and upload</title>
 
    <script type="text/javascript">
 
        function fileSelected(fileToUpload, capturedImg) {
            PreviewImage(fileToUpload, capturedImg);
 
      }
 
        function PreviewImage(fileToUpload, capturedImg) {
          var oFReader = new FileReader();
          oFReader.readAsDataURL(document.getElementById(fileToUpload).files[0]);

          oFReader.onload = function (oFREvent) {
              document.getElementById(capturedImg).src = oFREvent.target.result;
          };
      };

      //function uploadFile() {
 
      //  var fd = new FormData();
 
      //        var count = document.getElementById('fileToUpload').files.length;
 
      //        for (var index = 0; index < count; index ++)
 
      //        {
 
      //               var file = document.getElementById('fileToUpload').files[index];
 
      //               fd.append(file.name, file);
 
      //        }
 
      //  var xhr = new XMLHttpRequest();
 
      //  xhr.upload.addEventListener("progress", uploadProgress, false);
 
      //  xhr.addEventListener("load", uploadComplete, false);
 
      //  xhr.addEventListener("error", uploadFailed, false);
 
      //  xhr.addEventListener("abort", uploadCanceled, false);
 
      //  xhr.open("POST", "savetofile.aspx");
 
      //  xhr.send(fd);
 
      //}
 
      //function uploadProgress(evt) {
 
      //  if (evt.lengthComputable) {
 
      //    var percentComplete = Math.round(evt.loaded * 100 / evt.total);
 
      //    document.getElementById('progress').innerHTML = percentComplete.toString() + '%';
 
      //  }
 
      //  else {
 
      //    document.getElementById('progress').innerHTML = 'unable to compute';
 
      //  }
 
    //  }
 
      //function uploadComplete(evt) {
 
      //  /* This event is raised when the server send back a response */
 
      //  alert(evt.target.responseText);
 
      //}
 
      //function uploadFailed(evt) {
 
      //  alert("There was an error attempting to upload the file.");
 
      //}
 
      //function uploadCanceled(evt) {
 
      //  alert("The upload has been canceled by the user or the browser dropped the connection.");
 
      //}
 
    </script>
 
</head>
 
<body>
 
  <form id="form1" enctype="multipart/form-data" method="post" action="Upload.aspx">
 
    <div>
 
      <label for="fileToUpload">Take or select photo(s)</label><br />
 
      <input type="file" name="fileToUpload" id="fileToUpload" onchange="fileSelected('fileToUpload', 'capturedImg');" accept="image/*" capture="camera" />
        <div  style="width:640px; border:1px solid red; overflow:hidden;">
            <img src="#"  id="capturedImg" style="max-width:640px;"/>
        </div>


    </div>
 
    <div id="details"></div>
 
    <div>
 
     <%-- <input type="button" onclick="uploadFile()" value="Upload" />--%>
 
    </div>
 
    <div id="progress"></div>
 
  </form>
 
</body>
 
</html>