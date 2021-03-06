package com.project.dao;


import java.util.List;
import java.util.Map;



import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.dto.JoinDTO;

@Repository
public class JoinDAOImpl implements JoinDAO{
	
	@Autowired
	private SqlSessionTemplate template;

	@Override
	public List<JoinDTO> memberList(JoinDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
//媛��엯
	@Override
	public void insert(JoinDTO dto) throws Exception {
		template.insert("insert", dto);
		
	}
//�븘�씠�뵒 以묐났泥댄겕
	@Override
	public int findId(Map<String, Object> map) throws Exception {
		return template.selectOne("findid", map);
	}
//�땳�꽕�엫 以묐났泥댄겕
	@Override
	public int findnick(Map<String, Object> map) throws Exception {
		
		return template.selectOne("findnick", map);
	}
	
	@Override
	public int findemail(Map<String, Object> map) throws Exception{

		return template.selectOne("findemail", map);
	}
	//�븘�씠�뵒 李얘린 
	@Override
	public String searchId(Map<String, Object> map) throws Exception{
       return template.selectOne("searchId", map);
		
	}
	@Override
	public int searchpwd(Map<String, Object> map) throws Exception{
		return template.update("searchpwd", map);
	}
	@Override
	public void emailverify(String email) throws Exception{
		template.update("mailverify", email);
		
	}
	@Override
	public int verifycheck(String email) throws Exception{
		
		return template.selectOne("mailverifycheck", email);
	}
	

}
