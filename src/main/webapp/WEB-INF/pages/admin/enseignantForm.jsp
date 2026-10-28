<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${empty editEnseignant}">
        <c:set var="retour" value="${ctx}/admin/enseignants"/>
    </c:when>
    <c:otherwise>
        <c:set var="retour" value="${ctx}/admin/enseignants/detail?matricule=${editEnseignant.matricule}"/>
    </c:otherwise>
</c:choose>

<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${retour}" class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        ${empty editEnseignant ? 'Retour aux enseignants' : 'Retour à la fiche'}
    </a>
</div>

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="lg:col-span-2">
        <form method="post" action="${ctx}/admin/enseignants" class="overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-base font-semibold text-slate-900">${empty editEnseignant ? 'Nouvel enseignant' : 'Modifier l\'enseignant'}</h2>
                <p class="mt-0.5 text-xs text-slate-400">
                    ${empty editEnseignant ? 'Le compte sera créé avec le mot de passe 123456.' : 'Le matricule et l\'identifiant de connexion ne changent pas.'}
                </p>
            </div>

            <div class="px-6 py-5">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="matriculeOriginal" value="<c:out value='${editEnseignant.matricule}'/>">

                <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Identité</p>
                <div class="mt-3 grid gap-4 sm:grid-cols-2">
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Matricule *</label>
                        <input name="matricule" required value="<c:out value='${editEnseignant.matricule}'/>" ${not empty editEnseignant ? 'readonly' : ''}
                               placeholder="ENS007"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10 ${not empty editEnseignant ? 'bg-slate-50 text-slate-500' : ''}">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Grade</label>
                        <input name="grade" value="<c:out value='${editEnseignant.grade}'/>" placeholder="Maître de conférences"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Nom *</label>
                        <input name="nom" required value="<c:out value='${editEnseignant.nom}'/>" placeholder="Mballa"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Prénom *</label>
                        <input name="prenom" required value="<c:out value='${editEnseignant.prenom}'/>" placeholder="Serge"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Email</label>
                        <input name="email" type="email" value="<c:out value='${editEnseignant.email}'/>" placeholder="serge.mballa@univ.cm"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Téléphone</label>
                        <input name="telephone" value="<c:out value='${editEnseignant.telephone}'/>" placeholder="+237 6 99 00 00 00"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                </div>

                <p class="mt-6 border-t border-slate-100 pt-5 text-[11px] font-semibold uppercase tracking-wide text-slate-400">Affectation</p>
                <div class="mt-3 grid gap-4 sm:grid-cols-2">
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Spécialité *</label>
                        <select name="specialite" required class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <c:forEach var="s" items="${specialites}">
                                <option value="${s[0]}" ${editEnseignant.specialite == s[0] ? 'selected' : ''}><c:out value="${s[1]}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Adresse</label>
                        <input name="adresse" value="<c:out value='${editEnseignant.adresse}'/>" placeholder="Yaoundé"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2 border-t border-slate-100 bg-slate-50/50 px-6 py-4">
                <a href="${retour}" class="rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-xs font-medium text-slate-600 transition hover:bg-slate-50">Annuler</a>
                <button type="submit" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm transition hover:bg-accent-800">
                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                    ${empty editEnseignant ? 'Créer l\'enseignant' : 'Enregistrer les modifications'}
                </button>
            </div>
        </form>
    </div>

    <aside class="space-y-4">
        <div class="rounded-2xl border border-accent-100 bg-accent-50/60 p-5">
            <p class="text-xs font-semibold text-accent-900">Bon à savoir</p>
            <ul class="mt-2.5 space-y-2 text-[11px] leading-relaxed text-accent-800/80">
                <li>• L'identifiant de connexion correspond au matricule en minuscules.</li>
                <li>• Le mot de passe initial est <span class="font-mono font-semibold">123456</span>.</li>
                <li>• Un enseignant ne peut pas être dans deux jurys sur un même créneau.</li>
                <li>• La suppression est refusée s'il encadre un étudiant ou siège dans un jury.</li>
            </ul>
        </div>
        <c:if test="${not empty editEnseignant}">
            <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                <p class="text-xs font-semibold text-slate-900">Compte actuel</p>
                <p class="mt-2 text-[11px] text-slate-400">Identifiant</p>
                <p class="font-mono text-[12px] text-slate-700"><c:out value="${editEnseignant.login}"/></p>
                <p class="mt-2 text-[11px] text-slate-400">Étudiants encadrés</p>
                <p class="text-[12px] font-semibold text-slate-700"><c:out value="${editEnseignant.nbEncadres}"/></p>
                <a href="${ctx}/admin/enseignants/detail?matricule=<c:out value='${editEnseignant.matricule}'/>" class="mt-3 inline-flex items-center gap-1 text-[11px] font-medium text-accent-700 hover:text-accent-900">
                    Voir la fiche complète
                    <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                </a>
            </div>
        </c:if>
    </aside>
</div>
