"use strict";
function connexion(form) {
	let params = new URLSearchParams(new FormData(form));

	fetch('/login?' + params)
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
	let formdata = new FormData(form);
	let params = new URLSearchParams(formdata);

	fetch('/add_user?' + params.toString())
		.then(r => r.json())
		.then(data => {
			let resultat = refElem('resultat');

			data = data[0];
			if (!data.success) {
				resultat.classList.add('erreur');
				resultat.innerHTML = "Le nom d'utilisateur existe déjà.";
			} else {
				resultat.classList.remove('erreur');
				resultat.innerHTML = `Bonjour ${formdata.get("prenom")} ${formdata.get("nom")} !`;
			}
			setCookie("token", data.token);
		});

	return false;
}