package com.springboot.meongnyang_Jiphapso.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class OrderCancelController {
	@RequestMapping("/admin/OrderCancel/adminList")
	public String OrderCancel_adminList() {
		return"/OrderCancel_adminList";
	}
}
