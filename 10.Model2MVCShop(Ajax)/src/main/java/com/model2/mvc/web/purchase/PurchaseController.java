package com.model2.mvc.web.purchase;

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
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
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
	
	public PurchaseController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	@RequestMapping(value = "/addPurchase", method= RequestMethod.GET)
	public String addPurchaseView() throws Exception{
		
		System.out.println("/purchase/addPurchase : GET");
		
		return "redirect:/purchase/addPurchaseView.jsp";
	}

	
	@RequestMapping(value = "/addPurchase", method = RequestMethod.POST)
	public String addPurchase( @ModelAttribute("purchase")Purchase purchase	) throws Exception{
		
		System.out.println("/purchase/addPurchase");
		
		purchaseService.addPurchase(purchase);
		
		return "forward:/purchase/addPurchase.jsp";
	}
	
	@RequestMapping( value= "/getPurchaseByProdNo")
	public String getPurchaseByProdNo( @RequestParam("prodNo") String prodNo, Model model) throws Exception{
		
		System.out.println("/purchase/getPurchaseByProdNo");
		
		Purchase purchase = purchaseService.getPurchaseByProdNo(Integer.parseInt(prodNo));
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
	@RequestMapping( value= "/getPurchaseByTranNo")
	public String getPurchaseByTranNo( @RequestParam("tranNo") String tranNo, Model model) throws Exception{
		
		System.out.println("/purchase/getPurchaseByTranNo");
		
		Purchase purchase = purchaseService.getPurchaseByProdNo(Integer.parseInt(tranNo));
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
	@RequestMapping( value= "/updatePurchase", method = RequestMethod.GET)
	public String updatePurchaseView( @RequestParam("tranNo")String tranNo, Model model) throws Exception{
		
		System.out.println("/purchase/updatePurchase : GET");
		
		Purchase purchase = purchaseService.getPurchaseByTranNo(Integer.parseInt(tranNo));
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/updatePurchaseView.jsp";
	}
	
	@RequestMapping( value="/updatePurchase", method= RequestMethod.POST)
	public String updatePurchase ( @ModelAttribute("purchase")Purchase purchase) throws Exception{
		
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
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		return "forward:/purchase/listPurchase.jsp";
	}
	
	@RequestMapping( value="/updateTranCode")
	public String updateTranCode ( @RequestParam("tranNo")String tranNo, @RequestParam("menu")String menu) throws Exception{
		
		
		return "forward:/product/listProduct";
	}
	
}
