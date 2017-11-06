<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8" />
		<title></title>
		<meta name="description" content="overview & stats" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link href="static/css/bootstrap.min.css" rel="stylesheet" />
		<link href="static/css/bootstrap-responsive.min.css" rel="stylesheet" />
		<link rel="stylesheet" href="static/css/font-awesome.min.css" />
		<!-- 下拉框 -->
		<link rel="stylesheet" href="static/css/chosen.css" />
		
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		
		<link rel="stylesheet" href="static/css/datepicker.css" /><!-- 日期框 -->
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		
<script type="text/javascript">
	
	$(top.hangge());
	//保存
	function save(){
		/* $("#zhongxin").hide();
		$("#zhongxin2").show(); */
		//验证手机格式的正则表达是
		var phoneRegs=/^1[3-9]\d{9}$/;
		var phoneReg=/^([0-9]{3,4}-)?[0-9]{7,8}$/;
	 	var isMob=/^0\d{2,3}-?\d{7,8}$/;
	 	var weixin=/^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}$/;
		var hotline=$("#hotline").val();
		var weChat=$("#weChat").val();
		if($("#hotline").val()==""){
			$("#hotline").tips({
				side:3,
	            msg:'请输入客服热线电话',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#hotline").focus();
			return false;
		}
		if(!isMob.test(hotline)){
			$("#hotline").tips({
				side:3,
	            msg:'号码格式不正确',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#hotline").focus();
			return false;
		}
		if($("#weChat").val()==""){
			
			$("#weChat").tips({
				side:3,
	            msg:'请输入微信号',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#weChat").focus();
			return false;
		}
		if(!weixin.test(weChat)){
			$("#weChat").tips({
				side:3,
	            msg:'微信号格式不正确',
	            bg:'#AE81FF',
	            time:2
	        });
			
			$("#weChat").focus();
			return false;
		}
		//判断是否已经存在
		var url='suigong/selectBySuigongName.do';
		$.post(url,{"suigong_name":$("#Suigong_name").val()},function(data){
			if("已存在" == data.result){
				$("#Suigong_name").tips({
					side:3,
		            msg:'该名称已存在',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#Suigong_name").focus();
			}else{
				$("#Form").submit();
			}
		});
		$("#Form").submit();
	}
	
</script>
	</head>
<body>
	<form action="h5sys/${msg}.do" name="Form" id="Form" method="post">
		<input type="hidden" name="contact_id" id="contact_id" value="${pd.contact_id}"/>
		<div id="zhongxin">
		<table id="table_report" class="table table-striped table-bordered table-hover">
			<tr>
				<td>客服热线电话:<br><p style="font-size: 8px;color: red;">区号-XXX</p></td>
				<td><input type="text" style="width:95%;" name="hotline" id="hotline" value="${pd.hotline}" maxlength="13" placeholder="请输入客服热线电话号码" title="客服热线电话号码"/></td>
			</tr>
			<tr>
				<td>微信号:</td>
				<td><input type="text" style="width:95%;" name="weChat" id="weChat" value="${pd.weChat}" placeholder="请输入微信号" title="微信号"/></td>
			</tr>
			<tr>
				<td style="text-align: center;"colspan="2">
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>
		</div>
		
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
		
	</form>
	
	
		<!-- 引入 -->
		<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
		<script src="static/js/bootstrap.min.js"></script>
		<script src="static/js/ace-elements.min.js"></script>
		<script src="static/js/ace.min.js"></script>
		<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
		<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
		<script type="text/javascript">
		$(top.hangge());
		$(function() {
			
			//单选框
			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
			
			//日期框
			$('.date-picker').datepicker();
			
		});
		
		</script>
</body>
</html>