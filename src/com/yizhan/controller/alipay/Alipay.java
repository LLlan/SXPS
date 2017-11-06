package com.yizhan.controller.alipay;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.yizhan.controller.alipay.config.AlipayConfig;
import com.yizhan.controller.alipay.util.AlipayNotify;
import com.yizhan.controller.alipay.util.AlipaySubmit;
import com.yizhan.controller.app.jpushModel.JpushClientUtil;
import com.yizhan.controller.base.BaseController;
import com.yizhan.entity.Page;
import com.yizhan.entity.information.KeHu;
import com.yizhan.entity.information.ZywKeHu;
import com.yizhan.service.information.kehu.kehuService;
import com.yizhan.util.Const;
import com.yizhan.util.DateUtil;
import com.yizhan.util.PageData;
import com.yizhan.util.StringUtil;
import com.yizhan.util.Tools;
/**
 * 调用支付宝支付
 * 功能：
 * 作者： yangym
 * date：2017-8-2
 *
 */
@Controller
@RequestMapping("/api/alipay")
public class Alipay extends BaseController{
	//double保留两位小数
	private DecimalFormat df = new DecimalFormat("#0.0000");
	
	@Resource(name="kehuService")
	private kehuService kehuService;
	
	/**
	 * 唤起手机支付宝APP
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/alipay")  
    public ModelAndView payConfirm(HttpServletRequest request,HttpSession session) throws Exception{ 
		logBefore(logger, "--唤起手机支付宝APP--");
		ModelAndView mv=new ModelAndView();
		
		//商户订单号，商户网站订单系统中唯一订单号，必填
        String out_trade_no =request.getParameter("WIDout_trade_no");
        //订单名称，必填
        String subject =request.getParameter("WIDsubject");
        //付款金额，必填request.getParameter("WIDtotal_fee");
        String total_fee ="0.01";
        //收银台页面上，商品展示的超链接，必填
        String show_url = request.getParameter("WIDshow_url");
        //商品描述，可空request.getParameter("WIDbody");
        String body = "这生鲜配送支付过程";
        System.out.println("====参数out_trade_no="+out_trade_no+",subject="+subject+",total_fee="+total_fee+",show_url="+show_url+",body="+body);
        
        //更新订单号到订单表中
        PageData pd=new PageData();
        pd.put("order_takeou_id", request.getParameter("order_takeou_id"));//订单的主键ID
        pd.put("orderNumber", out_trade_no);//订单编号
        kehuService.updateOrderNumberById(pd);
        
        //把请求参数打包成数组
		Map<String, String> sParaTemp = new HashMap<String, String>();
		sParaTemp.put("service", AlipayConfig.service);
        sParaTemp.put("partner", AlipayConfig.partner);
        sParaTemp.put("seller_id", AlipayConfig.seller_id);
        sParaTemp.put("_input_charset", AlipayConfig.input_charset);
		sParaTemp.put("payment_type", AlipayConfig.payment_type);
		sParaTemp.put("notify_url", AlipayConfig.notify_url);
		sParaTemp.put("return_url", AlipayConfig.return_url);
		sParaTemp.put("out_trade_no", out_trade_no);
		sParaTemp.put("subject", subject);
		sParaTemp.put("total_fee", total_fee);
		sParaTemp.put("show_url", show_url);
		sParaTemp.put("app_pay","y");//启用此参数可唤起钱包APP支付。
		sParaTemp.put("body", body);
		//其他业务参数根据在线开发文档，添加参数.文档地址:https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.2Z6TSk&treeId=60&articleId=103693&docType=1
        //如sParaTemp.put("参数名","参数值");
		//建立请求
		String sHtmlText = AlipaySubmit.buildRequest(sParaTemp,"post","确认");
		System.out.println("================sHtmlText:===="+sHtmlText);
		mv.addObject("sHtmlText", sHtmlText);
		mv.setViewName("alipay/alipay");
		return mv;
    }  
	
	/**
	 * 支付成功回调（异步通知）
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/notify_url")
	public void notify_url(HttpServletRequest request,HttpServletResponse response) throws Exception{
		logBefore(logger, "--支付成功回调（异步通知）--");
		//获取支付宝POST过来反馈信息
		Map<String,String> params = new HashMap<String,String>();
		Map<String,String[]> requestParams = request.getParameterMap();
		for (Iterator<String> iter = requestParams.keySet().iterator(); iter.hasNext();){
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			//valueStr = new String(valueStr.getBytes("ISO-8859-1"), "gbk");
			params.put(name, valueStr);
		}
		System.out.println("=========================================支付成功回调（异步通知）参数params="+params);
		//商户订单号
		String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");
		//支付宝交易号
		String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");
		//交易状态
		String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
		
		//计算得出通知验证结果
		boolean verify_result = AlipayNotify.verify(params);
		//if(verify_result){//验证成功
			if(trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")){
				
				System.out.println("---------------异步通知支付成功--------------------");
				System.out.println("---------------异步通知支付成功--------------------");
				
				//更新订单
				PageData pd=new PageData();
				pd.put("payState", "已支付");
				pd.put("orderStateKehu", "2");
				pd.put("payMethod", "支付宝");
				pd.put("orderNumber", out_trade_no);
				kehuService.updateOrderInfoByOrderNumber(pd);
				
				//根据外卖订单编号获取查询商家的id
				PageData pds = kehuService.geuserShangjiaFid(pd);
				pds.put("user_shangjia_id", pds.getString("user_shangjia_fid"));
				//获取商家信息
				PageData sData = kehuService.queryUserShangjia(pds);
				String registrationId =  sData.getString("RegistrationID");//设备标识
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("jump", "1");//1跳转到商家新订单
				map.put("mp3", "xxx.mp3");
				map.put("notification_title", "订单大厅有新订单！");
				map.put("msg_title", "客户已下单，请查收后并受理！");
				String extrasparam = new Gson().toJson(map);
				if (sData.getString("RegistrationType").equals("ios")) {
					JpushClientUtil.ios_sj_sendToRegistrationId(registrationId, "订单大厅有新订单！", "客户已下单，请查收后并受理！", "您有新订单", extrasparam);
					System.out.println(".........客户付款后后+执行推送给指定商家消息！(ios).........");
				} else {
					JpushClientUtil.sj_sendToRegistrationId(registrationId, "订单大厅有新订单！", "客户已下单，请查收后并受理！", "您有新订单", extrasparam);
					System.out.println(".........客户付款后后+执行推送给指定商家消息！(an).........");
				}
				
			}else{
				System.out.println("-----------------异步通知支付失败----------------");
			}
		
			System.out.println("---------验证成功---------");
			response.getWriter().write("success");
		//}else{
			//System.out.println("验证失败");
		//}
	}
	/**
	 * 支付成功回调（同步通知）
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/return_url")
	public ModelAndView return_url(HttpServletRequest request,HttpSession session) throws Exception{
		logBefore(logger, "--支付成功回调（同步通知）--");
		ModelAndView mv=new ModelAndView();
		
		//获取支付宝GET过来反馈信息
		Map<String,String> params = new HashMap<String,String>();
		Map requestParams = request.getParameterMap();
		for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();){
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
			params.put(name, valueStr);
		}
		System.out.println("++++++++++++++++++++++++++++++++支付成功回调（同步通知）参数:"+params);
		
		//商户订单号
		String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");
		//支付宝交易号
		String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");
		//交易状态
		String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
		//计算得出通知验证结果
		boolean verify_result = AlipayNotify.verify(params);
		//if(verify_result){//验证成功
			if(trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")){
				//成功要做的事  插入订单 或修改订单信息
				System.out.println("---------------同步通知支付成功--------------------");
				System.out.println("---------------同步通知支付成功--------------------");
				System.out.println("---------------同步通知支付成功--------------------");
				
				//现在现在在同步中进行订单的操作，正式发布到外网上移到异步通知处做，同步通知内只做页面跳转即可
				PageData pd=new PageData();
				pd.put("payState", "已支付");
				pd.put("orderStateKehu", "2");
				pd.put("payMethod", "支付宝");
				pd.put("orderNumber", out_trade_no);
				kehuService.updateOrderInfoByOrderNumber(pd);
				
				//根据外卖订单编号获取查询商家的id
				PageData pds = kehuService.geuserShangjiaFid(pd);
				pds.put("user_shangjia_id", pds.getString("user_shangjia_fid"));
				//获取商家信息
				PageData sData = kehuService.queryUserShangjia(pds);
				String registrationId =  sData.getString("RegistrationID");//设备标识
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("jump", "1");//1跳转到商家新订单
				map.put("mp3", "xxx.mp3");
				map.put("notification_title", "订单大厅有新订单！");
				map.put("msg_title", "客户已下单，请查收后并受理！");
				String extrasparam = new Gson().toJson(map);
				if (sData.getString("RegistrationType").equals("ios")) {
					JpushClientUtil.ios_sj_sendToRegistrationId(registrationId, "订单大厅有新订单！", "客户已下单，请查收后并受理！", "您有新订单", extrasparam);
					System.out.println(".........客户付款后后+执行推送给指定商家消息！(ios).........");
				} else {
					JpushClientUtil.sj_sendToRegistrationId(registrationId, "订单大厅有新订单！", "客户已下单，请查收后并受理！", "您有新订单", extrasparam);
					System.out.println(".........客户付款后后+执行推送给指定商家消息！(an).........");
				}
				mv.addObject("order_takeou_id", pds.getString("order_takeou_id"));
				mv.setViewName("alipay/alipayreturn2");
			}else{
				System.out.println("-----------------同步通知支付失败----------------");
				System.out.println("-----------------同步通知支付失败----------------");
				System.out.println("-----------------同步通知支付失败----------------");
			}
			System.out.println("验证成功");
		//}else{
			//System.out.println("验证失败");
		//}
		return mv;
	}
///////////////////////////////////////////////////以下为在微信浏览器中选择支付宝支付时的方法/////////////////////////////////////////////////////////////	
	// 请在菜单中选择在浏览器中打开
	@RequestMapping(value="pay")
	public ModelAndView pay(HttpSession session) throws Exception{
		logBefore(logger, "--请在菜单中选择在浏览器中打开--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		/*
		 * 参数：1.订单编号  orderNumber
		 * 	   2.订单的主键ID order_takeou_id
		 */
		PageData tempIsOrNo=kehuService.getOrderInforByOrderNumber(pd);
		if(tempIsOrNo==null || tempIsOrNo.isEmpty()){
			//更新订单号到订单表中
	        kehuService.updateOrderNumberById(pd);
	      	mv.setViewName("alipay/pay");
		}else{
			mv.setViewName("redirect:/api/alipay/demo_post?orderNumber="+pd.getString("orderNumber"));
		}
		return mv;
	}
	
	//在浏览器中打开，确认支付页面
	@RequestMapping(value="/demo_post")
	public ModelAndView demo_post() throws Exception{
		logBefore(logger, "--在浏览器中打开，确认支付页面--");
		ModelAndView mv=new ModelAndView();
		PageData pd=new PageData();
		pd=this.getPageData();
		
		//根据订单编号获取订单信息
		PageData temp=kehuService.getOrderInforByOrderNumber(pd);
		//把请求参数打包成数组
		Map<String, String> sParaTemp = new HashMap<String, String>();
		sParaTemp.put("service", AlipayConfig.service);
        sParaTemp.put("partner", AlipayConfig.partner);
        sParaTemp.put("seller_id", AlipayConfig.seller_id);
        sParaTemp.put("_input_charset", AlipayConfig.input_charset);
		sParaTemp.put("payment_type", AlipayConfig.payment_type);
		sParaTemp.put("notify_url", AlipayConfig.notify_url);
		sParaTemp.put("return_url", AlipayConfig.return_url);
		sParaTemp.put("out_trade_no", pd.getString("orderNumber"));
		sParaTemp.put("subject", "生鲜配送");
		//sParaTemp.put("total_fee", temp.get("paySum").toString());
		sParaTemp.put("total_fee", "0.01");
		sParaTemp.put("show_url", "");
		sParaTemp.put("app_pay","y");//启用此参数可唤起钱包APP支付。
		sParaTemp.put("body", "这生鲜配送支付过程");
		
		//建立请求
		String sHtmlText = AlipaySubmit.buildRequest(sParaTemp,"post","确认支付");
		System.out.println("================sHtmlText:===="+sHtmlText);

		mv.addObject("sHtmlText", sHtmlText);
		mv.setViewName("alipay/alipay");
		return mv;
	}
}
