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
    <link rel="stylesheet" href="static/css/wm/zaixianZhifu.css">
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/layer/mobile/layer.js"></script>

    <title>在线支付</title>
    <style>

    </style>
</head>
<body ontouchstart>
<!--主体-->
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>在线支付</h1>
    </div>
</header>
<div class="contentDiv">
    <div class="shijianDiv">
        <p>支付剩余时间</p>
        <p class="time">
            <span id="t_m">15</span>:
            <span id="t_s">00</span>
        </p>
    </div>
    <p class="hejiP">合计 <span>￥${total}</span></p>
    <p class="fangshiP">选择支付方式</p>
    <div class="fangshiDiv">
        <p>
            <img src="static/images/wm/zhifubao.png" alt=""/>
            <span>支付宝</span>
            <a href="javascript:void(0)" class="xuan" tid="支付宝"><img src="static/images/wm/xuanzhe1.png" alt=""/></a>
        </p>
        <p>
            <img src="static/images/wm/weixin.png" alt=""/>
            <span>微信</span>
            <a href="javascript:void(0)" class="xuan" tid="微信"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        </p>
       <!--  <p>
            <img src="static/images/wm/yinhangka.png" alt=""/>
            <span>银行卡</span>
            <a href="javascript:void(0)" class="xuan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        </p>
        <p>
            <img src="static/images/wm/daofu.png" alt=""/>
            <span>货到付款</span>
            <a href="javascript:void(0)" class="xuan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        </p> -->
    </div>
</div>
<div class="footer" onclick="querenzhifu();">
    确认支付￥${total}
</div>

	<form action="" method="post" id="payForm">
    	<%-- 支付方式 --%>
    	<input type="hidden" name="payMethod" id="payMethod" value="支付宝">
    	<%-- 订单的主键ID --%>
    	<input type="hidden" name="order_takeou_id" id="order_takeou_id" value="${order_takeou_id }">
    	<%-- 订单编号 --%>
    	<input type="hidden" name="WIDout_trade_no" id="WIDout_trade_no">
    	<%-- 订单名称 --%>
    	<input type="hidden" name="WIDsubject" id="WIDsubject">
    	<%-- 付款金额 --%>
    	<input type="hidden" name="WIDtotal_fee" id="WIDtotal_fee" value="${total}">
    	<%-- 商品展示网址 --%>
    	<input type="hidden" name="WIDshow_url" id="WIDshow_url" value="">
    	<%-- 商品描述 --%>
    	<input type="hidden" name="WIDbody" id="WIDbody">
    </form>

<script>
    $(function() {
        FastClick.attach(document.body);
    });
</script>
<!--倒计时-->
<script type="text/javascript">
    var intDiff = parseInt(900);//倒计时总秒数量(900秒=15分钟)
    function timer(intDiff){
        window.setInterval(function(){
            var day=0,
                    hour=0,
                    minute=0,
                    second=0;//时间默认值
            if(intDiff > 0){
                minute = Math.floor(intDiff / 60) - (day * 24 * 60) - (hour * 60);
                second = Math.floor(intDiff) - (day * 24 * 60 * 60) - (hour * 60 * 60) - (minute * 60);
            }else if(intDiff == 0){
                //var id =$("#tid").val();
                //location.href="api/h5KeHu/cancelTongchenghujiaoDelete.do?information_tongcheng_id="+id;
                //关闭定时器
                clearInterval(timer);
            }
            if (minute <= 9) minute = '0' + minute;
            if (second <= 9) second = '0' + second;
            $('#day_show').html(day+"天");
            $('#hour_show').html('<s id="h"></s>'+hour+'时');
            $('#t_m').html('<s></s>'+minute);
            $('#t_s').html('<s></s>'+second);
            intDiff--;

        }, 1000);
    }
    $(function(){
        timer(intDiff);
    });
</script>
<!--支付方式-->
<script>
    $(function(){
        $(".xuan").click(function(){
            $(this).removeClass("gou");
            $(this).find("img").attr("src","static/images/wm/xuanzhe1.png");
            $(this).parents().siblings().children("a").find("img").attr("src","static/images/wm/yuanquan.png");
            $("#payMethod").val($(this).attr("tid"));
        });
    });
    
    //定义浏览器
    var browser = {
   	    versions: function () {
   	        var u = navigator.userAgent, app = navigator.appVersion;
   	        return {         //移动终端浏览器版本信息
   	            trident: u.indexOf('Trident') > -1, //IE内核
   	            presto: u.indexOf('Presto') > -1, //opera内核
   	            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
   	            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
   	            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
   	            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
   	            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或uc浏览器
   	            iPhone: u.indexOf('iPhone') > -1, //是否为iPhone或者QQHD浏览器
   	            iPad: u.indexOf('iPad') > -1, //是否iPad
   	            webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
   	        };
   	    }(),
    	language: (navigator.browserLanguage || navigator.language).toLowerCase()
    };
    
  	//点击确认支付
	function querenzhifu(){
			
		//公共参数
		var vNow = new Date();
		var sNow = "";
		sNow += String(vNow.getFullYear());
		(vNow.getMonth() + 1)<10?sNow += "0"+String(vNow.getMonth() + 1):sNow += String(vNow.getMonth() + 1);
		(vNow.getDate())<10?sNow += "0"+String(vNow.getDate()):sNow += String(vNow.getDate());
		(vNow.getHours())<10?sNow += "0"+String(vNow.getHours()):sNow += String(vNow.getHours());
		(vNow.getMinutes())<10?sNow += "0"+String(vNow.getMinutes()):sNow += String(vNow.getMinutes());
		(vNow.getSeconds())<10?sNow += "0"+String(vNow.getSeconds()):sNow += String(vNow.getSeconds());
		(vNow.getMilliseconds())<10?sNow += "00"+String(vNow.getMilliseconds()):(vNow.getMilliseconds())<100?sNow += "0"+String(vNow.getMilliseconds()):sNow += String(vNow.getMilliseconds());
		
		//获取随机六位数
		for(var i=0;i<6;i++)
		{
		    sNow += Math.floor(Math.random()*10);
		}
		console.log(sNow); 
		document.getElementById("WIDout_trade_no").value =  sNow;//订单编号
		document.getElementById("WIDsubject").value = "生鲜配送";//body
		
		if (browser.versions.mobile) {//移动设备中打开
			   var ua = navigator.userAgent.toLowerCase();//获取判断用的对象
			        
			   if (ua.match(/MicroMessenger/i) == "micromessenger") {//在微信中打开
				   if($("#payMethod").val()=="微信"){//选择微信支付
						//提示
						  layer.open({
						    content: '微信支付还未开通,敬请期待'
						    ,skin: 'msg'
						    ,time: 2 //2秒后自动关闭
						  });
						/*var backUri = "http://www.0898yzzx.com/yzlfd/api/wxpay/topay?fuwu_id="+fuwu_id+"&out_trade_no="+WIDout_trade_no+"&WIDtotal_fee="+WIDtotal_fee+"&xingming="+xingming+"&dianhua="+dianhua+"&dizhi="+dizhi+"&beizhu="+beizhu+"&number="+number;//这里要改成自己想回调的方法中去
						backUri = encodeURIComponent(backUri);
						console.log(backUri);
						
						var url="https://open.weixin.qq.com/connect/oauth2/authorize?appid=" 
								+ appid +"&redirect_uri=" + backUri 
								+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect";
						//scope 参数视各自需求而定，这里用scope=snsapi_base 不弹出授权页面直接授权目的只获取统一支付接口的openid,scope=snsapi_userinfo弹出授权页面
						window.location.href=url;
						*/
				    }else{//选择支付宝支付
				    	//$("#payForm").attr("action","api/alipay/pay.do");
				    	//$("#payForm").submit();
				    	window.location.href="api/alipay/pay.do?orderNumber="+sNow+"&order_takeou_id=${order_takeou_id }";
				    }
			   }else{//非微信内打开
				   if($("#payMethod").val()=="微信"){//选择微信支付
						//提示
						  layer.open({
						    content: '微信支付还未开通,敬请期待'
						    ,skin: 'msg'
						    ,time: 2 //2秒后自动关闭
						  });
						/*var backUri = "http://www.0898yzzx.com/yzlfd/api/wxpay/topay?fuwu_id="+fuwu_id+"&out_trade_no="+WIDout_trade_no+"&WIDtotal_fee="+WIDtotal_fee+"&xingming="+xingming+"&dianhua="+dianhua+"&dizhi="+dizhi+"&beizhu="+beizhu+"&number="+number;//这里要改成自己想回调的方法中去
						backUri = encodeURIComponent(backUri);
						console.log(backUri);
						
						var url="https://open.weixin.qq.com/connect/oauth2/authorize?appid=" 
								+ appid +"&redirect_uri=" + backUri 
								+ "&response_type=code&scope=snsapi_base&state=123#wechat_redirect";
						//scope 参数视各自需求而定，这里用scope=snsapi_base 不弹出授权页面直接授权目的只获取统一支付接口的openid,scope=snsapi_userinfo弹出授权页面
						window.location.href=url;
						*/
				    }else{//选择支付宝支付
				    	$("#payForm").attr("action","api/alipay/alipay.do");
				    	$("#payForm").submit();
				    }
			   }
		} else {//PC浏览器打开
				    
		}
	}
</script>
</body>
</html>
