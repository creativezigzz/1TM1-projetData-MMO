"use strict";
/* auteur : grandjean cyril HE201803*/
/**
 * cette fonction permet de crée les requêtes vers la base de donnée
 * @author cyril grandjean
 *
 * @param {string} url: url du web-service
 * @param {fonction} fct: fonction qui traitera la reponse
 * @param {string} id: id de la page html ou les données iront se mettre
 */
function requete(url, fct, id){
    var xhr = new XMLHttpRequest();
    xhr.open('get', url, true);
    xhr.onload =
        function(){
            fct(JSON.parse(xhr.responseText), id);
        };
    xhr.send();
}
/**
 * fonction d'initialisation de la page form.html
 * @author cyril grandjean
 */
function initForm(){
    requete('/getAllAnime',titreSelect,'titre');
}
/**
 * fonction d'initialisation de la page ajoute.html
 * @author cyril grandjean
 */
function initAjout(){
    requete('/getGenrList',genreSelect,'genre');
}
/**
 * cette fonction permet de créer le select des genres dans le html.
 * @author cyril grandjean
 *
 * @param {array} obj:objet qui sera utilisé pour former le select
 * @param {string} id:id de la page html ou les données iront
 */
function titreSelect(obj,id){
    let stringHtml = "";
    for(let i of obj){
        stringHtml += `<option value="${i.id}">${i.titre}</option>`;// création des options
    }
    setElem(id,stringHtml);
}
/**
 * cette fonction permet de créer le select des genres dans le html.
 * @author cyril grandjean
 *
 * @param {array} obj:objet qui sera utilisé pour former le select
 * @param {string} id:id de la page html ou les données iront
 */
function genreSelect(obj,id){
    let stringHtml = "";
    for(let i of obj){
        stringHtml += `<option value="${i.id}">${i.genre}</option>`;// création des options
    }
    setElem(id,stringHtml);
}
/**
 * cette fonction envoie une requête pour demander si le token que la personne posséde existe dans la table.
 * @author cyril grandjean
 */
function verifLog(){
    requete(`/verifLog?token=${getCookie("token")}`,verif,"loginInfo");
}
/**
 * cette fonction permet de changer les bouton de navigation dans le html en fonction de si la personne est connecter ou non.
 * @author cyril grandjean
 *
 * @param {array} obj:objet qui sera utilisé pour former le select
 * @param {string} id:id de la page html ou les données iront
 */
function verif(obj,id){
    if(obj[0].nom){
        setElem(id,`<a class="accueil" href="/site/myAnimeList.html">${obj[0].nom}</a>
        <a href="/site/connexion.html" onclick="setCookie('token','')">Déconnexion</a>`);
    }else{
        setElem(id,`<a class="inscription" href="/site/inscription.html">Inscription</a>
        <a class="connexion" href="/site/connexion.html">Connexion</a>`);
    }
}