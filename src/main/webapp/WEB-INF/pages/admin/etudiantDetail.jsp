<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Fil d'Ariane -->
<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${ctx}/admin/etudiants" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        Retour aux étudiants
    </a>
    <div class="flex items-center gap-2">
        <a href="${ctx}/admin/etudiants/modifier?matricule=<c:out value='${etudiant.matricule}'/>"
           class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125"/></svg>
            Modifier la fiche
        </a>
        <form method="post" action="${ctx}/admin/etudiants" onsubmit="return confirm('Supprimer cet étudiant ? Sa soutenance et ses évaluations seront également supprimées.');" class="inline">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="matricule" value="<c:out value='${etudiant.matricule}'/>">
            <button type="submit" class="inline-flex items-center gap-2 rounded-xl border border-rose-200 bg-white px-3.5 py-2.5 text-xs font-medium text-rose-600 shadow-sm transition hover:bg-rose-50">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"/></svg>
                Supprimer
            </button>
        </form>
    </div>
</div>

<!-- En-tête -->
<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <div class="h-24 bg-gradient-to-r from-accent-700 via-accent-800 to-accent-900"></div>
    <div class="px-6 pb-6">
        <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
            <div class="flex items-start gap-4">
                <div class="-mt-9 flex h-20 w-20 shrink-0 items-center justify-center rounded-2xl border-4 border-white bg-accent-100 text-2xl font-bold text-accent-800 shadow-sm"><c:out value="${etudiant.initiales}"/></div>
                <div class="pt-2">
                    <h2 class="text-xl font-semibold tracking-tight text-slate-900"><c:out value="${etudiant.prenom}"/> <c:out value="${etudiant.nom}"/></h2>
                    <div class="mt-1 flex flex-wrap items-center gap-2 text-xs text-slate-500">
                        <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${etudiant.matricule}"/></span>
                        <span class="rounded-full bg-accent-50 px-2.5 py-1 font-medium text-accent-800"><c:out value="${etudiant.filiereLibelle}"/></span>
                        <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${etudiant.niveauLibelle}"/></span>
                    </div>
                </div>
            </div>
            <div class="pt-2">
                <c:choose>
                    <c:when test="${etudiant.statutSoutenance == 'EVALUEE'}">
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1.5 text-xs font-semibold text-emerald-700"><span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>Soutenance évaluée</span>
                    </c:when>
                    <c:when test="${etudiant.statutSoutenance == 'ANNULEE'}">
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-500"><span class="h-1.5 w-1.5 rounded-full bg-slate-400"></span>Soutenance annulée</span>
                    </c:when>
                    <c:when test="${etudiant.statutSoutenance == 'PLANIFIEE'}">
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-amber-50 px-3 py-1.5 text-xs font-semibold text-amber-700"><span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>Soutenance planifiée</span>
                    </c:when>
                    <c:otherwise>
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-slate-50 px-3 py-1.5 text-xs font-semibold text-slate-400"><span class="h-1.5 w-1.5 rounded-full bg-slate-300"></span>Non planifiée</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="space-y-5 lg:col-span-2">
        <!-- Parcours -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <div class="flex items-center justify-between">
                <h3 class="text-sm font-semibold text-slate-900">Parcours académique</h3>
                <span class="text-[11px] text-slate-400">Master</span>
            </div>
            <dl class="mt-4 grid gap-x-6 gap-y-4 sm:grid-cols-2">
                <div>
                    <dt class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Filière</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${etudiant.filiereLibelle}"/></dd>
                </div>
                <div>
                    <dt class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Niveau</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${etudiant.niveauLibelle}"/></dd>
                </div>
                <div class="sm:col-span-2">
                    <dt class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Enseignant encadrant</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800">
                        <c:choose>
                            <c:when test="${not empty etudiant.encadrantNom}">
                                <a href="${ctx}/admin/enseignants/detail?matricule=<c:out value='${etudiant.matriculeEncadrant}'/>" class="inline-flex items-center gap-1.5 text-accent-700 hover:text-accent-900">
                                    <c:out value="${etudiant.encadrantNom}"/>
                                    <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"/></svg>
                                </a>
                            </c:when>
                            <c:otherwise><span class="text-slate-400">Non assigné</span></c:otherwise>
                        </c:choose>
                    </dd>
                </div>
                <div class="sm:col-span-2">
                    <dt class="text-[11px] font-medium uppercase tracking-wide text-slate-400">Sujet du mémoire</dt>
                    <dd class="mt-1 text-sm leading-relaxed text-slate-700">
                        <c:choose>
                            <c:when test="${not empty etudiant.sujet}"><c:out value="${etudiant.sujet}"/></c:when>
                            <c:otherwise><span class="text-slate-400">Aucun sujet renseigné.</span></c:otherwise>
                        </c:choose>
                    </dd>
                </div>
            </dl>
        </div>

        <!-- Soutenance -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <div class="flex items-center justify-between">
                <h3 class="text-sm font-semibold text-slate-900">Soutenance</h3>
                <c:if test="${not empty soutenance}">
                    <a href="${ctx}/admin/soutenances/detail?id=${soutenance.idSoutenance}" class="inline-flex items-center gap-1 text-xs font-medium text-accent-700 hover:text-accent-900">
                        Voir le détail
                        <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                    </a>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${empty soutenance}">
                    <div class="mt-4 flex flex-col items-center justify-center rounded-xl border border-dashed border-slate-200 bg-slate-50/50 px-6 py-10 text-center">
                        <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white text-slate-300 shadow-sm">
                            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.6" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                        </div>
                        <p class="mt-3 text-sm font-medium text-slate-600">Aucune soutenance planifiée</p>
                        <p class="mt-1 text-xs text-slate-400">Planifiez un passage depuis le planning des soutenances.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="mt-4 grid gap-4 sm:grid-cols-3">
                        <div class="rounded-xl bg-slate-50/70 px-4 py-3">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Date</p>
                            <p class="mt-1 text-sm font-semibold text-slate-800"><c:out value="${soutenance.dateJour}"/></p>
                            <p class="text-[11px] text-slate-400"><c:out value="${soutenance.heure}"/> – <c:out value="${soutenance.fin}"/></p>
                        </div>
                        <div class="rounded-xl bg-slate-50/70 px-4 py-3">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Salle</p>
                            <p class="mt-1 text-sm font-semibold text-slate-800"><c:out value="${soutenance.salle}"/></p>
                            <p class="text-[11px] text-slate-400">Durée : <c:out value="${soutenance.dureeMinutes}"/> min</p>
                        </div>
                        <div class="rounded-xl bg-slate-50/70 px-4 py-3">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Statut</p>
                            <p class="mt-1 text-sm font-semibold text-slate-800"><c:out value="${soutenance.statutLibelle}"/></p>
                            <p class="text-[11px] text-slate-400"><c:out value="${soutenance.nbNotes}"/>/<c:out value="${soutenance.nbJury}"/> notes saisies</p>
                        </div>
                    </div>

                    <c:if test="${not empty jury}">
                        <div class="mt-4 border-t border-slate-100 pt-4">
                            <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Jury</p>
                            <div class="mt-3 grid gap-2 sm:grid-cols-2">
                                <c:forEach var="m" items="${jury}">
                                    <div class="flex items-center justify-between rounded-xl border border-slate-100 px-3 py-2.5">
                                        <div class="flex min-w-0 items-center gap-2.5">
                                            <span class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-slate-100 text-[10px] font-semibold text-slate-600"><c:out value="${m.initiales}"/></span>
                                            <div class="min-w-0">
                                                <p class="truncate text-[12px] font-medium text-slate-700"><c:out value="${m.enseignantNom}"/></p>
                                                <p class="text-[10px] text-slate-400"><c:out value="${m.qualiteLibelle}"/></p>
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty m.note}">
                                                <span class="ml-2 shrink-0 text-[12px] font-semibold text-slate-700"><c:out value="${m.note}"/><span class="text-[10px] font-normal text-slate-400">/20</span></span>
                                            </c:when>
                                            <c:otherwise><span class="ml-2 shrink-0 text-[10px] text-slate-300">En attente</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
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
                            <c:when test="${not empty etudiant.email}"><a href="mailto:<c:out value='${etudiant.email}'/>" class="hover:text-accent-700"><c:out value="${etudiant.email}"/></a></c:when>
                            <c:otherwise><span class="text-slate-400">—</span></c:otherwise>
                        </c:choose>
                    </dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Téléphone</dt>
                    <dd class="mt-0.5 text-[13px] text-slate-700"><c:out value="${empty etudiant.telephone ? '—' : etudiant.telephone}"/></dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Adresse</dt>
                    <dd class="mt-0.5 text-[13px] text-slate-700"><c:out value="${empty etudiant.adresse ? '—' : etudiant.adresse}"/></dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Identifiant de connexion</dt>
                    <dd class="mt-0.5 font-mono text-[12px] text-slate-600"><c:out value="${etudiant.login}"/></dd>
                </div>
            </dl>
        </div>

        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Résultat</h3>
            <c:choose>
                <c:when test="${not empty soutenance and soutenance.statut == 'EVALUEE'}">
                    <div class="mt-3 rounded-xl ${soutenance.noteFinale >= 10 ? 'bg-emerald-50' : 'bg-rose-50'} px-4 py-4 text-center">
                        <p class="text-3xl font-bold tracking-tight ${soutenance.noteFinale >= 10 ? 'text-emerald-700' : 'text-rose-700'}"><c:out value="${soutenance.noteFinale}"/><span class="text-base font-normal opacity-60"> / 20</span></p>
                        <p class="mt-1 text-[11px] font-medium ${soutenance.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}">${soutenance.noteFinale >= 10 ? 'Admis(e)' : 'Ajourné(e)'}</p>
                    </div>
                    <a href="${ctx}/admin/resultats/detail?id=${soutenance.idSoutenance}" class="mt-3 inline-flex w-full items-center justify-center gap-1.5 rounded-xl border border-slate-200 px-3 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:text-accent-800">
                        Consulter la délibération
                        <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                    </a>
                </c:when>
                <c:when test="${not empty soutenance and soutenance.statut == 'ANNULEE'}">
                    <p class="mt-3 rounded-xl bg-slate-50 px-4 py-3 text-[12px] leading-relaxed text-slate-500">La soutenance a été annulée. Aucune note ne sera enregistrée.</p>
                </c:when>
                <c:when test="${not empty soutenance}">
                    <div class="mt-3 rounded-xl bg-amber-50 px-4 py-3">
                        <p class="text-[12px] font-medium text-amber-700">Délibération en cours</p>
                        <p class="mt-1 text-[11px] leading-relaxed text-amber-600"><c:out value="${soutenance.nbNotes}"/> note(s) sur <c:out value="${soutenance.nbJury}"/> saisie(s).</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="mt-3 text-[12px] leading-relaxed text-slate-400">Le résultat apparaîtra ici après la délibération du jury.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="rounded-2xl border border-accent-100 bg-accent-50/60 p-5">
            <p class="text-xs font-semibold text-accent-900">Actions rapides</p>
            <div class="mt-3 space-y-2">
                <a href="${ctx}/admin/soutenances/nouvelle" class="flex items-center justify-between rounded-xl bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:text-accent-800">
                    Planifier une soutenance
                    <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15"/></svg>
                </a>
                <a href="${ctx}/admin/export?type=etudiants" class="flex items-center justify-between rounded-xl bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:text-accent-800">
                    Exporter la liste
                    <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
                </a>
            </div>
        </div>
    </div>
</div>
