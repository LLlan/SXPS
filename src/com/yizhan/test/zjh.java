package com.yizhan.test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.yizhan.util.PageData;

public class zjh {

	public static void main(String[] args) {
		
		sortList();
		
	}
	
	//根据集合中对象的某一个属性进行排序
	public static void sortList(){
		List<PageData> list = new ArrayList<PageData>();
		
		//创建3个学生对象，年龄分别是20、19、21，并将他们依次放入List中
		PageData pd1=new PageData();
		pd1.put("age", 20);
		pd1.put("name", "pd1");
		
		PageData pd2=new PageData();
		pd2.put("age", 19);
		pd2.put("name", "pd2");
		
		PageData pd3=new PageData();
		pd3.put("age", 21);
		pd3.put("name", "pd3");
		
		list.add(pd1);
		list.add(pd2);
		list.add(pd3);
		
		System.out.println("排序前："+list);
		
		Collections.sort(list, new Comparator<PageData>(){

			/*
			 * int compare(Student o1, Student o2) 返回一个基本类型的整型，
			 * 返回负数表示：o1 小于o2，
			 * 返回0 表示：o1和o2相等，
			 * 返回正数表示：o1大于o2。
			 */
			public int compare(PageData o1, PageData o2) {
			
				//按照学生的年龄进行升序排列
				if(Integer.parseInt(o1.get("age").toString()) > Integer.parseInt(o2.get("age").toString())){
					return 1;
				}
				if(Integer.parseInt(o1.get("age").toString()) == Integer.parseInt(o2.get("age").toString())){
					return 0;
				}
				return -1;
			}
		}); 
		System.out.println("排序后："+list);
	}
}
