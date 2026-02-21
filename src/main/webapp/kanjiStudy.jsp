<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.AccountDTO, model.KanjiDTO, model.KanjiDAO" %>
<%@ page import="java.util.List, java.util.Collections" %>
<%
    // ========== 로그인 체크 ==========
    AccountDTO user = (AccountDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // ========== 파라미터 받기 ==========
    String level = request.getParameter("level");
    int sector = Integer.parseInt(request.getParameter("sector"));
    
    // ========== DB에서 한자 가져오기 ==========
    KanjiDAO kanjiDAO = new KanjiDAO();
    List<KanjiDTO> kanjiList = kanjiDAO.getKanjiByLevelSector(level, sector);
    
    // ========== ★ 랜덤 셔플 처리 ==========
    // 세션에 셔플된 리스트를 저장해서 이전/다음 버튼 눌러도 순서 유지
    String sessionKey = "shuffled_" + level + "_" + sector;
    String resetParam = request.getParameter("reset"); // 새로 셔플하고 싶을 때
    
    @SuppressWarnings("unchecked")
    List<KanjiDTO> shuffledList = (List<KanjiDTO>) session.getAttribute(sessionKey);
    
    // 세션에 없거나, reset 파라미터가 있으면 새로 셔플
    if (shuffledList == null || "true".equals(resetParam) || shuffledList.size() != kanjiList.size()) {
        Collections.shuffle(kanjiList);
        session.setAttribute(sessionKey, kanjiList);
        shuffledList = kanjiList;
    }
    
    int totalInSector = shuffledList.size();
    
    // ========== 현재 인덱스 ==========
    int currentIndex = 0;
    String indexParam = request.getParameter("index");
    if (indexParam != null) {
        currentIndex = Integer.parseInt(indexParam);
    }
    
    // 범위 체크
    if (currentIndex >= totalInSector) currentIndex = totalInSector - 1;
    if (currentIndex < 0) currentIndex = 0;
    
    KanjiDTO currentKanji = null;
    if (totalInSector > 0) {
        currentKanji = shuffledList.get(currentIndex);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>한자 학습 - <%= level %> 섹터 <%= sector %></title>
    <link rel="stylesheet" href="css/study.css">
</head>
<body>
    <div class="container">
        <div class="header">한자 학습</div>
        
        <% if (currentKanji != null) { %>
            <div class="progress"><%= currentIndex + 1 %>/<%= totalInSector %></div>
            
            <!-- 한국어 뜻 + 한자 -->
            <div class="korean-meaning"><%= currentKanji.getKoreanMeaning() %></div>
            <div class="kanji-char" 
                 onclick="location.href='kanjiDetail.jsp?level=<%= level %>&sector=<%= sector %>&index=<%= currentIndex %>'">
                <%= currentKanji.getKanji() %>
            </div>
            
            <!-- 읽기 정보 -->
            <div class="reading-section">
                <p><strong>음독:</strong> 
                    <%= currentKanji.getOnyomi1() != null ? currentKanji.getOnyomi1() : "-" %><%= currentKanji.getOnyomi2() != null ? ", " + currentKanji.getOnyomi2() : "" %><%= currentKanji.getOnyomi3() != null ? ", " + currentKanji.getOnyomi3() : "" %>
                </p>
                <p><strong>훈독:</strong> 
                    <%= currentKanji.getKunyomi1() != null ? currentKanji.getKunyomi1() : "-" %><%= currentKanji.getKunyomi2() != null ? ", " + currentKanji.getKunyomi2() : "" %><%= currentKanji.getKunyomi3() != null ? ", " + currentKanji.getKunyomi3() : "" %>
                </p>
            </div>
            
            <!-- 의미 설명 -->
            <% if (currentKanji.getMeaningDescription() != null) { %>
                <div class="meaning-desc"><%= currentKanji.getMeaningDescription() %></div>
            <% } %>
            
            <!-- 예시 단어 -->
            <div class="example-section">
                <h3>예시 단어</h3>
                <% if (currentKanji.getExample1() != null && !currentKanji.getExample1().isEmpty()) { %>
                    <p><%= currentKanji.getExample1() %></p>
                <% } %>
                <% if (currentKanji.getExample2() != null && !currentKanji.getExample2().isEmpty()) { %>
                    <p><%= currentKanji.getExample2() %></p>
                <% } %>
                <% if (currentKanji.getExample3() != null && !currentKanji.getExample3().isEmpty()) { %>
                    <p><%= currentKanji.getExample3() %></p>
                <% } %>
            </div>
            
            <!-- 이전/다음 버튼 -->
            <div class="nav-buttons">
                <button class="nav-btn" <%= currentIndex == 0 ? "disabled" : "" %>
                    onclick="location.href='kanjiStudy.jsp?level=<%= level %>&sector=<%= sector %>&index=<%= currentIndex - 1 %>'">
                    ◀
                </button>
                <button class="nav-btn" <%= currentIndex >= totalInSector - 1 ? "disabled" : "" %>
                    onclick="location.href='kanjiStudy.jsp?level=<%= level %>&sector=<%= sector %>&index=<%= currentIndex + 1 %>'">
                    ▶
                </button>
            </div>
            
            <!-- 마지막 한자일 때 테스트 버튼 -->
            <% if (currentIndex == totalInSector - 1) { %>
                <button class="test-btn" onclick="location.href='Test_main.jsp?level=<%= level %>&sector=<%= sector %>'">
                    🎯 테스트 시작하기
                </button>
            <% } %>
            
        <% } else { %>
            <p>등록된 한자가 없습니다.</p>
        <% } %>
        
        <button class="back-btn" onclick="location.href='sectorSelect.jsp?level=<%= level %>'">섹터 선택으로</button>
    </div>
</body>
</html>