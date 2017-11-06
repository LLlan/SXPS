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
    <link rel="stylesheet" href="../css/wmpc/weui1.css">
    <link rel="stylesheet" href="../css/wmpc/weui.css">
    <link rel="stylesheet" href="../css/wmpc/weui.min.css">
    <link rel="stylesheet" href="../css/wmpc/jquery-weui.css">
    <link rel="stylesheet" href="../css/wmpc/font-awesome.css">
    <link rel="stylesheet" href="../css/wmpc/style-mine.css">
    <link rel="stylesheet" href="../css/wmpc/index.css">
    <script src="../js/wmpc/jquery-2.1.4.js"></script>
    <script src="../js/wmpc/fastclick.js"></script>
    <script src="../js/wmpc/jquery.nav.js"></script>
    <script src="../js/wmpc/jquery-weui.js"></script>
    <title>在线支付</title>
    <style>
        body{
            background-color: #F0F0F0;
        }
    </style>
</head>
<body>
<div id="header" style="background-color: #068dff;">
    <h1 class="title">确认订单</h1>
    <a href="javascript:history.go(-1)" class="icon1"><i class="icon-angle-left "></i></a>
</div>
<!--主体-->
<div class="weui-content" style="padding-top: 60px;">
    <div class="weui-panel weui-panel_access">
        <div class="weui-panel__hd">
            <div class="payment">支付剩余时间</div>
            <div class="time">
                <span id="t_m">00分</span>
                <span id="t_s">00秒</span>
            </div>
        </div>
    </div>
    <div class="weui_cells weui_cells_access" style="margin-top: 0;">
        <a class="weui_cell" href="#">
            <div class="weui_cell_bd weui_cell_primary ">
                <p>合计：</p>
            </div>
            <div class="price_ft cart-total-txt"><i>￥</i><em class="num font-16" >172</em></div>
        </a>
    </div>
    <div class="weui-cells weui-cell_access" style="margin-top: 5px;">
        <a class="weui-cell" href="javascript:;" style="color: #000;">
            <div class="weui-cell__bd weui-cell_primary">
                <p>支付方式</p>
            </div>
            <div class="weui-cell__ft" id="zhifu">微信支付</div>
        </a>
    </div>
    <p class="zhifu1" style="margin-top: 2px;">合计<span>￥38</span></p>
    <p class="fangshi">选择支付方式</p>
    <div class="weixinZ" style="height: 60px;margin-bottom: 10px;">
        <p style="top: 7px;">
            <img src="../images/wmpc/weixin_03.png" alt=""/>
            <span style="top: 11px;font-size: 16px;">微信支付</span>
            <a class=" weui-cells_checkbox" style="top: 0;">
                <label class="weui-cell weui-check__label check1" for="s11">
                    <input type="checkbox" class="weui-check" name="checkbox1" id="s11" >
                    <i class="weui-icon-checked"></i>
                </label>
            </a>
        </p>
    </div>
    <div class="weixinZ" style="height: 60px;">
        <p style="top: 7px;">
            <img src="../images/wmpc/zfb.png" alt=""/>
            <span style="top: 11px;font-size: 16px;">支付宝支付</span>
            <a class=" weui-cells_checkbox" style="top: 0;">
                <label class="weui-cell weui-check__label check2" for="s12">
                    <input type="checkbox" class="weui-check" name="checkbox2" id="s12">
                    <i class="weui-icon-checked"></i>
                </label>
            </a>
        </p>
    </div>
    <a href="#" class="querenZ">确认支付<span>￥38.00</span></a>
</div>
<!--底部-->
<!--<div class="weui-btn-area">
    <input class="weui-btn weui-btn_warn" type="button" value="确定支付">
</div>-->
<script>
    $(function () {
        FastClick.attach(document.body);
    });
    $("#zhifu").select({
        title: "选择支付方式",
        items: [
            { title: "微信支付", value: "1"},
            {title: "支付宝",value: "2"},
        ],
        onChange:function(arg){
            console.log(arg);
           /* $('#pay_method').val( arg['values'] );*/
            $("#zhifu").text( arg['titles'] );
        }
    });
</script>
<script>
    function GetRTime(){
        var EndTime= new Date();
        var NowTime = new Date();
        var t =EndTime.getTime()+588000 - NowTime.getTime();
        var set=setInterval(function(){
           --t
            var m=Math.floor(t/1000/60%60);
            var s=Math.floor(t/1000%60);
            document.getElementById("t_m").innerHTML = m+":";
            document.getElementById("t_s").innerHTML = s;
        }, 1000)
        setTimeout(function(){

            clearInterval(set);
        }, 60000);
    }
    setInterval(GetRTime,0);
</script>
<script>
    $(function(){
        $(".check1 input").click(function(){
            $(".check1 input").attr("checked",true);
            $(".check2 input").attr("checked",false);
        })
        $(".check2 input").click(function(){
            $(".check2 input").attr("checked",true);
            $(".check1 input").attr("checked",false);
        })
    })
</script>
</body>
</html>