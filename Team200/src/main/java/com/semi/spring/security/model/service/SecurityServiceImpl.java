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

		System.out.println("loadUserByUsername실행");
		UserDetails member = dao.loadUserByUsername(username);
//		System.out.println("password from DB = " + member.getPassword());
//		System.out.println("username from DB = " + member.getUsername());
//		System.out.println("authorities = " + member.getAuthorities());
//		System.out.println(
//			    encoder.matches(
//		    		username,
//			        member.getPassword()
//			    )
//			);
		if(member == null){
			throw new UsernameNotFoundException(username);
		}
		
		return member;
	}
}
