<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${empty soutenance}">
        <div class="rounded-2xl border border-slate-200/70 bg-white px-6 py-16 text-center shadow-sm shadow-slate-200/40">
            <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-accent-50 text-accent-600">
                <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
            </div>
            <h2 class="mt-4 text-base font-semibold text-slate-800">Votre soutenance n'est pas encore planifiée</h2>
            <p class="mx-auto mt-1.5 max-w-md text-sm text-slate-500">
                L'administration n'a pas encore fixé de date pour votre passage. Vous recevrez les informations dès que le planning sera publié.
            </p>
            <div class="mx-auto mt-5 max-w-sm rounded-xl border border-slate-100 bg-slate-50/70 px-4 py-3 text-left">
                <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Votre sujet</p>
                <p class="mt-1 text-xs text-slate-600"><c:out value="${sessionScope.ConnectedUser.sujet}"/></p>
            </div>
        </div>
    </c:when>

    <c:otherwise>
        <!-- Bandeau principal -->
        <div class="overflow-hidden rounded-2xl bg-gradient-to-br from-accent-700 via-accent-800 to-[#0b3b38] text-white shadow-sm shadow-accent-900/20">
            <div class="flex flex-col gap-6 p-6 sm:p-7 lg:flex-row lg:items-center lg:justify-between">
                <div class="min-w-0">
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-2.5 py-1 text-[10px] font-medium uppercase tracking-wide text-white/70 ring-1 ring-white/10">
                        <c:choose>
                            <c:when test="${soutenance.statut == 'EVALUEE'}">Soutenance évaluée</c:when>
                            <c:when test="${soutenance.statut == 'ANNULEE'}">Soutenance annulée</c:when>
                            <c:otherwise>Soutenance planifiée</c:otherwise>
                        </c:choose>
                    </span>
                    <h2 class="mt-3 text-xl font-semibold tracking-tight sm:text-2xl"><c:out value="${soutenance.sujet}"/></h2>
                    <p class="mt-2 text-sm text-white/60">
                        <c:out value="${soutenance.filiereLibelle}"/> · <c:out value="${soutenance.niveauLibelle}"/>
                    </p>
                    <div class="mt-5 flex flex-wrap gap-4">
                        <div>
                            <p class="text-[10px] uppercase tracking-wider text-white/40">Date</p>
                            <p class="mt-0.5 text-sm font-medium"><c:out value="${soutenance.dateJour}"/></p>
                        </div>
                        <div class="h-9 w-px bg-white/10"></div>
                        <div>
                            <p class="text-[10px] uppercase tracking-wider text-white/40">Heure</p>
                            <p class="mt-0.5 text-sm font-medium"><c:out value="${soutenance.heure}"/> – <c:out value="${soutenance.fin}"/></p>
                        </div>
                        <div class="h-9 w-px bg-white/10"></div>
                        <div>
                            <p class="text-[10px] uppercase tracking-wider text-white/40">Salle</p>
                            <p class="mt-0.5 text-sm font-medium"><c:out value="${soutenance.salle}"/></p>
                        </div>
                    </div>
                </div>

                <div class="flex shrink-0 items-center gap-4 rounded-2xl border border-white/10 bg-white/5 px-6 py-5 backdrop-blur">
                    <c:choose>
                        <c:when test="${soutenance.statut == 'EVALUEE'}">
                            <div class="text-center">
                                <p class="text-[10px] uppercase tracking-wider text-white/40">Note finale</p>
                                <p class="text-4xl font-bold leading-none"><c:out value="${soutenance.noteFinale}"/></p>
                                <p class="mt-1 text-[10px] text-white/40">/ 20</p>
                            </div>
                        </c:when>
                        <c:when test="${soutenance.statut == 'ANNULEE'}">
                            <div class="text-center">
                                <p class="text-3xl">🚫</p>
                                <p class="mt-1 text-xs text-white/60">Annulée</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center">
                                <p class="text-[10px] uppercase tracking-wider text-white/40">Dans</p>
                                <p class="text-4xl font-bold leading-none">
                                    <c:choose>
                                        <c:when test="${joursRestants < 0}">—</c:when>
                                        <c:otherwise><c:out value="${joursRestants}"/></c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="mt-1 text-[10px] text-white/40">jour(s)</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="mt-5 grid gap-5 lg:grid-cols-3">
            <!-- Jury -->
            <div class="rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40 lg:col-span-2">
                <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4">
                    <div>
                        <h2 class="text-sm font-semibold text-slate-900">Votre jury</h2>
                        <p class="text-xs text-slate-400">Les membres qui évalueront votre travail</p>
                    </div>
                    <span class="rounded-lg bg-slate-100 px-2 py-1 text-[10px] font-medium text-slate-500"><c:out value="${jury.size()}"/> membre(s)</span>
                </div>
                <div class="grid gap-3 p-5 sm:grid-cols-2">
                    <c:forEach var="m" items="${jury}">
                        <div class="flex items-start gap-3 rounded-xl border border-slate-100 bg-slate-50/40 p-3.5">
                            <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-white text-[10px] font-semibold text-slate-600 ring-1 ring-slate-200"><c:out value="${m.initiales}"/></div>
                            <div class="min-w-0">
                                <p class="truncate text-[13px] font-medium text-slate-800"><c:out value="${m.enseignantNom}"/></p>
                                <p class="text-[11px] text-slate-400"><c:out value="${m.qualiteLibelle}"/><c:if test="${not empty m.specialite}"> · <c:out value="${m.specialite}"/></c:if></p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Suivi -->
            <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                <h2 class="text-sm font-semibold text-slate-900">Suivi de votre dossier</h2>
                <ol class="mt-5 space-y-5">
                    <li class="relative flex gap-3">
                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-emerald-100 text-emerald-700">
                            <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2.2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                        </span>
                        <div>
                            <p class="text-xs font-medium text-slate-700">Dossier déposé</p>
                            <p class="text-[11px] text-slate-400">Sujet et encadrant enregistrés</p>
                        </div>
                    </li>
                    <li class="relative flex gap-3">
                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${soutenance.statut == 'ANNULEE' ? 'bg-slate-100 text-slate-400' : 'bg-emerald-100 text-emerald-700'}">
                            <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2.2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                        </span>
                        <div>
                            <p class="text-xs font-medium text-slate-700">Soutenance planifiée</p>
                            <p class="text-[11px] text-slate-400"><c:out value="${soutenance.dateJour}"/> à <c:out value="${soutenance.heure}"/></p>
                        </div>
                    </li>
                    <li class="relative flex gap-3">
                        <span class="flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${soutenance.statut == 'EVALUEE' ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-100 text-slate-400'}">
                            <c:choose>
                                <c:when test="${soutenance.statut == 'EVALUEE'}">
                                    <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2.2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                                </c:when>
                                <c:otherwise><span class="h-1.5 w-1.5 rounded-full bg-current"></span></c:otherwise>
                            </c:choose>
                        </span>
                        <div>
                            <p class="text-xs font-medium ${soutenance.statut == 'EVALUEE' ? 'text-slate-700' : 'text-slate-400'}">Résultat publié</p>
                            <p class="text-[11px] text-slate-400">
                                <c:choose>
                                    <c:when test="${soutenance.statut == 'EVALUEE'}">Note : <span class="font-semibold text-slate-700"><c:out value="${soutenance.noteFinale}"/>/20</span></c:when>
                                    <c:otherwise>En attente des notes du jury</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </li>
                </ol>
                <div class="mt-6 space-y-2">
                    <a href="${ctx}/etudiant/soutenance" class="flex w-full items-center justify-center gap-2 rounded-xl border border-slate-200 px-4 py-2.5 text-xs font-semibold text-slate-600 transition hover:border-accent-300 hover:text-accent-800">
                        Voir le détail de ma soutenance
                        <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                    </a>
                    <c:if test="${soutenance.statut == 'EVALUEE'}">
                        <a href="${ctx}/etudiant/resultat" class="flex w-full items-center justify-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white transition hover:bg-accent-800">
                            Voir mon résultat détaillé
                            <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Informations -->
        <div class="mt-5 grid gap-4 sm:grid-cols-3">
            <div class="rounded-2xl border border-slate-200/70 bg-white p-4 shadow-sm shadow-slate-200/40">
                <p class="text-[10px] font-medium uppercase tracking-wide text-slate-400">Matricule</p>
                <p class="mt-1.5 text-sm font-semibold text-slate-800"><c:out value="${sessionScope.ConnectedUser.matricule}"/></p>
            </div>
            <div class="rounded-2xl border border-slate-200/70 bg-white p-4 shadow-sm shadow-slate-200/40">
                <p class="text-[10px] font-medium uppercase tracking-wide text-slate-400">Filière</p>
                <p class="mt-1.5 text-sm font-semibold text-slate-800"><c:out value="${sessionScope.ConnectedUser.filiereLibelle}"/></p>
            </div>
            <div class="rounded-2xl border border-slate-200/70 bg-white p-4 shadow-sm shadow-slate-200/40">
                <p class="text-[10px] font-medium uppercase tracking-wide text-slate-400">Niveau</p>
                <p class="mt-1.5 text-sm font-semibold text-slate-800"><c:out value="${sessionScope.ConnectedUser.niveauLibelle}"/></p>
            </div>
        </div>
    </c:otherwise>
</c:choose>
