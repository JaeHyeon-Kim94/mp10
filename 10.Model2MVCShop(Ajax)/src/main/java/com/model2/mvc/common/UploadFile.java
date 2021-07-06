package com.model2.mvc.common;

public class UploadFile {

	private int prodNo;
	private String originFileName;
	private String saveFileName;
	
	
	public UploadFile() {
		// TODO Auto-generated constructor stub
	}


	public int getProdNo() {
		return prodNo;
	}


	public void setProdNo(int prodNo) {
		this.prodNo = prodNo;
	}


	public String getOriginFileName() {
		return originFileName;
	}


	public void setOriginFileName(String originFileName) {
		this.originFileName = originFileName;
	}


	public String getSaveFileName() {
		return saveFileName;
	}


	public void setSaveFileName(String saveFileName) {
		this.saveFileName = saveFileName;
	}


	@Override
	public String toString() {
		return "UploadFile [prodNo=" + prodNo + ", originFileName=" + originFileName + ", saveFileName=" + saveFileName
				+ "]";
	}
	
	

}
