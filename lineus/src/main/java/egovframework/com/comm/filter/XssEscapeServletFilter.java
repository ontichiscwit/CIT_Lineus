package egovframework.com.comm.filter;

import java.io.IOException;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class XssEscapeServletFilter implements Filter {

    private XssEscapeFilter xssEscapeFilter = XssEscapeFilter.getInstance();

    @Override
    public void init(FilterConfig arg0) throws ServletException {}

    @Override
    public void destroy() {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse originalRes = (HttpServletResponse) response;

        // CORS 헤더
        originalRes.setHeader("Access-Control-Allow-Origin", "https://newsfe.cwit.co.kr:8443");
        originalRes.setHeader("Access-Control-Allow-Credentials", "true");
        originalRes.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        originalRes.setHeader("Access-Control-Allow-Headers", "Content-Type, X-Requested-With");

        // CSP 설정
        originalRes.setHeader("Content-Security-Policy", "frame-ancestors 'self' https://newsfe.cwit.co.kr:8443");

        // OPTIONS 프리플라이트 요청 처리
        if ("OPTIONS".equalsIgnoreCase(req.getMethod())) {
            originalRes.setStatus(HttpServletResponse.SC_OK);
            originalRes.flushBuffer(); // 명시적 종료
            return;
        }

        // 쿠키 SameSite=None; Secure 추가
        HttpServletResponse wrappedRes = new HttpServletResponseWrapper(originalRes) {
            @Override
            public void addHeader(String name, String value) {
                if ("Set-Cookie".equalsIgnoreCase(name) && value.contains("JSESSIONID")) {
                    value += "; SameSite=None; Secure";
                }
                super.addHeader(name, value);
            }

            @Override
            public void setHeader(String name, String value) {
                if ("Set-Cookie".equalsIgnoreCase(name) && value.contains("JSESSIONID")) {
                    value += "; SameSite=None; Secure";
                }
                super.setHeader(name, value);
            }
        };

        chain.doFilter(new XssEscapeServletFilterWrapper(request, xssEscapeFilter), wrappedRes);
    }
}
