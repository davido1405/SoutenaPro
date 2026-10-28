<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="rounded-2xl border border-slate-200/70 bg-white p-4 shadow-sm shadow-slate-200/40">
    <form method="get" action="${ctx}/enseignant/soutenances" class="grid gap-3 md:grid-cols-12">
        <div class="relative md:col-span-6">
            <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3.5">
                <svg class="h-4 w-4 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"/></svg>
            </div>
            <input type="search" name="q" value="<c:out value='${q}'/>" placeholder="Étudiant, sujet, salle…"
                   class="w-full rounded-xl border border-slate-200 bg-white py-2.5 pl-10 pr-4 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
        </div>
        <div class="md:col-span-3">
            <input type="date" name="date" value="<c:out value='${date}'/>"
                   class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm text-slate-600 outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
        </div>
        <div class="flex gap-2 md:col-span-3">
            <select name="statut" class="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm text-slate-600 outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                <option value="TOUTES" ${empty statut || statut == 'TOUTES' ? 'selected' : ''}>Tous</option>
                <option value="PLANIFIEE" ${statut == 'PLANIFIEE' ? 'selected' : ''}>Planifiées</option>
                <option value="EVALUEE" ${statut == 'EVALUEE' ? 'selected' : ''}>Évaluées</option>
                <option value="ANNULEE" ${statut == 'ANNULEE' ? 'selected' : ''}>Annulées</option>
            </select>
            <button type="submit" class="rounded-xl bg-slate-900 px-4 py-2.5 text-xs font-semibold text-white transition hover:bg-slate-800">Filtrer</button>
        </div>
    </form>
</div>

<p class="mt-4 text-xs text-slate-400"><span class="font-semibold text-slate-700"><c:out value="${liste.size()}"/></span> soutenance(s)</p>

<div class="mt-3 space-y-3">
    <c:choose>
        <c:when test="${empty liste}">
            <div class="rounded-2xl border border-slate-200/70 bg-white px-6 py-16 text-center shadow-sm shadow-slate-200/40">
                <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                </div>
                <p class="mt-3 text-sm font-medium text-slate-600">Aucune soutenance trouvée</p>
                <p class="mt-1 text-xs text-slate-400">Ajustez vos filtres pour élargir la recherche.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="s" items="${liste}">
                <div class="rounded-2xl border border-slate-200/70 bg-white p-4 shadow-sm shadow-slate-200/40 transition hover:border-slate-300/70 sm:p-5">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-center">
                        <div class="flex w-full shrink-0 items-center gap-3 lg:w-44">
                            <div class="flex h-12 w-12 flex-col items-center justify-center rounded-xl bg-accent-50 text-accent-800">
                                <span class="text-[9px] font-semibold uppercase leading-none text-accent-600"><c:out value="${s.moisCourt}"/></span>
                                <span class="mt-0.5 text-[15px] font-bold leading-none"><c:out value="${s.jourNumero}"/></span>
                                <span class="mt-0.5 text-[9px] leading-none text-accent-600"><c:out value="${s.heure}"/></span>
                            </div>
                            <div>
                                <p class="text-[11px] text-slate-400">Salle</p>
                                <p class="text-sm font-semibold text-slate-800"><c:out value="${s.salle}"/></p>
                                <p class="text-[10px] text-slate-400"><c:out value="${s.heure}"/> – <c:out value="${s.fin}"/></p>
                            </div>
                        </div>

                        <div class="min-w-0 flex-1">
                            <div class="flex flex-wrap items-center gap-2">
                                <p class="text-sm font-semibold text-slate-800"><a href="${ctx}/enseignant/soutenances/detail?id=${s.idSoutenance}" class="transition hover:text-accent-700"><c:out value="${s.prenomEtudiant}"/> <c:out value="${s.nomEtudiant}"/></a></p>
                                <span class="rounded-md bg-slate-100 px-1.5 py-0.5 text-[10px] font-medium text-slate-500"><c:out value="${s.filiereLibelle}"/></span>

                                <c:if test="${s.matriculeEncadrant == sessionScope.ConnectedUser.matricule}">
                                    <span class="rounded-md bg-indigo-50 px-1.5 py-0.5 text-[10px] font-semibold text-indigo-700">Encadrant</span>
                                </c:if>
                                <c:forEach var="m" items="${jurys[s.idSoutenance]}">
                                    <c:if test="${m.matriculeEnseignant == sessionScope.ConnectedUser.matricule}">
                                        <span class="rounded-md bg-accent-50 px-1.5 py-0.5 text-[10px] font-semibold text-accent-700"><c:out value="${m.qualiteLibelle}"/></span>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <p class="mt-1 line-clamp-1 text-xs text-slate-500"><c:out value="${s.sujet}"/></p>
                            <div class="mt-2 flex items-center gap-2">
                                <div class="flex -space-x-2">
                                    <c:forEach var="m" items="${jurys[s.idSoutenance]}">
                                        <span title="<c:out value='${m.enseignantNom}'/> — <c:out value='${m.qualiteLibelle}'/>" class="flex h-6 w-6 items-center justify-center rounded-full border-2 border-white bg-slate-100 text-[8px] font-semibold text-slate-600"><c:out value="${m.initiales}"/></span>
                                    </c:forEach>
                                </div>
                                <span class="text-[10px] text-slate-400"><c:out value="${s.nbNotes}"/>/<c:out value="${s.nbJury}"/> notes</span>
                            </div>
                        </div>

                        <div class="flex shrink-0 items-center gap-3 lg:flex-col lg:items-end lg:gap-1.5">
                            <c:choose>
                                <c:when test="${s.statut == 'EVALUEE'}">
                                    <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-medium text-emerald-700"><span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>Évaluée</span>
                                    <p class="text-xs text-slate-500">Note finale : <span class="font-semibold ${s.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}"><c:out value="${s.noteFinale}"/>/20</span></p>
                                </c:when>
                                <c:when test="${s.statut == 'ANNULEE'}">
                                    <span class="inline-flex items-center gap-1.5 rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-500"><span class="h-1.5 w-1.5 rounded-full bg-slate-400"></span>Annulée</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-flex items-center gap-1.5 rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-medium text-amber-700"><span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>Planifiée</span>
                                    <a href="${ctx}/enseignant/evaluations" class="text-[11px] font-medium text-accent-700 hover:text-accent-800">Évaluer →</a>
                                </c:otherwise>
                            </c:choose>
                            <a href="${ctx}/enseignant/soutenances/detail?id=${s.idSoutenance}" class="inline-flex items-center gap-1 text-[11px] font-medium text-slate-500 transition hover:text-accent-700">
                                Détail
                                <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
