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
    <link rel="stylesheet" href="static/css/wm/changeUserName.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>修改用户名</title>
    <style>

    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
	<header>
	    <div class="header">
	        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
	        <h1>修改用户名</h1>
	    </div>
	</header>
	<form id="uploadForm" action="api/kehu/${msg}.do" method="post" style="margin-top:88px;">
		<div class="contentDiv">
			<div class="content">
				<input type="text" placeholder="用户名" value="${pds.userName }"
					name="userName" id="userName" maxlength="12" class="usernameInput" />
				<p>请输入4-12位数字、字母或中文</p>
				<a href="javascript:void(0)" onclick="yonghuming()">确认修改</a>
			</div>
		</div>
	</form>
	<script>
	/*  $(function() {
        FastClick.attach(document.body);
    }); */
    
	  function yonghuming(){
    	var userName=$("#userName").val();
	    	if(userName==0){
				layer.tips('请输入您的真实姓名！', '#userName', {
		     		  tips: [1, '#D9006C'],
		     		  time: 3000
		     	});
				return;
			}else if(userName.length<2){
				layer.tips('请输入至少二个字！', '#userName', {
		     		  tips: [1, '#D9006C'],
		     		  time: 3000
		     	});
				return;
			}
    	$("#uploadForm").submit();
    }
</script>
</body>
</html>
