package com.model2.mvc.service.purchase.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
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
		
		return sqlSession.selectOne("PurchaseMapper.findPurchaseByTranNo", tranNo);
	}

	@Override
	public Purchase getPurchaseByProdNo(int prodNo) throws Exception {
		
		return sqlSession.selectOne("PurchaseMapper.findPurchaseByProdNo", prodNo);
	}

	@Override
	public Map<String , Object> getPurchaseList(Search search, String buyerId) throws Exception {
	
		System.out.println(search.getStartRowNum());
		System.out.println(search.getEndRowNum());
		Map<String , Object>  map = new HashMap<String, Object>();
		
		map.put("search", search);
		map.put("buyerId", buyerId);
	
		
		List<Purchase> list = sqlSession.selectList("PurchaseMapper.getPurchaseList", map); 
		
		System.out.println(list.get(0));
		System.out.println(list.get(1));
		System.out.println(list.get(2));
		
		for (int i = 0; i < list.size(); i++) {
			System.out.println("start");
			list.get(i).setBuyer((User)sqlSession.selectOne("UserMapper.getUser", list.get(i).getBuyer().getUserId()));
			System.out.println("setBuyer");
			list.get(i).setPurchaseProd((Product)sqlSession.selectOne("ProductMapper.findProduct", list.get(i).getPurchaseProd().getProdNo()));
			System.out.println("setProdPurchase");
		}
		
		
		map.put("totalCount", sqlSession.selectOne("PurchaseMapper.getTotalCount", buyerId));
		map.put("list", list);
		
		return map;
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
