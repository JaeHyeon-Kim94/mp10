package com.model2.mvc.web.purchase;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.user.UserService;
@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

	
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public PurchaseController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	@RequestMapping(value = "/addPurchase", method= RequestMethod.GET)
	public String addPurchaseView(@RequestParam int prodNo, Model model, HttpSession session) throws Exception{
		
		System.out.println("/purchase/addPurchase : GET");
		
		Product product = productService.getProduct(prodNo);
	
		
		model.addAttribute(product);
		return "forward:/purchase/addPurchaseView.jsp";
	}

	
	@RequestMapping(value = "/addPurchase", method = RequestMethod.POST)
	public String addPurchase( @ModelAttribute("purchase")Purchase purchase, 
								@RequestParam("prodNo")int prodNo,
								@RequestParam("userId")String userId) throws Exception{
		
		Product product = productService.getProduct(prodNo);
		User user = userService.getUser(userId);
		
		System.out.println("/purchase/addPurchase");
		purchase.setTranCode("1");
		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);
		purchaseService.addPurchase(purchase);

		return "forward:/purchase/addPurchase.jsp";
	}
	
	@RequestMapping( value= "/getPurchaseByProdNo")
	public String getPurchaseByProdNo( @RequestParam("prodNo") int prodNo, Model model, HttpSession session) throws Exception{
		
		System.out.println("/purchase/getPurchaseByProdNo");
		
		Purchase purchase = purchaseService.getPurchaseByProdNo(prodNo);
		purchase.setBuyer((User)session.getAttribute("user"));
		purchase.setPurchaseProd(productService.getProduct(prodNo));
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
	@RequestMapping( value= "/getPurchaseByTranNo")
	public String getPurchaseByTranNo( @RequestParam("tranNo") int tranNo, Model model, HttpSession session) throws Exception{
		
		System.out.println("/purchase/getPurchaseByTranNo");

		Purchase purchase = purchaseService.getPurchaseByTranNo(tranNo);
		purchase.setBuyer((User)session.getAttribute("user"));
		purchase.setPurchaseProd((Product)productService.getProduct(purchase.getPurchaseProd().getProdNo()));
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
	@RequestMapping( value= "/updatePurchase", method = RequestMethod.GET)
	public String updatePurchaseView( @RequestParam("tranNo")String tranNo, Model model, HttpSession session) throws Exception{
		
		System.out.println("/purchase/updatePurchase (View) : GET");
		
		Purchase purchase = purchaseService.getPurchaseByTranNo(Integer.parseInt(tranNo));
		purchase.setBuyer((User)session.getAttribute("user"));
		purchase.setPurchaseProd((Product)productService.getProduct(purchase.getPurchaseProd().getProdNo()));
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/updatePurchaseView.jsp";
	}
	
	@RequestMapping( value="/updatePurchase", method= RequestMethod.POST)
	public String updatePurchase ( @ModelAttribute("purchase")Purchase purchase, HttpSession session) throws Exception{

		
		
		System.out.println("/purchase/updatePurchase : POST");
		
		purchaseService.updatePurcahse(purchase);
		
		return "forward:/purchase/updatePurchase.jsp";
		
		
	}
	
	@RequestMapping( value="/listPurchase")
	public String listPurchase( @ModelAttribute("search")Search search, Model model, HttpSession session) throws Exception{
		
		System.out.println("/purchase/listPurchase");
		if(search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
	
		User user = (User)session.getAttribute("user");
	
		Map<String, Object> map = purchaseService.getPurchaseList(search, user.getUserId());

	
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);

		System.out.println(search.getPageSize());
		System.out.println(search.getCurrentPage());

		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/purchase/listPurchase.jsp";
	}
	
	@RequestMapping( value="/updateTranCode", method=RequestMethod.GET)
	public String updateTranCode ( @RequestParam("prodNo")int prodNo,
								@RequestParam("menu")String menu,
								@RequestParam("tranCode")String tranCode) throws Exception{
		Purchase purchase = purchaseService.getPurchaseByProdNo(prodNo);
		purchase.setTranCode(tranCode);
		
		purchaseService.updatePurcahse(purchase);
		
		return "forward:/product/listProduct?menu"+menu;
	}
	
}
