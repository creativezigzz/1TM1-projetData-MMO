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
	let data = new FormData(form);

	fetch('/login?pseudo=' + data.get('pseudo') + '&mdp=' + data.get('mdp'), {
		method: 'get',
		// body: 'pseudo=' + data.get('pseudo') + '&mdp=' + data.get('mdp')
	}).then(r => r.json()).then(data => {
		let resultat = refElem('resultat');

		data = data[0];
		console.log(data);
		if (data.token === null) {
			resultat.classList.add('erreur');
			resultat.innerHTML = "Nom d'utilisateur ou mot de passe incorrect.";
		} else {
			resultat.classList.remove('erreur');
			resultat.innerHTML = `Bonjour ${data.prenom} ${data.nom} !`;
		}
	});

	return false;
}