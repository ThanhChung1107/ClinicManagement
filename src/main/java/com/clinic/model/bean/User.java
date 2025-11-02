package com.clinic.model.bean;

public class User {
	private int userId;
	private String fullname;
	private String email;
	private String password;
	private String role;
	private String phone;
	private String gender;
	
	public User() {}
	
	
	public User(int userId, String fullname, String email, String password, String role, String phone, String gender) {
		super();
		this.userId = userId;
		this.fullname = fullname;
		this.email = email;
		this.password = password;
		this.role = role;
		this.phone = phone;
		this.gender = gender;
	}


	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getFullname() {
		return fullname;
	}
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	
}
