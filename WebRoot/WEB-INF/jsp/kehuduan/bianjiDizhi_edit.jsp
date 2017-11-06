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
    <link rel="stylesheet" href="static/css/wm/layer.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/city-picker.js"></script>
    <script src="static/js/wm/layer.js"></script>
    <title>编辑地址</title>
    <style>
        .shenfen>.bg1{
            background-color:#0283fb;
            color:#fff;
        }
        .biaoqian>.bg1{
            background-color:#0283fb;
            color:#fff;
        }
		.moren>.bg1{
            background-color:#0283fb;
            color:#fff;
        }
        .moren{
        	width: 100%;
		    height: 32px;
		    line-height: 32px;
		    margin-top: 15px;
		    overflow: hidden;
        }
        .moren>span{
        	display: block;
		    width: 20%;
		    text-align: center;
		    height: 32px;
		    line-height: 32px;
		    color: #fff;
		    background-color: #bfbfbf;
		    border-radius: 15px;
		    margin-right: 6%;
		    float: left;
		    font-size: 14px;
        
        }
        .moren>a{
       	    display: block;
		    width: 20%;
		    text-align: center;
		    height: 32px;
		    line-height: 32px;
		    color: #0283fb;
		    background-color: #fff;
		    border-radius: 15px;
		    border: 1px solid #0283fb;
		    margin-right: 4%;
		    float: left;
		    font-size: 14px;
        }

        #address{
            height:40px;
            width:88%;
            float: right;
            margin-top:4px;
        }
        .weui-picker-modal{
            height:250px;
        }
        .toolbar .toolbar-inner{
            height:40px;
        }
        .toolbar .title{
            line-height: 40px;;
        }
        .toolbar .picker-button{
            height:40px;
            line-height: 40px;;
        }
        .weui-picker-modal .picker-modal-inner{
            height:150px;
        }
        .btn{
          	width: 100%;
        }
        input::-webkit-input-placeholder {
		  color: #999 ;
		}
		.userDiv>input {
		    color: #333;
		} 
    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header id="header">
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>编辑地址</h1>
    </div>
</header>
<form id="Form" action="api/kehu/${msg }.do?shouhuo_address_id=${pd.shouhuo_address_id}&tag=${tag }&user_shangjia_id=${user_shangjia_id}" method="post" >
	<input type="hidden" id="sex" name="sex" value=""/>
	<input type="hidden" id="lable" name="lable" value=""/>
	<input type="hidden" id="isDefault" name="isDefault" value=""/>
	<div class="contentDiv">
	    <div class="content">
	        <div class="userDiv">
	            <span id="names">联系人</span>
	            <input type="text" name="linkmanName" id="linkmanName" value="${pd.linkmanName}" placeholder="联系人姓名"/>
	        </div>
	        <div class="userDiv">
	            <span>联系电话</span>
	            <input type="text" name="phone" id="phone" value="${pd.phone}" onkeyup="value=value.replace(/[\W]/g,'')" placeholder="联系人手机号码" maxlength="11"/>
	        </div>
	        <div class="userDiv">
	            <span>当前位置</span>
	            <p>
		            <i class="iconfont icon-dingwei"></i>
		            <input class="weui-input wab" name="address" id="address" value="${pd.address}" type="text"  placeholder="请选择" readonly="" data-code="420106" data-codes="420000,420100,420106">
		            <input type="hidden" value="${pd.latitude}" name="lat" class="lat" />
	        		<input type="hidden" value="${pd.longitude}" name="lng" class="lng" />
	        		<input type="hidden" value="${lats }" name="lats"/>
	        		<input type="hidden" value="${lngs }" name="lngs"/>
	            </p>
	        </div>
	        <div class="userDiv">
	            <span>详细地址</span>
	            <input type="text" name="detailAddress" id="detailAddress" value="${pd.detailAddress}"  placeholder="送餐详细地址"/>
	        </div>
	        <div class="shenfen">
	            <span id="identitys">身份</span>
            	<a href="javascript:void(0)">先生</a>
            	<a href="javascript:void(0)">女士</a>
	        </div>
	        <div class="biaoqian">
	            <span id="biaoqiansy">标签</span>
	            <a href="javascript:void(0)">家</a>
	            <a href="javascript:void(0)">公司</a>
	            <a href="javascript:void(0)">学校</a>
	        </div>
	         <div class="moren">
	            <span id="shezhi">设为默认</span>
	            <a href="javascript:void(0)">是</a>
	            <a href="javascript:void(0)">否</a>
	        </div>
		    <div class="weui-btn-area">
		        <a class="weui-btn weui-btn_primary" href="javascript:void(0)" onclick="edit();" id="showTooltips">保存修改地址 </a>
		        <a href="api/kehu/shouhuoDizhi.do?tag=2" class="weui-btn weui-btn_warn">取消</a>
	    	</div>
	    </div>
	</div>
	<iframe id="mapPage" width="100%" height="" frameborder=0 style="display: none;"
            src="http://apis.map.qq.com/tools/locpicker?search=1&type=1&policy=1&coordtype=5&backurl=http://3gimg.qq.com/lightmap/components/locationPicker2/back.html&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=myapp">
    </iframe>
</form>
<script>
    $(function() {//页面初始化时
         FastClick.attach(document.body);
         var shenfen = "${pd.identity}";//定义获取服务端的值
         var lable = "${pd.lable}";//定义获取服务端的值
         var isDefault = "${pd.isDefault}";//定义获取服务端的值
         
         $(".shenfen>a").each(function(){//循环遍历
         	if($(this).text()==shenfen){//判断服务端返回的值满足，相等‘先生’或‘女士’，就是显示什么（‘先生’或‘女士’）。
         		$(this).addClass("bg1");//显示默认值（先生或者女士）
         		$("#sex").val($(this).text());//如果不选择原来的赋值到隐藏域
         	}
         });
         $(".biaoqian>a").each(function(){//循环遍历
         	if($(this).text()==lable){//判断服务端返回的值满足，相等‘家’或‘公司’或‘学校’，就是显示什么（‘家’或‘公司’或‘学校’）。
         		$(this).addClass("bg1");//显示默认值‘家’或‘公司’或‘学校’。
         		$("#lable").val($(this).text());//赋值到隐藏域
         	}
         });
       
		$(".moren>a").each(function() {//循环遍历【id=“moren”】，id为“moren”（默认）下的a标签（each() 方法规定为每个匹配元素规定运行的函数，遍历显示默认选择中的值）
			if (isDefault == "1") {//判断服务返回的默认值“1”或者“0”，如果是‘1’或者‘0’；重新定义为‘是’或者‘否’
				var isDefaults = "是";//定义为‘是’
				if ($(this).text() == isDefaults) {//判断如果满足‘是’=‘是’
					$(this).addClass("bg1");//显示默认‘是’
					$("#isDefault").val("1");//赋值到隐藏域
				}
			} else {//否则
				var isDefaults = "否";//定义为‘否’
				if ($(this).text() == isDefaults) {//判断如果满足条件为 ‘否’ = ‘否’
					$(this).addClass("bg1");//显示默认否
					$("#isDefault").val("0");//赋值到隐藏域
				}
			}
		});
	});
	$(function() {
		$(".shenfen>a").click(function() {
			$(this).addClass("bg1");
			$(this).siblings("a").removeClass("bg1");
			$("#sex").val($(this).text());
		});
		$(".biaoqian>a").click(function() {
			$(this).addClass("bg1");
			$(this).siblings("a").removeClass("bg1");
			$("#lable").val($(this).text());
		});
		$(".moren>a").click(function() {
			$(this).addClass("bg1");
			$(this).siblings("a").removeClass("bg1");
			if ($(this).text() == "是") {
				$("#isDefault").val("1");
			} else {
				$("#isDefault").val("0");
			}
		});
		/*   $("#address").cityPicker({
		      title: "选择出发地",
		      onChange: function (picker, values, displayValues) {
		          console.log(values, displayValues);
		      }
		  }); */
	});

	//验证手机格式的正则表达是
	var phoneReg = /^1[3-9]\d{9}$/;
	var mobileRule = /^(1[3|4|5|8])[0-9]{9}$/;
	//保存
	function edit() {
		var linkmanName = $("#linkmanName").val();//联系人
		var phone = $("#phone").val();//联系电话
		var address = $("#address").val();//所在地址
		var detailAddress = $("#detailAddress").val();//详细地址
		var identity = $("#sex").val();//身份
		var lable = $("#lable").val();//标签
		var isDefault = $("#isDefault").val();//默认地址
		if (linkmanName == "") {//姓名
			layer.tips('请输入您的真实姓名！', '#names', {
				tips : [ 1, '#D9006C' ],
				time : 3000
			});
			return;
		}
		if (phone == "") {//手机号码
			layer.tips('请您输入正确的手机号码！', '#phone', {
				tips : [ 1, '#D9006C' ],
				time : 3000
			});
			return;
		}
		//判断手机号码是否合法
		if (!phoneReg.test(phone)) {
			layer.tips('手机号码格式不正确！', '#phone', {
				tips : [ 1, '#D9006C' ],
				time : 3000
			});
			return;
		}
		if (address == "") {//所在地址
			layer.tips('请填写所在地址！', '#address', {
				tips : [ 1, '#D9006C' ],
				time : 3000
			});
			return;
		}
		if (detailAddress == "") {//详细地址
			layer.tips('请填写详细地址！', '#detailAddress', {
				tips : [ 1, '#D9006C' ],
				time : 3000
			});
			return;
		}
		/* if(identity==""){//
			layer.tips('请选择身份！', '#identitys', {
		 		  tips: [1, '#D9006C'],
		 		  time: 3000
		 	});
			return;
		}
		if(lable==""){//
			layer.tips('请选择标签！', '#biaoqiansy', {
		 		  tips: [1, '#D9006C'],
		 		  time: 3000
		 	});
			return;
		}
		if(isDefault==""){//
			layer.tips('请选择默认地址！', '#shezhi', {
		 		  tips: [1, '#D9006C'],
		 		  time: 3000
		 	});
			return;
		} */
		$("#Form").submit();
	}
</script>
<script>
    $(function(){
        $("#mapPage").height($(window).height());
    });
    $(".wab").click(function(){
        $("#mapPage").show();
        $(".contentDiv").hide();
        $("#header").hide();
        window.addEventListener('message', function(event) {
            // 接收位置信息，用户选择确认位置点后选点组件会触发该事件，回传用户的位置信息
            var loc = event.data;
            if (loc && loc.module == 'locationPicker') {//防止其他应用也会向该页面post信息，需判断module是否为'locationPicker'
                $(".wab").val(loc.poiaddress);
                /*   console.log(loc.latlng.lat);
                 console.log(loc.latlng.lng); */
                $(".lng").val(loc.latlng.lng);
                $(".lat").val(loc.latlng.lat);
                $("#mapPage").hide();
                $(".contentDiv").show();
                $("#header").show();
            }
        }, false);
    });

</script>
</body>
</html>

