package com.yizhan.service.information.label;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yizhan.dao.DaoSupport;
import com.yizhan.entity.Page;
import com.yizhan.util.PageData;


@Service("labelService")
public class LabelService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**
	 * 分页列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	public List<PageData> getLabellistPage(Page page)throws Exception{
		return (List<PageData>)dao.findForList("labelMapper.getLabellistPage", page);
	}
	
	/**
	 * 添加
	 * @param pd
	 * @throws Exception
	 */
	public void insert(PageData pd)throws Exception{
		dao.save("labelMapper.insert", pd);
	}
	
	
	/**
	 * 根据ID获取一条对象信息
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public PageData getDateByIdorName(PageData pd) throws Exception{
		return (PageData) dao.findForObject("labelMapper.getDateByIdorName", pd);
	}
	
	/**
	 * 编辑
	 * @param pd
	 * @throws Exception 
	 */
	public void update(PageData pd) throws Exception{
		dao.update("labelMapper.update", pd);
	}
	/**
	 * 删除
	 * @param pd
	 * @throws Exception 
	 */
	public void delete(Map<String, Object> map) throws Exception{
		dao.delete("labelMapper.delete", map);
	}
	
}

