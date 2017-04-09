---
title: OpenTSDB-2
date: 2017-01-06 12:28:42
---
测试OpenTSDB的WebApi接口，表示不会写JS很是费劲，好不容易百度了ajax的写法，又遇到跨域问题和post数据大小的限制……这个破烂页面记一下，以后遇到要post数据的地方可以来这里翻
<!--more-->
```html
<!DOCTYPE html>
<html>
<head>
<script src="./jquery-1.10.2.min.js">
</script>
<script>
    $(document).ready(function () {
        $("button").click(function () {
            var uri="http://128.1.10.20:4242/api/put?summary";
            var i = 0;
            var j = 0;
            var start = new Date();
            document.getElementById("start").innerHTML = (start).toLocaleTimeString() + start.getMilliseconds();
            while (i++ < 10000) {
                $.ajax({
                    type: "POST",
                    url: uri,
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
    "metric": "mysql.bytes_received",
    "timestamp": i,
    "value": 1,
    "tags": {
       "host": "web01",
    }
}),
                    dataType: "json",
                    success: function (message) {
                        //alert(message.StatusCode==200?"Success":"Failed");
                        document.getElementById("count").innerHTML = (message.success == 1 ? j++ : alert( JSON.stringify(message)));
                        document.getElementById("end").innerHTML = (end).toLocaleTimeString() + end.getMilliseconds();
                        //message.StatusCode==200?alert("第"+i+"条数据成功"):null;
                    },
                    error: function (message) {
                        $("#request-process-patent").html("提交数据失败！");
                    }
                });
            }
            var end = new Date();
            document.getElementById("end").innerHTML = (end).toLocaleTimeString() + end.getMilliseconds();
        });
    });
</script>
</head>
<body>
开始时间<p id="start"></p>
<p id="count">成功次数</p>
结束时间<p id="end"></p>
<script></script>
<button>向页面发送 HTTP POST 请求，并获得返回的结果</button>

</body>
</html>
```