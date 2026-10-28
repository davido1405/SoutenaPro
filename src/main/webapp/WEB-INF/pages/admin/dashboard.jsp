<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- Cartes principales -->
<div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-start justify-between">
            <div>
                <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Étudiants</p>
                <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${nbEtudiants}"/></p>
                <p class="mt-1 text-xs text-slate-400">inscrits cette année</p>
            </div>
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-accent-50 text-accent-700">
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Z"/></svg>
            </div>
        </div>
    </div>

    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-start justify-between">
            <div>
                <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Enseignants</p>
                <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${nbEnseignants}"/></p>
                <p class="mt-1 text-xs text-slate-400">membres du corps enseignant</p>
            </div>
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-indigo-50 text-indigo-600">
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342"/></svg>
            </div>
        </div>
    </div>

    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-start justify-between">
            <div>
                <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Planifiées</p>
                <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${nbPlanifiees}"/></p>
                <p class="mt-1 text-xs text-slate-400"><c:out value="${prochainsJours}"/> dans les 7 prochains jours</p>
            </div>
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-amber-50 text-amber-600">
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
            </div>
        </div>
    </div>

    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <div class="flex items-start justify-between">
            <div>
                <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Moyenne générale</p>
                <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900">
                    <c:choose>
                        <c:when test="${not empty moyenneGenerale}"><c:out value="${moyenneGenerale}"/><span class="text-base font-normal text-slate-400"> / 20</span></c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </p>
                <p class="mt-1 text-xs text-slate-400"><c:out value="${nbEvaluees}"/> soutenance(s) évaluée(s)</p>
            </div>
            <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600">
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z"/></svg>
            </div>
        </div>
    </div>
</div>

<div class="mt-5 grid gap-5 xl:grid-cols-3">

    <!-- Prochaines soutenances -->
    <div class="xl:col-span-2 rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
        <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4">
            <div>
                <h2 class="text-sm font-semibold text-slate-900">Prochaines soutenances</h2>
                <p class="text-xs text-slate-400">Les passages à venir, classés par date</p>
            </div>
            <a href="${ctx}/admin/soutenances" class="inline-flex items-center gap-1.5 rounded-lg px-2.5 py-1.5 text-xs font-medium text-accent-700 transition hover:bg-accent-50">
                Tout voir
                <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
            </a>
        </div>

        <c:choose>
            <c:when test="${empty prochaines}">
                <div class="flex flex-col items-center justify-center px-6 py-14 text-center">
                    <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                        <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                    </div>
                    <p class="mt-3 text-sm font-medium text-slate-600">Aucune soutenance à venir</p>
                    <p class="mt-1 text-xs text-slate-400">Planifiez un passage depuis la page Soutenances.</p>
                    <a href="${ctx}/admin/soutenances" class="mt-4 rounded-xl bg-accent-700 px-4 py-2 text-xs font-semibold text-white transition hover:bg-accent-800">Planifier une soutenance</a>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="divide-y divide-slate-100">
                    <c:forEach var="s" items="${prochaines}">
                        <li class="flex items-center gap-4 px-5 py-4">
                            <div class="flex h-11 w-11 shrink-0 flex-col items-center justify-center rounded-xl bg-accent-50 text-accent-800">
                                <span class="text-[13px] font-bold leading-none"><c:out value="${s.jourNumero}"/></span>
                                <span class="mt-0.5 text-[9px] font-semibold uppercase leading-none text-accent-600"><c:out value="${s.moisCourt}"/></span>
                            </div>
                            <div class="min-w-0 flex-1">
                                <div class="flex items-center gap-2">
                                    <p class="truncate text-sm font-medium text-slate-800"><c:out value="${s.prenomEtudiant}"/> <c:out value="${s.nomEtudiant}"/></p>
                                    <span class="rounded-md bg-slate-100 px-1.5 py-0.5 text-[10px] font-medium text-slate-500"><c:out value="${s.filiereLibelle}"/></span>
                                </div>
                                <p class="truncate text-xs text-slate-400"><c:out value="${s.sujet}"/></p>
                            </div>
                            <div class="hidden shrink-0 text-right sm:block">
                                <p class="text-xs font-medium text-slate-700"><c:out value="${s.heure}"/> – <c:out value="${s.fin}"/></p>
                                <p class="text-[11px] text-slate-400">Salle <c:out value="${s.salle}"/></p>
                            </div>
                            <div class="flex -space-x-2">
                                <c:forEach var="m" items="${jurys[s.idSoutenance]}" end="2">
                                    <span title="<c:out value='${m.enseignantNom}'/>" class="flex h-7 w-7 items-center justify-center rounded-full border-2 border-white bg-slate-100 text-[9px] font-semibold text-slate-600"><c:out value="${m.initiales}"/></span>
                                </c:forEach>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Colonne droite -->
    <div class="space-y-5">
        <!-- Statuts -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h2 class="text-sm font-semibold text-slate-900">Répartition des statuts</h2>
            <c:set var="totalStatuts" value="${nbSoutenances == 0 ? 1 : nbSoutenances}"/>
            <div class="mt-4 space-y-4">
                <c:choose>
                    <c:when test="${empty repartitionStatuts}">
                        <p class="text-xs text-slate-400">Aucune soutenance enregistrée.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="row" items="${repartitionStatuts}">
                            <c:set var="libelle" value="${row[0]}"/>
                            <div>
                                <div class="mb-1.5 flex items-center justify-between text-xs">
                                    <span class="font-medium text-slate-600">
                                        <c:choose>
                                            <c:when test="${libelle == 'PLANIFIEE'}">Planifiées</c:when>
                                            <c:when test="${libelle == 'EVALUEE'}">Évaluées</c:when>
                                            <c:when test="${libelle == 'ANNULEE'}">Annulées</c:when>
                                            <c:otherwise><c:out value="${libelle}"/></c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="font-semibold text-slate-800"><c:out value="${row[1]}"/></span>
                                </div>
                                <div class="h-2 overflow-hidden rounded-full bg-slate-100">
                                    <div class="h-full rounded-full ${libelle == 'PLANIFIEE' ? 'bg-amber-400' : libelle == 'EVALUEE' ? 'bg-emerald-500' : 'bg-slate-300'}"
                                         style="width: ${row[1] * 100 / totalStatuts}%"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="mt-5 grid grid-cols-2 gap-3 border-t border-slate-100 pt-4">
                <div class="rounded-xl bg-slate-50 px-3 py-2.5">
                    <p class="text-[10px] uppercase tracking-wide text-slate-400">Cette semaine</p>
                    <p class="mt-0.5 text-lg font-semibold text-slate-800"><c:out value="${cetteSemaine}"/></p>
                </div>
                <div class="rounded-xl bg-slate-50 px-3 py-2.5">
                    <p class="text-[10px] uppercase tracking-wide text-slate-400">Annulées</p>
                    <p class="mt-0.5 text-lg font-semibold text-slate-800"><c:out value="${nbAnnulees}"/></p>
                </div>
            </div>
        </div>

        <!-- Étudiants par filière -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h2 class="text-sm font-semibold text-slate-900">Étudiants par filière</h2>
            <div class="mt-4 space-y-3">
                <c:choose>
                    <c:when test="${empty repartitionFilieres}">
                        <p class="text-xs text-slate-400">Aucune donnée disponible.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="row" items="${repartitionFilieres}">
                            <div class="flex items-center justify-between text-xs">
                                <span class="truncate text-slate-600"><c:out value="${row[0]}"/></span>
                                <span class="ml-3 rounded-md bg-slate-100 px-2 py-0.5 font-semibold text-slate-700"><c:out value="${row[1]}"/></span>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            <a href="${ctx}/admin/etudiants" class="mt-4 inline-flex w-full items-center justify-center gap-1.5 rounded-xl border border-slate-200 px-3 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:bg-accent-50/40 hover:text-accent-800">
                Gérer les étudiants
            </a>
        </div>

        <!-- Export -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h2 class="text-sm font-semibold text-slate-900">Exports</h2>
            <p class="mt-1 text-xs text-slate-400">Téléchargez les données au format CSV (Excel).</p>
            <div class="mt-3 grid gap-2">
                <a href="${ctx}/admin/export?type=soutenances" class="flex items-center gap-2 rounded-xl border border-slate-200 px-3 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:bg-accent-50/40">
                    <svg class="h-4 w-4 text-accent-600" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
                    Planning des soutenances
                </a>
                <a href="${ctx}/admin/export?type=etudiants" class="flex items-center gap-2 rounded-xl border border-slate-200 px-3 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:bg-accent-50/40">
                    <svg class="h-4 w-4 text-accent-600" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
                    Liste des étudiants
                </a>
                <a href="${ctx}/admin/export?type=enseignants" class="flex items-center gap-2 rounded-xl border border-slate-200 px-3 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:bg-accent-50/40">
                    <svg class="h-4 w-4 text-accent-600" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
                    Liste des enseignants
                </a>
            </div>
        </div>
    </div>
</div>
