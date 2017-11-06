package com.yizhan.service.information.h5sys;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yizhan.dao.DaoSupport;
import com.yizhan.entity.Page;
import com.yizhan.util.PageData;


@Service("h5sysService")
public class h5sysService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**
	 * 配送规则分页列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<PageData> peisongfeilistPage(Page page)throws Exception{
		return (List<PageData>)dao.findForList("H5sysMapper.peisongfeilistPage", page);
	}
	
	/**
	 * 获取配送规则信息
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public PageData peiSongGuiZeInfo(PageData pd)throws Exception{
		return (PageData) dao.findForObject("H5sysMapper.peiSongGuiZeInfo", pd);
	}
	
	/**
	 * 执行配送费规则添加
	 * @param pd
	 * @throws Exception
	 */
	public void saveinsert(PageData pd)throws Exception{
		dao.save("H5sysMapper.saveinsert", pd);
	}
	
	/**
	 * 根据ID获取一条对象信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getDateBypeisongfeiId(PageData pd) throws Exception{
		return (PageData) dao.findForObject("H5sysMapper.getDateBypeisongfeiId", pd);
	}
	
	/**
	 * 执行配送费规则编辑
	 * @param pd
	 * @throws Exception 
	 */
	public void sysPeisongfeiupdate(PageData pd) throws Exception{
		dao.update("H5sysMapper.sysPeisongfeiupdate", pd);
	}
	
	/**
	 * 执行配送费规则删除与批量删除
	 * @param pd
	 * @throws Exception
	 */
	public void sysPeisongfeiDelete(PageData pd) throws Exception{
		dao.delete("H5sysMapper.sysPeisongfeiDeleteAll", pd);
	}
	
	/**
	 * 服务费规则分页列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<PageData> fuwufeiListPage(Page page)throws Exception{
		return (List<PageData>)dao.findForList("H5sysMapper.fuwufeilistPage", page);
	}
	
	/**
	 * 执行服务费规则添加
	 * @param pd
	 * @throws Exception
	 */
	public void saveFuwufei(PageData pd)throws Exception{
		dao.save("H5sysMapper.saveFuwufei", pd);
	}
	
	
	/**
	 * 根据ID获取一条对象信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getDateByfuwufeiId(PageData pd) throws Exception{
		return (PageData) dao.findForObject("H5sysMapper.getDateByfuwufeiId", pd);
	}
	
	/**
	 * 执行服务费规则规则编辑
	 * @param pd
	 * @throws Exception 
	 */
	public void sysFuwufeiUpdate(PageData pd) throws Exception{
		dao.update("H5sysMapper.sysFuwufeiUpdate", pd);
	}
	
	//********************联系我们（开始）******************//
	/**
	 * @作者:Lj
	 * @功能:联系我们分页列表
	 * @日期:2017-9-7上午11:41:42
	 */
	public List<PageData> sysContactwmListPage(Page page)throws Exception{
		return (List<PageData>)dao.findForList("H5sysMapper.sysContactwmlistPage", page);
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行保存联系我们数据
	 * @日期:2017-9-7上午11:53:59
	 */
	public void saveLianxiwm(PageData pd)throws Exception{
		dao.save("H5sysMapper.saveLianxiwm", pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:根据ID获取联系我们的一条对象信息
	 * @日期:2017-9-7上午11:56:00
	 */
	public PageData golianxiwmEditId(PageData pd) throws Exception{
		return (PageData) dao.findForObject("H5sysMapper.golianxiwmEditId", pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行编辑联系我们
	 * @日期:2017-9-7上午11:58:24
	 */
	public void lianxiwmUpdate(PageData pd) throws Exception{
		dao.update("H5sysMapper.lianxiwmUpdate", pd);
	}
	
	/**
	 * @作者:Lj
	 * @功能:执行删除联系我们
	 * @日期:2017-9-7下午12:05:34
	 */
	public void deletelianxiwm(Map<String, Object> map) throws Exception{
		dao.delete("H5sysMapper.deletelianxiwm", map);
	}
	//********************联系我们（结束）******************//
}

