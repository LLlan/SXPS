package com.yizhan.controller.information.userKehu;

import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.yizhan.controller.base.BaseController;
import com.yizhan.entity.Page;
import com.yizhan.service.information.userKuhu.KeHuService;
import com.yizhan.util.PageData;

/**
 * 客户端用户列表后台功能控制器
 * @类名称： UserKehuController
 * @作者：lj 
 * @时间： 2017-6-27 下午2:48:03
 *
 */
@Controller
@RequestMapping(value="/userKehu")
public class UserKehuController extends BaseController {

	@Resource(name = "keHuService")
	private KeHuService keHuService;
	
	/**
	 * 分页列表
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/userKehulistPage")
	public ModelAndView UserKehulistPage(Page page){
		logBefore(logger, "-------客户端用户管理分页列表---------");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			page.setPd(pd);
 			List<PageData> userKehulist = keHuService.UserKehulistPage(page);
 			mv.addObject("pd",pd);
 			mv.addObject("userKehulist",userKehulist);
 			mv.setViewName("information/userKehu/userKehu_list");
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
		return mv;
	}
	
	
	/**
	 * 删除
	 */
	@RequestMapping(value="/del")
	public void delete(PrintWriter out){
		logBefore(logger, "删除");
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			keHuService.del(pd);
			out.write("success");
			out.close();
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
	}
	
	
}
