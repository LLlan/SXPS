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
    <link rel="stylesheet" href="static/css/wm/iconfont.css">
    <link rel="stylesheet" href="static/css/wm/jquery-weui.css">
    <link rel="stylesheet" href="static/css/wm/yahu.css"/>
    <link rel="stylesheet" href="static/css/wm/commen.css"/>
    <link rel="stylesheet" href="static/css/wm/myeval.css"/>
    <script src="static/js/wm/jquery-2.1.4.js"></script>
    <script src="static/js/wm/fastclick.js"></script>
    <script src="static/js/wm/jquery-weui.js"></script>
    <script src="static/js/wm/starScore.js"></script>
    <script src="static/js/wm/starScore1.js"></script>
	<link rel="stylesheet" href="static/css/wm/layer.css"/>
    <script src="static/js/wm/layer.js"></script>
    <title>订单评价</title>
</head>
<body>
<!--头部开始-->
<header>
    <div class="header">
        <a href="javascript:history.go(-1)" class="iconfont icon-toLeft-copy back"></a>
        <h1>订单评价</h1>
    </div>
</header>
<form id="Form" action="api/kehu/${msg }.do?order_takeou_id=${order_takeou_id}" method="post" >
	<div class="comment">
	    <div class="eval">
	        <div class="eval_t">
	            <!-- <img src="static/images/wm/mj10.jpg" alt=""/> -->
	            <img src="<%=basePath%>${pd.logoImg }" alt=""/>
	            ${pd.shopName }
	        </div>
	        <div class="eval_t1">
	            <div class="row">
	                <b></b>
	                <h5>为商家服务评分</h5>
	                <b></b>
	            </div>
	        </div>
	        <input type="hidden" name="sjscore" value="" id="sjscore">
	        <div id="startone"  class="block clearfix" >
	            <div class="star_score" id="sjstartone"></div>
	            <!--<p style="float:left;">您的评分：<span class="fenshu"></span> 分</p>-->
	        </div>
	        <input type="hidden" name="sjlabel" value="" id="sjlabel">
	        <input type="hidden" name="sjlabelid" value="" id="sjlabelid">
	        <ul class="assess_mi sj">
	        	<c:forEach items="${sysLabelList }" var="sysLabelList">
		        	<c:if test="${sysLabelList.type=='1' }">
		        		<li tName="${sysLabelList.type}" tid="${sysLabelList.label_id}">${sysLabelList.labelName }</li>
		        	</c:if>
	        	</c:forEach>
	        </ul>
	        <div class="textarea">
	            <textarea name="sjcontent" id="sjcontent" placeholder="说说哪里满意，请大家选择" ></textarea>
	            <span>0/140个字</span>
	        </div>
	    </div>
	    <div class="eval1">
	        <div class="eval_t1">
	            <div class="row">
	                <b></b>
	                <h5>所购买的商品</h5>
	                <b></b>
	            </div>
	        </div>
	        <c:forEach items="${goodsList}" var="pds">
		        <div class="eval_t2">
		            <ul>
		                <li>${pds.goodsName }(中份)</li>
		                <li>x${pds.goodsNum }</li>
		            </ul>
		        </div>
	        </c:forEach>
	    </div>
	    <div class="eval_t3">
	        <ul>
	            <li>送达时间:</li>
	            <li>${l }分钟(${fn:substring(pd.qurysdTime,10,16)}送达)</li>
	        </ul>
	    </div>
	    <div class="eval">
	        <div class="eval_t1">
	            <div class="row">
	                <b></b>
	                <h5>为骑手服务评分</h5>
	                <b></b>
	            </div>
	        </div>
	        <input type="hidden" name="qsscore" value="" id="qsscore">
	        <div id="startone1" class="block clearfix" >
	            <div class="star_score" id="qsstartone"></div>
	            <!--<p style="float:left;">您的评分：<span class="fenshu"></span> 分</p>-->
	        </div>
	        <input type="hidden" name="qslabel" value="" id="qslabel">
	        <input type="hidden" name="qslabelid" value="" id="qslabelid">
	        <ul class="assess_mi qs">
	            <c:forEach items="${sysLabelList }" var="sysLabelList">
		        	<c:if test="${sysLabelList.type=='2' }">
		        		<li tName="${sysLabelList.type}" tid="${sysLabelList.label_id}" >${sysLabelList.labelName }</li>
		        	</c:if>
	        	</c:forEach>
	        </ul>
	        <div class="textarea">
	            <textarea name="qscontent" id="qscontent" placeholder="说说骑手的服务" ></textarea>
	            <span>0/140个字</span>
	        </div>
	    </div>
	    <div class="submit" onclick="tijiao();" style="z-index: 99999;">提交评论</div>
	</div>
	<input type="hidden" id="type" name="type" value=""/>
	<input type="hidden" id="min" name="min" value=""/>
</form>
<script>
    $(function() {
        FastClick.attach(document.body);
    });
    //评分
    scoreFun($("#startone"));
    scoreFun1($("#startone1"));
    /*选择评语*/
    $(".assess_mi li").click(function(){
        if($(this).hasClass("hover")){
            $(this).removeClass("hover");
        }else{
            $(this).addClass("hover");
        }
    });
    function tijiao(){//提交评论
    	var sjlabel="";//自定义商家标签为空
    	var qslabel="";//自定义骑手评价标签为空
    	var sjlabelid="";//自定义商家id为空
    	var qslabelid="";//自定义骑手id为空
    	var min = "${l}";//骑手送达全程使用的分钟
		$(".sj li").each(function(){//商家评语标签循环遍历
		 	if($(this).hasClass("hover")){//如果标签被选中则有值
		 		if(sjlabel==""){//如果只选一个标签评语，满足赋值
		 			sjlabel=$(this).text();
		 			sjlabelid=$(this).attr("tid");
		 		}else{//否则将多个标签评语拼接起来赋值
		 			sjlabel=sjlabel+","+$(this).text();//多个评语标签拼接
		 			sjlabelid=sjlabelid+","+$(this).attr("tid");//选中多个评语标签的id拼接
		 		}
		 	}
	     });
		$("#sjlabel").val(sjlabel);//将选择的标签赋值给隐藏域
		$("#sjlabelid").val(sjlabelid);//将选择的标签id赋值给隐藏域
		$("#min").val(min);//骑手送达全程使用的分钟
		$(".qs li").each(function(){//骑手评语标签循环遍历
		 	if($(this).hasClass("hover")){
		 		if(qslabel==""){
		 			qslabel=$(this).text();
		 			qslabelid=$(this).attr("tid");
		 		}else{
		 			qslabel=qslabel+","+$(this).text();
		 			qslabelid=qslabelid+","+$(this).attr("tid");
		 		}
		 	}
	     });
		$("#qslabel").val(qslabel);//将选择的标签赋值给隐藏域
		$("#qslabelid").val(qslabelid);//将选择的标签id赋值给隐藏域
		var sjlabel=$("#sjlabel").val();//定义获取值
		var qslabel=$("#qslabel").val();//定义获取值
		var sjscore=$("#sjscore").val();//定义获取值
		var qsscore=$("#qsscore").val();//定义获取值
		var sjcontent=$("#sjcontent").val();//定义获取值
		var qscontent=$("#qscontent").val();//定义获取值
		if(sjscore==''){//商家评分非空判断
			layer.tips('请选择商家评分！', '#sjstartone', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		
		if(sjlabel==''){//商家评语标签非空判断
			layer.tips('请选择商家评语标签！', '.sj', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		
		if(sjcontent==0){//商家评价内容非空判断
			layer.tips('请填写您对商家评价内容！', '#sjcontent', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		
		if(qsscore==''){//骑手评分非空判断
			layer.tips('请选择骑手评分！', '#qsstartone', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		
		if(qslabel==''){//骑手评语标签非空判断
			layer.tips('请选择骑手评语标签！', '.qs', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		
		if(qscontent==0){//骑手评价内容非空判断
			layer.tips('请填写您对骑手评价内容！', '#qscontent', {
	     		  tips: [1, '#D9006C'],
	     		  time: 3000
	     	});
			return;
		}
		$("#Form").submit(); 
	}
    
</script>
</body>
</html>