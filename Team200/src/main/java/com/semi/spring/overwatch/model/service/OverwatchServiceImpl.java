package com.semi.spring.overwatch.model.service;

import org.springframework.stereotype.Service; // Repository 대신 Service 임포트

import com.semi.spring.lol.model.dao.LolDao;

import lombok.RequiredArgsConstructor;


@Service // 서비스 클래스에 맞는 어노테이션으로 변경
@RequiredArgsConstructor
public class OverwatchServiceImpl implements OverwatchService {
	private final LolDao OverDao;

    // 인터페이스(OverwatchService)의 추상 메서드들을 오버라이딩해야 에러가 사라짐
}