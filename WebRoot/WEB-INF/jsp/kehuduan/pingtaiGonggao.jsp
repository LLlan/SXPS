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
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>平台公告</title>
    <style>
        .contentDiv{
            margin-top:70px;
            width:100%;
        }
        .content{
            width:94%;
            margin:0 auto;
        }
        .gonggaoDiv{
            width:100%;
            padding:10px 3%;
            background-color:#fff;
            border-radius: 10px;
            margin-top:20px;
        }
        .gonggaoDiv>h2{
            overflow: hidden;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		    width: 88%;
            height:30px;
            line-height: 30px;
            color:#000;
            font-size: 18px;;
        }
        .gonggaoDiv>p{
           	width: 100%;
		    line-height: 22px;
		    color: #999999;
		    font-size: 12px;
		    white-space: pre-line;
		    display: -webkit-box;
		    -webkit-box-orient: vertical;
		    -webkit-line-clamp: 4;
		    overflow: hidden;
		    text-indent: 24px;
        }
        
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>平台公告</h1>
    </div>
</header>
<div class="contentDiv">
    <div class="content">
    	<c:forEach items="${noticeList }" var="list">
       		<div class="gonggaoDiv" onclick="window.location.href='api/kehu/toNoticeDetaile.do?notice_id=${list.notice_id }'">
	            <h2>${list.title }</h2>
	            <p>${list.content }</p>
	        </div>
       	</c:forEach>
       	<!--
        <div class="gonggaoDiv">
            <h2>公告一:</h2>
            <p>公告一公告一公告一公告一公告一公告一公告一公告一公告一公告一公告一</p>
        </div>
        <div class="gonggaoDiv">
            <h2>公告一:</h2>
            <p>公告一公告一公告一公告一公告一公告一公告一公告一公告一公告一公告一</p>
        </div>
        <div class="gonggaoDiv">
            <h2>公告一:</h2>
            <p>公告一公告一公告一公告一公告一公告一公告一公告一公告一公告一公告一</p>
        </div>
        -->
    </div>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
</script>
</body>
</html>
