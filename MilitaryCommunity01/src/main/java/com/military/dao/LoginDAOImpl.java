package com.military.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.military.dto.LoginDTO;

@Repository
public class LoginDAOImpl implements LoginDAO {
	
	@Autowired
	private SqlSessionTemplate template;
	
	@Override
	public LoginDTO selectUser(String username) {
		return template.selectOne("selectUser", username);
	}

}
