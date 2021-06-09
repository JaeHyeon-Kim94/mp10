package com.model2.mvc.web.product;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.CookieGenerator;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;



//==> ȸ������ Controller
@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method ���� ����
		
	public ProductController(){
		System.out.println(this.getClass());
	}
	
	//==> classpath:config/common.properties  ,  classpath:config/commonservice.xml ���� �Ұ�
	//==> �Ʒ��� �ΰ��� �ּ��� Ǯ�� �ǹ̸� Ȯ�� �Ұ�
	@Value("#{commonProperties['pageUnit']}")
	//@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	//@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	
	
	@RequestMapping(value = "/addProduct", method = RequestMethod.GET)
	public String addProductView() throws Exception {

		System.out.println("/product/addProductView");
		
		return "redirect:/product/addProductView.jsp";
	}
	
	@RequestMapping(value = "/addProduct", method = RequestMethod.POST)
	public String addProduct( @ModelAttribute("product")Product product ) throws Exception {

		System.out.println("/product/addProduct");
		//Business Logic
		product.setManuDate(product.getManuDate().replaceAll("-", ""));
		productService.addProduct(product);
		
		return "forward:/product/addProduct.jsp";
	}
	
	@RequestMapping("/getProduct")
	public String getProduct( @RequestParam("prodNo")String prodNo , Model model, HttpServletRequest request,
							HttpServletResponse response, @CookieValue ( value = "history", required = false)String history ) throws Exception {
		
		System.out.println("/product/getProduct");

		//Business Logic
		Product product = productService.getProduct(Integer.parseInt(prodNo));
		// Model �� View ����
		model.addAttribute("product", product);
		
		CookieGenerator cookie = new CookieGenerator();
		cookie.setCookieName("history");
		if(history == null) {
		history = prodNo+"";	
		}
		else if(history!=null && history.indexOf(prodNo)==-1) {
		history = history + "," + prodNo;
		}
		
		cookie.addCookie(response, history);
		
		return "forward:/product/getProduct.jsp";
	}
	
	@RequestMapping(value = "/updateProduct", method = RequestMethod.GET)
	public String updateUserView( @RequestParam("prodNo") String prodNo , Model model ) throws Exception{

		System.out.println("/product/updateProductView");
		//Business Logic
		Product product = productService.getProduct(Integer.parseInt(prodNo));
		// Model �� View ����
		model.addAttribute("product", product);
		
		return "forward:/product/updateProductView.jsp";
	}
	
	@RequestMapping(value = "/updateProduct", method = RequestMethod.POST)
	public String updateUser( @ModelAttribute("product") Product product , Model model) throws Exception{

		System.out.println("/product/updateProduct");
		//Business Logic
		productService.updateProduct(product);
		
		
		return "redirect:/product/getProduct?prodNo="+product.getProdNo();
	}
	
	@RequestMapping("/listProduct")
	public String listProduct( @ModelAttribute("search") Search search , Model model , @RequestParam("menu")String menu) throws Exception{
		
		System.out.println("/product/listProduct");
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		// Business logic ����
		Map<String , Object> map=productService.getProductList(search);
		System.out.println(search);
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		System.out.println(menu);
		// Model �� View ����
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		model.addAttribute("menu", menu);
		return "forward:/product/listProduct.jsp";
	}
}