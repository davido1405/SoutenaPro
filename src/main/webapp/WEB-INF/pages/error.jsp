<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="user" value="${sessionScope.ConnectedUser}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Une erreur est survenue · SoutenaPro</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>body { font-family: 'Inter', system-ui, sans-serif; }</style>
</head>
<body class="flex min-h-screen items-center justify-center bg-[#F6F7F9] px-5 py-12 text-slate-800 antialiased">
    <div class="w-full max-w-lg rounded-3xl border border-slate-200/70 bg-white p-8 text-center shadow-sm shadow-slate-200/40">
        <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-rose-50 text-rose-500">
            <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke-width="1.6" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m0 3.75h.008v.008H12v-.008ZM21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
        </div>
        <h1 class="mt-5 text-lg font-semibold tracking-tight text-slate-900">
            <c:out value="${empty erreurTitre ? 'Une erreur est survenue' : erreurTitre}"/>
        </h1>
        <p class="mt-2 text-sm text-slate-500">
            <c:out value="${empty erreurMessage ? 'Le chargement de la page a échoué. Veuillez réessayer.' : erreurMessage}"/>
        </p>
        <c:if test="${not empty erreurDetail}">
            <p class="mt-3 inline-block rounded-lg bg-slate-50 px-3 py-1.5 font-mono text-[10px] text-slate-400"><c:out value="${erreurDetail}"/></p>
        </c:if>
        <div class="mt-7 flex flex-col justify-center gap-2 sm:flex-row">
            <c:choose>
                <c:when test="${user.role == 1}"><c:set var="accueil" value="/admin"/></c:when>
                <c:when test="${user.role == 2}"><c:set var="accueil" value="/enseignant"/></c:when>
                <c:when test="${user.role == 3}"><c:set var="accueil" value="/etudiant"/></c:when>
                <c:otherwise><c:set var="accueil" value="/login"/></c:otherwise>
            </c:choose>
            <a href="${ctx}${accueil}" class="rounded-xl bg-accent-700 px-5 py-2.5 text-xs font-semibold text-white transition hover:bg-accent-800">Retour à l'accueil</a>
            <a href="${ctx}/logout" class="rounded-xl border border-slate-200 px-5 py-2.5 text-xs font-medium text-slate-600 transition hover:bg-slate-50">Se déconnecter</a>
        </div>
    </div>
</body>
</html>
