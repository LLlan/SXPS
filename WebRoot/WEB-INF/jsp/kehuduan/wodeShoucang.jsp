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
    <link rel="stylesheet" href="static/css/wm/wodeShoucang.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>我的店铺收藏</title>
    <style>
		.line2>i {
		    color: #666;
		    float: right;
		}
		.shoucangDiv {
			display: block;
		}
		.shoucRight>p{
			margin-top: 3px;
		}
		.line1 {
		    height: 20px;
		    line-height: 20px;
		}
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>我的店铺收藏</h1>
    </div>
</header>
<div class="contentDiv" >
	<c:forEach items="${shouCangList }" var="shouCanglist">
	    <a href="api/kehu/toShopByInfo.do?user_shangjia_id=${shouCanglist.user_shangjia_fid }&mkID=${shouCanglist.mkID}&lat=${pd.lat}&lng=${pd.lng}" class="shoucangDiv">
	        <img src="${shouCanglist.logoImg }" alt=""/>
	        <div class="shoucRight">
	            <p class="line1">${shouCanglist.shopName }</p>
	            <p class="line2">
	            	<c:if test="${shouCanglist.score == '0.5' }">
		                <img src="static/images/wm/banxing.png" alt=""/>
                	</c:if>
	            	<c:if test="${shouCanglist.score == '1' }">
		                <img src="static/images/wm/xing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '2' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '2.5' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/banxing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '3' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '3.5' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/banxing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '4' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '4.5' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/banxing.png" alt=""/>
                	</c:if>
                	<c:if test="${shouCanglist.score == '5' }">
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
		                <img src="static/images/wm/xing.png" alt=""/>
                	</c:if>
		            <i class="iconfont icon-jiantou-copy"></i>
	            </p>
	            <p class="line3">${shouCanglist.address }</p>
	        </div>
	    </a>
	</c:forEach>
	<!-- 当列表为空时，暂无数据 -->
	<c:if test="${empty shouCangList}"><%@include file="common.jsp" %></c:if>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    $(function(){
        var wid=$(".shoucangDiv").width()-70;
        $(".shoucRight").width(wid);
    });
</script>
</body>
</html>
