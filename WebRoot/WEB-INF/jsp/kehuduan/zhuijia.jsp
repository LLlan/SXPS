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
    <link rel="stylesheet" href="static/css/wm/huifu.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>

    <title>回复评论</title>
    <style>

    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>回复评论</h1>
        <a href="javascript:void(0)" class="tijiao" onclick="tijiao();" >提交</a>
    </div>
</header>
<form name="Form" id="Form" method="post" action="api/kehu/${msg }.do?evaluate_id=${evaluate_id}">
	<div class="contentDiv">
	    <p class="numPinglun">回复评论内容</p>
	    <textarea name="pinglun" id="pinglun" placeholder="输入你想对买家说的回复内容"></textarea>
	    <p class="num">0/200</p>
	</div>
</form>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    
    function tijiao(){//提交评论
    	var pinglun = $("#pinglun").val;
    	if(pinglun==0){//评价内容非空判断
			layer.tips('输入你想对买家说的回复内容！', '#pinglun', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		$("#Form").submit(); 
    }
</script>
</body>
</html>
