<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${ctx}/etudiant" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        Retour au tableau de bord
    </a>
    <c:if test="${not empty soutenance and soutenance.statut == 'EVALUEE'}">
        <a href="${ctx}/etudiant/resultat" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800">
            Voir mon résultat
            <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
        </a>
    </c:if>
</div>

<c:choose>
    <c:when test="${empty soutenance}">
        <div class="mt-5 rounded-2xl border border-dashed border-slate-200 bg-white px-6 py-16 text-center">
            <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
            </div>
            <p class="mt-4 text-sm font-medium text-slate-600">Aucune soutenance planifiée</p>
            <p class="mx-auto mt-1 max-w-sm text-xs leading-relaxed text-slate-400">Votre passage sera affiché ici dès que la scolarité aura fixé la date, la salle et le jury.</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="mt-5 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="h-24 bg-gradient-to-r ${soutenance.statut == 'EVALUEE' ? 'from-emerald-700 via-accent-800 to-accent-900' : (soutenance.statut == 'ANNULEE' ? 'from-slate-500 via-slate-600 to-slate-700' : 'from-accent-600 via-accent-700 to-accent-900')}"></div>
            <div class="px-6 pb-6">
                <div class="-mt-9 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                    <div class="flex items-end gap-4">
                        <div class="flex h-20 w-20 shrink-0 items-center justify-center rounded-2xl border-4 border-white bg-accent-100 text-2xl font-bold text-accent-800 shadow-sm"><c:out value="${soutenance.initiales}"/></div>
                        <div class="pb-1">
                            <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Ma soutenance</p>
                            <h2 class="mt-0.5 text-xl font-semibold tracking-tight text-slate-900"><c:out value="${soutenance.prenomEtudiant}"/> <c:out value="${soutenance.nomEtudiant}"/></h2>
                            <p class="mt-1 max-w-2xl text-[13px] leading-relaxed text-slate-500"><c:out value="${soutenance.sujet}"/></p>
                            <div class="mt-2 flex flex-wrap items-center gap-2 text-xs">
                                <span class="rounded-full bg-accent-50 px-2.5 py-1 font-medium text-accent-800"><c:out value="${soutenance.filiereLibelle}"/></span>
                                <span class="rounded-full bg-slate-100 px-2.5 py-1 font-medium text-slate-600"><c:out value="${soutenance.niveauLibelle}"/></span>
                            </div>
                        </div>
                    </div>
                    <div class="pb-1">
                        <c:choose>
                            <c:when test="${soutenance.statut == 'EVALUEE'}">
                                <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1.5 text-xs font-semibold text-emerald-700"><span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>Résultat disponible</span>
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
                            <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Date</dt>
                            <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${soutenance.dateJour}"/></dd>
                        </div>
                        <div>
                            <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Heure</dt>
                            <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${soutenance.heure}"/> – <c:out value="${soutenance.fin}"/></dd>
                        </div>
                        <div>
                            <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Salle</dt>
                            <dd class="mt-1 text-sm font-medium text-slate-800"><c:out value="${soutenance.salle}"/></dd>
                        </div>
                        <div>
                            <dt class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Encadrant</dt>
                            <dd class="mt-1 text-sm font-medium text-slate-800">
                                <c:choose>
                                    <c:when test="${not empty encadrant}"><c:out value="${encadrant.prenom}"/> <c:out value="${encadrant.nom}"/></c:when>
                                    <c:otherwise><span class="text-slate-400">Non assigné</span></c:otherwise>
                                </c:choose>
                            </dd>
                        </div>
                    </dl>
                </div>

                <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                    <h3 class="text-sm font-semibold text-slate-900">Mon jury</h3>
                    <p class="mt-0.5 text-[11px] text-slate-400">Les membres qui évalueront votre prestation</p>
                    <div class="mt-4 grid gap-2.5 sm:grid-cols-2">
                        <c:forEach var="m" items="${jury}">
                            <div class="flex items-center gap-3 rounded-xl border border-slate-100 bg-slate-50/40 px-4 py-3">
                                <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-white text-[10px] font-semibold text-slate-600 shadow-sm"><c:out value="${m.initiales}"/></span>
                                <div class="min-w-0">
                                    <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${m.enseignantNom}"/></p>
                                    <p class="text-[11px] text-slate-400"><c:out value="${m.qualiteLibelle}"/> · <c:out value="${m.specialite}"/></p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <c:if test="${soutenance.statut == 'ANNULEE'}">
                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                        <p class="text-sm font-medium text-slate-700">Soutenance annulée</p>
                        <p class="mt-1 text-[12px] leading-relaxed text-slate-500">La scolarité a annulé ce passage. Contactez-la pour connaître la nouvelle date.</p>
                    </div>
                </c:if>
            </div>

            <div class="space-y-5">
                <c:choose>
                    <c:when test="${soutenance.statut == 'EVALUEE'}">
                        <div class="rounded-2xl border border-emerald-200 bg-emerald-50/60 p-5">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-emerald-600">Résultat</p>
                            <p class="mt-2 text-3xl font-bold tracking-tight text-emerald-700"><c:out value="${soutenance.noteFinale}"/><span class="text-base font-normal opacity-60"> / 20</span></p>
                            <p class="mt-1 text-[11px] font-medium text-emerald-600">${soutenance.noteFinale >= 10 ? 'Soutenance validée' : 'Soutenance non validée'}</p>
                            <a href="${ctx}/etudiant/resultat" class="mt-3 inline-flex w-full items-center justify-center gap-1.5 rounded-xl bg-white px-3 py-2 text-xs font-medium text-emerald-800 shadow-sm transition hover:bg-emerald-100">
                                Consulter le relevé
                                <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                            </a>
                        </div>
                    </c:when>
                    <c:when test="${soutenance.statut == 'ANNULEE'}">
                        <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm shadow-slate-200/40">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Statut</p>
                            <p class="mt-2 text-lg font-semibold text-slate-600">Passage annulé</p>
                            <p class="mt-1 text-[11px] leading-relaxed text-slate-400">Aucune note ne sera publiée pour cette session.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                            <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Compte à rebours</p>
                            <c:choose>
                                <c:when test="${not empty joursRestants and joursRestants > 0}">
                                    <p class="mt-2 text-3xl font-bold tracking-tight text-slate-900"><c:out value="${joursRestants}"/> <span class="text-sm font-normal text-slate-400">jour(s)</span></p>
                                    <p class="mt-1 text-[11px] text-slate-400">avant votre soutenance</p>
                                </c:when>
                                <c:when test="${not empty joursRestants and joursRestants == 0}">
                                    <p class="mt-2 text-lg font-semibold text-accent-700">C'est aujourd'hui</p>
                                    <p class="mt-1 text-[11px] text-slate-400">Présentez-vous 15 minutes avant l'heure.</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="mt-2 text-lg font-semibold text-slate-700">Soutenance passée</p>
                                    <p class="mt-1 text-[11px] text-slate-400">Le résultat sera publié après délibération.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="rounded-2xl border border-accent-100 bg-accent-50/60 p-5">
                    <p class="text-xs font-semibold text-accent-900">Le jour J</p>
                    <ul class="mt-2.5 space-y-2 text-[11px] leading-relaxed text-accent-800/80">
                        <li>• Munissez-vous de votre carte d'étudiant et d'une pièce d'identité.</li>
                        <li>• Présentez-vous 15 minutes avant l'heure indiquée.</li>
                        <li>• Prévoyez votre support de présentation.</li>
                        <li>• La note finale est la moyenne des notes du jury.</li>
                    </ul>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>
