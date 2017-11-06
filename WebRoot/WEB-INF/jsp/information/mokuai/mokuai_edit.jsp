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
		<link rel="stylesheet" href="static/css/ace.min.css" />
		<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
		<link rel="stylesheet" href="static/css/ace-skins.min.css" />
		<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
		<!--提示框-->
		<script type="text/javascript" src="static/js/jquery.tips.js"></script>
</head>
<script type="text/javascript">
	$(top.hangge());
	//保存
	function save(){
		$("#Form").submit();
	}
</script>
<body>
	<form action="api/mokuai/${msg }.do" name="Form" id="Form" method="post" enctype="multipart/form-data">
		<input type="hidden" name="mokuai_id" value="${pd.mokuai_id}"/>
		<input type="hidden" name="headImg" value="${pd.headImg}"/>
		<div id="zhongxin">
		<table id="table_report"  class="table table-striped table-bordered table-hover">
			<tr>
				<td>头像</td>
				<td>
					<input type="file" name="file" id="file"/>
				</td>
			</tr>
			<tr>
				<td>名称</td>
				<td>
					<input type="text" name="title" id="title" placeholder="输入标题名称" value="${pd.title }"/>
				</td>
			</tr>
			<tr>
				<td>序号</td>
				<td>
					<input type="text" name="type" id="type" placeholder="输入序号" value="${pd.type }" <c:if test="${msg=='update' }">readonly="readonly"</c:if>/>
				</td>
			</tr>
			<tr>
				<td style="text-align: center;"colspan="2">
					<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
					<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
				</td>
			</tr>
		</table>
		</div>
		<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><img src="static/images/jzx.gif" style="width: 50px;" /><br/><h4 class="lighter block green"></h4></div>
	</form>
</body>

</html>