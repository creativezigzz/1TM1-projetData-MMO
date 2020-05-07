"use strict";
/**
 * fonction d'initialisation de la page form.html
 * @author cyril grandjean
 */
function initForm(){
    xhrReqJson('/getAllAnime',titreSelect,'titre');
}
/**
 * fonction d'initialisation de la page ajoute.html
 * @author cyril grandjean
 */
function initAjout(){
    xhrReqJson('/getGenrList',genreSelect,'genre');
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
 * cette fonction cree une requette pour demander si le token que la personne posséde existe dans la table.
 * @author cyril grandjean
 */
function verifLog(){
    xhrReqJson(`/verifLog?token=${getCookie("token")}`,verif,"loginInfo");
}
/**
 * cette fonction permet de changer les bouton de navigation dans le html en fonction de si al personne est connecter ou non.
 * @author cyril grandjean
 *
 * @param {array} obj:objet qui sera utilisé pour former le select
 * @param {string} id:id de la page html ou les données iront
 */
function verif(obj,id){
    if(obj[0].nom){
        setElem(id,`<a class="accueil" href="/site/myAnimeList.html">${obj[0].nom}</a><a href="/site/connexion.html" onclick="setCookie('token','')">Déconnexion</a>`);
    }else{
        setElem(id,`<a class="inscription" href="/site/inscription.html">Inscription</a>
        <a class="connexion" href="/site/connexion.html">Connexion</a>`);
    }
}