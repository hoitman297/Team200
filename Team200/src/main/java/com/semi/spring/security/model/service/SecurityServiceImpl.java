package com.semi.spring.security.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import com.semi.spring.security.model.dao.SecurityDao;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class SecurityServiceImpl implements SecurityService {
	private final BCryptPasswordEncoder encoder;
	
	private final SecurityDao dao;

	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		UserDetails member = dao.loadUserByUsername(username);
		if(member == null){
			throw new UsernameNotFoundException(username);
		}
		
		return member;
	}
}
