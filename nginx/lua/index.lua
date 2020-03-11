local template = require "resty.template"

template.render([[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0 user-scalable=no" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>家庭云盘</title>
    <style>
        html,
        body {
            width: 100%;
            height: 100%;
            overflow: hidden;
            margin: 0;
            padding: 0;
        }
        img {
            max-width: 100%;
            width: 100%;
        }
    </style>
</head>
<body>
<div style="width:100%;text-align:center">
    <a href="/download">文件列表</a>
</div>

<div style="width:100%;text-align:center">
    <fieldset>
        <p>上传文件</p>
        <form id="upload" action="/upload?is_private=1" method="POST" enctype="multipart/form-data">
            <input type="file" name="file"/>
            <select name="is_private" id="pri">
                <option value="1">私密上传</option>
                <option value="0">公开上传</option>
            </select>
            <input type="submit" value="提交" />
        </form>
    </fieldset>
</div>
</body>
<script>
    var pri = document.getElementById("pri");
    pri.onchange = function () {
        document.getElementById("upload").action = "/upload?is_private=" + this.value;
    }
</script>
</html>
]])
