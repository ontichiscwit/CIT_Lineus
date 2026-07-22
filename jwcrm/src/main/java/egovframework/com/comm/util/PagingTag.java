package egovframework.com.comm.util;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoader;

import egovframework.com.comm.model.PagingVO;


public class PagingTag extends BodyTagSupport{

	private static final long serialVersionUID = -6994599973294312726L;
	
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(PagingTag.class) ; 
	
	private PagingVO data ;

	public PagingVO getData() {
		return data;
	}

	public void setData(PagingVO data) {
		this.data = data;
	} 
	
	public int doStartTag() throws JspException {
		StringBuffer sb = new StringBuffer() ; 
		
		try{
			pageContext.getOut().print(sb.toString()) ; 
		}catch(Exception e){sb.setLength(0);}
		
		return EVAL_BODY_INCLUDE;
	}
	
	public int doEndTag() throws JspException{
		StringBuffer sb = new StringBuffer() ; 
		ApplicationContext ctx = ContextLoader.getCurrentWebApplicationContext() ; 
		
		String paging_location = SsStringUtil.normalize(data.getPaging_location(), "ad") ; 
		
		int pre10 = data.getPage() - 1; 
		int next10 = data.getPage() + 1 ; 
		
		if(pre10 < 1) pre10 = 1; 
		if(next10 > data.getPageCnt() ) next10 = data.getPageCnt();
		
		int beginLinkPage = (data.getPage() - 1) / data.getBlockSize() * data.getBlockSize() + 1;
		
		if(data.getPageCnt() != 0){
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList(1)\">&lt;&lt;</a>");
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList("+pre10+")\">&lt;</a>") ;	
		}
		
		for(int i = beginLinkPage; i < beginLinkPage + data.getBlockSize() ; i++ ){
			if(i > data.getPageCnt()) break ; 
			if(i == data.getPage()) {
				sb.append("			<a href=\"javascript:void(0);\" onclick=\"goList("+i+")\" class=\"on\">"+i+"</a>");
			}else{
				sb.append("			<a href=\"javascript:void(0);\" onclick=\"goList("+i+")\">"+i+"</a>");
			}
		}
		
		if(data.getPageCnt() != 0){
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList("+next10+")\">&gt;</a>") ;	
			sb.append("		<a href=\"javascript:void(0);\" onclick=\"goList("+data.getPageCnt()+")\">&gt;&gt;</a>");
		}
		
		try{
			pageContext.getOut().print(sb.toString()) ; 
		}catch(Exception e){
			throw new JspException("Error : " + e.toString()) ; 
		}
		
		
		return EVAL_PAGE ; 
		
	}
	
}
