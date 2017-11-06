<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <link rel="stylesheet" href="static/css/wm/weui.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/youhuiQuan.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>优惠券</title>
    <style>

    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>优惠券</h1>
    </div>
</header>
<div class="contentDiv">
    <div class="content">
        <div class="bangzhu">
            优惠券使用帮助
        </div>
        <div class="youhuiquan">
            <div class="quanLeft">
                <p><span>￥</span><span>5</span></p>
                <p>优惠券</p>
            </div>
            <div class="quanRight">
                <p>外卖商家券 : 港式牛扒饭</p>
                <p><span>满70元可用</span><span>APP下单使用</span><span>在线支付组专享</span></p>
            </div>
            <p>5天后过期</p>
        </div>
        <div class="youhuiquan">
            <div class="quanLeft">
                <p><span>￥</span><span>5</span></p>
                <p>优惠券</p>
            </div>
            <div class="quanRight">
                <p>外卖商家券 : 港式牛扒饭</p>
                <p><span>满70元可用</span><span>APP下单使用</span><span>在线支付组专享</span></p>
            </div>
            <p>5天后过期</p>
        </div>
        <div class="youhuiquan">
            <div class="quanLeft">
                <p><span>￥</span><span>5</span></p>
                <p>优惠券</p>
            </div>
            <div class="quanRight">
                <p>外卖商家券 : 港式牛扒饭</p>
                <p><span>满70元可用</span><span>APP下单使用</span><span>在线支付组专享</span></p>
            </div>
            <p>5天后过期</p>
        </div>
        <div class="youhuiquan">
            <div class="quanLeft">
                <p><span>￥</span><span>5</span></p>
                <p>优惠券</p>
            </div>
            <div class="quanRight">
                <p>外卖商家券 : 港式牛扒饭</p>
                <p><span>满70元可用</span><span>APP下单使用</span><span>在线支付组专享</span></p>
            </div>
            <p>5天后过期</p>
        </div>
    </div>

</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
</script>
</body>
</html>
