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
	<link rel="stylesheet" href="static/css/bootstrap.min.css"/>
	<link rel="stylesheet" href="static/css/bootstrap-responsive.min.css"/>
	<link rel="stylesheet" href="static/css/font-awesome.min.css" />
	<link rel="stylesheet" href="static/css/ace.min.css" />
	<link rel="stylesheet" href="static/css/ace-responsive.min.css" />
	<link rel="stylesheet" href="static/css/ace-skins.min.css" />
	<!-- 引入 -->
	<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/ace-elements.min.js"></script>
	<script src="static/js/ace.min.js"></script>
	<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
	<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
	<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
	<!-- 引入 -->
	<!-- <script type="text/javascript" src="static/js/jquery.tips.js"></script>提示框 -->
		
<script type="text/javascript">
	$(top.hangge());
	//新增
	function add(){
		 top.jzts();
		 var diag = new top.Dialog();
		 diag.Drag=true;
		 diag.Title ="添加商品";
		 diag.URL = '<%=basePath%>shangjia/goodstoAdd.do';
		 diag.Width = 400;
		 diag.Height = 400;
		 diag.CancelEvent = function(){ //关闭事件
			 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
				var num = '${page.currentPage}';
			 	if(num == '0'){
			 		top.jzts();
			 		location.href = location.href;
			 	}else{
			 		nextPage('${page.currentPage}');
			 	}
			}
			 diag.close();
		 };
		 diag.show();
	}
	//修改
	function edit(tagID){
		 top.jzts();
	   	 var diag = new top.Dialog();
		 diag.Drag=true;
		 diag.Title ="商品编辑";
		 diag.URL = '<%=basePath%>shangjia/goodstoEdit.do?tagID='+tagID;
		 diag.Width = 400;
		 diag.Height = 400;
		 diag.CancelEvent = function(){ //关闭事件
			 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
				 nextPage('${page.currentPage}');
			}
			 diag.close();
		 };
		 diag.show();
	}
	//删除
		function del(tagID){
			bootbox.confirm("确定要删除该条数据吗?", function(result) {
				if(result) {
					top.jzts();
					var url = '<%=basePath%>shangjia/goodsdelete.do?ids='+tagID;
					$.get(url,function(data){
						nextPage('${page.currentPage}');
					});
				}
			});
		}
		$(function() {
			//复选框
			$('table th input:checkbox').on('click' , function(){
				var that = this;
				$(this).closest('table').find('tr > td:first-child input:checkbox')
				.each(function(){
					this.checked = that.checked;
					//$(this).closest('tr').toggleClass('selected');
				});	
			});
		});
		//批量上架或下架
		function changeState(state){
			bootbox.confirm('确定执行该操作吗？',function(result){
				if(result){
					var str='';
					for ( var i = 0; i < document.getElementsByName('ids').length; i++) {
						if(document.getElementsByName('ids')[i].checked){
							if(str==''){
								str+=document.getElementsByName('ids')[i].value;
							}else{
								str+=','+document.getElementsByName('ids')[i].value;
							}
						}
					}
					if(str==''){
						bootbox.dialog("您没有选择任何内容!", 
							[
							  {
								"label" : "关闭",
								"class" : "btn-small btn-success",
								"callback": function() {
									//Example.show("great success");
									}
								}
							 ]
						);
						$("#zcheckbox").tips({
							side:3,
				            msg:'点这里全选',
				            bg:'#AE81FF',
				            time:4
				        });
						return;
					}else{
						$.ajax({
							type:'post',
							url:'<%=basePath%>shangjia/goodsstate.do',
							dataTyoe:'json',
							cache: false,
							data:{
								"ids":str,
								"state":state
							},
							success:function(data){
								nextPage('${page.currentPage}');
							},
						});
					}
				}
			});	
		}
		//批量删除
		function makeAll() {
			bootbox.confirm('确定执行批量删除操作吗？',function(result){
				if(result){
					var str='';
					for ( var i = 0; i < document.getElementsByName('ids').length; i++) {
						//alert(document.getElementsByName('ids').length);
						if(document.getElementsByName('ids')[i].checked){
							if(str==''){
								str+=document.getElementsByName('ids')[i].value;
							}else{
								str+=','+document.getElementsByName('ids')[i].value;
							}
						}
					}
					//alert("str:"+str);
					if(str==''){
						bootbox.dialog("您没有选择任何内容!", 
							[
							  {
								"label" : "关闭",
								"class" : "btn-small btn-success",
								"callback": function() {
									//Example.show("great success");
									}
								}
							 ]
						);
						$("#zcheckbox").tips({
							side:3,
				            msg:'点这里全选',
				            bg:'#AE81FF',
				            time:4
				        });
						return;
					}else{
						$.ajax({
							type:'post',
							url:'<%=basePath%>shangjia/goodsdelete.do',
							dataTyoe:'json',
							cache: false,
							data:{
								"ids":str
							},
							success:function(data){
								nextPage('${page.currentPage}');
							},
						});
					}
				}
			});	
		}
</script>

<script type="text/javascript">
		
		$(function() {
			
			//日期框
			$('.date-picker').datepicker();
			
			//下拉框
			$(".chzn-select").chosen(); 
			$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
			
			//复选框
			$('table th input:checkbox').on('click' , function(){
				var that = this;
				$(this).closest('table').find('tr > td:first-child input:checkbox')
				.each(function(){
					this.checked = that.checked;
					$(this).closest('tr').toggleClass('selected');
				});
					
			});
			
		});
		
		//导出excel
		function toExcel(){
			var searchName = $("#nav-search-input").val();
			var searchDateStart = $("#searchDateStart").val();
			var searchDateEnd = $("#searchDateEnd").val();
			/* var ROLE_ID = $("#role_id").val(); */
			window.location.href='<%=basePath%>shangjia/excel.do?searchName='+searchName+'&searchDateStart='+searchDateStart+'&searchDateEnd='+searchDateEnd;
		}
		
		//打开上传excel页面
		function fromExcel(){
			 top.jzts();
			 var diag = new top.Dialog();
			 diag.Drag=true;
			 diag.Title ="EXCEL 导入到数据库";
			 diag.URL = '<%=basePath%>shangjia/goUploadExcel.do';
			 diag.Width = 300;
			 diag.Height = 150;
			 diag.CancelEvent = function(){ //关闭事件
				 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
					 if('${page.currentPage}' == '0'){
						 top.jzts();
						 setTimeout("self.location.reload()",100);
					 }else{
						 nextPage('${page.currentPage}');
					 }
				}
				diag.close();
			 };
			 diag.show();
		}
		
		</script>
</head>

<body>
<div id="page-content" class="clearfix">
<div class="row-fluid">
	
	<!-- 检索  -->
	<form action="<%=basePath%>/shangjia/ordergetlistPage.do" method="post" name="userForm" id="userForm">
	<table>
		<tr>
			<td>
				<span class="input-icon">
					<input autocomplete="off" id="nav-search-input" type="text" name="searchName" value="${pd.searchName }" placeholder="这里输入关键词" />
					<i id="nav-search-icon" class="icon-search"></i>
				</span>
			</td>
			<td><input class="span10 date-picker" name="searchDateStart" id="searchDateStart"  value="${pd.searchDateStart}" type="text" data-date-format="yyyy-mm-dd" readonly="readonly" style="width:88px;" placeholder="开始日期" title="检索开始日期"/></td>
			<td><input class="span10 date-picker" name="searchDateEnd" id="searchDateEnd"  value="${pd.searchDateEnd}" type="text" data-date-format="yyyy-mm-dd" readonly="readonly" style="width:88px;" placeholder="结束日期" title="检索开始日期"/></td>
			<c:if test="${QX.cha == 1 }">
				<td style="vertical-align:top;">
					<button class="btn btn-mini btn-light" title="检索">
						<i id="nav-search-icon" class="icon-search"></i>
					</button>
				</td>
				<td style="vertical-align:top;">
					<a class="btn btn-mini btn-light" onclick="toExcel();" title="导出到EXCEL">
						<i id="nav-search-icon" class="icon-download-alt"></i>
					</a>
				</td>
				<c:if test="${QX.edit == 1 }">
					<td style="vertical-align:top;">
						<a class="btn btn-mini btn-light" onclick="fromExcel();" title="从EXCEL导入">
							<i id="nav-search-icon" class="icon-cloud-upload"></i>
						</a>
					</td>
				</c:if>
			</c:if>
		</tr>
	</table>
	<!-- <a class="btn btn-small btn-success" style="margin-bottom: 5px;" onclick="changeState('1');">上架</a>
	<a class="btn btn-small btn-success" style="margin-bottom: 5px;" onclick="changeState('0');">下架</a> -->
	<!-- 检索  -->
	<table id="table_report" class="table table-striped table-bordered table-hover">
		<thead>
		<tr>
			<!-- <th class="center">
				<label><input type="checkbox" id="zcheckbox" /><span class="lbl"></span></label>
			</th> -->
			<th class="center"  style="width: 30px;">序号</th>
			<th class='center'>商家店铺名称</th>
			<th class='center'>骑手姓名</th>
			<th class='center'>骑手联系电话</th>
			<th class='center'>订单编号</th>
			<th class='center'>下单时间</th>
			<th class='center'>取餐编号</th>
			<th class='center'>商品名称</th>
			<th class='center'>商品数量</th>
			<th class='center'>餐盒费用</th>
			<th class='center'>原价</th>
			<th class='center'>现价</th>
			<th class='center'>配送费用</th>
			<th class='center'>订单备注</th>
			<th class='center'>操作</th>
		</tr>
		</thead>
		<c:choose>
			<c:when test="${not empty list}">
				<c:forEach items="${list}" var="var" varStatus="vs">
				<tr>
					<%-- <td class='center' style="width: 30px;">
				 		<label><input type='checkbox' name='ids' value="${var.order_takeou_id }"/><span class="lbl"></span></label>
					</td> --%>
					<td class='center' style="width: 30px;">${vs.index+1}</td>
					<td class='center'>${var.shopName}</td>
					<td class='center'>${var.realName}</td>
					<td class='center'>${var.phone}</td>
					<td class='center'>${var.orderNumber}</td>
					<td class='center'><fmt:formatDate value="${var.orderTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td class='center'>${var.qucan_number}</td>
					<td class='center'>${var.goodsName}</td>
					<td class='center'>x${var.goodsNum}</td>
					<td class='center'>${var.canhefei}</td>
					<td class='center'>${var.originalPrice}</td>
					<td class='center'>${var.presentPrice}</td>
					<td class='center'>${var.peisongfei}</td>
					<td class='center'>${var.order_remark}</td>
					<td style="width: 68px;">
						<a class='btn btn-mini btn-info' title="编辑" onclick="edit('${var.order_takeou_id }')" ><i class='icon-edit'></i></a>
						<a class='btn btn-mini btn-danger' title="删除"  onclick="del('${var.order_takeou_id }')"><i class='icon-trash'></i></a>
					</td>
				</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
				<td colspan="100" class="center">没有相关数据</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
		<div class="page-header position-relative">
		<table style="width:100%;">
			<tr>
				<td style="vertical-align:top;width:50px;">
					<!-- <a class="btn btn-small btn-success" onclick="add();">新增</a>
					<a title="批量删除" class="btn btn-small btn-danger" onclick="makeAll();" style="margin: -55px 0 0 59px;width: 26px;text-align: center;"><i class='icon-trash'></i></a> -->
				</td>
				<td style="vertical-align:top;"><div class="pagination" style="float: right;padding-top: 0px;margin-top: 0px;">${page.pageStr}</div></td>
			</tr>
		</table>
		</div>
	</form>
</div>
</div>
</body>
</html>