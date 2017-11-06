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
    <link rel="stylesheet" href="static/css/wm/lianxiWomen.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>联系我们</title>
    <style>

    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>联系我们</h1>
    </div>
</header>
<c:forEach items="${lianxiwmList }" var="lianxiwmLists">
	<div class="contentDiv">
	    <p>客服热线: <span class="call">${lianxiwmLists.hotline }</span><a href="javascript:void(0)" class="hujiao">呼叫</a></p>
	    <div class="weixin">
	        <p>微信号:${lianxiwmLists.weChat }</p>
	        <p>(手动添加微信)</p>
	    </div>
	</div>
</c:forEach>
<!-- 当列表为空时，暂无数据 -->
 <c:if test="${empty lianxiwmList}"><%@include file="common.jsp" %></c:if>
<div class="mask"></div>
<div class="shanchuDiv">
    <p class="shifou"></p>
    <p><a href="javascript:void(0)" class="cancel" style="color:#0284fe;">取消</a><a href="javascript:void(0)" class="sure" style="color:#0284fe">呼叫</a></p>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    $(function(){
        $(".hujiao").click(function(){
            console.log("111");
            $(".shifou").text($(".call").text());
            $(".sure").attr("href","tel:"+$(".shifou").text());
            $(".mask").fadeIn();
            $(".shanchuDiv").fadeIn();
            $(".cancel").click(function(){
                $(".mask").fadeOut();
                $(".shanchuDiv").fadeOut();
            })
        })
    })
</script>
</body>
</html>
