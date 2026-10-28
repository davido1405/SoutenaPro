<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <form method="get" action="${ctx}/admin/enseignants" class="relative flex-1 sm:max-w-sm">
        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3.5">
            <svg class="h-4 w-4 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z"/></svg>
        </div>
        <input type="search" name="q" value="<c:out value='${q}'/>" placeholder="Rechercher un enseignant, une spécialité…"
               class="w-full rounded-xl border border-slate-200 bg-white py-2.5 pl-10 pr-4 text-sm shadow-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
    </form>
    <div class="flex items-center gap-2">
        <a href="${ctx}/admin/export?type=enseignants" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-xs font-medium text-slate-600 shadow-sm transition hover:border-accent-300 hover:text-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3"/></svg>
            Exporter
        </a>
        <a href="${ctx}/admin/enseignants/nouveau" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15"/></svg>
            Nouvel enseignant
        </a>
    </div>
</div>

<div class="mt-5 overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
    <div class="flex items-center justify-between border-b border-slate-100 px-5 py-3.5">
        <p class="text-xs text-slate-400"><span class="font-semibold text-slate-700"><c:out value="${liste.size()}"/></span> enseignant(s)</p>
        <c:if test="${not empty q}">
            <a href="${ctx}/admin/enseignants" class="inline-flex items-center gap-1 text-xs font-medium text-slate-400 hover:text-slate-700">
                Réinitialiser
                <svg class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12"/></svg>
            </a>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty liste}">
            <div class="flex flex-col items-center justify-center px-6 py-16 text-center">
                <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342"/></svg>
                </div>
                <p class="mt-3 text-sm font-medium text-slate-600">Aucun enseignant trouvé</p>
                <p class="mt-1 text-xs text-slate-400">Modifiez votre recherche ou ajoutez un enseignant.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="overflow-x-auto">
                <table class="min-w-full text-sm">
                    <thead>
                        <tr class="border-b border-slate-100 bg-slate-50/60 text-left text-[11px] uppercase tracking-wide text-slate-400">
                            <th class="px-5 py-3 font-medium">Enseignant</th>
                            <th class="px-5 py-3 font-medium">Spécialité</th>
                            <th class="px-5 py-3 font-medium">Grade</th>
                            <th class="px-5 py-3 font-medium">Encadrements</th>
                            <th class="px-5 py-3 text-right font-medium">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <c:forEach var="e" items="${liste}">
                            <tr class="transition hover:bg-slate-50/60">
                                <td class="px-5 py-3.5">
                                    <div class="flex items-center gap-3">
                                        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-indigo-50 text-[11px] font-semibold text-indigo-600">
                                            <c:out value="${e.initiales}"/>
                                        </div>
                                        <div class="min-w-0">
                                            <a href="${ctx}/admin/enseignants/detail?matricule=<c:out value='${e.matricule}'/>" class="block truncate text-[13px] font-medium text-slate-800 transition hover:text-accent-700"><c:out value="${e.prenom}"/> <c:out value="${e.nom}"/></a>
                                            <p class="text-[11px] text-slate-400"><c:out value="${e.matricule}"/> · <c:out value="${e.email}"/></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-5 py-3.5">
                                    <span class="inline-flex rounded-full bg-slate-100 px-2.5 py-1 text-[11px] font-medium text-slate-600"><c:out value="${e.specialiteLibelle}"/></span>
                                </td>
                                <td class="px-5 py-3.5 text-[13px] text-slate-600"><c:out value="${e.grade}"/></td>
                                <td class="px-5 py-3.5">
                                    <span class="text-[13px] font-semibold text-slate-800"><c:out value="${e.nbEncadres}"/></span>
                                    <span class="text-[11px] text-slate-400">étudiant(s)</span>
                                </td>
                                <td class="px-5 py-3.5">
                                    <div class="flex items-center justify-end gap-1">
                                        <a href="${ctx}/admin/enseignants/detail?matricule=<c:out value='${e.matricule}'/>" title="Voir la fiche"
                                           class="rounded-lg p-1.5 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700">
                                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/></svg>
                                        </a>
                                        <a href="${ctx}/admin/enseignants/modifier?matricule=<c:out value='${e.matricule}'/>" title="Modifier"
                                           class="rounded-lg p-1.5 text-slate-400 transition hover:bg-accent-50 hover:text-accent-700">
                                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10"/></svg>
                                        </a>
                                        <form method="post" action="${ctx}/admin/enseignants" onsubmit="return confirm('Supprimer cet enseignant ? Cette action est refusée s\'il encadre des étudiants ou participe à un jury.');" class="inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="matricule" value="<c:out value='${e.matricule}'/>">
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
