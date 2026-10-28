<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion · SoutenaPro</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'system-ui', 'sans-serif'] },
                    colors: { accent: { 50:'#f0fdfa',100:'#ccfbf1',200:'#99f6e4',300:'#5eead4',400:'#2dd4bf',500:'#14b8a6',600:'#0d9488',700:'#0f766e',800:'#115e59',900:'#134e4a' } }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', system-ui, sans-serif; }
        .grain { background-image: radial-gradient(circle at 1px 1px, rgba(255,255,255,.12) 1px, transparent 0); background-size: 22px 22px; }
    </style>
</head>
<body class="min-h-screen bg-[#F6F7F9] text-slate-800 antialiased">

<div class="min-h-screen grid lg:grid-cols-2">

    <!-- Panneau de présentation -->
    <div class="relative hidden lg:flex flex-col justify-between overflow-hidden bg-[#0b3b38] p-12 text-white">
        <div class="grain absolute inset-0 opacity-40"></div>
        <div class="absolute -top-32 -left-24 h-96 w-96 rounded-full bg-accent-500/20 blur-3xl"></div>
        <div class="absolute bottom-0 right-0 h-80 w-80 rounded-full bg-emerald-400/10 blur-3xl"></div>

        <div class="relative">
            <div class="flex items-center gap-3">
                <div class="flex h-11 w-11 items-center justify-center rounded-2xl bg-white/10 ring-1 ring-white/20 backdrop-blur">
                    <svg class="h-6 w-6 text-accent-300" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" />
                    </svg>
                </div>
                <div>
                    <p class="text-lg font-semibold tracking-tight">SoutenaPro</p>
                    <p class="text-xs text-white/50">Gestion des soutenances</p>
                </div>
            </div>

            <h1 class="mt-16 max-w-md text-4xl font-semibold leading-tight tracking-tight">
                Organisez vos soutenances<br>
                <span class="text-accent-300">avec sérénité.</span>
            </h1>
            <p class="mt-5 max-w-sm text-sm leading-relaxed text-white/60">
                Planification des passages, composition des jurys, saisie des notes et publication
                des résultats — au même endroit.
            </p>
        </div>

        <div class="relative mt-14 space-y-5">
            <div class="flex items-start gap-3">
                <div class="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-white/10 ring-1 ring-white/10">
                    <svg class="h-4 w-4 text-accent-300" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5"/></svg>
                </div>
                <div>
                    <p class="text-sm font-medium">Planning sans conflit</p>
                    <p class="text-xs text-white/50">Détection automatique des chevauchements de salle et de jury.</p>
                </div>
            </div>
            <div class="flex items-start gap-3">
                <div class="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-white/10 ring-1 ring-white/10">
                    <svg class="h-4 w-4 text-accent-300" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/></svg>
                </div>
                <div>
                    <p class="text-sm font-medium">Évaluations guidées</p>
                    <p class="text-xs text-white/50">Notes du jury centralisées, moyenne calculée automatiquement.</p>
                </div>
            </div>
            <div class="flex items-start gap-3">
                <div class="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-white/10 ring-1 ring-white/10">
                    <svg class="h-4 w-4 text-accent-300" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z"/></svg>
                </div>
                <div>
                    <p class="text-sm font-medium">Pilotage en temps réel</p>
                    <p class="text-xs text-white/50">Tableaux de bord et exports CSV pour chaque profil.</p>
                </div>
            </div>
        </div>

        <p class="relative mt-14 text-xs text-white/30">© 2026 SoutenaPro · Université — M1 Génie Logiciel</p>
    </div>

    <!-- Formulaire -->
    <div class="flex items-center justify-center px-5 py-12 sm:px-10">
        <div class="w-full max-w-md">

            <div class="mb-8 flex items-center gap-3 lg:hidden">
                <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-accent-700 text-white">
                    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" /></svg>
                </div>
                <span class="text-lg font-semibold tracking-tight">SoutenaPro</span>
            </div>

            <h2 class="text-2xl font-semibold tracking-tight text-slate-900">Bienvenue</h2>
            <p class="mt-2 text-sm text-slate-500">Connectez-vous à votre espace pour continuer.</p>

            <c:if test="${not empty erreur}">
                <div class="mt-6 flex items-start gap-3 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700">
                    <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z"/></svg>
                    <span><c:out value="${erreur}"/></span>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/login" class="mt-7 space-y-5">
                <div>
                    <label for="login" class="mb-2 block text-sm font-medium text-slate-700">Identifiant</label>
                    <div class="relative">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                            <svg class="h-4 w-4 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z"/></svg>
                        </div>
                        <input id="login" name="login" type="text" required autocomplete="username"
                               value="<c:out value='${login}'/>"
                               placeholder="admin1, ens1 ou etu1"
                               class="w-full rounded-xl border border-slate-200 bg-white py-3 pl-11 pr-4 text-sm text-slate-800 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                    </div>
                </div>

                <div>
                    <label for="motDePasse" class="mb-2 block text-sm font-medium text-slate-700">Mot de passe</label>
                    <div class="relative">
                        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                            <svg class="h-4 w-4 text-slate-400" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z"/></svg>
                        </div>
                        <input id="motDePasse" name="motDePasse" type="password" required autocomplete="current-password"
                               placeholder="••••••••"
                               class="w-full rounded-xl border border-slate-200 bg-white py-3 pl-11 pr-12 text-sm text-slate-800 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-accent-500 focus:ring-4 focus:ring-accent-500/10">
                        <button type="button" onclick="basculerMotDePasse()" aria-label="Afficher le mot de passe"
                                class="absolute inset-y-0 right-0 flex w-12 items-center justify-center text-slate-400 transition hover:text-slate-600">
                            <svg id="oeil" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z"/><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/></svg>
                        </button>
                    </div>
                </div>

                <button type="submit"
                        class="group flex w-full items-center justify-center gap-2 rounded-xl bg-accent-700 px-4 py-3 text-sm font-semibold text-white shadow-sm shadow-accent-700/20 transition hover:bg-accent-800 focus:outline-none focus:ring-4 focus:ring-accent-500/20">
                    Se connecter
                    <svg class="h-4 w-4 transition group-hover:translate-x-0.5" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"/></svg>
                </button>
            </form>

            <div class="mt-8 rounded-2xl border border-slate-200 bg-white/70 p-4">
                <p class="text-[11px] font-semibold uppercase tracking-wider text-slate-400">Comptes de démonstration</p>
                <div class="mt-3 grid gap-2 sm:grid-cols-3">
                    <button type="button" onclick="remplir('admin1','admin123')" class="rounded-xl border border-slate-200 bg-white px-3 py-2 text-left transition hover:border-accent-300 hover:bg-accent-50/50">
                        <span class="block text-xs font-medium text-slate-700">Administrateur</span>
                        <span class="block text-[11px] text-slate-400">admin1 / admin123</span>
                    </button>
                    <button type="button" onclick="remplir('ens1','ens123')" class="rounded-xl border border-slate-200 bg-white px-3 py-2 text-left transition hover:border-accent-300 hover:bg-accent-50/50">
                        <span class="block text-xs font-medium text-slate-700">Enseignant</span>
                        <span class="block text-[11px] text-slate-400">ens1 / ens123</span>
                    </button>
                    <button type="button" onclick="remplir('etu1','etu123')" class="rounded-xl border border-slate-200 bg-white px-3 py-2 text-left transition hover:border-accent-300 hover:bg-accent-50/50">
                        <span class="block text-xs font-medium text-slate-700">Étudiant</span>
                        <span class="block text-[11px] text-slate-400">etu1 / etu123</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function basculerMotDePasse() {
        const input = document.getElementById('motDePasse');
        input.type = input.type === 'password' ? 'text' : 'password';
    }
    function remplir(login, motDePasse) {
        document.getElementById('login').value = login;
        document.getElementById('motDePasse').value = motDePasse;
    }
</script>
</body>
</html>
