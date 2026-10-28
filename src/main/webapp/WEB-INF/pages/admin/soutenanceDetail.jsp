<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Fil d'Ariane -->
<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${ctx}${modeResultat ? '/admin/resultats' : '/admin/soutenances'}" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        ${modeResultat ? 'Retour aux résultats' : 'Retour aux soutenances'}
    </a>
    <div class="flex flex-wrap items-center gap-2">
        <a href="${ctx}/admin/soutenances/convocation?id=${soutenance.idSoutenance}" target="_blank"
           class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:border-accent-300 hover:text-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0 1 10.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0 .229 2.523a1.125 1.125 0 0 1-1.12 1.227H7.231c-.662 0-1.18-.568-1.12-1.227L6.34 18m11.318 0h1.091A2.25 2.25 0 0 0 21 15.75V9.456c0-1.081-.768-2.015-1.837-2.175a48.055 48.055 0 0 0-1.913-.247M6.34 18H5.25A2.25 2.25 0 0 1 3 15.75V9.456c0-1.081.768-2.015 1.837-2.175a48.041 48.041 0 0 1 1.913-.247m10.5 0a48.536 48.536 0 0 0-10.5 0m10.5 0V3.375c0-.621-.504-1.125-1.125-1.125h-8.25c-.621 0-1.125.504-1.125 1.125v3.659M18 10.5h.008v.008H18V10.5Zm-3 0h.008v.008H15V10.5Z"/></svg>
            Convocation
        </a>
        <c:if test="${soutenance.statut != 'EVALUEE'}">
            <a href="${ctx}/admin/soutenances/modifier?id=${soutenance.idSoutenance}"
               class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125"/></svg>
                Modifier
            </a>
        </c:if>
        <c:choose>
            <c:when test="${soutenance.statut == 'PLANIFIEE'}">
                <form method="post" action="${ctx}/admin/soutenances" onsubmit="return confirm('Annuler cette soutenance ?');" class="inline">
                    <input type="hidden" name="action" value="statut">
                    <input type="hidden" name="statut" value="ANNULEE">
                    <input type="hidden" name="id" value="${soutenance.idSoutenance}">
                    <input type="hidden" name="retour" value="detail">
                    <button type="submit" class="inline-flex items-center gap-2 rounded-xl border border-amber-200 bg-white px-3.5 py-2.5 text-xs font-medium text-amber-700 shadow-sm transition hover:bg-amber-50">
                        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 0 0 5.636 5.636m12.728 12.728A9 9 0 0 1 5.636 5.636m12.728 12.728L5.636 5.636"/></svg>
                        Annuler
                    </button>
                </form>
            </c:when>
            <c:when test="${soutenance.statut == 'ANNULEE'}">
                <form method="post" action="${ctx}/admin/soutenances" class="inline">
                    <input type="hidden" name="action" value="statut">
                    <input type="hidden" name="statut" value="PLANIFIEE">
                    <input type="hidden" name="id" value="${soutenance.idSoutenance}">
                    <input type="hidden" name="retour" value="detail">
                    <button type="submit" class="inline-flex items-center gap-2 rounded-xl border border-emerald-200 bg-white px-3.5 py-2.5 text-xs font-medium text-emerald-700 shadow-sm transition hover:bg-emerald-50">
                        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99"/></svg>
                        Réactiver
                    </button>
                </form>
            </c:when>
        </c:choose>
        <form method="post" action="${ctx}/admin/soutenances" onsubmit="return confirm('Supprimer définitivement cette soutenance et ses évaluations ?');" class="inline">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id" value="${soutenance.idSoutenance}">
            <button type="submit" class="inline-flex items-center gap-2 rounded-xl border border-rose-200 bg-white px-3.5 py-2.5 text-xs font-medium text-rose-600 shadow-sm transition hover:bg-rose-50">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"/></svg>
                Supprimer
            </button>
        </form>
    </div>
</div>

<!-- En-tête -->
<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <div class="h-24 bg-gradient-to-r ${soutenance.statut == 'EVALUEE' ? 'from-emerald-700 via-accent-800 to-accent-900' : (soutenance.statut == 'ANNULEE' ? 'from-slate-500 via-slate-600 to-slate-700' : 'from-accent-600 via-accent-700 to-accent-900')}"></div>
    <div class="px-6 pb-6">
        <div class="-mt-9 flex flex-col gap-5 sm:flex-row sm:items-end sm:justify-between">
            <div class="flex items-end gap-4">
                <div class="flex h-20 w-20 shrink-0 items-center justify-center rounded-2xl border-4 border-white bg-accent-100 text-2xl font-bold text-accent-800 shadow-sm"><c:out value="${soutenance.initiales}"/></div>
                <div class="pb-1">
                    <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Soutenance <c:out value="${soutenance.idSoutenance}"/></p>
                    <h2 class="mt-0.5 text-xl font-semibold tracking-tight text-slate-900"><c:out value="${soutenance.prenomEtudiant}"/> <c:out value="${soutenance.nomEtudiant}"/></h2>
                    <p class="mt-1 max-w-2xl text-[13px] leading-relaxed text-slate-500"><c:out value="${soutenance.sujet}"/></p>
                    <div class="mt-2 flex flex-wrap items-center gap-2 text-xs">
                        <span class="rounded-full bg-accent-50 px-2.5 py-1 font-medium text-accent-800"><c:out value="${soutenance.filiereLibelle}"/></span>
                        <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${soutenance.niveauLibelle}"/></span>
                        <c:if test="${not empty etudiant}">
                            <a href="${ctx}/admin/etudiants/detail?matricule=<c:out value='${etudiant.matricule}'/>" class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600 transition hover:bg-slate-200">Fiche étudiant</a>
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="flex items-center gap-3 pb-1">
                <c:choose>
                    <c:when test="${soutenance.statut == 'EVALUEE'}">
                        <div class="rounded-2xl bg-emerald-50 px-5 py-3 text-center">
                            <p class="text-2xl font-bold tracking-tight text-emerald-700"><c:out value="${soutenance.noteFinale}"/><span class="text-sm font-normal opacity-60"> / 20</span></p>
                            <p class="mt-0.5 text-[10px] font-semibold uppercase tracking-wide text-emerald-600">Note finale</p>
                        </div>
                    </c:when>
                    <c:when test="${soutenance.statut == 'ANNULEE'}">
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-slate-100 px-3 py-1.5 text-xs font-semibold text-slate-500"><span class="h-1.5 w-1.5 rounded-full bg-slate-400"></span>Annulée</span>
                    </c:when>
                    <c:otherwise>
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-amber-50 px-3 py-1.5 text-xs font-semibold text-amber-700"><span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>Planifiée</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<c:if test="${soutenance.statut == 'ANNULEE'}">
    <div class="mt-5 flex items-start gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-600">
        <svg class="mt-0.5 h-4 w-4 shrink-0 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z"/></svg>
        <span>Cette soutenance est annulée. Elle n'apparaît plus dans les passages à venir et aucune note ne peut être saisie.</span>
    </div>
</c:if>

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="space-y-5 lg:col-span-2">
        <!-- Informations -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Informations pratiques</h3>
            <dl class="mt-4 grid gap-x-6 gap-y-4 sm:grid-cols-2">
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Date et heure</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${soutenance.dateJour}"/> · <c:out value="${soutenance.heure}"/> – <c:out value="${soutenance.fin}"/></dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Salle</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${soutenance.salle}"/></dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Durée</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${soutenance.dureeMinutes}"/> minutes</dd>
                </div>
                <div>
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Encadrant</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800">
                        <c:choose>
                            <c:when test="${not empty encadrant}">
                                <a href="${ctx}/admin/enseignants/detail?matricule=<c:out value='${encadrant.matricule}'/>" class="text-accent-700 hover:text-accent-900"><c:out value="${encadrant.prenom}"/> <c:out value="${encadrant.nom}"/></a>
                            </c:when>
                            <c:otherwise><span class="text-slate-400">Non assigné</span></c:otherwise>
                        </c:choose>
                    </dd>
                </div>
            </dl>
        </div>

        <!-- Jury -->
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <div class="flex items-center justify-between">
                <div>
                    <h3 class="text-sm font-semibold text-slate-900">Jury et évaluations</h3>
                    <p class="mt-0.5 text-[11px] text-slate-400"><c:out value="${soutenance.nbNotes}"/> note(s) sur <c:out value="${soutenance.nbJury}"/> membre(s)</p>
                </div>
                <c:if test="${soutenance.statut == 'EVALUEE'}">
                    <span class="rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-medium text-emerald-700">Délibération close</span>
                </c:if>
            </div>

            <div class="mt-4 space-y-3">
                <c:forEach var="m" items="${jury}">
                    <div class="rounded-xl border border-slate-100 bg-slate-50/40 p-4">
                        <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                            <div class="flex min-w-0 items-center gap-3">
                                <span class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-white text-[11px] font-semibold text-slate-600 shadow-sm"><c:out value="${m.initiales}"/></span>
                                <div class="min-w-0">
                                    <p class="truncate text-[13px] font-semibold text-slate-800"><c:out value="${m.enseignantNom}"/></p>
                                    <p class="text-[11px] text-slate-400"><c:out value="${m.qualiteLibelle}"/> · <c:out value="${m.specialite}"/></p>
                                </div>
                            </div>
                            <div class="flex shrink-0 items-center gap-3">
                                <c:choose>
                                    <c:when test="${not empty m.note}">
                                        <span class="rounded-lg bg-white px-3 py-1.5 text-[13px] font-bold text-slate-800 shadow-sm"><c:out value="${m.note}"/><span class="text-[10px] font-normal text-slate-400"> /20</span></span>
                                    </c:when>
                                    <c:otherwise><span class="rounded-lg bg-amber-50 px-2.5 py-1 text-[10px] font-medium text-amber-700">En attente</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <c:if test="${not empty m.avis}">
                            <p class="mt-2.5 rounded-lg bg-white px-3 py-2 text-[11px] italic leading-relaxed text-slate-500">« <c:out value="${m.avis}"/> »</p>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Colonne latérale -->
    <div class="space-y-5">
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Synthèse</h3>
            <dl class="mt-4 space-y-3">
                <div class="flex items-center justify-between">
                    <dt class="text-[12px] text-slate-500">Membres du jury</dt>
                    <dd class="text-[13px] font-semibold text-slate-800"><c:out value="${soutenance.nbJury}"/></dd>
                </div>
                <div class="flex items-center justify-between">
                    <dt class="text-[12px] text-slate-500">Notes saisies</dt>
                    <dd class="text-[13px] font-semibold text-slate-800"><c:out value="${soutenance.nbNotes}"/> / <c:out value="${soutenance.nbJury}"/></dd>
                </div>
                <div class="flex items-center justify-between">
                    <dt class="text-[12px] text-slate-500">Statut</dt>
                    <dd class="text-[13px] font-semibold text-slate-800"><c:out value="${soutenance.statutLibelle}"/></dd>
                </div>
                <div class="flex items-center justify-between border-t border-slate-100 pt-3">
                    <dt class="text-[12px] text-slate-500">Note finale</dt>
                    <dd class="text-[15px] font-bold ${empty soutenance.noteFinale ? 'text-slate-300' : (soutenance.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600')}">
                        <c:choose>
                            <c:when test="${not empty soutenance.noteFinale}"><c:out value="${soutenance.noteFinale}"/><span class="text-[10px] font-normal text-slate-400"> /20</span></c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </dd>
                </div>
                <c:if test="${soutenance.statut == 'EVALUEE'}">
                    <div class="flex items-center justify-between">
                        <dt class="text-[12px] text-slate-500">Décision</dt>
                        <dd class="text-[13px] font-semibold ${soutenance.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}">${soutenance.noteFinale >= 10 ? 'Validée' : 'Non validée'}</dd>
                    </div>
                </c:if>
            </dl>
        </div>

        <c:if test="${soutenance.statut == 'EVALUEE'}">
            <div class="rounded-2xl border border-accent-100 bg-accent-50/60 p-5">
                <p class="text-xs font-semibold text-accent-900">Soutenance verrouillée</p>
                <p class="mt-1.5 text-[11px] leading-relaxed text-accent-700">Les notes ont été délibérées : le créneau, la salle et le jury ne peuvent plus être modifiés.</p>
            </div>
        </c:if>

        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Étudiant</h3>
            <c:choose>
                <c:when test="${not empty etudiant}">
                    <div class="mt-3 flex items-center gap-3">
                        <span class="flex h-10 w-10 items-center justify-center rounded-full bg-accent-50 text-[11px] font-semibold text-accent-700"><c:out value="${etudiant.initiales}"/></span>
                        <div class="min-w-0">
                            <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${etudiant.prenom}"/> <c:out value="${etudiant.nom}"/></p>
                            <p class="text-[11px] text-slate-400"><c:out value="${etudiant.matricule}"/> · <c:out value="${etudiant.filiereLibelle}"/></p>
                        </div>
                    </div>
                    <dl class="mt-3 space-y-2 border-t border-slate-100 pt-3 text-[11px]">
                        <div class="flex justify-between gap-3"><dt class="text-slate-400">Email</dt><dd class="truncate text-slate-600"><c:out value="${etudiant.email}"/></dd></div>
                        <div class="flex justify-between gap-3"><dt class="text-slate-400">Téléphone</dt><dd class="text-slate-600"><c:out value="${etudiant.telephone}"/></dd></div>
                    </dl>
                    <a href="${ctx}/admin/etudiants/detail?matricule=<c:out value='${etudiant.matricule}'/>" class="mt-3 inline-flex w-full items-center justify-center gap-1.5 rounded-xl border border-slate-200 px-3 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:text-accent-800">
                        Ouvrir la fiche
                        <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                    </a>
                </c:when>
                <c:otherwise><p class="mt-3 text-[12px] text-slate-400">Fiche étudiante introuvable.</p></c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
