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
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/login.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <title>设置新密码</title>
</head>
<body>
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>设置新密码</h1>
    </div>
</header>
<div class="login">
    <form action="">
    <input type="hidden" value="${phone}" id="phone">
        <div class="login_t">
            <input type="password" id="mm" name="newPassword" placeholder="设置密码(密码由6-11位字母加数字组成)"/>
        </div>
        <div class="login_t">
            <input type="password" id="qrmm" name="xx" placeholder="确认密码"/>
        </div>
        <a href="javascript:void(0)" onclick="sub()" class="login_b hover">确定</a>
    </form>

</div>
 <script src="static/js/layer/mobile/layer.js"></script>
 <script src="static/js/jquery.tips.js"></script>
<script>
    $(function() {
        FastClick.attach(document.body);
    });

</script>
<script type="text/javascript">
  var reg = new RegExp(/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/);
   function sub(){
	   if(reg.test($("#mm").val())){
	   		if($("#mm").val().length>=6 && $("#mm").val().length<11){
		   		if($("#mm").val()==$("#qrmm").val()){
		   			$.post('api/kehu/changepwd.do',{
		   			phone:$("#phone").val(),
		   			newPassword:$("#mm").val()},function(data){
		   			var msg = data.respMsg;
		   				if(data.respCode=="01"){
		   					window.location.href="api/kehu/toLogin.do";
		   				}else{
		   					 layer.open({
						     content:msg
						    ,skin: 'msg'
						    ,time: 2 //2秒后自动关闭
						  });
		   				}
		   			});
		   		}else{
		   			//提示
						  layer.open({
						    content: '两次密码输入不一致!'
						    ,skin: 'msg'
						    ,time: 2.5 //2秒后自动关闭
						  });
		   		}
	   		}else{
	   			//提示
				  layer.open({
				     content: '密码长度必须是6-11位'
				    ,skin: 'msg'
				    ,time: 2.5 //2秒后自动关闭
				  });
	   		}
	   	}else{
	   		//提示
			  layer.open({
			     content: '密码必须是6-11位字母加数字组成。'
			    ,skin: 'msg'
			    ,time: 2 //2秒后自动关闭
			  });
	   	}
   }
</script>
</body>
</html>