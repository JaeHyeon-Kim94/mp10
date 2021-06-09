package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.purchase.PurchaseDao;

@Repository("purchaseDaoImpl")
public class PurchaseDaoImpl implements PurchaseDao {

	//Field
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;
	
	public PurchaseDaoImpl() {
		System.out.println(this.getClass());
	}

	@Override
	public void addPurchase(Purchase purchase) throws Exception {
		
		sqlSession.insert("PurchaseMapper.addPurchase", purchase);

	}

	@Override
	public Purchase getPurchaseByTranNo(int tranNo) throws Exception {
		
		return sqlSession.selectOne("PurchaseMapper.getPurchaseByTranNo", tranNo);
	}

	@Override
	public Purchase getPurchaseByProdNo(int prodNo) throws Exception {
		
		return sqlSession.selectOne("PurchaseMapper.getPurchaseByProdNo", prodNo);
	}

	@Override
	public List<Purchase> getPurchaseList(Search search, String buyerId) throws Exception {
	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("search", search);
		map.put("buyerId", buyerId);
		
		return sqlSession.selectList("PurchaseMapper.getPurchaseList", map);
	}

	@Override
	public void updatePurcahse(Purchase purchase) throws Exception {
		
		sqlSession.update("PurchaseMapper.updatePurchase", purchase);
	}

	@Override
	public void updateTranCode(Purchase purchase) throws Exception {

		sqlSession.update("PurchaseMapper.updateTranCode", purchase);

	}

	@Override
	public int getTotalCount(Search search) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("PurchaseMapper.getTotalCount", search);
	}

}
