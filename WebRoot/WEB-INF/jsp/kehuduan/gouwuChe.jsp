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
    <link rel="stylesheet" href="static/css/wm/weui.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/iconfont.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/gouwuChe.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/swiper.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=f2C9QaeY2zU9joj3Z34DG2gThH70Pwzl"></script>
    <title>购物车</title>
    <style>
        .shangPinDiv{
            position: relative;
        }
        .yuanquan,.yuanquan1{
            position: absolute;
            top:13px;
            left:0;
        }
        .xingxi,.xingxi01{
            position: absolute;
            top:6px;
            right:0;
        }
        .yuanquan,.xingxi{
            z-index: 6;
        }
        .yuanquan1,.xingxi01{
            z-index: 2;
        }
        .shangpinPic{
            position: absolute;
            top:6px;
            left:12%;
        }
        .footer{
            z-index: 500;;
        }
    </style>
</head>
<body ontouchstart>
<!--头部-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>购物车</h1>
        <a href="javascript:void(0)" class="tijiao">编辑</a>
    </div>
</header>
<div class="contentDiv">
    <div class="shangPinDiv">
        <a href="javascript:void(0)" class="yuanquan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <a href="javascript:void(0)" class="yuanquan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <img src="static/images/wm/u132.png" class="shangpinPic" alt=""/>
        <div class="xingxi">
            <p class="line1">家开行代行阿基后火速回溯法交电话费回复分分合合的时刻尅UGG和就是蠢级的呼呼付费</p>
            <p class="line3"><span>￥</span><span>1</span> <del>2435</del></p>
            <a href="javascript:void(0)" class="shuliang">x<span>11</span></a>
        </div>
        <div class="xingxi01">
            <p class="jiajian"><a href="javascript:void(0)" class="jian">-</a><span>1</span><a href="javascript:void(0)" class="jia">+</a></p>
        </div>
    </div>
    <div class="shangPinDiv">
        <a href="javascript:void(0)" class="yuanquan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <a href="javascript:void(0)" class="yuanquan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <img src="static/images/wm/u132.png" class="shangpinPic" alt=""/>
        <div class="xingxi">
            <p class="line1">家开行代行阿基后火速回溯法交电话费回复分分合合的时刻尅UGG和就是蠢级的呼呼付费</p>
            <p class="line3"><span>￥</span><span>2</span> <del>2435</del></p>
            <a href="javascript:void(0)" class="shuliang">x<span>12</span></a>
        </div>
        <div class="xingxi01">
            <p class="jiajian"><a href="javascript:void(0)" class="jian">-</a><span>1</span><a href="javascript:void(0)" class="jia">+</a></p>
        </div>
    </div>
    <div class="shangPinDiv">
        <a href="javascript:void(0)" class="yuanquan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <a href="javascript:void(0)" class="yuanquan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <img src="static/images/wm/u132.png" class="shangpinPic" alt=""/>
        <div class="xingxi">
            <p class="line1">家开行代行阿基后火速回溯法交电话费回复分分合合的时刻尅UGG和就是蠢级的呼呼付费</p>
            <p class="line3"><span>￥</span><span>3</span> <del>2435</del></p>
            <a href="javascript:void(0)" class="shuliang">x<span>13</span></a>
        </div>
        <div class="xingxi01">
            <p class="jiajian"><a href="javascript:void(0)" class="jian">-</a><span>1</span><a href="javascript:void(0)" class="jia">+</a></p>
        </div>
    </div>
    <div class="shangPinDiv">
        <a href="javascript:void(0)" class="yuanquan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <a href="javascript:void(0)" class="yuanquan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <img src="static/images/wm/u132.png" class="shangpinPic" alt=""/>
        <div class="xingxi">
            <p class="line1">家开行代行阿基后火速回溯法交电话费回复分分合合的时刻尅UGG和就是蠢级的呼呼付费</p>
            <p class="line3"><span>￥</span><span>4</span> <del>2435</del></p>
            <a href="javascript:void(0)" class="shuliang">x<span>14</span></a>
        </div>
        <div class="xingxi01">
            <p class="jiajian"><a href="javascript:void(0)" class="jian">-</a><span>1</span><a href="javascript:void(0)" class="jia">+</a></p>
        </div>
    </div>
    <div class="shangPinDiv">
        <a href="javascript:void(0)" class="yuanquan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <a href="javascript:void(0)" class="yuanquan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <img src="static/images/wm/u132.png" class="shangpinPic" alt=""/>
        <div class="xingxi">
            <p class="line1">家开行代行阿基后火速回溯法交电话费回复分分合合的时刻尅UGG和就是蠢级的呼呼付费</p>
            <p class="line3"><span>￥</span><span>5</span> <del>2435</del></p>
            <a href="javascript:void(0)" class="shuliang">x<span>15</span></a>
        </div>
        <div class="xingxi01">
            <p class="jiajian"><a href="javascript:void(0)" class="jian">-</a><span>1</span><a href="javascript:void(0)" class="jia">+</a></p>
        </div>
    </div>
    <div class="shangPinDiv">
        <a href="javascript:void(0)" class="yuanquan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <a href="javascript:void(0)" class="yuanquan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
        <img src="static/images/wm/u132.png" class="shangpinPic" alt=""/>
        <div class="xingxi">
            <p class="line1">家开行代行阿基后火速回溯法交电话费回复分分合合的时刻尅UGG和就是蠢级的呼呼付费</p>
            <p class="line3"><span>￥</span><span>1</span> <del>2435</del></p>
            <a href="javascript:void(0)" class="shuliang">x<span>16</span></a>
        </div>
        <div class="xingxi01">
            <p class="jiajian"><a href="javascript:void(0)" class="jian">-</a><span>1</span><a href="javascript:void(0)" class="jia">+</a></p>
        </div>
    </div>
</div>
<div class="footer">
    <a href="javascript:void(0)" class="quanxuan"><img src="static/images/wm/yuanquan.png" alt=""/></a>
    <a href="javascript:void(0)" class="quanxuan1"><img src="static/images/wm/yuanquan.png" alt=""/></a>
    <span class="quanxuanSpan">全选</span>
    <span class="hejiSpan">合计：</span>
    <span class="jineSpan">￥0</span>
    <span class="yunfeiSpan">不含运费</span>
    <a href="javascript:void(0)" class="jiesuan">结算</a>
    <a href="javascript:void(0)" class="shanchu">删除</a>
</div>
<!-- 底栏 -->
<%@include file="buttom.jsp" %>
<script>
    $(function () {
        FastClick.attach(document.body);
        $("#t2").addClass("weui-bar__item--on").siblings().removeClass("weui-bar__item--on");
    });
</script>
<!--排序-->
<script>
    $(function(){
        $(".paixuUl>li").click(function(){
            $(this).find("a").addClass("paixuOn");
            $(this).siblings().find("a").removeClass("paixuOn");
        });
        var wid1=$(".shangPinDiv").width();
        var wid2=$(".yuanquan").width();
        $(".xingxi").width(wid1-wid2-90);
        $(".xingxi01").width(wid1-wid2-90);
    });
</script>
<!--选择-->
<script>
    $(function(){
        $(".yuanquan").click(function(){
            if($(this).find("img").hasClass("xuan")){
                $(this).find("img").attr("src","static/images/wm/yuanquan.png").removeClass("xuan");
            }else{
                $(this).find("img").attr("src","static/images/wm/xuanzhe.png").addClass("xuan");
            }
            var m=0;
            var num=[];
            var price=[];
            var sum=[];
            var zongjia=0;
            $.each($(".yuanquan"),function(){
                if($(this).find("img").hasClass("xuan")){
                    m+=1;
                    price.push(parseInt($(this).next().next().next().find(".line3>span:nth-child(2)").text()));
                    num.push(parseInt($(this).next().next().next().find(".shuliang>span").text()));
                }
            });
            for(var i=0;i<price.length;i++){
                sum[i]=price[i]*num[i];
            }
            for(var i=0;i<sum.length;i++){
                zongjia+=sum[i]
            }
            $(".jineSpan").html("￥"+zongjia);
            if(m==$(".yuanquan").length){
                $(".quanxuan").find("img").attr("src","static/images/wm/xuanzhe.png").addClass("quan");
            }else{
                $(".quanxuan").find("img").attr("src","static/images/wm/yuanquan.png").removeClass("quan");
            }
        });
        $(".quanxuan").click(function(){
            var num1=[];
            var price1=[];
            var sum1=[];
            var zongjia1=0;
            if($(this).find("img").hasClass("quan")){
                $(this).find("img").attr("src","static/images/wm/yuanquan.png").removeClass("quan");
                $(".yuanquan").find("img").attr("src","static/images/wm/yuanquan.png").removeClass("xuan");
                $.each($(".yuanquan"),function(){
                    if($(this).find("img").hasClass("xuan")){
                        price1.push(parseInt($(this).next().next().next().find(".line3>span:nth-child(2)").text()));
                        num1.push(parseInt($(this).next().next().next().find(".shuliang>span").text()));
                    }
                });
                for(var i=0;i<price1.length;i++){
                    sum1[i]=price1[i]*num1[i];
                }
                for(var i=0;i<sum1.length;i++){
                    zongjia1+=sum1[i]
                }
                $(".jineSpan").html("￥"+zongjia1);
                
            }else {
                $(this).find("img").attr("src", "static/images/wm/xuanzhe.png").addClass("quan");
                $(".yuanquan").find("img").attr("src", "static/images/wm/xuanzhe.png").addClass("xuan");
                $.each($(".yuanquan"),function(){
                    if($(this).find("img").hasClass("xuan")){
                        price1.push(parseInt($(this).next().next().next().find(".line3>span:nth-child(2)").text()));
                        num1.push(parseInt($(this).next().next().next().find(".shuliang>span").text()));
                    }
                });
                for(var i=0;i<price1.length;i++){
                    sum1[i]=price1[i]*num1[i];
                }
                for(var i=0;i<sum1.length;i++){
                    zongjia1+=sum1[i]
                }
                $(".jineSpan").html("￥"+zongjia1);
                $(".yuanquan").click(function () {
                    var m=0;
                    $.each($(".yuanquan"),function(){
                        if($(this).find("img").hasClass("xuan")){
                            m+=1;
                        }
                    });
                    if(m==$(".yuanquan").length){
                        $(".quanxuan").find("img").attr("src","static/images/wm/xuanzhe.png").addClass("quan");
                    }else{
                        $(".quanxuan").find("img").attr("src","static/images/wm/yuanquan.png").removeClass("quan");
                    }
                });
            }
        });
    })
</script>

<!--购物车加减-->
<script>
    $(function(){
        $(".jia").click(function(){
            var n=$(this).prev("span").text();
            n++;
            $(this).prev("span").text(n);
        });
        $(".jian").click(function(){
            var n=$(this).next("span").text();
            n--;
            if(n<1){
                n=1;
            }
            $(this).next("span").text(n);
        })
    })
</script>
<!--编辑-->
<script>
    $(function(){
        $(".tijiao").click(function(){
            if($(this).hasClass("wanc")){
                $(this).removeClass("wanc");
                $(this).text("编辑");
                $(".hejiSpan").show();
                $(".jineSpan").show();
                $(".yunfeiSpan").show();
                $(".shanchu").css("display","none");
                $(".jiesuan").css("display","block");
                $(".xingxi01").css("display","none");
                $(".xingxi").css("display","block");
                $(".quanxuan").css("display","block");
                $(".quanxuan1").css("display","none");
                $(".yuanquan").css("display","block");
                $(".yuanquan1").css("display","none");
                for(var i=0;i<$(".shangPinDiv").length;i++){
                    $(".shangPinDiv").eq(i).children(".xingxi").find(".shuliang").children("span").html($(".shangPinDiv").eq(i).children(".xingxi01").find("span").text());
                }
                var num2=[];
                var price2=[];
                var sum2=[];
                var zongjia2=0;
                $.each($(".yuanquan"),function(){
                    if($(this).find("img").hasClass("xuan")){
                        price2.push(parseInt($(this).next().next().next().find(".line3>span:nth-child(2)").text()));
                        num2.push(parseInt($(this).next().next().next().find(".shuliang>span").text()));
                    }
                });
                for(var i=0;i<price2.length;i++){
                    sum2[i]=price2[i]*num2[i];
                }
                for(var i=0;i<sum2.length;i++){
                    zongjia2+=sum2[i]
                }
                $(".jineSpan").html("￥"+zongjia2);
            }else{
                $(this).addClass("wanc");
                $(this).text("完成");
                $(".hejiSpan").hide();
                $(".jineSpan").hide();
                $(".yunfeiSpan").hide();
                $(".shanchu").css("display","block");
                $(".jiesuan").css("display","none");
                $(".xingxi01").css("display","block");
                $(".xingxi").css("display","none");
                $(".quanxuan").css("display","none");
                $(".quanxuan1").css("display","block");
                $(".yuanquan").css("display","none");
                $(".yuanquan1").css("display","block");
                for(var i=0;i<$(".shangPinDiv").length;i++){
                    $(".shangPinDiv").eq(i).children(".xingxi01").find("span").html($(".shangPinDiv").eq(i).children(".xingxi").find(".shuliang").children("span").text());
                }
            }
            $(".yuanquan1").click(function(){
                if($(this).find("img").hasClass("xuan")){
                    $(this).find("img").attr("src","static/images/wm/yuanquan.png").removeClass("xuan");
                }else{
                    $(this).find("img").attr("src","static/images/wm/xuanzhe.png").addClass("xuan");
                }
                var m=0;
                $.each($(".yuanquan1"),function(){
                    if($(this).find("img").hasClass("xuan")){
                        m+=1;
                    }
                });
                if(m==$(".yuanquan1").length){
                    $(".quanxuan1").find("img").attr("src","static/images/wm/xuanzhe.png").addClass("quan");
                }else{
                    $(".quanxuan1").find("img").attr("src","static/images/wm/yuanquan.png").removeClass("quan");
                }
                 $(".shanchu").click(function(){
                     for(var j=0;j<$(".yuanquan1").length;j++){
                         if($(".yuanquan1").eq(j).children("img").hasClass("xuan")){
                             $(".yuanquan1").eq(j).parent().remove();
                         }
                     };
                 });
            });
            $(".quanxuan1").click(function(){
                if($(this).find("img").hasClass("quan")){
                    $(this).find("img").attr("src","static/images/wm/yuanquan.png").removeClass("quan");
                    $(".yuanquan1").find("img").attr("src","static/images/wm/yuanquan.png").removeClass("xuan");
                }else {
                    $(this).find("img").attr("src", "static/images/wm/xuanzhe.png").addClass("quan");
                    $(".yuanquan1").find("img").attr("src", "static/images/wm/xuanzhe.png").addClass("xuan");

                    $(".yuanquan1").click(function () {
                        var m=0;
                        $.each($(".yuanquan1"),function(){
                            if($(this).find("img").hasClass("xuan")){
                                m+=1;
                            }
                        });
                        if(m==$(".yuanquan1").length){
                            $(".quanxuan1").find("img").attr("src","static/images/wm/xuanzhe.png").addClass("quan");
                        }else{
                            $(".quanxuan1").find("img").attr("src","static/images/wm/yuanquan.png").removeClass("quan");
                        }
                    });
                }
                $(".shanchu").click(function(){
                    for(var j=0;j<$(".yuanquan1").length;j++){
                        console.log($(".yuanquan1").eq(j).children("img"));
                        if($(".yuanquan1").eq(j).children("img").hasClass("xuan")){
                            $(".yuanquan1").eq(j).parent().remove();
                        }
                    };
                });
            });
        });

    })
</script>

</body>
</html>