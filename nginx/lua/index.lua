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
    <a href="/download"> 下载区</a>
</div>

<div style="width:100%;text-align:center">
    <fieldset>
        <p>公开上传</p>
        <form class="upload" action="/upload" method="POST" enctype="multipart/form-data"/>
            <input type="file" name="file"/>
            <input type="submit" value="提交" />
        </form>
    </fieldset>
</div>

<div style="width:100%;text-align:center">
    <fieldset>
        <p>私有上传</p>
        <form class="upload2" action="/upload/" method="POST" enctype="multipart/form-data"/>
            <input type="file" name="file"/>
            <input type="submit" value="提交" />
        </form>
    </fieldset>
</div>
</body>
</html>
]])