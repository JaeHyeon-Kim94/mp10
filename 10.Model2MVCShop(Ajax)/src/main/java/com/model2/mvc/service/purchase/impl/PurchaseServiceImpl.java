package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;
import com.model2.mvc.service.purchase.PurchaseService;

@Service("purchaseServiceImpl")
public class PurchaseServiceImpl implements PurchaseService {

	//Field
	@Autowired
	@Qualifier("purchaseDaoImpl")
	private PurchaseDao purchaseDao;


	@Override
	public void addPurchase(Purchase purchase) throws Exception {
		
		purchaseDao.addPurchase(purchase);

	}

	@Override
	public Purchase getPurchaseByTranNo(int tranNo) throws Exception {
	
		
		return purchaseDao.getPurchaseByTranNo(tranNo);
	}

	@Override
	public Purchase getPurchaseByProdNo(int ProdNo) throws Exception {
		
		return purchaseDao.getPurchaseByProdNo(ProdNo);
	}

	@Override
	public Map<String, Object> getPurchaseList(Search search, String buyerId) throws Exception {
		 
	
		return purchaseDao.getPurchaseList(search, buyerId);
	}

	@Override
	public void updatePurcahse(Purchase purchase) throws Exception {

		purchaseDao.updatePurcahse(purchase);

	}

	@Override
	public void updateTranCode(Purchase purchase) throws Exception {
		
		purchaseDao.updateTranCode(purchase);

	}

}
