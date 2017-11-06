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
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/login.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
   <!--  <script src="plugins/layer/mobile/layer.js"></script> -->
    <script src="static/js/layer/mobile/layer.js"></script>
    <script src="static/js/jquery.tips.js"></script>
    <title>注册</title>
</head>
<body ontouchstart>
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>注册</h1>

    </div>
</header>
<div class="login">
    <form action="">
        <div class="login_t">
            <input type="number" id="phone" placeholder="手机号"/>

            <input type="button" class="img-ver1 weui-input" value="获取验证码" onclick="clickButton(this)">
        </div>
        <div class="login_t">
            <input type="number" id="yzm" placeholder="输入验证码"/>
        </div>
        <div class="login_t">
            <input type="password" id="password" placeholder="设置密码"/>
        </div>
        <div class="login_t">
            <input type="password" id="password2" placeholder="确认密码"/>
        </div>
        <!-- 服务器返回的验证码 -->
        <input type="hidden"  name="fhyzm" id="fhyzm">
        <div class="login_b hover" onclick="register()">注册</div>
    </form>


</div>

<script>
    $(function() {
        FastClick.attach(document.body);
    });

</script>
<script type="text/javascript">
 	var reg = new RegExp(/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/);
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
                       console.log(data.yanzhengma);
	           			 
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
    
    /*注册*/
    function register(){
    	var phone = $("#phone").val();
		var password = $("#password").val();
    	if(phone==''){
	   		$("#phone").tips({
                  side : 1,
                  msg : "手机号码不能为空",
                  bg : '#FF5080',
                  time : 1.5
               });
             $("#phone").focus();
	     	return;
	   }
    	if($("#yzm").val()==''){
        	$("#yzm").tips({
              side : 1,
              msg : "验证码不能为空",
              bg : '#FF5080',
              time : 1.5
           });
         $("#yzm").focus();
        	return;
    }
       if($("#yzm").val()!=$("#fhyzm").val()){
	        	$("#yzm").tips({
                  side : 1,
                  msg : "验证码输入错误！",
                  bg : '#FF5080',
                  time : 1.5
               });
             $("#yzm").focus();
	        	return;
	    }
       if(password==''){
	   		$("#password").tips({
                 side : 1,
                 msg : "密码不能为空",
                 bg : '#FF5080',
                 time : 1.5
              });
            $("#password").focus();
	     	return;
	   }
       if($("#password").val()!=$("#password2").val()){
				$("#password2").tips({
                 side : 1,
                 msg : "两次密码不一致",
                 bg : '#FF5080',
                 time : 1.5
              });
            $("#password2").focus();
	     	return;
		}
       $.ajax({
           url:"api/kehu/register.do",
           type:"post",
           data:{phone:$("#phone").val(),
           	  password:$("#password").val(),
           	  yzm:$("#yzm").val(),
           	  fhyzm:$("#fhyzm").val()},
           success:function(data){
           	if(data.respCode=="01"){
           		//提示
					  layer.open({
					    content: data.respMsg
					    ,skin: 'msg'
					    ,time: 1.5 //2秒后自动关闭
					  });
                		setTimeout( function(){
	    		        	 window.location.href="api/kehu/toLogin.do";
	    		        },1000);
           	}else{
           		  layer.open({
					    content: data.respMsg
					    ,skin: 'msg'
					    ,time: 1.5 //2秒后自动关闭
					  });
           	}
               
           },
           error:function(e){
               alert("出错误啦！！");
               //window.clearInterval(timer);
           }
       }); //ajax end
    	
    			
			   
			     
			     
    		 /* if(reg.test($("#mm").val())){
    		  	if($("#mm").val().length>=6 && $("#mm").val().length<11){
			    	 		 $.ajax({
				                url:"api/kehu/register.do",
				                type:"post",
				                data:{phone:$("#phone").val(),
				                	  password:$("#password").val(),
				                	  yzm:$("#yzm").val(),
				                	  fhyzm:$("#fhyzm").val()},
				                success:function(data){
				                	if(data.respCode=="01"){
				                		//提示
										  layer.open({
										    content: data.respMsg
										    ,skin: 'msg'
										    ,time: 1.5 //2秒后自动关闭
										  });
				                     		setTimeout( function(){
						    		        	 window.location.href="api/kehu/toLogin.do";
						    		        },1000);
				                	}else{
				                		  layer.open({
										    content: data.respMsg
										    ,skin: 'msg'
										    ,time: 1.5 //2秒后自动关闭
										  });
				                	}
				                    
				                },
				                error:function(e){
				                    alert("出错误啦！！");
				                    //window.clearInterval(timer);
				                }
				            }); //ajax end
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
	            }*/
	        //else end
    }
</script>
</body>
</html>