<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${empty editSoutenance}">
        <c:set var="retour" value="${ctx}/admin/soutenances"/>
    </c:when>
    <c:otherwise>
        <c:set var="retour" value="${ctx}/admin/soutenances/detail?id=${editSoutenance.idSoutenance}"/>
    </c:otherwise>
</c:choose>

<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${retour}" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        ${empty editSoutenance ? 'Retour aux soutenances' : 'Retour à la soutenance'}
    </a>
</div>

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="lg:col-span-2">
        <form method="post" action="${ctx}/admin/soutenances" class="overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-base font-semibold text-slate-900">${empty editSoutenance ? 'Planifier une soutenance' : 'Modifier la soutenance'}</h2>
                <p class="mt-0.5 text-xs text-slate-400">Le jury doit comporter un président et au moins un autre membre. Les conflits de salle et de jury sont détectés automatiquement.</p>
            </div>

            <div class="px-6 py-5">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="id" value="${editSoutenance.idSoutenance}">

                <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Étudiant et créneau</p>
                <div class="mt-3 grid gap-4 sm:grid-cols-2">
                    <div class="sm:col-span-2">
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Étudiant *</label>
                        <select name="matriculeEtudiant" required class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <option value="">— Sélectionner un étudiant —</option>
                            <c:if test="${not empty editSoutenance}">
                                <option value="<c:out value='${editSoutenance.matriculeEtudiant}'/>" selected>
                                    <c:out value="${editSoutenance.prenomEtudiant}"/> <c:out value="${editSoutenance.nomEtudiant}"/> — <c:out value="${editSoutenance.filiereLibelle}"/>
                                </option>
                            </c:if>
                            <c:forEach var="e" items="${etudiantsNonPlanifies}">
                                <c:if test="${empty editSoutenance or e[0] != editSoutenance.matriculeEtudiant}">
                                    <option value="<c:out value='${e[0]}'/>">
                                        <c:out value="${e[1]}"/> — <c:out value="${e[3]}"/>
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <c:if test="${empty editSoutenance and empty etudiantsNonPlanifies}">
                            <p class="mt-2 rounded-lg bg-amber-50 px-3 py-2 text-[11px] text-amber-700">Tous les étudiants ont déjà une soutenance. Ajoutez un étudiant avant de planifier.</p>
                        </c:if>
                    </div>

                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Date et heure *</label>
                        <input type="datetime-local" name="dateHeure" required value="<c:out value='${editSoutenance.dateHeureLocal}'/>"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Durée</label>
                        <select name="dureeMinutes" class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <option value="30" ${editSoutenance.dureeMinutes == 30 ? 'selected' : ''}>30 minutes</option>
                            <option value="45" ${editSoutenance.dureeMinutes == 45 ? 'selected' : ''}>45 minutes</option>
                            <option value="60" ${empty editSoutenance or editSoutenance.dureeMinutes == 60 ? 'selected' : ''}>60 minutes</option>
                            <option value="90" ${editSoutenance.dureeMinutes == 90 ? 'selected' : ''}>90 minutes</option>
                            <option value="120" ${editSoutenance.dureeMinutes == 120 ? 'selected' : ''}>120 minutes</option>
                        </select>
                    </div>
                    <div class="sm:col-span-2">
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Salle *</label>
                        <input name="salle" required value="<c:out value='${editSoutenance.salle}'/>" placeholder="Amphi A, Salle 204…"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                </div>

                <p class="mt-6 border-t border-slate-100 pt-5 text-[11px] font-semibold uppercase tracking-wide text-slate-400">Composition du jury</p>
                <div class="mt-3 grid gap-4 sm:grid-cols-2">
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Président du jury *</label>
                        <select name="president" required class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <option value="">— Sélectionner —</option>
                            <c:forEach var="ens" items="${enseignants}">
                                <option value="<c:out value='${ens.matricule}'/>" ${juryPresident == ens.matricule ? 'selected' : ''}>
                                    <c:out value="${ens.prenom}"/> <c:out value="${ens.nom}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Rapporteur</label>
                        <select name="rapporteur" class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <option value="">— Aucun —</option>
                            <c:forEach var="ens" items="${enseignants}">
                                <option value="<c:out value='${ens.matricule}'/>" ${juryRapporteur == ens.matricule ? 'selected' : ''}>
                                    <c:out value="${ens.prenom}"/> <c:out value="${ens.nom}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="sm:col-span-2">
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Examinateur</label>
                        <select name="examinateur" class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <option value="">— Aucun —</option>
                            <c:forEach var="ens" items="${enseignants}">
                                <option value="<c:out value='${ens.matricule}'/>" ${juryExaminateur == ens.matricule ? 'selected' : ''}>
                                    <c:out value="${ens.prenom}"/> <c:out value="${ens.nom}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2 border-t border-slate-100 bg-slate-50/50 px-6 py-4">
                <a href="${retour}" class="rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-xs font-medium text-slate-600 transition hover:bg-slate-50">Annuler</a>
                <button type="submit" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm transition hover:bg-accent-800">
                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                    ${empty editSoutenance ? 'Planifier la soutenance' : 'Enregistrer les modifications'}
                </button>
            </div>
        </form>
    </div>

    <aside class="space-y-4">
        <div class="rounded-2xl border border-accent-100 bg-accent-50/60 p-5">
            <p class="text-xs font-semibold text-accent-900">Règles de planification</p>
            <ul class="mt-2.5 space-y-2 text-[11px] leading-relaxed text-accent-800/80">
                <li>• Jury de 2 à 5 membres distincts, président obligatoire.</li>
                <li>• Aucun chevauchement de salle sur le même créneau.</li>
                <li>• Aucun enseignant mobilisé dans deux jurys simultanés.</li>
                <li>• Une soutenance évaluée est verrouillée.</li>
            </ul>
        </div>
        <c:if test="${not empty editSoutenance}">
            <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                <p class="text-xs font-semibold text-slate-900">Soutenance actuelle</p>
                <p class="mt-2 text-[12px] font-medium text-slate-700"><c:out value="${editSoutenance.prenomEtudiant}"/> <c:out value="${editSoutenance.nomEtudiant}"/></p>
                <p class="mt-0.5 text-[11px] text-slate-400"><c:out value="${editSoutenance.dateJour}"/> · <c:out value="${editSoutenance.heure}"/></p>
                <p class="text-[11px] text-slate-400"><c:out value="${editSoutenance.salle}"/></p>
                <a href="${ctx}/admin/soutenances/detail?id=${editSoutenance.idSoutenance}" class="mt-3 inline-flex items-center gap-1 text-[11px] font-medium text-accent-700 hover:text-accent-900">
                    Voir la fiche
                    <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                </a>
            </div>
        </c:if>
    </aside>
</div>
