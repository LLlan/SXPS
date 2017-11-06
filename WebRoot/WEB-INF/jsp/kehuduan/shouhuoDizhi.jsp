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
    <link rel="stylesheet" href="static/css/wm/shouhuoDizhi.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>

    <title>管理收货地址</title>
    <style>
		.dizhiRight {
	    float: left;
	    width: 10%;
	    height: 80px;
	    line-height: 80px;
	    text-align: right;
	}
	.dizhiLeft {
	    border-right: 1px solid #ddd;
	    width: 88%;
	    height: 85px;
	    float: left;
	}
	.dizhiRight>p>a {
	    font-size: 22px;
	}
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="api/kehu/wode.do" class="iconfont icon-toLeft-copy back"></a>
        <h1>管理收货地址</h1>
    </div>
</header>
<div class="contentDiv">
<c:forEach items="${shouhuoDizhiList}" var="pdList">
    <div class="dizhiDiv" style="width: 94%; height: 85px;">
        <div class="dizhiLeft">
            <p style="line-height: 19px;"><span>${pdList.linkmanName }</span><span>${pdList.phone }</span><span class="identity">${pdList.identity } </span>
            <c:if test="${pdList.isDefault eq '1'}">
             	 <b style="color: #0284fb;font-size: 14px">默认</b>
            </c:if>
            </p>
            <p><span>${pdList.lable }</span>${pdList.address } ${pdList.detailAddress }</p>
        </div>
        <div class="dizhiRight">
            <p style="margin-top: 8px;margin-bottom: 5px;"><a href="api/kehu/bianjiDizhiEdit.do?shouhuo_address_id=${pdList.shouhuo_address_id}&tag=2&user_shangjia_id=${user_shangjia_id }" class="iconfont icon-bianji" style="font-size: 22px;"></a></p>
            <p><a href="javascript:void(0)" onclick="deletes('${pdList.shouhuo_address_id}');" class="iconfont icon-lajitong shanchu"></a></p>
        </div>
    </div>
 </c:forEach>
 <!-- 当列表为空时，暂无数据 -->
 <c:if test="${empty shouhuoDizhiList}"><%@include file="common.jsp" %></c:if>
</div>
<a href="api/kehu/xinzengDizhi.do?tag=2" class="xinzeng">
    <i class="iconfont icon-zengjia"></i><span>新增地址</span>
</a>
<div class="mask"></div>
<div class="shanchuDiv">
    <p class="shifou">确认删除此地址？</p>
    <p><a href="javascript:void(0)" class="cancel">取消</a><a href="javascript:void(0)" class="sure" style="color: #0284fe">确认</a></p>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    function deletes(id){//执行删除
		var del;
		var user_shangjia_id = "${user_shangjia_id }";
        del=$(this);
        $(".mask").fadeIn();
        $(".shanchuDiv").fadeIn();
        $(".sure").click(function(){
            $(".mask").fadeOut();
            $(".shanchuDiv").fadeOut();
			location.href="api/kehu/addressDelete.do?shouhuo_address_id="+id+"&tag=2&user_shangjia_id="+user_shangjia_id;
        });
        $(".cancel").click(function(){
            $(".mask").fadeOut();
            del.parent().remove();
            $(".shanchuDiv").fadeOut();
        });
	}
</script>
</body>
</html>
