<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="grid gap-4 sm:grid-cols-3">
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Total</p>
        <p class="mt-2 text-3xl font-semibold tracking-tight text-slate-900"><c:out value="${liste.size()}"/></p>
        <p class="mt-1 text-xs text-slate-400">soutenances dans votre jury</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">En attente</p>
        <p class="mt-2 text-3xl font-semibold tracking-tight text-amber-600"><c:out value="${enAttente}"/></p>
        <p class="mt-1 text-xs text-slate-400">notes à saisir</p>
    </div>
    <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
        <p class="text-xs font-medium uppercase tracking-wide text-slate-400">Saisies</p>
        <p class="mt-2 text-3xl font-semibold tracking-tight text-emerald-600"><c:out value="${saisies}"/></p>
        <p class="mt-1 text-xs text-slate-400">évaluations complétées</p>
    </div>
</div>

<div class="mt-5 space-y-4">
    <c:choose>
        <c:when test="${empty liste}">
            <div class="rounded-2xl border border-slate-200/70 bg-white px-6 py-16 text-center shadow-sm shadow-slate-200/40">
                <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25Z"/></svg>
                </div>
                <p class="mt-3 text-sm font-medium text-slate-600">Aucune évaluation</p>
                <p class="mt-1 text-xs text-slate-400">Vous n'êtes membre d'aucun jury pour le moment.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="ev" items="${liste}">
                <div id="eval-${ev.idEvaluation}" class="rounded-2xl border ${empty ev.note and ev.statutSoutenance != 'ANNULEE' ? 'border-amber-200/70' : 'border-slate-200/70'} bg-white p-5 shadow-sm shadow-slate-200/40">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-start">
                        <div class="flex min-w-0 flex-1 items-start gap-3">
                            <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-full ${empty ev.note ? 'bg-amber-50 text-amber-700' : 'bg-emerald-50 text-emerald-700'} text-xs font-semibold"><c:out value="${ev.initialesEtudiant}"/></div>
                            <div class="min-w-0">
                                <div class="flex flex-wrap items-center gap-2">
                                    <a href="${ctx}/enseignant/soutenances/detail?id=${ev.idSoutenance}" class="text-sm font-semibold text-slate-800 transition hover:text-accent-700"><c:out value="${ev.prenomEtudiant}"/> <c:out value="${ev.nomEtudiant}"/></a>
                                    <span class="rounded-md bg-slate-100 px-1.5 py-0.5 text-[10px] font-medium text-slate-500"><c:out value="${ev.qualiteLibelle}"/></span>
                                    <c:choose>
                                        <c:when test="${ev.statutSoutenance == 'ANNULEE'}">
                                            <span class="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2 py-0.5 text-[10px] font-medium text-slate-500"><span class="h-1 w-1 rounded-full bg-slate-400"></span>Annulée</span>
                                        </c:when>
                                        <c:when test="${empty ev.note}">
                                            <span class="inline-flex items-center gap-1 rounded-full bg-amber-50 px-2 py-0.5 text-[10px] font-medium text-amber-700"><span class="h-1 w-1 rounded-full bg-amber-500"></span>À évaluer</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-0.5 text-[10px] font-medium text-emerald-700"><span class="h-1 w-1 rounded-full bg-emerald-500"></span>Notée</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <p class="mt-1 line-clamp-2 text-xs text-slate-500"><c:out value="${ev.sujet}"/></p>
                                <p class="mt-1.5 text-[11px] text-slate-400">
                                    <c:out value="${ev.dateSoutenance}"/>
                                    <c:if test="${ev.statutSoutenance == 'ANNULEE'}"> · <span class="font-medium text-rose-500">Soutenance annulée</span></c:if>
                                </p>
                            </div>
                        </div>

                        <form method="post" action="${ctx}/enseignant/evaluations" class="flex flex-col gap-2 sm:flex-row sm:items-start lg:w-[420px]">
                            <input type="hidden" name="idEvaluation" value="${ev.idEvaluation}">
                            <div class="sm:w-28">
                                <label class="mb-1 block text-[10px] font-medium uppercase tracking-wide text-slate-400">Note / 20</label>
                                <input type="number" name="note" required min="0" max="20" step="0.25" value="${ev.note}" ${ev.statutSoutenance == 'ANNULEE' ? 'disabled' : ''}
                                       class="w-full rounded-xl border border-slate-200 px-3 py-2 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10 disabled:bg-slate-50 disabled:text-slate-400">
                            </div>
                            <div class="flex-1">
                                <label class="mb-1 block text-[10px] font-medium uppercase tracking-wide text-slate-400">Avis (optionnel)</label>
                                <input name="avis" maxlength="255" value="<c:out value='${ev.avis}'/>" placeholder="Commentaire sur la prestation" ${ev.statutSoutenance == 'ANNULEE' ? 'disabled' : ''}
                                       class="w-full rounded-xl border border-slate-200 px-3 py-2 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10 disabled:bg-slate-50">
                            </div>
                            <button type="submit" class="mt-auto rounded-xl bg-accent-700 px-3.5 py-2 text-xs font-semibold text-white transition hover:bg-accent-800 disabled:cursor-not-allowed disabled:opacity-40"
                                    ${ev.statutSoutenance == 'ANNULEE' ? 'disabled' : ''}>
                                ${empty ev.note ? 'Enregistrer' : 'Modifier'}
                            </button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
