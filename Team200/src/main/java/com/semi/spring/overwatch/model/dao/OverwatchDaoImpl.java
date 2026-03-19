package com.semi.spring.overwatch.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class OverwatchDaoImpl implements OverwatchDao{
	private final SqlSessionTemplate session;

}
