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
<head lang="en">
<base href="<%=basePath%>">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/login.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/layer/mobile/layer.js"></script>
    <title>登录</title>
</head>
<body ontouchstart>
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>登录</h1>
        <a href="api/kehu/toRegister.do" class="register">注册</a>
    </div>
</header>
<div class="login">
    <form>
        <div class="login_t">
            <input type="text" id="phone"  maxlength="11" placeholder="手机号"/>
        </div>
        <div class="login_t">
            <input type="password" id="password" placeholder="请输入密码"/>
        </div>
        <a href="javascript:void(0)" class="login_b hover" onclick="checkLogin()">登录</a>
        <a href="api/kehu/wangjimima.do?tag=1" class="forget">忘记密码</a>
    </form>

</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    
    //检查服务器验证登录
		function checkLogin(){
	          $.ajax({
	             type: "post",
	             url: "api/kehu/login.do",
	             data: {phone:$("#phone").val(),password:$("#password").val()},
	             dataType: "json",
	             success: function(data){
	             var msg = data.respMsg;
	             console.log(msg)
	           		if(data.respCode=="01"){
	           			location.href="api/kehu/index.do";
	           		}else if(data.respCode=="02"){
	           			 //提示
						  layer.open({
						    content: msg
						    ,skin: 'msg'
						    ,time: 2 //2秒后自动关闭
						  });
    		       		 
	           		}else{
    		       		 //提示
						  layer.open({
						    content: msg
						    ,skin: 'msg'
						    ,time: 2 //2秒后自动关闭
						  });
	           		}
	           	
	              }
	         });
		}
</script>
</body>
</html>