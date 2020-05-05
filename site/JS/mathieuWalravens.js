"use strict";
function connexion(form) {
	fetch('/login?' + getParams(form))
		.then(r => r.json())
		.then(data => {
			let resultat = refElem('resultat');

			data = data[0];
			if (data.token === null) {
				resultat.classList.add('erreur');
				resultat.innerHTML = "Nom d'utilisateur ou mot de passe incorrect.";
			} else {
				resultat.classList.remove('erreur');
				resultat.innerHTML = `Bonjour ${data.prenom} ${data.nom} !`;
			}
			setCookie("token", data.token);
		});

	return false;
}

function inscription(form) {
	fetch('/add_user?' + getParams(form))
		.then(r => r.json())
		.then(data => {
			let resultat = refElem('resultat');

			data = data[0];
			if (!data.success) {
				resultat.classList.add('erreur');
				resultat.innerHTML = data.message;
			} else {
				resultat.classList.remove('erreur');
				resultat.innerHTML = `Bonjour ${form.prenom.value} ${form.nom.value} !`;
			}
			setCookie("token", data.token);
		});

	return false;
}