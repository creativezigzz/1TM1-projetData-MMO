"use strict";


/**
 * fonction d'initialisation de la page form.html
 */
function initForm(){
    xhrReqJson('http://localhost/getGenrList/',genrSelect,'genre');
}
/**
 * cette fonction permet de créer le select des genres dans le html.
 *
 * @obj {array} objet qui sera utilisé pour former le select
 * @id {string} id de la page html ou les données iront
 */
function genrSelect(obj,id){
    let stringHtml = "";
    for(let i of obj){
        stringHtml += `<option value="${i.id}">${i.genre}</option>`;// création des options
    }
    setElem(id,stringHtml);
}


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