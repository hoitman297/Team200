package com.semi.spring.member.model.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.semi.spring.member.model.vo.Member;

public class MemberValidator implements Validator{

		@Override
		public boolean supports(Class<?> clazz) {
			// 유효성 검사를 수행할 클래스를 지정하는 메서드
			return Member.class.isAssignableFrom(clazz);
		}

		@Override
		public void validate(Object target, Errors errors) {
			// 유효성 검사 메서드
			Member member = (Member) target;
			
			// 유효성 검사 로직
			// =================== ID ====================
			if(member.getUserId() == null || member.getUserId().trim().isEmpty()) {
				
		        errors.rejectValue("userId", "required", "아이디를 입력하세요");
		    }
			
		    else if(member.getUserId().length() < 4 || member.getUserId().length() > 20) {
		    	
		        errors.rejectValue("userId", "length", "아이디는 4~20자 이내여야 합니다.");
		        
		    }
		    else if(!member.getUserId().matches("^[a-zA-Z0-9_]+$")) {
		    	
		        errors.rejectValue("userId", "pattern", "아이디는 영문, 숫자, _만 사용가능 합니다.");
		        
		    }
			
			// =================== PW ==================== 
			if(member.getUserPw() == null || member.getUserPw().trim().isEmpty()) {
				errors.rejectValue("userPw", "required", "비밀번호를 입력하세요"); 
			} else 
				{ if(member.getUserPw().length() < 8) { 
					
					errors.rejectValue("userPw", "length", "비밀번호는 8자 이상이어야 합니다."); 
					
				} if(!member.getUserPw().matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$")){
					
					errors.rejectValue( "userPw", "pattern", "비밀번호는 영문, 숫자, 특수문자를 포함한 8자 이상이어야 합니다." ); 
					
				}
			}
			// ================ PW 확인 =============
			
			// 비밀번호 확인용
			String pwCheck = member.getUserPw();
			
			 if(pwCheck == null || pwCheck.trim().isEmpty()) {
				 
		            errors.rejectValue("userPw", "required", "비밀번호 확인에 입력하세요");
		            
		      }else if(member.getUserPw() != null && !member.getUserPw().equals(pwCheck)) {
				 
		            errors.rejectValue("userPw", "mismatch", "비밀번호가 일치하지 않습니다.");
		            
		        }
			// ================= 이메일 ================= 
		    if(member.getEmail() == null || member.getEmail().trim().isEmpty()) {
		    	
		        errors.rejectValue("email", "required", "이메일을 입력하세요");
		        
		    }
		    // ================= 닉네임 ================= 
		    if(member.getUserName() == null || member.getUserName().trim().isEmpty()) {
		    	
		        errors.rejectValue("userName", "required", "닉네임을 입력하세요");
		        
		    }
		    else if(member.getUserName().length() < 2) {
		    	
		        errors.rejectValue("userName", "length", "닉네임은 2자 이상이어야 합니다.");
		        
		    }

	}
		
}
