"use strict";
/**
 * fonction d'initialisation de la page form.html
 */
function initForm(){
    xhrReqJson('http://localhost/getAllAnime/',titreSelect,'titre');
}
function initAjout(){
    xhrReqJson('http://localhost/getGenrList/',genreSelect,'genre');
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

function genreSelect(obj,id){
    let stringHtml = "";
    for(let i of obj){
        stringHtml += `<option value="${i.id}">${i.genre}</option>`;// création des options
    }
    setElem(id,stringHtml);
}