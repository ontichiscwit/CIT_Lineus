package egovframework.com.comm;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler;

public class EgovSampleExcepHndlr implements ExceptionHandler {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleExcepHndlr.class) ;  
	
	@Override
	public void occur(Exception ex, String packageName) {
		// TODO Auto-generated method stub
		
		LOGGER.debug(" EgovServiceExceptionHandler run..........................");
		try{
			LOGGER.debug(" EgovServiceExceptionHandler try..........................");	
		}catch(Exception e){
			LOGGER.debug(" EgovServiceExceptionHandler CATCH..........................");
		}
		
	}
	
}

