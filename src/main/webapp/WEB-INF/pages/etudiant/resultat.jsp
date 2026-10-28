<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${empty soutenance}">
        <div class="rounded-2xl border border-slate-200/70 bg-white px-6 py-16 text-center shadow-sm shadow-slate-200/40">
            <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-50 text-slate-300">
                <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
            </div>
            <h2 class="mt-4 text-base font-semibold text-slate-800">Aucun résultat disponible</h2>
            <p class="mx-auto mt-1.5 max-w-md text-sm text-slate-500">Votre soutenance n'est pas encore planifiée ou n'a pas encore été évaluée par le jury.</p>
            <a href="${ctx}/etudiant" class="mt-5 inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white transition hover:bg-accent-800">Retour au tableau de bord</a>
        </div>
    </c:when>

    <c:when test="${soutenance.statut != 'EVALUEE'}">
        <div class="rounded-2xl border border-amber-200/70 bg-white px-6 py-16 text-center shadow-sm shadow-slate-200/40">
            <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-50 text-amber-500">
                <svg class="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
            </div>
            <h2 class="mt-4 text-base font-semibold text-slate-800">Résultat en attente</h2>
            <p class="mx-auto mt-1.5 max-w-md text-sm text-slate-500">
                <c:choose>
                    <c:when test="${soutenance.statut == 'ANNULEE'}">Votre soutenance a été annulée. Contactez la scolarité pour connaître la nouvelle date.</c:when>
                    <c:otherwise>Le résultat sera publié dès que tous les membres du jury auront saisi leur note.</c:otherwise>
                </c:choose>
            </p>
            <div class="mx-auto mt-5 flex max-w-sm items-center justify-center gap-3 rounded-xl bg-slate-50 px-4 py-3">
                <span class="text-xs text-slate-500">Progression du jury</span>
                <span class="rounded-lg bg-white px-2 py-1 text-xs font-semibold text-slate-700 ring-1 ring-slate-200"><c:out value="${soutenance.nbNotes}"/>/<c:out value="${soutenance.nbJury}"/></span>
            </div>
        </div>
    </c:when>

    <c:otherwise>
        <!-- Bandeau résultat -->
        <div class="overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="flex flex-col items-center gap-6 px-6 py-8 sm:flex-row sm:items-center sm:justify-between sm:px-8">
                <div class="text-center sm:text-left">
                    <p class="text-xs font-medium uppercase tracking-wider text-slate-400">Résultat de soutenance</p>
                    <h2 class="mt-2 text-xl font-semibold tracking-tight text-slate-900"><c:out value="${soutenance.prenomEtudiant}"/> <c:out value="${soutenance.nomEtudiant}"/></h2>
                    <p class="mt-1 max-w-xl text-sm text-slate-500"><c:out value="${soutenance.sujet}"/></p>
                    <p class="mt-2 text-[11px] text-slate-400">
                        <c:out value="${soutenance.filiereLibelle}"/> · <c:out value="${soutenance.niveauLibelle}"/>
                        · Soutenue le <c:out value="${soutenance.dateJour}"/> à <c:out value="${soutenance.heure}"/>
                        · Salle <c:out value="${soutenance.salle}"/>
                    </p>
                </div>
                <div class="flex shrink-0 flex-col items-center">
                    <div class="flex h-28 w-28 flex-col items-center justify-center rounded-full ${soutenance.noteFinale >= 10 ? 'bg-emerald-50 ring-8 ring-emerald-50/50' : 'bg-rose-50 ring-8 ring-rose-50/50'}">
                        <span class="text-3xl font-bold ${soutenance.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}"><c:out value="${soutenance.noteFinale}"/></span>
                        <span class="text-[10px] font-medium uppercase tracking-wide text-slate-400">/ 20</span>
                    </div>
                    <span class="mt-3 inline-flex items-center gap-1.5 rounded-full ${soutenance.noteFinale >= 10 ? 'bg-emerald-50 text-emerald-700' : 'bg-rose-50 text-rose-700'} px-3 py-1 text-[11px] font-semibold">
                        <c:choose>
                            <c:when test="${soutenance.noteFinale >= 16}">Très bien</c:when>
                            <c:when test="${soutenance.noteFinale >= 14}">Bien</c:when>
                            <c:when test="${soutenance.noteFinale >= 12}">Assez bien</c:when>
                            <c:when test="${soutenance.noteFinale >= 10}">Admis(e)</c:when>
                            <c:otherwise>Ajourné(e)</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            <div class="border-t border-slate-100 bg-slate-50/50 px-6 py-4 sm:px-8">
                <div class="flex flex-wrap items-center justify-between gap-3">
                    <p class="text-xs text-slate-500">
                        <c:choose>
                            <c:when test="${soutenance.noteFinale >= 10}">Félicitations, votre soutenance est validée. La délibération du jury est définitive.</c:when>
                            <c:otherwise>Votre soutenance n'a pas été validée. Rapprochez-vous de la scolarité pour connaître les modalités de rattrapage.</c:otherwise>
                        </c:choose>
                    </p>
                    <button type="button" onclick="window.print()" class="no-print inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-3.5 py-2 text-xs font-medium text-slate-600 transition hover:border-accent-300 hover:text-accent-800">
                        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0 1 10.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0 .229 2.523a1.125 1.125 0 0 1-1.12 1.227H7.231c-.662 0-1.18-.568-1.12-1.227L6.34 18m11.318 0h1.091A2.25 2.25 0 0 0 21 15.75V9.456c0-1.081-.768-2.015-1.837-2.175a48.055 48.055 0 0 0-1.913-.247M6.34 18H5.25A2.25 2.25 0 0 1 3 15.75V9.456c0-1.081.768-2.015 1.837-2.175a48.041 48.041 0 0 1 1.913-.247m10.5 0a48.536 48.536 0 0 0-10.5 0m10.5 0V3.375c0-.621-.504-1.125-1.125-1.125h-8.25c-.621 0-1.125.504-1.125 1.125v3.659M18 10.5h.008v.008H18V10.5Zm-3 0h.008v.008H15V10.5Z"/></svg>
                        Imprimer le relevé
                    </button>
                </div>
            </div>
        </div>

        <!-- Détail des notes -->
        <div class="mt-5 grid gap-5 lg:grid-cols-3">
            <div class="rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40 lg:col-span-2">
                <div class="border-b border-slate-100 px-5 py-4">
                    <h2 class="text-sm font-semibold text-slate-900">Notes du jury</h2>
                    <p class="text-xs text-slate-400">Détail par membre et appréciations</p>
                </div>
                <div class="divide-y divide-slate-100">
                    <c:forEach var="m" items="${jury}">
                        <div class="flex flex-col gap-3 px-5 py-4 sm:flex-row sm:items-start sm:justify-between">
                            <div class="flex items-start gap-3">
                                <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-slate-100 text-[10px] font-semibold text-slate-600"><c:out value="${m.initiales}"/></div>
                                <div>
                                    <p class="text-[13px] font-medium text-slate-800"><c:out value="${m.enseignantNom}"/></p>
                                    <p class="text-[11px] text-slate-400"><c:out value="${m.qualiteLibelle}"/><c:if test="${not empty m.specialite}"> · <c:out value="${m.specialite}"/></c:if></p>
                                    <c:if test="${not empty m.avis}">
                                        <p class="mt-1.5 max-w-md rounded-lg bg-slate-50 px-2.5 py-1.5 text-[11px] italic text-slate-500">« <c:out value="${m.avis}"/> »</p>
                                    </c:if>
                                </div>
                            </div>
                            <div class="shrink-0 sm:text-right">
                                <c:choose>
                                    <c:when test="${not empty m.note}">
                                        <span class="text-lg font-semibold ${m.note >= 10 ? 'text-emerald-600' : 'text-rose-600'}"><c:out value="${m.note}"/></span>
                                        <span class="text-[11px] text-slate-400">/20</span>
                                    </c:when>
                                    <c:otherwise><span class="text-[11px] text-slate-300">Non saisie</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="space-y-4">
                <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                    <h2 class="text-sm font-semibold text-slate-900">Synthèse</h2>
                    <dl class="mt-4 space-y-3 text-xs">
                        <div class="flex items-center justify-between">
                            <dt class="text-slate-400">Membres du jury</dt>
                            <dd class="font-medium text-slate-700"><c:out value="${jury.size()}"/></dd>
                        </div>
                        <div class="flex items-center justify-between">
                            <dt class="text-slate-400">Note finale</dt>
                            <dd class="font-semibold text-slate-900"><c:out value="${soutenance.noteFinale}"/> / 20</dd>
                        </div>
                        <div class="flex items-center justify-between">
                            <dt class="text-slate-400">Décision</dt>
                            <dd class="font-semibold ${soutenance.noteFinale >= 10 ? 'text-emerald-600' : 'text-rose-600'}">
                                ${soutenance.noteFinale >= 10 ? 'Validée' : 'Non validée'}
                            </dd>
                        </div>
                    </dl>
                </div>
                <div class="rounded-2xl border border-slate-200/70 bg-accent-50/50 p-5">
                    <p class="text-xs font-semibold text-accent-900">Besoin d'un justificatif ?</p>
                    <p class="mt-1 text-[11px] leading-relaxed text-accent-800/70">Imprimez ce relevé ou contactez la scolarité pour obtenir une attestation officielle de soutenance.</p>
                    <a href="mailto:scolarite@universite.cm" class="mt-3 inline-flex items-center gap-1.5 text-[11px] font-semibold text-accent-800 hover:text-accent-900">
                        Contacter la scolarité
                        <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                    </a>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>
