<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:choose>
    <c:when test="${empty editEtudiant}">
        <c:set var="retour" value="${ctx}/admin/etudiants"/>
    </c:when>
    <c:otherwise>
        <c:set var="retour" value="${ctx}/admin/etudiants/detail?matricule=${editEtudiant.matricule}"/>
    </c:otherwise>
</c:choose>

<div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
    <a href="${retour}"
       class="inline-flex w-fit items-center gap-1.5 text-xs font-medium text-slate-500 transition hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        ${empty editEtudiant ? 'Retour aux étudiants' : 'Retour à la fiche'}
    </a>
</div>

<div class="mt-5 grid gap-5 lg:grid-cols-3">
    <div class="lg:col-span-2">
        <form method="post" action="${ctx}/admin/etudiants" class="overflow-hidden rounded-2xl border border-slate-200/70 bg-white shadow-sm shadow-slate-200/40">
            <div class="border-b border-slate-100 px-6 py-5">
                <h2 class="text-base font-semibold text-slate-900">${empty editEtudiant ? 'Nouvel étudiant' : 'Modifier l\'étudiant'}</h2>
                <p class="mt-0.5 text-xs text-slate-400">
                    ${empty editEtudiant ? 'Le compte sera créé avec le mot de passe 123456.' : 'Le matricule et l\'identifiant de connexion ne changent pas.'}
                </p>
            </div>

            <div class="px-6 py-5">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="matriculeOriginal" value="<c:out value='${editEtudiant.matricule}'/>">

                <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Identité</p>
                <div class="mt-3 grid gap-4 sm:grid-cols-2">
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Matricule *</label>
                        <input name="matricule" required value="<c:out value='${editEtudiant.matricule}'/>" ${not empty editEtudiant ? 'readonly' : ''}
                               placeholder="ETU011"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10 ${not empty editEtudiant ? 'bg-slate-50 text-slate-500' : ''}">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Nom *</label>
                        <input name="nom" required value="<c:out value='${editEtudiant.nom}'/>" placeholder="Nkomo"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Prénom *</label>
                        <input name="prenom" required value="<c:out value='${editEtudiant.prenom}'/>" placeholder="Ariane"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Email</label>
                        <input name="email" type="email" value="<c:out value='${editEtudiant.email}'/>" placeholder="ariane.nkomo@univ.cm"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Téléphone</label>
                        <input name="telephone" value="<c:out value='${editEtudiant.telephone}'/>" placeholder="+237 6 90 00 00 00"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Adresse</label>
                        <input name="adresse" value="<c:out value='${editEtudiant.adresse}'/>" placeholder="Yaoundé"
                               class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                </div>

                <p class="mt-6 border-t border-slate-100 pt-5 text-[11px] font-semibold uppercase tracking-wide text-slate-400">Cursus et mémoire</p>
                <div class="mt-3 grid gap-4 sm:grid-cols-2">
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Filière *</label>
                        <select name="filiere" required class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <c:forEach var="f" items="${filieres}">
                                <option value="${f[0]}" ${editEtudiant.filiere == f[0] ? 'selected' : ''}><c:out value="${f[1]}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Niveau *</label>
                        <select name="niveau" required class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <c:forEach var="n" items="${niveaux}">
                                <option value="${n[0]}" ${editEtudiant.niveau == n[0] ? 'selected' : ''}><c:out value="${n[1]}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="sm:col-span-2">
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Enseignant encadrant</label>
                        <select name="matriculeEncadrant" class="w-full rounded-xl border border-slate-200 bg-white px-3.5 py-2.5 text-sm outline-none transition focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                            <option value="">— Aucun —</option>
                            <c:forEach var="ens" items="${enseignants}">
                                <option value="<c:out value='${ens.matricule}'/>" ${editEtudiant.matriculeEncadrant == ens.matricule ? 'selected' : ''}>
                                    <c:out value="${ens.prenom}"/> <c:out value="${ens.nom}"/> — <c:out value="${ens.specialiteLibelle}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="sm:col-span-2">
                        <label class="mb-1.5 block text-xs font-medium text-slate-600">Sujet du mémoire</label>
                        <textarea name="sujet" rows="3" placeholder="Intitulé du projet de fin d'études"
                                  class="w-full rounded-xl border border-slate-200 px-3.5 py-2.5 text-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10"><c:out value="${editEtudiant.sujet}"/></textarea>
                    </div>
                </div>
            </div>

            <div class="flex items-center justify-end gap-2 border-t border-slate-100 bg-slate-50/50 px-6 py-4">
                <a href="${retour}"
                   class="rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-xs font-medium text-slate-600 transition hover:bg-slate-50">Annuler</a>
                <button type="submit" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm transition hover:bg-accent-800">
                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"/></svg>
                    ${empty editEtudiant ? 'Créer l\'étudiant' : 'Enregistrer les modifications'}
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
                <li>• Un étudiant ne peut avoir qu'une seule soutenance.</li>
                <li>• L'encadrant peut être modifié à tout moment.</li>
            </ul>
        </div>
        <c:if test="${not empty editEtudiant}">
            <div class="rounded-2xl border border-slate-200/70 bg-white p-5 shadow-sm shadow-slate-200/40">
                <p class="text-xs font-semibold text-slate-900">Compte actuel</p>
                <p class="mt-2 text-[11px] text-slate-400">Identifiant</p>
                <p class="font-mono text-[12px] text-slate-700"><c:out value="${editEtudiant.login}"/></p>
                <a href="${ctx}/admin/etudiants/detail?matricule=<c:out value='${editEtudiant.matricule}'/>" class="mt-3 inline-flex items-center gap-1 text-[11px] font-medium text-accent-700 hover:text-accent-900">
                    Voir la fiche complète
                    <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                </a>
            </div>
        </c:if>
    </aside>
</div>
