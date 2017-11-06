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
    <link rel="stylesheet" href="static/css/wm/layer.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/layer.js"></script>
    <title>换绑手机号</title>
    <style>

    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>换绑手机号</h1>
    </div>
</header>
<div class="contentDiv">
    <div class="content">
        <div class="hunbang">
            <input type="text" placeholder="旧手机号" name="phone" id="phone" maxlength="11" class="telInput" style="width: 50%" name="mobile"/>
            <input type="button" class="img-ver1 weui-input yanzheng" id="yanzheng" value="获取验证码" onclick="clickButton(this)">
        </div>
        <input type="hidden" id="zhengqueyzm" name="zhengqueyzm" value="">
        <input type="text" placeholder="请输入验证码" maxlength="6" name="shuruyzm" id="shuruyzm"  class="yanzhengma"/>
        <a href="javascript:void(0);" onclick="yanzhou();">验证后绑定新手机号</a>
    </div>
</div>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    //验证手机格式的正则表达是
	var phoneReg=/^1[3-9]\d{9}$/;
    function clickButton(obj){
        var obj = $(obj);
        var phone=$("#phone").val();
        if(phoneReg.test(phone)){
	        obj.attr("disabled","disabled");/*按钮倒计时*/
	        var time = 60;
	        var set=setInterval(function(){
	            obj.val(--time+"(s)");
	        }, 1000);/*等待时间*/
	        setTimeout(function(){
	            obj.attr("disabled",false).val("重新获取");/*倒计时*/
	            clearInterval(set);
	        }, 60000);
	         $.ajax({
	          		type:"post",
	          		url:"api/kehu/getSms.do",
	          		data:{
	          			"phone":phone
	          		},
	          		dataType:"json",
	          		success:function(data){
	          			if(data.reqCode=='01'){
	          				$("#zhengqueyzm").val(data.yanzhengma);
	          			}else{
	          				layer.tips('获取验证码失败,倒计时结束后,点击重新获取', '#yanzheng', {
	                  		  tips: [1, '#D9006C'],
	                  		  time: 3000
	                  		});
	          			}
	          		}
	          	});
          }else{
          	layer.tips('请您输入正确手机号码！', '#phone', {
        		  tips: [1, '#D9006C'],
        		  time: 3000
        	});
          }
    }
    
    function yanzhou(){
    	var respCode = "${respCode}";
    	var phone=$("#phone").val();//手机号
    	var zhengqueyzm=$("#zhengqueyzm").val();//正确的验证码
		var shuruyzm=$("#shuruyzm").val();//输入的验证码
		 if(phone==""){
			layer.tips('请输入您的手机号码！', '#phone', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		 //判断手机号码是否合法
	   if(!phoneReg.test(phone)){
		   layer.tips('手机号码格式不正确!', '#phone', {
     		  tips: [1, '#D9006C'],
     		  time: 3000
     		});
		   return;
	   }
	    //判断是否获取验证码
	  if(zhengqueyzm==''){
		   layer.tips('请您点击获取验证码!', '#yanzheng', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
	   }
	   if(shuruyzm==""){
			layer.tips('请您输入正确的验证码！', '#shuruyzm', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		 //判断确认验证码是否合法
	   if(zhengqueyzm!=shuruyzm){
		   layer.tips('您输入的验证码不正确！', '#shuruyzm', {
	     		  tips: [1, '#D9006C'],
	     		  time: 2000
	     	});
			return;
	   }
		$.ajax({
    		type:"post",
    		url:"api/kehu/yanzhengPhone.do",
    		data:{
    			"phone":phone,
    		},
    		dataType:"json",
    		success:function(data){
    			if(data.respCode=="01"){
    				window.location.href='api/kehu/newTel.do';
    			}else if(data.respCode=="00"){
    				layer.msg("该账号出错！",{//该账号还未注册，请您去注册！
    		            time:3000,//单位毫秒
    		            shade: [0.8, '#393D49'],
    		            icon:2,//1:绿色对号,2：红色差号,3：黄色问好,4：灰色锁,5：红色不开心,6：绿色开心,7：黄色感叹号
    		        });
    			}
    		}
    	});
    	
    }
</script>
</body>
</html>
