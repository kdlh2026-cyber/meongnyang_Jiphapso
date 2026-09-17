package com.springboot.meongnyang_Jiphapso.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.ProductDetailImageDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductOptionDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;

@Service
public class ProductService {

    @Autowired
    private IProductDao p_dao;
    
    @Autowired
    private ProductESService p_esservice;
    
    public void p_write(ProductDto p_dto) throws Exception {
        p_dao.ProductWrite(p_dto); 
        p_esservice.p_save(p_dto); // 엘라스틱서치에 색인(저장)
    }
    
    public List<ProductDto> p_list() {
        return p_dao.p_list();
    }
    
    public List<ShoppingListDto> p_search(String keyword) throws Exception {
        return p_esservice.p_search(keyword);	
    }

    // 자동완성 + 하이라이트
    public List<Map<String, String>> p_autocomplete(String keyword) throws Exception {
        return p_esservice.p_autocompleteHighlight(keyword);
    }
    
    @Transactional(rollbackFor = Exception.class)
    public void productWrite(ProductDto p_dto, ProductOptionDto o_dto, 
                             MultipartFile o_img, List<MultipartFile> img_urls,
                             int o_quantity, int o_price, String o_default, 
                             String p_title, Integer o_origin_price) throws Exception {
        
        ProductDto findtitle = p_dao.getProductByTitle(p_title);  
        int generatedPno;
        
        if (findtitle == null) {
            p_write(p_dto);
            generatedPno = p_dto.getP_no(); 
        } else {
            generatedPno = findtitle.getP_no(); 
        }
          
        o_dto.setP_no(generatedPno);
        
        if (o_price == 0) {
            o_dto.setO_quantity(0);
        } else {
            o_dto.setO_quantity(o_quantity);
        }
        
        if (o_origin_price == null) {
            o_dto.setO_origin_price(o_price);
        }
        
        if (!"Y".equals(o_default)) {
            o_dto.setO_default("N");
        }
        
        // 메인 이미지 파일 저장
        if (o_img != null && !o_img.isEmpty()) {
            File mainDir = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\main");
            if (!mainDir.exists()) {
                mainDir.mkdirs();
            }
            String o_main_img = o_img.getOriginalFilename();
            o_img.transferTo(new File(mainDir, o_main_img));
            o_dto.setO_main_img(o_main_img);
        } else {
            o_dto.setO_main_img(null);
        }
        
        p_dao.ProductOptionWrite(o_dto);
        
        // 상세 이미지 목록 파일 저장
        if (img_urls != null && !img_urls.isEmpty()) {
            File infoDir = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\info");
            if (!infoDir.exists()) {
                infoDir.mkdirs();
            }

            int sortOrder = 1;
            for (MultipartFile fname : img_urls) {
                if (!fname.isEmpty()) {
                    String img_url = fname.getOriginalFilename();
                    fname.transferTo(new File(infoDir, img_url));

                    ProductDetailImageDto detailDto = new ProductDetailImageDto();
                    detailDto.setImg_url(img_url);
                    detailDto.setImg_sort(sortOrder++);
                    detailDto.setP_no(generatedPno);

                    p_dao.ProductDetailImageWrite(detailDto);
                }
            }
        }
    }
    
    @Transactional(rollbackFor = Exception.class)
    public void productUpdate(ProductDto p_dto, ProductOptionDto o_dto,
                              MultipartFile o_img, List<MultipartFile> img_urls,
                              String existing_o_img, List<Integer> delete_img_nos) throws Exception {

        p_dao.ProductUpdate(p_dto);
        
        int p_no = p_dto.getP_no();
        o_dto.setP_no(p_no);

        if (o_dto.getO_origin_price() == null || o_dto.getO_origin_price() == 0) {
            o_dto.setO_origin_price(o_dto.getO_price());
        }

        if ("Y".equals(o_dto.getO_default())) {
            p_dao.resetProductDefaultOption(p_no);
        } else {
            o_dto.setO_default("N");
        }

        // 메인 이미지 변경 처리
        if (o_img != null && !o_img.isEmpty()) {
            String o_main_img = o_img.getOriginalFilename();
            File uploadPath = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\main");
            if (!uploadPath.exists()) uploadPath.mkdirs();

            o_img.transferTo(new File(uploadPath, o_main_img));
            o_dto.setO_main_img(o_main_img);
        } else {
            o_dto.setO_main_img(existing_o_img);
        }

        // 옵션 정보 수정
        p_dao.ProductOptionUpdate(o_dto);

        // 상세 이미지 디렉토리 준비
        File detailSaveDir = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\info");
        if (!detailSaveDir.exists()) {
            detailSaveDir.mkdirs();
        }

        // 삭제 대상 상세 이미지 제거 및 순서 재정렬
        if (delete_img_nos != null && !delete_img_nos.isEmpty()) {
            List<String> deleteFiles = p_dao.getImageUrlsByNos(delete_img_nos);
            if (deleteFiles != null) {
                for (String fileName : deleteFiles) {
                    File targetFile = new File(detailSaveDir, fileName);
                    if (targetFile.exists()) {
                        targetFile.delete();
                    }
                }
            }
            p_dao.deleteImagesByNos(delete_img_nos);
            p_dao.reorderDetailImages(p_no);
        }

        // 신규 상세 이미지 파일 저장 및 DB 등록
        if (img_urls != null && !img_urls.isEmpty()) {
            int sortOrder = p_dao.getMaxDetailSort(p_no) + 1;
            for (MultipartFile fname : img_urls) {
                if (!fname.isEmpty()) {
                    String img_url = fname.getOriginalFilename();
                    fname.transferTo(new File(detailSaveDir, img_url));

                    ProductDetailImageDto detailDto = new ProductDetailImageDto();
                    detailDto.setP_no(p_no);
                    detailDto.setImg_url(img_url);
                    detailDto.setImg_sort(sortOrder++);

                    p_dao.ProductDetailImageWrite(detailDto);
                }
            }
        }
    }
}