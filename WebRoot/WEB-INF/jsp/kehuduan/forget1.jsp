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
    <title>找回密码</title>
</head>
<body>
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>找回密码</h1>
    </div>
</header>
<div class="login">
    <form action="api/kehu/wangjimima.do?tag=2&phone=${phone}" method="post" id="subForm">
        <div class="login_t">
            <input type="text" id="phone" name="phone" placeholder="手机号" maxlength="11" />
            <input type="button" class="img-ver1 weui-input" value="获取验证码" onclick="clickButton(this)">
        </div>
        <div class="login_t">
            <input type="text" id="yzm" maxlength="6" placeholder="输入验证码"/>
        </div>
        <input type="hidden" id="fhyzm">
        <a href="javascript:void(0)" onclick="next()" class="login_b hover">下一步</a>
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
	 var phoneReg=/^1[3-9]\d{9}$/;
    function clickButton(obj){
         if($("#phone").val()!=""&&phoneReg.test($("#phone").val())){
        var obj = $(obj);
        obj.attr("disabled","disabled");/*按钮倒计时*/
        var time = 60;
        var set=setInterval(function(){
            obj.val(--time+"(s)");
        }, 1000);/*等待时间*/
        setTimeout(function(){
            obj.attr("disabled",false).val("重新获取");/*倒计时*/
            clearInterval(set);
        }, 60000);
        
	        //请求获取验证码
	          $.ajax({
	             type: "post",
	             url: "api/kehu/getSms.do",
	             data: {phone:$("#phone").val()},
	             dataType: "json",
	             success: function(data){
		             //	将返回的验证码赋到隐藏域中，用于注册带过去
                       $("#fhyzm").val(data.yanzhengma);
                       console.log(data.yanzhengma)
	           			 
	              }
	         });
		         
           }else{
        		 //提示
				  layer.open({
				    content: '手机号码格式不正确!'
				    ,skin: 'msg'
				    ,time: 2 //2秒后自动关闭
				  });
        }
    }
    
    function next(){
    	if($("#fhyzm").val()==$("#yzm").val()){
    		$("#subForm").submit();
    	}else{
    		 //提示
			  layer.open({
			    content: '验证码不正确!'
			    ,skin: 'msg'
			    ,time: 2 //2秒后自动关闭
			  });
    	}
    }
</script>
</body>
</html>