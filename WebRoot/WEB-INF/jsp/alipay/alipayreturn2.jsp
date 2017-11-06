<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>">
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <title>支付成功</title>
    <style>
	    h1 {
		    margin-top: 0;
		    font-size: 15px;
		    color: white;
		    font-weight: 100;
		}
		#header {
		    width: 100%;
		    height: 50px;
		    background-color: #0284fe;
		    position: fixed;
		    top: 0;
		    left: 0;
		    z-index: 100;
		    text-align: center;
		    line-height: 50px;
		}
		.connectBox{
			margin-top:70px;
			background-color:#fff;
		}
    </style>
</head>
<body>

<div id="header" style="background-color: #068dff;">
    <h1 class="title">付款成功</h1>
    <a href="api/h5KeHu/index.do" class="icon1"><i class="icon-angle-left "></i></a>
</div>
<!--主体开始-->
<div class="connectBox">
	<br>
	<div style="width:70%;margin:0 auto;text-align: center;">
		<div >
    	<img src="static/images/wm/lvseduihao.png" style="width: 40px;vertical-align: middle;">
    	<span style="margin-left: 10px;font-size:18px;">付款成功</span>
    </div><br><br>
    <div>
    	<a href="api/kehu/orderinfo.do?order_takeou_id=${order_takeou_id }" style="color: #38c4ff;">订单详情</a>
    	<a href="api/kehu/index.do" style="margin-left: 25%;color: #38c4ff;">返回主页</a>
    </div>
	</div>
    <br>
</div>
</body>
</html>