package com.project.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.project.dto.BoardDTO;

@Repository
public class ReplyDAOImpl implements ReplyDAO{
	
	@Autowired
	private SqlSessionTemplate template;
	
	
	@Override
	public List<BoardDTO> selectList(Map<String, Object> map) {
		return template.selectList("com.project.mappers.reply.selectList", map);
	}
	
	@Override
	public int getRecords(int board_no) {
		return template.selectOne("com.project.mappers.reply.getRecords", board_no);
	}
	
	@Override
	public void updateReply(Map<String, Object> map) {
		template.update("com.project.mappers.reply.updateReplyOthers", map);
		template.update("com.project.mappers.reply.updateReply", map);
	}
	
	@Override
	public void updateLike(int reply_no) {
		template.update("com.project.mappers.reply.updateLike", reply_no);
	}
	
	@Override
	public void updateDislike(int reply_no) {
		template.update("com.project.mappers.reply.updateDislike", reply_no);
	}
}
