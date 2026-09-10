package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class FavoriteDTO {

	private Long faNo;
	private String faToken;
	private Date faAt;
	private Long mNo;
	private Long pNo;

	// 상품 조인 조회
	private String pName; // 상품명
	private String pMainImg; // 대표이미지
	private Long oPrice; // 대표 (기본옵션) 가격
	private Long oOriginPrice; // 대표 (기본옵션) 원가 (할인율 계산용)
	private Long favoriteCount; // 이 상품을 찜한 전체 인원 수 (하트 옆 숫자)
	private Integer quantity; // 수량 선택(주문 이동시 사용, 저장 컬럼 아님)

	public FavoriteDTO() {}

	public Long getFaNo() {return faNo;}
	public void setFaNo(Long faNo) { this.faNo = faNo; }

	public String getFaToken() {return faToken;}
	public void setFaToken(String faToken) { this.faToken = faToken; }

    public Date getFaAt() { return faAt; }
    public void setFaAt(Date faAt) { this.faAt = faAt; }

    public Long getMNo() { return mNo; }
    public void setMNo(Long mNo) { this.mNo = mNo; }

    public Long getPNo() { return pNo; }
    public void setPNo(Long pNo) { this.pNo = pNo; }

    public String getPName() { return pName; }
    public void setPName(String pName) { this.pName = pName; }

    public String getPMainImg() { return pMainImg; }
    public void setPMainImg(String pMainImg) { this.pMainImg = pMainImg; }

    public Long getOPrice() { return oPrice; }
    public void setOPrice(Long oPrice) { this.oPrice = oPrice; }

    public Long getOOriginPrice() { return oOriginPrice; }
    public void setOOriginPrice(Long oOriginPrice) { this.oOriginPrice = oOriginPrice; }

    public Long getFavoriteCount() { return favoriteCount; }
    public void setFavoriteCount(Long favoriteCount) { this.favoriteCount = favoriteCount; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    @Override
    public String toString() {
        return "FavoriteDTO{" +
                "faNo=" + faNo +
                ", mNo=" + mNo +
                ", pNo=" + pNo +
                '}';
    }


}