"use strict";
/**
 * fonction d'initialisation de la page form.html
 */
function initForm(){
    xhrReqJson('/getAllAnime',titreSelect,'titre');
}
function initAjout(){
    xhrReqJson('/getGenrList',genreSelect,'genre');
}
/**
 * cette fonction permet de créer le select des genres dans le html.
 *
 * @obj {array} objet qui sera utilisé pour former le select
 * @id {string} id de la page html ou les données iront
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
 *
 * @obj {array} objet qui sera utilisé pour former le select
 * @id {string} id de la page html ou les données iront
 */
function genreSelect(obj,id){
    let stringHtml = "";
    for(let i of obj){
        stringHtml += `<option value="${i.id}">${i.genre}</option>`;// création des options
    }
    setElem(id,stringHtml);
}

function verifLog(){
    xhrReqJson(`/verifLog?token=${getCookie("token")}`,verif,"loginInfo");
}
function verif(obj,id){
    if(obj[0].nom){
        setElem(id,`<a class="accueil" href="/site/myAnimeList.html">${obj[0].nom}</a><a href="/site/connexion.html" onclick="setCookie('token','')">Déconnexion</a>`);
    }else{
        setElem(id,`<a class="inscription" href="/site/inscription.html">Inscription</a>
        <a class="connexion" href="/site/connexion.html">Connexion</a>`);
    }
}