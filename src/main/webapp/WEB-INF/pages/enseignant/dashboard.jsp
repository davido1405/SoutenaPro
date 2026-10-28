<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Bandeau -->
<div class="overflow-hidden rounded-2xl bg-gradient-to-br from-accent-700 via-accent-800 to-[#0b3b38] p-6 text-white shadow-sm shadow-accent-900/20 sm:p-7">
    <div class="flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
        <div>
            <p class="text-xs font-medium uppercase tracking-wider text-white/50">Espace enseignant</p>
            <h2 class="mt-2 text-xl font-semibold tracking-tight sm:text-2xl">Bonjour <c:out value="${sessionScope.ConnectedUser.prenom}"/> 👋</h2>
            <p class="mt-1.5 max-w-lg text-sm text-white/60">
                <c:choose>
                    <c:when test="${enAttente > 0}">Vous avez <span class="font-semibold text-accent-200"><c:out value="${enAttente}"/> évaluation(s)</span> en attente de saisie.</c:when>
                    <c:otherwise>Toutes vos évaluations sont à jour. Merci pour votre rigueur.</c:otherwise>
                </c:choose>
            </p>
            <div class="mt-4 flex flex-wrap gap-2">
                <a href="${ctx}/enseignant/evaluations" class="inline-flex items-center gap-2 rounded-xl bg-white px-4 py-2.5 text-xs font-semibold text-accent-900 shadow-sm transition hover:bg-accent-50">
                    Saisir mes notes
                    <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                </a>
                <a href="${ctx}/enseignant/soutenances" class="inline-flex items-center gap-2 rounded-xl border border-white/15 bg-white/5 px-4 py-2.5 text-xs font-medium text-white/80 transition hover:bg-white/10">
                    Mon planning
                </a>
            </div>
        </div>
        <div class="flex shrink-0 items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-5 py-4 backdrop-blur">
            <div class="text-right">
                <p class="text-[10px] uppercase tracking-wider text-white/40">À évaluer</p>
                <p class="text-3xl font-semibold leading-none"><c:out value="${enAttente}"/></p>
            </div>
            <div class="h-10 w-px bg-white/10"></div>
            <div class="text-right">
                <p class="text-[10px] uppercase tracking-wider text-white/40">Soutenances</p>
                <p class="text-3xl font-semibold leading-none"><c:out value="${toutesSoutenances.size()}"/></p>
            </div>
        </div>
    </div>
</div>

<!-- Statistiques -->
<div class="mt-5 grid gap-4 sm:grid-cols-3">
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-center justify-between">
            <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Notes saisies</p>
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-50 text-emerald-600">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
            </div>
        </div>
        <p class="mt-2 text-2xl font-semibold text-slate-900"><c:out value="${saisies}"/></p>
        <p class="mt-1 text-xs text-slate-400">évaluations complétées</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-center justify-between">
            <p class="text-xs font-medium uppercase tracking-wide text-slate-400">En attente</p>
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-50 text-amber-600">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
            </div>
        </div>
        <p class="mt-2 text-2xl font-semibold text-slate-900"><c:out value="${enAttente}"/></p>
        <p class="mt-1 text-xs text-slate-400">notes à saisir</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-center justify-between">
            <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Encadrements</p>
            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-indigo-50 text-indigo-600">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Z"/></svg>
            </div>
        </div>
        <p class="mt-2 text-2xl font-semibold text-slate-900"><c:out value="${nbEncadres}"/></p>
        <p class="mt-1 text-xs text-slate-400">étudiants encadrés</p>
    </div>
</div>

<div class="mt-5 grid gap-5 lg:grid-cols-2">

    <!-- À évaluer -->
    <div class="rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
        <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4">
            <div>
                <h2 class="text-sm font-semibold text-slate-900">Évaluations à saisir</h2>
                <p class="text-xs text-slate-400">Vos notes de jury en attente</p>
            </div>
            <a href="${ctx}/enseignant/evaluations" class="text-xs font-medium text-accent-700 hover:text-accent-800">Tout voir</a>
        </div>
        <c:choose>
            <c:when test="${empty evaluations}">
                <div class="px-5 py-10 text-center">
                    <p class="text-sm text-slate-500">Aucune évaluation pour le moment.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="divide-y divide-slate-100">
                    <c:set var="compteur" value="0"/>
                    <c:forEach var="ev" items="${evaluations}">
                        <c:if test="${empty ev.note and ev.statutSoutenance != 'ANNULEE' and compteur < 5}">
                            <c:set var="compteur" value="${compteur + 1}"/>
                            <li class="flex items-center gap-3 px-5 py-3.5">
                                <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-slate-100 text-[10px] font-semibold text-slate-600"><c:out value="${ev.initialesEtudiant}"/></div>
                                <div class="min-w-0 flex-1">
                                    <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${ev.prenomEtudiant}"/> <c:out value="${ev.nomEtudiant}"/></p>
                                    <p class="truncate text-[11px] text-slate-400"><c:out value="${ev.qualiteLibelle}"/> · <c:out value="${ev.dateSoutenance}"/></p>
                                </div>
                                <a href="${ctx}/enseignant/evaluations#eval-${ev.idEvaluation}" class="shrink-0 rounded-lg bg-accent-50 px-2.5 py-1.5 text-[11px] font-semibold text-accent-700 transition hover:bg-accent-100">Noter</a>
                            </li>
                        </c:if>
                    </c:forEach>
                </ul>
                <c:if test="${compteur == 0}">
                    <div class="px-5 py-8 text-center">
                        <p class="text-sm text-slate-500">Toutes vos notes sont saisies ✓</p>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Prochaines -->
    <div class="rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
        <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4">
            <div>
                <h2 class="text-sm font-semibold text-slate-900">Prochaines soutenances</h2>
                <p class="text-xs text-slate-400">Où vous êtes attendu</p>
            </div>
            <a href="${ctx}/enseignant/soutenances" class="text-xs font-medium text-accent-700 hover:text-accent-800">Tout voir</a>
        </div>
        <c:choose>
            <c:when test="${empty avenir}">
                <div class="px-5 py-10 text-center">
                    <p class="text-sm text-slate-500">Aucune soutenance à venir.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="divide-y divide-slate-100">
                    <c:forEach var="s" items="${avenir}" end="4">
                        <li class="flex items-center gap-3 px-5 py-3.5">
                            <div class="flex h-10 w-10 shrink-0 flex-col items-center justify-center rounded-xl bg-accent-50 text-accent-800">
                                <span class="text-[9px] font-semibold uppercase leading-none text-accent-600"><c:out value="${s.moisCourt}"/></span>
                                <span class="mt-0.5 text-[13px] font-bold leading-none"><c:out value="${s.jourNumero}"/></span>
                                <span class="mt-0.5 text-[9px] leading-none text-accent-600"><c:out value="${s.heure}"/></span>
                            </div>
                            <div class="min-w-0 flex-1">
                                <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${s.prenomEtudiant}"/> <c:out value="${s.nomEtudiant}"/></p>
                                <p class="truncate text-[11px] text-slate-400">Salle <c:out value="${s.salle}"/> · <c:out value="${s.filiereLibelle}"/></p>
                            </div>
                            <span class="shrink-0 rounded-lg bg-slate-100 px-2 py-1 text-[10px] font-medium text-slate-500"><c:out value="${s.nbNotes}"/>/<c:out value="${s.nbJury}"/></span>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </div>
</div>
