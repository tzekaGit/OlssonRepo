<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="takePhotoWin.aspx.cs" Inherits="Olsson.WebApp.Forms.takePhotoWin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script type="text/javascript">
function captureImage()
{
    //S1: Create a new Camera Capture UI Object
    var cam = Windows.Media.Capture.CameraCaptureUI();
    //S2: Perform an Async operation where the Capture
    // Image will be stored as file
    cam.captureFileAsync(Windows.Media.Capture.CameraCaptureUIMode.photo)
        .done(function (data) {
            if (data)
            {
                //S3: Create a URL for the capture image
                // and assign it to the <Img>
                document.getElementById('img-capture').src = window.URL.createObjectURL(data);
            }
        }
        , error);
    document.getElementById('txterror').value = "Done";
}
function error()
{
    document.getElementById('txterror').value = "Error";
}
</script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
    <p>Content goes here</p>
        <input type="button" id="btnCapture" value="Capture"  onclick="captureImage()"/>
        <img id="imgCapture" src=""  width="100px" height="100px"/>
        <input type="text" id="txterror" />
    </div>
    </form>
</body>
</html>
