<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${ctx}/enseignant/soutenances" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        Retour à mes soutenances
    </a>
    <c:if test="${not empty maNote}">
        <a href="${ctx}/enseignant/evaluations" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:border-accent-300 hover:text-accent-800">
            Toutes mes évaluations
            <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
        </a>
    </c:if>
</div>

<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <div class="h-24 bg-gradient-to-r ${soutenance.statut == 'EVALUEE' ? 'from-emerald-700 via-accent-800 to-accent-900' : (soutenance.statut == 'ANNULEE' ? 'from-slate-500 via-slate-600 to-slate-700' : 'from-accent-600 via-accent-700 to-accent-900')}"></div>
    <div class="px-6 pb-6">
        <div class="-mt-9 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
            <div class="flex items-end gap-4">
                <div class="flex h-20 w-20 shrink-0 items-center justify-center rounded-2xl border-4 border-white bg-accent-100 text-2xl font-bold text-accent-800 shadow-sm"><c:out value="${soutenance.initiales}"/></div>
                <div class="pb-1">
                    <h2 class="text-xl font-semibold tracking-tight text-slate-900"><c:out value="${soutenance.prenomEtudiant}"/> <c:out value="${soutenance.nomEtudiant}"/></h2>
                    <p class="mt-1 max-w-2xl text-[13px] leading-relaxed text-slate-500"><c:out value="${soutenance.sujet}"/></p>
                    <div class="mt-2 flex flex-wrap items-center gap-2 text-xs">
                        <span class="rounded-full bg-accent-50 px-2.5 py-1 font-medium text-accent-800"><c:out value="${soutenance.filiereLibelle}"/></span>
                        <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${soutenance.niveauLibelle}"/></span>
                        <c:if test="${estEncadrant}">
                            <span class="rounded-full bg-sky-50 px-2.5 py-1 font-medium text-sky-700">Vous encadrez ce mémoire</span>
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

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="space-y-5 lg:col-span-2">
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
                    <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Votre rôle</dt>
                    <dd class="mt-1 text-sm font-medium text-slate-800">
                        <c:choose>
                            <c:when test="${not empty maNote}"><c:out value="${maNote.qualiteLibelle}"/></c:when>
                            <c:when test="${estEncadrant}">Encadrant</c:when>
                            <c:otherwise>Observateur</c:otherwise>
                        </c:choose>
                    </dd>
                </div>
            </dl>
        </div>

        <c:if test="${not empty maNote}">
            <div class="rounded-2xl border ${empty maNote.note and soutenance.statut != 'ANNULEE' ? 'border-amber-200/70' : 'border-slate-200/70'} bg-white p-5 shadow-sm shadow-slate-200/40">
                <div class="flex items-center justify-between">
                    <div>
                        <h3 class="text-sm font-semibold text-slate-900">Votre évaluation</h3>
                        <p class="mt-0.5 text-[11px] text-slate-400">Note et appréciation transmises au jury</p>
                    </div>
                    <c:choose>
                        <c:when test="${soutenance.statut == 'ANNULEE'}">
                            <span class="rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-500">Annulée</span>
                        </c:when>
                        <c:when test="${empty maNote.note}">
                            <span class="rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-medium text-amber-700">À évaluer</span>
                        </c:when>
                        <c:otherwise>
                            <span class="rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-medium text-emerald-700">Enregistrée</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <form method="post" action="${ctx}/enseignant/evaluations" class="mt-4">
                    <input type="hidden" name="idEvaluation" value="${maNote.idEvaluation}">
                    <input type="hidden" name="retour" value="detail">
                    <input type="hidden" name="idSoutenance" value="${soutenance.idSoutenance}">
                    <div class="grid gap-4 sm:grid-cols-3">
                        <div>
                            <label class="mb-1.5 block text-xs font-medium text-slate-600">Note / 20 *</label>
                            <input type="number" name="note" required min="0" max="20" step="0.25" value="${maNote.note}" ${soutenance.statut == 'ANNULEE' ? 'disabled' : ''}
                                   class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10 disabled:bg-slate-50 disabled:text-slate-400">
                        </div>
                        <div class="sm:col-span-2">
                            <label class="mb-1.5 block text-xs font-medium text-slate-600">Avis (optionnel)</label>
                            <input name="avis" maxlength="255" value="<c:out value='${maNote.avis}'/>" placeholder="Commentaire sur la prestation" ${soutenance.statut == 'ANNULEE' ? 'disabled' : ''}
                                   class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10 disabled:bg-slate-50">
                        </div>
                    </div>
                    <c:if test="${soutenance.statut != 'ANNULEE'}">
                        <div class="mt-3 flex justify-end">
                            <button type="submit" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm transition hover:bg-accent-800">
                                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                                ${empty maNote.note ? 'Enregistrer la note' : 'Mettre à jour'}
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${soutenance.statut == 'ANNULEE'}">
                        <p class="mt-3 rounded-lg bg-slate-50 px-3 py-2 text-[11px] text-slate-500">La soutenance est annulée : la saisie est désactivée.</p>
                    </c:if>
                </form>
            </div>
        </c:if>

        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Jury</h3>
            <div class="mt-4 space-y-2.5">
                <c:forEach var="m" items="${jury}">
                    <div class="flex items-center justify-between gap-3 rounded-xl border border-slate-100 bg-slate-50/40 px-4 py-3">
                        <div class="flex min-w-0 items-center gap-3">
                            <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-white text-[10px] font-semibold text-slate-600 shadow-sm"><c:out value="${m.initiales}"/></span>
                            <div class="min-w-0">
                                <p class="truncate text-[13px] font-medium text-slate-800">
                                    <c:out value="${m.enseignantNom}"/>
                                    <c:if test="${m.matriculeEnseignant == sessionScope.ConnectedUser.matricule}"><span class="ml-1 text-[10px] font-normal text-accent-600">(vous)</span></c:if>
                                </p>
                                <p class="text-[11px] text-slate-400"><c:out value="${m.qualiteLibelle}"/> · <c:out value="${m.specialite}"/></p>
                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${soutenance.statut == 'EVALUEE'}">
                                <c:choose>
                                    <c:when test="${not empty m.note}">
                                        <span class="shrink-0 text-[13px] font-semibold text-slate-700"><c:out value="${m.note}"/><span class="text-[10px] font-normal text-slate-400">/20</span></span>
                                    </c:when>
                                    <c:otherwise><span class="shrink-0 text-[10px] text-slate-300">—</span></c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <span class="shrink-0 rounded-full px-2 py-0.5 text-[10px] font-medium ${empty m.note ? 'bg-slate-100 text-slate-500' : 'bg-emerald-50 text-emerald-700'}">${empty m.note ? 'En attente' : 'Noté'}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="space-y-5">
        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm sm:shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Étudiant</h3>
            <div class="mt-3 flex items-center gap-3">
                <span class="flex h-10 w-10 items-center justify-center rounded-full bg-accent-50 text-[11px] font-semibold text-accent-700"><c:out value="${soutenance.initiales}"/></span>
                <div class="min-w-0">
                    <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${soutenance.prenomEtudiant}"/> <c:out value="${soutenance.nomEtudiant}"/></p>
                    <p class="text-[11px] text-slate-400"><c:out value="${soutenance.matriculeEtudiant}"/> · <c:out value="${soutenance.niveauLibelle}"/></p>
                </div>
            </div>
            <p class="mt-3 rounded-xl bg-slate-50 px-3 py-2.5 text-[11px] leading-relaxed text-slate-500"><c:out value="${soutenance.sujet}"/></p>
        </div>

        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
            <h3 class="text-sm font-semibold text-slate-900">Avancement</h3>
            <dl class="mt-3 space-y-2.5">
                <div class="flex items-center justify-between">
                    <dt class="text-[12px] text-slate-500">Notes saisies</dt>
                    <dd class="text-[13px] font-semibold text-slate-800"><c:out value="${soutenance.nbNotes}"/> / <c:out value="${soutenance.nbJury}"/></dd>
                </div>
                <div class="flex items-center justify-between">
                    <dt class="text-[12px] text-slate-500">Statut</dt>
                    <dd class="text-[13px] font-semibold text-slate-800"><c:out value="${soutenance.statutLibelle}"/></dd>
                </div>
                <c:if test="${soutenance.statut == 'EVALUEE'}">
                    <div class="flex items-center justify-between border-t border-slate-100 pt-2.5">
                        <dt class="text-[12px] text-slate-500">Note finale</dt>
                        <dd class="text-[15px] font-bold ${soutenance.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}"><c:out value="${soutenance.noteFinale}"/><span class="text-[10px] font-normal text-slate-400"> /20</span></dd>
                    </div>
                </c:if>
            </dl>
        </div>

        <div class="rounded-2xl border border-accent-100 bg-accent-50/60 p-5">
            <p class="text-xs font-semibold text-accent-900">Rappel</p>
            <p class="mt-1.5 text-[11px] leading-relaxed text-accent-700">Les notes sont confidentielles jusqu'à la délibération. La note finale est la moyenne des notes du jury.</p>
        </div>
    </div>
</div>
