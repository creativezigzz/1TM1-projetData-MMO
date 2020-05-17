"use strict";

/* auteur : Walravens Mathieu HE201799 */

let resultatTimeout = null;

/**
 * Affiche un message dans l'élément #resultat.
 * @author Mathieu Walravens
 *
 * @param {string} message - Le message à afficher.
 * @param {boolean} [error=false] - S'il faut afficher le message en tant qu'erreur ou non.
 *
 */
function showMessage(message, error) {
	let resultat = refElem('resultat');

	if (error) {
		resultat.classList.add('erreur');
	} else {
		resultat.classList.remove('erreur');
	}

	resultat.innerHTML = message;

	// Si un timeout est déjà en cours, on le clear
	if (resultatTimeout !== null)
		clearTimeout(resultatTimeout);

	// On enlève le message après 3 secondes
	resultatTimeout = setTimeout(() => {
		resultatTimeout = null;
		resultat.innerHTML = "";
	}, 3000);
}

/**
 * Alias pour showMessage(message, true)
 * @author Mathieu Walravens
 *
 * @param {string} message - L'erreur à afficher.
 *
 */
function showError(message) {
	showMessage(message, true);
}

/**
 * Connecte l'utilisateur à son compte.
 * @author Mathieu Walravens
 *
 * @param {HTMLFormElement} form - Le formulaire de connexion
 *
 * @return {Boolean} false
 *
 */
function connexion(form) {
	fetch('/login?' + getParams(form))
		.then(r => r.json())
		.then(data => {
			data = data[0];
			setCookie("token", data.token);
			if (data.token === null) {
				showError("Nom d'utilisateur ou mot de passe incorrect.");
			} else {
				showMessage(`Bonjour ${data.prenom} ${data.nom} !<br>Vous allez être redirigé automatiquement.`);
				setTimeout(() => {
					window.location = '/site/myAnimeList.html';
				}, 2000);
			}
		}).catch(err => {
			showError(`Une erreur est survenue: ${err}`);
		});

	return false;
}

/**
 * Crée un nouveau compte dans la base de donnée.
 * @author Mathieu Walravens
 *
 * @param {HTMLFormElement} form - Le formulaire d'inscription
 *
 * @return {Boolean} false
 *
 */
function inscription(form) {
	fetch('/add_user?' + getParams(form))
		.then(r => r.json())
		.then(data => {
			data = data[0];
			setCookie("token", data.token);
			if (!data.success) {
				showError(data.message);
			} else {
				showMessage(`Bonjour ${form.prenom.value} ${form.nom.value} !<br>Vous allez être redirigé automatiquement.`);
				setTimeout(() => {
					window.location = '/site/myAnimeList.html';
				}, 2000);
			}
		}).catch(err => {
			showError(`Une erreur est survenue: ${err}`);
		});

	return false;
}

/**
 * Vérifie si la confirmation du mot de passe est correcte.
 * @author Mathieu Walravens
 *
 * @return {Boolean} true si les mots de passes sont identiques
 *
 */
function checkPswd() {
	let pswd = refElem('pswd');
	let pswdConfirm = refElem('pswdConfirm');

	if (pswd.value == pswdConfirm.value) {
		pswdConfirm.setCustomValidity("");
		return true;
	}

	pswdConfirm.setCustomValidity("Les mots de passes ne correspondent pas.");
	return false;
}

/**
 * Initialise la page d'accueil avec la note moyenne des animes.
 * @author Mathieu Walravens
 *
 * @return {Boolean} false
 *
 */
function initTop() {
	let table = refElem('top');

	fetch('/get_top')
		.then(r => r.json())
		.then(animes => {
			table.innerHTML = animes.map(anime =>
				`<tr>
					<td>${anime.note}</td>
					<td>${anime.titre}</td>
					<td>${anime.genre}</td>
				</tr>`
			).join('');
		}).catch(err => {
			table.parentNode.outerHTML = `<div class="erreur">Une erreur est survenue: ${err}</div>`;
		});

	return false;
}