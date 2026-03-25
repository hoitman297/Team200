package com.semi.spring.security.model.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.userdetails.UserDetails;

public interface SecurityDao {

	UserDetails loadUserByUsername(String username);
}
