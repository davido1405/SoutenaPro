<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Convocation · <c:out value="${etudiant.prenom}"/> <c:out value="${etudiant.nom}"/></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', system-ui, sans-serif; }
        @page { size: A4; margin: 14mm; }
        @media print {
            .no-print { display: none !important; }
            body { background: #fff !important; }
            .sheet { box-shadow: none !important; border: none !important; margin: 0 !important; max-width: none !important; }
        }
    </style>
</head>
<body class="min-h-screen bg-slate-100 px-4 py-8 text-slate-800 antialiased">

<div class="no-print mx-auto mb-5 flex max-w-[820px] items-center justify-between">
    <a href="${ctx}/admin/soutenances/detail?id=${soutenance.idSoutenance}" class="inline-flex items-center gap-1.5 text-xs font-medium text-slate-500 hover:text-accent-700">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5 3 12m0 0 7.5-7.5M3 12h18"/></svg>
        Retour à la soutenance
    </a>
    <button type="button" onclick="window.print()" class="inline-flex items-center gap-2 rounded-xl bg-accent-700 px-4 py-2.5 text-xs font-semibold text-white shadow-sm transition hover:bg-accent-800">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0 1 10.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0 .229 2.523a1.125 1.125 0 0 1-1.12 1.227H7.231c-.662 0-1.18-.568-1.12-1.227L6.34 18m11.318 0h1.091A2.25 2.25 0 0 0 21 15.75V9.456c0-1.081-.768-2.015-1.837-2.175a48.055 48.055 0 0 0-1.913-.247M6.34 18H5.25A2.25 2.25 0 0 1 3 15.75V9.456c0-1.081.768-2.015 1.837-2.175a48.041 48.041 0 0 1 1.913-.247m10.5 0a48.536 48.536 0 0 0-10.5 0m10.5 0V3.375c0-.621-.504-1.125-1.125-1.125h-8.25c-.621 0-1.125.504-1.125 1.125v3.659M18 10.5h.008v.008H18V10.5Zm-3 0h.008v.008H15V10.5Z"/></svg>
        Imprimer la convocation
    </button>
</div>

<div class="sheet mx-auto max-w-[820px] rounded-2xl border border-slate-200 bg-white p-10 shadow-xl shadow-slate-300/30">
    <div class="flex items-start justify-between border-b border-slate-200 pb-6">
        <div class="flex items-center gap-3">
            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-accent-700 text-white">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5"/></svg>
            </div>
            <div>
                <p class="text-sm font-bold tracking-tight text-slate-900">SoutenaPro</p>
                <p class="text-[11px] text-slate-400">Plateforme de gestion des soutenances</p>
            </div>
        </div>
        <div class="text-right text-[11px] leading-relaxed text-slate-400">
            <p>Référence : <span class="font-semibold text-slate-600">SOUT-<c:out value="${soutenance.idSoutenance}"/></span></p>
            <p>Éditée le <c:out value="${soutenance.dateJour}"/></p>
        </div>
    </div>

    <div class="mt-8 text-center">
        <p class="text-[11px] font-semibold uppercase tracking-[0.2em] text-accent-700">Soutenance de fin d'études</p>
        <h1 class="mt-2 text-2xl font-bold tracking-tight text-slate-900">CONVOCATION</h1>
        <p class="mt-1 text-[12px] text-slate-400">Le candidat est prié de se présenter 15 minutes avant l'heure indiquée.</p>
    </div>

    <div class="mt-8 rounded-2xl bg-slate-50 px-6 py-5">
        <div class="grid gap-4 sm:grid-cols-2">
            <div>
                <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Candidat</p>
                <p class="mt-1 text-base font-semibold text-slate-900"><c:out value="${etudiant.prenom}"/> <c:out value="${etudiant.nom}"/></p>
                <p class="text-[12px] text-slate-500"><c:out value="${etudiant.matricule}"/> · <c:out value="${etudiant.filiereLibelle}"/> · <c:out value="${etudiant.niveauLibelle}"/></p>
            </div>
            <div class="sm:text-right">
                <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Date et heure</p>
                <p class="mt-1 text-base font-semibold text-slate-900"><c:out value="${soutenance.dateJour}"/> à <c:out value="${soutenance.heure}"/></p>
                <p class="text-[12px] text-slate-500">Durée prévue : <c:out value="${soutenance.dureeMinutes}"/> minutes</p>
            </div>
        </div>
        <div class="mt-4 border-t border-slate-200 pt-4">
            <p class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Sujet du mémoire</p>
            <p class="mt-1 text-sm leading-relaxed text-slate-700"><c:out value="${soutenance.sujet}"/></p>
        </div>
        <div class="mt-4 flex items-center gap-2 border-t border-slate-200 pt-4 text-[12px] text-slate-600">
            <svg class="h-4 w-4 text-accent-700" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z"/></svg>
            Salle : <span class="font-semibold text-slate-900"><c:out value="${soutenance.salle}"/></span>
        </div>
    </div>

    <div class="mt-8">
        <p class="text-[11px] font-semibold uppercase tracking-wide text-slate-400">Composition du jury</p>
        <table class="mt-3 w-full border-collapse text-left text-[12px]">
            <thead>
                <tr class="border-b border-slate-200 text-[10px] uppercase tracking-wide text-slate-400">
                    <th class="py-2 pr-3 font-medium">Membre</th>
                    <th class="py-2 pr-3 font-medium">Qualité</th>
                    <th class="py-2 font-medium">Spécialité</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                <c:forEach var="m" items="${jury}">
                    <tr>
                        <td class="py-2.5 pr-3 font-medium text-slate-800"><c:out value="${m.enseignantNom}"/></td>
                        <td class="py-2.5 pr-3 text-slate-500"><c:out value="${m.qualiteLibelle}"/></td>
                        <td class="py-2.5 text-slate-500"><c:out value="${m.specialite}"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="mt-10 flex items-end justify-between gap-6 border-t border-slate-200 pt-6">
        <div class="text-[10px] leading-relaxed text-slate-400">
            <p>Ce document tient lieu de convocation officielle.</p>
            <p>Merci de vous munir d'une pièce d'identité et de votre carte d'étudiant.</p>
        </div>
        <div class="text-center">
            <p class="text-[10px] text-slate-400">Le service de la scolarité</p>
            <div class="mt-8 w-40 border-t border-slate-300 pt-1 text-[9px] text-slate-300">Signature et cachet</div>
        </div>
    </div>
</div>

</body>
</html>
