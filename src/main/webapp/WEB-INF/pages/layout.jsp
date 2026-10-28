<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="utils.DateUtils" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<c:set var="user" value="${sessionScope.ConnectedUser}" scope="request" />
<c:set var="role" value="${user.role}" scope="request" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}"/> · SoutenaPro</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'system-ui', 'sans-serif'] },
                    colors: { accent: { 50:'#f0fdfa',100:'#ccfbf1',200:'#99f6e4',300:'#5eead4',400:'#2dd4bf',500:'#14b8a6',600:'#0d9488',700:'#0f766e',800:'#115e59',900:'#134e4a' } }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', system-ui, sans-serif; }
        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 999px; }
        ::-webkit-scrollbar-track { background: transparent; }
        @media print {
            aside, header, .no-print { display: none !important; }
            main { padding: 0 !important; max-width: none !important; }
        }
    </style>
</head>
<body class="min-h-screen bg-[#F6F7F9] text-slate-800 antialiased">

<!-- Voile mobile -->
<div id="overlay" class="fixed inset-0 z-30 hidden bg-slate-900/40 backdrop-blur-sm lg:hidden" onclick="fermerMenu()"></div>

<!-- Barre latérale -->
<aside id="sidebar" class="fixed inset-y-0 left-0 z-40 flex w-72 -translate-x-full flex-col border-r border-slate-200/70 bg-white transition-transform duration-300 lg:translate-x-0">
    <div class="flex h-20 items-center gap-3 px-6">
        <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-gradient-to-br from-accent-600 to-accent-800 text-white shadow-sm shadow-accent-700/30">
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" />
            </svg>
        </div>
        <div class="leading-tight">
            <p class="text-[15px] font-semibold tracking-tight text-slate-900">SoutenaPro</p>
            <p class="text-[11px] text-slate-400">Gestion des soutenances</p>
        </div>
        <button type="button" onclick="fermerMenu()" class="ml-auto rounded-lg p-1.5 text-slate-400 hover:bg-slate-100 lg:hidden" aria-label="Fermer le menu">
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12"/></svg>
        </button>
    </div>

    <nav class="flex-1 overflow-y-auto px-3 pb-6">
        <p class="mb-2 px-3 text-[10px] font-semibold uppercase tracking-wider text-slate-400">Navigation</p>
        <ul class="space-y-1">
            <c:choose>
                <%-- ===================== ADMINISTRATEUR ===================== --%>
                <c:when test="${role == 1}">
                    <li>
                        <a href="${ctx}/admin" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'dashboard' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'dashboard' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z"/></svg>
                            Tableau de bord
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/admin/etudiants" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'etudiants' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'etudiants' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z"/></svg>
                            Étudiants
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/admin/enseignants" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'enseignants' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'enseignants' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5"/></svg>
                            Enseignants
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/admin/soutenances" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'soutenances' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'soutenances' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                            Soutenances
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/admin/resultats" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'resultats' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'resultats' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
                            Résultats
                        </a>
                    </li>
                </c:when>

                <%-- ===================== ENSEIGNANT ===================== --%>
                <c:when test="${role == 2}">
                    <li>
                        <a href="${ctx}/enseignant" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'dashboard' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'dashboard' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z"/></svg>
                            Tableau de bord
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/enseignant/soutenances" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'soutenances' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'soutenances' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                            Mes soutenances
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/enseignant/evaluations" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'evaluations' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'evaluations' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M11.35 3.836c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m8.9-4.414c.376.023.75.05 1.124.08 1.131.088 1.976 1.05 1.976 2.185V8.25M8.25 8.25h8.4m-8.4 0H6.375c-1.036 0-1.875.84-1.875 1.875v9.75c0 1.036.839 1.875 1.875 1.875h11.25c1.036 0 1.875-.839 1.875-1.875v-9.75c0-1.036-.839-1.875-1.875-1.875H15.6m-7.35 0V6.108c0-.414.336-.75.75-.75h.008a.75.75 0 0 1 .75.75v.356m0 0h4.5m-4.5 0V6.108c0-.414.336-.75.75-.75h.008a.75.75 0 0 1 .75.75v.356m0 0h4.5"/></svg>
                            Mes évaluations
                        </a>
                    </li>
                </c:when>

                <%-- ===================== ÉTUDIANT ===================== --%>
                <c:otherwise>
                    <li>
                        <a href="${ctx}/etudiant" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'dashboard' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'dashboard' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12 11.54 2.71a2.25 2.25 0 0 1 3.182 0l9.288 9.29M4.5 9.75v10.5a.75.75 0 0 0 .75.75h4.5a.75.75 0 0 0 .75-.75V15a.75.75 0 0 1 .75-.75h3a.75.75 0 0 1 .75.75v5.25a.75.75 0 0 0 .75.75h4.5a.75.75 0 0 0 .75-.75V9.75"/></svg>
                            Tableau de bord
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/etudiant/soutenance" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'soutenance' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'soutenance' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                            Ma soutenance
                        </a>
                    </li>
                    <li>
                        <a href="${ctx}/etudiant/resultat" class="group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition ${pageActive == 'resultat' ? 'bg-accent-50 text-accent-800' : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}">
                            <svg class="h-[18px] w-[18px] ${pageActive == 'resultat' ? 'text-accent-700' : 'text-slate-400 group-hover:text-slate-600'}" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
                            Mon résultat
                        </a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>

        <div class="mt-8 rounded-2xl bg-gradient-to-br from-accent-700 to-accent-900 p-4 text-white">
            <p class="text-xs font-medium text-white/70">Aide</p>
            <p class="mt-1 text-[13px] font-semibold leading-snug">Besoin d'un coup de main ?</p>
            <p class="mt-1 text-[11px] leading-relaxed text-white/60">Contactez le service de scolarité pour toute question sur votre soutenance.</p>
            <a href="mailto:scolarite@universite.cm" class="mt-3 inline-flex items-center gap-1.5 text-[11px] font-medium text-accent-200 hover:text-white">
                Écrire à la scolarité
                <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
            </a>
        </div>
    </nav>

    <div class="border-t border-slate-100 p-3">
        <div class="flex items-center gap-3 rounded-xl px-2 py-2">
            <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-accent-100 text-xs font-semibold text-accent-800">
                <c:out value="${user.initiales}"/>
            </div>
            <div class="min-w-0 flex-1">
                <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${user.prenom}"/> <c:out value="${user.nom}"/></p>
                <p class="truncate text-[11px] text-slate-400"><c:out value="${user.roleLibelle}"/></p>
            </div>
            <a href="${ctx}/logout" title="Se déconnecter" class="rounded-lg p-2 text-slate-400 transition hover:bg-rose-50 hover:text-rose-600">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0 0 13.5 3h-6a2.25 2.25 0 0 0-2.25 2.25v13.5A2.25 2.25 0 0 0 7.5 21h6a2.25 2.25 0 0 0 2.25-2.25V15m3 0 3-3m0 0-3-3m3 3H9"/></svg>
            </a>
        </div>
    </div>
</aside>

<!-- Contenu -->
<div class="lg:pl-72">
    <header class="sticky top-0 z-20 border-b border-slate-200/70 bg-[#F6F7F9]/85 backdrop-blur">
        <div class="mx-auto flex h-20 max-w-7xl items-center gap-4 px-4 sm:px-6 lg:px-8">
            <button type="button" onclick="ouvrirMenu()" class="rounded-xl border border-slate-200 bg-white p-2 text-slate-500 shadow-sm lg:hidden" aria-label="Ouvrir le menu">
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"/></svg>
            </button>
            <div class="min-w-0 flex-1">
                <h1 class="truncate text-lg font-semibold tracking-tight text-slate-900 sm:text-xl"><c:out value="${pageTitle}"/></h1>
                <p class="truncate text-xs text-slate-500 sm:text-[13px]"><c:out value="${pageSubtitle}"/></p>
            </div>
            <div class="hidden items-center gap-2 rounded-xl border border-slate-200 bg-white px-3 py-2 text-xs text-slate-500 shadow-sm md:flex">
                <svg class="h-4 w-4 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                <%= DateUtils.aujourdHui() %>
            </div>
        </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-7 sm:px-6 lg:px-8 lg:py-9">

        <c:if test="${not empty sessionScope.flashSuccess}">
            <div class="mb-5 flex items-start gap-3 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800">
                <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
                <span><c:out value="${sessionScope.flashSuccess}"/></span>
            </div>
            <c:remove var="flashSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.flashError}">
            <div class="mb-5 flex items-start gap-3 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700">
                <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z"/></svg>
                <span><c:out value="${sessionScope.flashError}"/></span>
            </div>
            <c:remove var="flashError" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.flashInfo}">
            <div class="mb-5 flex items-start gap-3 rounded-2xl border border-sky-200 bg-sky-50 px-4 py-3 text-sm text-sky-700">
                <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z"/></svg>
                <span><c:out value="${sessionScope.flashInfo}"/></span>
            </div>
            <c:remove var="flashInfo" scope="session"/>
        </c:if>

        <jsp:include page="${contenu}" />

        <footer class="mt-12 flex flex-col items-center justify-between gap-2 border-t border-slate-200/70 pt-6 text-[11px] text-slate-400 sm:flex-row no-print">
            <p>© 2026 SoutenaPro · Plateforme de gestion des soutenances</p>
            <p>M1 Génie Logiciel · Jakarta EE 10</p>
        </footer>
    </main>
</div>

<script>
    function ouvrirMenu() {
        document.getElementById('sidebar').classList.remove('-translate-x-full');
        document.getElementById('overlay').classList.remove('hidden');
    }
    function fermerMenu() {
        document.getElementById('sidebar').classList.add('-translate-x-full');
        document.getElementById('overlay').classList.add('hidden');
    }

    // Empêche un double clic sur un formulaire POST de créer deux fois la même
    // entité (le second envoi provoquerait une erreur de doublon en base).
    document.addEventListener('submit', function (event) {
        var form = event.target;
        if (!form || (form.getAttribute('method') || '').toLowerCase() !== 'post') return;
        if (form.dataset.envoiEnCours === '1') {
            event.preventDefault();
            return;
        }
        form.dataset.envoiEnCours = '1';
        window.setTimeout(function () {
            var boutons = form.querySelectorAll('button[type="submit"], input[type="submit"]');
            for (var i = 0; i < boutons.length; i++) {
                boutons[i].disabled = true;
                boutons[i].classList.add('opacity-60', 'cursor-not-allowed');
            }
        }, 0);
    });

    // Si la page revient depuis le cache du navigateur (bouton Retour), on
    // réactive les boutons pour pouvoir soumettre à nouveau.
    window.addEventListener('pageshow', function () {
        var formulaires = document.querySelectorAll('form[data-envoi-en-cours="1"]');
        for (var i = 0; i < formulaires.length; i++) {
            delete formulaires[i].dataset.envoiEnCours;
            var boutons = formulaires[i].querySelectorAll('button[type="submit"], input[type="submit"]');
            for (var j = 0; j < boutons.length; j++) {
                boutons[j].disabled = false;
                boutons[j].classList.remove('opacity-60', 'cursor-not-allowed');
            }
        }
    });
</script>
</body>
</html>
