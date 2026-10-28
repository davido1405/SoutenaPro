<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Filtres -->
<div class="rounded-2xl border border-slate-200/70 bg-white p-4 shadow-sm shadow-slate-200/40">
    <form method="get" action="${ctx}/admin/soutenances" class="grid gap-3 md:grid-cols-12">
        <div class="relative md:col-span-5">
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
        <div class="md:col-span-2">
            <select name="statut" class="w-full rounded-xl border border-slate-200 bg-white px-3 py-2.5 text-sm text-slate-600 outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                <option value="TOUTES" ${empty statut || statut == 'TOUTES' ? 'selected' : ''}>Tous</option>
                <option value="PLANIFIEE" ${statut == 'PLANIFIEE' ? 'selected' : ''}>Planifiées</option>
                <option value="EVALUEE" ${statut == 'EVALUEE' ? 'selected' : ''}>Évaluées</option>
                <option value="ANNULEE" ${statut == 'ANNULEE' ? 'selected' : ''}>Annulées</option>
            </select>
        </div>
        <div class="flex gap-2 md:col-span-2">
            <button type="submit" class="flex-1 rounded-xl bg-slate-900 px-3 py-2.5 text-xs font-semibold text-white transition hover:bg-slate-800">Filtrer</button>
            <a href="${ctx}/admin/soutenances" class="rounded-xl border border-slate-200 px-3 py-2.5 text-xs font-medium text-slate-500 transition hover:bg-slate-50" title="Réinitialiser">
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99"/></svg>
            </a>
        </div>
    </form>
</div>

<div class="mt-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <p class="text-xs text-slate-400"><span class="font-semibold text-slate-700"><c:out value="${liste.size()}"/></span> soutenance(s) affichée(s)</p>
    <div class="flex items-center gap-2">
        <a href="${ctx}/admin/export?type=soutenances" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:border-accent-300 hover:text-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
            Exporter
        </a>
        <a href="${ctx}/admin/soutenances/nouvelle" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15"/></svg>
            Planifier une soutenance
        </a>
    </div>
</div>

<c:if test="${empty etudiantsNonPlanifies and empty editSoutenance}">
    <div class="mt-4 flex items-start gap-3 rounded-2xl border border-sky-200 bg-sky-50 px-4 py-3 text-xs text-sky-700">
        <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z"/></svg>
        Tous les étudiants ont déjà une soutenance planifiée. Ajoutez un étudiant pour planifier un nouveau passage.
    </div>
</c:if>

<!-- Liste -->
<div class="mt-4 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <c:choose>
        <c:when test="${empty liste}">
            <div class="flex flex-col items-center justify-center px-6 py-16 text-center">
                <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                </div>
                <p class="mt-3 text-sm font-medium text-slate-600">Aucune soutenance</p>
                <p class="mt-1 text-xs text-slate-400">Ajustez les filtres ou planifiez un nouveau passage.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm">
                    <thead>
                        <tr class="border-b border-slate-100 bg-slate-50/60 text-left text-[11px] uppercase tracking-wide text-slate-400">
                            <th class="px-4 py-3 font-medium">Date &amp; heure</th>
                            <th class="px-4 py-3 font-medium">Étudiant</th>
                            <th class="px-4 py-3 font-medium">Salle</th>
                            <th class="px-4 py-3 font-medium">Jury</th>
                            <th class="px-4 py-3 font-medium">Statut</th>
                            <th class="px-4 py-3 font-medium">Note</th>
                            <th class="px-4 py-3 text-right font-medium">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <c:forEach var="s" items="${liste}">
                            <tr class="transition hover:bg-slate-50/60">
                                <td class="whitespace-nowrap px-4 py-3.5">
                                    <p class="text-[13px] font-medium text-slate-800"><c:out value="${s.dateJour}"/></p>
                                    <p class="text-[11px] text-slate-400"><c:out value="${s.heure}"/> – <c:out value="${s.fin}"/></p>
                                </td>
                                <td class="px-4 py-3.5">
                                    <div class="flex items-center gap-3">
                                        <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent-50 text-[10px] font-semibold text-accent-700"><c:out value="${s.initiales}"/></div>
                                        <div class="min-w-0 max-w-[190px]">
                                            <a href="${ctx}/admin/soutenances/detail?id=${s.idSoutenance}" class="block truncate text-[13px] font-medium text-slate-800 transition hover:text-accent-700"><c:out value="${s.prenomEtudiant}"/> <c:out value="${s.nomEtudiant}"/></a>
                                            <p class="truncate text-[11px] text-slate-400"><c:out value="${s.filiereLibelle}"/> · <c:out value="${s.niveauLibelle}"/></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-4 py-3.5">
                                    <span class="inline-flex items-center gap-1 whitespace-nowrap rounded-lg bg-slate-100 px-2 py-1 text-[11px] font-medium text-slate-600">
                                        <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 21h19.5m-18-18v18m10.5-18v18m6-13.5V21M6.75 6.75h.75m-.75 3h.75m-.75 3h.75m3-6h.75m-.75 3h.75m-.75 3h.75M6.75 21v-3.375c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21M3 3h12m-.75 4.5H21m-3.75 3.75h.008v.008h-.008v-.008Zm0 3h.008v.008h-.008v-.008Z"/></svg>
                                        <c:out value="${s.salle}"/>
                                    </span>
                                </td>
                                <td class="px-4 py-3.5">
                                    <div class="flex items-center gap-2">
                                        <div class="flex -space-x-2">
                                            <c:forEach var="m" items="${jurys[s.idSoutenance]}">
                                                <span title="<c:out value='${m.enseignantNom}'/> — <c:out value='${m.qualiteLibelle}'/>" class="flex h-7 w-7 items-center justify-center rounded-full border-2 border-white bg-slate-100 text-[9px] font-semibold text-slate-600"><c:out value="${m.initiales}"/></span>
                                            </c:forEach>
                                        </div>
                                        <span class="whitespace-nowrap text-[11px] text-slate-400"><c:out value="${s.nbNotes}"/>/<c:out value="${s.nbJury}"/> notes</span>
                                    </div>
                                </td>
                                <td class="px-4 py-3.5">
                                    <c:choose>
                                        <c:when test="${s.statut == 'EVALUEE'}">
                                            <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-2.5 py-1 text-[11px] font-medium text-emerald-700"><span class="h-1.5 w-1.5 rounded-full bg-emerald-500"></span>Évaluée</span>
                                        </c:when>
                                        <c:when test="${s.statut == 'ANNULEE'}">
                                            <span class="inline-flex items-center gap-1.5 rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-500"><span class="h-1.5 w-1.5 rounded-full bg-slate-400"></span>Annulée</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1.5 rounded-full bg-amber-50 px-2.5 py-1 text-[11px] font-medium text-amber-700"><span class="h-1.5 w-1.5 rounded-full bg-amber-500"></span>Planifiée</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-3.5">
                                    <c:choose>
                                        <c:when test="${not empty s.noteFinale}">
                                            <span class="text-[13px] font-semibold ${s.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}"><c:out value="${s.noteFinale}"/></span>
                                            <span class="text-[11px] text-slate-400">/20</span>
                                        </c:when>
                                        <c:otherwise><span class="text-[11px] text-slate-300">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-3.5">
                                    <div class="flex items-center justify-end gap-1">
                                        <a href="${ctx}/admin/soutenances/detail?id=${s.idSoutenance}" title="Voir la fiche"
                                           class="rounded-lg p-1.5 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700">
                                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/></svg>
                                        </a>
                                        <c:choose>
                                            <c:when test="${s.statut == 'EVALUEE'}">
                                                <span class="rounded-lg p-1.5 text-slate-300" title="Soutenance évaluée : modification verrouillée">
                                                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z"/></svg>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${ctx}/admin/soutenances/modifier?id=<c:out value='${s.idSoutenance}'/>" title="Modifier"
                                                   class="rounded-lg p-1.5 text-slate-400 transition hover:bg-accent-50 hover:text-accent-700">
                                                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10"/></svg>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${s.statut == 'PLANIFIEE'}">
                                            <form method="post" action="${ctx}/admin/soutenances" onsubmit="return confirm('Annuler cette soutenance ?');" class="inline">
                                                <input type="hidden" name="action" value="statut">
                                                <input type="hidden" name="statut" value="ANNULEE">
                                                <input type="hidden" name="id" value="${s.idSoutenance}">
                                                <button type="submit" title="Annuler" class="rounded-lg p-1.5 text-slate-400 transition hover:bg-amber-50 hover:text-amber-600">
                                                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 0 0 5.636 5.636m12.728 12.728A9 9 0 0 1 5.636 5.636m12.728 12.728L5.636 5.636"/></svg>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${s.statut == 'ANNULEE'}">
                                            <form method="post" action="${ctx}/admin/soutenances" class="inline">
                                                <input type="hidden" name="action" value="statut">
                                                <input type="hidden" name="statut" value="PLANIFIEE">
                                                <input type="hidden" name="id" value="${s.idSoutenance}">
                                                <button type="submit" title="Réactiver" class="rounded-lg p-1.5 text-slate-400 transition hover:bg-emerald-50 hover:text-emerald-600">
                                                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99"/></svg>
                                                </button>
                                            </form>
                                        </c:if>
                                        <form method="post" action="${ctx}/admin/soutenances" onsubmit="return confirm('Supprimer définitivement cette soutenance et ses évaluations ?');" class="inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${s.idSoutenance}">
                                            <button type="submit" title="Supprimer" class="rounded-lg p-1.5 text-slate-400 transition hover:bg-rose-50 hover:text-rose-600">
                                                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"/></svg>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>
