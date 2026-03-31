package com.semi.spring.security.model.vo;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.semi.spring.member.model.vo.Member;

import lombok.Getter;

public class MemberExt extends Member implements UserDetails{

	private static final long serialVersionUID = 1L;
	
	// SimpleGrantedAuthority
	//  - 문자열 형태의 권한
	//  - "ROLE_USER", "ROLE_ADMIN" , "ROLE_MANAGER"...
	private List<SimpleGrantedAuthority> authorities;

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		
		return this.authorities;
		//String role = userRole.equals("A") ? "ROLE_ADMIN" : "ROLE_USER";
		//return List.of(new SimpleGrantedAuthority(role));
	}

	@Override
	public String getPassword() {
		return getUserPw();
	}

	@Override
	public String getUsername() {
		return getUserId();
	}
	
	@Override
	public String getEmail() {
		return super.getEmail();
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}

}
