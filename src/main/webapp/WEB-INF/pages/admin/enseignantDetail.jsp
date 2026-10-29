<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Fil d'Ariane -->
<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${ctx}/admin/enseignants" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        Retour aux enseignants
    </a>
    <div class="flex items-center gap-2">
        <a href="${ctx}/admin/enseignants/modifier?matricule=<c:out value='${enseignant.matricule}'/>"
           class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125"/></svg>
            Modifier la fiche
        </a>
        <form method="post" action="${ctx}/admin/enseignants" onsubmit="return confirm('Supprimer cet enseignant ? Cette action est refusée s\'il encadre des étudiants ou participe à un jury.');" class="inline">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="matricule" value="<c:out value='${enseignant.matricule}'/>">
            <button type="submit" class="inline-flex items-center gap-2 rounded-xl border border-rose-200 bg-white px-3.5 py-2.5 text-xs font-medium text-rose-600 shadow-sm transition hover:bg-rose-50">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"/></svg>
                Supprimer
            </button>
        </form>
    </div>
</div>

<!-- En-tête -->
<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <div class="h-24 bg-gradient-to-r from-slate-800 via-slate-900 to-accent-900"></div>
    <div class="px-6 pb-6">
        <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
            <div class="flex items-start gap-4">
                <div class="-mt-9 flex h-20 w-20 shrink-0 items-center justify-center rounded-2xl border-4 border-white bg-indigo-100 text-2xl font-bold text-indigo-700 shadow-sm"><c:out value="${enseignant.initiales}"/></div>
                <div class="pt-2">
                    <h2 class="text-xl font-semibold tracking-tight text-slate-900"><c:out value="${enseignant.prenom}"/> <c:out value="${enseignant.nom}"/></h2>
                    <div class="mt-1 flex flex-wrap items-center gap-2 text-xs">
                        <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${enseignant.matricule}"/></span>
                        <span class="rounded-full bg-indigo-50 px-2.5 py-1 font-medium text-indigo-700"><c:out value="${enseignant.specialiteLibelle}"/></span>
                        <c:if test="${not empty enseignant.grade}">
                            <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${enseignant.grade}"/></span>
                        </c:if>
                    </div>
                </div>
            </div>
            <p class="pt-2 text-xs text-slate-400">Compte enseignant</p>
        </div>
    </div>
</div>

<!-- Statistiques -->
<div class="mt-5 grid gap-4 sm:grid-cols-3">
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Étudiants encadrés</p>
        <p class="mt-1.5 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${enseignant.nbEncadres}"/></p>
        <p class="mt-1 text-[11px] text-slate-400">encadrements en cours</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Soutenances suivies</p>
        <p class="mt-1.5 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${soutenances.size()}"/></p>
        <p class="mt-1 text-[11px] text-slate-400">jury ou encadrement</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Notes saisies</p>
        <p class="mt-1.5 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${notesSaisies}"/></p>
        <p class="mt-1 text-[11px] text-slate-400">évaluations déposées</p>
    </div>
</div>

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="space-y-5 lg:col-span-2">
        <!-- Étudiants encadrés -->
        <div class="rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4">
                <div>
                    <h3 class="text-sm font-semibold text-slate-900">Étudiants encadrés</h3>
                    <p class="mt-0.5 text-[11px] text-slate-400">Mémoires suivis par cet enseignant</p>
                </div>
                <span class="rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-600"><c:out value="${encadres.size()}"/></span>
            </div>
            <c:choose>
                <c:when test="${empty encadres}">
                    <p class="px-5 py-8 text-center text-xs text-slate-400">Aucun étudiant encadré pour le moment.</p>
                </c:when>
                <c:otherwise>
                    <div class="divide-y divide-slate-100">
                        <c:forEach var="e" items="${encadres}">
                            <a href="${ctx}/admin/etudiants/detail?matricule=<c:out value='${e.matricule}'/>" class="flex items-center justify-between gap-3 px-5 py-3.5 transition hover:bg-slate-50/70">
                                <div class="flex min-w-0 items-center gap-3">
                                    <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-accent-50 text-[10px] font-semibold text-accent-700"><c:out value="${e.initiales}"/></span>
                                    <div class="min-w-0">
                                        <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${e.prenom}"/> <c:out value="${e.nom}"/></p>
                                        <p class="truncate text-[11px] text-slate-400"><c:out value="${e.filiereLibelle}"/> · <c:out value="${e.niveauLibelle}"/></p>
                                    </div>
                                </div>
                                <span class="shrink-0 text-[11px] text-slate-400"><c:out value="${e.matricule}"/></span>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Soutenances -->
        <div class="rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4">
                <div>
                    <h3 class="text-sm font-semibold text-slate-900">Soutenances & jurys</h3>
                    <p class="mt-0.5 text-[11px] text-slate-400">Passages où l'enseignant est mobilisé</p>
                </div>
                <span class="rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-600"><c:out value="${soutenances.size()}"/></span>
            </div>
            <c:choose>
                <c:when test="${empty soutenances}">
                    <p class="px-5 py-8 text-center text-xs text-slate-400">Aucune soutenance associée.</p>
                </c:when>
                <c:otherwise>
                    <div class="divide-y divide-slate-100">
                        <c:forEach var="s" items="${soutenances}">
                            <a href="${ctx}/admin/soutenances/detail?id=${s.idSoutenance}" class="flex items-center justify-between gap-4 px-5 py-3.5 transition hover:bg-slate-50/70">
                                <div class="flex min-w-0 items-center gap-3">
                                    <div class="flex h-10 w-10 shrink-0 flex-col items-center justify-center rounded-xl bg-accent-50 text-accent-800">
                                        <span class="text-[9px] font-semibold uppercase leading-none text-accent-600"><c:out value="${s.moisCourt}"/></span>
                                        <span class="mt-0.5 text-[13px] font-bold leading-none"><c:out value="${s.jourNumero}"/></span>
                                    </div>
                                    <div class="min-w-0">
                                        <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${s.prenomEtudiant}"/> <c:out value="${s.nomEtudiant}"/></p>
                                        <p class="truncate text-[11px] text-slate-400"><c:out value="${s.heure}"/> · <c:out value="${s.salle}"/> · <c:out value="${s.filiereLibelle}"/></p>
                                    </div>
                                </div>
                                <div class="flex shrink-0 flex-wrap items-center justify-end gap-1.5">
                                    <c:if test="${s.matriculeEncadrant == enseignant.matricule}">
                                        <span class="rounded-full bg-sky-50 px-2 py-0.5 text-[10px] font-medium text-sky-700">Encadrant</span>
                                    </c:if>
                                    <c:forEach var="m" items="${jurys[s.idSoutenance]}">
                                        <c:if test="${m.matriculeEnseignant == enseignant.matricule}">
                                            <span class="rounded-full bg-slate-100 px-2 py-0.5 text-[10px] font-medium text-slate-600"><c:out value="${m.qualiteLibelle}"/></span>
                                        </c:if>
                                    </c:forEach>
                                    <span class="rounded-full px-2 py-0.5 text-[10px] font-medium ${s.statut == 'EVALUEE' ? 'bg-emerald-50 text-emerald-700' : (s.statut == 'ANNULEE' ? 'bg-slate-100 text-slate-500' : 'bg-amber-50 text-amber-700')}"><c:out value="${s.statutLibelle}"/></span>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Colonne latérale -->
    <div class="space-y-5">
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Coordonnées</h3>
            <dl class="mt-4 space-y-3.5">
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Email</dt>
                    <dd class="mt-0.5 break-all text-[13px] text-slate-700">
                        <c:choose>
                            <c:when test="${not empty enseignant.email}"><a href="mailto:<c:out value='${enseignant.email}'/>" class="hover:text-accent-700"><c:out value="${enseignant.email}"/></a></c:when>
                            <c:otherwise><span class="text-slate-400">—</span></c:otherwise>
                        </c:choose>
                    </dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Téléphone</dt>
                    <dd class="mt-0.5 text-[13px] text-slate-700"><c:out value="${empty enseignant.telephone ? '—' : enseignant.telephone}"/></dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Adresse</dt>
                    <dd class="mt-0.5 text-[13px] text-slate-700"><c:out value="${empty enseignant.adresse ? '—' : enseignant.adresse}"/></dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Identifiant de connexion</dt>
                    <dd class="mt-0.5 font-mono text-[12px] text-slate-600"><c:out value="${enseignant.login}"/></dd>
                </div>
            </dl>
        </div>

        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Dernières évaluations</h3>
            <c:choose>
                <c:when test="${empty evaluations}">
                    <p class="mt-3 text-[12px] leading-relaxed text-slate-400">Aucune évaluation déposée.</p>
                </c:when>
                <c:otherwise>
                    <ul class="mt-3 space-y-2.5">
                        <c:forEach var="ev" items="${evaluations}" end="4">
                            <li class="flex items-start justify-between gap-2 border-b border-slate-100 pb-2.5 last:border-0 last:pb-0">
                                <div class="min-w-0">
                                    <p class="truncate text-[12px] font-medium text-slate-700"><c:out value="${ev.prenomEtudiant}"/> <c:out value="${ev.nomEtudiant}"/></p>
                                    <p class="text-[10px] text-slate-400"><c:out value="${ev.qualiteLibelle}"/></p>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty ev.note}">
                                        <span class="shrink-0 text-[12px] font-semibold text-slate-700"><c:out value="${ev.note}"/><span class="text-[10px] font-normal text-slate-400">/20</span></span>
                                    </c:when>
                                    <c:otherwise><span class="shrink-0 text-[10px] text-amber-600">En attente</span></c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
