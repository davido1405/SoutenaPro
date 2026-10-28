<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="grid gap-4 sm:grid-cols-3">
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Soutenances évaluées</p>
        <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${liste.size()}"/></p>
        <p class="mt-1 text-xs text-slate-400">délibérations closes</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Moyenne des notes finales</p>
        <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900">
            <c:choose>
                <c:when test="${not empty moyenneGenerale}"><c:out value="${moyenneGenerale}"/><span class="text-base font-normal text-slate-400"> / 20</span></c:when>
                <c:otherwise>—</c:otherwise>
            </c:choose>
        </p>
        <p class="mt-1 text-xs text-slate-400">moyenne des moyennes de jury</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Moyenne des notes de jury</p>
        <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900">
            <c:choose>
                <c:when test="${not empty moyenneJury}"><c:out value="${moyenneJury}"/><span class="text-base font-normal text-slate-400"> / 20</span></c:when>
                <c:otherwise>—</c:otherwise>
            </c:choose>
        </p>
        <p class="mt-1 text-xs text-slate-400">toutes notes confondues</p>
    </div>
</div>

<div class="mt-5 flex items-center justify-between">
    <p class="text-xs text-slate-400">Détail des notes par membre du jury</p>
    <a href="${ctx}/admin/export?type=soutenances" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:border-accent-300 hover:text-accent-800">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
        Exporter
    </a>
</div>

<div class="mt-4 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <c:choose>
        <c:when test="${empty liste}">
            <div class="flex flex-col items-center justify-center px-6 py-16 text-center">
                <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
                </div>
                <p class="mt-3 text-sm font-medium text-slate-600">Aucun résultat disponible</p>
                <p class="mt-1 text-xs text-slate-400">Les soutenances apparaîtront ici dès que tous les membres du jury auront saisi leur note.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="divide-y divide-slate-100">
                <c:forEach var="s" items="${liste}">
                    <div class="px-5 py-5 transition hover:bg-slate-50/40">
                        <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                            <div class="flex items-start gap-3">
                                <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-accent-50 text-xs font-semibold text-accent-700"><c:out value="${s.initiales}"/></div>
                                <div>
                                    <p class="text-sm font-semibold text-slate-800"><c:out value="${s.prenomEtudiant}"/> <c:out value="${s.nomEtudiant}"/></p>
                                    <p class="mt-0.5 max-w-xl text-xs text-slate-500"><c:out value="${s.sujet}"/></p>
                                    <p class="mt-1 text-[11px] text-slate-400"><c:out value="${s.filiereLibelle}"/> · <c:out value="${s.niveauLibelle}"/> · <c:out value="${s.dateJour}"/> à <c:out value="${s.heure}"/> · Salle <c:out value="${s.salle}"/></p>
                                </div>
                            </div>
                            <div class="flex items-center gap-4 sm:flex-col sm:items-end sm:gap-1">
                                <div class="rounded-xl ${s.noteFinale >= 10 ? 'bg-emerald-50 text-emerald-700' : 'bg-rose-50 text-rose-700'} px-3 py-1.5 text-center">
                                    <p class="text-lg font-bold leading-none"><c:out value="${s.noteFinale}"/></p>
                                    <p class="mt-0.5 text-[10px] font-medium uppercase tracking-wide opacity-70">/ 20</p>
                                </div>
                                <span class="text-[11px] font-medium ${s.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}">
                                    ${s.noteFinale >= 10 ? 'Admis(e)' : 'Ajourné(e)'}
                                </span>
                                <a href="${ctx}/admin/resultats/detail?id=${s.idSoutenance}" class="inline-flex items-center gap-1 text-[11px] font-medium text-accent-700 transition hover:text-accent-900">
                                    Voir le détail
                                    <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                                </a>
                            </div>
                        </div>

                        <div class="mt-4 grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
                            <c:forEach var="m" items="${jurys[s.idSoutenance]}">
                                <div class="flex items-center justify-between rounded-xl border border-slate-100 bg-white px-3 py-2">
                                    <div class="flex min-w-0 items-center gap-2">
                                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-slate-100 text-[9px] font-semibold text-slate-500"><c:out value="${m.initiales}"/></span>
                                        <div class="min-w-0">
                                            <p class="truncate text-[11px] font-medium text-slate-700"><c:out value="${m.enseignantNom}"/></p>
                                            <p class="text-[10px] text-slate-400"><c:out value="${m.qualiteLibelle}"/></p>
                                        </div>
                                    </div>
                                    <span class="ml-2 shrink-0 text-[12px] font-semibold text-slate-700">
                                        <c:choose>
                                            <c:when test="${not empty m.note}"><c:out value="${m.note}"/><span class="text-[10px] font-normal text-slate-400">/20</span></c:when>
                                            <c:otherwise><span class="text-[10px] font-normal text-slate-300">En attente</span></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
