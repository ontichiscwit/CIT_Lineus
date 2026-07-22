package egovframework.com.comm;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.rte.fdl.cmmn.exception.handler.ExceptionHandler;

public class EgovSampleOthersExcepHndlr implements ExceptionHandler{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleOthersExcepHndlr.class);

	@Override
	public void occur(Exception arg0, String arg1) {
		// TODO Auto-generated method stub
		LOGGER.debug(" EgovServiceExceptionHandler run...............");
	}

}
